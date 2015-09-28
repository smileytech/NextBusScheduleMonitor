function Initialize()
	local baseTime = {}
	baseTime.year = '2015'
	baseTime.month = '1'
	baseTime.day = '1'
	baseTime.sec = '0'
	baseTime.wday = '1'
	baseTime.yday = '0'
	baseTime.isdst = false
	local busTimesFile = 'bus-arrival-times.txt'
	busTimesFile = SKIN:MakePathAbsolute(busTimesFile)
	busSchedule = {}
	local index = 0
	local count = 0
	for line in io.lines(busTimesFile) do
		index = index + 1
		count = 0
		for num in string.gmatch(line, '%d+') do
			count = count + 1
			if count == 1 then
				baseTime.hour = num
			elseif count == 2 then
				baseTime.min = num
				busSchedule[index] = os.time(baseTime)
			end
		end
	end
	table.sort(busSchedule)
end

function Update()
	local currentTime = os.date('*t')
	currentTime.wday = '1'
	currentTime.day = '1'
	currentTime.month = '1'
	currentTime.year = '2015'
	currentTime.sec = '0'
	currentTime.yday = '0'
	currentTime.isdst = false
	local currentTimeEpoch = os.time(currentTime)
	local difference = 0
	local retString = ''
	local busScheduleLength = table.getn(busSchedule)
	for i,busTime in ipairs(busSchedule) do
		difference = os.difftime(currentTimeEpoch, busTime)
		if (difference <= 0) then
			retString = os.date('%I:%M %p', busTime)
			if i+1 <= busScheduleLength then
				retString = retString .. '\n' .. os.date('%I:%M %p', busSchedule[i+1])
			end
			return retString
		end
	end
	return 'No more buses today!'
end