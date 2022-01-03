using FileIO
using LibSndFile
using Plots
using WAV
using DSP
using MFCC

function plot_snd(load_filepath::String)
    snd, fs, _, _= wavread(load_filepath)
    println(typeof(snd), size(snd)) plt = plot(snd, title="signal plot of $(basename(load_filepath))")
    display(plt)
    savefig("wave.png")
end

function main()
    data_path = "$(pwd())/data/"
    for load_file in readdir(data_path, join=true)[3:4]
        println(load_file)
        plot_snd(string(load_file))
    end
end

main()
