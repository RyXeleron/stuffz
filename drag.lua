-- services
local runService = game:GetService("RunService");
local tweenService = game:GetService("TweenService");
local players = game:GetService("Players");
local inputService = game:GetService("UserInputService")

-- globals
local player = players.LocalPlayer;
local mouse = player:GetMouse();
local utils = require(script.Parent.Parent.utils);

-- ui
local main = script.Parent;
local hitbox = script.Parent.Topbar.Hitbox;


-- tweeninfo
local moveTweenInfo = utils.tweenInfo.move;

-- vars
local dragConnection;
local clickPos;

local isMobile = inputService.TouchEnabled;

-- core
local function drag()
	local Position;
	-- simple drag system
	if isMobile then
		Position = UDim2.fromOffset(mouse.X, mouse.Y);
	else
		local relPos = Vector2.new(mouse.X, mouse.Y)-main.AbsolutePosition;
		local res = main.AbsolutePosition + (relPos - clickPos);
		Position = UDim2.fromOffset(res.X, res.Y);
	end
	-- tween
	tweenService:Create(
		main,
		moveTweenInfo,
		{
			Position = Position
		}
	):Play();
end

-- disconnect and clear
local function disconnect()
	if dragConnection then
		dragConnection:Disconnect();
		dragConnection = nil;
	end
end
-- custom drag
utils.onDownUp(hitbox,
	function() -- on button down
		disconnect();
		clickPos = Vector2.new(mouse.X, mouse.Y)-main.AbsolutePosition;
		
		dragConnection = runService.RenderStepped:Connect(drag);
	end,
	function() -- on button up
		disconnect();
	end
);
