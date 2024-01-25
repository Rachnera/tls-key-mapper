#===============================================================================
# * [ACE] Control Configuration System - Vocab Settings (Cidiomar's Input)
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
# * This is the place to set up the display names of your functions and keys,
#   as well as help texts for your functions, icons and custom images used
#   for your keys, and lastly, your system messages.
# * You can also set up a format for the new message codes added with this 
#   script. In case you would like to always color the name of your functions
#   or keys, you can spare yourself from always entering the color codes before
#   and after them, and instead add them here only once.
# * All of your functions and keys must have all related vocab settings set up
#   here to avoid any display errors or crash issues!
#===============================================================================
module ConfigScene
  #-----------------------------------------------------------------------------
  # Message Code Format Settings:
  #-----------------------------------------------------------------------------
  # So, you want to always color function names as yellow and key names as red?
  # Or you want to wrap them between some kind of brackets?
  # Or you want to make their text bigger?
  # Or you... Okay, you get the idea, right? :P
  #
  # Just enter the format of how you would like to display them in your message
  # boxes, and these settings will be loaded every time you use the new message 
  # codes provided by this system.
  #
  # The setting values must be strings, obviously, and they must contain one %s 
  # sign in the case of key and function name text formats! That sign will be 
  # replaced with the name of the function/key. This ensures that you can put 
  # whatever you like before or after the name of your functions/keys.
  #
  # The key name and icon separators will be used to separate your key 
  # names/icons in case the displayed function got more than one key assigned.
  # These also accept message codes if you need them.
  #
  # You can use any message codes here with the exception of the ones provided
  # by this system (seriously, do NOT use those, or your game will crash!).
  # There is a small difference here though, instead of using a single \ sign to
  # denote a message code, you must use \e here!
  # You can check what I mean in the sample settings I made. 
  #
  # The last two setting is NOT used anywhere! They are for some of my own
  # custom scenes, so you should ignore them. :P
  #-----------------------------------------------------------------------------
  MsgCodes = {
    :keymsg => "\eC[17][%s]\eC[0]",  # Key name text format.
    :functmsg => "\eC[1][%s]\eC[0]", # Function name text format.
    :namesep => "/",   # Key name separator.
    :iconsep => " / ", # Key icon separator.
    :imgsep => " / ",  # Key image separator.
    :keytxt => "[%s]",   # NOT USED!
    :functtxt => "[%s]", # NOT USED!
  }
  
  #-----------------------------------------------------------------------------
  # System Message Settings:
  #-----------------------------------------------------------------------------
  # These messages will be used in the control configuration menu, more 
  # specifically, they will be shown in the informative popup window that
  # appears whenever the player wants to change a key-bind.
  # That popup window will show the result of the change (if the change was 
  # successful or not, what were the changes, etc).
  #
  # You have 3 special message codes which are only usable here!
  # These are:
  #
  # \eBTNKEY  - Will be replaced with the relevant key.
  # \eFNCTN   - Will be replaced with the relevant function name.
  # \eBTNPRIO - Will be replaced with the relevant key-bind index name.
  #
  # Based on your settings, the key can be displayed in text form, or by using
  # icons or custom images. You can set up which display type you want to use 
  # below, in the other setting areas.
  #
  # The key-bind priority will be displayed based on the settings you set up
  # in the :priorities option here. 
  # You should make a priority name for every possible key-bind index your game
  # might have!
  #
  # And the function name will be displayed based on the vocab settings for
  # your functions (also found below, in another setting).
  #
  # I think, most of the appearance of these should be obvious just by reading
  # the sample texts I made, so I won't go into details about this.
  #
  # Every new line you make will be centered in the popup window!
  # You can make new lines with the \n message code here!
  # Other message codes should still use the \eCODE format instead of the \CODE
  # format!
  # The popup window will also scale it's size to the text automatically.
  #-----------------------------------------------------------------------------
  SystemMsg = {
    :priorities => { # Button priority vocab:
      0 => "primary",
      1 => "secondary",
      2 => "tertiary",
      # Add more priority (key-bind index) names here!
    },
    # The below 2 appear when a key-bind has beed changed successfully.
    # These do NOT accept message codes!
    :changed => "Button changed successfully!",
    :sideeff => "Side Effects:",
    # Appears when the system waits for the new key-bind setting input.
    :wait_for_key => "Press a button to set the \eBTNPRIO key for " +
                     "the \eC[1]\eFNCTN\eC[0] function!",
    # Appears when the player cleared a key-bind for a function.
    :cleared => "The \eBTNPRIO key for the \eC[1]\eFNCTN\eC[0] function " +
                "has been cleared!\n",
    # A locked key would display this popup text.
    :key_locked => "You can't change this key-bind!",
    # An incorrect configuration would result with this text.
    :cant_clear => "The \eC[17]\eBTNKEY\eC[0] key is the only one set for " +
                   "the \eC[1]\eFNCTN\eC[0] function!\n" +
                   "This function must have at least one key set up,"+
                   "\nso it can not be removed right now!",
    # Another incorrect configuration message.
    :cant_set => "The \eC[17]\eBTNKEY\eC[0] key is currently set to " +
                 "the \eC[1]\eFNCTN\eC[0] function\nand can not be removed!\n" +
                 "Please try a different key!",
  }
  
  #-----------------------------------------------------------------------------
  # Debug Menu - Help Text Settings:
  #-----------------------------------------------------------------------------
  # Since the controls are changeable now by the player, it makes no sense to
  # display a static text showing which buttons do what, right?
  # The only menu in the game which shows some kind of control instructions is
  # the debug menu by default.
  # For that reason, you can change the displayed help text for that menu.
  # Remember the new message codes added with this system? Time to use them! :P
  # The samples I made will display the correct key-binds with text, no matter
  # if the player changed them or not in the game. 
  # Well, I don't know why would you allow the player to use this menu at all,
  # but even if you don't, it's kinda cool to see the right key-binds there. :P
  #
  # The :switch text is the help text for switches, the :variable text is the
  # help text for variables. No idea why I wrote this, it should be obvious. >.>
  #-----------------------------------------------------------------------------
  DebugHelp = {
    :switch => "\eBTNC[p1,m_confirm] : Toggles the switches ON or OFF.",
    :variable => "\eBTNC[p1,m_left] : Subtracts 1 from the variable.\n"+
                 "\eBTNC[p1,m_right] : Adds 1 to the variable.\n"+
                 "\eBTNC[p1,m_pgup] : Subtracts 10 from the variable.\n"+
                 "\eBTNC[p1,m_pgdown] : Adds 10 to the variable.",
  }
  
  #-----------------------------------------------------------------------------
  # Path Text Settings:
  #-----------------------------------------------------------------------------
  # These are texts added for the button function display after each nested 
  # paths used in the default control configuration.
  # In case you would like to use the same function symbols in different 
  # paths/categories, it would be a wise idea to differentiate these functions
  # somehow in your game, otherwise your player could mix them up.
  #
  # For example, a two player game could use the same function symbols, each
  # player having it's own path/category. In this case, the name of your 
  # functions would be the same, because they share the same function symbols.
  # That is where this setting jumps in. 
  # It will add the text you enter for each path level to the default name of
  # the function, and would display that instead of the bare function name text.
  # Can be a great way to lessen your work with the function name vocab 
  # settings.
  #
  # Note that each path level's text you set up here will be added to the end of
  # the function name text!
  # So, if a function is placed inside this path setting:
  #   [:p1][:p2]
  # The name of the function would be:
  #   "Function Name (P1) (P2)"
  # Which would be dumb on many levels, alright, I just wanted to make a silly 
  # example. :P
  #
  # You don't have to set a path text for all of your paths, only for the ones
  # you want to be noted in your function names.
  #-----------------------------------------------------------------------------
  Paths = {
    #:p1 => " (P1)",
    #:p2 => " (P2)",
    # Add more path text settings here!
  }
  
  #-----------------------------------------------------------------------------
  # Function Name Vocab Settings:
  #-----------------------------------------------------------------------------
  # This is a pretty obvious setting finally, where I shouldn't need to explain
  # anything at all. Right? Riiiiight? :P
  #
  # Okay, just one simple thing...
  # All of your functions must have a name set up here! No exceptions!
  #-----------------------------------------------------------------------------
  Buttons = {
    # System Buttons:
    :fullscreen  => "Full-Screen",
    :screenratio => "Screen Ratio",
    :resolution  => "Resolution",
    :qload       => "Quick Load",
    :qsave       => "Quick Save",
    :debug       => "Debug Menu",
    :help        => "Help",
    # Menu Buttons:
    :m_up       => "Cursor Up",
    :m_down     => "Cursor Down",
    :m_left     => "Cursor Left",
    :m_right    => "Cursor Right",
    :m_confirm  => "Confirm",
    :m_cancel   => "Cancel/Exit",
    :m_pgup     => "Previous Page",
    :m_pgdown   => "Next Page",
    :m_toggle   => "Toggle",
    :m_clear    => "Clear",
    # Field Buttons:
    :f_up       => "Move Up",
    :f_down     => "Move Down",
    :f_left     => "Move Left",
    :f_right    => "Move Right",
    :f_confirm  => "Interact",
    :f_cancel   => "Special",
    :f_move     => "Mouse Movement",
    # Menu Shortcuts:
    :m_menu     => "Menu",
    :inventory  => "Inventory",
    :status     => "Status",
    :craft      => "Craft",
    :quest      => "Quest Log",
    :cards      => "Card Album",
    :map        => "Map",
    :options    => "System",
    # Battle Keys:
    :item_1     => "Item 1",
    :item_2     => "Item 2",
    :skill_1    => "Skill 1",
    :skill_2    => "Skill 2",
    :skill_3    => "Skill 3",
    :special    => "Special",
    # Misc. Keys:
    :mmode      => "Movement Mode",
    :mtype      => "Movement Type",
    :d_through  => "Debug-Through",
    # Add more function name settings here!
  }
  
  #-----------------------------------------------------------------------------
  # Function Help Text Settings:
  #-----------------------------------------------------------------------------
  # Another easy setting.
  # These help texts will be diplayed in the help window on the control 
  # configuration scene.
  # You can use message codes in them, yay!
  # Remeber, line breaks can be made with the \n message code!
  #
  # Again, all of your functions must have a help text setup here!
  #-----------------------------------------------------------------------------
  ButtonHelps = {
    # System Buttons:
    :fullscreen  => "Toggle full-screen mode with this key.",
    :screenratio => "Toggle the screen ratio with this key.",
    :resolution  => "Toggle the resolution with this key.",
    :qload       => "Triggers the quick-load function.\n" +
                    "If there is no quick-save file, it won't do anything!",
    :qsave       => "Triggers the quick-save function.\n" +
                    "Only effective on the field, " +
                    "and you can't save during special events!",
    :help        => "Brings up the help files for the current menu.\n" +
                    "Can be used in any menus!", # Not used by default!
    :debug       => "Opens the debug menu of the game.\n" +
                    "Should be disabled when the game is published!",
    # Menu Buttons:
    :m_up       => "Moves the cursor up in the menus and in choice selections.",
    :m_down     => "Moves the cursor down in the menus and in choice selections.",
    :m_left     => "Moves the cursor left in the menus and in choice selections.",
    :m_right    => "Moves the cursor right in the menus and in choice selections.",
    :m_confirm  => "Selects the highlighted option and confirms popups in menus.",
    :m_cancel   => "Moves back one level in the menu options (if applicable) " +
                   "or exits the menu.",
    :m_pgup     => "Moves to the previous page of options or scrolls up a page instantly.\n"+
                   "If the current page is the first one, instantly moves to the first option!",
    :m_pgdown   => "Moves to the next page of options or scrolls down a page instantly.\n"+
                   "If the current page is the last one, instantly moves to the last option!",
    :m_toggle   => "Toggles between special displays in menus (if applicable).",
    :m_clear    => "Used for clearing the currently highlighted option in menus (if applicable).",
    # Field Buttons:
    :f_up       => "Move upwards on the field.\n"+
                   "Also used in quick-time events!",
    :f_down     => "Move downwards on the field.\n"+
                   "Also used in quick-time events!",
    :f_left     => "Move left on the field.\n"+
                   "Also used in quick-time events!",
    :f_right    => "Move right on the field.\n"+
                   "Also used in quick-time events!",
    :f_confirm  => "Interacts with NPCs and special objects and used in quick-time events.\n"+
                   "Can also be used to fast forward messages.",
    :f_cancel   => "Brings up special interaction modes for NPCs and special objects.\n"+
                   "Used in quick-time events and to fast forward messages too.",
    :f_move     => "Press this button and your hero will move to where the mouse cursor is.\n"+
                   "If the place can not be reached, no movement will be made.",
    # Menu Shortcuts:
    :m_menu     => "Opens the main menu of the game.",
    :inventory  => "Opens the Inventory menu.",
    :status     => "Opens the Status menu.",
    :craft      => "Opens the Craft menu.",
    :quest      => "Opens the Quest Log menu.",
    :cards      => "Opens the Card Album menu.",
    :map        => "Opens the World Map menu.",
    :options    => "Opens the System menu.",
    # Battle Keys:
    :item_1     => "Uses the equipped item on the 1st item slot.",
    :item_2     => "Uses the equipped item on the 2nd item slot.",
    :skill_1    => "Uses the equipped skill on the 1st skill slot.",
    :skill_2    => "Uses the equipped skill on the 2nd skill slot.",
    :skill_3    => "Uses the equipped skill on the 3rd skill slot.",
    :special    => "I totally forgot what this one does... >.>"+
                   "It must be something special!",
    # Misc. Keys:
    :mmode      => "Toggles between the available movement modes.",
    :mtype      => "Toggles between the available movement types.",
    :d_through  => "Toggles the collision checks (ON / OFF) for the player.\n"+
                   "Should be disabled when the game is published!",
    # Add more function help texts here!
  }
  
  #-----------------------------------------------------------------------------
  # Key Display Settings:
  #-----------------------------------------------------------------------------
  # Couldn't really name it "Key Vocab Settings", because this is not just a 
  # simple text setting for your keys.
  #
  # Depending on the display type you choose for your keys in the control
  # configuration menu, you can display them with texts, icons or custom images.
  # These are the things you must set up here.
  #
  # Should be abvious what each ooptions here do.
  # Just in case, the :img setting should be set to the name of the image file
  # you want to use for the key. If you don't plan to use that feature, you 
  # might as well ignore it.
  #
  # All of your keys must have a setting here!
  #-----------------------------------------------------------------------------
  Keys = {
    # No key set:
    :empty => {:name => "----", :icon => 1, :img => "kempty"},
    # Mouse Clicks:
    :LBUTTON => {:name => "Left Mouse", :icon => 200, :img => "mouse_l"},
    :MBUTTON => {:name => "Middle Mouse", :icon => 201, :img => "mouse_m"},
    :RBUTTON => {:name => "Right Mouse", :icon => 202, :img => "mouse_r"},
    :XBUTTON1 => {:name => "Mouse X1", :icon => 202, :img => "mouse_x1"},
    :XBUTTON2 => {:name => "Mouse X2", :icon => 202, :img => "mouse_x2"},
    # Numbers:
    :N0    => {:name => "0", :icon => 2, :img => "k0"},
    :KEY_1 => {:name => "1", :icon => 3, :img => "k1"},
    :KEY_2 => {:name => "2", :icon => 4, :img => "k2"},
    :KEY_3 => {:name => "3", :icon => 5, :img => "k3"},
    :KEY_4 => {:name => "4", :icon => 6, :img => "k4"},
    :KEY_5 => {:name => "5", :icon => 7, :img => "k5"},
    :KEY_6 => {:name => "6", :icon => 8, :img => "k6"},
    :KEY_7 => {:name => "7", :icon => 9, :img => "k7"},
    :KEY_8 => {:name => "8", :icon => 10, :img => "k8"},
    :KEY_9 => {:name => "9", :icon => 11, :img => "k9"},
    # Numbers (Numpad):
    :NUMPAD0 => {:name => "Num 0", :icon => 12, :img => "knum0"},
    :NUMPAD1 => {:name => "Num 1", :icon => 13, :img => "knum1"},
    :NUMPAD2 => {:name => "Num 2", :icon => 14, :img => "knum2"},
    :NUMPAD3 => {:name => "Num 3", :icon => 15, :img => "knum3"},
    :NUMPAD4 => {:name => "Num 4", :icon => 16, :img => "knum4"},
    :NUMPAD5 => {:name => "Num 5", :icon => 17, :img => "knum5"},
    :NUMPAD6 => {:name => "Num 6", :icon => 18, :img => "knum6"},
    :NUMPAD7 => {:name => "Num 7", :icon => 19, :img => "knum7"},
    :NUMPAD8 => {:name => "Num 8", :icon => 20, :img => "knum8"},
    :NUMPAD9 => {:name => "Num 9", :icon => 21, :img => "knum9"},
    # Other Numpad stuffs:
    :MULTIPLY  => {:name => "Num *", :icon => 105, :img => "knummul"},
    :ADD       => {:name => "Num +", :icon => 106, :img => "knumplus"},
    :SUBTRACT  => {:name => "Num -", :icon => 107, :img => "knumminus"},
    :DECIMAL   => {:name => "Num .", :icon => 108, :img => "knumpoint"},
    :DIVIDE    => {:name => "Num /", :icon => 109, :img => "knumslash"},
    :SEPARATOR => {:name => "Num ?", :icon => 109, :img => "knumslash"},
    # Lock keys:
    :CAPITAL => {:name => "Caps Lock",   :icon => 110, :img => "kcapslock"},
    :NUMLOCK => {:name => "Num Lock",    :icon => 111, :img => "knumlock"},
    :SCROLL  => {:name => "Scroll Lock", :icon => 112, :img => "kscrolllock"},
    # Function Keys:
    :F1  => {:name => "F1", :icon => 22, :img => "kf1"},
    :F2  => {:name => "F2", :icon => 23, :img => "kf2"},
    :F3  => {:name => "F3", :icon => 24, :img => "kf3"},
    :F4  => {:name => "F4", :icon => 25, :img => "kf4"},
    :F5  => {:name => "F5", :icon => 26, :img => "kf5"},
    :F6  => {:name => "F6", :icon => 27, :img => "kf6"},
    :F7  => {:name => "F7", :icon => 28, :img => "kf7"},
    :F8  => {:name => "F8", :icon => 29, :img => "kf8"},
    :F9  => {:name => "F9", :icon => 30, :img => "kf9"},
    :F10 => {:name => "F10", :icon => 31, :img => "kf10"},
    :F11 => {:name => "F11", :icon => 32, :img => "kf11"},
    :F12 => {:name => "F12", :icon => 33, :img => "kf12"},
    :F13 => {:name => "F13", :icon => 22, :img => "kf13"},
    :F14 => {:name => "F14", :icon => 23, :img => "kf14"},
    :F15 => {:name => "F15", :icon => 24, :img => "kf15"},
    :F16 => {:name => "F16", :icon => 25, :img => "kf16"},
    :F17 => {:name => "F17", :icon => 26, :img => "kf17"},
    :F18 => {:name => "F18", :icon => 27, :img => "kf18"},
    :F19 => {:name => "F19", :icon => 28, :img => "kf19"},
    :F20 => {:name => "F20", :icon => 29, :img => "kf20"},
    :F21 => {:name => "F21", :icon => 30, :img => "kf21"},
    :F22 => {:name => "F22", :icon => 31, :img => "kf22"},
    :F23 => {:name => "F23", :icon => 32, :img => "kf23"},
    :F24 => {:name => "F24", :icon => 33, :img => "kf24"},
    # Letters:
    :LETTER_A => {:name => "A", :icon => 34, :img => "ka"},
    :LETTER_B => {:name => "B", :icon => 35, :img => "kb"},
    :LETTER_C => {:name => "C", :icon => 36, :img => "kc"},
    :LETTER_D => {:name => "D", :icon => 37, :img => "kd"},
    :LETTER_E => {:name => "E", :icon => 38, :img => "ke"},
    :LETTER_F => {:name => "F", :icon => 39, :img => "kf"},
    :LETTER_G => {:name => "G", :icon => 40, :img => "kg"},
    :LETTER_H => {:name => "H", :icon => 41, :img => "kh"},
    :LETTER_I => {:name => "I", :icon => 42, :img => "ki"},
    :LETTER_J => {:name => "J", :icon => 43, :img => "kj"},
    :LETTER_K => {:name => "K", :icon => 44, :img => "kk"},
    :LETTER_L => {:name => "L", :icon => 45, :img => "kl"},
    :LETTER_M => {:name => "M", :icon => 46, :img => "km"},
    :LETTER_N => {:name => "N", :icon => 47, :img => "kn"},
    :LETTER_O => {:name => "O", :icon => 48, :img => "ko"},
    :LETTER_P => {:name => "P", :icon => 49, :img => "kp"},
    :LETTER_Q => {:name => "Q", :icon => 50, :img => "kq"},
    :LETTER_R => {:name => "R", :icon => 51, :img => "kr"},
    :LETTER_S => {:name => "S", :icon => 52, :img => "ks"},
    :LETTER_T => {:name => "T", :icon => 53, :img => "kt"},
    :LETTER_U => {:name => "U", :icon => 54, :img => "ku"},
    :LETTER_V => {:name => "V", :icon => 55, :img => "kv"},
    :LETTER_W => {:name => "W", :icon => 56, :img => "kw"},
    :LETTER_X => {:name => "X", :icon => 57, :img => "kx"},
    :LETTER_Y => {:name => "Y", :icon => 58, :img => "ky"},
    :LETTER_Z => {:name => "Z", :icon => 59, :img => "kz"},
    # Arrow Keys:
    :LEFT  => {:name => "LEFT",  :icon => 60, :img => "kleft"},  # ← LEFT
    :RIGHT => {:name => "RIGHT", :icon => 61, :img => "kright"}, # → RIGHT
    :UP    => {:name => "UP",    :icon => 62, :img => "kup"},    # ↑ UP
    :DOWN  => {:name => "DOWN",  :icon => 63, :img => "kdown"},  # ↓ DOWN
    # Others:
    :RETURN   => {:name => "ENTER",     :icon => 64, :img => "kenter"},
    :BACK     => {:name => "BACKSPACE", :icon => 66, :img => "kbackspace"},
    :SPACE    => {:name => "SPACE",     :icon => 67, :img => "kspace"},
    :ESCAPE   => {:name => "ESC",       :icon => 68, :img => "kesc"},
    :SHIFT    => {:name => "SHIFT",     :icon => 70, :img => "kshift"},
    :TAB      => {:name => "TAB",       :icon => 71, :img => "ktab"},
    :MENU     => {:name => "ALT",       :icon => 72, :img => "kalt"},
    :CONTROL  => {:name => "CTRL",      :icon => 73, :img => "kctrl"},
    :DELETE   => {:name => "DEL",       :icon => 74, :img => "kdel"},
    :INSERT   => {:name => "INS",       :icon => 76, :img => "kins"},
    :PRIOR    => {:name => "PAGE UP",   :icon => 80, :img => "kpgup"},
    :NEXT     => {:name => "PAGE DOWN", :icon => 80, :img => "kpgdown"},
    :HOME     => {:name => "HOME",      :icon => 82, :img => "khome"},
    :END      => {:name => "END",       :icon => 83, :img => "kend"},
    :LMENU    => {:name => "L-ALT",     :icon => 84, :img => "klalt"},
    :LCONTROL => {:name => "L-CTRL",    :icon => 85, :img => "klctrl"},
    :RMENU    => {:name => "R-ALT",     :icon => 86, :img => "kralt"},
    :RCONTROL => {:name => "R-CTRL",    :icon => 87, :img => "krctrl"},
    :LSHIFT   => {:name => "L-SHIFT",   :icon => 88, :img => "klshift"},
    :RSHIFT   => {:name => "R-SHIFT",   :icon => 89, :img => "krshift"},
    :PAUSE    => {:name => "PAUSE",     :icon => 113, :img => "kpause"},
    # Symbols:
    :masculine      => {:name => ":",  :icon => 90, :img => "kcolon"},
    :THORN          => {:name => "'",  :icon => 91, :img => "kapostrophe"},
    :kQUOTE         => {:name => "\"", :icon => 92, :img => "kquote"},
    :onequarter     => {:name => ",",  :icon => 93, :img => "kcomma"},
    :threequarters  => {:name => ".",  :icon => 94, :img => "kperiod"},
    :questiondown   => {:name => "/",  :icon => 95, :img => "kslash"},
    :Udiaeresis     => {:name => "\\", :icon => 96, :img => "kbackslash"},
    :Ucircumflex    => {:name => "[",  :icon => 97, :img => "kleftbrace"},
    :Yacute         => {:name => "]",  :icon => 98, :img => "krightbrace"},
    :onehalf        => {:name => "-",  :icon => 99, :img => "kminus"},
    :kUNDERSCORE    => {:name => "_",  :icon => 100, :img => "kunderscore"},
    :kPLUS          => {:name => "+",  :icon => 101, :img => "kplus"},
    :guillemotright => {:name => "=",  :icon => 102, :img => "kequal"},
    :Agrave         => {:name => "~",  :icon => 104, :img => "ktilde"}, 
    :acircumflex    => {:name => "<",  :icon => 114, :img => "kltri"},
  }
  
end
#==============================================================================
# !!END OF SCRIPT - OHH, NOES!!
#==============================================================================
