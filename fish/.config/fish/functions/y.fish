function y
    yay -S $argv
end

function y
    if test (count $argv) -eq 0
        yay
        return
    end

    yay -S $argv
end
