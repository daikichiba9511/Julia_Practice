using DataFrames
using CSV
using Base
using PyCall

function confirm_data_description()
    df = DataFrame(CSV.read("./input/cv-valid-train.csv"))
    @show head(df)
    # if there are Missing, it doesnt seem to work.
    # println(head(filter(row -> row[:accent] .== "us", df)))

    # so, use 'isequal' instead of '=='
    println(head(filter(:accent => isequal("us"), df)))
    println(head(filter(:accent => isequal("us"), df))[:filename])
end


function mp3_2_wav(mp3_file::String)
    pydub = pyimport("pydub")
    pwd_path = pwd()
    mp3_path = joinpath("$pwd_path/input/cv-valid-train", mp3_file)
    println("$mp3_path")
    println(typeof(mp3_path))
    audio = pydub.AudioSegment.from_mp3("$mp3_path")
    base_name, extension = splitext(basename(mp3_file))
    wav_path = joinpath("$pwd_path/input/use_data", "$base_name.wav")
    audio.export("$wav_path", format="wav")
end


function make_wav_dataset()
    df = DataFrame(CSV.read("./input/cv-valid-train.csv"))
    mp3_filename_list = filter(:accent => isequal("us"), df)[:filename]
    for mp3_filename in mp3_filename_list
        mp3_2_wav(mp3_filename)
    end
    println("== making dataset is fininshed !! ==")
end

make_wav_dataset()
# confirm_data_description()