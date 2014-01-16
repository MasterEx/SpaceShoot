-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local game_over = {}
local score
local nickname = ''
local stats

function game_over.load(s)
	nickname = ''
	score = s
	stats = require 'stats'
	stats.readEntries()
end

function game_over.draw()
	love.graphics.printf('GAME OVER', 0, 50, love.graphics.getWidth(), 'center')
	love.graphics.printf('YOUR SCORE IS '..score, 0, 80, love.graphics.getWidth(), 'center')
	if stats.isHighscore(score) then
		love.graphics.printf('NEW HIGHSCORE!',0, 130,love.graphics.getWidth(), 'center')
		love.graphics.printf('ENTER YOUR NICKNAME:',0, 180,love.graphics.getWidth(), 'center')
		love.graphics.printf(nickname,0, 210,love.graphics.getWidth(), 'center')
	else			
		love.graphics.printf('PLAY AGAIN? (y/n)', 0, 110, love.graphics.getWidth(), 'center')
	end
end

function game_over.keypressed(key)
	if stats.isHighscore(score) then
		if key == "backspace" then
			if #nickname > 1 then
				nickname = nickname:sub(1,#nickname-1)
			else
				nickname = ''
			end
		elseif key == 'return' and #nickname > 0 then
			-- save score with nickname			
			stats.addScore(score,nickname)
			stats.saveScore()
			status = require 'menu'
			status.load()
			
		end
	elseif key == 'y' then
		state = require 'game'
		state.load()
	elseif key == 'n' then
		state = require 'menu'
		state.load()
	elseif key == 'escape' then
		--screen = SCREENS.MENU
		state = require 'menu'
		state.load()
	end
end

function game_over.update()

end

function game_over.textinput(t)
	if #nickname < 20 then
		nickname = nickname .. t
	end
end

return game_over
