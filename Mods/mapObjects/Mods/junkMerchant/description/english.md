# Junk Merchant

A wandering trader who takes unwanted artifacts off your hands. He does not operate like a normal marketplace: each artifact has its own specific reward. You may also sell individual spell scrolls for cash.

## How trading works

- The merchant shows **one offer suited to your current inventory**. You can decline, keep your item and return to see another possible offer.
- **Unlimited visits:** the same hero may trade again, even on the same day. No movement-point or gold fee is charged unless the particular offer says otherwise.
- The artifact or spell scroll listed as payment is **consumed**. Gold, troops, resources, skills and other rewards are granted in return. Unlike original WoG, VCMI may take an equipped item before an identical backpack item, or disassemble a combined artifact to obtain its component. Check the offer carefully before accepting.

## Artifact trades

| Give | Receive |
| --- | --- |
| Centaur Axe | 50 Centaur Captain |
| Shield Of The Dwarven Lords | 15 Battle Dwarf |
| Buckler Of The Gnoll King | Targ Of The Rampaging Ogre |
| Helm Of The Alabaster Unicorn | 5 gems |
| Breastplate Of Petrified Wood | +1 Spell Power |
| Clover Of Fortune | 1,500 gold |
| Cards Of Prophecy | 1,500 gold |
| Ladybird Of Luck | 1,500 gold |
| Badge Of Courage | 1,500 gold |
| Crest Of Valor | 1,500 gold |
| Glyph Of Gallantry | 1,500 gold |
| Speculum | Reveal terrain (radius 30) |
| Spyglass | 1,830 gold |
| Amulet Of The Undertaker | 600 gold |
| Vampires Cowl | 2,500 gold |
| Dead Mans Boots | 2,000 gold |
| Surcoat Of Counterpoise | 4,000 gold |
| Bird Of Perception | 15 Royal Griffin |
| Statesmans Medal | 10 Crystal |
| Diplomats Ring | 10 gems |
| Ambassadors Sash | 10 Mercury |
| Necklace Of Ocean Guidance | 15 Wood |
| Angel Wings | 5 Archangel |
| Charm Of Mana | 60 spell points |
| Collar Of Conjuring | Learn Slow |
| Recanters Cloak | 2,500 gold |
| Spirit Of Oppression | 2,000 gold |
| Hourglass Of The Evil Hour | 500 gold |
| Sphere Of Permanence | 2,000 experience |
| Orb Of Vulnerability | Orb Of The Firmament |
| Pendant Of Negativity | Learn Lightning Bolt |
| Legs Of Legion | 15 Ore |

**Angel Wings special offer:** Without the 8th Level Units mod, the offer grants **5 Archangels**. When that mod is enabled, the offer instead grants **2 Supreme Archangels**. You still surrender the Angel Wings only once.

The two spell-teaching offers are only available when the hero can actually learn the offered spell (including possession of a spellbook and not already knowing the spell). This intentionally avoids taking an artifact in exchange for nothing.

## Spell scrolls

The Junk Merchant buys any of the **70 spell-scroll types** listed below for **500 gold per scroll**. Selling a scroll destroys it and **does not teach the spell** to your hero.

Summon Boat, Scuttle Boat, Visions, View Earth, Disguise, View Air, Fly, Water Walk, Dimension Door, Town Portal.

Quicksand, Land Mine, Force Field, Fire Wall, Earthquake, Magic Arrow, Ice Bolt, Lightning Bolt, Implosion, Chain Lightning.

Titan Bolt, Frost Ring, Fireball, Inferno, Meteor Shower, Death Ripple, Destroy Undead, Armageddon, Shield, Air Shield.

Fire Shield, Protect Air, Protect Fire, Protect Water, Protect Earth, Anti Magic, Dispel, Magic Mirror, Cure, Resurrection.

Animate Dead, Sacrifice, Bless, Curse, Bloodlust, Precision, Weakness, Stone Skin, Disrupting Ray, Prayer.

Mirth, Sorrow, Fortune, Misfortune, Haste, Slow, Slayer, Frenzy, Counterstrike, Berserk.

Hypnotize, Forgetfulness, Blind, Teleport, Remove Obstacle, Clone, Fire Elemental, Earth Elemental, Water Elemental, Air Elemental.


## WoG 3.59 differences and version 1.0.1

- The original merchant offers one copy of each eligible backpack artifact or scroll per visit, sequentially. This port offers a single random eligible transaction per visit and permits repeated visits without a movement fee.
- Version 1.0.1 fixes the optional Level 8 Units patch: VCMI uses one-based `modify@N` indices. `modify@23` targets Angel Wings, leaving Necklace of Ocean Guidance at 15 wood.
- All 85 original ERT records (108000–108084) are preserved in `description/wog-original/`. Active English offers use the original text (except for the base Angel Wings reward, scroll names and the safety warning). Polish offers are adapted translations; spell names in scroll offers were English before v1.0.2. Sequential greeting, second-scroll variants, responses to refusal, success and final trade-count messages are archived rather than shown out of context.
- Original AI skips creature rewards; this port does not explicitly enforce that rule. Mod-added scrolls are not automatically included.
- Native tests with and without the compatibility module confirmed refusal, repeated sales, a 500-gold scroll sale, Slow teaching and eligibility guards, both Angel Wings troop deliveries and the 15-wood Necklace trade. Not all trades, full-army/combined-artifact cases, AI or GUI were tested.


## Version 1.0.2 audit
All 32 artifact offers and 70 scroll offers were checked against the original ERM; the one-based `modify@23` patch targets Angel Wings. The Polish scroll dialogue now uses Polish spell labels (translated here, not extracted from official Polish game assets), and the empty dialogue and mercury offer were clarified. The English ERT-derived offers, trade rewards, RMG parameters and compatibility patch are unchanged. The two teaching offers use the engine canLearnSpells limiter; it allows map-banned spells by design, but requires a spellbook, sufficient mastery and an unknown spell. Original sequential greeting, success and refusal dialogues remain archived, since the current object offers only one transaction per visit. Full-army delivery, combined artifact removal, AI and full map visits remain integration test cases.
