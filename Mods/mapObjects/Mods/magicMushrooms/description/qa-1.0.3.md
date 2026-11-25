# Magic Mushrooms 1.0.3 – QA

Source: script010.erm (WoG master v1.10g), script010.ert (identical in all three archives).
ERT: 8 hover records reconstructed from name + status; 8 dialogue records exact; 4 adapted last lines. EN/PL key parity PASS.
Native tests: actual libvcmi.so; reward config and expert limiter threshold, manually applied bonus and durations; no full map visit.
water: config, spell mastery 0/1/2/3, independent visit markers, expiry for days 1-7, eight skills, skill upgrade retained PASS
fire: config, spell mastery 0/1/2/3, independent visit markers, expiry for days 1-7, eight skills, skill upgrade retained PASS
earth: config, spell mastery 0/1/2/3, independent visit markers, expiry for days 1-7, eight skills, skill upgrade retained PASS
air: config, spell mastery 0/1/2/3, independent visit markers, expiry for days 1-7, eight skills, skill upgrade retained PASS

Server --dummy-run exit 0; All game content loaded.
Global obsolete valueType scan PASS.
Changed files: mapObjects/Mods/magicMushrooms/content/config/mapObjects/mushrooms.json, mapObjects/Mods/magicMushrooms/content/translation/english.json, mapObjects/Mods/magicMushrooms/description/english.md, mapObjects/Mods/magicMushrooms/mod.json, mapObjects/mod.json
Gameplay config unchanged (only display names changed).

Remaining: actual map visit including Expert rejection, multiple objects of same school, save/load, AI and GUI. No C++ changes to engine or distributed mod.
