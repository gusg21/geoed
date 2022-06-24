-- Basic skinning example.

local white = "#ffffff"
local black = "#000000"
local black_trans = "#00000055"
local orange = "#ffcc00"
local green = "#00cc00"
local dark_green = "#003300"

local colorTable = {
	['text'] = white,
	['window'] = black_trans,
	['header'] = dark_green,
	['border'] = green,
	['button'] = dark_green,
	['button hover'] = green,
	['button active'] = orange,
	['toggle'] = '#646464',
	['toggle hover'] = green,
	['toggle cursor'] = orange,
	['select'] = '#2d2d2d',
	['select active'] = '#232323',
	['slider'] = '#262626',
	['slider cursor'] = '#646464',
	['slider cursor hover'] = '#787878',
	['slider cursor active'] = green,
	['property'] = '#262626',
	['edit'] = '#262626',
	['edit cursor'] = '#afafaf',
	['combo'] = dark_green,
	['chart'] = '#787878',
	['chart color'] = '#2d2d2d',
	['chart color highlight'] = green,
	['scrollbar'] = '#282828',
	['scrollbar cursor'] = '#646464',
	['scrollbar cursor hover'] = '#787878',
	['scrollbar cursor active'] = '#969696',
	['tab header'] = '#282828'
}

local styleTable = {
	['button'] = {
		['rounding'] = 0
	},
	['window'] = {
		['scaler'] = green
	}
}

return function (ui)
	ui:styleLoadColors(colorTable)
	ui:stylePush(styleTable)
end