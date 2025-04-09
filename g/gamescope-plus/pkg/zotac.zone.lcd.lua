-- colorimetry from DXQ7D0023 PDF specification
local dongxingqiang_amoled_colorimetry = {
   r = { x = 0.712, y = 0.345 },
   g = { x = 0.280, y = 0.756 },
   b = { x = 0.168, y = 0.076 },
   w = { x = 0.320, y = 0.330 }
}

gamescope.config.known_displays.dongxingqiang_amoled = {
    pretty_name = "DXQ7D0023 AMOLED",
    dynamic_refresh_rates = {
        60, 72, 90, 120, 144
    },
    hdr = {
        supported = true,
        force_enabled = false,
        eotf = gamescope.eotf.pq,
        max_content_light_level = 1000,
        max_frame_average_luminance = 1000,
        min_content_light_level = 0.5
    },
    colorimetry = dongxingqiang_amoled_colorimetry,
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating mode "..refresh.."Hz for DXQ7D0023 AMOLED")
        local mode = base_mode

        gamescope.modegen.set_resolution(mode, 1080, 1920)

        -- Horizontal timings from PDF: HFP=156, HSync=1, HBP=23
        gamescope.modegen.set_h_timings(mode, 156, 1, 23)
        -- Vertical timings from PDF: VFP=20, VSync=1, VBP=15
        gamescope.modegen.set_v_timings(mode, 20, 1, 15)

        mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        return mode
    end,
    matches = function(display)
        -- Match based on the EDID information
        local lcd_types = {
            { vendor = "ZDZ", model = "ZDZ0501" },
            { vendor = "DXQ", model = "DXQ7D0023" },
        }

        for index, value in ipairs(lcd_types) do
            if value.vendor == display.vendor and value.model == display.model then
                debug("[dongxingqiang_amoled] Matched vendor: "..value.vendor.." model: "..value.model)
                return 5000
            end
        end

        return -1
    end
}
debug("Registered DXQ7D0023 AMOLED as a known display")
