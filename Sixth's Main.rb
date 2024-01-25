#===============================================================================
# * [ACE] Control Configuration System - Main Functions
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
# * This script contains the main functions needed for the control configuration
#   system. 
# * Also contains some methods to expand Neon Black's Keyboard Input system and
#   Shaz's Super Simple Mouse script.
# * This got no settings for you to edit! 
#   Aren't you sick of those already anyway? :P
#===============================================================================
$imported = {} if $imported.nil?
$imported["SixthControlConfigMenu"] = true

module System

  def self.init
    file = self.check_sys_file
    if File.exist?(file) && !Reload
      $system = load_data(file)
    else
      load_defaults
      save_data($system, file)
    end
  end
   
  def self.check_sys_file
    file = ""
    file += DPath + "\\" unless DPath.empty?
    SPath.each do |path|
      file += path + "\\"
      Dir.mkdir(file) if !FileTest.exist?(file)
    end
    file += FileName
    return file
  end

  def self.load_defaults
    $system = Marshal.load(Marshal.dump(Defaults))
  end
  
  def self.load_system
    file = self.check_sys_file
    $system = load_data(file) if File.exist?(file)
  end
  
  def self.save_system
    file = self.check_sys_file
    save_data($system, file)
  end  
    
  # Getting the data from a hash wherever it is in the hash based on the
  # path entered. Recursive method!
  def self.nest(strt,*args)
    if args != []
      nxt = strt[args.shift]
      if nxt
        case nxt
        when Hash; return self.nest(nxt,*args)
        else;      return nxt
        end
      else
        return nil
      end
    else
      return strt
    end
  end
 
  def self.modify_data(ori,data)
    data.each do |path,value|
      last = path.pop
      if value.nil?
        self.nest(ori,*path).delete(last)
      else
        self.nest(ori,*path)[last] = value
      end
      path << last
    end
    return ori
  end

end

module Cache
  
  def self.custom_imgs(filename,folder)
    load_bitmap(folder,filename)
  end
  
end

module GrPS
  
  def self.get(val)
    case val
    when /GW\/(\d+)([+\-]\d+)/i; vv = Graphics.width/$1.to_i + $2.to_i
    when /GWx(.*)([+\-]\d+)/i;   vv = Graphics.width * $1.to_f + $2.to_i
    when /GW([+\-]\d+)/i;        vv = Graphics.width + $1.to_i
    when /GW\/(\d+)/i;           vv = Graphics.width/$1.to_i
    when /GWx(.*)/i;             vv = Graphics.width * $1.to_f
    when /GW/i;                  vv = Graphics.width
    when /GH\/(\d+)([+\-]\d+)/i; vv = Graphics.height/$1.to_i + $2.to_i
    when /GHx(.*)([+\-]\d+)/i;   vv = Graphics.height * $1.to_f + $2.to_i
    when /GH([+\-]\d+)/i;        vv = Graphics.height + $1.to_i
    when /GH\/(\d+)/i;           vv = Graphics.height/$1.to_i
    when /GHx(.*)/i;             vv = Graphics.height * $1.to_f
    when /GH/i;                  vv = Graphics.height
    when Integer;                vv = val
    end
    return vv
  end
  
end

module SceneManager
 
  class << self; alias init_buttons1153 run; end
  def self.run
    System.init
    init_buttons1153
  end
  
end

module Input
    
  class << self
    
    if method_defined?(:release?)
      
      alias add_nchecks7612 release?
      def release?(button)
        if defined?(Mouse) && $mouse.enabled? && !Mouse.pos.nil?
          if Mouse.trigger_hash[button]
            return true if Mouse.release?(Mouse.trigger_hash[button])
          end
        end
        return true if $imported["CP_KEYBOARD"] && Keyboard.release?(button)
        return add_nchecks7612(button)
      end
      
    else
      
      def release?(button) # Requires Shaz's Mouse and NB's Keyboard script!
        if defined?(Mouse) && $mouse.enabled? && !Mouse.pos.nil?
          if Mouse.trigger_hash[button]
            return true if Mouse.release?(Mouse.trigger_hash[button])
          end
        end
        return true if $imported["CP_KEYBOARD"] && Keyboard.release?(button)
        return false
      end
      
    end
    
  end
  
  def self.trigger_ex?(buttons)
    return false if buttons.nil?
    buttons.any? {|button| trigger?(button)}
  end
  
  def self.repeat_ex?(buttons)
    return false if buttons.nil?
    buttons.any? {|button| repeat?(button)}
  end
  
  def self.press_ex?(buttons)
    return false if buttons.nil?
    buttons.any? {|button| press?(button)}
  end
  
  def self.release_ex?(buttons)
    return false if buttons.nil?
    buttons.any? {|button| release?(button)}
  end
  
  def self.trigger_find?(buttons)
    bt = buttons.find {|button| trigger?(button)}
    @last_trigger = bt
    return bt
  end
  
  def self.repeat_find?(buttons)
    bt = buttons.find {|button| repeat?(button)}
    @last_repeat = bt
    return bt
  end
  
  def self.press_find?(buttons)
    bt = buttons.find {|button| press?(button)}
    @last_press = bt
    return bt
  end
  
  def self.release_find?(buttons)
    bt = buttons.find {|button| release?(button)}
    @last_release = bt
    return bt
  end

  def self.last_trigger
    return @last_trigger
  end
  
  def self.last_repeat
    return @last_repeat
  end
  
  def self.last_press
    return @last_press
  end
  
  def self.last_release
    return @last_release
  end
  
end

class << Graphics

  if $imported[:Zeus_Fullscreen] && defined?(Mouse)
  
    alias fix_mouse_screen_rect9917 resize_window
    def resize_window(w, h)
      fix_mouse_screen_rect9917(w,h)
      Mouse.set_correct_win_size
      Mouse.set_client_rect
      Mouse.center_mouse
    end
  
  end
     
=begin

  # This part is disabled on purpose! 
  # Do NOT enable it unless you know what you are doing!

  alias res_toggler6622 update
  def update
    res_toggler6622
    toggle_res if Input.trigger_ex?($system[:system][:resolution])
  end

  def toggle_res
    return unless $system[:resolutions]
    current_index = $system[:resolutions].index([Graphics.width,Graphics.height])
    if current_index.nil?
      new_index = 0 
    else
      new_index = current_index + 1
    end
    new_index = 0 if new_index > $system[:resolutions].size - 1
    new_res = $system[:resolutions][new_index]
    while res_overflow(new_res)
      new_index += 1
      new_index = 0 if new_index > $system[:resolutions].size - 1
      new_res = $system[:resolutions][new_index]
    end
    p new_res
    resize_screen(*new_res)
    SceneManager.scene.instance_variables.each do |varname|
      ivar = SceneManager.scene.instance_variable_get(varname)
      if ivar.is_a?(Window)
        ivar.x = ivar.get_x
        ivar.y = ivar.get_y
        ivar.width = ivar.get_width
        ivar.height = ivar.get_height
        ivar.create_contents
        ivar.refresh if ivar.respond_to?(:refresh)
        ivar.update_cursor if ivar.respond_to?(:update_cursor)
        ivar.update
      end
    end
    if $game_player
      $game_player.reserve_transfer($game_map.map_id, $game_player.x, 
                                    $game_player.y, $game_player.direction)
      $game_temp.fade_type = 2
    end
  end
  
  def res_overflow(res)
    return res[0] > GetSystemMetrics.call(0) || res[1] > GetSystemMetrics.call(1)
  end
  
=end

end

class Window_Base < Window
    
  def get_x
    return @grps_data ? GrPS.get(@grps_data[:pos][0]) : self.x
  end
  
  def get_y
    return @grps_data ? GrPS.get(@grps_data[:pos][1]) : self.y
  end
  
  def get_width
    return @grps_data ? GrPS.get(@grps_data[:size][0]) : self.width
  end
  
  def get_height
    return @grps_data ? GrPS.get(@grps_data[:size][1]) : self.height
  end
 
  def set_font_opts(opts=nil,enable=true)
    return if opts.nil?
    contents.font.name = opts[:type] if opts[:type]
    contents.font.size = opts[:size] if opts[:size]
    contents.font.bold = opts[:bold] if opts[:bold]
    contents.font.italic = opts[:italic] if opts[:italic]
    contents.font.shadow = opts[:shadow] if opts[:shadow]
    contents.font.outline = opts[:outline] if opts[:outline]
    ocol = opts[:outline_col].is_a?(Integer) ? text_color(opts[:outline_col]) : opts[:outline_col]
    contents.font.out_color = ocol if ocol 
    fcol = opts[:font_col].is_a?(Integer) ? text_color(opts[:font_col]) : opts[:font_col]
    change_color(fcol,enable) if fcol 
  end

  def draw_back_box(x,y,w,h,color)
    if color.is_a?(Array)
      contents.gradient_fill_rect(x,y,w,h,*color)
    else
      contents.fill_rect(x,y,w,h,color)
    end
  end
  
  alias reset_pos_data0027 draw_text_ex
  def draw_text_ex(x, y, text)
    @pos_data = {}
    reset_pos_data0027(x, y, text)
    return @pos_data 
  end

  alias get_pos_data9927 process_character
  def process_character(c, text, pos)
    get_pos_data9927(c, text, pos)
    @pos_data = pos
  end
   
  alias add_btn_img_codes9917 process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when "BTNIM"
      text.sub!(/\[(.*?)\]/i,"")
      iname = $1
      draw_button_image(key_image(iname.to_sym),pos)
    when "BTNCIM"
      text.sub!(/\[(.*(?:\s*,\s*.*)*)\]/i,"")
      idata = $1
      inames = get_button_img(idata)
      inames.each_with_index do |inm,i| 
        draw_button_image(inm,pos)
        unless i == inames.size - 1
          sep = ConfigScene::MsgCodes[:imgsep].clone
          process_character(sep.slice!(0, 1), sep, pos) until sep.empty?
        end
      end
    when "BTNCIMS"
      text.sub!(/\[(.*(?:\s*,\s*.*)*)\]/i,"")
      idata = $1
      iname = get_button_img_single(idata)
      draw_button_image(iname,pos)
    else
      add_btn_img_codes9917(code, text, pos)
    end
  end
    
  def key_image(key)
    if defined?(Mouse) && Mouse.inverted
      case key # swap display images for mouse buttons if inverted
      when :mouse_l; key = :mouse_r 
      when :mouse_r; key = :mouse_l 
      end
    end
    return ConfigScene::Keys[key][:img]
  end
  
  def get_button_img_single(data)
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    button = System.nest($system,*path)
    key = button.find {|ky| !ky.nil? }
    return key ? key_image(key) : key_image(:empty)
  end
  
  def get_button_img(data)
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    buttons = System.nest($system,*path)
    keys = buttons.select {|ky| !ky.nil? }
    if keys.empty?
      return [key_image(:empty)]
    else
      imgs = []
      keys.each {|ky| imgs << key_image(ky) }
      return imgs
    end
  end
  
  def draw_button_image(iname,pos)
    img = Cache.custom_imgs(iname,System::ImgFolder)
    rct = Rect.new(0,0,img.width,img.height)
    contents.blt(pos[:x],pos[:y],img,rct,255)
    pos[:x] += img.width
  end
  
  alias add_button_codes8827 convert_escape_characters
  def convert_escape_characters(text)
    result = add_button_codes8827(text)
    result.gsub!(/\eBTNCI\[(.*(?:\s*,\s*.*)*)\]/i) { get_button_icon($1) }
    result.gsub!(/\eBTNCIS\[(.*(?:\s*,\s*.*)*)\]/i) { get_button_icon_single($1) }
    result.gsub!(/\eBTNI\[(.*)\]/i) { key_icon($1.to_sym) }
    result.gsub!(/\eBTNC\[(.*(?:\s*,\s*.*)*)\]/i) { get_button_txt($1,:msg) }
    result.gsub!(/\eBTNCS\[(.*(?:\s*,\s*.*)*)\]/i) { get_button_txt_single($1,:msg) }
    result.gsub!(/\eBTN\[(.*)\]/i) { key_txt($1.to_sym,:msg) }
    result.gsub!(/\eFNCP\[(.*(?:\s*,\s*.*)*)\]/i) { get_function_txt($1,:msg) }
    result.gsub!(/\eFNC\[(.*)\]/i) { function_txt($1.to_sym,:msg) }
    return result
  end
    
  def draw_button_txt(x,y,w,h,txt,al)
    ctxt = txt.clone
    ctxt.gsub!(/\eBTNC\[(.*(?:\s*,\s*.*)*)\]/i) { get_button_txt($1) }
    ctxt.gsub!(/\eBTN\[(.*)\]/i) { key_txt($1.to_sym) }
    ctxt.gsub!(/\eFNCP\[(.*(?:\s*,\s*.*)*)\]/i) { get_function_txt($1) }
    ctxt.gsub!(/\eFNC\[(.*)\]/i) { function_txt($1.to_sym) }
    draw_text(x,y,w,h,ctxt,al)
  end
  
  def key_txt(key,type=:txt)
    if defined?(Mouse) && Mouse.inverted
      case key # swap display names for mouse buttons if inverted
      when :mouse_l; key = :mouse_r 
      when :mouse_r; key = :mouse_l 
      end
    end
    base = type == :txt ? ConfigScene::MsgCodes[:keytxt] : ConfigScene::MsgCodes[:keymsg]
    return sprintf(base,ConfigScene::Keys[key][:name])
  end
    
  def get_button_txt_single(data,type=:txt)
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    button = System.nest($system,*path)
    key = button.find {|ky| !ky.nil? }
    return key ? key_txt(key,type) : key_txt(:empty,type)
  end
  
  def get_button_txt(data,type=:txt)
    txt = ""
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    buttons = System.nest($system,*path)
    keys = buttons.select {|ky| !ky.nil? }
    if keys.empty?
      return key_txt(:empty,type)
    else
      sep = ConfigScene::MsgCodes[:namesep]
      keys.each do |ky|
        txt += txt.empty? ? key_txt(ky,type) : sep + key_txt(ky,type)
      end
      return txt
    end
  end

  def key_icon(key)
    if defined?(Mouse) && Mouse.inverted
      case key # swap display icons for mouse buttons if inverted
      when :mouse_l; key = :mouse_r 
      when :mouse_r; key = :mouse_l 
      end
    end
    return sprintf("\eI[%d]",ConfigScene::Keys[key][:icon])
  end
  
  def get_button_icon_single(data)
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    button = System.nest($system,*path)
    key = button.find {|ky| !ky.nil? }
    return key ? key_icon(key) : key_icon(:empty)
  end
  
  def get_button_icon(data)
    txt = ""
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    buttons = System.nest($system,*path)
    keys = buttons.select {|ky| !ky.nil? }
    if keys.empty?
      return key_icon(:empty)
    else
      sep = ConfigScene::MsgCodes[:iconsep]
      keys.each do |ky|
        txt += txt.empty? ? key_icon(ky) : sep + key_icon(ky)
      end
      return txt
    end
  end
  
  def function_txt(funct,type=:txt)
    base = type == :txt ? ConfigScene::MsgCodes[:functtxt] : ConfigScene::MsgCodes[:functmsg]    
    return sprintf(base,ConfigScene::Buttons[funct])
  end

  def get_function_txt(data,type=:txt)
    path = []
    data.split(/(?:\s*,\s*)/i).each {|dt| path << dt.to_sym }
    base = type == :txt ? ConfigScene::MsgCodes[:functtxt] : ConfigScene::MsgCodes[:functmsg]
    ftxt = ConfigScene::Buttons[path.pop]
    add = ""
    path.each {|pt| add += ConfigScene::Paths[pt] || "" }
    return sprintf(base,ftxt+add)
  end
  
end

class Scene_Debug < Scene_MenuBase

  def help_text
    return ConfigScene::DebugHelp[@left_window.mode]
  end
  
end

class Window_MenuCommand < Window_Command

  alias add_controls_cmd1002 make_command_list
  def make_command_list
    add_controls_cmd1002
    cmd_data = {
      :name => ConfigScene::MenuAdd[:name], 
      :symbol=> :controls, 
      :enabled => true, 
      :ext => nil
    }
    @list.insert(ConfigScene::MenuAdd[:index],cmd_data)
  end
  
end

class Scene_Menu < Scene_MenuBase
  
  alias add_controls_funct2214 create_command_window
  def create_command_window
    add_controls_funct2214
    @command_window.set_handler(:controls, method(:open_controls))
  end
    
  def open_controls
    SceneManager.call(ConfScene)
  end
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
