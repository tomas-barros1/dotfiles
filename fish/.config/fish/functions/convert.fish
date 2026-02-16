function convert
    set input $argv[1]
    set output (string replace -r '\.mp4$' '.mkv' $input)
    ffmpeg -i $input $output
end