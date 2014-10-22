-- MessageBox.lua

--[[

消息框

]]

local DEFAULT_TTF_TITLE_SIZE = 64
local DEFAULT_TTF_TITLE_COLOR = display.COLOR_RED
local DEFAULT_TTF_TITLE_ALIGN = cc.TEXT_ALIGNMENT_CENTER
local DEFAULT_TTF_MSG_SIZE = 32
local DEFAULT_TTF_MSG_COLOR = display.COLOR_WHITE
local DEFAULT_TTF_MSG_ALIGN = cc.TEXT_ALIGNMENT_LEFT
local DEFAULT_TTF_MSG_VALIGN = cc.VERTICAL_TEXT_ALIGNMENT_TOP

-- local UIGroup = import("cc.ui.UIGroup")
local M = class("MessageBox", cc.ui.UIGroup)

--- @args
-- @args.size box大小
-- @args.maskColor color4
-- @args.color 背景色ccc4
-- @args.image 背景图片
-- @args.click function
-- @args.swallowTouch bool 是否吞噬触摸，不向下层传递
-- @args.title 标题
-- @args.msg 信息
-- @args.bgitem 附加的层,在title和message下面
-- @args.item 附加的层
-- @args.btns 按钮的数组{ btn1, btn2, ... }
--		btns.images 按钮组图片数组
--		btn[1] = normal label
--		btn.click function 点击的回调
--		btn.images 按钮图片数组
--		btn.size 按钮尺寸
--		btn.align { align, x, y }

function M:ctor(args)
	M.super.ctor(self)

	local nilObj = {}
	local args = args or nilObj

	-- 颜色遮罩层
	if args.maskColor then
		display.newColorLayer(args.maskColor):addTo(self)
	end

	local size = args.size or cc.size(display.width/2, display.height/2)
	local layer = display.newLayer():addTo(self)
	layer:setPosition((display.width-size.width)/2, (display.height-size.height)/2)
	layer:setContentSize(size)

	-- 颜色背景层
	local clr = args.color or nilObj
	local r = clr.r or 0
	local g = clr.g or 0
	local b = clr.b or 0
	local a = clr.a or 100         -- 透明度
	local clr_bg = display.newColorLayer(cc.c4b(r, g, b, a)):addTo(layer)
	clr_bg:setContentSize(size)

	if args.image then
		if type(args.image) == "table" then
			local spr = display.newSprite(args.image[1], size.width/2, size.height/2, args.image.params):addTo(layer)
			if args.image.scale then
				spr:setScale(args.image.scale)
			end
		else
			local spr = display.newSprite(args.image, size.width/2, size.height/2):addTo(layer)
		end
	end

	if args.bgitem then
		self:addChild(args.bgitem)
	end

	local titley = size.height - DEFAULT_TTF_TITLE_SIZE
	local titleh = 4
	if args.title then
		local msg = args.title
		titley = args.title.y or titley
		titleh = args.title.size or DEFAULT_TTF_TITLE_SIZE
		if type(msg)=="string" then
			msg = {
				text = msg,
				size = DEFAULT_TTF_TITLE_SIZE,
    			color = DEFAULT_TTF_TITLE_COLOR,
    			textAlign = DEFAULT_TTF_TITLE_ALIGN,
    			x = size.width/2,
    			y = titley
    		}
		end
		self.title = cc.ui.UILabel.new(msg):addTo(layer)
		self.title:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER])
		if not msg.x and not msg.y then
			self.title:setPosition(size.width/2, titley)
		end
	end

	local msgy = titley - titleh
	if args.msg then
		local msg = args.msg
		if type(msg)=="string" then
			msg = {
				text = msg,
				size = DEFAULT_TTF_MSG_SIZE,
    			color = DEFAULT_TTF_MSG_COLOR,
    			textAlign = DEFAULT_TTF_MSG_ALIGN,
    			textValign = DEFAULT_TTF_MSG_VALIGN,
    			x = 10,
    			y = msgy,
    			dimensions = cc.size(size.width-20, size.height-100),
    		}
		end
		-- dump(msg)
		self.msg = cc.ui.UILabel.new(msg):addTo(layer)
		self.msg:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])
		if not msg.x and not msg.y then
			self.msg:setPosition(10, msgy)
		end
	end

	if args.item then
		self:addChild(args.item)
	end

	if not args.btns then
		args.btns = {
			{ "ok", click = function() self:dismiss() end }
		}
	end
	if args.btns then
		local btns_images = args.btns.images or {
		    normal = "ui/Button01.png",
		    pressed = "ui/Button01Pressed.png",
		    disabled = "ui/Button01Disabled.png",
		}
		local btnDefaultWidth = math.min(size.width/#args.btns, 90)
		local btnDefaultHeight = 60
		local btns = {}
		local autoAlign = true
		local buttonH = 0
		for _, btn in ipairs(args.btns) do
			local images = btn.images or btns_images
			local button = cc.ui.UIPushButton.new(images, {scale9 = true})
			local sz = btn.size or nilObj
			local btnW, btnH = sz.width or btnDefaultWidth, sz.height or btnDefaultHeight
	        button:setButtonSize(btnW, btnH)
	        button:setButtonLabel("normal", cc.ui.UILabel.new({
	            UILabelType = 2,
	            text = btn[1],
	            size = btnH-10,
	        }))
	        if btn.align then
	        	autoAlign = false
	        	button:align(unpack(btn.align))
	        end
	        button:onButtonClicked(btn.click or function() end)
	        button:addTo(layer)
	        btns[#btns+1] = button

	        if buttonH < btnH then
	        	buttonH = btnH
	        end
		end
		if autoAlign then
			local w = size.width/#args.btns
			local x = -w/2
			for i, btn in ipairs(btns) do
				btn:align(display.CENTER, x+i*w, buttonH/2+8)
			end
		end
	end


	self.click = args.click or nil
	self.clickFunc = function(x, y)
		if self.click then
			self.click(x,y)
		else
			self:dispatchEvent({ name="CLICK", x=x, y=y })
		end
	end  -- 点击回调函数

	-- 屏蔽点击
	if args.swallowTouch then
		local function onTouch(event)
			local eventType , x , y = event.name, event.x, event.y
		    if eventType == CCTOUCHBEGAN then return true end
		    if eventType == CCTOUCHMOVED then return true end

		    if eventType == CCTOUCHENDED then
		        -- 点击回调函数
				    this.clickFunc(x , y)
		        return true
		    end

		    return false
		end
		self:setTouchEnabled( true )
		self:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
	end

	if item ~= nil then
	    self:addChild(item)
	end
end


function M:show()
	self:setVisible(true)
end

function M:dismiss()
	self:removeFromParent()
end

-- 设置点击回调函数
function M:click(func)
	self.click = func
end

return M
