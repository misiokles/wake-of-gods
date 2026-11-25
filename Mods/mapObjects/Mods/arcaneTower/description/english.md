# Arcane Tower (v1.0.1)

A ghostly tutor offers to exchange one primary skill point for another: Attack, Defence, Spell Power or Knowledge. The exchange changes the distribution of points, not their total.

## Using the tower

- One visit presents one randomly selected eligible exchange, with the gained and sacrificed attributes stated in the dialogue. You can refuse for free and revisit.
- Each accepted trade costs **300 movement points**. No gold or Mithril is required.
- All 12 different pairs of attributes are available if the hero qualifies. You can revisit the same tower (Space on its visitable tile) or another tower without a daily or weekly limit, provided you have enough movement.
- The offered donor must have at least 1 Attack/Defence or 2 Spell Power/Knowledge. The receiving attribute must be below 99 (standard VCMI cap).
- **Important:** remove equipment and potions that change primary skills before accepting a trade. VCMI currently checks the effective value, including equipment, while reducing the underlying base skill. Do not trade points granted by artifacts or temporary bonuses. This is a known engine limitation, not an enforced restriction. For example, a hero with base Attack 0 and Hydromel can be incorrectly offered an Attack sacrifice.

## Original WoG and this adaptation

The original Script 04 lets human players choose both skills and repeat the same exchange up to 30 times within the exchange loop, at no movement cost. It checks base skills via GetBasicPrim. VCMI retains the existing movement cost and randomized offer for balance and to display both sides of each trade. All 16 original ERT records are preserved in `description/wog-original/`; active English and Polish messages use the original introduction and exchange premise, while unsupported nested menu and post-exchange texts remain archived. No new Lua or engine changes are required.

## Verification

Native VCMI 1.8 checks on actual object instances: all 12 exchange directions, 299/300 movement threshold, refusal, minimum stats with unmodified attributes, effective cap of 99, repeated visits at one or two towers. 17 positive checks/groups passed; the Hydromel/base Attack issue was separately reproduced. Headless full-port load returned 0. GUI, AI, multiplayer, save/load, RMG and Polish client display were not tested.
