#===============================================================================
# * [ACE] Control Configuration System - Menu Code
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
# * And this script has all the code needed for the control configuration menu.
# * No settings here either, so shu-shu! :P
#===============================================================================
class Window_ConfigHelp < Window_Base

  def initialize
    @grps_data = ConfigScene::Windows[:help]
    xx = GrPS.get(@grps_data[:pos][0])
    yy = GrPS.get(@grps_data[:pos][1])
    ww = GrPS.get(@grps_data[:size][0])
    hh = GrPS.get(@grps_data[:size][1])
    super(xx,yy,ww,hh)
    set_font_opts(ConfigScene::HelpVisual[:font])
    self.opacity = ConfigScene::Windows[:help][:opa]
    self.z = ConfigScene::Windows[:help][:z]
    self.windowskin = Cache.system(ConfigScene::Windows[:help][:skin])
  end
  
  def refresh(txt=nil)
    contents.clear
    return if txt.nil?
    set_font_opts(ConfigScene::HelpVisual[:font])
    draw_text_ex(0,0,txt)
  end
  
  def reset_font_settings
    # Removed!
  end
  
end

class Window_ConfigCateg < Window_Command

  attr_accessor :list_window
  
  def initialize()
    @grps_data = ConfigScene::Windows[:categ]
    xx = GrPS.get(@grps_data[:pos][0])
    yy = GrPS.get(@grps_data[:pos][1])
    super(xx,yy)
    set_font_opts(ConfigScene::CategVisual[:font])
    self.opacity = ConfigScene::Windows[:categ][:opa]
    self.z = ConfigScene::Windows[:categ][:z]
    self.windowskin = Cache.system(ConfigScene::Windows[:categ][:skin])
  end
  
  def window_width
    return GrPS.get(@grps_data[:size][0])
  end
  
  def window_height
    return GrPS.get(@grps_data[:size][1])
  end
  
  def alignment
    return 1
  end
  
  def spacing
    return 4
  end
  
  def col_max
    return @grps_data[:cols]
  end
  
  def make_command_list
    ConfigScene::Categs.each do |key,data|
      add_command(data[:name],data[:type],true,data)
    end
  end
    
  def draw_item(index)
    set_font_opts(ConfigScene::CategVisual[:font],command_enabled?(index))
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end

  def update_help
    @help_window.refresh(current_ext[:help])
    @list_window.set_data(current_ext) if @list_window
  end
  
end

class Window_ConfigList < Window_Command

  attr_accessor :data, :enabled_btns
  
  def initialize()
    @data = ConfigScene::Categs.values[0]
    @grps_data = ConfigScene::Windows[:list]
    xx = GrPS.get(@grps_data[:pos][0])
    yy = GrPS.get(@grps_data[:pos][1])
    super(xx,yy)
    deactivate
    select(-1)
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
    
  def alignment
    return 1
  end

  def spacing
    return 4
  end
 
  def col_max
    return @data ? @data[:max] : 1
  end
    
  def current_col
    return self.index % col_max
  end
  
  def item_width
    full = width - standard_padding * 2 + spacing
    mod = @data[:type] == :buttons ? GrPS.get(ConfigScene::ListVisual[:padding]) : 0
    return (full - mod - spacing) / col_max - spacing
  end

  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    mod = @data[:type] == :buttons ? GrPS.get(ConfigScene::ListVisual[:padding]) : 0
    rect.x = (index % col_max * (item_width + spacing)) + mod + spacing
    rect.y = index / col_max * item_height
    rect
  end
  
  def set_data(data)
    return if @data == data
    @data = data
    refresh
  end
  
  def make_command_list
    @enabled_btns = {}
    @data[:list].each_with_index do |dt,i|
      case @data[:type]
      when :buttons
        btns = System.nest($system,*@data[:setting])
        col_max.times do |ii|
          btn = btns[dt][ii]
          chk = System.nest(System::ButtonRules,*@data[:setting])[dt][:can_change]
          @enabled_btns[@list.size] = chk ? chk.include?(ii) : true
          if defined?(Mouse) && Mouse.inverted 
            case btn # swap display names for mouse buttons if inverted
            when :mouse_l; btn = :mouse_r 
            when :mouse_r; btn = :mouse_l 
            end
          end
          kdt = btn ? ConfigScene::Keys[btn] : ConfigScene::Keys[:empty]
          add_command(kdt[:name],@data[:type],true,dt)
          @list[-1][:icon] = kdt[:icon]
          @list[-1][:img] = kdt[:img]
        end
      when :resolution
        name = dt[0].to_s + " x " + dt[1].to_s
        add_command(name,@data[:type],true,dt)
      end
    end
  end
    
  def draw_item(index)
    rct = item_rect(index)
    if @data[:type] == :resolution
      draw_res_buttons(index,rct)
    else
      draw_key_buttons(index,rct)
    end
  end
  
  def draw_res_buttons(index,rect)
    set_font_opts(ConfigScene::ListVisual[:font][:res],command_enabled?(index))
    if Graphics.res_overflow(@list[index][:ext])
      color = ConfigScene::ListVisual[:boxes][:locked]
    elsif [Graphics.width,Graphics.height] == @list[index][:ext]
      color = ConfigScene::ListVisual[:boxes][:c_res]
    else
      color = ConfigScene::ListVisual[:boxes][:res]
    end
    draw_back_box(rect.x,rect.y+1,rect.width,rect.height-2,color)
    draw_text(item_rect_for_text(index), command_name(index), alignment)
  end
  
  def draw_key_buttons(index,rect)
    if @enabled_btns[index]
      color = ConfigScene::ListVisual[:boxes][:keys]
    else
      color = ConfigScene::ListVisual[:boxes][:locked]
    end
    draw_back_box(rect.x,rect.y+1,rect.width,rect.height-2,color)
    case ConfigScene::ListVisual[:key_type]
    when :name
      set_font_opts(ConfigScene::ListVisual[:font][:keys],command_enabled?(index))
      draw_text(item_rect_for_text(index), command_name(index), alignment)
    when :icon
      xi = rect.x + (rect.width-24)/2
      draw_icon(@list[index][:icon],xi,rect.y)
    when :img
      img = Cache.custom_imgs(@list[index][:img],System::ImgFolder)
      rct = Rect.new(0,0,img.width,img.height)
      xi = rect.x + (rect.width-img.width)/2
      yi = rect.y + (rect.height-img.height)/2
      contents.blt(xi,yi,img,rct,255)
    end
  end

  def refresh
    super
    draw_button_names if @data[:type] == :buttons
  end

  def draw_button_names
    mod = GrPS.get(ConfigScene::ListVisual[:padding])
    set_font_opts(ConfigScene::ListVisual[:font][:names])
    @data[:list].each_with_index do |dt,i|
      yy = i * item_height
      color = ConfigScene::ListVisual[:boxes][:names]
      draw_back_box(0,yy+1,mod,item_height-2,color)
      txt = ConfigScene::Buttons[dt]
      draw_text(4,yy,mod-8,item_height,txt)
    end
  end
  
  def update
    super
    update_button_clear if @data[:type] == :buttons && Input.trigger_ex?($system[:p1][:m_clear])
  end
  
  def update_button_clear
    return unless self.active
    if @enabled_btns[self.index]
      rules = System.nest(System::ButtonRules,*@data[:setting])[current_ext]
      btn_data = System.nest($system,*@data[:setting])[current_ext]
      return if btn_data[current_col].nil?
      if rules[:must_set] && btn_data.compact.size == 1
        Sound.play_buzzer
        path = @data[:setting]+[current_ext]
        SceneManager.scene.add_pop(:cant_clear,nil,path,btn_data[current_col])
      else
        Sound.play_ok
        btn_data[current_col] = nil
        refresh
        SceneManager.scene.add_pop(:cleared)
      end
    else
      Sound.play_buzzer
      SceneManager.scene.add_pop(:key_locked)
    end
  end
  
  def update_help
    txt = ConfigScene::ButtonHelps[current_ext]
    @help_window.refresh(txt) if @data[:type] == :buttons
  end
  
end

class Window_ConfigPop < Window_Base
    
  def initialize(list_win,type,prev_change=nil,path=nil,key=nil)
    @grps_data = ConfigScene::Windows[:pop]
    @list_win = list_win
    @type = type # Sys message type symbol
    @id = @list_win.current_col # Button priority index (primary,secondary,etc)
    @path = path
    if path 
      @funct = path[-1]  # Button function symbol (interact/cancel/etc)
    else
      @funct = @list_win.current_ext # Button function symbol (interact/cancel/etc)
    end
    @prev_change = prev_change # Buttons changed data.
    @key = key     # Key pressed (if any)
    @list_data = @list_win.data # Current data of the list window
    xx = GrPS.get(@grps_data[:pos][0])
    yy = GrPS.get(@grps_data[:pos][1])
    ww = GrPS.get(@grps_data[:size][0])
    hh = GrPS.get(@grps_data[:size][1])
    super(xx,yy,ww,hh)
    set_font_opts(ConfigScene::PopVisual[:font])
    self.opacity = ConfigScene::Windows[:pop][:opa]
    self.z = ConfigScene::Windows[:pop][:z]
    self.windowskin = Cache.system(ConfigScene::Windows[:pop][:skin])
    close
    self.openness = 0
    refresh
    open
    until self.openness >= 255
      update
      SceneManager.scene.update
    end
  end
  
  def get_text
    ktype = ConfigScene::SystemMsg[:priorities][@id] # primary/secondary/etc
    kfunct = ConfigScene::Buttons[@funct] # interact/cancel/etc
    @path = @list_data[:setting]+[@funct] if @path.nil?
    @path.each do |pt|
      kfunct += ConfigScene::Paths[pt] || ""
    end
    dtype = ConfigScene::PopVisual[:key_type] # key display type
    key = ConfigScene::Keys[@key][dtype] if @key # ENTER/NUM 1/etc
    txt = ConfigScene::SystemMsg[@type].clone
    case dtype
    when :name
      key = key + "\\" if key && key == "\\"
      txt.gsub!(/\eBTNKEY/i) { key }
    when :icon
      txt.gsub!(/\eBTNKEY/i) { "\eI[#{key}]" }
    when :img
      key = "\eBTNIM[#{@key}]"
      txt.gsub!(/\eBTNKEY/i) { key }
    end
    txt.gsub!(/\eFNCTN/i) { kfunct }
    txt.gsub!(/\eBTNPRIO/i) { ktype }
    return txt
  end
  
  def get_txt(path,data) # data = [key_id,prio_id]
    type = ConfigScene::PopVisual[:key_type] # key display type
    if data[0].nil?
      key = ConfigScene::Keys[:empty][type]
    else
      if defined?(Mouse) && Mouse.inverted
        case data[0] # swap display names for mouse buttons if inverted
        when :mouse_l; data[0] = :mouse_r
        when :mouse_r; data[0] = :mouse_l
        end
      end
      key = ConfigScene::Keys[data[0]][type]
    end
    id = ConfigScene::SystemMsg[:priorities][data[1]] || ""
    funct = ConfigScene::Buttons[path[-1]]
    path.each do |pt|
      funct += ConfigScene::Paths[pt] || ""
    end
    funct += " (" + id + ")" unless id.empty?
    return {:key => key, :id => id, :funct => funct, :type => type}
  end
  
  def calc_win_size2
    @hh = line_height
    @ww = GrPS.get(ConfigScene::ListVisual[:padding])
    @iw = @list_win.item_width
    @texts = {}
    side_effs = false
    @prev_change.each do |type,data| 
      @texts[type] = {} 
      data[:new].each do |path,info| 
        old = data[:old][path]
        ntxt = get_txt(path,info) # new text
        otxt = get_txt(path,old)  # old text
        tdata = {:y => @hh + 2, :new => ntxt, :old => otxt}
        next if change_duplicate?(tdata)
        if !side_effs && ([:swapped,:cleared].include?(type) ||
           type == :swapped2 && @texts[type].size == 1)
          @hh += line_height + 2
          tdata[:y] += line_height + 2
          side_effs = true
        end
        @texts[type][path] = tdata
        @hh += line_height
        tw = text_size(ntxt[:funct]).width + 9
        @ww = tw if tw > @ww
      end
    end
    @hh += 2
  end
  
  def change_duplicate?(tdata)
    return false if @texts.empty?
    @texts.each do |type,data|
      next if data.nil? || data.empty?
      data.each do |path,info|
        return true if info[:new] == tdata[:new] && info[:old] == tdata[:old]
      end
    end
    return false
  end
  
  def draw_the_changes
    draw_change_header
    last_y = 0
    side_effs = false
    @texts.each do |type,data|
      lnum = 0
      data.each do |path,info|
        if !side_effs && ([:swapped,:cleared].include?(type) ||
           type == :swapped2 && lnum == 1)
          draw_side_effects_txt(last_y+line_height)
          side_effs = true
        end
        draw_changed_button(type,info,path)
        last_y = info[:y]
        lnum += 1
      end
    end
  end
  
  def draw_change_header
    col = ConfigScene::PopVisual[:lines][:changed]
    txt = ConfigScene::SystemMsg[:changed]
    yy = ConfigScene::PopVisual[:lines][:y_add]
    draw_back_box(0,yy,contents_width,2,col)
    draw_text(0,0,contents_width,line_height,txt,1)
  end
  
  def draw_side_effects_txt(yy)
    col = ConfigScene::PopVisual[:lines][:sideeff]
    txt = ConfigScene::SystemMsg[:sideeff]
    yl = yy + ConfigScene::PopVisual[:lines][:y_add]
    draw_back_box(0,yl,contents_width,2,col)
    draw_text(0,yy,contents_width,line_height,txt,1)
  end
  
  def draw_changed_button(type,info,path)    
    yy = info[:y]
    ftxt = info[:new][:funct]
    color1 = ConfigScene::PopVisual[:boxes][:names]
    draw_back_box(0, yy+1, @ww, line_height-2,color1)
    draw_text(4,yy,@ww-8,line_height,ftxt)
    color2 = ConfigScene::PopVisual[:boxes][:keys]
    draw_back_box(@ww+8,yy+1,@iw,line_height-2,color2)
    case info[:old][:type]
    when :name
      draw_text(@ww+8,yy,@iw,line_height,info[:old][:key],1)
    when :icon
      xi = @ww+8 + (@iw-24)/2
      draw_icon(info[:old][:key],xi,yy)
    when :img
      img = Cache.custom_imgs(info[:old][:key],System::ImgFolder)
      rct = Rect.new(0,0,img.width,img.height)
      xi = @ww+8 + (@iw-img.width)/2
      yi = yy + (line_height-img.height)/2
      contents.blt(xi,yi,img,rct,255)
    end
    old_f = contents.font.name
    contents.font.name = ["VL Gothic","Arial"]
    draw_text(@ww+@iw+8,yy,30,line_height,"→",1)
    contents.font.name = old_f
    draw_back_box(@ww+@iw+38,yy+1,@iw,line_height-2,color2)
    case info[:new][:type]
    when :name
      draw_text(@ww+@iw+38,yy,@iw,line_height,info[:new][:key],1)
    when :icon
      xi = @ww+@iw+38 + (@iw-24)/2
      draw_icon(info[:new][:key],xi,yy)
    when :img
      img = Cache.custom_imgs(info[:new][:key],System::ImgFolder)
      rct = Rect.new(0,0,img.width,img.height)
      xi = @ww+@iw+38 + (@iw-img.width)/2
      yi = yy + (line_height-img.height)/2
      contents.blt(xi,yi,img,rct,255)
    end
  end
  
  def set_win_size_and_pos(ww,hh)
    ww = Graphics.width if ww > Graphics.width
    hh = Graphics.height if hh > Graphics.height
    self.width = ww
    self.height = hh
    self.x = (Graphics.width-self.width) / 2
    self.y = (Graphics.height-self.height) / 2
    create_contents
    set_font_opts(ConfigScene::PopVisual[:font])
  end
  
  def draw_information(txt)
    texts = {}
    lnum = 0
    hh = standard_padding * 2
    ww = standard_padding * 2
    txt = txt.clone
    txt.each_line do |line|
      line.sub!("\n","")
      line.sub!("\r\n","")
      data = draw_text_ex(0,0,line)
      hh += line_height
      yy = lnum * line_height
      tw = data[:x]
      mw = tw + standard_padding * 2 + ConfigScene::PopVisual[:add_w]
      ww = mw if mw > ww
      texts[lnum] = {:txt => line, :y => yy, :w => tw}
      lnum += 1
    end
    set_win_size_and_pos(ww,hh)
    texts.each do |lnum,info|
      xx = (contents_width-info[:w])/2
      yy = info[:y]
      draw_text_ex(xx,yy,info[:txt])
    end
  end
  
  def refresh
    case @type
    when :changed
      calc_win_size2
      mw = @ww + @iw * 2 + standard_padding * 2 + 30 + 8
      set_win_size_and_pos(mw,@hh+standard_padding*2)
      draw_the_changes
    else
      txt = get_text
      return if txt.nil?
      draw_information(txt)
    end
  end

  def reset_font_settings
    # Removed!
  end

  def pop_over
    close
    until self.openness <= 0
      SceneManager.scene.update
    end
    dispose
  end
  
  def update
    super
    return if self.disposed? || self.openness < 255
    if @type == :wait_for_key
      waiting_for_key_press
    else
      waiting_for_confirm
    end
  end
  
  # Starting the wait for the input:
  def waiting_for_key_press
    if Input.trigger_find?(System::AllKeys)
      Input.update
      @old_btn = System.nest($system,*@list_data[:setting])[@funct][@id]
      @buttons_swapped = {} # Swapped buttons.
      @buttons_cleared = {} # Cleared buttons.
      @buttons_swapped2 = {} # Swapped buttons from 2nd check.
      @buttons_cleared2 = {} # Cleared buttons from 2nd check.
      @syms = []  # First path.
      @nest = 0   # First nest level.
      @can_change = true # First check.
      check_same_key2()
      if @can_change # Change success!
        change_the_buttons
        SceneManager.scene.add_pop(:changed,@changes,@funct,Input.last_trigger)
        Sound.play_ok
        @list_win.refresh
        pop_over
      end
    end
  end
  
  # First recursive check:
  def check_same_key2(strt=$system,syms=@syms,nest=@nest)
    return if @can_change == false
    strt.each do |sym,data|
      case data
      when Hash
        @syms << sym
        @nest += 1
        check_same_key2(data,@syms)
        @syms.pop
        @nest -= 1
      when Array
        data.each_with_index do |key,i|
          if key == Input.last_trigger
            case key_incompatible3(sym,data,key,i)
            when :cant_swap, :locked_key
              SceneManager.scene.add_pop(:cant_set,nil,@syms+[sym],Input.last_trigger)
              pop_over
              Sound.play_buzzer
              @can_change = false # Can not set key!
              return
            when :dont_swap
              # Don't swap the key from the checked function!
            when :swap_it
              # Add the key to the to-be-swapped hash!
              @buttons_swapped[[*(@syms+[sym])]] = i
            when :clear_it
              # Add the ket to the to-be-cleared hash!
              @buttons_cleared[[*(@syms+[sym])]] = i
            end
          end
        end
      end
    end
  end

  # Checking for incompatible key binds in the first recursive method:
  def key_incompatible3(sym,keys,key,i)
    funct_rules = System.nest(System::ButtonRules,*(@syms))[sym]
    locked = funct_rules[:can_change] ? !funct_rules[:can_change].include?(i) : false
    if @syms + [sym] == @list_data[:setting] + [@funct]
      if locked
        return :cant_swap # Locked keys can not be changed, so no swap here
      else
        return :swap_it # The same key can be swapped for sure
      end
    end
    same_check = false
    if funct_rules[:same_key]
      ldt = System.nest(funct_rules[:same_key],*@list_data[:setting])
      case ldt
      when Array;     same_check = ldt.include?(@funct)
      when TrueClass; same_check = ldt
      else;           same_check = false
      end
    end
    if same_check
      return :dont_swap # Don't swap the key for the checked function
    else
      if locked
        return :locked_key # Can't modify the key-bind
      elsif funct_rules[:must_set] && keys.compact.size == 1 && @old_btn.nil?
        return :cant_swap # Can't clear/swap the key for the checked function
      else
        @syms2 = [] # Second path
        @nest2 = 0  # Second nest level
        @can_change2 = true # Second check
        @csym = sym
        check_same_key2_extra()
        if @can_change2
          return :swap_it # Can change the key(s)
        else
          return :cant_swap # Can't change the key(s)
        end
      end
    end
  end

  # Second recursive check - making sure no incompatible configuration exists:
  def check_same_key2_extra(strt=$system,syms=@syms2,nest=@nest2)
    return if @can_change2 == false
    strt.each do |sym,data|
      case data
      when Hash
        @syms2 << sym
        @nest2 += 1
        check_same_key2_extra(data,@syms2)
        @syms2.pop
        @nest2 -= 1
      when Array
        data.each_with_index do |key,i|
          if key == @old_btn && !key.nil? #Input.last_trigger
            case key_incompatible4(sym,data,key,i)
            when :cant_swap, :locked_key
              @can_change2 = false # Can not set key!
              return
            when :dont_swap
              # Do nothing here!
            else
              # Making sure that any incompatible buttons are fixed on the way here.
              @buttons_swapped2[[*(@syms2+[sym])]] = i
            end
          end
        end
      end
    end
  end

  # Checking for incompatible key binds in the second recursive method:
  def key_incompatible4(sym,keys,key,i)
    funct_rules = System.nest(System::ButtonRules,*(@syms))[@csym]
    locked = funct_rules[:can_change] ? !funct_rules[:can_change].include?(i) : false
    if @syms2 + [sym] == @syms + [@csym] || @syms2 + [sym] == @list_data[:setting] + [@funct]
      if locked
        return :cant_swap # Locked keys can not be changed, so no swap here
      else
        return :swap_it # It's the same key, so it's surely safe to swap
      end
    end
    same_check = false
    if funct_rules[:same_key]
      ldt = System.nest(funct_rules[:same_key],*@syms2)
      case ldt
      when Array;     same_check = ldt.include?(sym)
      when TrueClass; same_check = ldt
      else;           same_check = false
      end
    end
    if same_check
      return :dont_swap # Can share the same key, so no need to swap keys
    else
      if locked
        return :locked_key
      elsif funct_rules[:must_set] && keys.compact.size == 1 && @old_btn.nil?
        if key.nil?
          return :dont_swap # No need to restrict if the key was empty anyway
        else
          return :cant_swap # Can't swap the key for the checked function
        end
      else
        if @old_btn.nil? && key.nil?
          return :dont_swap # No need to swap if bothe the old and new key is empty
        else
          return :swap_it # Swap the keys
        end
      end
    end
  end

  # Finally, changing all affected buttons, setting info texts shown:
  def change_the_buttons
    @changes = {
      :direct   => {:old => {}, :new => {}}, 
      :swapped2 => {:old => {}, :new => {}},
      :swapped  => {:old => {}, :new => {}}, 
      :cleared  => {:old => {}, :new => {}}, 
    }
    @buttons_swapped.each do |path,index|
      old = System.nest($system,*path)
      @changes[:swapped][:new][path] = [@old_btn,index]
      @changes[:swapped][:old][path] = [old[index],index]
      old[index] = @old_btn
    end
    @buttons_cleared.each do |path,index|
      old = System.nest($system,*path)
      @changes[:cleared][:new][path] = [nil,index]
      @changes[:cleared][:old][path] = [old[index],index]
      old[index] = nil
    end
    if @can_change2 == true
      @buttons_swapped2.each do |path,index|
        old = System.nest($system,*path)
        @changes[:swapped2][:new][path] = [Input.last_trigger,index]
        @changes[:swapped2][:old][path] = [old[index],index]
        old[index] = Input.last_trigger
      end
    end
    path = @list_data[:setting]+[@funct]
    old = System.nest($system,*path)
    unless @changes[:swapped2][:new].include?(path)
      @changes[:direct][:new][path] = [Input.last_trigger,@id]
      @changes[:direct][:old][path] = [old[@id],@id]
    end
    old[@id] = Input.last_trigger
  end
  
  # Popup Confirmation:
  def waiting_for_confirm
    if Input.trigger_ex?($system[:p1][:m_confirm])
      Sound.play_ok
      pop_over
      @list_win.activate
    end
  end
  
end

class ConfScene < Scene_Base

  def start
    super
    init_vars
    init_wins
  end
  
  def init_vars
    @old_settings = Marshal.load(Marshal.dump($system))
    @msgs = []
  end
  
  def init_wins
    init_help_win
    init_list_win
    init_categ_win
  end
  
  def init_help_win
    @helpy = Window_ConfigHelp.new
  end
  
  def init_list_win
    @list = Window_ConfigList.new
    @list.help_window = @helpy
    @list.set_handler(:resolution, method(:on_resolution_ok))
    @list.set_handler(:buttons, method(:on_buttons_ok))
    @list.set_handler(:cancel, method(:on_list_cancel))
  end
   
  def init_categ_win
    @categ = Window_ConfigCateg.new
    @categ.help_window = @helpy
    @categ.list_window = @list
    @categ.set_handler(:ok, method(:on_categ_ok))
    @categ.set_handler(:cancel, method(:on_categ_cancel))
  end
  
  def on_resolution_ok
    # Do resolution change here!
    # This function is disabled!
    return @list.activate if @list.current_ext == [Graphics.width,Graphics.height]
    Graphics.resize_screen(*@list.current_ext)
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
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
    $game_player.reserve_transfer($game_map.map_id, $game_player.x, 
                                  $game_player.y, $game_player.direction)
    $game_temp.fade_type = 2
    @helpy.refresh(@categ.current_ext[:help])
    @categ.update_cursor
    @list.activate
  end
  
  def on_buttons_ok
    if @list.enabled_btns[@list.index]
      add_pop(:wait_for_key)
    else
      add_pop(:key_locked)
    end
  end
  
  def on_list_cancel
    @list.deactivate
    @list.select(-1)
    @categ.activate
  end
  
  def on_categ_ok
    @list.activate
    @list.select(0)
  end
  
  def on_categ_cancel
    System.save_system if @old_settings != $system
    return_scene
  end
  
  def add_pop(type,prev_change=nil,funct=nil,key=nil)
    @list.deactivate if @list.active
    @msgs << [type,prev_change,funct,key]
  end
  
  def update
    super
    print_settings if $TEST && Input.trigger_ex?($system[:p1][:m_toggle])
    @msg_win = nil if @msg_win && @msg_win.disposed?
    if @msgs != [] && @msg_win.nil?
      @msg_win = Window_ConfigPop.new(@list,*@msgs.shift)
    end
  end
    
  def print_settings
    saved_file = ""
    case System::PrintF[:type]
    when :reset;      type = "w+"
    when :add_bottom; type = "a+"
    when :add_top
      type = "r+"
      File.open(System::PrintF[:filename],"r") do |f|
        f.each_line do |line|
          saved_file += line
        end
      end
    end
    File.open(System::PrintF[:filename],type) do |f|
      f.puts("-"*40 + "\n")
      f.puts("Save Date: #{Time.now} \n")
      f.puts("-"*40 + "\n")
      f.write("  Defaults = {\n    ")
      pchar = ""
      nest = 2
      index = 0
      refer = $system.inspect.clone
      $system.inspect.each_char do |ch|
        if index == 0 || (ch == " " && pchar == ",")
          index += 1 
          next
        end
        f.write(ch)
        case ch
        when "{"
          nest += 1
          f.write("\n" + nest_txt(nest))
        when ","
          if pchar == "}"
            f.write("\n" + nest_txt(nest))
          elsif pchar == "]"
            f.write("\n" + nest_txt(nest))
          end
        when "]"
          if refer[index+1] == "}"
            nest -= 1 if nest > 0
            f.write("\n" + nest_txt(nest) )
          end
        when "}"
          if refer[index+1] == "}"
            nest -= 1 if nest > 0
            f.write("\n" + nest_txt(nest))
          end
        when ">"
          f.write(" ")
        when /\w/i
          if refer[index+1] == "="
            f.write(" ")
          end
        end
        pchar = ch.clone
        index += 1
      end
      f.write("\n" + "-"*40 + "\n\n")
      f.write(saved_file) if type == "r+"
    end
  end
  
  def nest_txt(nest)
    return " " * (nest * 2)
  end
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
