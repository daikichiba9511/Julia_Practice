using FileIO
using LibSndFile

function main()
    snd = load("$(pwd())/data/sample-195774.wav")
end


# if python, 'if __name__ == "__main__"'
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

