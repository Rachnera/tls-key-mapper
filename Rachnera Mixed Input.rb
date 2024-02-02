# Foolish attempt at merging Lone Wolf, Cidiomar and Sixth's work to fully support both keyboard an gamepad
# Override VX Ace default Input

module GamepadKeyboardGlue
  # Use VX Ace standard default values as default
  # Ref: https://forums.rpgmakerweb.com/index.php?threads/rpg-maker-pc-game-controls-mv-vx-ace-vx-xp-2003-2000.140758/
  Defaults = {
    :confirm => :X,
    :cancel => :B,
    :mmode => :A,
    :m_pgup => :L1,
    :m_pgdown => :R1,
  }

  def self.bindings
    $gamepad_bindings
  end

  def self.gamepad(method, key)
    return false unless WolfPad.plugged_in?

    Array(GamepadKeyboardGlue.convert(key)).any? { |k| WolfPad.send(method, k) }
  end

  def self.convert(key)
    return [:UP, :L_UP] if self.is_any(key, [:f_up, :m_up])
    return [:DOWN, :L_DOWN] if self.is_any(key, [:f_down, :m_down])
    return [:LEFT, :L_LEFT] if self.is_any(key, [:f_left, :m_left])
    return [:RIGHT, :L_RIGHT] if self.is_any(key, [:f_right, :m_right])

    return self.bindings[:confirm] if self.is_any(key, [:f_confirm, :m_confirm])
    return self.bindings[:cancel] if self.is_any(key, [:f_cancel, :m_cancel, :m_menu])

    self.bindings.each do |binding, button|
      return button if self.is_any(key, [binding])
    end

    nil
  end

  def self.is_any(key, options)
    options.any? { |option| $system[:p1][option].include?(key) }
  end
end

module Input
  def self.update
    WolfPad.update
    GetKeyboardState.call(@state.to_i)
    0.upto(255) do |key|
      if @state[key] & DOWN_STATE_MASK == DOWN_STATE_MASK
        @released[key] = false
        @pressed[key]  = true if (@triggered[key] = !@pressed[key])
        @repeated[key] < 17 ? @repeated[key] += 1 : @repeated[key] = 15
      elsif !@released[key] and @pressed[key]
        @triggered[key] = false
        @pressed[key]   = false
        @repeated[key]  = 0
        @released[key]  = true
      else
        @released[key]  = false
      end
    end
    update_dir
  end

  def self.press?(keys)
    return true if GamepadKeyboardGlue.gamepad(:press?, keys)

    if keys.is_a?(Numeric)
      k = keys.to_i
      return (@pressed[k] and !@triggered[k])
    elsif keys.is_a?(Array)
      return keys.any? {|key| self.press?(key) }
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| (@pressed[key]  and !@triggered[key]) }
      elsif (KEYMAP.key?(keys))
        k = KEYMAP[keys]
        return (@pressed[k] and !@triggered[k])
      else
        return false
      end
    end
  end

  def self.trigger?(keys)
    return true if GamepadKeyboardGlue.gamepad(:trigger?, keys)

    if keys.is_a?(Numeric)
      return @triggered[keys.to_i]
    elsif keys.is_a?(Array)
      return keys.any? {|key| @triggered[key]}
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| @triggered[key]}
      elsif KEYMAP.key?(keys)
        return @triggered[KEYMAP[keys]]
      else
        return false
      end
    end
  end

  def self.repeat?(keys)
    return true if GamepadKeyboardGlue.gamepad(:repeat?, keys)

    if keys.is_a?(Numeric)
      key = keys.to_i
      return @repeated[key] == 1 || @repeated[key] == 16
    elsif keys.is_a?(Array)
      return keys.any? {|key| @repeated[key] == 1 || @repeated[key] == 16}
    elsif keys.is_a?(Symbol)
      if SYM_KEYS.key?(keys)
        return SYM_KEYS[keys].any? {|key| @repeated[key] == 1 || @repeated[key] == 16}
      elsif KEYMAP.key?(keys)
        return @repeated[KEYMAP[keys]] == 1 || @repeated[KEYMAP[keys]] == 16
      else
        return false
      end
    end
  end

  def self.dir4
    return WolfPad.dir4 if WolfPad.plugged_in? and WolfPad.dir4 > 0

    @dir4 = 0 if @dir4.nil?
    return @dir4
  end

  def self.dir8
    return WolfPad.dir8 if WolfPad.plugged_in? and WolfPad.dir8 > 0

    @dir8 = 0 if @dir8.nil?
    return @dir8
  end
end

class Scene_GamepadConfig < Scene_Base
  def start
    super
    init_main_win
  end

  def init_main_win
    @window = Window_GamepadConfig.new
    @window.set_handler(:cancel, method(:on_cancel))
  end

  def on_cancel
    return_scene
  end
end

# Heavily copy-pasted from Sixth's code, some lines might be dead branches I forgot to prune
class Window_GamepadConfig < Window_Command
    attr_accessor :data

  def initialize()
    @data = $gamepad_bindings
    @grps_data = ConfigScene::Windows[:list]
    xx = GrPS.get(@grps_data[:pos][0])
    yy = GrPS.get(@grps_data[:pos][1])
    super(xx,yy)
    activate
    select(0)
    self.opacity = ConfigScene::Windows[:list][:opa]
    self.z = ConfigScene::Windows[:list][:z]
    self.windowskin = Cache.system(ConfigScene::Windows[:list][:skin])
  end

  def window_width
    return GrPS.get(@grps_data[:size][0])
  end

  def window_height
    return GrPS.get(@grps_data[:size][1])
  end

  def item_width
    full = width - standard_padding * 2 + spacing
    mod = GrPS.get(ConfigScene::ListVisual[:padding])
    return full - mod - spacing * 2
  end

  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    mod = GrPS.get(ConfigScene::ListVisual[:padding])
    rect.x = mod + spacing
    rect.y = index * item_height
    rect
  end

  def make_command_list
    @data.each do |key, btn|
      add_command(btn.to_s, key, true, btn)
    end
  end

  def draw_item(index)
    rct = item_rect(index)
    draw_key_buttons(index,rct)
  end

  def draw_key_buttons(index, rect)
    color = ConfigScene::ListVisual[:boxes][:keys]
    draw_back_box(rect.x, rect.y+1, rect.width, rect.height-2, color)
    set_font_opts(ConfigScene::ListVisual[:font][:keys])
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end

  def refresh
    super
    draw_button_names
  end

  def draw_button_names
    mod = GrPS.get(ConfigScene::ListVisual[:padding])
    set_font_opts(ConfigScene::ListVisual[:font][:names])
    @data.each_with_index do |(key, btn), i|
      yy = i * item_height
      color = ConfigScene::ListVisual[:boxes][:names]
      draw_back_box(0,yy+1,mod,item_height-2,color)
      txt = ConfigScene::Buttons[key]
      draw_text(4,yy,mod-8,item_height,txt)
    end
  end
end

module System
  class << self
    alias_method :original_init, :init
  end

  def self.init
    original_init

    # TODO Save and load from file
    $gamepad_bindings = GamepadKeyboardGlue::Defaults.clone
  end
end
