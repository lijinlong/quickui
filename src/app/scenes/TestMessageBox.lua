-- TestMessageBox.lua
local MessageBox = import("../ui/MessageBox")

local T = class("TestMessageBox", function()
    return display.newScene("TestMessageBox")
end)

function T:ctor()
    app:createGrid(self)

    self:createView()

    app:createTitle(self, "Test MessageBox")
    app:createNextButton(self)
end

function T:createView()
    self.label = cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64,
            color = cc.c3b(255, 0, 0)
        })
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)


    display.addSpriteFrames("ui/AllSprites.plist", "ui/AllSprites.png")
    local viewSize = cc.size(display.width-80, display.height/2)
    self.view = MessageBox.new{
    	color = cc.c4b(69, 128, 98, 255),
		click = function(x,y)
			printInfo("click %s, %s", x, y)
		end,
		swallowTouch = true,

		size = viewSize,
		maskColor = cc.c4b(245, 127, 100, 99),
		-- image = "ui/MenuSceneBg.png",
		-- image = { "ui/MenuSceneBg.png", scale = 0.5 }, 
		-- image = { "#OtherSceneBg.png", scale = 0.5 },
		image = { "ui/MenuSceneBg.png", params={class = cc.Scale9Sprite, size = viewSize, } },

		title = "标题",
		msg = [["信息---深入理解计算机系统
计算机基础_编译原理介绍程序员
应该了解的计算机体统的一些知识
计算机程序的构造和解释
计算机基础_编译原理
介绍编程方法的书,影响比较深远,
以lisp语言为基础进行的讲解"]],
		-- item = 附加的层,
		btns = {
			{"ok",
				click = function()
					print("clicked")
					self.view:dismiss()
				end 
			},
			{"cancle",
				click = function()
					print("cancle")
					self.view:dismiss()
				end 
			}
		},

	}:addTo(self)

end

return T
