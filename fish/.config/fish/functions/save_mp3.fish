function save_mp3 --wraps='yt-dlp --embed-thumbnail -t mp3' --description 'alias save_mp3=yt-dlp --embed-thumbnail -t mp3'
    yt-dlp --embed-thumbnail -t mp3 $argv
end