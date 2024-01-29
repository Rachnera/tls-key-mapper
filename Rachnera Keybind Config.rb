### Default values ###

# Use VX Ace standard default values as default
# Ref: https://forums.rpgmakerweb.com/index.php?threads/rpg-maker-pc-game-controls-mv-vx-ace-vx-xp-2003-2000.140758/
System::Defaults[:p1][:f_up] = System::Defaults[:p1][:m_up] = [:UP, :NUMPAD8]
System::Defaults[:p1][:f_down] = System::Defaults[:p1][:m_down] = [:DOWN, :NUMPAD2]
System::Defaults[:p1][:f_left] = System::Defaults[:p1][:m_left] = [:LEFT, :NUMPAD4]
System::Defaults[:p1][:f_right] = System::Defaults[:p1][:m_right] = [:RIGHT, :NUMPAD6]
System::Defaults[:p1][:f_confirm] = System::Defaults[:p1][:m_confirm] = [:RETURN, :SPACE]
System::Defaults[:p1][:f_cancel] = System::Defaults[:p1][:m_cancel] = System::Defaults[:p1][:m_menu] = [:ESCAPE, :LETTER_X, :NUMPAD0]
System::Defaults[:p1][:m_pgdown] = [:LETTER_W,:NEXT]

### Playing nice with other scripts ###

# Repair Yanfly autodash
class Game_Player < Game_Character
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle

    dash = false
    dash = !dash if $game_system.autodash?
    dash = !dash if Input.press_ex?($system[:p1][:mmode])

    return dash
  end
end
ConfigScene::ButtonHelps[:mmode] = "Hold to dash instead of walking or to walk instead of dashing."

# Repair Hime Message Skip
class Window_Message < Window_Base
  def skip_key_pressed?
    return false if $game_switches[TH::Message_Skip::Disable_Switch]

    return Input.press_ex?($system[:p1][:skip])
  end

  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger_ex?($system[:p1][:f_confirm]+$system[:p1][:f_cancel]) || skip_key_pressed?
    Input.update
    self.pause = false
  end
end
ConfigScene::Buttons[:skip] = "Fast text"
ConfigScene::ButtonHelps[:skip] = "Hold to auto-advance text (skips quickly when paired with instant text)."
System::ButtonRules[:p1][:skip] = {:must_set => true }
ConfigScene::Categs[:p1_map][:list].push(:skip)
System::Defaults[:p1][:skip] = [:CONTROL]

### Disable unused options

# Save the config in a file instead of having it been lost every time the game is closed
System::Reload = false

# Save controls in game directory (alongside the other save files) instead of AppData
System::DPath = ""
System::SPath = []

# Don't reserve keys for (unsupported) mouse-based movement
System::Defaults[:p1][:f_move] = []
ConfigScene::Categs[:p1_map][:list].delete(:f_move)

# Hide NOT USED! keys
[:inventory, :status, :craft, :quest, :cards, :map, :options].each do |key|
  System::Defaults[:p1][key] = []
  ConfigScene::Categs[:p1_shortcuts][:list].delete(key)
end

[:resolution, :qload, :qsave, :help].each do |key|
  System::Defaults[:system][key] = []
  ConfigScene::Categs[:system][:list].delete(key)
end

[:item_1, :item_2, :skill_1, :skill_2, :skill_3, :special].each do |key|
  System::Defaults[:p1][key] = []
end
ConfigScene::Categs.delete(:p1_battlekeys)

System::Defaults[:p1][:mtype] = []
ConfigScene::Categs[:p1_map][:list].delete(:mtype)

# Hide debug options
System::Defaults[:system][:debug] = []
ConfigScene::Categs[:system][:list].delete(:debug)
System::Defaults[:p1][:d_through] = []
ConfigScene::Categs[:p1_map][:list].delete(:d_through)

# Allow up to 3 different keys to be bound to a feature
ConfigScene::Categs.each_key do |key|
  ConfigScene::Categs[key][:max] = 3
end
ConfigScene::ListVisual[:padding] = 100

# Lock screen resolution buttons
System::ButtonRules[:system][:fullscreen][:can_change] = []
System::ButtonRules[:system][:screenratio][:can_change] = []
