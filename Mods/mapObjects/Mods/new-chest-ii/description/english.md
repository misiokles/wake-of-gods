# New Chest II (Script 31)

## How to use

This rare chest disappears after its reward has been claimed. It contains one of three types of treasure:

- **Scroll and gold (40% initial chance).** Find 300–900 gold (in steps of 100). Keep the spell scroll or destroy it to receive 30 spell points per spell level instead. Either choice awards the same gold. The spell points may exceed the hero's normal mana limit.
- **Tomes of Knowledge (40% initial chance).** If you know at least two standard secondary skills at Basic or Advanced, choose one eligible skill to raise immediately to Expert. This does not teach a new skill. If fewer than two skills qualify, you receive the scroll-and-gold choice instead.
- **Mine deed (20% initial chance).** A merchant pays 2,000 gold for the deed. This adaptation does not claim a mine.

The scroll level is based on the visiting hero's level. The base is min(5, floor(hero level / 5) + 1). An additional uniform roll from 1 to 10, plus the hero level modulo 5, raises the spell level once at a total of 10 or more, and again at 14 or more, capped at 5. From hero level 20 the spell is always level 5. Only allowed, non-special spells in the selected level are eligible. If an entire tier is disabled, the engine may fail to choose a valid scroll (not tested).

## Differences from WoG 3.59 alpha

The original script031.erm (FU5200–5208) studies a randomly offered pair of skills over seven days, with optional daily reminders; it instead gives scrolls if study is ongoing or fewer than two skills qualify. The VCMI version offers all eligible standard skills, completes the study immediately, and has no ongoing-study state. A deed does not remotely capture a neutral mine or reveal the area. The substitute is retained from v0.1.0. WoG falls back to the tomes branch when no mine is available; VCMI cannot perform this check here. The duplicate-scroll rerolls, Living Scrolls, Adventure Cave wealth doubling, and the original AI alternative of 1500 XP when destroying a scroll are not reproduced. Random chest contents are fixed when initialized by the engine rather than rolled on visit. The shared choice dialog cannot be customized for each branch using the current JSON selectPlayer mechanism. Post-choice reward-specific text is not shown in that path; all original strings are preserved separately for future development. No engine changes or Lua are required.

Original ERT: 35 active records and 29 older commented (#) records are preserved in description/wog-original. Adapted active dialogs are provided in English and Polish. RMG parameters (value 9000, rarity 10, zoneLimit 1, mapLimit 3) are unchanged.

## Validation

v0.1.1, VCMI 1.8.0. Full mod loading (--dummy-run) returned 0. Static checks: 12,000 combinations (100 dice values × hero levels 1–30 × 0–3 qualifying standard skills). Native fixture: 300 eligibility checks using actual engine limiters (3 sampled dice, levels 1–25, 0–3 qualifying skills), plus five successful reward scenarios (scroll, mana above limit, Basic to Expert, Advanced to Expert, deed gold). Deferred object removal was intercepted and checked for mana; actual map removal, GUI, Polish UI, AI, RMG, saves/reloads and maps with all spells of one level banned were not tested. Fixture calls visit and answer handlers directly rather than simulating walking on the map. An initial exhaustive native reroll run exceeded 45 seconds; the smaller native sample passed. JSON uses 141 reward entries with recursive limiters; performance in large RMG maps is not established.


## v0.1.2 audit
Restored the intended VAB mask and bottom-row legacy visit matrix, with explicit visitableFromTop=false. VCMI 1.8 reduces legacy directions to a top-entry flag; side access remains possible. Adapted ERT 131003/131009 in the shared prompt and ERT 131025 for the deed substitute. Archived-only ERT keys were removed from active translations, preserving the original ERM/ERT and strings.json. Rewards and RMG parameters are unchanged.

Validation in the v0.1.2 cycle: VCMI 1.8.0 dummy-run PASS. 45,000 static eligibility cases and scroll-tier distributions across levels 1–75; native VAB mask/entry flag and 72 sampled reward eligibility cases PASS. No full adventure-map visit.
