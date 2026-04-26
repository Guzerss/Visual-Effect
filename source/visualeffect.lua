script_author("Guzers")

local imgui  = require 'mimgui'
local cfg   = require('jsoncfg')
local ffi = require 'ffi'
local gta = ffi.load('GTASA')

ffi.cdef([[
    extern bool _ZN10CSpecialFX8bLiftCamE;
    extern bool _ZN10CSpecialFX9bVideoCamE;
    extern bool _ZN12CPostEffects17m_bDarknessFilterE;
]])

local defaultConfig = {
    nightvision = false,
    infraredvision = false,
    liftcam = false,
    videocam = false,
    darkness = false,
}

local config = cfg.load(defaultConfig, 'visualeffect')

local SW, SH = getScreenResolution()
local WinState = imgui.new.bool(false)
local nightvision = imgui.new.bool(config.nightvision)
local infraredvision = imgui.new.bool(config.infraredvision)
local liftcam = imgui.new.bool(config.liftcam)
local videocam = imgui.new.bool(config.videocam)
local darkness = imgui.new.bool(config.darkness)

function saveConfig()
    config.nightvision = nightvision[0]
    config.infraredvision = infraredvision[0]
    config.liftcam = liftcam[0]
    config.videocam = videocam[0]
    config.darkness = darkness[0]
    cfg.save(config, 'visualeffect')
end

imgui.OnFrame(
    function() return WinState[0] end,
    function()
        imgui.SetNextWindowPos(imgui.ImVec2(SW / 2, SH / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(150 * MONET_DPI_SCALE, 118 * MONET_DPI_SCALE))
        imgui.Begin('Visual Effect', WinState, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        if imgui.Checkbox('NightVision', nightvision) then 
             setNightVision(nightvision[0])
             saveConfig() 
        end
        if imgui.Checkbox('InfraredVision', infraredvision) then 
             setInfraredVision(infraredvision[0])
             saveConfig() 
        end
        if imgui.Checkbox('LiftCam', liftcam) then 
             gta._ZN10CSpecialFX8bLiftCamE = liftcam[0]
             saveConfig() 
        end
        if imgui.Checkbox('VideoCam', videocam) then 
             gta._ZN10CSpecialFX9bVideoCamE = videocam[0]
             saveConfig() 
        end
        if imgui.Checkbox('Darkness', darkness) then 
             gta._ZN12CPostEffects17m_bDarknessFilterE = darkness[0]
             saveConfig() 
        end
        imgui.End()
    end
)

function main()
    sampRegisterChatCommand('veff', function() WinState[0] = not WinState[0] end)
    wait(-1) 
end
