#===============================================================================
# * [ACE] Control Configuration System - Default Input Check Methods
#===============================================================================
# * Made by: Sixth (www.rpgmakervxace.net, www.forums.rpgmakerweb.com)
# * Version: 1.5
# * Updated: 04/07/2017
# * Requires: Neon Black's Keyboard Input (or another keyboard script)
#        /--> Shaz's Super Simple Mouse - modified (or another mouse script)
#        \----- Only if you want to enable mouse usage!
#-------------------------------------------------------------------------------
# * < Description >
#-------------------------------------------------------------------------------
# * This script will completely replace the default input check methods with 
#   the ones used by this control system.
# * If you don't change the sample settings I provided for the default 
#   functions, you don't need to change anything here. 
#   However, if you changed something in those, you will also need to change 
#   the path and/or function names used here too or else you will break your
#   game! Who would play a game without any control over the controls? :D
# * Note that this script overwrites many default methods, so if you have any
#   scripts aliasing these, you should put those below this one!
#===============================================================================
module Input

  def self.pref_ax 
    @pref_ax = '' if @pref_ax.nil?
    return @pref_ax
  end

  def self.pref_ax=(val)
    @pref_ax = val
  end
      
  def self.dir4
    @dir4 = 0 if @dir4.nil?
    return @dir4
  end
  
  def self.dir4=(val)
    @dir4 = val
  end

  def self.dir8
    @dir8 = 0 if @dir8.nil?
    return @dir8
  end
  
  def self.dir8=(val)
    @dir8 = val
  end

  def self.update_dir
    xx = self.get_x
    yy = self.get_y
    self.dir8 = self.num_dir(xx,yy)
    if xx != 0 && yy != 0
      if self.pref_ax == 'x'
        yy = 0
      else
        xx = 0
      end
    elsif xx != 0
      self.pref_ax = 'y'
    elsif yy != 0
      self.pref_ax = 'x'
    end
    self.dir4 = self.num_dir(xx,yy)
  end
  
  def self.get_x
    xx = 0
    xx -= 1 if self.press_ex?($system[:p1][:f_left])
    xx += 1 if self.press_ex?($system[:p1][:f_right])
    return xx
  end
  
  def self.get_y
    yy = 0
    yy -= 1 if self.press_ex?($system[:p1][:f_up])
    yy += 1 if self.press_ex?($system[:p1][:f_down])
    return yy
  end
  
  def self.num_dir(x,y)
    if x != 0 || y != 0
      return 5 - y * 3 + x
    else
      return 0
    end
  end
       
  class << self; alias fix_dirs7761 update; end
  def self.update
    fix_dirs7761
    update_dir
  end

end

class Game_Player < Game_Character
 
  attr_accessor :run_flag, :debug_flag
  
  alias add_run_toggle7644 initialize
  def initialize
    add_run_toggle7644
    @run_flag = true
    @debug_flag = false
  end
  
  alias run_toggle9422 update
  def update
    @run_flag = !@run_flag if Input.trigger_ex?($system[:p1][:mmode])
    @debug_flag = !@debug_flag if Input.trigger_ex?($system[:p1][:d_through])
    run_toggle9422
  end
  
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    if last_moving
      $game_party.on_player_walk
      return if check_touch_event
    end
    if movable? && Input.trigger_ex?($system[:p1][:f_confirm])
      return if get_on_off_vehicle
      return if check_action_event
    end
    update_encounter if last_moving
  end
 
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
    return false if vehicle
    return @run_flag
  end
  
  def debug_through?
    $TEST && @debug_flag
  end
  
  def update_encounter
    return if debug_through?
    return if $game_party.encounter_none?
    return if in_airship?
    return if @move_route_forcing
    @encounter_count -= encounter_progress_value
  end

end

class Window_Selectable < Window_Base
  
  def process_cursor_move
    return unless cursor_movable?
    last_index = @index
    cursor_down  Input.trigger_ex?($system[:p1][:m_down])  if Input.repeat_ex?($system[:p1][:m_down])
    cursor_up    Input.trigger_ex?($system[:p1][:m_up])    if Input.repeat_ex?($system[:p1][:m_up])
    cursor_right Input.trigger_ex?($system[:p1][:m_right]) if Input.repeat_ex?($system[:p1][:m_right])
    cursor_left  Input.trigger_ex?($system[:p1][:m_left])  if Input.repeat_ex?($system[:p1][:m_left])
    cursor_pagedown   if !handle?(:pagedown) && Input.repeat_ex?($system[:p1][:m_pgdown])
    cursor_pageup     if !handle?(:pageup)   && Input.repeat_ex?($system[:p1][:m_pgup])
    Sound.play_cursor if @index != last_index
  end

  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger_ex?($system[:p1][:m_confirm])
    return process_cancel   if cancel_enabled?    && Input.trigger_ex?($system[:p1][:m_cancel])
    return process_pagedown if handle?(:pagedown) && Input.trigger_ex?($system[:p1][:m_pgdown])
    return process_pageup   if handle?(:pageup)   && Input.trigger_ex?($system[:p1][:m_pgup])
  end

end

class Window_NumberInput < Window_Base

  def process_cursor_move
    return unless active
    last_index = @index
    cursor_right Input.trigger_ex?($system[:p1][:m_right]) if Input.repeat_ex?($system[:p1][:m_right])
    cursor_left  Input.trigger_ex?($system[:p1][:m_left])  if Input.repeat_ex?($system[:p1][:m_left])
    Sound.play_cursor if @index != last_index
  end

  def process_digit_change
    return unless active
    if Input.repeat_ex?($system[:p1][:m_up]+$system[:p1][:m_down])
      Sound.play_cursor
      place = 10 ** (@digits_max - 1 - @index)
      n = @number / place % 10
      @number -= n * place
      n = (n + 1) % 10 if Input.repeat_ex?($system[:p1][:m_up])
      n = (n + 9) % 10 if Input.repeat_ex?($system[:p1][:m_down])
      @number += n * place
      refresh
    end
  end

  def process_handling
    return unless active
    return process_ok     if Input.trigger_ex?($system[:p1][:m_confirm])
    return process_cancel if Input.trigger_ex?($system[:p1][:m_cancel])
  end
  
end

class Window_NameInput < Window_Selectable

  def process_handling
    return unless open? && active
    process_jump if Input.trigger_ex?($system[:p1][:m_toggle])
    process_back if Input.repeat_ex?($system[:p1][:m_cancel])
    process_ok   if Input.trigger_ex?($system[:p1][:m_confirm])
  end
  
end

class Window_DebugRight < Window_Selectable

  def update_switch_mode
    if Input.trigger_ex?($system[:p1][:m_confirm])
      Sound.play_ok
      $game_switches[current_id] = !$game_switches[current_id]
      redraw_current_item
    end
  end

  def update_variable_mode
    return unless $game_variables[current_id].is_a?(Numeric)
    value = $game_variables[current_id]
    value += 1 if Input.repeat_ex?($system[:p1][:m_right])
    value -= 1 if Input.repeat_ex?($system[:p1][:m_left])
    value += 10 if Input.repeat_ex?($system[:p1][:m_pgdown])
    value -= 10 if Input.repeat_ex?($system[:p1][:m_pgup])
    if $game_variables[current_id] != value
      $game_variables[current_id] = value
      Sound.play_cursor
      redraw_current_item
    end
  end
  
end

class Window_ShopStatus < Window_Base

  def update_page
    if visible && Input.trigger_ex?($system[:p1][:m_toggle]) && page_max > 1
      @page_index = (@page_index + 1) % page_max
      refresh
    end
  end
  
end

class Window_Message < Window_Base

  def update_show_fast
    @show_fast = true if Input.trigger_ex?($system[:p1][:f_confirm])
  end
  
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until Input.trigger_ex?($system[:p1][:f_confirm]+$system[:p1][:f_cancel])
    Input.update
    self.pause = false
  end

end

class Window_ScrollText < Window_Base

  def show_fast?
    !$game_message.scroll_no_fast && 
    (Input.press_ex?($system[:p1][:f_cancel]) || Input.press_ex?($system[:p1][:f_confirm]))
  end
  
end

class Scene_File < Scene_MenuBase

  def update_savefile_selection
    return on_savefile_ok     if Input.trigger_ex?($system[:p1][:m_confirm])
    return on_savefile_cancel if Input.trigger_ex?($system[:p1][:m_cancel])
    update_cursor
  end
  
  def update_cursor
    last_index = @index
    cursor_down (Input.trigger_ex?($system[:p1][:m_down])) if Input.repeat_ex?($system[:p1][:m_down])
    cursor_up   (Input.trigger_ex?($system[:p1][:m_up]))   if Input.repeat_ex?($system[:p1][:m_up])
    cursor_pagedown   if Input.repeat_ex?($system[:p1][:m_pgdown])
    cursor_pageup     if Input.repeat_ex?($system[:p1][:m_pgup])
    if @index != last_index
      Sound.play_cursor
      @savefile_windows[last_index].selected = false
      @savefile_windows[@index].selected = true
    end
    process_mouse_handling if defined?(Mouse) && Input.method == :mouse
  end
  
end

class Scene_Map < Scene_Base

  def update_call_menu
    return if $game_system.menu_disabled || $game_map.interpreter.running?
    return if $game_player.moving?
    call_menu if Input.trigger_ex?($system[:p1][:m_menu])
  end
  
  def update_call_debug
    SceneManager.call(Scene_Debug) if $TEST && Input.trigger_ex?($system[:system][:debug])
  end

end

class Scene_Gameover < Scene_Base

  def update
    super
    goto_title if Input.trigger_ex?($system[:p1][:m_confirm])
  end
  
end

class Scene_Battle < Scene_Base

  def show_fast?
    return Input.press_ex?($system[:p1][:m_confirm])
  end
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
