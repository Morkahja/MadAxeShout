# MadAxeShout (Turtle WoW 1.12)

Random EMOTE/YELL on **Battle Shout**, with dungeon-aware chances.
- **In dungeons:** 30% YELL, 30% built-in emote, 40% custom emote  
- **Outside:** 30% built-in emote, 70% custom emote

## Install
1. Download the latest release `.zip`
2. Extract to: `World of Warcraft/Interface/AddOns/`
3. Final path must be: `Interface/AddOns/MadAxeShout/`
4. `/reload` in-game.

## Commands
- `/mas on` — enable
- `/mas off` — disable
- `/mas test` — fire a random line
- `/mas spell Battle Shout` — set the localized spell name

## Turtle Notes
- `.toc` Interface: **11200**
- Dungeon detection via zone names (see list inside `MadAxeShout.lua`)
- Event: `CHAT_MSG_SPELL_SELF_BUFF` (looks for your spell name)
