using DataFrames
using CSV

function confirm_data_description()
    df = DataFrame(CSV.read("./input/cv-valid-train.csv"))
    @show head(df)
    # if there are Missing, it doesnt seem to work.
    # println(head(filter(row -> row[:accent] .== "us", df)))

    # so, use 'isequal' instead of '=='
    println(head(filter(:accent => isequal("us"), df)))
end

confirm_data_description()



