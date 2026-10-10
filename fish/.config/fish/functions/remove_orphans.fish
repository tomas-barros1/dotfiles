function remove_orphans --wraps='set orphans (pacman -Qtdq); and test (count $orphans) -gt 0; and sudo pacman -Rns $orphans' --description 'alias remove_orphans set orphans (pacman -Qtdq); and test (count $orphans) -gt 0; and sudo pacman -Rns $orphans'
    set orphans (pacman -Qtdq); and test (count $orphans) -gt 0; and sudo pacman -Rns $orphans $argv
end
