using DataFrames
using CSV


csv = DataFrame(CSV.read("Practice/input/cv-valid-train.csv"))
head(csv[[:text, :filename]])


