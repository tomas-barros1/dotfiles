function fastconvert
    set input $argv[1]
    set output (string replace -r '\.[^.]+$' '.mkv' $input)
    ffmpeg -i $input -c copy $output
end