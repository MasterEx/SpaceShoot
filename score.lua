-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local score = {}
local stats

function score.load()
	state = score
	stats = require 'stats'
	stats.readEntries()
end

function score.draw()
	love.graphics.printf('HALL OF FAME', 0, 50, love.graphics.getWidth(), 'center')
	love.graphics.printf('SCORE', 0, 90, love.graphics.getWidth()/3, 'right')
	love.graphics.printf('NICKNAME', love.graphics.getWidth()/3 - 15, 90, love.graphics.getWidth()/3-20, 'center')
	love.graphics.printf('DATE', love.graphics.getWidth()/3*2, 90, love.graphics.getWidth()/3, 'left')
	local sc = stats.getScoreEntries()
	local y = 90
	for i=1,#sc do
		y = y + 20
		love.graphics.printf(sc[i].score, 0, y, love.graphics.getWidth()/3, 'right')
		love.graphics.printf(sc[i].nickname, love.graphics.getWidth()/3 - 15, y, love.graphics.getWidth()/3-20, 'center')
		love.graphics.printf(sc[i].date, love.graphics.getWidth()/3*2, y, love.graphics.getWidth()/3, 'left')
	end
end

function score.update()

end

function score.keypressed(key)
	if key == 'escape' or key == 'return' or key == ' ' then
		--screen = SCREENS.MENU
		state = require 'menu'
		state.load()
	end
end

function score.textinput(t)

end

return score
