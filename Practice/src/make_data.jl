using DataFrames
using CSV

function confirm_data_description()
    csv = DataFrame(CSV.read("./input/cv-valid-train.csv"))
    @show head(csv[[:text, :filename]])
end

confirm_data_description()

