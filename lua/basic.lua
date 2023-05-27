-- uft-8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = 'utf-8'

-- jk移动式光标上下保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- 相对行号
vim.wo.number = true
vim.wo.relativenumber = true

-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"
-- 右侧参考线，超过表示代码太长了，考虑换行
-- vim.wo.colorcolumn = "80"

-- 鼠标支持
vim.o.mouse = "a"

-- 缩进
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- 样式
vim.o.background = "dark"
vim.o.termguicolors = true
vim.opt.termguicolors = true



-- 保存本地变量
local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true }

-- 之后就可以这样映射按键了
-- map('模式','按键','映射为XX',opt)
--

-- visual模式下可以连续>缩进代码
map('v', '<', '<gv', opt)
map('v', '>', '>gv', opt)

-- fcitx && fcitx5自动切换
local fcitx_cmd = ''
if vim.fn.executable('fcitx-remote') == 1 then
    fcitx_cmd = 'fcitx-remote'
elseif vim.fn.executable('fcitx5-remote') == 1 then
    fcitx_cmd = 'fcitx5-remote'
else
    return
end

if os.getenv('SSH_TTY') ~= nil then
    return
end

local os_name = vim.loop.os_uname().sysname
if (os_name == 'Linux' or os_name == 'Unix') and os.getenv('DISPLAY') == nil and os.getenv('WAYLAND_DISPLAY') == nil then
    return
end

function _Fcitx2en()
    local input_status = tonumber(vim.fn.system(fcitx_cmd))
    if input_status == 2 then
    -- input_toggle_flag means whether to restore the state of fcitx
        vim.b.input_toggle_flag = true
    -- switch to English input
        vim.fn.system(fcitx_cmd .. ' -c')
    end
end

function _Fcitx2NonLatin()
    if vim.b.input_toggle_flag == nil then
        vim.b.input_toggle_flag = false
    elseif vim.b.input_toggle_flag == true then
        -- switch to Non-Latin input
        vim.fn.system(fcitx_cmd .. ' -o')
        vim.b.input_toggle_flag = false
    end
end

vim.cmd[[
    augroup fcitx
        au InsertEnter * :lua _Fcitx2NonLatin()
        au InsertLeave * :lua _Fcitx2en()
        au CmdlineEnter [/\?] :lua _Fcitx2NonLatin()
        au CmdlineLeave [/\?] :lua _Fcitx2en()
    augroup END
]]
