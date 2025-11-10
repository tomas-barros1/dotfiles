local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"
local lspconfig = require "plugins.lsp.config"
local lspkind = require 'plugins.lspkind'
local nerdfonts_symbols = require "libraries.font_symbols_nerdfont_mono_regular"

lspkind.setup {
    symbols = {
        Text = nerdfonts_symbols.utf8["cod-symbol_string"],
        Method = nerdfonts_symbols.utf8["cod-symbol_method"],
        Function = nerdfonts_symbols.utf8["md-function"],
        Constructor = nerdfonts_symbols.utf8["cod-symbol_method"],
        Field = nerdfonts_symbols.utf8["cod-symbol_field"],
        Variable = nerdfonts_symbols.utf8["cod-symbol_variable"],
        Class = nerdfonts_symbols.utf8["cod-symbol_class"],
        Interface = nerdfonts_symbols.utf8["cod-symbol_interface"],
        Module = nerdfonts_symbols.utf8["md-view_module"],
        Property = nerdfonts_symbols.utf8["cod-symbol_property"],
        Unit = nerdfonts_symbols.utf8["cod-symbol_misc"],
        Value = nerdfonts_symbols.utf8["cod-symbol_misc"],
        Enum = nerdfonts_symbols.utf8["cod-symbol_enum"],
        Keyword = nerdfonts_symbols.utf8["cod-symbol_keyword"],
        Snippet = nerdfonts_symbols.utf8["cod-symbol_snippet"],
        Color = nerdfonts_symbols.utf8["cod-symbol_color"],
        File = nerdfonts_symbols.utf8["cod-symbol_file"],
        Reference = nerdfonts_symbols.utf8["oct-cross_reference"],
        Folder = nerdfonts_symbols.utf8["oct-folder"],
        EnumMember = nerdfonts_symbols.utf8["cod-symbol_enum_member"],
        Constant = nerdfonts_symbols.utf8["cod-symbol_constant"],
        Struct = nerdfonts_symbols.utf8["cod-symbol_structure"],
        Event = nerdfonts_symbols.utf8["cod-symbol_event"],
        Operator = nerdfonts_symbols.utf8["cod-symbol_operator"],
        TypeParameter = nerdfonts_symbols.utf8["cod-symbol_parameter"],
        Unknown = nerdfonts_symbols.utf8["cod-symbol_misc"]
    },
    format = 'symbol',
    size = 14 * SCALE, 
    font_raw = renderer.font.load(nerdfonts_symbols.path, 14 * SCALE)
}

lspconfig.solargraph.setup {}

-- lspconfig.html.setup {
--   file_patterns = { "%.html$", "%.erb$" },
-- }

config.plugins.lsp_emmet.file_patterns = {
  "%.jsx$", "%.tsx$", "%.html?$", "%.xml$", "%.scss$", "%.css$", "%.astro$", "%.erb$"
}


