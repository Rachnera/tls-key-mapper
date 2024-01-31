#===============================================================================
# * [ACE] Control Configuration System - Menu Settings
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
# * In this section, you can set up various visual settings for the control
#   configuration menu.
#===============================================================================
module ConfigScene
  #-----------------------------------------------------------------------------
  # Menu Command Addon Settings:
  #-----------------------------------------------------------------------------
  # In case you want to add the control configuration scene to your main menu 
  # with a command button, this is the place to do so.
  #
  # Only 3 options here:
  #
  #   :enable => true/false,
  # Enable the main menu command button or not?
  # In case you would like to add the control configuration scene button in
  # another script (like a menu engine script, for example), you should set
  # this to false, otherwise set it to true.
  # Note that the new command button will only appear in the default main menu
  # scene! If you use a custom menu, you will have to add this button somewhere
  # in the your custom menu script!
  #
  #   :index => number,
  # The place to insert the command button on the command list.
  # 0 means it will be the first, 1 means it will be the second, and so on.
  #
  #   :name => "command name",
  # The name of the command button. Kinda obvious what this does, right? :P
  #
  # In case you need the information on how to add the command button in a 
  # custom menu engine, here is the data for it:
  #
  #   Handler name: :controls
  #   Handler method name: :open_controls
  #   Name of the menu scene class: ConfScene
  #
  # It should be easy enough to add the command button for the controls menu
  # knowing these. This only applies to the menus which are based on the 
  # default main menu (Scene_Menu)! If they aren't, these won't help much.
  #-----------------------------------------------------------------------------
  MenuAdd = {
    :enable => true,
    :index => 5,
    :name => "Controls",
  }
  
  #-----------------------------------------------------------------------------
  # Window Settings:
  #-----------------------------------------------------------------------------
  # Setup the windows' properties here.
  #
  # All of them got the same options, and those are:
  #
  #   :pos => [x,y],
  # The X and Y position of the window.
  # Besides the usual direct positioning by using integer numbers, you have 
  # several other options here for setting up the position of the window.
  # These are all strings, specifically:
  #   GW/value±value  <---
  #   GWxvalue±value     |
  #   GW±value           |-- Screen width related options.
  #   GWxvalue           |
  #   GW/value           |
  #   GW              <---
  #   GH/value±value  <---
  #   GHxvalue±value     |
  #   GH±value           |-- Screen height related options.
  #   GHxvalue           |
  #   GH/value           |
  #   GH              <---
  # The weird ± sign can be a + or - sign for adding or subtracting the value.
  # The values must be integer numbers, except when it comes after an x sign, in
  # which case they can be float numbers too.
  # The GW indicates "Graphics.width" aka your resolution's width, and the
  # GH indicates "Graphics.height" aka your resolution's height.
  # The x sign indicates multiplification, the / sign divides, and...
  # C'mon, it's basic math! :D
  # You can use these to make dynamic settings depending on the resolution of
  # your game. Quite pointless if you can't change resolutions in your game,
  # but the ability is still here. :P
  #
  #   :size => [width,height],
  # The width and height of the window.
  # Got the same extra options as the position settings!
  #
  #   :opa => value,
  # The opacity level of the window. 0 - 255.
  #
  #   :z => value,
  # The Z level of the window. Integer values.
  #
  #   :skin => "windowskin_image_name",
  # The windowskin image used for the window.
  #
  #   :cols => number,
  # This is a special setting for the category window only!
  # The maximum amount of columns the category buttons can have.
  # If you set it to the same amount as your categories in the category window,
  # you will have a horizontal selectable window instead of a vertical one, for
  # example.
  #
  # Note that the popup window's position and size will be adjusted 
  # automatically based on the text it shows, so it doesn't matter what you set 
  # there! Just keep it's width and height above 0!
  #
  # And that's all here, folks! :P
  #-----------------------------------------------------------------------------
  Windows = {
    :help => { # Help window settings:
      :pos => [0,0], :size => ["GW",72], 
      :opa => 255, :z => 100, :skin => "Window",
    },
    :categ => { # Category window settings:
      :pos => [0,72], :size => ["GWx0.33","GH-72"], 
      :opa => 255, :z => 100, :skin => "Window",
      :cols => 1,
    },
    :list => { # List window settings:
      :pos => ["GWx0.33",72], :size => ["GWx0.67","GH-72"], 
      :opa => 255, :z => 100, :skin => "Window",
    },
    :pop => { # Popup window settings:
      :pos => [0,"GH/2-24"], :size => ["GW",48], # <-- NOT USED!
      :opa => 255, :z => 101, :skin => "Window",
    },
  }
  
  #-----------------------------------------------------------------------------
  # Help Window Visual Settings:
  #-----------------------------------------------------------------------------
  # Not much here, just some font settings.
  # The name of the options should tell what they do, so no details on that.
  #
  # Ahhh, okay, just one detail regarding the color options...
  # You can either set it to an integer number or a color object.
  # The integer type would read the color from the help window's windowskin
  # color palette, and the color object type would directly set the color's 
  # red, green, blue and alpha values.
  # Choose the one you want.
  # Note that if you use color message codes in help texts, and got no message
  # code to set back the color to a specific RGBA value (some message systems
  # got this option with new message codes), it is better to use integer values,
  # so that you can set it back to the default color after the color coded text.
  #
  # Also, you can omit any options here, in which case the default font 
  # properties will be loaded for them.
  #
  # All font options below work the same way, so no more about these below! :P
  #-----------------------------------------------------------------------------
  HelpVisual = {
    :font => {
      :type => "Aclonica", :size => 16, 
      :bold => false, :italic => false, :shadow => true, :outline => true,
      :font_col => Color.new(255,255,255,255), 
      :outline_col => Color.new(0, 0, 0, 128),
    },
  }
  
  #-----------------------------------------------------------------------------
  # Category Window Visual Settings:
  #-----------------------------------------------------------------------------
  # Same as above, just some font options. A one-liner description, yay! :D
  #-----------------------------------------------------------------------------
  CategVisual = {
    :font => {
      :type => "Aclonica", :size => 16, 
      :bold => false, :italic => false, :shadow => true, :outline => true,
      :font_col => Color.new(255,255,255,255), 
      :outline_col => Color.new(0, 0, 0, 128),
    },
  }
  
  #-----------------------------------------------------------------------------
  # List Window Visual Settings:
  #-----------------------------------------------------------------------------
  # This one got a bit more settings.
  # Lets check them in order...
  #
  #   :padding => pixels,
  # This will decide how much width the function names will reserve for 
  # themselves in the list window. The rest of the space will be equally split
  # between the key-bind names.
  #
  #   :key_type => :name/:icon/:img,
  # This will decide how will the keys be displayed in the list window.
  # It should be obvious which option will yield which result, so no more 
  # details for this one. :P
  #
  #   :boxes => { 
  #     :box1 => color_setting,
  #     :box2 => color_setting,
  #     ...
  #   },
  # These settings will set the color of the background boxes behind the various
  # information displayed in the list window.
  # The color settings can be set up 2 ways:
  # 1. A color object. This will directly set that color for the box.
  # 2. An array of 2 color objects. This will make the box's color a gradient
  #    one between the 2 colors you entered.
  # The different color options will set the following box colors:
  # :names  - Box color behind the function names.
  # :keys   - Box color behind the key-bind displays.
  # :locked - Box color for locked key-binds.
  # :res    - Box color for the currently set resolution. NOT USED!
  # :c_res  - Box color for the other resolution options. NOT USED!
  # You may have noticed the 2 resolution related settings...
  # While the feature actually works (resolution change during the game), it
  # would be extremely long and tedious to change all the default window 
  # properties to be compatible with this, so I simply removed it from this 
  # system. I based my custom menus with this feature in mind from the start in  
  # my old project, so those work without any issues, but to achieve that with 
  # all the other menus out there is something that I don't think I will ever 
  # try. In short, I removed this feature, but kept in the settings, so that I
  # can import all the setting scripts into my old project whenever I make an 
  # update to this system without always adding in these in my project.
  # Just ignore them kindly, okay? :P
  #
  # And the rest of the settings here are font settings.
  #-----------------------------------------------------------------------------
  ListVisual = {
    :padding => 150,
    :key_type => :name, # :name, :img or :icon
    :boxes => { # Array = gradient, single = fill
      :names => [Color.new(250,100,80,155),Color.new(255,255,80,155)],
      :keys => Color.new(0,0,0,80),
      :res => Color.new(0,0,0,80),
      :c_res => Color.new(50,150,50,120),
      :locked => Color.new(255,120,120,155),
    },
    :font => {
      :names => { # Font properties for the function names:
        :type => "Aclonica", :size => 16, 
        :bold => false, :italic => false, :shadow => true, :outline => true,
        :font_col => Color.new(255,255,255,255), 
        :outline_col => Color.new(0, 0, 0, 128),
      },
      :keys => { # Font properties for the key names:
        :type => "Aclonica", :size => 16, 
        :bold => false, :italic => false, :shadow => true, :outline => true,
        :font_col => Color.new(255,255,255,255), 
        :outline_col => Color.new(0, 0, 0, 128),
      },
      :res => { # NOT USED!
        :type => "Aclonica", :size => 16, 
        :bold => false, :italic => false, :shadow => true, :outline => true,
        :font_col => Color.new(255,255,255,255), 
        :outline_col => Color.new(0, 0, 0, 128),
      },      
    },
  }
  
  #-----------------------------------------------------------------------------
  # Popup Window Visual Settings:
  #-----------------------------------------------------------------------------
  # Visual settings for the popup window. Ohh, wait, it says that in the name
  # of this setting already, right? o.o
  #
  # Details in order:
  #
  #   :add_w => pixels,
  # Like I mentioned somewhere already (forgot where :P), the popup window will
  # scale automatically to fit the text in it. But in some cases, the text size
  # calculation can fail for some font types for some reasons. Damn, too many
  # "some"s. >.>
  # In any case, you can correct that here by specifying a constant width to
  # be added to the calculated width value, ensuring that your text doesn't get
  # cut down on any side of the window.
  #
  #   :key_type => :name/:icon/:img,
  # This will decide how will the keys be displayed in the popup window.
  # It should be obvious which option will yield which result, so no more 
  # details for this one. :P
  # It should also be obvious that I copy/pasted this description. :P
  #
  #   :lines => {
  #     :y_add => pixels,
  #     :changed => color_setting,
  #     :sideeff => color_setting,
  #   },
  # Okay, 3 settings here, all connected to some mysterious lines... :D
  # These lines appear for the :changed and :sideeff texts in the popup window.
  # Their purpose is to clearly separate the key-bind the player changed and 
  # side effects of the change (if there was any).
  # Depending on your font settings, you might need to move the lines a bit 
  # up or down, and that is what you can do with the :y_add settings.
  # The lines are drawn at the same Y position like the texts, so to put them
  # below the texts, you must add some pixels for their Y value.
  # The color settings will set the colors for these lines.
  # As with all color options, you can use the 2 type of color settings I 
  # mentioned already somewhere above to make a simple colored line or a 
  # gradient colored line.
  #
  # And there is the usual font setting area here too.
  #-----------------------------------------------------------------------------
  PopVisual = {
    :add_w => 12,
    :key_type => :name, # :name, :img or :icon
    :lines => { # Array = gradient, single = fill
      :y_add => 19,
      :changed => Color.new(255,255,120,255),
      :sideeff => Color.new(200,105,255,255),
    },
    :boxes => { # Array = gradient, single = fill
      :names => [Color.new(250,100,80,205),Color.new(255,255,80,205)],
      :keys => Color.new(0,0,0,120),
    },
    :font => {
      :type => "Aclonica", :size => 16, 
      :bold => false, :italic => false, :shadow => true, :outline => true,
      :font_col => Color.new(255,255,255,255), 
      :outline_col => Color.new(0, 0, 0, 128),
    },
  }

  #-----------------------------------------------------------------------------
  # Menu Category Settings:
  #-----------------------------------------------------------------------------
  # And finally (for real), the settings for the control configuration 
  # categories.
  #
  # With these settings, you can categorize your functions in a senseful manner.
  # Everybody likes organized categories for their stuffs, right? :P
  #
  # You could make a category for menu buttons, for map buttons, for battle 
  # buttons, and so on.
  #
  # Here is how the setting layout looks like for each categories:
  #
  #   :categ_symbol => {
  #     :name => "category button name",
  #     :help => "category help text",
  #     :list => [:function_sym_1, :function_sym_2, ...],
  #     :max => max_key_binds,
  #     :type => :buttons,
  #     :setting => [:path1,:path2,...],
  #   },
  #
  # The :categ_symbol can be whatever you want it to be, but it must be a 
  # symbol!
  #
  # So, 6 settings for each menu category (5 actually, you will see :P).
  # Here are the details on them:
  #
  #   :name => "text",
  # The name of the menu category button. 
  #
  #   :help => "text",
  # The help text shown in the help window for the category.
  # You can use message codes in these texts if you want.
  # Again, make new lines with \n if needed.
  #
  #   :list => [:function_sym_1, :function_sym_2, ...],
  # This will decide which functions the menu category will show.
  # Enter any valid function symbol in the array. Make sure that the path 
  # setting that you enter in the :setting option actually contains these 
  # function symbols!
  # 
  #   :max => max_key_binds,
  # The number of available key-binds for a function. It should be an integer
  # number from 1 to infinity (although you probably shouldn't allow absurdly
  # lot of key-binds for the same functions).
  #
  #   :type => :buttons,
  # And this is why I wrote that it is actually 5 options only here.
  # This setting should always look exactly how you see it above.
  # If you read all of the description I made in this section, you probably
  # already know that the menu I made was not actually for the control options 
  # only, but for some other things as well (such as resolution selection, 
  # volume control, and all the usual stufss). This setting has been used for
  # the purpose of allowing all these options in the menu, but since I stripped
  # those from this release (there are many scripts with these options already
  # out there - well, except the resolution option), you don't need to worry
  # about this one, just copy/paste it into your category settings and 
  # that's it.
  #
  #   :setting => [:path1,:path2,...],
  # And this is where you set the path of the used functions in the :list 
  # option. Each nested path that leads to the functions should be listed in
  # the order of top level to low level path symbols. For example:
  #   :path1 => {
  #     :path2 => {
  #       :funct_1 => [:key1,:key2],
  #       :funct_2 => [:key1],
  #       ...
  #     },
  #   },
  # The above sample setting would need to use the following :setting optiion 
  # here:
  #   :setting => [:path1,:path2],
  # Because that is how we reach the functions listed in the :list option here.
  # Remember, they are just like folders on your PC!
  #
  # You can make as many menu categories as you want!
  #
  # And this should be it for this setting area!
  # Ohh, my kittens, finally, finsihed the documentation, yay! O_O
  #-----------------------------------------------------------------------------
  Categs = {
#~     :resolutions => { # Resolution Selection: 
#~       :name => "Resolution",
#~       :help => "Set the game's resolution here!",
#~       :list => System::Defaults[:resolutions],
#~       :max => 3,
#~       :type => :resolution,
#~       :setting => [:resolutions],
#~     },
    :system => { # System Buttons:
      :name => "System Buttons",
      :help => "Set up the system buttons here!",
      :list => System::Defaults[:system].keys,
      :max => 2,
      :type => :buttons,
      :setting => [:system],
    },
    :p1_menu => { # Player 1 Menu Buttons:
      :name => "Menu Buttons",
      :help => "Set up the menu buttons here!",
      :list => [:m_up,:m_down,:m_left,:m_right,:m_confirm,:m_cancel,
                :m_pgup,:m_pgdown,:m_toggle,:m_clear],
      :max => 2,
      :type => :buttons,
      :setting => [:p1],
    },
    :p1_shortcuts => { # Player 1 Menu Shortcut Buttons:
      :name => "Shortcut Buttons",
      :help => "Set up the menu shortcut buttons here!\n"+
               "You can find yourself in your favourite menu with just one key press!",
      :list => [:m_menu,:inventory,:status,:craft,:quest,:cards,:map,:options],
      :max => 2,
      :type => :buttons,
      :setting => [:p1],
    },
    :p1_map => { # Player 1 Field Buttons:
      :name => "Field Buttons",
      :help => "Set up the field buttons here!",
      :list => [:f_up,:f_down,:f_left,:f_right,:f_confirm,:f_cancel,:f_move,
                :mmode,:mtype,:d_through],
      :max => 2,
      :type => :buttons,
      :setting => [:p1],
    },
    :p1_battlekeys => { # Player 1 Battle keys:
      :name => "Battle Buttons",
      :help => "Set up the keys used in battle here!",
      :list => [:item_1,:item_2,:skill_1,:skill_2,:skill_3,:special],
      :max => 2,
      :type => :buttons,
      :setting => [:p1],
    },
    # Add more menu categories here!
  }
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
