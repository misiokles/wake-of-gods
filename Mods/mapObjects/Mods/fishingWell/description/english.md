# Fishing Well (Script 07) — Player Guide

## English

A mysterious well invites heroes to spend their day fishing. You may discover a treasure, encounter monsters, or fish up something entirely useless.

- One catch per well per week, shared by all heroes. The well resets at the start of each week (days 8, 15, 22, etc.), allowing four catches per standard month.
- The catch requires at least one movement point, consumes all remaining movement, and restores mana to its normal maximum. Visit late in the day for best value. Unused excess mana is not preserved by this refill.
- An unguarded eligible visit automatically resolves the catch. If guards are present, you can decline the fight without spending movement on the reward or using the weekly catch. Guards can be shown before the fight by the native interface; if a hero has no movement, the guard prompt may still appear.
- The 30% humorous results award no material item. They still restore mana and use movement. The stories are based on the original WoG ERT, including the soggy sandwich, old boot, furry trout, miniature mermaid and illusory Grail.

| Outcome | Chance |
|---|---:|
| Humorous empty catch | 30% |
| Loose coins (50–200 gold) | 3% |
| Chest gold (200–900, in steps of 100) | 7% |
| One resource (3–8 units) | 21% |
| Treasure or Minor artifact | 6% |
| Spell scroll (level 1–3) | 9% |
| Friendly Imps (3 or 6) | 6% |
| Experience (500 base XP) | 3% |
| −1 morale or −1 luck for the next battle | 6% |
| Guards, with 500 gold on claiming the reward | 9% |

Gold, material rewards, artifacts and scrolls depend on the actual game configuration. No extra destination mods are required. Guarded rewards are granted only after guards are removed and the normal reward conditions are satisfied.

## Polski

Studnia pozwala spróbować szczęścia raz w tygodniu, wspólnie dla wszystkich bohaterów. Odnawia się w pierwszym dniu tygodnia. Połów wymaga minimum 1 punktu ruchu, zużywa cały pozostały ruch i odnawia manę do zwykłego maksimum. Niezagrożony połów odbywa się automatycznie; walki ze strażnikami można odmówić. Najlepiej łowić pod koniec dnia. 30% wyników to humorystyczne znaleziska bez nagrody rzeczowej. Wartości i szanse są wymienione w tabeli powyżej. Pozostałe efekty, w tym strażnicy i ich nagrody, pozostają zgodne z dotychczasowym portem VCMI.

## Implementation notes

This is an independent object, not the WoG extension of every Magic Well. Unlike WoG, the catch is weekly and automatic, and there is no tunnel exploration, gnome troop trading, stack growth/downgrade, darts, Living Scroll, rescue of arbitrary creatures or separate chest-opening dialogue. Original WoG charges up to 5000 movement for a human who chooses to fish and exempts AI; the port retains zero remaining movement. The 43 reward branches and existing category weights are preserved. The gold sub-pools now follow the original value ranges. All 85 numbered ERT records are archived, and appropriate active messages are localized in English and Polish; incompatible dialogue fragments remain archived. Scouted non-guarded loot preview is disabled. Guard composition remains governed by the engine. A refusal of ordinary fishing would expose the reward before consent, so it is not enabled.

Validation: 100 static dice values, all 43 reward branches, 85 original ERT records and 49 matching translation keys in each language (previous revision; 51 in current files). Native tests: 8 PASS checks for no-movement visit, empty catch/mana/movement, shared weekly limit, weekly reset, loose coins and >5000 movement, chest gold, guard refusal, and a reward after controlled guard removal. Full mod loaded in vcmiserver --dummy-run (exit 0). First test run had a bad optional access because the test used dice ID 1 instead of the existing ID 0; corrected in test only. Tiny fixture reported a missing hero template animation. No actual battle was played, and GUI, Polish client display, AI, save/load, RMG, guard regeneration after a real battle, overflow mana and every individual reward were not tested.

## Audit 0.2.2

The 43 reward branches, weekly reset, probabilities, movement/mana mechanics and RMG settings are unchanged from 0.2.1. ERT 107035 (rescued creatures) is adapted to the existing Imp rewards; 107055 (victory treasure) is adapted to the guard rewards. The XP and negative luck stories are new flavor text. All reward suffixes specify normal maximum mana; the tooltip uses the alternate original ERT wording 107085/107086 from the supplied s.zip, adapted to weekly visits. The archived 85-record ERT matches GrayFace and s_classics byte-for-byte; s.zip has 87 records and empty text in 107000–107004. The original ERM does not impose a weekly limit.

New native component test: all 100 die values, one first-visit reward each, zero/one movement-point threshold, movement calculation at 6000 points, mana restoration from zero and overflow to a positive limit of 30, reward-category checks, English reward text and weekly reset configuration. This does not execute a full adventure-map visit, actual weekly turn or battle. Earlier visit tests are documented above, not newly repeated. GUI, AI, save/load, map-specific restricted artifact/spell pools, RMG and guard regeneration after actual combat remain pending.
