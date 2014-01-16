-- a classic space invasion game written in love2d
-- Periklis Ntanasis <pntanasis@gmail.com> 2014

GAME_NAME = 'GAME: Space Shoot!'
GAME_ICON = 'img/icon.png'
BULLETS_IMAGE = 'img/bullets.png'
BANGS_IMAGE = 'img/bangs.png'
LIFE_IMAGE = 'img/life.png'
SHIPS = {
	GREEN = 'img/enemyshipgreen.png',
	YELLOW = 'img/enemyshipyellow.png',
	BLUE = 'img/enemyshipblue.png'
}
SHIP_IMAGE = 'img/spaceship.png'
WIN_IMAGE = 'img/win.png'
LOGO_IMAGE = 'img/logo.png'

function love.load()
	love.window.setTitle(GAME_NAME)
	love.window.setIcon(love.image.newImageData(GAME_ICON))	
	state = require "menu"
	state.load()
end

function love.draw()
	state.draw()
end

function love.keypressed(key, isrepeat)
	state.keypressed(key)
end

function love.textinput(t)
	state.textinput(t)
end

function love.update(dt)
	state.update(dt)
end
