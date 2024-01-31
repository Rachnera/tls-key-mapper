# RPG Maker VX Ace Keybinding Improved

## Setup

Definitely not plug-and-play, unless you happen to be adding this feature to exactly _The Last Sovereign_, in which case you just need to add the ten (!) scripts stored in that repository to your game, in that exact order:
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

## Usage

### What does it do?

TODO with screenshots and all

### What doesn't it do?

At the moment, the following caveats are known:
- Completely override anything defined through the F1 menu, which can be confusing.

## Customization

If you wish to modify a button's name, description, usage, anything really, you first need to know its [symbolic](https://ruby-doc.org/core-1.9.1/Symbol.html) name. Here's the list of all in use:
:up, :down, :left, :right, :confirm, :cancel, :fullscreen (F5), :screenratio (F6), :mmode (walk/dash), :skip (fast text), :backlog, :party_switch, :m_toggle (only used in the shop screen; tab as a default), :m_clear (clear assigned key; only used in the keybinding menu)

### Text

Most text displayed in the new menu can be changed by altering either `ConfigScene::Buttons` or `ConfigScene::ButtonHelps` for the appropriate button.

Example:
```rb
ConfigScene::Buttons[:up] = "New name for the up button."
ConfigScene::ButtonHelps[:screenratio] = "Better explanation of what F6 does."
```

### Defaults

Similar to previous, but with `System::Defaults[:p1]`:
```rb
# Change the backlog to the B button as a default
System::Defaults[:p1][:backlog] = [:LETTER_B]
```

Reminder: Default values are only used if no `Controls.rvdata2` exists yet!

## Credits

Based on:
- https://forums.rpgmakerweb.com/index.php?threads/control-configuration-system-v1-5-04-07-2017.70517/
- https://forums.rpgmakerweb.com/index.php?threads/gamepad-extender-v1-1-2-20-2015.1284/
