### Default values ###

# Use VX Ace standard default values as default
# Ref: https://forums.rpgmakerweb.com/index.php?threads/rpg-maker-pc-game-controls-mv-vx-ace-vx-xp-2003-2000.140758/
System::Defaults[:p1][:up] = System::Defaults[:p1][:f_up] = System::Defaults[:p1][:m_up] = [:UP, :NUMPAD8]
System::Defaults[:p1][:down] = System::Defaults[:p1][:f_down] = System::Defaults[:p1][:m_down] = [:DOWN, :NUMPAD2]
System::Defaults[:p1][:left] = System::Defaults[:p1][:f_left] = System::Defaults[:p1][:m_left] = [:LEFT, :NUMPAD4]
System::Defaults[:p1][:right] = System::Defaults[:p1][:f_right] = System::Defaults[:p1][:m_right] = [:RIGHT, :NUMPAD6]
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
System::ButtonRules[:p1][:skip] = { :must_set => true }
ConfigScene::Categs[:p1_map][:list].push(:skip)
System::Defaults[:p1][:skip] = [:CONTROL]

# Configure Lord Forte VN-style Backlog
class Scene_Map < Scene_Base
  alias original_update update
  def update
    return original_update unless Input.trigger_ex?($system[:p1][:backlog]) and not @window_log

    @window_log = Window_MessageLog.new
    update_message_log
  end
end
class Scene_Battle < Scene_Base
  alias original_update update
  def update
    return original_update unless Input.trigger_ex?($system[:p1][:backlog]) and not @window_log

    @window_log = Window_MessageLog.new
    update_message_log
  end
end
ConfigScene::Buttons[:backlog] = "Backlog"
ConfigScene::ButtonHelps[:backlog] = "Open VN-style text backlog."
System::ButtonRules[:p1][:backlog] = { :must_set => true }
ConfigScene::Categs[:p1_map][:list].push(:backlog)
System::Defaults[:p1][:backlog] = [:LETTER_D]

# Retro-compatibility with existing party swap code
module Input
  class << self
    alias_method :original_press?, :press?
  end

  def self.press?(keys)
    # 18 -> R button, cf EventsKeyCodes in Cidiomar's Input System
    return self.press_ex?($system[:p1][:party_switch]) if keys == 18

    original_press?(keys)
  end
end
ConfigScene::Buttons[:party_switch] = "Party switch"
ConfigScene::ButtonHelps[:party_switch] = "Used in some specific events only."
System::ButtonRules[:p1][:party_switch] = { :must_set => true }
ConfigScene::Categs[:p1_map][:list].push(:party_switch)
System::Defaults[:p1][:party_switch] = [:LETTER_W]

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

### Rework key binding menu ###

# Move field keys first
field_keys = ConfigScene::Categs[:p1_map]
ConfigScene::Categs.delete(:p1_map)
ConfigScene::Categs = { :p1_map => field_keys }.merge!(ConfigScene::Categs)

# Move system keys last
system_keys = ConfigScene::Categs[:system]
ConfigScene::Categs.delete(:system)
ConfigScene::Categs[:system] = system_keys

# Lock keys that are only problems in the making if bound differently
System::ButtonRules[:system][:fullscreen][:can_change] = []
System::ButtonRules[:system][:screenratio][:can_change] = []
ConfigScene::Categs[:system][:help] = "Useful, unalterable, system keys."

# Better (?) descriptions
ConfigScene::Buttons[:m_clear] = "Unbind"
ConfigScene::ButtonHelps[:m_clear] = "Unassign a key. Used solely in this very configuration screen."

# Configure movement/confirm/cancel only once
general_keys = {
  :name => "General",
  :help => "Main keys.",
  :list => [],
  :max => 3,
  :type => :buttons,
  :setting => [:p1],
}
ConfigScene::Categs = { :p1_main => general_keys }.merge!(ConfigScene::Categs)

module MultiKeyBind
  FusedKeys = {
    :up => { :name => "Up", :description => "Move character/cursor upward.", :supersede => [:f_up, :m_up] },
    :down => { :name => "Down", :description => "Move character/cursor downward.", :supersede => [:f_down, :m_down] },
    :left => { :name => "Left", :description => "Move character/cursor leftward.", :supersede => [:f_left, :m_left] },
    :right => { :name => "Right", :description => "Move character/cursor rightward.", :supersede => [:f_right, :m_right] },
  }

  FusedKeys.each do |key, cf|
    ConfigScene::Buttons[key] = cf[:name]
    ConfigScene::ButtonHelps[key] = cf[:description]
    System::ButtonRules[:p1][key] = { :must_set => true }
    ConfigScene::Categs[:p1_main][:list].push(key)

    # Hide superseded keys
    cf[:supersede].each do |key|
      ConfigScene::Categs.each_key do |cat|
        ConfigScene::Categs[cat][:list].delete(key)
      end
    end
  end
end

class Window_ConfigPop < Window_Base
  alias_method :original_change_the_buttons, :change_the_buttons

  def change_the_buttons
    original_change_the_buttons

    if MultiKeyBind::FusedKeys.has_key?(@funct)
      MultiKeyBind::FusedKeys[@funct][:supersede].each do |key|
        # I have no idea how this works
        path = @list_data[:setting]+[key]
        System.nest($system,*path)
      end
    end
  end
end
