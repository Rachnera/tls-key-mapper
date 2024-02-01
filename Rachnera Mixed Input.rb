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
    # TODO Give the ability to configure this
    Defaults
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
    return WolfPad.dir4 if WolfPad.plugged_in?

    @dir4 = 0 if @dir4.nil?
    return @dir4
  end

  def self.dir8
    return WolfPad.dir8 if WolfPad.plugged_in?

    @dir8 = 0 if @dir8.nil?
    return @dir8
  end
end
