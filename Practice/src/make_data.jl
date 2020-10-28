using DataFrames
using CSV
using Base
using PyCall

""" confirm data description of donwloaded data in input directory.
I wanna use 'us' accent data, so filter the value of accent cols , whether it is equal to "us" or not.
"""
function confirm_data_description()
    df = DataFrame(CSV.read("./input/cv-valid-train.csv"))
    @show head(df)
    # if there are Missing, it doesnt seem to work.
    # println(head(filter(row -> row[:accent] .== "us", df)))

    # so, use 'isequal' instead of '=='
    println(head(filter(:accent => isequal("us"), df)))
    println(head(filter(:accent => isequal("us"), df))[:filename])
end


"""there are MP3.jl to load mp3 file, It seems that MP3.jl is not available julia 1.x, but On topic brach, Not official code is avaliable.
so, I decided to use python package "pydub" through julia. but installation of this package should be done with pyaudio

this function is accept a file_path, and then load mp3 file,
secondly file name and extension are splited,
finally the pulses loaded from mp3 is saved by filename is added "wav" as extension
"""
function mp3_2_wav(mp3_file::String)
    pydub = pyimport("pydub")
    pwd_path = pwd()
    mp3_path = joinpath("$pwd_path/input/cv-valid-train", mp3_file)
    println("$mp3_path")
    println(typeof(mp3_path))
    audio = pydub.AudioSegment.from_mp3("$mp3_path")
    base_name, extension = splitext(basename(mp3_file))
    wav_path = joinpath("$pwd_path/data", "$base_name.wav")
    audio.export("$wav_path", format="wav")
end

"""for make data set function
"""
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