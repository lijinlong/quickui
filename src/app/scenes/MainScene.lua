
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	app:createGrid(self)

    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64,
            color = cc.c4b(255, 0, 0, 255)
        })
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    app:createTitle(self, "Test MainScene")
    app:createNextButton(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
