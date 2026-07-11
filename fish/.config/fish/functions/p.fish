function p
    if test (count $argv) -eq 0
        paru
        return
    end

    paru -S $argv
end
