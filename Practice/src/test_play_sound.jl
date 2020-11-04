using FileIO
using LibSndFile
using Plots
using WAV
using DSP
using MFCC

# for vscode
gr()

function plot_snd(load_filepath::String)
    snd, fs = wavread(load_filepath)
    plot(
        0:1/fs:(length(snd)-1)/fs,
        snd,
        xaxis="Time [s]",
        title="signal plot of $(basename(load_filepath))"
    )
end

function main()
    data_path = "$(pwd())/data/"
    for load_file in readdir(data_path, join=true)[1:2]
        println(load_file)
        plot_snd(string(load_file))
        y, fs, nbits, chunk = wavread(load_file)
        y16 = reshape(convert.(Float16, y), (length(y),))
        println(nbits, typeof(y16))
        # println(typeof(y))
        # mfcc(y, fs)
        data = spectrogram(y16)
        heatmap(
            time(data),
            freq(data),
            power(data),
            title="spectrogram plot of $(basename(load_file))",
            margin=10
        )
    end
end

main()