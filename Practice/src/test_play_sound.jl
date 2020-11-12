using FileIO
using LibSndFile
using Plots
using WAV
using DSP
using MFCC

# for vscode
# plotly()
# popdisplay()
gr()


function plot_snd(load_filepath::String)
    snd, fs, _, _= wavread(load_filepath)
    println(typeof(snd), size(snd))
    plt = plot(snd, title="signal plot of $(basename(load_filepath))")
    display(plt)
end

function plot_spectrogram(y16::Array{Float16, 1}, load_file::AbstractString)
    data = spectrogram(y16)
    hmp = heatmap(
        time(data),
        freq(data),
        log.(power(data)),
        title="spectrogram plot of $(basename(load_file))",
    )
    display(hmp)
end

function plot_mfcc(y16::Array{Float16, 1}, fs::Float32)
    # calc mfcc
    mfcc_fe = mfcc(y16, fs)
    println(typeof(mfcc_fe[1]), size(mfcc_fe[1]))
    mfcc_plot = plot(mfcc_fe[1])
    println("paramters be used to calc features : \n $(mfcc_fe[3])")
    display(mfcc_plot)
end

function main()
    data_path = "$(pwd())/data/"
    for load_file in readdir(data_path, join=true)[3:4]
        println(load_file)
        plot_snd(string(load_file))
        # wavplay(load_file)

        y, fs, nbits, chunk = wavread(load_file)
        y16 = reshape(convert.(Float16, y), (length(y),))
        plot_spectrogram(y16, load_file)

        plot_mfcc(y16, fs)
    end
end

main()