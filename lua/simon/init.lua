local function on_attach()
    -- TODO: TJ told me to do this and I should do it because he is Telescopic
    -- "Big Tech" "Cash Money" Johnson
end

require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach=require'completion'.on_attach }
end

require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
-- require'lspconfig'.css.setup{ on_attach=require'completion'.on_attach }
-- require'lspconfig'.html.setup{ on_attach=require'completion'.on_attach }
-- require'lspconfig'.solargraph.setup{ on_attach=require'completion'.on_attach }
-- require'lspconfig'.'html-languageserver'.setup{ on_attach=require'completion'.on_attach }

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}


