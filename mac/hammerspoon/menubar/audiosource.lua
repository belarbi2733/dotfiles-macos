---
-- Display audiosource
-- setAudiosourceBarTitle(uid, event_name, event_scope, event_element)
print "== menubar.audiosource"
local audiosourceBar = hs.menubar.new()
local function nextAudiosource (mods)
  local result = hs.execute('/usr/local/bin/SwitchAudioSource -n')
end
audiosourceBar:setClickCallback(nextAudiosource)
local function setAudiosourceBarTitle (e)
  if e ~= 'dOut' then return end
  local defaultDevice = hs.audiodevice.defaultOutputDevice()
  local title = defaultDevice:name()
  if title == 'Built-in Output' then title = 'H'
  elseif title == 'Built-in Line Output' then title = 'L'
  elseif title == 'Built-in Digital Output' then title = 'D'
  end
  audiosourceBar:setTitle(title)
end
setAudiosourceBarTitle('dOut')
local audioWatcher = hs.audiodevice.watcher
audioWatcher.setCallback(setAudiosourceBarTitle)
audioWatcher.start()