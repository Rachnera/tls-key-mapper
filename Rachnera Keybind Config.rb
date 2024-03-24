#==============================================================================
# TLS specific keyboard/gamepad configuration
# by Rachnera
#------------------------------------------------------------------------------
# Ensuring there's no conflict with the numerous other scripts used by TLS
# Code to open the input config menu: SceneManager.call(Scene_InputConfigMain)
#==============================================================================

### Default values ###

# Use VX Ace standard default values as baseline defaults
# Ref: https://forums.rpgmakerweb.com/index.php?threads/rpg-maker-pc-game-controls-mv-vx-ace-vx-xp-2003-2000.140758/
System::Defaults[:p1][:up] = System::Defaults[:p1][:f_up] = System::Defaults[:p1][:m_up] = [:UP, :NUMPAD8]
System::Defaults[:p1][:down] = System::Defaults[:p1][:f_down] = System::Defaults[:p1][:m_down] = [:DOWN, :NUMPAD2]
System::Defaults[:p1][:left] = System::Defaults[:p1][:f_left] = System::Defaults[:p1][:m_left] = [:LEFT, :NUMPAD4]
System::Defaults[:p1][:right] = System::Defaults[:p1][:f_right] = System::Defaults[:p1][:m_right] = [:RIGHT, :NUMPAD6]
System::Defaults[:p1][:confirm] = System::Defaults[:p1][:f_confirm] = System::Defaults[:p1][:m_confirm] = [:SPACE, :LETTER_Z, :RETURN]
System::Defaults[:p1][:cancel] = System::Defaults[:p1][:f_cancel] = System::Defaults[:p1][:m_cancel] = System::Defaults[:p1][:m_menu] = [:ESCAPE, :LETTER_X, :NUMPAD0, :INSERT]
System::Defaults[:p1][:m_pgup] = [:LETTER_Q, :PRIOR, :NUMPAD9]
System::Defaults[:p1][:m_pgdown] = [:LETTER_W, :NEXT, :NUMPAD3]

### Playing nice with other scripts ###

# Repair Yanfly autodash and standard debug through
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

  def debug_through?
    $TEST && Input.press_ex?($system[:p1][:d_through])
  end
end
ConfigScene::ButtonHelps[:mmode] = "Hold to dash instead of walking or to walk instead of dashing."

# Repair Yanfly Party System
class Window_PartySelect < Window_Selectable
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger_ex?($system[:p1][:m_confirm])
    return process_cancel   if cancel_enabled?    && Input.trigger_ex?($system[:p1][:m_cancel])
    return process_pagedown if handle?(:pagedown) && Input.trigger_ex?($system[:p1][:m_pgdown])
    return process_pageup   if handle?(:pageup)   && Input.trigger_ex?($system[:p1][:m_pgup])
  end
end

# Repair Yanfly Battle Engine
class Scene_Battle < Scene_Base
  def show_fast?
    return true unless $game_system.animations?
    return true if YEA::BATTLE::AUTO_FAST
    return Input.press_ex?($system[:p1][:m_confirm])
  end
end

# Repair Yanfly Shop
class Window_ShopNumber < Window_Selectable
  def update_number
    # Default behavior missed by Sixth in their script
    change_number(1)   if Input.repeat_ex?($system[:p1][:right])
    change_number(-1)  if Input.repeat_ex?($system[:p1][:left])
    change_number(10)  if Input.repeat_ex?($system[:p1][:up])
    change_number(-10) if Input.repeat_ex?($system[:p1][:down])

    # Yanfly specific
    change_number(-@max) if Input.repeat_ex?($system[:p1][:m_pgdown])
    change_number(@max)  if Input.repeat_ex?($system[:p1][:m_pgup])
  end
end

# Repair Yanfly Options menu
class Window_SystemOptions < Window_Command
  # Must be a button that already does something within a menu context
  INCREMENT_TIMES_TEN = :confirm

  def change_window_tone(direction)
    Sound.play_cursor
    value = increment_value(direction)
    tone = $game_system.window_tone.clone
    case current_symbol
    when :window_red; tone.red += value
    when :window_grn; tone.green += value
    when :window_blu; tone.blue += value
    end
    $game_system.window_tone = tone
    draw_item(index)
  end

  def change_volume(direction)
    Sound.play_cursor
    value = increment_value(direction)
    case current_symbol
    when :volume_bgm
      $game_system.volume_change(:bgm, value)
      RPG::BGM::last.play
    when :volume_bgs
      $game_system.volume_change(:bgs, value)
      RPG::BGS::last.play
    when :volume_sfx
      $game_system.volume_change(:sfx, value)
    end
    draw_item(index)
  end

  def change_custom_variables(direction)
    Sound.play_cursor
    value = increment_value(direction)
    ext = current_ext
    var = YEA::SYSTEM::CUSTOM_VARIABLES[ext][0]
    minimum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][4]
    maximum = YEA::SYSTEM::CUSTOM_VARIABLES[ext][5]
    $game_variables[var] += value
    $game_variables[var] = [[$game_variables[var], minimum].max, maximum].min
    draw_item(index)
  end

  def increment_value(direction)
    value = direction == :left ? -1 : 1
    value *= 10 if Input.press_ex?($system[:p1][INCREMENT_TIMES_TEN])
    value
  end
end

# Repair Hime Message Skip and ATS: Message Options scroll
class Window_Message < Window_Base
  def skip_key_pressed?
    return false if $game_switches[TH::Message_Skip::Disable_Switch]

    return Input.press_ex?($system[:p1][:skip])
  end

  def input_pause
    return if @atsf_testing
    $game_message.pause_se.play if $game_message.atsmo_play_sound?(:pause)

    self.pause = true
    wait(10)
    @scroll_review_max_oy = contents.height - contents_height
    until Input.trigger_ex?($system[:p1][:f_confirm]+$system[:p1][:f_cancel]) || skip_key_pressed?
      update_scroll_review
      Fiber.yield
    end
    self.oy = @scroll_review_max_oy
    Input.update
    self.pause = false
  end

  def update_scroll_review
    if Input.press_ex?($system[:p1][:m_up])
      self.oy -= [4, self.oy].min
    elsif Input.press_ex?($system[:p1][:m_down])
      self.oy += [4, @scroll_review_max_oy - self.oy].min
    end
  end
end
ConfigScene::Buttons[:skip] = "Fast text"
ConfigScene::ButtonHelps[:skip] = "Hold to auto-advance text (skips quickly when paired with instant text)."
System::ButtonRules[:p1][:skip] = { :must_set => true, :same_key => System::PresetRules[:field1] }
ConfigScene::Categs[:p1_map][:list].push(:skip)
System::Defaults[:p1][:skip] = [:CONTROL]
GamepadKeyboardGlue::Defaults[:skip] = :L1
GamepadKeyboardGlue::Scopes[:skip] = :field_only

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
class Window_MessageLog < Window_Base
  def update
    super
    update_anime
    return if @opening || @closing
    dispose if close?
    if !self.disposed? && self.open?
      if Input.trigger_ex?($system[:p1][:m_cancel])
        Sound.play_cancel
        close
      elsif Input.repeat_ex?($system[:p1][:m_up])
        self.index = @index - 1
      elsif Input.repeat_ex?($system[:p1][:m_down])
        self.index = @index + 1
      elsif Input.repeat_ex?($system[:p1][:m_left])
        self.index = @index - 5
      elsif Input.repeat_ex?($system[:p1][:m_right])
        self.index = @index + 5
      elsif Input.repeat_ex?($system[:p1][:m_pgup])
        self.index = @index - 15
      elsif Input.repeat_ex?($system[:p1][:m_pgdown])
        self.index = @index + 15
      end
    end
  end
end
ConfigScene::Buttons[:backlog] = "Backlog"
ConfigScene::ButtonHelps[:backlog] = "Open VN-style text backlog."
System::ButtonRules[:p1][:backlog] = { :must_set => true, :same_key => System::PresetRules[:field1] }
ConfigScene::Categs[:p1_map][:list].push(:backlog)
System::Defaults[:p1][:backlog] = [:LETTER_D, :LETTER_L]
GamepadKeyboardGlue::Defaults[:backlog] = :R2

# Restore modern algebra Quest Journal
class Scene_Map < Scene_Base
  def update_call_quest_journal
    if $game_map.interpreter.running?
      @quest_journal_calling = false
    else
      if Input.trigger_ex?($system[:p1][:quest])
        $game_system.quest_access_disabled || $game_party.quests.list.empty? ?
          Sound.play_buzzer : @quest_journal_calling = true
      end
      call_quest_journal if @quest_journal_calling && !$game_player.moving?
    end
  end
end
class Window_QuestData < Window_Selectable
  def update(*args, &block)
    super(*args, &block)
    if open? && active && @dest_scroll_oy == self.oy
      scroll_down if Input.press_ex?($system[:p1][:m_down])
      scroll_up if Input.press_ex?($system[:p1][:m_up])
    end
    if self.oy != @dest_scroll_oy
      mod = (@dest_scroll_oy <=> self.oy)
      self.oy += 3*mod
      self.oy = @dest_scroll_oy if (@dest_scroll_oy <=> self.oy) != mod
    end
  end
end
class Scene_Quest < Scene_MenuBase
  def update_all_windows(*args, &block)
    @quest_category_window.deactivate if @quest_category_window &&
      QuestData::CONCURRENT_ACTIVITY && @quest_list_window.active &&
      Input.trigger_ex?($system[:p1][:m_confirm])
    super(*args, &block)
    @quest_category_window.activate if @quest_category_window &&
      QuestData::CONCURRENT_ACTIVITY && @quest_list_window.active
  end
end

# Retro-compatibility with existing party swap code and efeberk Message Visibility
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
class Window_Message < Window_Base
  alias previous_258_update update
  def update
    previous_258_update
    if Input.trigger_ex?($system[:p1][:party_switch])
      self.visible = !self.visible
    end
  end
end
ConfigScene::Buttons[:party_switch] = "Hide/Switch"
ConfigScene::ButtonHelps[:party_switch] = "Hide text until advanced.\nAlso used to switch between parties during certain segments."
System::ButtonRules[:p1][:party_switch] = { :must_set => true }
ConfigScene::Categs[:p1_map][:list].push(:party_switch)
System::Defaults[:p1][:party_switch] = [:LETTER_W, :LETTER_H]
GamepadKeyboardGlue::Defaults[:party_switch] = :R1
GamepadKeyboardGlue::Scopes[:party_switch] = :field_only

# Integrate with Yanfly config menu
YEA::SYSTEM::COMMANDS.insert(YEA::SYSTEM::COMMANDS.find_index(:reset_opts), :keyboard)
YEA::SYSTEM::COMMAND_VOCAB[:keyboard] = ["Keyboard Settings", "None", "None", "Bind controls to different/additional keys."]

YEA::SYSTEM::COMMANDS.insert(YEA::SYSTEM::COMMANDS.find_index(:reset_opts), :gamepad)
YEA::SYSTEM::COMMAND_VOCAB[:gamepad] = ["Gamepad Settings", "None", "None", "Rebind gamepad buttons.\nRequires a pad to be plugged."]

class Window_SystemOptions < Window_Command
  alias_method :original_ok_enabled?, :ok_enabled?
  alias_method :original_draw_item, :draw_item

  def ok_enabled?
    return true if current_symbol == :keyboard
    return true if current_symbol == :gamepad

    original_ok_enabled?
  end

  def draw_item(index)
    if [:keyboard, :gamepad].include?(@list[index][:symbol])
      reset_font_settings
      rect = item_rect(index)
      contents.clear_rect(rect)
      return draw_text(item_rect_for_text(index), command_name(index), 1)
    end

    original_draw_item(index)
  end

  def make_command_list
    @help_descriptions = {}
    for command in YEA::SYSTEM::COMMANDS
      case command
      when :blank
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = description_msg(command)
      when :window_red, :window_grn, :window_blu
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = description_msg(command)
      when :volume_bgm, :volume_bgs, :volume_sfx
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = description_msg(command)
      when :autodash, :instantmsg, :animations
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = description_msg(command)
      when :reset_opts, :to_title, :shutdown, :keyboard, :gamepad
        add_command(YEA::SYSTEM::COMMAND_VOCAB[command][0], command)
        @help_descriptions[command] = description_msg(command)
      else
        process_custom_switch(command)
        process_custom_variable(command)
      end
    end
  end

  def description_msg(command)
    msg = YEA::SYSTEM::COMMAND_VOCAB[command][3]

    if msg.include?("SHIFT")
      actual_key = TextHelper.key_name(Window_SystemOptions::INCREMENT_TIMES_TEN)
      actual_button = TextHelper.btn_name(Window_SystemOptions::INCREMENT_TIMES_TEN)
      msg = msg.gsub('SHIFT', actual_key + " (" + actual_button + " on pad)")
    end

    msg
  end
end

class Scene_System < Scene_MenuBase
  alias_method :original_create_command_window, :create_command_window
  alias_method :original_command_reset_opts, :command_reset_opts

  def create_command_window
    original_create_command_window
    @command_window.set_handler(:keyboard, method(:command_keyboard))
    @command_window.set_handler(:gamepad, method(:command_gamepad))
  end

  def command_keyboard
     SceneManager.call(ConfScene)
  end

  def command_gamepad
    unless WolfPad.plugged_in?
      @popup_window = Window_PopupMessage_GamepadAsKeyboard.new
      @popup_window.set_handler(:ok, method(:clean_popup))
      @popup_window.set_handler(:cancel, method(:clean_popup))
      @popup_window.activate
      @help_window.hide
      @command_window.hide
      return
    end

     SceneManager.call(Scene_GamepadConfig)
  end

  def command_reset_opts
    System.reset_keyboard_bindings
    System.reset_gamepad_bindings

    original_command_reset_opts
  end

  def clean_popup
    @popup_window.dispose
    @popup_window = nil
    @help_window.show
    @command_window.show
    @command_window.activate
  end
end

class Window_PopupMessage < Window_Selectable
  def initialize(txt, max_line_numbers)
    width = Graphics.width - 80
    height = max_line_numbers * line_height + standard_padding * 2

    super((Graphics.width - width) / 2, (Graphics.height - height) / 2, width, height)

    formatted_txt = mapf_format_paragraph(txt)
    draw_text_ex(0, 0, formatted_txt)
  end
end

class Window_PopupMessage_GamepadAsKeyboard < Window_PopupMessage
  MESSAGE = "No gamepad detected.\n—\nIf you are using one right now, and it seems to be responding just fine, it might be detected as a keyboard instead (don't ask) and you might be able to configure it by using the \eC[1]Keyboard Settings\eC[0] option instead."
  WINDOW_HEIGHT = 8

  def initialize
    super(MESSAGE, WINDOW_HEIGHT)
  end
end

# Remove default call from main menu
class Window_MenuCommand < Window_Command
  alias_method :original_make_command_list, :make_command_list

  def make_command_list
    original_make_command_list
    @list.reject! { |command| command[:symbol] == :controls }
  end
end

### Disable unused options

# Save the config in a file instead of having it been lost every time the game is closed
System::Reload = false

# Save controls in game directory (alongside the other save files) instead of AppData
System::DPath = ""
System::SPath = []

# Rename files so that they are excluded on export
System::FileName = "Save777.rvdata2"
GamepadKeyboardGlue::File = "Save666.rvdata2"

module DataManager
  def self.save_file_exists?
    # Ignore "global" config files
    files = Dir.glob('Save*.rvdata2').reject { |filename| [System::FileName, GamepadKeyboardGlue::File].include?(filename) }

    !files.empty?
  end
end

# Don't reserve keys for (unsupported) mouse-based movement
System::Defaults[:p1][:f_move] = []
ConfigScene::Categs[:p1_map][:list].delete(:f_move)

# Hide NOT USED! keys
[:inventory, :status, :craft, :quest, :cards, :map, :options].each do |key|
  System::Defaults[:p1][key] = []
  ConfigScene::Categs[:p1_shortcuts][:list].delete(key)
end

# Restore quest key, but as a standard field key
ConfigScene::Categs[:p1_map][:list].push(:quest)
System::Defaults[:p1][:quest] = [:LETTER_Q, :PRIOR]
GamepadKeyboardGlue::Defaults[:quest] = :L2
GamepadKeyboardGlue::Scopes[:quest] = :field_only

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

module System
  class << self
    alias_method :original_741_init, :init
  end

  def self.init
    original_741_init

    # If new keys have been added since the file was created, setup them with their default values
    System::Defaults[:p1].each do |key, value|
      $system[:p1][key] = value.clone if $system[:p1][key].nil? or $system[:p1][key].empty?
    end

    # Hardcode debug keys as there's little point letting the player configure them
    $system[:system][:debug] = [:F9]
    $system[:p1][:d_through] = [:CONTROL]
  end

  def self.reset_keyboard_bindings
    load_defaults
    save_data($system, System.check_sys_file)
  end
end

# Allow up to 3 different keys to be bound to a feature as a default
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
ConfigScene::ButtonHelps[:m_toggle] += "\nOnly used in shops."

# Configure movement/confirm/cancel only once
general_keys = {
  :name => "General",
  :help => "Main keys.",
  :list => [],
  :max => 4,
  :type => :buttons,
  :setting => [:p1],
}
ConfigScene::Categs = { :p1_main => general_keys }.merge!(ConfigScene::Categs)

module MultiKeyBind
  FusedKeys.each do |key, cf|
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

ConfigScene::Categs.delete(:p1_shortcuts)

### Add to start menu ###

class Window_TitleCommand
  alias original_546_make_command_list make_command_list
  def make_command_list(*args, &block)
    original_546_make_command_list(*args, &block)

    @list.insert(
      @list.find_index { |command| command[:name] == "Patreon" },
      { :name => "Controls", :symbol => :controls, :enabled => true }
    )
  end
end
class Scene_Title
  alias original_546_create_command_window create_command_window
  def create_command_window(*args, &block)
    original_546_create_command_window(*args, &block)
    @command_window.set_handler(:controls, method(:open_controls_menu))
  end

  def open_controls_menu
    SceneManager.call(Scene_InputConfigMain)
  end
end

class Window_InputConfigMain < Window_Command
  def initialize()
    super(0, 0)
    self.x = (Graphics.width - window_width) / 2
    self.y = (Graphics.height - window_height) / 2
  end

  def make_command_list
    add_command("Keyboard Settings", :keyboard)
    add_command("Gamepad Settings", :gamepad)
    add_command("Reset to default", :reset)
    add_command("Return", :exit)
  end

  def window_width
    240
  end
end
class Scene_InputConfigMain < Scene_Base
  def start
    super
    create_window
  end

  def create_window
    @window = Window_InputConfigMain.new
    @window.set_handler(:keyboard, method(:keyboard))
    @window.set_handler(:gamepad, method(:gamepad))
    @window.set_handler(:reset, method(:reset))
    @window.set_handler(:cancel, method(:exit))
    @window.set_handler(:exit, method(:exit))
  end

  def keyboard
    SceneManager.call(ConfScene)
  end

  def gamepad
    unless WolfPad.plugged_in?
      return SceneManager.call(Scene_PopupMessage_GamepadAsKeyboard)
    end

    SceneManager.call(Scene_GamepadConfig)
  end

  def reset
    System.reset_keyboard_bindings
    System.reset_gamepad_bindings
    @window.activate
  end

  def exit
    return_scene
  end
end

class Scene_PopupMessage_GamepadAsKeyboard < Scene_Base
  def start
    super

    @window = Window_PopupMessage_GamepadAsKeyboard.new
    @window.set_handler(:ok, method(:exit))
    @window.set_handler(:cancel, method(:exit))
    @window.activate
  end

  def exit
    return_scene
  end
end

module TextHelper
  def self.key_name(feature)
    ConfigScene::Keys[$system[:p1][feature].compact.first][:name]
  end

  def self.btn_name(feature)
    $gamepad_bindings[feature].to_s
  end
end
