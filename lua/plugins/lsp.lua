return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        -- LSP default capabilities
        local lsp_defaults = require('lspconfig').util.default_config
        lsp_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lsp_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

	-- Mason setup
	require('mason').setup()
	require('mason-lspconfig').setup({
	    ensure_installed = {
		"lua_ls",       -- Lua
		"intelephense", -- PHP
		"pyright",      -- Python
		"vtsls",     -- JavaScript/TypeScript
		"html",         -- HTML
		"cssls",        -- CSS
		"eslint",       -- JS/TS linting
		"rust_analyzer", -- <--- ADD THIS LINE
	    },
	    handlers = {
		-- Default handler for all servers
		function(server_name)
		    require('lspconfig')[server_name].setup({})
		end,
		-- Special handler for Lua
		lua_ls = function()
		    require('lspconfig').lua_ls.setup({
			settings = {
			    Lua = {
				runtime = { version = 'LuaJIT' },
				diagnostics = { globals = { 'vim' } },
				workspace = { library = { vim.env.VIMRUNTIME } },
			    },
			},
		    })
		end,
		-- <--- ADD THIS BLOCK START
		-- Explicitly tell Mason NOT to set up rust_analyzer via lspconfig,
		-- because rustaceanvim handles it.
		rust_analyzer = function()
		    return true
		end,
		-- <--- ADD THIS BLOCK END
	    },
	})
	-- Hover filter: remove only Base64 icons safely
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	    vim.lsp.handlers.hover,
	    {
		border = "rounded",
		focusable = false,
		contents_filter = function(contents)
		    local function filter_lines(value)
			local result = {}
			local lines = {}
			if type(value) == "string" then
			    lines = vim.split(value, "\n")
			elseif type(value) == "table" and value.value then
			    lines = vim.split(value.value, "\n")
			end
			for _, line in ipairs(lines) do
			    if not line:match("^!%[.*%]") then
				table.insert(result, line)
			    end
			end
			return table.concat(result, "\n")
		    end

              if type(contents) == "string" then
                return filter_lines(contents)
              elseif type(contents) == "table" then
                local filtered = {}
                for _, entry in ipairs(contents) do
                  if type(entry) == "string" then
                    table.insert(filtered, filter_lines(entry))
                  elseif type(entry) == "table" and entry.value then
                    table.insert(filtered, { kind = entry.kind, value = filter_lines(entry) })
                  else
                    table.insert(filtered, entry)
                  end
                end
                return filtered
              else
                return contents
              end
            end,
          }
        )

        -- Keymaps for LSP
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }
                local map = vim.keymap.set

                map('n', 'K', vim.lsp.buf.hover, opts)
                map('n', 'gd', vim.lsp.buf.definition, opts)
                map('n', 'gD', vim.lsp.buf.declaration, opts)
                map('n', 'gi', vim.lsp.buf.implementation, opts)
                map('n', 'go', vim.lsp.buf.type_definition, opts)
                map('n', 'gr', vim.lsp.buf.references, opts)
                map('n', 'gs', vim.lsp.buf.signature_help, opts)
                map('n', 'gl', vim.diagnostic.open_float, opts)
                map('n', '<F2>', vim.lsp.buf.rename, opts)
                map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                map('n', '<F4>', vim.lsp.buf.code_action, opts)
            end,
        })

        -- nvim-cmp setup
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = { documentation = cmp.config.window.bordered() },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer', keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
            snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    item.menu = n == 'nvim_lsp' and '[LSP]' or string.format('[%s]', n)
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then cmp.abort() else cmp.complete() end
                end),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    local line = vim.fn.getline('.')
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or line:sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-d>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end
                end, { 'i', 's' }),
                ['<C-b>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
                end, { 'i', 's' }),
            }),
        })
    end,
}
