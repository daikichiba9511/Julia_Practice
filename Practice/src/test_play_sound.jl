using FileIO
using LibSndFile
using Plots
using WAV

function plot_snd(load_filepath::String)
    snd, fs = wavread(load_filepath)
    display(plot(snd))
end

function main()
    data_path = "$(pwd())/data/"
    for load_file in readdir(data_path, join=true)[1:3]
        println(load_file)
        plot_snd(string(load_file))
        y, fs = wavread(load_file)
    end
end

main()