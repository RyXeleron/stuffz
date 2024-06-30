-- service
local textService = game:GetService("TextService");

-- ui
local scrolling = script.Parent.ScrollingFrame;
local textbox = scrolling.SourceBox;
local linesLab = scrolling.Lines;

local config = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.config);

-- import
local highlight = require(script:WaitForChild("highlight"));

highlight.UpdateColors(config.data.settings.codeColors);

-- TODO update only when color settings update
-- currently we update colors every time config is saved
config.configSaved:Connect(function()
	highlight.UpdateColors(config.data.settings.codeColors);
end)

-- vars
local texts = {}; 	-- used texts
local pool = {}; 	-- textlabel pool
local onTextUpdate = textbox:GetPropertyChangedSignal("Text");

-- util
local function getNumberOfLines(str)
	local _, n = str:gsub('\n', '');
	return n;
end

-- core
local old = function() end;


local function render()
	local code = textbox.Text;
	-- highlight
	old();
	old = highlight.Highlight(textbox, textbox.Text);
	-- render lines
	local text = "";
	for i=0, getNumberOfLines(code) do
		text = text .. i+1 .. "\n";
	end
	linesLab.TextSize = textbox.TextSize;
	linesLab.Font = textbox.Font;
	linesLab.Text = text;
	-- set CanvasSize
	local canvas = textService:GetTextSize(code, textbox.TextSize, textbox.Font, Vector2.new());
	scrolling.CanvasSize = UDim2.new(0, canvas.X + textbox.TextSize + 24, 0, canvas.Y + textbox.TextSize);
end


task.spawn(function()
	while textbox.Parent do
		onTextUpdate:Wait();
		render();
	end
end);

return {
	colors = highlight.TokenColors
}
