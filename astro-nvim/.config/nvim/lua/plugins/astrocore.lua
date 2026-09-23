return {
  "AstroNvim/astrocore",
  opts = {
    options = {
      opt = {
        updatetime = 100, -- responde mais rápido a CursorHold/gitsigns (default: 300)
        timeoutlen = 400, -- menos atraso em seqüências com leader (default: 500)
        redrawtime = 500, -- aborta redraw de highlight caros (default: 2000)
        signcolumn = "number", -- economiza uma coluna e reduz redraw vs "yes"
        diffopt = "internal,filler,closeoff", -- remove "algorithm:histogram" que é caro
      },
    },
  },
}

