local M = {}

function M.is_charging()
    local battery_status = nil

    -- Try to open BAT0 status file first
    local file = io.open("/sys/class/power_supply/BAT0/status", "r")
    if file then
        battery_status = file:read("*l")
        file:close()
    else
        -- Try to open BAT1 status file if BAT0 is not available
        file = io.open("/sys/class/power_supply/BAT1/status", "r")
        if file then
            battery_status = file:read("*l")
            file:close()
        else
            return false -- Return false if neither BAT0 nor BAT1 is accessible
        end
    end

    if battery_status then
        battery_status = battery_status:lower()
        if battery_status == "charging" then
            return true  -- Charging
        elseif battery_status == "full" then
            return true -- Battery is fully charged
        end
    end

    return false -- Return false if battery status is nil
end

return M
