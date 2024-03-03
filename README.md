# RPG Maker VX Ace Keybinding Improved

## Setup

If you are adding this feature to exactly _The Last Sovereign_, you "just" need to add (through the Script Editor, as usual) the ten scripts stored in that repository to the game, after all other custom scripts and in that exact order:
1. Lone Wolf Gamepad Extender
2. System Settings - Cidiomar
3. Vocab Settings - Cidiomar
4. Cidiomar's Input System
5. Sixth's Input
6. Sixth's Main
7. Sixth Keybinding Menu Settings
8. Sixth Keybinding Menu Code
9. Rachnera Mixed Input
10. Rachnera Keybind Config

![](/docs/ordered-scripts.png)

If you are dealing with any other VX Ace game and have found you way here somehow, you might be able to achieve the results described below nonetheless, though you will need to replace the tenth script by a custom one of your own, covering compatibility issues with all peculiarisms of your own project. Warning: It's likely going to be a fair bit of technical work.

## Usage

### What does it do?

Once the scripts are in, you should see two additional entries within the System menu:

![](/docs/options.jpg)

The first grants access to Cidiomar and Sixth thorough rebinding menu for the keyboard:

![](/docs/keyboard.jpg)

And the second to Lone Wolf and mine equivalent for the gamepad:

![](/docs/gamepad.jpg)

Usage should be straightforward. If it's not, it means I still have work to do to make it so.

The scripts create two new custom save files to keep track of any custom configuration, namely `Save777.rvdata2` and `Save666.rvdata2`. Bindings can be reset to their default values by deleting these files or by using the in-game _Reset Options_ command.

### What doesn't it do?

At the moment, the following caveats are known:
- Completely override any custom key binding already defined through the F1 menu.
- Behavior of non-XInput controllers is [only half supported](https://forums.rpgmakerweb.com/index.php?threads/gamepad-extender-v1-1-2-20-2015.1284/page-8#post-685265). They might work perfectly fine, for example thanks to [Steam dealing the compability for us](https://www.pcgamingwiki.com/wiki/Store:Steam#Steam_Input). They might be detected as keyboards and required to be configured as such, but work fine otherwise. They might not work at all. However, as of the very exact moment I'm writing these lines, there is no known example of a controller faring worst with these scripts than without.

## Customization

Basically any base configuration can be overridden by adding a few arcane lines of code either to the end of the tenth script or in an eleventh one.

In theory, it's as simple as "set that thing for this button to this value". In practice, it's still that, but with a clunky syntax:
```
SOMETHING_ARCANE_TO_BE_COPYPASTED_AS_IS_SEE_BELOW[BUTTON_SYMBOLIC_NAME] = NEW_VALUE
```

### Target

To modify a button's name, description, usage, anything really, you first need to know its [symbolic](https://ruby-doc.org/core-1.9.1/Symbol.html) name.

Here's the list of all currently in use:
```
:up, :down, :left, :right, :confirm, :cancel, :fullscreen (F5), :screenratio (F6), :mmode (walk/dash), :skip (fast text), :backlog, :party_switch, :m_toggle (only used in the shop screen; tab as a default), :m_clear (clear assigned key; only used in the keybinding menu)
```

### Texts

Most text displayed in the new menus can be changed by altering either `ConfigScene::Buttons` or `ConfigScene::ButtonHelps` for the appropriate button.

Example:
```rb
ConfigScene::Buttons[:up] = "New name for the up button."
ConfigScene::ButtonHelps[:screenratio] = "Better explanation of what F6 does."
```

### Defaults

Default bindings can similarly be configured, but by tinkering with `System::Defaults[:p1]` and `GamepadKeyboardGlue::Defaults` instead:
```rb
System::Defaults[:p1][:backlog] = [:LETTER_B]
GamepadKeyboardGlue::Defaults[:party_switch] = :R2
```

If a default is changed and a save file already exists, the save file will take precedence until Reset Options is hit.

## Credits

Wouldn't have been possible without:
- https://forums.rpgmakerweb.com/index.php?threads/control-configuration-system-v1-5-04-07-2017.70517/
- https://forums.rpgmakerweb.com/index.php?threads/gamepad-extender-v1-1-2-20-2015.1284/
