local Normal = {
  {
    "<leader>r",
    children = {
      {
        "r",
        ":%s//g<Left><Left>",
        desc = "Replace regex",
      },
      {
        "n",
        ":set relativenumber!<cr>",
        desc = "Toggle relative line numbers"
      }
    }
  },
  {
    "<leader>b",
    children = {
      { -- close buffer
        "c",
        ":bp|bd#<cr>",
        desc = "Close buffer"
      },
      { -- next buffer
        "n",
        function() vim.api.nvim_command("normal ]b") end,
        desc = "Next buffer"
      },
      {      -- prev buffer
        "b", -- (back)
        function() vim.api.nvim_command("normal [b") end,
        desc = "Previous buffer"
      }
    }
  }
}

local modeMap = {
  {
    "n",
    Normal
  }
}



function HandleMap(mode, map)
  for _, m in ipairs(map) do
    local firstArg = m[1]
    if m.children then
      -- prepend first arg to child first arg
      for _, child in ipairs(m.children) do
        child[1] = firstArg .. child[1]
      end
      HandleMap(mode, m.children)
    else
      local opts = {}
      if m.desc then
        opts.noremap = true
        opts.desc = m.desc
      end
      vim.keymap.set(
        mode,
        firstArg,
        m[2],
        opts
      )
    end
  end
end

function HandleModes(modes)
  for _, mode in ipairs(modes) do
    local modeChar = mode[1]
    local modeMaps = mode[2]
    HandleMap(modeChar, modeMaps)
  end
end

HandleModes(modeMap)
