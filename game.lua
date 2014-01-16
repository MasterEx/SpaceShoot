-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local game = {}
local spaceship = {}
local enemyship = {}
local bullets = {}
local spaceshipBulletsShot = {}
local enemyBulletsShot = {}
local enemies = {{},{},{},{},{},{},{},{},{},{}}
local bangs = {}
local ready = 0
local lives = 3
local score = 0
local level = 1
local directionRight= true
local nickname = ''
local lifeImage;
local bangsi = {}
local enemiesNumber = 0
local escPressed
local pause

local function gameOver()
	state = require 'game_over'
	state.load(score)
end
local function gameWin()
	state = require 'win'
	state.load(score)
end

local function clearTable(t)
	for i=#t,1,-1 do
		table.remove(t,i)
	end
end

local function clearEnemies()
	for i=#enemies,1,-1 do
		for j=#enemies[i],1,-1 do
			table.remove(enemies[i], j)
		end
	end
end

local function setEnemies()
	enemiesNumber = 0
	for i=1,4 do
		for j=1,10 do
			local enemy = {}
			enemy.x = (j-1) * enemyship.width + 10
			enemy.y = (i-1) * enemyship.height + 35
			if level == 3 then
				enemy.health = 3
			end
			table.insert(enemies[j],enemy)
			enemiesNumber = enemiesNumber + 1
		end
	end
end

local function setGame()
	ready = 3
	clearTable(spaceshipBulletsShot)
	clearTable(enemyBulletsShot)
	clearTable(bangs)
	clearEnemies()
	setEnemies()
	spaceship.x = love.graphics.getWidth() / 2 - spaceship.width / 2
end

local function printReadyMessage()
	love.graphics.printf('GAME STARTS IN',0,love.graphics.getHeight()/2 ,love.graphics.getWidth(), 'center')
	love.graphics.printf(math.ceil(ready),0,love.graphics.getHeight()/2 + 40,love.graphics.getWidth(), 'center')
end

local function drawExitQuestion()
	love.graphics.printf('DO YOU WANT TO EXIT TO MENU? (y/n)',0, 0,love.graphics.getWidth(), 'center')
end

local function spaceshipShoot()
	local bullet = {}
	spaceship.lastShot = 0
	bullet.x = spaceship.x + 32
	bullet.y = spaceship.y + 10
	table.insert(spaceshipBulletsShot, bullet)
end

local function enemyShoot(x,y)
	local bullet = {}
	enemyship.lastShot = 0
	bullet.x = x + enemyship.width/2
	bullet.y = y - 5
	table.insert(enemyBulletsShot, bullet)
end

local function moveEnemiesDown(y)
	for i=1,#enemies do
		for j=1,#enemies[i] do
			enemies[i][j].y = enemies[i][j].y + y
		end
	end
end

-- move spaceship bullets and check for collisions
local function spaceshipShots(dt)
	if next(spaceshipBulletsShot) ~= nil then
		for i=#spaceshipBulletsShot,1,-1 do
			spaceshipBulletsShot[i].y = spaceshipBulletsShot[i].y - dt * spaceship.bulletSpeed
			if spaceshipBulletsShot[i].y < 0 then
				table.remove(spaceshipBulletsShot,i)
				-- bad shots cost 5 points
				score = score - 5
			else
				for j=#enemies,1,-1 do
					for k=#enemies[j],1,-1 do
						if next(spaceshipBulletsShot) ~= nil and spaceshipBulletsShot[i] ~= nil and 
								enemies[j][k].x <= spaceshipBulletsShot[i].x and enemies[j][k].x + 50 >= spaceshipBulletsShot[i].x
								and enemies[j][k].y <= spaceshipBulletsShot[i].y and enemies[j][k].y + 47 >= spaceshipBulletsShot[i].y then
							table.insert(bangs, {['x'] = enemies[j][k].x, ['y'] = enemies[j][k].y, ['dt'] = 0.2})
							table.remove(spaceshipBulletsShot, i)
							if level == 3 and enemies[j][k].health > 0 then
								enemies[j][k].health = enemies[j][k].health - 1
							else
								table.remove(enemies[j], k)
								enemiesNumber = enemiesNumber - 1
								score = score + 50
							end
							break
						end
					end
				end
			end
		end
	end
end

local function spaceshipShot()
	lives = lives - 1
	if lives == 0 then
		gameOver()
	end
end

local function enemyShots(dt)
	if next(enemyBulletsShot) ~= nil then
		for i=#enemyBulletsShot,1,-1 do
			enemyBulletsShot[i].y = enemyBulletsShot[i].y + dt * enemyship.bulletSpeed
			if enemyBulletsShot[i].y > love.graphics.getHeight() then
				table.remove(enemyBulletsShot,i)
			elseif spaceship.x <= enemyBulletsShot[i].x and spaceship.x + spaceship.width >= enemyBulletsShot[i].x
				and spaceship.y <= enemyBulletsShot[i].y and spaceship.y + spaceship.height >= enemyBulletsShot[i].y then
				table.insert(bangs, {['x'] = spaceship.x, ['y'] = spaceship.y, ['dt'] = 0.1})
				table.remove(enemyBulletsShot, i)
				spaceshipShot()
			end
		end
	end
end

local function nextLevel()
	level = level + 1
	score = score + 500 * lives
	if level == 2 then
		enemyship.image = love.graphics.newImage(enemyship.YELLOW_IMAGE)
		enemyship.speed = 85
		enemyship.shotProb = enemyship.YELLOW_SHOOT_PROB
		enemyship.bang = bangsi.yellowQuad
		enemyship.bullet = bullets.yellowQuad
		setGame()
	elseif level == 3 then
		enemyship.bang = bangsi.greenQuad
		enemyship.bullet = bullets.greenQuad
		enemyship.image = love.graphics.newImage(enemyship.GREEN_IMAGE)
		setGame()
	elseif level > 3 then
		gameWin()
	end
end

-- GAME FUNCTIONS
function game.load()
	escPressed = false
	pause = false
	bullets.greenQuad = love.graphics.newQuad(0, 0, 10, 8, 10, 36)
	bullets.yellowQuad = love.graphics.newQuad(0, 9, 10, 8, 10, 36)
	bullets.blueQuad = love.graphics.newQuad(0, 19, 10, 8, 10, 36)
	bullets.redQuad = love.graphics.newQuad(0, 28, 10, 8, 10, 36)
	bangsi.image = love.graphics.newImage(BANGS_IMAGE)
	bangsi.greenQuad = love.graphics.newQuad(0, 0, 40, 27, 40, 108)
	bangsi.yellowQuad = love.graphics.newQuad(0, 27, 40, 27, 40, 108)
	bangsi.blueQuad = love.graphics.newQuad(0, 54, 40, 27, 40, 108)
	bangsi.redQuad = love.graphics.newQuad(0, 81, 40, 27, 40, 108)
	nickname = ''
	level = 1
	lives = 3
	score = 0
	spaceship.speed = 150
	spaceship.shootingSpeed = 0.35
	spaceship.bulletSpeed = 250
	spaceship.width = 75
	spaceship.height = 71
	spaceship.lastShot = 0
	enemyship.speed = 50
	enemyship.shootingSpeed = 0.3
	enemyship.width = 50
	enemyship.height = 47
	enemyship.down = 0
	enemyship.downDistance = 10
	enemyship.lastShot = 0
	enemyship.GREEN_IMAGE = SHIPS.GREEN
	enemyship.YELLOW_IMAGE = SHIPS.YELLOW
	enemyship.BLUE_IMAGE = SHIPS.BLUE
	enemyship.BLUE_SHOOT_PROB = 20
	enemyship.YELLOW_SHOOT_PROB = 35
	enemyship.shotProb = enemyship.BLUE_SHOOT_PROB
	enemyship.bulletSpeed = 250
	enemyship.bang = bangsi.blueQuad
	enemyship.bullet = bullets.blueQuad
	enemyship.image = love.graphics.newImage(enemyship.BLUE_IMAGE)
	spaceship.IMAGE = SHIP_IMAGE
	spaceship.image = love.graphics.newImage(spaceship.IMAGE)
	lifeImage = love.graphics.newImage(LIFE_IMAGE)
	spaceship.x = love.graphics.getWidth() / 2 - spaceship.width/2
	spaceship.y = love.graphics.getHeight() - 100
	bullets.image = love.graphics.newImage(BULLETS_IMAGE)
	setGame()
end

function game.draw()
	if pause then
		love.graphics.print('PAUSE', love.graphics.getWidth()/2 - 20, 20)
	end
	if escPressed then
		drawExitQuestion()
	end
	-- spaceship bullets
	if next(spaceshipBulletsShot) ~= nil then
		for i=1,#spaceshipBulletsShot do
			love.graphics.draw(bullets.image, bullets.redQuad, spaceshipBulletsShot[i].x, spaceshipBulletsShot[i].y)
		end
	end
	-- enemy bullets
	if next(enemyBulletsShot) ~= nil then
		for i=1,#enemyBulletsShot do
			love.graphics.draw(bullets.image, enemyship.bullet, enemyBulletsShot[i].x, enemyBulletsShot[i].y)
		end
	end
	-- enemies
	if next(enemies) ~= nil then
		for i=1,#enemies do
			for j=1,#enemies[i] do
				love.graphics.draw(enemyship.image, enemies[i][j].x, enemies[i][j].y)
			end
		end
	end
	-- score, lives and spaceship
	love.graphics.print('Score: '..score, love.graphics.getWidth() - 100, 20)
	love.graphics.draw(spaceship.image, spaceship.x, spaceship.y)
	for i=1,lives do
		love.graphics.draw(lifeImage, 10 + i * 15 , 20)
	end
	-- bangs
	if next(bangs) ~= nil then
		for i=1,#bangs do
			love.graphics.draw(bangsi.image, enemyship.bang, bangs[i].x, bangs[i].y)
		end
	end
	if ready ~= 0 then
		printReadyMessage()
	end
end

function game.update(dt)
	if not pause and not escPressed and ready <= 0 then
		spaceship.lastShot = spaceship.lastShot + dt
		enemyship.lastShot = enemyship.lastShot + dt
		if enemiesNumber == 0 then
			nextLevel()
		end
		for i=#bangs,1,-1 do
			bangs[i]['dt'] = bangs[i]['dt'] - dt
			if bangs[i]['dt'] < 0 then
				table.remove(bangs, i)
			end
		end
		if love.keyboard.isDown("right") then
			spaceship.x = spaceship.x + dt * spaceship.speed
		elseif love.keyboard.isDown("left") then
			spaceship.x = spaceship.x - dt * spaceship.speed
		end
		if love.keyboard.isDown(" ") and spaceship.lastShot > spaceship.shootingSpeed then
			spaceshipShoot()
		end
		spaceshipShots(dt)
		enemyShots(dt)
		if love.math.random(1,100) < enemyship.shotProb and enemyship.lastShot > enemyship.shootingSpeed then
			local r = love.math.random(1,#enemies)
			if next(enemies[r]) ~= nil then
				enemyShoot(enemies[r][#enemies[r]].x,enemies[r][#enemies[r]].y)
			end
		end
		if directionRight then
			for i=1,#enemies do
				for j=1,#enemies[i] do
					enemies[i][j].x = enemies[i][j].x + dt * enemyship.speed
					if enemies[i][j].x + enemyship.width + 2 >= love.graphics.getWidth() then
						directionRight = false
						enemyship.down = enemyship.downDistance
					end
				end
			end
		else
			for i=1,#enemies do
				for j=1,#enemies[i] do
					enemies[i][j].x = enemies[i][j].x - dt * enemyship.speed
					if enemies[i][j].x - 2 <= 0 then
						directionRight = true
						enemyship.down = enemyship.downDistance
					end
				end
			end
		end
		if enemyship.down > 0 then
			local speed = dt * 50
			enemyship.down = enemyship.down - speed
			moveEnemiesDown(speed)
		end
		if spaceship.x < 0 then
			spaceship.x = 0
		elseif spaceship.x > love.graphics.getWidth() - 75 then
			spaceship.x = love.graphics.getWidth() - 75
		end
	elseif ready > 0 and not pause and not escPressed then
		ready = ready - dt
		if ready < 0 then
			ready = 0
		end
	end
end

function game.keypressed(key)
	if key == "escape" then
		escPressed = not escPressed
	elseif key == "p" then
		pause = not pause
	end
	if key == 'y' and escPressed then
		status = require 'menu'
		status.load()
	elseif key == 'n' and escPressed then
		escPressed = not escPressed	
	end
end

function game.textinput(t)

end

return game
