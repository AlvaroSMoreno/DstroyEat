
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    composer.gotoScene( "game" )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores" )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local background = display.newImageRect( sceneGroup, "back-back.jpg", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local title = display.newImageRect( sceneGroup, "title.png", 100*3, 30*3 )
    title.x = display.contentCenterX
    title.y = display.contentCenterY-100

    local playButton = display.newImageRect( sceneGroup, "play_btn.png", 90*2, 30*2 )
	playButton.x = display.contentCenterX
	playButton.y = display.contentHeight-210

	local tienda = display.newImageRect( sceneGroup, "tienda_btn.png", 90*2, 30*2 )
	tienda.x = display.contentCenterX
	tienda.y = display.contentHeight-140

	local scores = display.newImageRect( sceneGroup, "scores_btn.png", 90*2, 30*2 )
	scores.x = display.contentCenterX
	scores.y = display.contentHeight-70

	local items = display.newImageRect( sceneGroup, "items_btn.png", 90*2, 30*2 )
	items.x = display.contentCenterX
	items.y = display.contentHeight

    playButton:addEventListener( "tap", gotoGame )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
