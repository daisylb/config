-- HANDLE SCROLLING WITH MOUSE BUTTON PRESSED
local scrollMouseButton = 3
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
end)

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
end)

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

scrollToSwitchSpaces:start()

local zoom = nil

hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(e)
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
end):start()


-- track window focus

local applicationTimers = {}
local applicationTimeouts = {
    ['us.zoom.xos'] = 7200, -- 2h
    ['com.google.Chrome'] = 43200, -- 12h
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