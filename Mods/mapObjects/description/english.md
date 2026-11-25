# mapObjects 1.0.13 — Differences Between WoG and VCMI 1.8

This guide compares all 19 submods with the classic WoG mechanics and the WoG 3.59 alpha scripts. The headings use the submod names shown in the launcher. Some objects have their own visit rules in VCMI. Others follow the WoG rules through VCMI's dialogs and game mechanics.

## Trading, Training, and Assistance

### Alms House — Aid for Heroes in Need

In WoG, the host helps each hero once. He may provide missing resources, give 100 gold to an empty treasury, give 1,000 experience to a novice hero, or raise very low primary skills. The port keeps those thresholds and most of the original dialogue. In VCMI, a hero who visits with no movement points can come back later. Receiving any gift, including experience alone, uses all remaining movement points. Equipment can affect whether the hero qualifies for a primary skill increase. (WoG Script 18)

### Artificer — Reworking Artifacts

In WoG, each workshop offers up to two services per day and charges double for the second. Prices can depend on the day and the hero's skills, among other factors. In VCMI, the workshop presents one available offer, which the hero can decline for free. Each hero can accept one service per workshop per day. It costs 100 movement points and has a fixed price. There are 80 base recipes and up to 40 more with Mithril and Commanders. Trading the Still Eye of the Dragon for the Pendant of Courage costs 6,000 gold and 1 Mithril. Some ingredient names still appear in English in the Polish offers. (WoG Script 26)

### Battle Academy — Training and the Armory

In WoG, the player chooses a service from a menu. VCMI presents one randomly selected offer for which the hero qualifies, and the player can decline it. Each hero can accept one service per day across all academies. Training grants +1 Attack or Defense and costs 500 gold per point the hero already has in that attribute. WoG uses the base value. VCMI also counts equipment bonuses. Learning a secondary skill costs 3,000 gold and follows the normal skill slot limit. An optional add-on offers Commander equipment. (WoG Script 16)

### Arcane Tower — Trading Primary Skill Points

In WoG, the player can choose both attributes and make up to 30 free exchanges in a single session. VCMI presents one of 12 possible exchanges. Accepting transfers one point and costs 300 movement points. The hero can return on the same day. Remove any equipment and potions that change primary skills before accepting a trade. The port checks the value including bonuses, then deducts the point from the base value. In a test with base Attack of 0 and a temporary Attack bonus, the Tower raised another attribute and charged the movement points while leaving base Attack at 0. (WoG Script 04)

### School of Wizardry — Learning Magic

WoG offers a menu and uses its own timetable for offers. In VCMI, the school presents one offer suited to the hero. Each hero can accept one service per day across all schools. Spell Power and Knowledge training become more expensive as the attribute rises, including equipment bonuses. The school also teaches magic skills, sells spells, and offers a spell book for 250 gold. Copying a spell consumes the matching scroll and requires Expert Wisdom and the ability to learn the spell. The port follows the normal skill slot limit. (WoG Script 28)

### Junk Merchant — Trading Unwanted Artifacts

In WoG, the merchant buys items from the backpack and allows several trades in one session. In VCMI, the merchant presents one offer based on the hero's inventory. The hero can return immediately. The port has 32 artifact trades and 70 offers to sell spell scrolls for 500 gold each. VCMI may take an equipped item or disassemble a combination artifact to obtain the required part, so check the hero's inventory before accepting. (WoG Script 08)

## Magic, Travel, and Transformation

### Altar of Transformation — Transforming an Army

WoG lets the hero spend mana on a transformation and can roll separately for each stack. VCMI offers 11 icons for the nine classic town factions, Neutral, and Random. Random picks one destination faction for the entire army. Eligible stacks keep their creature count and tier. Standard town creatures also retain their upgrade status. The Neutral option uses its own equivalents. Selecting a faction costs 1,000 gold, while Random costs 500 gold. Both options cost 500 movement points. Each hero gets one paid transformation per week across all altars. Support for additional creatures depends on whether a transformation is defined for them. (WoG Script 14)

### Magic Mushrooms — Expert Spellcasting Until Monday

WoG temporarily replaces the level of a magic skill and restores it later. VCMI grants Expert spellcasting in one school of magic until the end of the week. A hero can benefit even with a full set of secondary skills. The learned skill stays at its existing level, so abilities and requirements that read the learned skill may still use that level. (WoG Script 10)

### Forgotten Shrine — A Prayer Before Battle

In both versions, the hero can decline. Accepting requires at least 201 movement points, spends all remaining movement, and grants one of 20 hidden blessings for the next battle. VCMI uses its opening spell mechanic to cast the spell at Expert mastery. The spell's rules, immunities, and battlefield magic restrictions still apply. (WoG Script 60)

### Potion Fountains — Potions With Three Doses

In WoG, heroes carry doses and decide before combat whether to drink a potion. In VCMI, each potion is an artifact with three charges. An equipped potion uses a dose after battle. Keeping it in the backpack saves it for later. Visiting the relevant fountain refills the potion, and some of its bonuses also apply on the adventure map. Mixing Hydromel with the Berserker Potion could cost a point of Spell Power in WoG. The VCMI port omits that interaction. (WoG Script 17)

### Mirror of the Home-Way — Travel to a Town

WoG lets the player select one of their own towns before charging the fee. VCMI charges 1,000 gold as soon as the hero accepts, before opening the list of the player's and allies' towns. Closing the list or having no valid destination can cost the fee without any travel. The portal uses no mana or additional movement points. (WoG Script 52)

### Spell Book — A Book Found on the Map

In WoG, picking up an ordinary Spell Book can give the hero spells. VCMI uses a separate object with four quality tiers that depend on Luck and Wisdom. It can also give the hero a Spell Book. The port follows VCMI's rules for selecting and learning spells, so duplicate rolls, Wisdom requirements, and map restrictions can affect the outcome. (WoG Script 27 and the classic script collection entry “51 wog - spell book”)

## Treasures and Trials on the Adventure Map

### Fishing Well — A Weekly Catch

WoG expands magic wells with outcomes including tunnels, traps, and monster encounters. VCMI adds a separate well with one catch per week, shared by all heroes. Fishing restores mana and uses all remaining movement points. The 43 possible outcomes include treasure, encounters with guards, and humorous discoveries with no material reward. The port leaves out the original tunnels and traps. (WoG Script 07)

### New Chest I — A Choice of Rewards or an Unpleasant Surprise

WoG can calculate the cost of upgrading a particular stack and select it automatically. VCMI checks which standard upgrades fit the chest's budget and lets the player choose a creature type. The upgrade applies to all stacks of the chosen type. Other outcomes offer resources, training, or a trap. The WoG gas trap applies a set of spells through ERM. In VCMI, the gas applies a penalty to Morale, Luck, Attack, or Defense. Expert Luck or Expert Intelligence protects the hero against the trap. (WoG Script 29)

### New Chest II — Scrolls, Tomes, and a Mine Deed

In WoG, studying a tome takes a week, and a deed can claim a mine remotely. In VCMI, if at least two skills qualify, the player can immediately raise one of them to Expert. The deed is worth 2,000 gold. In the scroll outcome, the hero can keep the scroll or exchange it for mana. The hero keeps the gold either way. (WoG Script 31)

### Palace of Dreams — One Bet per Day

WoG lets the player choose between two slot machines, see the symbols, and play several times in one session. The port combines their prizes into one automatic bet per palace per day, shared by all players. A bet costs 100 gold and up to 400 of the hero's remaining movement points. Usually the hero loses the stake, but the game can award a resource, gold, or an artifact. Early cash prizes depend on the day. Later payouts change by the week and are capped. (WoG Script 11)

### Sphinxes — A Trial of Luck

The classic WoG Sphinx asks a riddle from `ZSphinx0.TXT` and the player types an answer. A correct answer brings a blessing. A wrong or blank answer brings a curse. WoG 3.59 also has an optional script in which the player can ask up to three questions about a creature and make up to three guesses. The player can win a stack of those creatures or face them in battle.

In VCMI, all six Sphinxes use the same random trial. A hero needs 1,280 movement points and can visit each Sphinx once per day. A blessing and a curse are equally likely, and the effect lasts from 1 to 7 days. Version 1.0.1 adds Polish and English messages for every outcome. (WoG sources `T1/service.cpp`, `T1/erm.cpp`, and `Script098.erm`)

### War Machines on Map — Finding War Machines and the Grail

This VCMI add-on provides adventure map graphics for war machines and the Grail. The Ballista, Ammo Cart, and First Aid Tent can enter the ordinary random artifact pool. The Catapult and the Grail can be picked up when placed on the map. The ordinary draw skips the Catapult because it is a Special artifact and the Grail because it has no equipment slot. The ordinary Spell Book is unaffected by the add-on. There is no single equivalent ERM script in the WoG sources reviewed.

### Death Chamber — Facing the Undead King

In WoG, the King casts spells including Anti-Magic and Inferno. His death can trigger additional summons if his guards are still alive. With creature bank growth enabled, the chamber respawns 28 days after victory. In VCMI, the hero can decline the fight after the warning or leave the loot after winning and come back for it later. The battlefield has a fixed layout, and further reinforcements depend on the round and whether the King is still alive. The large crypts crumble in round two, and Wraiths or Ghosts can appear in round three. The port uses its own rules for the King's spells and curses. Armageddon targets the attacking army.

Chambers reset at the start of a shared 28-day cycle, such as on days 29 and 57. The base submod works on its own and awards gold. Creatures Compatibility enables Ghosts and the King's transformation into a Dracolich from week four onward. Mithril is a separate option. To combine both rewards, also enable the nested Creatures + Mithril Compatibility add-on. (WoG Script 70)

## What the Tests Confirmed

- **Palace of Dreams.** Across 6,000 visits on the test map, the engine awarded resources 74 times, gold 24 times, and an artifact 55 times. The stake was lost in the remaining 5,847 trials.
- **Sphinxes.** There were 3,000 trials per language with the same random seed. Each run produced 1,504 blessings and 1,496 curses, with every effect type appearing. A separate test confirmed that the 1,000 gold bonus paid out for the stated number of mornings for both the one-day and seven-day effects.
- **Training.** The server processed all 12 exchange directions at the Arcane Tower, Attack training at the Battle Academy, and the purchase of a Spell Book and the copying of Haste at the School of Wizardry.
- **Death Chamber.** The eight scenarios played two rounds and checked the start of round three. The tests then forced a victory to check that the loot could be claimed. They covered four add-on combinations and all five difficulty tiers. In both retreat tests, the chamber remained guarded.
- **War Machines.** The Ballista, Ammo Cart, and First Aid Tent appeared in 6,000 draws. The Catapult and the Grail were also picked up after being placed on the map.

The static audit and content loading checks cover all 19 submods. Details of the native tests, their logs, and the test program are in the ZIP's `QA` folder. Full regression testing still needs to cover the graphical client, AI, multiplayer, saving and loading, random map generation, WoG Graphic Fix, and third-party factions.
