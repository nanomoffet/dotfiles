local wezterm = require("wezterm")
local config = wezterm.config_builder()
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
config.color_scheme = "Tokyo Night"
config.tab_bar_at_bottom = true
config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.use_dead_keys = false
config.scrollback_lines = 5000
config.adjust_window_size_when_changing_font_size = false
config.status_update_interval = 500
config.tab_max_width = 999

-- Colors
local colors = {
	_name = "tokyonight_night",
	_style = "night",
	bg = "#1a1b26",
	bg_dark = "#16161e",
	bg_dark1 = "#0C0E14",
	bg_float = "#16161e",
	bg_highlight = "#292e42",
	bg_popup = "#16161e",
	bg_search = "#3d59a1",
	bg_sidebar = "#16161e",
	bg_statusline = "#16161e",
	bg_visual = "#283457",
	black = "#15161e",
	blue = "#7aa2f7",
	blue0 = "#3d59a1",
	blue1 = "#2ac3de",
	blue2 = "#0db9d7",
	blue5 = "#89ddff",
	blue6 = "#b4f9f8",
	blue7 = "#394b70",
	border = "#15161e",
	border_highlight = "#27a1b9",
	comment = "#565f89",
	cyan = "#7dcfff",
	dark3 = "#545c7e",
	dark5 = "#737aa2",
	diff = {
		add = "#20303b",
		change = "#1f2231",
		delete = "#37222c",
		text = "#394b70",
	},
	error = "#db4b4b",
	fg = "#c0caf5",
	fg_dark = "#a9b1d6",
	fg_float = "#c0caf5",
	fg_gutter = "#3b4261",
	fg_sidebar = "#a9b1d6",
	git = {
		add = "#449dab",
		change = "#6183bb",
		delete = "#914c54",
		ignore = "#545c7e",
	},
	green = "#9ece6a",
	green1 = "#73daca",
	green2 = "#41a6b5",
	hint = "#1abc9c",
	info = "#0db9d7",
	magenta = "#bb9af7",
	magenta2 = "#ff007c",
	none = "NONE",
	orange = "#ff9e64",
	purple = "#9d7cd8",
	rainbow = { "#7aa2f7", "#e0af68", "#9ece6a", "#1abc9c", "#bb9af7", "#9d7cd8", "#ff9e64", "#f7768e" },
	red = "#f7768e",
	red1 = "#db4b4b",
	teal = "#1abc9c",
	terminal = {
		black = "#15161e",
		black_bright = "#414868",
		blue = "#7aa2f7",
		blue_bright = "#8db0ff",
		cyan = "#7dcfff",
		cyan_bright = "#a4daff",
		green = "#9ece6a",
		green_bright = "#9fe044",
		magenta = "#bb9af7",
		magenta_bright = "#c7a9ff",
		red = "#f7768e",
		red_bright = "#ff899d",
		white = "#a9b1d6",
		white_bright = "#c0caf5",
		yellow = "#e0af68",
		yellow_bright = "#faba4a",
	},
	terminal_black = "#414868",
	todo = "#7aa2f7",
	warning = "#e0af68",
	yellow = "#e0af68",
}

-- Font
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font Mono",
	"IbmPlex",
})
config.font_size = 12.0

config.font_rules = {
	{ -- Italic
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			-- family = "Monaspace Radon", -- script style
			family = "FiraCode Nerd Font", -- courier-like
			style = "Italic",
		}),
	},

	{ -- Bold
		font = wezterm.font({
			family = "FiraCode Nerd Font", -- courier-like
			-- weight='ExtraBold',
			weight = "Bold",
		}),
	},

	{ -- Bold Italic
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "FiraCode Nerd Font", -- courier-like
			-- family = "Monaspace Radon",
			style = "Italic",
			weight = "Bold",
		}),
	},
}

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local RIGHT_ARROW = wezterm.nerdfonts.pl_left_soft_divider

-- SOLID_RIGHT_ARROW = wezterm.pad_right(SOLID_RIGHT_ARROW, 0)

function basename(s)
	return string.match(s, "([^/]+)/?$")
end
-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	-- if the tab title is explicitly set, take that
	-- Otherwise, use the title from the active pane
	-- in that tab
	local pane = tab_info.active_pane
	title = basename(pane.current_working_dir.file_path)

	if title == "206711371" then
		title = "~"
	end

	title = string.gsub(title, "slemanager", "")
	title = string.gsub(title, "-src", "")
	title = string.gsub(title, "-", "")
	return title
end

function get_max_cols(window)
	local tab = window:active_tab()
	local cols = tab:get_size().cols
	return cols
end

wezterm.on("window-config-reloaded", function(window)
	wezterm.GLOBAL.cols = get_max_cols(window)
end)

wezterm.on("window-resized", function(window, pane)
	wezterm.GLOBAL.cols = get_max_cols(window)
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	config.font = wezterm.font_with_fallback({
		"FiraCode Nerd Font Mono",
		"IbmPlex",
	})
	local width = 500
	local bar_background = colors.bg
	local tab_background = ""
	local active_tab_background = "#a4daff"
	local inactive_tab_background = "#7aa2f7"
	local text_color = ""
	local spacer = " "
	local intensity = ""

	if tab.is_active then
		tab_background = active_tab_background
		text_color = colors.black
		intensity = "Bold"
	else
		tab_background = inactive_tab_background
		text_color = colors.black
		intensity = "Half"
	end

	local title = tab_title(tab)
	local full_title = "[" .. tab.tab_index + 1 .. "] " .. title
	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width - 2)

	local pad_length = math.fmod((math.fmod(wezterm.GLOBAL.cols, #tabs) - #full_title), 2)
	if pad_length * 2 + #full_title > width then
		pad_length = (width - #full_title) / 2
	end
	spacer = string.rep(" ", pad_length)

	return {
		{ Background = { Color = bar_background } },
		{ Text = spacer },
		{ Background = { Color = tab_background } },
		{ Foreground = { Color = bar_background } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = tab_background } },
		{ Foreground = { Color = text_color } },
		{ Text = "    " },
		{ Attribute = { Intensity = intensity } },
		{ Background = { Color = tab_background } },
		{ Foreground = { Color = text_color } },
		{ Text = full_title },
		{ Background = { Color = tab_background } },
		{ Foreground = { Color = text_color } },
		{ Text = "    " },
		{ Background = { Color = bar_background } },
		{ Foreground = { Color = tab_background } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = bar_background } },
		{ Text = "" },
	}
end)

config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0cell",
}

smart_splits.apply_to_config(config)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.colors = { compose_cursor = "orange" }
config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = "m",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
}

return config
