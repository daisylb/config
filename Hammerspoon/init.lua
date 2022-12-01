-- HANDLE SCROLLING WITH MOUSE BUTTON PRESSED
local scrollMouseButton = 2
local deferred = false

overrideOtherMouseDown = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(e)
    -- print("down")
    local pressedMouseButton = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    print(pressedMouseButton)
    if scrollMouseButton == pressedMouseButton 
        then
            deferred = true
            return true
        end
end):start()

overrideOtherMouseUp = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp }, function(e)
    -- print("up")
    local pressedMouseButton = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    if scrollMouseButton == pressedMouseButton 
        then 
            if (deferred) then
                overrideOtherMouseDown:stop()
                overrideOtherMouseUp:stop()
                hs.eventtap.otherClick(e:location(), pressedMouseButton)
                overrideOtherMouseDown:start()
                overrideOtherMouseUp:start()
                return true
            end
            return false
        end
        return false
end):start()

local oldmousepos = {}
local scrollmult = 1  -- negative multiplier makes mouse work like traditional scrollwheel

dragOtherToScroll = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDragged }, function(e)
    local pressedMouseButton = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    -- print ("pressed mouse " .. pressedMouseButton)
    if scrollMouseButton == pressedMouseButton 
        then 
            -- print("scroll");
            deferred = false
            oldmousepos = hs.mouse.getAbsolutePosition()    
            local dx = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
            local dy = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
            local scroll = hs.eventtap.event.newScrollEvent({dx * scrollmult, dy * scrollmult},{},'pixel')
            -- put the mouse back
            hs.mouse.setAbsolutePosition(oldmousepos)
            return true, {scroll}
        else 
            return false, {}
        end 
end)

overrideOtherMouseDown:start()
overrideOtherMouseUp:start()
dragOtherToScroll:start()

local lastTime = 0
local debouncePeriod = 250000000

scrollToSwitchSpaces = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel}, function(e)
    if e:getProperty(hs.eventtap.event.properties['scrollWheelEventIsContinuous']) ~= 0 then
        return false, {}
    end
    local thisTime = hs.timer.absoluteTime()
    print(lastTime, thisTime, thisTime - lastTime)
    if  thisTime - lastTime < debouncePeriod then
        return true, {}
    end
    lastTime = thisTime
    local delta = e:getProperty(hs.eventtap.event.properties['scrollWheelEventDeltaAxis1'])
    local direction = delta >= 0 and hs.keycodes.map.left or hs.keycodes.map.right
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.ctrl, true):post()
    hs.eventtap.event.newKeyEvent(direction, true):post()
    hs.eventtap.event.newKeyEvent(direction, false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.ctrl, false):post()
    return true, {
    }
end)

--scrollToSwitchSpaces:start()

local zoom = nil

zoomPtt = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(e)
    print(e:getKeyCode())
    if e:getKeyCode() ~= hs.keycodes.map["f13"] then
        return false, {}
    end
    print("f13 picked up")
    local isDown = e:getType() == hs.eventtap.event.types.keyDown
    if zoom == nil then
        zoom = hs.application.get("zoom.us")
    end
    print(zoom)
    print(zoom:isRunning())
    if zoom ~= nil and zoom:isRunning() then
        print("posting space to zoom")
        hs.eventtap.event.newKeyEvent(hs.keycodes.map["space"], isDown):post(zoom)
    end
    if not isDown then
        zoom = nil
    end
    return true, {}
end)

-- zoomPtt:start()

hs.hotkey.bind("", "f13", function(e)
    local zoom = hs.application.applicationsForBundleID('us.zoom.xos')[1]
    -- hs.eventtap.event.newKeyEvent('cmd,shift', 'a', true):post(zoom)
    -- hs.eventtap.event.newKeyEvent('cmd,shift', 'a', false):post(zoom)
    hs.eventtap.event.newKeyEvent('', 'space', true):post(zoom)
end, function(e)
    local zoom = hs.application.applicationsForBundleID('us.zoom.xos')[1]
    -- hs.eventtap.event.newKeyEvent('cmd,shift', 'a', true):post(zoom)
    -- hs.eventtap.event.newKeyEvent('cmd,shift', 'a', false):post(zoom)
    hs.eventtap.event.newKeyEvent('', 'space', false):post(zoom)
end)


-- track window focus

local MINUTE = 60
local HOUR = 3600

local applicationTimers = {}
local applicationTimeouts = {
    ['us.zoom.xos'] = 2 * HOUR,
    ['com.google.Chrome'] = 12 * HOUR,
    ['com.yubico.yubioath'] = 10 * MINUTE,
    ['com.apple.keychainaccess'] = 2 * HOUR,
    ['com.apple.reminders'] = 6 * HOUR,
    ['com.agilebits.onepassword7'] = HOUR,
    ['com.apple.Notes'] = 3 * HOUR,
    ['com.apple.iCal'] = 3 * HOUR,
    ['com.flexibits.fantastical2.mac'] = 3 * HOUR,
    ['com.postmanlabs.mac'] = 3 * HOUR,
    ['com.tinyapp.TablePlus'] = 8 * HOUR,
    ['app.kaleidoscope.v3'] = 8 * HOUR,
    ['com.apple.iWork.Pages'] = 8 * HOUR,
    ['com.apple.iWork.Numbers'] = 8 * HOUR,
    ['com.apple.Preview'] = 3 * HOUR,
    ['com.apple.shortcuts'] = 3 * HOUR,
    ['co.gitup.mac'] = 1 * HOUR,
}

hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function(window, appName)
    local bundleID = window:application():bundleID()
    print('Unfocused: ' .. bundleID)
    local timeout = applicationTimeouts[bundleID]
    if not timeout then
        return
    end
    print('Will be shut down in ' .. timeout .. 's')
    local timer = hs.timer.doAfter(timeout, function ()
        print('Killing bundle id ' .. bundleID)
        for key, app in pairs(hs.application.applicationsForBundleID(bundleID)) do
            app:kill()
        end
    end)
    applicationTimers[bundleID] = timer
end)

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
    local bundleID = window:application():bundleID()
    local timer = applicationTimers[bundleID]
    if not timer then
        return
    end
    print('Focused: ' .. bundleID .. ', cancelling timer')
    timer:stop()
    applicationTimers[bundleID] = nil
end)

-- com.apple.Safari
local defaultBrowser = 'com.apple.Safari' -- 'com.apple.Safari'
local nonSafariBrowser = 'com.vivaldi.Vivaldi' -- org.mozilla.Firefox com.vivaldi.Vivaldi
local chromiumBrowser = 'com.vivaldi.Vivaldi'

hs.urlevent.httpCallback = function(scheme, host, params, fullURL)
    -- Only Zoom join links should open in Zoom, not any zoom.us URL
    if string.match(fullURL, "^https?://.*%.zoom%.us/j/") or string.match(fullURL, "^https?://zoom%.us/j/") or string.match(fullURL, "^https?://zoom%.us/my/") then
        hs.urlevent.openURLWithBundle(fullURL, 'us.zoom.xos')
    -- Things that need to be opened in a Chromium browser:
    -- Streamyard: some screen sharing features
    -- AWS: uses legacy U2F APIs not supported in Safari
    -- Sentry: legacy U2F APIs also
    elseif host == 'streamyard.com' or host == 'meet.google.com' then
        hs.urlevent.openURLWithBundle(fullURL, chromiumBrowser)
    elseif host == 'aws.amazon.com' or string.match(host, '.*%.aws%.amazon%.com') then
        hs.urlevent.openURLWithBundle(fullURL, nonSafariBrowser)
    else
        hs.urlevent.openURLWithBundle(fullURL, defaultBrowser) 
    end
end
hs.urlevent.setDefaultHandler('http')


hs.urlevent.bind('krakenCoreFile', function(eventName, params, senderPID)
    print(params['file'])
    local cmd = '/usr/local/bin/subl "/Users/leigh/Octopus Energy/kraken-core/' .. params['file'] .. '"'
    print(cmd)
    status = os.execute(cmd)
    print(status)
end)

-- delete button in mail.app archives
-- TODO
