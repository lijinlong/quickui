-- compatible.lua
local version = cc.VERSION
print("compatible-----")
if string.sub(version, 1, 1) == "2" then
	print("quick version 2.x")

	local futils = cc.FileUtils
	futils.getInstance = futils.sharedFileUtils

	local node_removeFromParent = cc.Node.removeFromParent
	cc.Node.removeFromParent = function(self)
		node_removeFromParent(self)
	end

	cc.c4b = ccc4
	cc.c3b = ccc3

	display.addSpriteFrames = display.addSpriteFramesWithFile
	display.newLine = function(points, params)
		return display.newNode()
	end
	display.newBMFontLabel = ui.newBMFontLabel
	display.newTTFLabel = function(params)
		assert(type(params) == "table",
	           "[framework.ui] newTTFLabel() invalid params")

	    local text       = tostring(params.text)
	    local font       = params.font or ui.DEFAULT_TTF_FONT
	    local size       = params.size or ui.DEFAULT_TTF_FONT_SIZE
	    local color      = params.color or display.COLOR_WHITE
	    local textAlign  = params.align or ui.TEXT_ALIGN_LEFT
	    local textValign = params.valign or ui.TEXT_VALIGN_TOP
	    local x, y       = params.x, params.y
	    local dimensions = params.dimensions

	    assert(type(size) == "number",
	           "[framework.ui] newTTFLabel() invalid params.size")

	    local label
	    if dimensions then
	        label = CCLabelTTF:create(text, font, size, dimensions, textAlign, textValign)
	    else
	        label = CCLabelTTF:create(text, font, size)
	    end

	    if label then
	        label:setColor(color)

	        -- function label:realign(x, y)
	        --     if textAlign == ui.TEXT_ALIGN_LEFT then
	        --         label:setPosition(math.round(x + label:getContentSize().width / 2), y)
	        --     elseif textAlign == ui.TEXT_ALIGN_RIGHT then
	        --         label:setPosition(x - math.round(label:getContentSize().width / 2), y)
	        --     else
	        --         label:setPosition(x, y)
	        --     end
	        -- end

	        -- if x and y then label:realign(x, y) end
	        if x and y then label:setPosition(x, y) end
	    end

	    return label
	end
end
