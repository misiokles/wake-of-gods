# Magic Mushrooms (Script 10) — 1.0.3

Four rare mushrooms temporarily allow a hero to cast spells at Expert mastery in their corresponding school of magic.

| Mushroom | Benefit |
| --- | --- |
| Magic Water Mushroom | Expert Water Magic |
| Magic Fire Mushroom | Expert Fire Magic |
| Magic Earth Mushroom | Expert Earth Magic |
| Magic Air Mushroom | Expert Air Magic |

## Visiting

- No gold, resources, artifacts, or extra movement points are charged by the object.
- The effect lasts until the end of the current week, not seven days from the visit. It expires at the beginning of the next week.
- A hero without the corresponding secondary skill, or with Basic or Advanced mastery, can benefit. A hero with the permanent Expert skill receives no additional bonus.
- Each school has its own visit marker, shared by all mushrooms of that school for the same hero. A second visit does not stack the effect. Other heroes and other schools are independent.
- The benefit does not require an empty secondary skill slot. It is a temporary spell-mastery bonus, not an actual secondary skill. Your permanent skill level is unchanged. Requirements and specialties based on the learned secondary skill may still see the original level.

Example: a hero with Basic Fire Magic receives Expert spell mastery until Monday. The permanent Fire Magic skill remains Basic throughout.

## Differences from WoG

WoG temporarily changes the actual secondary skill and restores its saved level on Monday. VCMI instead grants `MAGIC_SCHOOL_SKILL` with `AT_LEAST`, value 3 and `ONE_WEEK`. This avoids overwriting normal skill progression, but does not reproduce all secondary-skill-dependent interactions. The twenty original ERT text records are preserved in `description/wog-original`; active texts have separate English and Polish translations. The success text describes spell mastery rather than learning a permanent skill. RMG settings are unchanged.
