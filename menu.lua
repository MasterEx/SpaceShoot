-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local menu = {}
local logo;
local menuSelection;

menu.name = 'MENU'

local function play()
	state = require 'game'
	state.load()
end

local function scores()
	state = require 'score'
	state.load()
end

local menuEntries = {
	{['text'] = 'Play', ['action'] = play},
	{['text'] = 'Scores', ['action'] = scores},
	{['text'] = 'Quit', ['action'] = love.event.quit}
}

function menu.load()
	logo = love.graphics.newImage(LOGO_IMAGE)
	menuSelection = 1	
	lifeImage = love.graphics.newImage(LIFE_IMAGE)
	state = menu
end

function menu.update()
	return state
end

function menu.draw()
	love.graphics.draw(logo, 200, 10)
	for i=1,#menuEntries do
		if i == menuSelection then
			love.graphics.draw(lifeImage,  300, 200 + i * 20)
		end
		love.graphics.printf(menuEntries[i].text,0,200 + i * 20 ,love.graphics.getWidth(), 'center')
	end
end

function menu.keypressed(key)
	if key == "up" then
		menuSelection = (menuSelection - 2) % (#menuEntries) + 1
	elseif key == "down" then
		menuSelection = (menuSelection) % (#menuEntries) + 1
	elseif key == " " or key == "return" then
		menuEntries[menuSelection].action()
	elseif key == "escape" then
		love.event.quit()
	end
end

function menu.textinput(t)

end

return menu
