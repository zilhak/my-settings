-- Hammerspoon configuration file
-- 

-- This script sets up Hammerspoon to switch input sources to English (ABC layout)
local im_select = "/opt/homebrew/bin/im-select"

local function switchToABC()
  hs.execute(im_select .. " com.apple.keylayout.ABC")
end

appWatcher = hs.application.watcher.new(function(appName, eventType)
  if eventType == hs.application.watcher.activated then
    switchToABC()
  end
end)
appWatcher:start()

-- key mapping for vim 
-- Convert input soruce as English and sends 'escape' if inputSource is not English.
-- Sends 'escape' if inputSource is English.
-- key bindding reference --> https://www.hammerspoon.org/docs/hs.hotkey.html
local inputEnglish = "com.apple.keylayout.ABC"
local esc_bind

function convert_to_eng_with_esc()
	local inputSource = hs.keycodes.currentSourceID()
	if not (inputSource == inputEnglish) then
		hs.eventtap.keyStroke({}, 'right')
		hs.keycodes.currentSourceID(inputEnglish)
	end
	esc_bind:disable()
	hs.eventtap.keyStroke({}, 'escape')
	esc_bind:enable()
end

esc_bind = hs.hotkey.new({}, 'escape', convert_to_eng_with_esc):enable()


-- Force Click to mouse wheel button
middleClickWatcher = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, function(event)
    local button = event:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    if button == 2 then -- middle click
        hs.eventtap.keyStroke({"cmd", "ctrl"}, "D")
        return true -- 이벤트 가로채기
    end
    return false
end)

middleClickWatcher:start()

-- Disable the default behavior of Command + H
hs.hotkey.bind({"cmd"}, "H", function() end)

-- 앱 활성화 목록
local bindings = {
  { functionKey = {"ctrl", "cmd"}, key = "T", appName = "iTerm" },
  { functionKey = {"ctrl", "cmd"}, key = "I", appName = "Antigravity" },
  { functionKey = {"ctrl", "cmd"}, key = "O", appName = "IntelliJ IDEA CE" },
  { functionKey = {"ctrl", "cmd"}, key = "P", appName = "PyCharm" },
  { functionKey = {"ctrl", "cmd"}, key = "Z", appName = "Dooray Messenger" },
  { functionKey = {"ctrl", "cmd"}, key = "X", appName = "Finder" },
  { functionKey = {"ctrl", "cmd"}, key = "E", appName = "Google Chrome" },
}

for _, binding in ipairs(bindings) do
  hs.hotkey.bind(binding.functionKey, binding.key, 
                  function() hs.application.launchOrFocus(binding.appName) end)
end

