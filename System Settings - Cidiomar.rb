#===============================================================================
# * [ACE] Control Configuration System - Main Settings (Cidiomar's Input)
#===============================================================================
# * Made by: Sixth (www.rpgmakervxace.net, www.forums.rpgmakerweb.com)
# * Version: 1.5
# * Updated: 04/07/2017
# * Requires: Cidiomar's Input
#        /--> Shaz's Super Simple Mouse - modified (or another mouse script)
#        \----- Only if you want to enable mouse cursor usage!
#-------------------------------------------------------------------------------
# * < Description >
#-------------------------------------------------------------------------------
# * This is the place where you will set up your default key-binds and rules 
#   for your functions. 
# * Also contains the settings for your settings file, key image folder, and
#   other miscellaneous settings.
# * The last 3 setting areas here are majorly connected to each other!
#   Make sure to read about those with extra caution in their description!
#   Editing one, but not the others can and will most probably have undesired 
#   effects, so double check everything you changed in all 3 settings!
#===============================================================================
module System
  #-----------------------------------------------------------------------------
  # Debug Settings:
  #-----------------------------------------------------------------------------
  # This is for debugging purposes!
  # If this is true, every time you start the game, the file used to store your
  # settings will be reloaded with the default settings you set up in this 
  # script!
  # true = reload, false = no reload.
  # Use it if you want to quickly reload the settings for some reason (most
  # probably for debugging).
  # WARNING:
  # You must set this to false for your public game relase, otherwise it will
  # break your control settings menu!
  #-----------------------------------------------------------------------------
  Reload = true

  #-----------------------------------------------------------------------------
  # Current Key-Bind Print Settings:
  #-----------------------------------------------------------------------------
  # When you press the :m_toggle function keys on the control configuration
  # scene, your current control key-bind settings will be saved in a file in 
  # your project folder.
  # In case you don't want to worry about messing up the default control 
  # settings due to ignoring your key-bind rule settings by mistake, you can
  # start the game, open the controls menu, and set your new key-binds there.
  # Once you are finished with the editing, press any of the :m_toggle 
  # function keys, and you will see that the current key-bind settings from the
  # game are saved in your project's folder.
  # That file will contain a ready-to-be-imported setting layout, so you can 
  # simply copy/paste it into the default key-bind setting area in this script,
  # replacing the entire setting named 'Defaults' here with that one.
  #
  # So, why do this?
  # Well, the key-bind rules are enforced in the game, so unless you messed up
  # your rule settings, you will never make an incorrect key-bind setting there.
  # What is an incorrect setting? It is when you set 2 different menu functions
  # to the same key, for example. So, lets say, you set the cancel and confirm
  # functions to the same key, that would be bad, right? :D
  #
  # It might also be a bit more "human readable" to set your keybinds up in the 
  # game with a menu, visuals and such.
  #
  # Anyway, set up the name of the file which will contain the new key-bind
  # settings here. Include the file extension in the name as well!
  #
  # The type can be:
  # :reset - Will save only one key-bind setting, overwriting any previous file.
  # :add_bottom - Will save the most recent key-bind setting to the end of the
  #               file. Will not overwrite your old saved settings in the file.
  # :add_top - Will save the most recent keybind setting to the top of the file.
  #            Will not overwrite your old saved settings in the file.
  #
  # NOTE:
  # This feature is only available in play-test mode! 
  #-----------------------------------------------------------------------------
  PrintF = {
    :filename => "KeyBindPrint.txt",
    :type => :add_bottom,
  }
  
  #-----------------------------------------------------------------------------
  # Environmental Path Settings:
  #-----------------------------------------------------------------------------
  # The environmental path of the folder for your file.
  # This path can differ from PC to PC, and that is why it should use the 
  # 'ENV' module to get the correct path to the desired folder(s).
  # In any case, you can edit the text inside the [brackets] to get different
  # folder paths. You can use these values:
  #
  # "AppData" = Will get: "C\\Users\\*Username*\\AppData\\Roaming"
  # "LOCALAPPDATA" = Will get: "C\\Users\\*Username*\\AppData\\Local"
  # "ProgramFiles" = Will get: "C\\ProgramFiles (x86)"
  # "CommonProgramFiles" = Will get: "C\\ProgramFiles (x86)\\Common Files"
  #
  # Again, these folder paths might differ, especially on different OS.
  # The examples I gave are for a Windows 7 PC with the windows installed on 
  # the C partition. 
  #
  # If you use the environmental path, depending on which one you choose, the
  # setting file can be a separate file for the different users logged in on the
  # PC (as Windows users).
  #
  # Also, some of these might require your game to be "Run as Administrator"!
  #
  # If you don't want to use these environmental folder paths, you can use an
  # empty string for this setting, which looks like this: 
  #   DPath = ""
  # In this case, the root of the path will be your project's folder, so if you
  # just enter this, it will be in your project's folder.
  # This also means that all users of the PC (as Windows users) will share the
  # same settings. Might not be a good idea, if you ask me. :P
  #-----------------------------------------------------------------------------
  DPath = ENV["LOCALAPPDATA"]

  #-----------------------------------------------------------------------------
  # Static Path Settings:
  #-----------------------------------------------------------------------------  
  # This is the static sub-folder path to the actual file. These are the 
  # non-environmental parts of your folder path to your file.
  # Each string you add into the array will be a sub-folder created, nested in
  # each other.
  # The sample settings will place the used files to the following folder:
  # "C\\Users\\*Username*\\AppData\\Local\\MyProject_CSS\\Settings\\"
  # Again, this path might differ for different PC/OS versions.
  #-----------------------------------------------------------------------------
  SPath = ["MyProject_CCS","Settings"]

  #-----------------------------------------------------------------------------
  # File Name Settings:
  #-----------------------------------------------------------------------------  
  # And finally, the last setting for your setting file, it's name.
  # You can name it however you like.
  # It's extension can also be anything you like, such as .ini/.txt/.rvdata2 ...
  # Note that some minor encoding will be used on the file, so you will not be 
  # able to edit the file directly, regardless of what kind of extension you
  # use for it!
  #-----------------------------------------------------------------------------
  FileName = "Controls.rvdata2"
  
  #-----------------------------------------------------------------------------
  # Image Folder Settings:
  #-----------------------------------------------------------------------------
  # The folder containing all of the key images (if you use them).
  # You can ignore this if you don't plan to use custom images for your control
  # keys in the game.
  #-----------------------------------------------------------------------------
  ImgFolder = "Graphics/Key Images/"
    
  #-----------------------------------------------------------------------------
  # Mouse Addon Settings:
  #-----------------------------------------------------------------------------
  # The settings here will only work with Shaz's Super Simple Mouse script!
  #
  # Some settings here will decide when the mouse cursor will show up in your 
  # game.
  # If the mouse cursor is invisible, you can NOT select options in the menu
  # with the mouse only, and you can NOT move around with the mouse on the map.
  # You can still confirm selections or cancel out of menus/commands if you 
  # set some of these functions to the mouse buttons (left, right and middle 
  # clicks).
  #
  # Certain games just don't need mouse based movement on the map, so there 
  # would be no point of showing the cursor there.
  # Similarly, certain menus just don't use the mouse cursor for selections,
  # so, if you have one of these menus, you can turn it off anytime, even for
  # some specified menu scenes only.
  #
  # You can see several options here, and these are:
  #
  #   :lock_cursor => type,
  # With this you can forcibly lock the mouse cursor inside your game's window.
  # You got 4 possible values/types here:
  # true - Always locks the mouse inside the game's window.
  # false - The mouse can freely move outside the game's window anytime.
  # :fullscreen - The mouse will be locked inside the game's window in 
  #               full-screen mode only.
  # :windowed - The mouse will be locked inside the game's window in 
  #             windowed mode only.
  # Careful with this, some people might not like locked cursors! :P
  # Although full-screen games got no reason to let the mouse outside, so...
  #
  #   :force_sys_cursor => true/false,
  # In case you disable the mouse cursor with any of the next 3 options, you can
  # forcibly show the system cursor (of Windows) instead on the scenes where the 
  # mouse is disabled. The in-game graphic of the mouse cursor will be invisible
  # on the disabled scenes, so if you want to show the system cursor when that
  # happens, you can do so by setting this option to true, otherwise set it to
  # false.
  #
  #   :map_cursor => true/false,
  # This enables or disables the mouse cursor features on the map scene.
  # true fully enables the mouse on the map (meaning you can move around the map
  # with the mouse if you want), while false will disable the mouse cursor 
  # features on the map (meaning you can still use the mouse buttons on the map
  # if you have some functions set to them, like confirmation, etc, but you
  # won't be able to move the character with the mouse anymore).
  #
  #   :menu_cursor => true/false,
  # If you don't want a menu cursor in any of your menus, set this to false.
  # Doing that will disable the mouse cursor in any of your menus. Again, you
  # can still confirm or cancel selections with the mouse buttons if you 
  # asigned a function for them in my control configuration settings.
  # If you set this to true, all menus except the ones you list in the next 
  # option (named :disabled_scenes) will have the mouse cursor, and you will
  # be able to select options by hovering the mouse cursor over them.
  #
  #   :disabled_scenes => ["scene_1", "scene_2", ...],
  # If you have set the :menu_cursor option to true, but you would still like to
  # disable the mouse cursor for some specific menus only, you can do so with 
  # this setting. 
  # You will need to enter the name of the scene as strings into the array.
  # Any scenes entered will have the mouse cursor disabled.
  # Not entered scenes will read the :menu_cursor option's value to decide the
  # mouse cursor's visibility.
  #-----------------------------------------------------------------------------
  MouseAdds = {
    :lock_cursor => false,
    :force_sys_cursor => true,
    :map_cursor => true,
    :menu_cursor => true,
    :disabled_scenes => [],
  }
    
  #-----------------------------------------------------------------------------
  # Usable Keys Settings:
  #-----------------------------------------------------------------------------
  # All usable keys for the key configuration must be listed in this array!
  # Do NOT use duplicate names which point to the same key (such as 
  # :kESC and :kESCAPE in Neon Black's Keyboard Input script)!
  # The player will NOT be able to set ANY key-binds to ANY keys missing from 
  # here! 
  # 
  # I believe, I added all of the keys which can be found on a regular keyboard
  # with the exception of some special keys (such as the Windows button, 
  # for obvious reasons, and the PrintScreen button, which works in a different
  # way than the others and that other way renders it unusable for the current
  # keyboard input checks).
  #
  # You can see that I only added the separated versions of some special keys,
  # such as ALT and CTRL. This means that it will differentiate between the
  # left and right keys from those. If you would like to treat them as single
  # keys, you should remove those and add their unified symbol version (so,
  # instead of :kLALT and :kRALT, you use :kALT, for example).
  # There is no point in keeping all versions of them here, so either use the
  # separated versions or the unified one, but whichever you use, remove the
  # other one(s)!
  #
  # The mouse click symbols will use Cidiomar's Input script too!
  #
  # Don't ask about the symbol names of the last part here... 
  # Cidiomar named these in his script, and yes, they look weird for sure.
  # You can check what each of them represents on the keyboard if you don't know
  # it from these symbols (and why would you, right? :P) in the "Vocab Settings"
  # script, in the 'Keys' settings.
  #-----------------------------------------------------------------------------
  AllKeys = [
    # Mouse Clicks:
    :LBUTTON, :RBUTTON, :MBUTTON, :XBUTTON1, :XBUTTON2,
    # Numbers:
    :N0, :KEY_1, :KEY_2, :KEY_3, :KEY_4, :KEY_5, :KEY_6, :KEY_7, :KEY_8, :KEY_9,
    # Numpad Numbers:
    :NUMPAD0, :NUMPAD1, :NUMPAD2, :NUMPAD3, :NUMPAD4,
    :NUMPAD5, :NUMPAD6, :NUMPAD7, :NUMPAD8, :NUMPAD9,
    # Other Numpad stuffs:
    :MULTIPLY, :ADD, :SEPARATOR, :DIVIDE, :SUBTRACT, :DECIMAL,
    # Lock keys:
    :CAPITAL, :NUMLOCK, :SCROLL,
    # Function Keys:
    :F1, :F2, :F3, :F4, :F5, :F6,  :F7,  :F8, :F9, :F10, :F11, :F12,
    :F13, :F14, :F15, :F16, :F17, :F18,  :F19,  :F20, :F21, :F22, :F23, :F24,
    # Letters:
    :LETTER_A, :LETTER_B, :LETTER_C, :LETTER_D, :LETTER_E, :LETTER_F, :LETTER_G,
    :LETTER_H, :LETTER_I, :LETTER_J, :LETTER_K, :LETTER_L, :LETTER_M, :LETTER_N, 
    :LETTER_O, :LETTER_P, :LETTER_Q, :LETTER_R, :LETTER_S, :LETTER_T, :LETTER_U,
    :LETTER_V, :LETTER_W, :LETTER_X, :LETTER_Y, :LETTER_Z,
    # Arrows Keys:
    :LEFT, :RIGHT, :UP, :DOWN,
    # Others:
    :LMENU, :RMENU, :LCONTROL, :RCONTROL, :LSHIFT, :RSHIFT,
    :RETURN, :BACK, :SPACE, :ESCAPE, :SHIFT, :TAB, :MENU, :CONTROL,
    :DELETE, :INSERT, :PRIOR, :NEXT, :HOME, :END, :PAUSE,
    # Symbols:
    :masculine, :THORN, :onequarter, :threequarters, :questiondown, :Udiaeresis,
    :Ucircumflex, :Yacute, :onehalf, :guillemotright, :Agrave, :acircumflex
  ]
      
  #-----------------------------------------------------------------------------
  # Default Control Settings:
  #-----------------------------------------------------------------------------
  # And this is where most of the magic happens. :D
  # The settings you make here will be the starting control configuration for
  # your game. This is what the player can change during the game if he/she
  # wants to.
  #
  # The structure of this setting is entirely up to you.
  # What that means? 
  # Well, you can categorize your control settings however you want by using
  # nested hashes. It is not necessary to do that though, you don't even have
  # to use any nested hashes if you don't want to.
  # I recommend some kind of categorization still, so that you don't get lost
  # in your settings if you got a lot of functions.
  #
  # Okay, before we start with the more extensive stuff here, lets learn about
  # the important keywords I will use here (and in later descriptions)...
  #
  # - Functions:
  # The functions are the actual things your player can trigger in your game.
  # For example, "Menu Confirmation" is a function, just like "Quick Save" or
  # "Move Up", for example.
  # In the sample settings, you will see these set up as:
  #   :function_name => [key_bind_settings], 
  #   :function_name => [:key_symbol_1,:key_symbol_2,...],
  # Both of the above mentioned formats are the same!
  # This is to demonstrate how a valid key-bind setting looks like.
  # Function names must be symbols!
  #
  # - Key-binds:
  # The above mentioned functions must have a key-bind setting so that the 
  # player can actually trigger them.
  # With this script, your key-bind settings can contain multiple keys.
  # That means that the player can trigger the same functions with different
  # keys.
  # Regardless if you use more than one keys for your key-binds or not, this
  # must be an array with one or more key symbols in it or an empty array (in
  # which case there would be no default keys set for the function, but the 
  # player will still be able to assign keys for it in the game).
  #
  # - Keys:
  # The actual trigger keys for your functions. 
  # Your key-bind settings can contain more than one keys, and if they do, the
  # player will be able to trigger the same function with more than one key.
  # These must be symbols, and they must correspond a valid key identifier from
  # the keyboard/mouse script you use! 
  # These key symbols must also be in the above 'AllKeys' settings, or else the
  # player will not be able to set ANY function to use the missing key!
  #
  # - Path Configuration (categorization):
  # This is what I mentioned at the start of this section.
  # Paths are basically the same as folders on your PC.
  # They are nested hashes here, but work exactly like the folders on your PC,
  # and serve the same purpose as well (categorization).
  # To make a direct comparison, lets compare a folder structure and a path 
  # configuration:
  #   Folder: Computer\C:\Program Files\MGRR\Data\Function_A.ext
  #   Path:   $system[:c][:program_files][:mgrr][:data][:function_a]
  # This would be how to access your configured paths.
  # The $system in this case is your root folder that is always the same, like 
  # the "Computer" is for your PC.
  # And this is how your configuration would look like:
  #   :c => {
  #     :program_files => {
  #       :mgrr => {
  #         :data => {
  #           :function_a => [:key_symbol_1, :key_symbol_2, ...],
  #           ...,
  #         },
  #       },
  #     },
  #   },
  # So, as you can see, nested hashes.
  # I don't recommend making too many nested hashes though, keep it categorized
  # but within limits! You don't need many categories for any kind of game, let
  # alone for most RPGs.
  # In the sample settings, I used only one nest level to keep it simple.
  # Remember that the more complicated path configuration you make, the longer
  # your input check script calls and message codes will get!
  # 
  # The sample settings I made cover all of the default functions 
  # RPG Maker VX Ace has. Aside from those, I added in some extra functions to
  # show how it's done.
  #
  # Another important thing to mention is, that the control configuration menu
  # can only display functions from the same category per menu command button! 
  # So, if you plan to break your control settings into "Menu", "Map" and "Misc"
  # categories, a menu category can only display key-bind settings for the 
  # functions of "Menu", "Map" or "Misc", you can NOT combine them under the 
  # same menu command!
  # You can, however, select which functions will be displayed from the 
  # category, so you don't have to display all the function key-bind settings
  # from the "Misc" category under one menu command, you can split them up
  # however you want.
  # Keep this in mind when making your path settings/categorization here!
  #
  # NOTE:
  # If you change the names/path of the default functions, you will also need
  # to change the input checks of ANY functions you changed in the 
  # Default Input Check Methods scripts I provided! If you don't do that, your
  # input checks will be non-functional or your game can even crash!
  #-----------------------------------------------------------------------------
  Defaults = {
    # Control Mode Settings (NOT USED!):
    :game => {
      :control => [:keyboard, :gamepad],
    },
    # All button settings are below!
    :system => { # Default System Buttons:
      :fullscreen  => [:F5],   # Used by Zeus81's Fullcreen++ script!
      :screenratio => [:F6],   # Used by Zeus81's Fullcreen++ script!
      :resolution  => [:F7],   # NOT USED!
      :qload       => [:F10],  # NOT USED!
      :qsave       => [:F11],  # NOT USED!
      :debug       => [:F9],   # Opens the debug menu.
      :help        => [:LMENU], # NOT USED!
    },
    :p1 => { # Default Button Configuration for Player 1:
      # Menu Keys (effective in menus only!):
      :m_up       => [:LETTER_W,:UP],    # Cursor up
      :m_down     => [:LETTER_S,:DOWN],  # Cursor down
      :m_left     => [:LETTER_A,:LEFT],  # Cursor left
      :m_right    => [:LETTER_D,:RIGHT], # Cursor right
      :m_confirm  => [:RETURN,:LBUTTON], # Confirm selection
      :m_cancel   => [:ESCAPE,:RBUTTON], # Cancel selection / exit menus
      :m_pgup     => [:LETTER_Q,:PRIOR], # Previous page / page up
      :m_pgdown   => [:LETTER_E,:NEXT],  # Next page / page down
      :m_toggle   => [:TAB],       # Letter type toggle on the name enter menu / character stat next page on the shop menu
      :m_clear    => [:LSHIFT],    # Clears the key-bind for the selected function on the control config menu
      # Menu Shortcut Keys (effective on the map only!):
      :m_menu     => [:ESCAPE,:RBUTTON], # Opens the main menu
      :inventory  => [:LETTER_I],       # NOT USED!
      :status     => [:LETTER_H],       # NOT USED!
      :craft      => [:LETTER_C],       # NOT USED!
      :quest      => [:LETTER_L],       # NOT USED!
      :cards      => [:LETTER_T],       # NOT USED!
      :map        => [:LETTER_M],       # NOT USED!
      :options    => [:LETTER_O],       # NOT USED!
      # Field Keys (effective on the map only!):
      :f_up       => [:LETTER_W,:UP],    # Move up
      :f_down     => [:LETTER_S,:DOWN],  # Move down
      :f_left     => [:LETTER_A,:LEFT],  # Move left
      :f_right    => [:LETTER_D,:RIGHT], # Move right
      :f_confirm  => [:LETTER_F,:LBUTTON], # Interaction on the map / message skip / message speed up
      :f_cancel   => [:LETTER_X,:RBUTTON], # Message skip / message speed up
      :f_move     => [:SPACE,:LBUTTON], # Mouse movement mode (requires Shaz's Mouse script)
      # Battle Keys (effective on the map only!):
      :item_1     => [:LETTER_Q], # NOT USED!
      :item_2     => [:LETTER_E], # NOT USED!
      :skill_1    => [:KEY_1], # NOT USED!
      :skill_2    => [:KEY_2], # NOT USED!
      :skill_3    => [:KEY_3], # NOT USED!
      :special    => [:LETTER_R], # NOT USED!
      # Misc. Keys:
      :mmode      => [:LSHIFT], # Toggle between movement modes (walk / run)
      :mtype      => [:TAB],    # NOT USED!
      :d_through  => [:LCONTROL], # Toggle debug through mode
    },
    # Add more function / key-bind settings here!
  }
  
  #-----------------------------------------------------------------------------
  # Shared Key-Bind Setting Presets:
  #-----------------------------------------------------------------------------
  # This is where you can set up preset settings which will decide which 
  # functions can share key-binds with other functions.
  #
  # NOTE:
  # Without a doubt, this is the most confusing and hard to get setting in this
  # script! If you have read the notes I made at the header of this script, you
  # should already know that the last 3 settings here are closely connected to
  # each other. Depending on how you set up your settings in the default 
  # key-bind settings (named as Default), the next two setting areas
  # (PresetRules - this one, and ButtonRules - next one) will majorly change
  # in their format as well! Everything depends on your default key-bind 
  # settings, so make sure to finalize that setting before you even attempt to
  # set the next two setting areas up, otherwise you will have some major edits
  # to do in the other setting areas too!
  #
  # This setting alone will do absolutely NOTHING!
  # These are presets which you can assign to the next setting below.
  # Because you will most probably have tons of functions sharing the same
  # rules for this, you can simply set them up here only once, and assign them
  # to multiple functions in the next setting (named as ButtonRules).
  #
  # Okay, so how does this work?
  # Kinda hard to explain without getting into the next setting area, so if you
  # don't understand it at first, get to the next setting description, read it,
  # and come back here after that. Doing this may or may not help you, dunno. :P
  #
  # Lets see the format first:
  #
  #   :preset_symbol => {
  #     :path1 => {
  #       :path2 => {
  #         :path3 => [:function_sym_1, :function_sym2, ...],
  #         :path4 => [:function_sym_1, :function_sym2, ...],
  #       },
  #       :path5 => [:function_sym_1, :function_sym2, ...],
  #     },
  #   },
  #
  # Note that the above example is extremely complex, and well, it is just an
  # example of how complicated it can get if you use too many path settings.
  # The actual setting format can and should look way less complicated.
  #
  # So, what do we see in the format example? 
  #
  # The :preset_symbol can be named however you want, but it must be a symbol!
  # That is what you will use to assign the settings from this one (PresetRules)
  # to the next one (ButtonRules).
  #
  # The :paths you see in the format example can be 3 types:
  # 1. Connection path. This is merely used for categorization in your default 
  #    key-bind settings from above (named as Defaults). They do not hold any
  #    functions/key-bind settings themselves, but they may hold another path
  #    setting (nested hash). 
  # 2. End level path. This is the last level in your path settings, and these
  #    should hold at least 1 function/key-bind setting (but they really should
  #    hold more, it would be a waste to have a whole category for just 1 
  #    function, right? :P).
  # 3. A mix of the above 2 types.
  #
  # In the format example, :path2 belongs to the 1st category I explained, 
  # because it doesn't hold any function/key-bind settings, only other paths.
  #
  # :path3, :path4  and :path5 belongs to the 2nd category, because they hold 
  # some function/key-bind settings. In this setting here (PresetRules), only 
  # these type of paths can have a function array assigned. 
  # Any functions listed in the function array in these path types here can
  # share the same keys with the function you assigned this preset rule in the
  # next setting (ButtonRules). 
  # Not listed functions can NOT share the same keys with the assigned function!
  # 
  # And :path1 belongs to the 3rd path type, because it holds other paths and
  # function/key-bind settings as well.
  #
  # Optionally, there is another format you could use which is less modular,
  # but certainly shorter.
  #
  #   :preset_symbol => {
  #     :path1 => {
  #       :path2 => true,
  #     },
  #   },
  #
  # And this would allow the function using this rule to share the keys with
  # all of the functions found in the [:path1][:path2] path/category.
  # Much more compact, but less modular. 
  # This lacks the option to select specific functions from the same category,
  # but if you don't need that option, this might be even better to use for you.
  #
  # I am quite sure that this is very confusing, and if you didn't get what I
  # just described, don't feel bad, even I am not sure what the heck did I do
  # in this setting. :D
  #-----------------------------------------------------------------------------
  PresetRules = {
    :system1 => { # Allows sharing the same keys with the menu keys.
      :p1 => [
        :m_up, :m_down, :m_left, :m_right,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    :menu1 => { # Allows sharing the same keys with field buttons and hotkeys (P1).
      :p1 => [
        :f_up, :f_down, :f_left, :f_right, :f_confirm, :f_cancel, :f_move,
        :m_menu, :inventory, :status, :craft, :quest, :cards, :map, :options,
        :item_1, :item_2, :skill_1, :skill_2, :skill_3, :special,
        :mmode, :mtype, :d_through,
      ],
      :system => [ :qload, :qsave, :debug ],
    },
    :field1 => { # Allows sharing the same keys with the menu keys.
      :p1 => [
        :m_up, :m_down, :m_left, :m_right,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    :field2 => { # Only used for the :m_menu function (Main Menu button)
      :p1 => [
        :m_up, :m_down, :m_left, :m_right, :f_cancel,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    :field3 => { # Only used for the :f_cancel function (Map Cancel button)
      :p1 => [
        :m_up, :m_down, :m_left, :m_right, :m_menu,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    :field4 => { # Only used for the :f_move function (Mouse Movement button)
      :p1 => [
        :m_up, :m_down, :m_left, :m_right, :f_confirm,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    :field5 => { # Only used for the :f_confirm function (Map Interaction button)
      :p1 => [
        :m_up, :m_down, :m_left, :m_right, :f_move,
        :m_confirm, :m_cancel, :m_pgup, :m_pgdown, :m_toggle, :m_clear,
      ],
    },
    # Add more preset rule settings here!
  }
  
  #-----------------------------------------------------------------------------
  # Key-Bind Rule Settings:
  #-----------------------------------------------------------------------------
  # And finally (for real, FINALLY!), this is where you can set your rules for
  # your functions.
  # Depending on your settings here, you can block changes to some key-binds,
  # you can set them as "must set" key-binds, and you can set which functions
  # can share the same keys with other functions.
  #
  # In the contol configuration menu, the player will never be able to make an
  # incorrect key-bind setting thanks to the rules you setup here.
  # For example, if you set a key-bind to be unchangeable, the player won't
  # be able to change it at all in the game, or if you set it as a "must set"
  # function, the player will never be able to make a control setting which 
  # would otherwise remove the last key-bind from that function.
  # This can prevent awkward situations due to incorrect control settings, such
  # as not being able to move the cursor in menus. If the player would be able
  # to remove all key-binds from the cursor movement functions, it would pretty
  # much brake the game, right? 
  #
  # NOTE:
  # You MUST set a button rule for ALL of your functions!
  # If you miss one or more, you risk the possibility of breaking your entire
  # control configuration menu!
  #
  # Now, onto the nasty details!
  #
  # Lets start with the format:
  #
  #   :path1 => {
  #     :path2 => {
  #       :function_sym_1 => {* rule_settings_go_here *},
  #       :function_sym_2 => {* rule_settings_go_here *},
  #       ...
  #     },
  #   },
  # 
  # Again with these paths, argh! >.>
  # Yeah, I know, but like I wrote at least 2 times already above, these last 3
  # setting areas a closely connected.
  # 
  # Eventually, what you will need to do here, to keep it relatively "simple",
  # is to copy over your entire setting area from the default control options
  # (named Default), but instead of setting the key-binds for your functions,
  # here you will set up the key-bind rules for your functions.
  # So, this setting shares the exact same format like the one name Default in
  # this script, with the exception of what you actually set up with it.
  # To be even more specific (I was specific enough before, right? o.o), the
  # path settings/categorization here must be the same like in the Default 
  # setting area.
  #
  # Now lets take a look at those pesky rule settings!
  # You got 3 types of rule settings. 
  # I will dedicate a whole section for each of the below.
  #
  # - The "must set" flag:
  # It is the easiest setting in this section, and is pretty self-explanatory.
  # The setting got the :must_set name, and it can be either true or false.
  # So, it looks like this:
  #   :must_set => true/false,
  # true means that the function must always have at least one key set up.
  # The player will not be able to make any control settings which would break
  # this rule in the control configuration menu.
  # And false means that the player can remove all key-binds the function might
  # have. Careful with using this option, mandatory functions must always have
  # this setting set to true (such as cursor movement functions, for example)!
  #
  # - The key-bind lock settings:
  # This option is used to lock a key-bind to a function.
  # This setting is optional only, and your should NOT use it if you don't plan
  # to lock a key-bind for a function!
  # The player will NOT be able to remove or change ANY locked key-binds in
  # the control configuration menu, and any control settings which would 
  # otherwise remove the locked key-bind(s) will be discarded!
  # The name of the setting is :can_change, and it's value is an array of 
  # key-bind indexes (primary, secondary, tertiary, and so on). 
  # It should look like this:
  #   :can_change => [index1, index2, ...],
  # Now... Pay attention to the next few lines at all cost!
  # Any key-bind index you enter will be changeable, and any key-bind index
  # NOT entered will be locked for the function!
  # So, it's just like the name of the setting suggests, right? 
  # Again, if you don't want any key-binds locked for the function, you should 
  # omit this setting completely!
  # 
  # - The key-bind sharing rules:
  # Sharing is caring, right? :P
  # This is the last option you set up here, and it is basically just a link to
  # the above preset rules (from the PresetRules settings explained above).
  # Technically, you could set up the rules for this here just like you would
  # in the PresetRules setting area above, but because of your functions
  # must have a key-bind sharing rule, re-typing the same rules for all of these
  # functions would be tedious and would eat up quite a lot of space.
  # The name of this setting is :same_key and it's just a link to the above 
  # setting. It should look like this:
  #   :same_key => PresetRules[:preset_rule_symbol],
  # You just change the :preset_rule_symbol with the symbols you used in the
  # PresetRules setting above, and that preset rule will be assigned for the
  # function.
  # So, what is this used for exactly?
  # Some of your functions may function even when another function got the same 
  # key set up. In these cases, there is no reason to block the key from all
  # the other functions, right?
  # The most simple example would be the cursor movement functions in your 
  # menus, and the character movement functions on the map. These can share the
  # same keys (and in most games, they do) without any conflict, unless you
  # have a menu which can be navigated without pausing the map scene, obviously.
  # That last scenario is the very reason this setting has been born, to allow
  # the separation of the cursor movement and character movement functions, but
  # you can use it for more than that.
  # For example, a "Quick Save" function, which should be usable only on the 
  # map usually, could share the same key as the menu confirmation button, 
  # because they wouldn't conflict with each other anyway (yeah, I question
  # my example's validity in real games, but hey, the possibility is there :P).
  # In any case, I hope, you get the idea, because I am certainly tired from
  # typing all of this in. >.>
  # And the last info, but pretty important still, is that if you don't want to
  # allow ANY other functions to share the same key with the function, you can
  # and you should omit this setting entirely!
  # For example, a full-screen or print-screen function could be used all the
  # time by the player, so mapping the same key for those and some other 
  # functions WILL break your game for sure. These functions should not have
  # any shared keys, so you should omit this setting for them!
  # 
  # And this concludes this "chapter"! :P
  # Phew! Finally, no more complicated settings to explain, yay!
  #-----------------------------------------------------------------------------
  ButtonRules = {
    :system => { # Default System Buttons:
      :fullscreen  => {:must_set => false, :can_change => [1], :same_key => {}},
      :screenratio => {:must_set => false },
      :resolution  => {:must_set => false },
      :help        => {:must_set => false },
      :qload => {:must_set => false, :same_key => PresetRules[:system1]},
      :qsave => {:must_set => false, :same_key => PresetRules[:system1]},
      :debug => {:must_set => false, :same_key => PresetRules[:system1]},
    },
    :p1 => { # Default Button Configuration for Player 1:
      # Menu Buttons:
      :m_up      => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_down    => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_left    => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_right   => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_confirm => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_cancel  => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_pgup    => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_pgdown  => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_toggle  => {:must_set => true, :same_key => PresetRules[:menu1]},
      :m_clear   => {:must_set => true, :same_key => PresetRules[:menu1]},
      # Field Buttons:
      :f_up       => {:must_set => true, :same_key => PresetRules[:field1]},
      :f_down     => {:must_set => true, :same_key => PresetRules[:field1]},
      :f_left     => {:must_set => true, :same_key => PresetRules[:field1]},
      :f_right    => {:must_set => true, :same_key => PresetRules[:field1]},
      :f_confirm  => {:must_set => true, :same_key => PresetRules[:field5]},
      :f_cancel   => {:must_set => true, :same_key => PresetRules[:field3]},
      :f_move     => {:must_set => true, :same_key => PresetRules[:field4]},
      # Menu Shortcuts:
      :m_menu     => {:must_set => true, :same_key => PresetRules[:field2]},
      :inventory  => {:must_set => true, :same_key => PresetRules[:field1]},
      :status     => {:must_set => true, :same_key => PresetRules[:field1]},
      :craft      => {:must_set => true, :same_key => PresetRules[:field1]},
      :quest      => {:must_set => true, :same_key => PresetRules[:field1]},
      :cards      => {:must_set => true, :same_key => PresetRules[:field1]},
      :map        => {:must_set => true, :same_key => PresetRules[:field1]},
      :options    => {:must_set => true, :same_key => PresetRules[:field1]},
      # Battle Keys:
      :item_1     => {:must_set => true, :same_key => PresetRules[:field1]},
      :item_2     => {:must_set => true, :same_key => PresetRules[:field1]},
      :skill_1    => {:must_set => true, :same_key => PresetRules[:field1]},
      :skill_2    => {:must_set => true, :same_key => PresetRules[:field1]},
      :skill_3    => {:must_set => true, :same_key => PresetRules[:field1]},
      :special    => {:must_set => true, :same_key => PresetRules[:field1]},
      # Misc. Keys:
      :mmode      => {:must_set => true, :same_key => PresetRules[:field1]},
      :mtype      => {:must_set => true, :same_key => PresetRules[:field1]},
      :d_through  => {:must_set => true, :same_key => PresetRules[:field1]},
    },
    # Add more rule settings here!
  }
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
