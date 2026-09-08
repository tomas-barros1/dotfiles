function y
    if test (count $argv) -eq 0
        yay
        return
    end

    yay -S $argv
end
