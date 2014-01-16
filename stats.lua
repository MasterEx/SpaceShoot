-- Periklis Ntanasis <pntanasis@gmail.com> 2014

local stats = {}
local statEntries = {}
local STAT_FILE = 'stats.txt'

function stats.readEntries()
	statEntries = {}
	if love.filesystem.exists(STAT_FILE) then
		local file = love.filesystem.newFile(STAT_FILE)
		file:open("r")
		for line in file:lines() do
			local entry = {}
			local temp
			entry.score, temp = split(line,'*')
			entry.date, entry.nickname = split(temp,'*')
			table.insert(statEntries, entry)
		end
		file:close()
	end
end

function stats.addScore(score, nickname)
	local sDate = os.date("%d-%m-%Y")
	local newEntries = {}
	local i = 1
	if #statEntries == 0 then
		table.insert(newEntries, {['score'] = score, ['date'] = sDate, ['nickname'] = nickname})
	else
		while i <= #statEntries and i <= 10 do
			if tonumber(statEntries[i].score) < score then
				table.insert(newEntries, {['score'] = score, ['date'] = sDate, ['nickname'] = nickname})
				break
			else
				table.insert(newEntries, statEntries[i])
			end
			i = i + 1
		end
		while i <= #statEntries+1 and i<10 do
			table.insert(newEntries, statEntries[i])
			i = i + 1
		end
		if i < 10 and #statEntries == #newEntries then
			table.insert(newEntries, {['score'] = score, ['date'] = sDate, ['nickname'] = nickname})
		end
	end
	statEntries = nil
	statEntries = newEntries
end

function stats.getScoreEntries()
	return statEntries
end

function stats.saveScore()
	local dir = love.filesystem.getSaveDirectory()
	local str = ''
	for i=1,#statEntries do
		str = str .. statEntries[i].score..'*'..statEntries[i]['date']..'*'..statEntries[i]['nickname']..'\n'
	end
	if string.len(str) > 0 then
		if love.filesystem.write(STAT_FILE, str) then
			-- OK
		else
			print('[ERROR] Failed to save stats to file!')
		end
	end
end

function stats.isHighscore(score)
	if #statEntries < 10 then
		return true
	end
	for i=1,#statEntries do
		if tonumber(statEntries[i].score) < score then
			return true
		end
	end
	return false
end

-- up to one delimiter i.e. word*word
function split(s,c)
	local i = 1
	while i < #s do
		if s:sub(i,i) == c then
			break
		end
		i = i + 1
	end
	return s:sub(1,i-1),s:sub(i+1,#s)
end

return stats
