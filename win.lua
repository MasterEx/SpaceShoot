-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local win = {}
local score
local nickname = ''
local stats
local wlogo = love.graphics.newImage(WIN_IMAGE)

function win.load(s)
	nickname = ''
	score = s
	stats = require 'stats'
	stats.readEntries()
end

function win.draw()
	love.graphics.draw(wlogo, 270, 10)
	love.graphics.printf('Congratulations!',0, 250,love.graphics.getWidth(), 'center')
	love.graphics.printf('Your score is: '..score,0, 280,love.graphics.getWidth(), 'center')
	if stats.isHighscore(score) then
		love.graphics.printf('NEW HIGHSCORE!',0, 310,love.graphics.getWidth(), 'center')
		love.graphics.printf('ENTER YOUR NICKNAME:',0, 340,love.graphics.getWidth(), 'center')
		love.graphics.printf(nickname,0, 370,love.graphics.getWidth(), 'center')
	end
end

function win.keypressed(key)
	if stats.isHighscore(score) then
		if key == "backspace" then
			if #nickname > 1 then
				nickname = nickname:sub(1,#nickname-1)
			else
				nickname = ''
			end
		elseif key == 'return' and #nickname > 0 then
			stats.addScore(score,nickname)
			stats.saveScore()
			state = require 'menu'
			state.load()
		end
	elseif key == 'y' then
		state = require 'game'
		state.load()
	elseif key == 'n' then
		state = require 'menu'
		state.load()		
	end
end

function win.update()

end

function win.textinput(t)
	if #nickname < 20 then
		nickname = nickname .. t
	end
end

return win
