display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")


system.activate( "multitouch" )
local ui = require("ui")
local gameUI = require("gameUI")

physics.start()
--physics.setDrawMode( "hybrid" ) 
physics.setGravity( 0, 9.8 )

local dragBody = gameUI.dragBody

local bkg = display.newImage( "paper_bkg.png", true )

-- Chopped fruit physics properties
local minAngularVelocityChopped = 100
local maxAngularVelocityChopped = 200

-- Audio for slash sound (sound you hear when user swipes his/her finger across the screen)
local slashSounds = {slash1 = audio.loadSound("slash1.wav"), slash2 = audio.loadSound("slash2.wav"), slash3 = audio.loadSound("slash3.wav")}
local slashSoundEnabled = true -- sound should be enabled by default on startup
local minTimeBetweenSlashes = 150 -- Minimum amount of time in between each slash sound
local minDistanceForSlashSound = 50 -- Amount of pixels the users finger needs to travel in one frame in order to play a slash sound
local maxPoints = 5
local lineThickness = 20
local lineFadeTime = 250
local endPoints = {}

local splashImgs = {}
table.insert(splashImgs, "splash1.png")
table.insert(splashImgs, "splash2.png")
table.insert(splashImgs, "splash3.png")
	

function drawSlashLine(event)
	
	-- Play a slash sound
	if(endPoints ~= nil and endPoints[1] ~= nil) then
		local distance = math.sqrt(math.pow(event.x - endPoints[1].x, 2) + math.pow(event.y - endPoints[1].y, 2))
		if(distance > minDistanceForSlashSound and slashSoundEnabled == true) then 
			playRandomSlashSound();  
			slashSoundEnabled = false
			timer.performWithDelay(minTimeBetweenSlashes, function(event) slashSoundEnabled = true end)
		end
	end
	
	-- Insert a new point into the front of the array
	table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 

	-- Remove any excessed points
	if(#endPoints > maxPoints) then 
		table.remove(endPoints)
	end

	for i,v in ipairs(endPoints) do
		local line = display.newLine(v.x, v.y, event.x, event.y)
		line.width = lineThickness
		transition.to(line, {time = lineFadeTime, alpha = 0, width = 0, onComplete = function(event) line:removeSelf() end})		
	end

	if(event.phase == "ended") then		
		while(#endPoints > 0) do
			table.remove(endPoints)
		end
	end
end

-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end

function playRandomSlashSound()
	
	audio.play(slashSounds["slash" .. math.random(1, 3)])
end



Runtime:addEventListener("touch", drawSlashLine)



--BUILD ZOMBIE RAGDOLL



local Zombie = display.newGroup()

local wallPhysics = { density=1.6, friction=0.9, bounce=.7 }
local bodyPhysics = { density=.4, friction=0.9, bounce=.7 }
local headPhysics = { density=.4, friction=0.9, bounce=.7, radius = 70 }
local handPhysics = { density=.4, friction=0.9, bounce=.7, radius = 40 }
local footPhysics = { density=.4, friction=0.9, bounce=.7, radius = 30 }



--LEFT LEG
local leftUpperLeg = display.newImage(Zombie, "leftUpperLeg.png", 175, 365)
physics.addBody( leftUpperLeg , bodyPhysics)
leftUpperLeg.name = "leftUpperLeg"
leftUpperLeg.top = "leftUpperLegTop.png"
leftUpperLeg.bottom = "leftUpperLegBottom.png"
leftUpperLeg.type = "rect"

local leftLowerLeg = display.newImage(Zombie, "leftLowerLeg.png", 180, 465)
physics.addBody( leftLowerLeg , bodyPhysics)
leftLowerLeg.name = "leftLowerLeg"
leftLowerLeg.top = "leftLowerLegTop.png"
leftLowerLeg.bottom = "leftLowerLegBottom.png"
leftLowerLeg.type = "rect"

local leftFoot = display.newImage(Zombie, "leftFoot.png", 125, 550)
physics.addBody( leftFoot , footPhysics)



--RIGHT LEG
local rightUpperLeg = display.newImage(Zombie, "rightUpperLeg.png", 245, 365)
physics.addBody( rightUpperLeg, bodyPhysics)
rightUpperLeg.name = "rightUpperLeg"
rightUpperLeg.top = "rightUpperLegTop.png"
rightUpperLeg.bottom = "rightUpperLegBottom.png"
rightUpperLeg.type = "rect"

local rightLowerLeg = display.newImage(Zombie, "rightLowerLeg.png", 250, 465)
physics.addBody( rightLowerLeg, bodyPhysics)
rightLowerLeg.name = "rightLowerLeg"
rightLowerLeg.top = "rightLowerLegTop.png"
rightLowerLeg.bottom = "rightLowerLegBottom.png"
rightLowerLeg.type = "rect"

local rightFoot = display.newImage(Zombie, "rightFoot.png", 260, 550)
physics.addBody( rightFoot, footPhysics)



--TORSO
local torso = display.newImage(Zombie, "torso.png", 150, 200)
physics.addBody( torso, bodyPhysics)

local neck = display.newImage(Zombie, "neck.png", 210, 170)
neck.name = "neck"
physics.addBody( neck, bodyPhysics)

leftUpperLeg.bottomPart = leftLowerLeg
leftUpperLeg.upperPart = torso
leftLowerLeg.bottomPart = leftFoot
leftLowerLeg.upperPart = leftUpperLeg

rightUpperLeg.bottomPart = rightLowerLeg
rightUpperLeg.upperPart = torso
rightLowerLeg.bottomPart = rightFoot
rightLowerLeg.upperPart = rightUpperLeg

local head = display.newImage(Zombie, "head.png", 155, 90)
head.name = "head"
head.top = "headTop.png"
head.bottom = "headBottom.png"
head.type = "circle"


physics.addBody( head , "static", headPhysics)



--LEFT ARM

local leftUpperArm = display.newImage(Zombie, "leftUpperArm.png", 100,200);
physics.addBody( leftUpperArm, bodyPhysics)
leftUpperArm.name = "leftUpperArm"
leftUpperArm.top = "leftUpperArmTop.png"
leftUpperArm.bottom = "leftUpperArmBottom.png"
leftUpperArm.type = "rect"

local leftLowerArm = display.newImage(Zombie, "leftLowerArm.png", 102, 300);
physics.addBody( leftLowerArm, bodyPhysics)
leftLowerArm.name = "leftLowerArm"
leftLowerArm.top = "leftLowerArmTop.png"
leftLowerArm.bottom = "leftLowerArmBottom.png"
leftLowerArm.type = "rect"

local leftHand = display.newImage(Zombie, "leftHand.png", 90, 375)
physics.addBody( leftHand, handPhysics)

local leftShoulder = display.newImage(Zombie, "shoulder.png", 120,200)
physics.addBody( leftShoulder, bodyPhysics)



--RIGHT ARM

local rightShoulder = display.newImage(Zombie, "shoulder.png", 300,200)
physics.addBody( rightShoulder, bodyPhysics)

local rightUpperArm = display.newImage(Zombie, "rightUpperArm.png", 330,200);
physics.addBody( rightUpperArm, bodyPhysics)
rightUpperArm.name = "rightUpperArm"
rightUpperArm.top = "rightUpperArmTop.png"
rightUpperArm.bottom = "rightUpperArmBottom.png"
rightUpperArm.type = "rect"


local rightLowerArm = display.newImage(Zombie, "rightLowerArm.png", 332, 300);
physics.addBody( rightLowerArm, bodyPhysics)
rightLowerArm.name = "rightLowerArm"
rightLowerArm.top = "rightLowerArmTop.png"
rightLowerArm.bottom = "rightLowerArmBottom.png"
rightLowerArm.type = "rect"

local rightHand = display.newImage(Zombie, "rightHand.png", 320, 375)
physics.addBody( rightHand, handPhysics)





--JOINTS
local lowerNeck = physics.newJoint ("pivot", torso, neck, 225, 200)
local upperNeck = physics.newJoint ("pivot", head, neck, 225, 150)
upperNeck.isLimitEnabled = true 
upperNeck:setRotationLimits( -45, 45 )



head.bottomPart = neck
head.upperPart = 0


local leftElbow = physics.newJoint ("pivot", leftUpperArm, leftLowerArm, 109, 300)
local leftSTJoint = physics.newJoint ("pivot", leftShoulder, torso, 150, 210)
local leftArmJoint = physics.newJoint("pivot", leftShoulder, leftUpperArm, 120, 215)
local leftWrist = physics.newJoint ("pivot", leftHand, leftLowerArm, 120, 395)
leftWrist.isLimitedEnabled = true
leftWrist:setRotationLimits( -45, 45 )


leftLowerArm.bottomPart = leftHand
leftLowerArm.upperPart = leftUpperArm
leftUpperArm.bottomPart = leftLowerArm
leftUpperArm.upperPart = leftShoulder

rightLowerArm.bottomPart = rightHand
rightLowerArm.upperPart = rightUpperArm
rightUpperArm.bottomPart = rightLowerArm
rightUpperArm.upperPart = rightShoulder


local rightSTJoint = physics.newJoint("pivot", rightShoulder, torso, 300, 215)
local rightArmJoint = physics.newJoint("pivot", rightShoulder, rightUpperArm, 330, 210)
local rightElbow = physics.newJoint("pivot", rightLowerArm, rightUpperArm, 340, 300)
local rightWrist = physics.newJoint ("pivot", rightLowerArm, rightHand, 350, 375)
rightWrist.isLimitedEnabled = true
rightWrist:setRotationLimits( -45, 45 )

local rightHip = physics.newJoint ("pivot", rightUpperLeg, torso, 260, 370)
local rightKnee = physics.newJoint ("pivot", rightUpperLeg, rightLowerLeg, 260, 475)
local rightAnkle = physics.newJoint ("pivot", rightFoot, rightLowerLeg, 260, 550)
rightAnkle.isLimitEnabled = true 
rightAnkle:setRotationLimits( -45, 45 )

local leftHip = physics.newJoint ("pivot", leftUpperLeg, torso, 190, 365)
local leftKnee = physics.newJoint ("pivot", leftUpperLeg, leftLowerLeg, 190, 475)
local leftAnkle = physics.newJoint ("pivot", leftFoot, leftLowerLeg, 190, 550)
leftAnkle.isLimitEnabled = true 
leftAnkle:setRotationLimits( -45, 45 )






--BOUNDARIES
local leftWall = display.newRect(0,0, 0, display.contentHeight)
physics.addBody(leftWall, "static", wallPhysics )

local downWall = display.newRect(0, display.contentHeight, display.contentWidth, 0)
physics.addBody(downWall, "static", wallPhysics )

local topWall = display.newRect(0, 0, display.contentWidth, 0)
physics.addBody(topWall, "static", wallPhysics)

local rightWall = display.newRect(display.contentWidth,0, 0, display.contentHeight)
physics.addBody(rightWall, "static", wallPhysics  )


--TOUCH

function moveBody( event )
	local body = event.target
	local yForce = 2000
	local xForce = 2000
	if (event.y > display.contentHeight / 2) then yForce = -2100 end
	if (event.x > display.contentWidth / 2) then xForce = -2000 end
	body:applyLinearImpulse(xForce, yForce, event.x, event.y)
	--body:applyAngularImpulse( 2000 )
end

function addSliceListener( bodyPart ) 
	bodyPart:addEventListener("touch", function(event) sliceBody(bodyPart) end)
end -- addSliceListener

addSliceListener ( head )
addSliceListener ( neck )
addSliceListener ( torso ) 
addSliceListener ( leftUpperArm )
addSliceListener ( leftLowerArm )
addSliceListener ( leftHand ) 
addSliceListener ( leftUpperLeg ) 
addSliceListener ( leftLowerLeg )
addSliceListener ( leftFoot )
addSliceListener ( leftShoulder )
addSliceListener ( rightUpperArm ) 
addSliceListener ( rightLowerArm ) 
addSliceListener ( rightHand )
addSliceListener ( rightUpperLeg ) 
addSliceListener ( rightLowerLeg )
addSliceListener ( rightFoot ) 
addSliceListener ( rightShoulder ) 

function sliceBody(bodyPart)
	createBodyPart(bodyPart, "top")
	createBodyPart(bodyPart, "bottom")
	createSplash(bodyPart)
	createGush(bodyPart)
	bodyPart:removeSelf()
end --sliceBody

function createBodyPart(fruit, section)

	local fruitVelX, fruitVelY = fruit:getLinearVelocity()

	-- Calculate the position of the chopped piece
	local half = display.newImage(fruit[section])
	half.x = fruit.x - fruit.x -- Need to have the fruit's position relative to the origin in order to use the rotation matrix
	local yOffSet = section == "top" and -half.height / 2 or half.height / 2
	half.y = fruit.y + yOffSet - fruit.y
	
	local newPoint = {}
	newPoint.x = half.x * math.cos(fruit.rotation * (math.pi /  180)) - half.y * math.sin(fruit.rotation * (math.pi /  180))
	newPoint.y = half.x * math.sin(fruit.rotation * (math.pi /  180)) + half.y * math.cos(fruit.rotation * (math.pi /  180))
	
	half.x = newPoint.x + fruit.x -- Put the fruit back in its original position after applying the rotation matrix
	half.y = newPoint.y + fruit.y
	
	
	-- Set the rotation 
	half.rotation = fruit.rotation
	--fruitProp.radius = half.width / 2 -- We won't use a custom shape since the chopped up fruit doesn't interact with the player 
	physics.addBody(half, "dynamic", half)
	
	if (section == "bottom" and fruit.bottomPart ~= 0 ) then
		
		half.bottomJoint = physics.newJoint ("pivot", half, fruit.bottomPart, fruit.bottomPart.x, fruit.bottomPart.y )
		fruit.bottomPart.upperPart = 0
	end 
	
	if (section == "top" and fruit.upperPart ~= 0 ) then
		
		half.topJoint = physics.newJoint ("pivot", half, fruit.upperPart, fruit.upperPart.x, fruit.upperPart.y)
		fruit.upperPart.bottomPart = 0
	end 
	
	
	
	-- Set the linear velocity  
	local velocity  = math.sqrt(math.pow(fruitVelX, 2) + math.pow(fruitVelY, 2))
	local xDirection = section == "top" and -1 or 1
	local velocityX = math.cos((fruit.rotation + 90) * (math.pi /  180)) * velocity * xDirection
	local velocityY = math.sin((fruit.rotation + 90) * (math.pi /  180)) * velocity
	half:setLinearVelocity(velocityX,  velocityY)

	-- Calculate its angular velocity 
 	local minAngularVelocity = getRandomValue(minAngularVelocityChopped, maxAngularVelocityChopped)
	local direction = (math.random() < .5) and -1 or 1
	half.angularVelocity = minAngularVelocity * direction
end

-- Splash properties
local splashFadeTime = 2500
local splashFadeDelayTime = 5000
local splashInitAlpha = .5
local splashSlideDistance = 50 -- The amoutn of of distance the splash slides down the background

local splashGroup 
splashGroup = display.newGroup()

-- Gush properties 
local minGushRadius = 10 
local maxGushRadius = 25
local numOfGushParticles = 15
local gushFadeTime = 500
local gushFadeDelay = 500

local minGushVelocityX = -350
local maxGushVelocityX = 350
local minGushVelocityY = -350
local maxGushVelocityY = 350

-- Gush filter should not interact with other fruit or the catch platform
local gushProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} } 

function createSplash(fruit)
	
	local splash = getRandomSplash()
	splash.x = fruit.x
	splash.y = fruit.y
	splash.rotation = math.random(-90,90)
	splash.alpha = splashInitAlpha
	splashGroup:insert(splash)
	
	transition.to(splash, {time = splashFadeTime, alpha = 0,  y = splash.y + splashSlideDistance, delay = splashFadeDelayTime, onComplete = function(event) splash:removeSelf() end})		
	
end

function createGush(fruit)

	local i
	for  i = 0, numOfGushParticles do
		local gush = display.newCircle( fruit.x, fruit.y, math.random(minGushRadius, maxGushRadius) )
		gush:setFillColor(107, 5, 5, 255)
		
		gushProp.radius = gush.width / 2
		physics.addBody(gush, "dynamic", gushProp)

		local xVelocity = math.random(minGushVelocityX, maxGushVelocityX)
		local yVelocity = math.random(minGushVelocityY, maxGushVelocityY)

		gush:setLinearVelocity(xVelocity, yVelocity)
		
		transition.to(gush, {time = gushFadeTime, delay = gushFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) gush:removeSelf() end})		
	end

end

function getRandomSplash()

 	return display.newImage(splashImgs[math.random(1, #splashImgs)])
end



