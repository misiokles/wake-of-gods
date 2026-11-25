# Spell Book — Lost Pages of Magic

*The old volume has been hidden for years, yet its pages still whisper forgotten incantations. Heroes skilled in Luck and Wisdom may uncover secrets that elude the unprepared.*

This submod adds a **separate Spell Book adventure-map object**. Visiting it grants a collection of randomly selected spells. If your hero lacks a normal spellbook, the reward also includes one. The book disappears from the adventure map after the hero claims its reward; it cannot be collected again.

## What Can You Learn?

Every reward configuration contains **three level-1 spells and three level-2 spells**. Depending on the hero's **Luck** and **Wisdom**, the book may reveal additional knowledge:

| Result | Spells in the configured reward |
|---|---|
| Basic | 3 level-1 + 3 level-2 (6 total) |
| Advanced | Above + 2 level-3 (8 total) |
| Expert | Above + 2 level-4 (10 total) |
| Master | Above + 1 level-5 (11 total) |

Higher Luck and Wisdom increase your chance of reaching the better results. The underlying ten-step roll is calculated as `clamp(random 0–9 + Luck rank + 2 × Wisdom rank − 6, 0–9)`; extra spells are included at results **4**, **7**, and **9**. These are ranks of the *secondary skills*, not the hero's current morale/luck bonus.

For example, with **Expert Luck and Expert Wisdom**, the configured chances are 10% for 6 spells, 30% for 8 spells, 20% for 10 spells, and 40% for 11 spells.

## Important Limitations

- The object **does not change ordinary spellbook artifact pickups**, unlike the original WoG script.
- The listed numbers describe the configured spell selections. Actual learned spells remain subject to VCMI's spell availability, possible duplicate picks, and other engine rules; 11 guaranteed *distinct new spells* is not promised.
- Only unknown spells within the hero’s native Wisdom limit are learned. The dialogue lists the contents of the book, not guaranteed newly learned spells.
- Map bans are respected by random selection. Adventure spells are not unconditionally excluded: the original ERM helper checks the WoG ban options rather than imposing a blanket exclusion.
- After collection, the object is configured to be removed from the adventure map (`removeObject: true` in all 94 reward branches).

*Implementation: Spell Book v0.1.3 for VCMI 1.8. The native reward configuration and ERT name substitution passed 3,200 cases (100 dice values × 32 hero profiles). Actual pickup and disappearance still require an integrated gameplay test.*

## Compatibility with War Machines on Map

**War Machines on Map v1.0.1** no longer generates ordinary Spell Book artifacts as random map loot. This object remains the spell-granting book to look for. It works independently of War Machines on Map, so no combined installation is required. Other mods may still add regular spellbook artifacts to map loot.

