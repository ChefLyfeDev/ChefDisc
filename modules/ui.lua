-- UI Module
-- Handles menu creation and UI rendering functionality for Discipline Priest

local ui = {}

-- Required modules
local control_panel_helper = require("common/utility/control_panel_helper")
local key_helper = require("common/utility/key_helper")
local plugin_helper = require("common/utility/plugin_helper")
local color_module = require("common/color")

-- Define menu elements
ui.menu_elements = {
    -- Main container
    main_tree = core.menu.tree_node(),
    enable_script_check = core.menu.checkbox(true, "enable_script_check"),
    enable_toggle = core.menu.keybind(999, false, "toggle_script_check"),
    
    -- General settings
    general_settings_tree = core.menu.tree_node(),
    
    -- Content type settings
    content_type_tree = core.menu.tree_node(),
    raid_mode = core.menu.checkbox(true, "raid_mode"),
    mythic_plus_mode = core.menu.checkbox(false, "mythic_plus_mode"),
    
    -- Specialization settings
    spec_tree = core.menu.tree_node(),
    oracle_spec = core.menu.checkbox(true, "oracle_spec"),
    voidweaver_spec = core.menu.checkbox(false, "voidweaver_spec"),
    
    -- Healing thresholds
    threshold_tree = core.menu.tree_node(),
    heal_threshold = core.menu.slider_int(60, 90, 75, "heal_threshold"),
    shield_threshold = core.menu.slider_int(80, 100, 90, "shield_threshold"),
    tank_shield_threshold = core.menu.slider_int(70, 100, 85, "tank_shield_threshold"),
    emergency_heal_threshold = core.menu.slider_int(25, 50, 40, "emergency_heal_threshold"),
    critical_heal_threshold = core.menu.slider_int(15, 40, 25, "critical_heal_threshold"),
    execute_threshold = core.menu.slider_int(10, 30, 20, "execute_threshold"),
    
    -- Healing style
    healing_style_tree = core.menu.tree_node(),
    prioritize_atonement = core.menu.checkbox(true, "prioritize_atonement"),
    allow_reactive_healing = core.menu.checkbox(true, "allow_reactive_healing"),
    
    -- Atonement management
    atonement_tree = core.menu.tree_node(),
    min_atonement_count = core.menu.slider_int(2, 6, 3, "min_atonement_count"),
    min_evangelism_count = core.menu.slider_int(3, 10, 5, "min_evangelism_count"),
    prioritize_tank_atonement = core.menu.checkbox(true, "prioritize_tank_atonement"),
    refresh_atonement_threshold = core.menu.slider_int(1, 10, 3, "refresh_atonement_threshold"),
    
    -- Core spell toggles
    spells_tree = core.menu.tree_node(),
    
    -- Damage spells
    damage_spells_tree = core.menu.tree_node(),
    enable_shadow_word_pain = core.menu.checkbox(true, "enable_shadow_word_pain"),
    enable_mind_blast = core.menu.checkbox(true, "enable_mind_blast"),
    enable_penance_damage = core.menu.checkbox(true, "enable_penance_damage"),
    enable_smite = core.menu.checkbox(true, "enable_smite"),
    enable_mind_games = core.menu.checkbox(true, "enable_mind_games"),
    enable_shadow_word_death = core.menu.checkbox(true, "enable_shadow_word_death"),
    enable_mindbender = core.menu.checkbox(true, "enable_mindbender"),
    enable_halo = core.menu.checkbox(true, "enable_halo"),
    dot_refresh_threshold = core.menu.slider_int(1, 10, 2, "dot_refresh_threshold"),
    
    -- Healing spells
    heal_spells_tree = core.menu.tree_node(),
    enable_shield = core.menu.checkbox(true, "enable_shield"),
    enable_shadowmend = core.menu.checkbox(true, "enable_shadowmend"),
    enable_penance_heal = core.menu.checkbox(true, "enable_penance_heal"),
    enable_pain_suppression = core.menu.checkbox(true, "enable_pain_suppression"),
    enable_power_word_radiance = core.menu.checkbox(true, "enable_power_word_radiance"),
    enable_evangelism = core.menu.checkbox(true, "enable_evangelism"),
    enable_flash_heal = core.menu.checkbox(true, "enable_flash_heal"),
    
    -- Voidweaver specific spells
    voidweaver_spells_tree = core.menu.tree_node(),
    enable_voidwraith = core.menu.checkbox(true, "enable_voidwraith"),
    enable_void_blast = core.menu.checkbox(true, "enable_void_blast"),
    enable_entropic_rift = core.menu.checkbox(true, "enable_entropic_rift"),
    enable_renew = core.menu.checkbox(true, "enable_renew"),
    enable_ultimate_penitence = core.menu.checkbox(true, "enable_ultimate_penitence"),
    use_binding_heals = core.menu.checkbox(true, "use_binding_heals"),
    use_words_of_pious = core.menu.checkbox(true, "use_words_of_pious"),
    
    -- Cooldowns
    cooldowns_tree = core.menu.tree_node(),
    enable_power_infusion = core.menu.checkbox(true, "enable_power_infusion"),
    power_infusion_key = core.menu.keybind(999, false, "power_infusion_key"),
    power_infusion_self = core.menu.checkbox(true, "power_infusion_self"),
    power_infusion_health_threshold = core.menu.slider_int(0, 50, 30, "power_infusion_health_threshold"),
    enable_spirit_shell = core.menu.checkbox(true, "enable_spirit_shell"),
    spirit_shell_key = core.menu.keybind(999, false, "spirit_shell_key"),
    
    -- Standard ramping settings
    ramping_tree = core.menu.tree_node(),
    enable_ramping = core.menu.checkbox(true, "enable_ramping"),
    ramp_automatically = core.menu.checkbox(false, "ramp_automatically"),
    ramp_time_before_event = core.menu.slider_int(5, 20, 10, "ramp_time_before_event"),
    
    -- Full ramp settings
    full_ramp_tree = core.menu.tree_node(),
    manual_ramp_key = core.menu.keybind(999, false, "manual_ramp_key"),
    ramp_shield_count = core.menu.slider_int(3, 8, 5, "ramp_shield_count"),
    ramp_phase1_duration = core.menu.slider_int(2, 8, 3, "ramp_phase1_duration"),
    ramp_phase2_duration = core.menu.slider_int(3, 10, 6, "ramp_phase2_duration"),
    ramp_phase3_duration = core.menu.slider_int(5, 12, 8, "ramp_phase3_duration"),
    
    -- Mini ramp settings
    mini_ramp_tree = core.menu.tree_node(),
    mini_ramp_key = core.menu.keybind(999, false, "mini_ramp_key"),
    enable_health_based_ramp = core.menu.checkbox(false, "enable_health_based_ramp"),
    health_ramp_threshold = core.menu.slider_int(40, 80, 60, "health_ramp_threshold"),
    mini_ramp_shield_count = core.menu.slider_int(2, 5, 3, "mini_ramp_shield_count"),
    mini_ramp_duration = core.menu.slider_int(3, 12, 6, "mini_ramp_duration"),
    
    -- Voidweaver ramping
    voidweaver_ramping_tree = core.menu.tree_node(),
    
    -- Voidweaver major ramp
    voidweaver_major_ramp_tree = core.menu.tree_node(),
    enable_voidweaver_ramp = core.menu.checkbox(true, "enable_voidweaver_ramp"),
    voidweaver_ramp_key = core.menu.keybind(999, false, "voidweaver_ramp_key"),
    voidweaver_renew_count = core.menu.slider_int(3, 6, 6, "voidweaver_renew_count"),
    
    -- Voidweaver mini ramp
    voidweaver_mini_ramp_tree = core.menu.tree_node(),
    enable_voidweaver_mini_ramp = core.menu.checkbox(true, "enable_voidweaver_mini_ramp"),
    voidweaver_mini_ramp_key = core.menu.keybind(999, false, "voidweaver_mini_ramp_key"),
    voidweaver_mini_shield_count = core.menu.slider_int(1, 4, 3, "voidweaver_mini_shield_count"),
    
    -- Quick keybinds
    keybinds_tree = core.menu.tree_node(),
    pain_suppression_key = core.menu.keybind(999, false, "pain_suppression_key"),

    -- Interface settings
    interface_tree = core.menu.tree_node(),
    draw_plugin_state = core.menu.checkbox(true, "draw_plugin_state"),
    ts_custom_logic_override = core.menu.checkbox(true, "override_ts_logic"),
    draw_atonement_count = core.menu.checkbox(true, "draw_atonement_count"),
    draw_ramp_timer = core.menu.checkbox(true, "draw_ramp_timer"),
    draw_heal_thresholds = core.menu.checkbox(true, "draw_heal_thresholds"),
    ui_scale = core.menu.slider_int(75, 150, 100, "ui_scale")
}

-- Helper function to render a section header
local function render_section_header(text)
    core.menu.text_colored(text, 0.4, 0.8, 1.0, 1.0)
    core.menu.separator()
end

-- Render the menu
function ui.render_menu()
    ui.menu_elements.main_tree:render("Discipline Priest Rotation", function()
        -- Main enable toggle
        ui.menu_elements.enable_script_check:render("Enable Script")
        ui.menu_elements.enable_toggle:render("Toggle Key")
        
        if not ui.menu_elements.enable_script_check:get_state() then
            return false
        end
        
        -- General Settings
        ui.menu_elements.general_settings_tree:render("General Settings", function()
            -- Content Type
            render_section_header("Content Type")
            ui.menu_elements.raid_mode:render("Raid Mode")
            ui.menu_elements.mythic_plus_mode:render("Mythic+ Mode")
            core.menu.separator()
            
            -- Specialization
            render_section_header("Specialization")
            ui.menu_elements.oracle_spec:render("Oracle (Traditional Disc)")
            ui.menu_elements.voidweaver_spec:render("Voidweaver")
            
            -- Target Selector Override
            core.menu.separator()
            ui.menu_elements.ts_custom_logic_override:render("Enable Target Selector Custom Settings")
        end)
        
        -- Thresholds
        ui.menu_elements.threshold_tree:render("Healing Thresholds", function()
            render_section_header("Standard Thresholds")
            ui.menu_elements.heal_threshold:render("Heal Threshold % (Standard Healing)")
            ui.menu_elements.shield_threshold:render("Shield Threshold % (Proactive Shielding)")
            ui.menu_elements.tank_shield_threshold:render("Tank Shield Threshold %")
            
            render_section_header("Emergency Thresholds")
            ui.menu_elements.emergency_heal_threshold:render("Emergency Heal Threshold % (Direct Healing Priority)")
            ui.menu_elements.critical_heal_threshold:render("Critical Heal Threshold % (Emergency Cooldowns)")
            
            render_section_header("Damage Thresholds")
            ui.menu_elements.execute_threshold:render("Execute Threshold % (Shadow Word: Death)")
        end)
        
        -- Healing Style
        ui.menu_elements.healing_style_tree:render("Healing Style", function()
            render_section_header("Healing Approach")
            ui.menu_elements.prioritize_atonement:render("Prioritize Atonement (Proactive Healing)")
            ui.menu_elements.allow_reactive_healing:render("Allow Reactive Emergency Healing")
        end)
        
        -- Atonement Management
        ui.menu_elements.atonement_tree:render("Atonement Management", function()
            render_section_header("Atonement Settings")
            ui.menu_elements.min_atonement_count:render("Minimum Atonement Count")
            ui.menu_elements.min_evangelism_count:render("Minimum Atonements for Evangelism")
            ui.menu_elements.prioritize_tank_atonement:render("Prioritize Tank Atonement")
            ui.menu_elements.refresh_atonement_threshold:render("Refresh Atonement when < X seconds remain")
        end)
        
        -- Spells section
        ui.menu_elements.spells_tree:render("Spells", function()
            -- Damage spells
            ui.menu_elements.damage_spells_tree:render("Damage Spells", function()
                render_section_header("Core Damage Abilities")
                ui.menu_elements.enable_shadow_word_pain:render("Enable Shadow Word: Pain")
                ui.menu_elements.enable_mind_blast:render("Enable Mind Blast")
                ui.menu_elements.enable_penance_damage:render("Enable Penance (Damage)")
                ui.menu_elements.enable_smite:render("Enable Smite")
                
                render_section_header("Additional Damage")
                ui.menu_elements.enable_shadow_word_death:render("Enable Shadow Word: Death")
                ui.menu_elements.enable_mind_games:render("Enable Mind Games")
                ui.menu_elements.enable_mindbender:render("Enable Mindbender")
                ui.menu_elements.enable_halo:render("Enable Halo")
                
                render_section_header("DoT Management")
                ui.menu_elements.dot_refresh_threshold:render("Refresh DoT when < X seconds remain")
            end)
            
            -- Healing spells
            ui.menu_elements.heal_spells_tree:render("Healing Spells", function()
                render_section_header("Core Healing")
                ui.menu_elements.enable_shield:render("Enable Power Word: Shield")
                ui.menu_elements.enable_shadowmend:render("Enable Shadow Mend")
                ui.menu_elements.enable_penance_heal:render("Enable Penance (Healing)")
                ui.menu_elements.enable_flash_heal:render("Enable Flash Heal (when no enemies)")
                
                render_section_header("Atonement Spread")
                ui.menu_elements.enable_power_word_radiance:render("Enable Power Word: Radiance")
                ui.menu_elements.enable_evangelism:render("Enable Evangelism")
                
                render_section_header("Defensive")
                ui.menu_elements.enable_pain_suppression:render("Enable Pain Suppression")
            end)
            
            -- Only show Voidweaver spells if spec is selected
            if ui.menu_elements.voidweaver_spec:get_state() then
                ui.menu_elements.voidweaver_spells_tree:render("Voidweaver Abilities", function()
                    render_section_header("Core Voidweaver Abilities")
                    ui.menu_elements.enable_voidwraith:render("Enable Voidwraith")
                    ui.menu_elements.enable_void_blast:render("Enable Void Blast")
                    
                    render_section_header("Additional Abilities")
                    ui.menu_elements.enable_entropic_rift:render("Enable Entropic Rift")
                    ui.menu_elements.enable_renew:render("Enable Renew")
                    ui.menu_elements.enable_ultimate_penitence:render("Enable Ultimate Penitence")
                    
                    render_section_header("Healing Modifiers")
                    ui.menu_elements.use_binding_heals:render("Use Binding Heals")
                    ui.menu_elements.use_words_of_pious:render("Use Words of Pious")
                end)
            end
        end)
        
        -- Cooldowns
        ui.menu_elements.cooldowns_tree:render("Cooldowns", function()
            render_section_header("Power Infusion")
            ui.menu_elements.enable_power_infusion:render("Enable Power Infusion")
            ui.menu_elements.power_infusion_key:render("Power Infusion Key")
            ui.menu_elements.power_infusion_self:render("Use Power Infusion on Self")
            ui.menu_elements.power_infusion_health_threshold:render("Tank Health % for Power Infusion")
            
            render_section_header("Spirit Shell")
            ui.menu_elements.enable_spirit_shell:render("Enable Spirit Shell")
            ui.menu_elements.spirit_shell_key:render("Spirit Shell Key")
            
            render_section_header("Defensive")
            ui.menu_elements.pain_suppression_key:render("Pain Suppression Key")
        end)
        
        -- Ramping System
        ui.menu_elements.ramping_tree:render("Damage Ramping", function()
            ui.menu_elements.enable_ramping:render("Enable Ramping System")
            
            if not ui.menu_elements.enable_ramping:get_state() then
                return false
            end
            
            render_section_header("Automatic Ramping")
            ui.menu_elements.ramp_automatically:render("Auto-Ramp Based on BigWigs Timers")
            ui.menu_elements.ramp_time_before_event:render("Seconds Before Event to Start Ramping")
            
            -- Full Ramp Settings
            ui.menu_elements.full_ramp_tree:render("Full Ramp Settings", function()
                render_section_header("Full Ramp Configuration")
                ui.menu_elements.manual_ramp_key:render("Manual Full Ramp Key")
                ui.menu_elements.ramp_shield_count:render("Number of Shields to Apply in Phase 1")
                
                render_section_header("Phase Timings")
                ui.menu_elements.ramp_phase1_duration:render("Shield Phase Duration (seconds)")
                ui.menu_elements.ramp_phase2_duration:render("Radiance Phase Duration (seconds)")
                ui.menu_elements.ramp_phase3_duration:render("Evangelism Phase Duration (seconds)")
            end)
            
            -- Mini Ramp Settings
            ui.menu_elements.mini_ramp_tree:render("Mini Ramp Settings", function()
                render_section_header("Mini Ramp Configuration")
                ui.menu_elements.mini_ramp_key:render("Manual Mini Ramp Key")
                ui.menu_elements.mini_ramp_shield_count:render("Number of Shields for Mini Ramp")
                ui.menu_elements.mini_ramp_duration:render("Mini Ramp Duration (seconds)")
                
                render_section_header("Health-Based Ramping")
                ui.menu_elements.enable_health_based_ramp:render("Enable Health-Based Mini Ramp")
                ui.menu_elements.health_ramp_threshold:render("Group Health % to Trigger Mini Ramp")
            end)
            
            -- Only show Voidweaver ramping if Voidweaver spec is selected
            if ui.menu_elements.voidweaver_spec:get_state() then
                ui.menu_elements.voidweaver_ramping_tree:render("Voidweaver Ramping", function()
                    -- Major Ramp Settings
                    ui.menu_elements.voidweaver_major_ramp_tree:render("Major Damage Ramp", function()
                        render_section_header("Configuration")
                        ui.menu_elements.enable_voidweaver_ramp:render("Enable Voidweaver Major Ramp")
                        ui.menu_elements.voidweaver_ramp_key:render("Major Ramp Key")
                        ui.menu_elements.voidweaver_renew_count:render("Number of Renews to Apply")
                    end)
                    
                    -- Mini Ramp Settings
                    ui.menu_elements.voidweaver_mini_ramp_tree:render("Minor Damage Ramp", function()
                        render_section_header("Configuration")
                        ui.menu_elements.enable_voidweaver_mini_ramp:render("Enable Voidweaver Mini-Ramp")
                        ui.menu_elements.voidweaver_mini_ramp_key:render("Mini-Ramp Key")
                        ui.menu_elements.voidweaver_mini_shield_count:render("Number of Shields for Mini-Ramp")
                    end)
                end)
            end
        end)
        
        -- Interface Settings
        ui.menu_elements.interface_tree:render("Interface", function()
            render_section_header("Visual Feedback")
            ui.menu_elements.draw_plugin_state:render("Display Script State")
            ui.menu_elements.draw_atonement_count:render("Display Atonement Count")
            ui.menu_elements.draw_ramp_timer:render("Display Ramp Timer")
            ui.menu_elements.draw_heal_thresholds:render("Display Healing Thresholds")
            
            render_section_header("Appearance")
            ui.menu_elements.ui_scale:render("UI Scale %")
        end)
    end)
end

-- Render on-screen UI elements
function ui.render_screen(is_ramping, ramp_phase, ramp_start_time, next_big_damage_time, get_atonement_count, ramp_type)
    local local_player = core.object_manager.get_local_player()
    if not local_player then
        return
    end

    if not ui.menu_elements.enable_script_check:get_state() then
        return
    end

    if not plugin_helper:is_toggle_enabled(ui.menu_elements.enable_toggle) then
        if ui.menu_elements.draw_plugin_state:get_state() then
            plugin_helper:draw_text_character_center("DISABLED")
        end
        return
    end
    
    -- Load color
    local color = color_module
    
    -- Calculate UI scale factor
    local scale_factor = ui.menu_elements.ui_scale:get() / 100.0
    
    -- Display Atonement count if enabled
    if ui.menu_elements.draw_atonement_count:get_state() then
        local atonement_count = get_atonement_count()
        local min_count = ui.menu_elements.min_atonement_count:get()
        
        local display_color = color.white()
        
        -- Color based on count (green for good coverage, yellow for moderate, red for low)
        if atonement_count >= min_count then
            display_color = color.green()
        elseif atonement_count >= 1 then
            display_color = color.yellow()
        else
            display_color = color.red()
        end
        
        plugin_helper:draw_text_character_center("Atonement: " .. atonement_count .. "/" .. min_count, 
                                                display_color, 
                                                20 * scale_factor)
    end
    
    -- Display healing thresholds if enabled
    if ui.menu_elements.draw_heal_thresholds:get_state() then
        local emergency_threshold = ui.menu_elements.emergency_heal_threshold:get()
        local critical_threshold = ui.menu_elements.critical_heal_threshold:get()
        local shield_threshold = ui.menu_elements.shield_threshold:get()
        
        local threshold_text = string.format("Thresholds - Shield: %d%% | Emergency: %d%% | Critical: %d%%", 
                                           shield_threshold, 
                                           emergency_threshold, 
                                           critical_threshold)
                                           
        plugin_helper:draw_text_character_center(threshold_text, 
                                              color.cyan(180), 
                                              40 * scale_factor)
    end
    
    -- Display ramping status if enabled
    if ui.menu_elements.draw_ramp_timer:get_state() and is_ramping then
        local current_time = core.time()
        local elapsed_time = current_time - ramp_start_time
        local time_to_damage = next_big_damage_time - current_time
        
        local phase_text = ""
        local phase_color = color.white()
        
        if ramp_phase == 1 then
            phase_text = "Shielding"
            phase_color = color.blue_pale()
        elseif ramp_phase == 2 then
            phase_text = "Radiance"
            phase_color = color.purple()
        elseif ramp_phase == 3 then
            phase_text = "Evangelism"
            phase_color = color.yellow()
        elseif ramp_phase == 4 then
            phase_text = "Damage Phase"
            phase_color = color.red()
        end
        
        -- Format time nicely
        local damage_timer = string.format("%.1f", time_to_damage)
        
        -- Use ramp type passed from main script
        local ramp_type_text = ramp_type .. " RAMP: "
        
        plugin_helper:draw_text_character_center(ramp_type_text .. phase_text, 
                                              phase_color, 
                                              -20 * scale_factor)
        plugin_helper:draw_text_character_center("Damage in: " .. damage_timer .. "s", 
                                              time_to_damage < 3 and color.red() or color.yellow(), 
                                              -40 * scale_factor)
                                              
        -- Show additional ramp info if applicable
        if ramp_phase == 1 then
            local shield_target = ui.menu_elements.ramp_shield_count:get()
            local phase_duration = ui.menu_elements.ramp_phase1_duration:get()
            local remaining = phase_duration - elapsed_time
            
            if remaining > 0 then
                plugin_helper:draw_text_character_center(
                    string.format("Shield Phase: %.1fs left", remaining),
                    color.blue(200),
                    -60 * scale_factor
                )
            end
        elseif ramp_phase == 2 then
            local phase_duration = ui.menu_elements.ramp_phase2_duration:get()
            local remaining = phase_duration - (elapsed_time - ui.menu_elements.ramp_phase1_duration:get())
            
            if remaining > 0 then
                plugin_helper:draw_text_character_center(
                    string.format("Radiance Phase: %.1fs left", remaining),
                    color.purple(200),
                    -60 * scale_factor
                )
            end
        end
    end
end

-- Render the control panel elements
function ui.render_control_panel()
    local control_panel_elements = {}
    
    -- Enable Toggle on Control Panel
    if ui.menu_elements.enable_toggle then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Enable (" .. key_helper:get_key_name(ui.menu_elements.enable_toggle:get_key_code()) .. ") ",
            keybind = ui.menu_elements.enable_toggle
        })
    end
    
    -- Pain Suppression Toggle
    if ui.menu_elements.pain_suppression_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Pain Suppression (" .. key_helper:get_key_name(ui.menu_elements.pain_suppression_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.pain_suppression_key
        })
    end
    
    -- Power Infusion Toggle
    if ui.menu_elements.power_infusion_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Power Infusion (" .. key_helper:get_key_name(ui.menu_elements.power_infusion_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.power_infusion_key
        })
    end
    
    -- Manual Ramp Toggle
    if ui.menu_elements.manual_ramp_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Full Ramp (" .. key_helper:get_key_name(ui.menu_elements.manual_ramp_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.manual_ramp_key
        })
    end
    
    -- Mini Ramp Toggle
    if ui.menu_elements.mini_ramp_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Mini-Ramp (" .. key_helper:get_key_name(ui.menu_elements.mini_ramp_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.mini_ramp_key
        })
    end
    
    -- Voidweaver Ramp Toggle (only if Voidweaver spec is selected)
    if ui.menu_elements.voidweaver_spec:get_state() and ui.menu_elements.voidweaver_ramp_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[Voidweaver] Major Ramp (" .. key_helper:get_key_name(ui.menu_elements.voidweaver_ramp_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.voidweaver_ramp_key
        })
    end
    
    -- Voidweaver Mini-Ramp Toggle (only if Voidweaver spec is selected)
    if ui.menu_elements.voidweaver_spec:get_state() and ui.menu_elements.voidweaver_mini_ramp_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[Voidweaver] Mini-Ramp (" .. key_helper:get_key_name(ui.menu_elements.voidweaver_mini_ramp_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.voidweaver_mini_ramp_key
        })
    end
    
    -- Mode Toggles
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Raid Mode",
        checkbox = ui.menu_elements.raid_mode
    })
    
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Mythic+ Mode",
        checkbox = ui.menu_elements.mythic_plus_mode
    })
    
    -- Spec Toggles
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Oracle Spec",
        checkbox = ui.menu_elements.oracle_spec
    })
    
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Voidweaver Spec",
        checkbox = ui.menu_elements.voidweaver_spec
    })
    
    -- Healing Style Toggle
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Prioritize Atonement",
        checkbox = ui.menu_elements.prioritize_atonement
    })
    
    -- Emergency Healing Toggle
    control_panel_helper:insert_checkbox(control_panel_elements,
    {
        name = "[DiscPriest] Allow Emergency Healing",
        checkbox = ui.menu_elements.allow_reactive_healing
    })
    
    -- Spirit Shell Toggle
    if ui.menu_elements.spirit_shell_key then
        control_panel_helper:insert_toggle(control_panel_elements,
        {
            name = "[DiscPriest] Spirit Shell (" .. key_helper:get_key_name(ui.menu_elements.spirit_shell_key:get_key_code()) .. ") ",
            keybind = ui.menu_elements.spirit_shell_key
        })
    end

    return control_panel_elements
end

return ui