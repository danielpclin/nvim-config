-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local imap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("i", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>vt", require("telescope.builtin").lsp_type_definitions, "[V]iew [T]ype Definition")
  nmap("<leader>sd", require("telescope.builtin").lsp_document_symbols, "[S]earch [D]ocument Symbols")
  nmap("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch Workspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-s>", vim.lsp.buf.signature_help, "Signature Documentation")
  imap("<C-q>", vim.lsp.buf.hover, "Hover Documentation")
  imap("<C-s>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {
    -- cmd = {
    --   "clangd", "--header-insertion=never",
    -- },
  },
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  html = {
    filetypes = { "html" },
  },
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath "config"
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        },
      })
    end,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  dockerls = {},
  docker_compose_language_service = {},
}

for server_name, config in pairs(servers) do
  -- vim.print(server_name)
  -- vim.print(config)
  config["on_attach"] = on_attach
  config["capabilities"] = capabilities
  vim.lsp.config(server_name, config or {})
  vim.lsp.enable(server_name)
end

require("mason").setup()
require("mason-lspconfig").setup {
  automatic_enable = false, -- HACK: rely on lspconfig[server_name].setup to enable the LSPs. For some reason, pyright doesn't get enabled this way
  ensure_installed = vim.tbl_keys(servers),
}
require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "isort", -- python formatter
    "black", -- python formatter
    "pylint", -- python linter
    "eslint_d", -- js linter
    "ansible-lint", --ansible linter
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- vim: ts=2 sts=2 sw=2 et
