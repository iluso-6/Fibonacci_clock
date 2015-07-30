system.setIdleTimer( false )
display.setStatusBar( display.HiddenStatusBar )

local X = display.screenOriginX
local Y = display.screenOriginY
local W = display.contentWidth - display.screenOriginX
local H = display.contentHeight - display.screenOriginY
local cellHeight = 120
local cell2D = cellHeight*2
local cell3D = cell2D+cellHeight
local cell5D = cell2D+cell3D
local cellGrp = display.newGroup()

local cell = {}
local strokeCommon = 10
--forwards 
local tm
local hour
local minute
local second

local white = {1,1,1,1}
local red = {1,0,0,1}
local green = {0,1,0,1}
local yellow = {1,1,0,1}
local blue = {0,0,1,1}

local hourPanel = {{1,0,0,0,0},{0,0,1,0,0},{0,0,0,1,0},{1,1,1,0,0},{0,0,0,0,1},{1,0,0,0,1},{0,0,1,0,1},{0,0,0,1,1},{1,0,0,1,1},{0,0,1,1,1},{1,0,1,1,1},{1,1,1,1,1}}

local minutePanel = {{0,0,0,0,0},{1,0,0,0,0},{0,0,1,0,0},{0,0,0,1,0},{1,0,0,1,0},{0,0,0,0,1},{1,0,1,1,0},{0,0,1,0,1},{0,0,0,1,1},{1,1,1,0,1},{0,0,1,1,1},{1,0,1,1,1}}

local secondPanel = {{1,0,0,0,0},{0,0,1,0,0},{0,0,0,1,0},{1,0,0,1,0},{0,0,0,0,1},{1,0,1,1,0},{0,0,1,0,1},{0,0,0,1,1},{0,1,0,1,1},{0,0,1,1,1},{1,0,1,1,1},{1,1,1,1,1}}


local hourPanel2 = {{0,1,0,0,0},{1,1,0,0,0},{1,0,1,0,0},{0,1,0,1,0},{0,0,1,1,0},{1,0,1,1,0},{1,1,1,1,0},{1,0,1,0,1},{1,1,1,0,1},{1,1,0,1,1},{0,1,1,1,1},{1,1,1,1,1}}

local minutePanel2 = {{0,0,0,0,0},{1,0,0,0,0},{0,0,1,0,0},{0,0,0,1,0},{1,0,0,1,0},{0,0,0,0,1},{1,0,1,1,0},{0,0,1,0,1},{0,0,0,1,1},{1,1,1,0,1},{0,0,1,1,1},{1,0,1,1,1}}

local function transReset(tgt)
	local object = tgt
transition.to(object,{time=1000,alpha = 1})
	
end			

local function transTo(obj)
	local object = obj
	object:toFront() 
	local randDelay = (math.random(1,15)*100)
transition.to(object,{delay=randDelay,time=1000,alpha = 0.5,onComplete=function ()
transReset(object);
end})
	
end

	
local function getTime()
local tm = {}

	local time = os.date("*t")

	tm.hour = time.hour
	tm.minute = math.floor(time.min/5) 
	tm.second = math.floor(time.sec/5)+1
	if(time.hour>12)then 
	tm.hour = tm.hour-12
	end
	if(time.hour==0)then 
	tm.hour = 12
	end
	return tm
end


	
local function setUpDisplay()
	
cell[3] = display.newRect(X,Y,cell2D,cell2D)
cell[3].anchorX = 0
cell[3].anchorY = 0
cell[3]:setStrokeColor(0)
cell[3]:setFillColor(0,0,1)
cell[3].strokeWidth = strokeCommon
cellGrp:insert(cell[3])


cell[1] = display.newRect(cell[3].width,Y,cellHeight,cellHeight)
cell[1].anchorX = 0
cell[1].anchorY = 0
cell[1]:setStrokeColor(0)
cell[1]:setFillColor(0,0,1)
cell[1].strokeWidth = strokeCommon
cellGrp:insert(cell[1])

cell[2] = display.newRect(cell[3].width,cell[3].height,cellHeight,cellHeight)
cell[2].anchorX = 0
cell[2].anchorY = 1
cell[2]:setStrokeColor(0)
cell[2]:setFillColor(0,0,1)
cell[2].strokeWidth = strokeCommon
cellGrp:insert(cell[2])

cell[4] = display.newRect(X,cell[3].height,cell3D,cell3D)
cell[4].anchorX = 0
cell[4].anchorY = 0
cell[4]:setStrokeColor(0)
cell[4]:setFillColor(0,0,1)
cell[4].strokeWidth = strokeCommon
cellGrp:insert(cell[4])

cell[5] = display.newRect(cell[4].width,Y,cell5D,cell5D)
cell[5].anchorX = 0
cell[5].anchorY = 0
cell[5]:setStrokeColor(0)
cell[5]:setFillColor(0,0,1)
cell[5].strokeWidth = strokeCommon
cellGrp:insert(cell[5])

cellGrp.x = X
cellGrp.y = (H-cell[5].height)*0.5

end


local function setSeconds()

	for i=1,5 do
		if(secondPanel[second][i]==1)then
		transTo(cell[i])
		end
	end

end
 
local function setMinutes() 

local selectedMn = minutePanel[minute+1] 
	for i = 1, #selectedMn do

		if(selectedMn[i]==1)then
			if(cell[i].color == red)then
			cell[i]:setFillColor(1,1,0)
			cell[i].color = yellow
			else
			cell[i]:setFillColor(0,1,0)
			cell[i].color = green
			end
		end	
		if(selectedMn[i]==0)then
			if (cell[i].color == red)then
			else
			cell[i]:setFillColor(0,0,1)
			cell[i].color = blue
			end
		end
	end 
	setSeconds()
end

local prev=hourPanel

local function setHours()

	local rand = math.random(1,3) 
	local randString = {hourPanel,hourPanel2,'SKIP'}
	local randSelect = randString[rand]
	
if(randSelect=='SKIP')then
randSelect = prev
--print('SKIP')
end

local selectedHr = randSelect[hour]

	for i = 1, #selectedHr do

		if(selectedHr[i]==1)then
			cell[i]:setFillColor(1,0,0)
			cell[i].color = red
		end
		if(selectedHr[i]==0)then
			cell[i]:setFillColor(0,0,1)
			cell[i].color = blue
		end
	end
	prev = randSelect
	setMinutes()
end


local function update()

	tm = getTime()
	hour = tm.hour
	minute = tm.minute
	second = tm.second
	setHours()
	--setSeconds()
end


setUpDisplay();
update();
local clockTimer = timer.performWithDelay( 5000, update, -1 )
