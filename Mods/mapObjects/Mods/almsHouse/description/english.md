# Alms House

A kind man offers assistance to heroes and kingdoms in need. All applicable gifts are awarded together, without any fee.

## Gifts

- 100 gold if your kingdom has no gold; one unit of each other standard resource that is missing.
- +1 Attack or Defence if that primary skill is zero.
- +1 Spell Power or Knowledge if that primary skill is exactly one.
- 1,000 base experience if the hero has fewer than 1,000 experience points (VCMI applies its normal experience modifiers).

## Visiting

Each hero can make one eligible visit to an Alms House in the entire game, regardless of which building is visited. Other heroes can still visit. A hero must have at least one movement point to receive help. A visit with zero movement points gives no gifts and does not use up the opportunity; the hero can try again after recovering movement. A visit with movement but without any eligible gifts still uses up the opportunity.

All remaining movement is lost whenever at least one gift is awarded, including experience at any starting XP below 1,000. The three farewell messages distinguish zero, one to three, and four or more gifts. Version 1.0.2 deliberately corrects two inconsistencies of the original WoG 3.59 script: the XP gift now always counts toward the help total, and a visit without movement no longer consumes the once-per-hero opportunity.

The original WoG greetings, individual gifts and farewells are included in English and Polish. The repeat-visit message uses “This hero” instead of the dynamic hero name. The original ERT and ERM are retained for reference under `description/wog-original`.

## Technical notes

VCMI 1.8; JSON only. A permanent `NONE` reward bonus and `visitMode: bonus` track visits by object type, not instance. The eligibility checks use VCMI's current primary-skill values and normal XP award routine. The actual level-up dialog, save/load, AI, and map movement into the object have not been tested. Use a new game for verification.

## Version 1.0.3 audit
All 19 ERT entries are present in English and Polish (18 exact English originals and one adapted hero-name placeholder). Corrected the Polish greeting. No gameplay, RMG or asset changes. The 12 donation criteria and all 4,096 gift subsets were checked with and without movement (8,192 static cases). Native VCMI tests evaluated 54 representative hero profiles using the actual reward limiters, movement calculation and object-type visit bonus. The engine determines eligible rewards before granting them, then continues pending rewards after experience/level-up resolution; actual level-up continuation has not been played. The primary-skill checks use effective values, including artifacts and temporary effects; remove such equipment before a visit if you want eligibility based on the unmodified hero. AI, actual visits, save/load and GUI remain integration tests.
