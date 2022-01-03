using Random, Distributions

mutable struct EarlyStop
    best::Float64
    count::Int8
    early_stopping::Int8
end

function is_early_stopping!(condition::EarlyStop, value::Float64)
    """ calculate the likelihood, if the count is upper than threshold, stop training
    """
    if condition.best < value
        condition.best = value
        condition.count += 1
        if condition.count > condition.early_stopping
            return false
        end
    end
    return true
end

function gauss(x_t, mu, sigma, pi_z)
    return 1 / ((2pi * sigma) ^ (1 / 2)) * (-1 * ((x_t - mu) ^ 2) / 2*(sigma ^ 2))
end

function em_algorithm(K, x_t, x_valid, T, early_stopping)
    bar_mu = 1/T * sum(x_t)
    println(bar_mu)
    bar_sigma = 1/T * sum((x_t .- bar_mu).^2)

    # make initial params state
    mu = zeros(K)
    sigma = zeros(K)
    pi_z = 1/K
    for z in 1:K
        r = rand(Normal(bar_mu, bar_sigma))
        mu[z] = r
        sigma[z] = bar_sigma
    end


    condition = EarlyStop(-999.0, 0, early_stopping)
    likelihood = 0.0
    while is_early_stopping!(condition, likelihood)
        # init sufficient statistic
        n = zeros(K)
        m = zeros(K)
        s = zeros(K)
        q_t = zeros(K)
        # cumsum of sufficient statistic
        for t in 1:T
            Z = 0
            for z in 1:K
                q_t[z] = pi_z[z] * rand(MvNormal(mu, sigma), size(x_t))
                Z = Z + q_t[z]
            end
            for z in 1:K
                q_t[z] = q_t[z] / Z
                n[z] = n[z] + q_t[z]
                m[z] = m[z] + q_t[z]*x_t
                x[z] = s[z] + q_t[z]*(x_t)^2
            end
        end
        # update parameters
        for z in 1:K
            mu[z] = m[z] / n[z]
            sigma[z] = s[z] / n[z]
            pi_z[z] = n[z] / T
        end
        likelihood = sum(log(gauss(x_valid, mu, sigma, pi_z)))
    end
    return mu, sigma, pi_z
end

function main()
    println("Start Exp")
    K = 20
    T = 20
    early_stopping = 2
    x_t = rand(K)
    x_valid = rand(10)
    println(x_t)

    mu, sigma, pi_z = em_algorithm(K, x_t, x_valid, T, early_stopping)
end

main()
