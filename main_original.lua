-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 1 )

math.randomseed( os.time() )

local score = 0
local enemies = {}
local livesCounter = 60

local background = display.newImageRect("back-back.jpg", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local scoreText = display.newText( "Score:"..score, display.contentCenterX, 20, native.systemFont, 40 )
scoreText:setFillColor( 0, 0, 0 )

local player = display.newImageRect("player.png", 50,50);
player.x = display.contentCenterX
player.y = display.contentHeight-25
physics.addBody( player, "static", { radius=50, bounce=0.8, isSensor=true } )

local function createEnemy() 
    local newEnemy = display.newImageRect("burger.png", 40, 40);
    table.insert( enemies, newEnemy )
    physics.addBody( newEnemy, "dynamic", { radius=40, bounce=0.8, isSensor=true } )
    newEnemy.myName = "enemy"
    newEnemy.x = math.random( display.contentWidth )
    newEnemy.y = -60
    newEnemy:setLinearVelocity( math.random( -2,2 ), math.random( 20,120 ) )
    newEnemy:applyTorque( math.random( -5,5 ) )
end

local function movePlayer( event )
 
    local player = event.target
    local phase = event.phase
 
    if ( "began" == phase ) then
        display.currentStage:setFocus( player )
        player.touchOffsetX = event.x - player.x
    elseif ( "moved" == phase ) then
        player.x = event.x - player.touchOffsetX
    elseif ( "ended" == phase or "cancelled" == phase ) then
        display.currentStage:setFocus( nil )
    end
    return true  -- Prevents touch propagation to underlying objects
end

player:addEventListener("touch", movePlayer);

local function fire()
    local bullet = display.newImageRect("bullet.png", 25, 25)
    physics.addBody( bullet, "dynamic", { isSensor=true } )
    bullet.isBullet = true
    bullet.myName = "bullet"
    bullet.x = player.x
    bullet.y = player.y
    transition.to( bullet, { y=-10, time=1000,
        onComplete = function() display.remove( bullet ) end
    } )
end

player:addEventListener( "tap", fire)

local function gameLoop()
    if(livesCounter > 0) then
        createEnemy()
        livesCounter = livesCounter - 1
        for i = #enemies, 1, -1 do
            local thisEnemy = enemies[i]
            if ( thisEnemy.x < -100 or
                thisEnemy.x > display.contentWidth + 100 or
                thisEnemy.y < -100 or
                thisEnemy.y > display.contentHeight + 100 )
            then
                display.remove( thisEnemy )
                table.remove( enemies, i )
            end
        end
    else 
        display.remove(player)
        for i = #enemies, 1, -1 do
            display.remove(enemies[i])
            table.remove( enemies, i )
        end
        scoreText.text = "GAMEOVER: "..score
    end
end

gameLoopTimer = timer.performWithDelay( 800, gameLoop, 0 )

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
 
        if ( ( obj1.myName == "bullet" and obj2.myName == "enemy" ) or
             ( obj1.myName == "enemy" and obj2.myName == "bullet" ) )
        then
            display.remove( obj1 )
            display.remove( obj2 )
            for i = #enemies, 1, -1 do
                if ( enemies[i] == obj1 or enemies[i] == obj2 ) then
                    table.remove( enemies, i )
                    break
                end
            end
        end
        score = score + 1
        scoreText.text = "Score:"..score
    end
end

Runtime:addEventListener( "collision", onCollision )
