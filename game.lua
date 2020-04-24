
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 1 )

math.randomseed( os.time() )

local score = 0
local enemies = {}
local livesCounter = 15

local background
local scoreText
local player 


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

local function fire()
    local bullet = display.newImageRect("bullet.png", 25, 25)
    physics.addBody( bullet, "dynamic"  )
    bullet.isBullet = true
    bullet.myName = "bullet"
    bullet.x = player.x
    bullet.y = player.y
    transition.to( bullet, { y=-10, time=1000,
        onComplete = function() display.remove( bullet ) end
    } )
end

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
            score = score + 1
            scoreText.text = "Score:"..score
        end
    end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()
    
    background = display.newImageRect("back-back.jpg", 360, 570)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    scoreText = display.newText( "Score:"..score, display.contentCenterX, 20, native.systemFont, 40 )
    scoreText:setFillColor( 0, 0, 0 )

    player = display.newImageRect("player.png", 50,50);
    player.x = display.contentCenterX
    player.y = display.contentHeight-25
    physics.addBody( player, "static", { radius=50, bounce=0.8, isSensor=true } )


    player:addEventListener("touch", movePlayer);
    player:addEventListener( "tap", fire)


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 700, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
