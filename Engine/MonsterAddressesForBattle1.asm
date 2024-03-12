MonsterTableSpriteSheetBlock: equ 16
MonsterTableNX:               equ MonsterTableSpriteSheetBlock+1
MonsterTableNY:               equ MonsterTableNX+1
MonsterTableCostGold:         equ MonsterTableNY+1
MonsterTableCostGems:         equ MonsterTableCostGold+1
MonsterTableCostRubies:       equ MonsterTableCostGems+1
MonsterTableHp:               equ MonsterTableCostRubies+1
MonsterTableSpeed:            equ MonsterTableHp+1
MonsterTableAttack:           equ MonsterTableSpeed+1
MonsterTableDefense:          equ MonsterTableAttack+1
MonsterTableGrowth:           equ MonsterTableDefense+1
MonsterTableSpecialAbility:   equ MonsterTableGrowth+1
MonsterTableName:             equ MonsterTableSpecialAbility+1
RangedMonster:                equ 128

LengthMonsterAddressesTable: equ Monster002Table-Monster001Table

Level1Unit: equ  %0000 0000
Level2Unit: equ  %0010 0000
Level3Unit: equ  %0100 0000
Level4Unit: equ  %0110 0000
Level5Unit: equ  %1000 0000
Level6Unit: equ  %1010 0000




include "MonsterAddressesForBattle1Data.asm"




Monster001Table:                        ;brown flyer (sd snatcher)
  dw    Monster001Idle
  dw    Monster001Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+00                           ;ny
  db    UsasUnitLevel3CostGold        ;cost (gold)
  db    UsasUnitLevel3CostGems        ;cost (gems)
  db    UsasUnitLevel3CostRubies      ;cost (rubies)
  db    UsasUnitLevel3HP              ;hp
  db    UsasUnitLevel3Speed           ;speed
  db    UsasUnitLevel3Attack          ;attack
  db    UsasUnitLevel3Defense         ;defense
  db    UsasUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Brown Flyer",255

Monster002Table:                        ;green flyer (sd snatcher)
  dw    Monster002Idle
  dw    Monster002Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+00                           ;ny
  db    UsasUnitLevel4CostGold        ;cost (gold)
  db    UsasUnitLevel4CostGems        ;cost (gems)
  db    UsasUnitLevel4CostRubies      ;cost (rubies)
  db    UsasUnitLevel4HP              ;hp
  db    UsasUnitLevel4Speed           ;speed
  db    UsasUnitLevel4Attack          ;attack
  db    UsasUnitLevel4Defense         ;defense
  db    UsasUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Green Flyer",255

Monster003Table:                        ;Dark grey flyer (sd snatcher)
  dw    Monster003Idle
  dw    Monster003Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+00                           ;ny
  db    UsasUnitLevel5CostGold        ;cost (gold)
  db    UsasUnitLevel5CostGems        ;cost (gems)
  db    UsasUnitLevel5CostRubies      ;cost (rubies)
  db    UsasUnitLevel5HP              ;hp
  db    UsasUnitLevel5Speed           ;speed
  db    UsasUnitLevel5Attack          ;attack
  db    UsasUnitLevel5Defense         ;defense
  db    UsasUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "DarkG Flyer",255

Monster004Table:                        ;light grey flyer (sd snatcher)
  dw    Monster004Idle
  dw    Monster004Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+00                           ;ny
  db    UsasUnitLevel6CostGold        ;cost (gold)
  db    UsasUnitLevel6CostGems        ;cost (gems)
  db    UsasUnitLevel6CostRubies      ;cost (rubies)
  db    UsasUnitLevel6HP              ;hp
  db    UsasUnitLevel6Speed           ;speed
  db    UsasUnitLevel6Attack          ;attack
  db    UsasUnitLevel6Defense         ;defense
  db    UsasUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "LightGFlyer",255

Monster005Table:                        ;big spider (sd snatcher)
  dw    Monster005Idle
  dw    Monster005Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    UsasUnitLevel2CostGold        ;cost (gold)
  db    UsasUnitLevel2CostGems        ;cost (gems)
  db    UsasUnitLevel2CostRubies      ;cost (rubies)
  db    UsasUnitLevel2HP              ;hp
  db    UsasUnitLevel2Speed           ;speed
  db    UsasUnitLevel2Attack          ;attack
  db    UsasUnitLevel2Defense         ;defense
  db    UsasUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Big Spider",255," "

Monster006Table:                        ;tiny spider (sd snatcher)
  dw    Monster006Idle
  dw    Monster006Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+04                           ;ny
  db    UsasUnitLevel1CostGold        ;cost (gold)
  db    UsasUnitLevel1CostGems        ;cost (gems)
  db    UsasUnitLevel1CostRubies      ;cost (rubies)
  db    UsasUnitLevel1HP              ;hp
  db    UsasUnitLevel1Speed           ;speed
  db    UsasUnitLevel1Attack          ;attack
  db    UsasUnitLevel1Defense         ;defense
  db    UsasUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Tiny Spider",255

Monster007Table:                        ;Bobblun blue (bubble bobble)
  dw    Monster007Idle
  dw    Monster007Move
  dw    Monster007AttackPatternRight
  dw    Monster007AttackPatternLeft
  dw    Monster007AttackPatternLeft
  dw    Monster007AttackPatternLeft
  dw    Monster007AttackPatternRight
  dw    Monster007AttackPatternRight
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupBUnitLevel4CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel4CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel4CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel4HP              ;hp
  db    BubbleBobbleGroupBUnitLevel4Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel4Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel4Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Bobblun",255,"    "

Monster008Table:                        ;Bubblun green (bubble bobble)
  dw    Monster008Idle
  dw    Monster008Move
  dw    Monster008AttackPatternRight
  dw    Monster008AttackPatternLeft
  dw    Monster008AttackPatternLeft
  dw    Monster008AttackPatternLeft
  dw    Monster008AttackPatternRight
  dw    Monster008AttackPatternRight
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupAUnitLevel5CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel5CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel5CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel5HP              ;hp
  db    BubbleBobbleGroupAUnitLevel5Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel5Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel5Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Bubblun",255,"    "

Monster009Table:                        ;zen chan blue robotic (bubble bobble)
  dw    Monster009Idle
  dw    Monster009Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupAUnitLevel1CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel1CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel1CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel1HP              ;hp
  db    BubbleBobbleGroupAUnitLevel1Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel1Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel1Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Zen Chan",255,"   "

Monster010Table:                        ;mad zen chan red robotic (bubble bobble)
  dw    Monster010Idle
  dw    Monster010Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupBUnitLevel3CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel3CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel3CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel3HP              ;hp
  db    BubbleBobbleGroupBUnitLevel3Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel3Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel3Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Mad Zenchan",255

Monster011Table:                        ;mighta ghoul (bubble bobble)
  dw    Monster011Idle
  dw    Monster011Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupAUnitLevel3CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel3CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel3CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel3HP              ;hp
  db    BubbleBobbleGroupAUnitLevel3Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel3Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel3Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Mighta",255,"     "

Monster012Table:                        ;skell monsta ghost whale (bubble bobble)
  dw    Monster012Idle
  dw    Monster012Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupAUnitLevel4CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel4CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel4CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel4HP              ;hp
  db    BubbleBobbleGroupAUnitLevel4Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel4Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel4Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "SkellMonsta",255

Monster013Table:                        ;Banebou spring jumper (bubble bobble)
  dw    Monster013Idle
  dw    Monster013Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupBUnitLevel1CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel1CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel1CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel1HP              ;hp
  db    BubbleBobbleGroupBUnitLevel1Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel1Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel1Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Banebou",255,"    "

Monster014Table:                        ;Hidegons blue fuzzy (bubble bobble)
  dw    Monster014Idle
  dw    Monster014Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupBUnitLevel2CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel2CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel2CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel2HP              ;hp
  db    BubbleBobbleGroupBUnitLevel2Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel2Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel2Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Hidegons",255,"   "

Monster015Table:                        ;drunk green (bubble bobble)
  dw    Monster015Idle
  dw    Monster015Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    BubbleBobbleGroupAUnitLevel2CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel2CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel2CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel2HP              ;hp
  db    BubbleBobbleGroupAUnitLevel2Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel2Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel2Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Drunk",255,"      "

Monster016Table:                        ;super drunk green (bubble bobble)
  dw    Monster016Idle
  dw    Monster016Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    64                              ;nx  
  db    64+04                           ;ny
  db    BubbleBobbleGroupBUnitLevel6CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel6CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel6CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel6HP              ;hp
  db    BubbleBobbleGroupBUnitLevel6Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel6Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel6Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Super Drunk",255

Monster017Table:                        ;super mighta ghoul (bubble bobble)
  dw    Monster017Idle
  dw    Monster017Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    BubbleBobbleGroupBUnitLevel5CostGold        ;cost (gold)
  db    BubbleBobbleGroupBUnitLevel5CostGems        ;cost (gems)
  db    BubbleBobbleGroupBUnitLevel5CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupBUnitLevel5HP              ;hp
  db    BubbleBobbleGroupBUnitLevel5Speed           ;speed
  db    BubbleBobbleGroupBUnitLevel5Attack          ;attack
  db    BubbleBobbleGroupBUnitLevel5Defense         ;defense
  db    BubbleBobbleGroupBUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Supermighta",255





Monster018Table:                        ;Fish Man (Castlevania)
  dw    Monster018Idle
  dw    Monster018Move
  dw    Monster018AttackPatternRight
  dw    Monster018AttackPatternLeft
  dw    Monster018AttackPatternLeftUp
  dw    Monster018AttackPatternLeftDown
  dw    Monster018AttackPatternRightUp
  dw    Monster018AttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel3CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel3CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel3CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel3HP              ;hp
  db    CastleVaniaUnitLevel3Speed           ;speed
  db    CastleVaniaUnitLevel3Attack          ;attack
  db    CastleVaniaUnitLevel3Defense         ;defense
  db    CastleVaniaUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Fish Man",255,"   "

Monster019Table:                        ;Zombie (Castlevania)
  dw    Monster019Idle
  dw    Monster019Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel1CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel1CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel1CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel1HP              ;hp
  db    CastleVaniaUnitLevel1Speed           ;speed
  db    CastleVaniaUnitLevel1Attack          ;attack
  db    CastleVaniaUnitLevel1Defense         ;defense
  db    CastleVaniaUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Zombie",255,"     "

Monster020Table:                        ;Mummy Man (Castlevania)
  dw    Monster020Idle
  dw    Monster020Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    CastleVaniaUnitLevel5CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel5CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel5CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel5HP              ;hp
  db    CastleVaniaUnitLevel5Speed           ;speed
  db    CastleVaniaUnitLevel5Attack          ;attack
  db    CastleVaniaUnitLevel5Defense         ;defense
  db    CastleVaniaUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Mummy Man",255,"  "

Monster021Table:                        ;Spear Guard (Castlevania)
  dw    Monster021Idle
  dw    Monster021Move
  dw    Monster021AttackPatternRight
  dw    Monster021AttackPatternLeft
  dw    Monster021AttackPatternLeftUp
  dw    Monster021AttackPatternLeftDown
  dw    Monster021AttackPatternRightUp
  dw    Monster021AttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel3CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel3CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel3CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel3HP              ;hp
  db    CastleVaniaUnitLevel3Speed           ;speed
  db    CastleVaniaUnitLevel3Attack          ;attack
  db    CastleVaniaUnitLevel3Defense         ;defense
  db    CastleVaniaUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Spear Guard",255

Monster022Table:                        ;Medusa Head (Castlevania)
  dw    Monster022Idle
  dw    Monster022Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    CastleVaniaUnitLevel2CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel2CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel2CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel2HP              ;hp
  db    CastleVaniaUnitLevel2Speed           ;speed
  db    CastleVaniaUnitLevel2Attack          ;attack
  db    CastleVaniaUnitLevel2Defense         ;defense
  db    CastleVaniaUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Medusa Head",255
  
Monster023Table:                        ;Flea Man (Castlevania)
  dw    Monster023Idle
  dw    Monster023Move
  dw    Monster023AttackPatternRight
  dw    Monster023AttackPatternLeft
  dw    Monster023AttackPatternLeftUp
  dw    Monster023AttackPatternLeftDown
  dw    Monster023AttackPatternRightUp
  dw    Monster023AttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    CastleVaniaUnitLevel2CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel2CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel2CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel2HP              ;hp
  db    CastleVaniaUnitLevel2Speed           ;speed
  db    CastleVaniaUnitLevel2Attack          ;attack
  db    CastleVaniaUnitLevel2Defense         ;defense
  db    CastleVaniaUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Flea Man",255,"   "

Monster024Table:                        ;Grim Reaper (Castlevania)
  dw    Monster024Idle
  dw    Monster024Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    48                              ;nx  
  db    48+08                           ;ny
  db    CastleVaniaUnitLevel6CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel6CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel6CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel6HP              ;hp
  db    CastleVaniaUnitLevel6Speed           ;speed
  db    CastleVaniaUnitLevel6Attack          ;attack
  db    CastleVaniaUnitLevel6Defense         ;defense
  db    CastleVaniaUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Grim Reaper",255
  
Monster025Table:                        ;Skeleton (Castlevania)
  dw    Monster025Idle
  dw    Monster025Move
  dw    Monster025AttackPatternRight
  dw    Monster025AttackPatternLeft
  dw    Monster025AttackPatternLeftUp
  dw    Monster025AttackPatternLeftDown
  dw    Monster025AttackPatternRightUp
  dw    Monster025AttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel1CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel1CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel1CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel1HP              ;hp
  db    CastleVaniaUnitLevel1Speed           ;speed
  db    CastleVaniaUnitLevel1Attack          ;attack
  db    CastleVaniaUnitLevel1Defense         ;defense
  db    CastleVaniaUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Skeleton",255,"   "

Monster026Table:                        ;Axe man (Castlevania)
  dw    Monster026Idle
  dw    Monster026Move
  dw    Monster026AttackPatternRight
  dw    Monster026AttackPatternLeft
  dw    Monster026AttackPatternLeft
  dw    Monster026AttackPatternLeft
  dw    Monster026AttackPatternRight
  dw    Monster026AttackPatternRight
  db    BattleMonsterSpriteSheet2Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel4CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel4CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel4CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel4HP              ;hp
  db    CastleVaniaUnitLevel4Speed           ;speed
  db    CastleVaniaUnitLevel4Attack          ;attack
  db    CastleVaniaUnitLevel4Defense         ;defense
  db    CastleVaniaUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Axe Man",255,"    "






Monster027Table:                        ;Scorpii (Dragon Slayer IV)
  dw    Monster027Idle
  dw    Monster027Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel2CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel2CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel2CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel2HP              ;hp
  db    DragonSlayerUnitLevel2Speed           ;speed
  db    DragonSlayerUnitLevel2Attack          ;attack
  db    DragonSlayerUnitLevel2Defense         ;defense
  db    DragonSlayerUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Scorpii",255,"    "


Monster028Table:                        ;Porgi (pink fatty) (Dragon Slayer IV)
  dw    Monster028Idle
  dw    Monster028Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel1CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel1CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel1CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel1HP              ;hp
  db    DragonSlayerUnitLevel1Speed           ;speed
  db    DragonSlayerUnitLevel1Attack          ;attack
  db    DragonSlayerUnitLevel1Defense         ;defense
  db    DragonSlayerUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Porgi",255,"      "

Monster029Table:                        ;Rock man (grey/white round small head) (Dragon Slayer IV)
  dw    Monster029Idle
  dw    Monster029Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel3CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel3CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel3CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel3HP              ;hp
  db    DragonSlayerUnitLevel3Speed           ;speed
  db    DragonSlayerUnitLevel3Attack          ;attack
  db    DragonSlayerUnitLevel3Defense         ;defense
  db    DragonSlayerUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Rock Man",255,"   "

Monster030Table:                        ;Piglet (piggy red nose) (Dragon Slayer IV)
  dw    Monster030Idle
  dw    Monster030Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel1CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel1CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel1CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel1HP              ;hp
  db    DragonSlayerUnitLevel1Speed           ;speed
  db    DragonSlayerUnitLevel1Attack          ;attack
  db    DragonSlayerUnitLevel1Defense         ;defense
  db    DragonSlayerUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Dawg",255,"       "
;  db    "Piglet",255,"     "

Monster031Table:                        ;Gers (white grey flat head) (Dragon Slayer IV)
  dw    Monster031Idle
  dw    Monster031Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel4CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel4CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel4CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel4HP              ;hp
  db    DragonSlayerUnitLevel4Speed           ;speed
  db    DragonSlayerUnitLevel4Attack          ;attack
  db    DragonSlayerUnitLevel4Defense         ;defense
  db    DragonSlayerUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Gers",255,"       "

Monster032Table:                        ;Yashinotkin (red fish like creature) (Dragon Slayer IV)
  dw    Monster032Idle
  dw    Monster032Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel2CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel2CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel2CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel2HP              ;hp
  db    DragonSlayerUnitLevel2Speed           ;speed
  db    DragonSlayerUnitLevel2Attack          ;attack
  db    DragonSlayerUnitLevel2Defense         ;defense
  db    DragonSlayerUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Yashinotkin",255

Monster033Table:                        ;King Mu (Dragon Slayer IV)
  dw    Monster033Idle
  dw    Monster033Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel6CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel6CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel6CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel6HP              ;hp
  db    DragonSlayerUnitLevel6Speed           ;speed
  db    DragonSlayerUnitLevel6Attack          ;attack
  db    DragonSlayerUnitLevel6Defense         ;defense
  db    DragonSlayerUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "King Mu",255,"    "

Monster034Table:                        ;Crawler (blue 3 legs) (Dragon Slayer IV)
  dw    Monster034Idle
  dw    Monster034Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel3CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel3CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel3CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel3HP              ;hp
  db    DragonSlayerUnitLevel3Speed           ;speed
  db    DragonSlayerUnitLevel3Attack          ;attack
  db    DragonSlayerUnitLevel3Defense         ;defense
  db    DragonSlayerUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Crawler",255,"    "

Monster035Table:                        ;Octo (Dragon Slayer IV)
  dw    Monster035Idle
  dw    Monster035Move
  dw    Monster035AttackPatternRight
  dw    Monster035AttackPatternLeft
  dw    Monster035AttackPatternLeft
  dw    Monster035AttackPatternLeft
  dw    Monster035AttackPatternRight
  dw    Monster035AttackPatternRight
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    DragonSlayerUnitLevel5CostGold        ;cost (gold)
  db    DragonSlayerUnitLevel5CostGems        ;cost (gems)
  db    DragonSlayerUnitLevel5CostRubies      ;cost (rubies)
  db    DragonSlayerUnitLevel5HP              ;hp
  db    DragonSlayerUnitLevel5Speed           ;speed
  db    DragonSlayerUnitLevel5Attack          ;attack
  db    DragonSlayerUnitLevel5Defense         ;defense
  db    DragonSlayerUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Octo",255,"       "

Monster036Table:                        ;Sarge green (Contra)
  dw    Monster036Idle
  dw    Monster036Move
  dw    Monster036AttackPatternRight
  dw    Monster036AttackPatternLeft
  dw    Monster036AttackPatternLeft
  dw    Monster036AttackPatternLeft
  dw    Monster036AttackPatternRight
  dw    Monster036AttackPatternRight
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel2CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel2CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel2CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel2HP              ;hp
  db    ContraGroupBUnitLevel2Speed           ;speed
  db    ContraGroupBUnitLevel2Attack          ;attack
  db    ContraGroupBUnitLevel2Defense         ;defense
  db    ContraGroupBUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Sarge",255,"      "

Monster037Table:                        ;Lieutenant red (Contra)
  dw    Monster037Idle
  dw    Monster037Move
  dw    Monster037AttackPatternRight
  dw    Monster037AttackPatternLeft
  dw    Monster037AttackPatternLeft
  dw    Monster037AttackPatternLeft
  dw    Monster037AttackPatternRight
  dw    Monster037AttackPatternRight
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel4CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel4CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel4CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel4HP              ;hp
  db    ContraGroupBUnitLevel4Speed           ;speed
  db    ContraGroupBUnitLevel4Attack          ;attack
  db    ContraGroupBUnitLevel4Defense         ;defense
  db    ContraGroupBUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Lieutenant",255," "

Monster038Table:                        ;FootSoldier (Contra)
  dw    Monster038Idle
  dw    Monster038Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupAUnitLevel1CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel1CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel1CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel1HP              ;hp
  db    ContraGroupAUnitLevel1Speed           ;speed
  db    ContraGroupAUnitLevel1Attack          ;attack
  db    ContraGroupAUnitLevel1Defense         ;defense
  db    ContraGroupAUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "FootSoldier",255

Monster039Table:                        ;Grenadier (Contra)
  dw    Monster039Idle
  dw    Monster039Move
  dw    Monster039AttackPatternRight
  dw    Monster039AttackPatternLeft
  dw    Monster039AttackPatternLeft
  dw    Monster039AttackPatternLeft
  dw    Monster039AttackPatternRight
  dw    Monster039AttackPatternRight
  db    BattleMonsterSpriteSheet4Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel5CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel5CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel5CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel5HP              ;hp
  db    ContraGroupBUnitLevel5Speed           ;speed
  db    ContraGroupBUnitLevel5Attack          ;attack
  db    ContraGroupBUnitLevel5Defense         ;defense
  db    ContraGroupBUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Grenadier",255,"  "

Monster040Table:                        ;Sniper (Contra)
  dw    Monster040Idle
  dw    Monster040Move
  dw    Monster040AttackPatternRight
  dw    Monster040AttackPatternLeft
  dw    Monster040AttackPatternLeft
  dw    Monster040AttackPatternLeft
  dw    Monster040AttackPatternRight
  dw    Monster040AttackPatternRight
  db    BattleMonsterSpriteSheet4Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel6CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel6CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel6CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel6HP              ;hp
  db    ContraGroupBUnitLevel6Speed           ;speed
  db    ContraGroupBUnitLevel6Attack          ;attack
  db    ContraGroupBUnitLevel6Defense         ;defense
  db    ContraGroupBUnitLevel6Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Sniper",255,"     "

Monster041Table:                        ;Gigafly (Contra)
  dw    Monster041Idle
  dw    Monster041Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    ContraGroupAUnitLevel3CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel3CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel3CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel3HP              ;hp
  db    ContraGroupAUnitLevel3Speed           ;speed
  db    ContraGroupAUnitLevel3Attack          ;attack
  db    ContraGroupAUnitLevel3Defense         ;defense
  db    ContraGroupAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Gigafly",255,"    "

Monster042Table:                        ;Alien Grunt (Contra)
  dw    Monster042Idle
  dw    Monster042Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupAUnitLevel2CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel2CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel2CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel2HP              ;hp
  db    ContraGroupAUnitLevel2Speed           ;speed
  db    ContraGroupAUnitLevel2Attack          ;attack
  db    ContraGroupAUnitLevel2Defense         ;defense
  db    ContraGroupAUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Alien Grunt",255

Monster043Table:                        ;Infiltrant (Contra)
  dw    Monster043Idle
  dw    Monster043Move
  dw    Monster043AttackPatternRight
  dw    Monster043AttackPatternLeft
  dw    Monster043AttackPatternLeft
  dw    Monster043AttackPatternLeft
  dw    Monster043AttackPatternRight
  dw    Monster043AttackPatternRight
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel3CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel3CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel3CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel3HP              ;hp
  db    ContraGroupBUnitLevel3Speed           ;speed
  db    ContraGroupBUnitLevel3Attack          ;attack
  db    ContraGroupBUnitLevel3Defense         ;defense
  db    ContraGroupBUnitLevel3Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Infiltrant",255," "

Monster044Table:                        ;Red Soldier (Contra)
  dw    Monster044Idle
  dw    Monster044Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupBUnitLevel1CostGold        ;cost (gold)
  db    ContraGroupBUnitLevel1CostGems        ;cost (gems)
  db    ContraGroupBUnitLevel1CostRubies      ;cost (rubies)
  db    ContraGroupBUnitLevel1HP              ;hp
  db    ContraGroupBUnitLevel1Speed           ;speed
  db    ContraGroupBUnitLevel1Attack          ;attack
  db    ContraGroupBUnitLevel1Defense         ;defense
  db    ContraGroupBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Red Soldier",255
  
Monster045Table:                        ;Face Hugger (Contra)
  dw    Monster045Idle
  dw    Monster045Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    ContraGroupAUnitLevel5CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel5CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel5CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel5HP              ;hp
  db    ContraGroupAUnitLevel5Speed           ;speed
  db    ContraGroupAUnitLevel5Attack          ;attack
  db    ContraGroupAUnitLevel5Defense         ;defense
  db    ContraGroupAUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Face Hugger",255

Monster046Table:                        ;Gorudea (Contra)
  dw    Monster046Idle
  dw    Monster046Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    32                              ;nx  
  db    56+08                           ;ny
  db    ContraGroupAUnitLevel6CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel6CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel6CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel6HP              ;hp
  db    ContraGroupAUnitLevel6Speed           ;speed
  db    ContraGroupAUnitLevel6Attack          ;attack
  db    ContraGroupAUnitLevel6Defense         ;defense
  db    ContraGroupAUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Gorudea",255,"    "

Monster047Table:                        ;Turret (Contra)
  dw    Monster047Idle
  dw    Monster047Move
  dw    Monster047AttackPatternRight
  dw    Monster047AttackPatternLeft
  dw    Monster047AttackPatternLeft
  dw    Monster047AttackPatternLeft
  dw    Monster047AttackPatternRight
  dw    Monster047AttackPatternRight
  db    BattleMonsterSpriteSheet3Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ContraGroupAUnitLevel4CostGold        ;cost (gold)
  db    ContraGroupAUnitLevel4CostGems        ;cost (gems)
  db    ContraGroupAUnitLevel4CostRubies      ;cost (rubies)
  db    ContraGroupAUnitLevel4HP              ;hp
  db    ContraGroupAUnitLevel4Speed           ;speed
  db    ContraGroupAUnitLevel4Attack          ;attack
  db    ContraGroupAUnitLevel4Defense         ;defense
  db    ContraGroupAUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Turret",255,"     "








Monster048Table:                        ;GraveWing (Usas)
  dw    Monster048Idle
  dw    Monster048Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    UsasUnitLevel4CostGold        ;cost (gold)
  db    UsasUnitLevel4CostGems        ;cost (gems)
  db    UsasUnitLevel4CostRubies      ;cost (rubies)
  db    UsasUnitLevel4HP              ;hp
  db    UsasUnitLevel4Speed           ;speed
  db    UsasUnitLevel4Attack          ;attack
  db    UsasUnitLevel4Defense         ;defense
  db    UsasUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Gravewing",255,"  "

Monster049Table:                        ;Vanguard (Usas)
  dw    Monster049Idle
  dw    Monster049Move
  dw    Monster049AttackPatternRight
  dw    Monster049AttackPatternLeft
  dw    Monster049AttackPatternLeft
  dw    Monster049AttackPatternLeft
  dw    Monster049AttackPatternRight
  dw    Monster049AttackPatternRight
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    UsasUnitLevel5CostGold        ;cost (gold)
  db    UsasUnitLevel5CostGems        ;cost (gems)
  db    UsasUnitLevel5CostRubies      ;cost (rubies)
  db    UsasUnitLevel5HP              ;hp
  db    UsasUnitLevel5Speed           ;speed
  db    UsasUnitLevel5Attack          ;attack
  db    UsasUnitLevel5Defense         ;defense
  db    UsasUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Vanguard",255,"   "

Monster050Table:                        ;Aerial Luna (Usas)
  dw    Monster050Idle
  dw    Monster050Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    UsasUnitLevel6CostGold        ;cost (gold)
  db    UsasUnitLevel6CostGems        ;cost (gems)
  db    UsasUnitLevel6CostRubies      ;cost (rubies)
  db    UsasUnitLevel6HP              ;hp
  db    UsasUnitLevel6Speed           ;speed
  db    UsasUnitLevel6Attack          ;attack
  db    UsasUnitLevel6Defense         ;defense
  db    UsasUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Aerial Luna",255
  
Monster051Table:                        ;Mini Phanto (Usas)
  dw    Monster051Idle
  dw    Monster051Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    UsasUnitLevel1CostGold        ;cost (gold)
  db    UsasUnitLevel1CostGems        ;cost (gems)
  db    UsasUnitLevel1CostRubies      ;cost (rubies)
  db    UsasUnitLevel1HP              ;hp
  db    UsasUnitLevel1Speed           ;speed
  db    UsasUnitLevel1Attack          ;attack
  db    UsasUnitLevel1Defense         ;defense
  db    UsasUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Mini Phanto",255
  
Monster052Table:                        ;Thicket Tot (Usas)
  dw    Monster052Idle
  dw    Monster052Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    UsasUnitLevel2CostGold        ;cost (gold)
  db    UsasUnitLevel2CostGems        ;cost (gems)
  db    UsasUnitLevel2CostRubies      ;cost (rubies)
  db    UsasUnitLevel2HP              ;hp
  db    UsasUnitLevel2Speed           ;speed
  db    UsasUnitLevel2Attack          ;attack
  db    UsasUnitLevel2Defense         ;defense
  db    UsasUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Thicket Tot",255
  
Monster053Table:                        ;Bonefin (Usas)
  dw    Monster053Idle
  dw    Monster053Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    UsasUnitLevel1CostGold        ;cost (gold)
  db    UsasUnitLevel1CostGems        ;cost (gems)
  db    UsasUnitLevel1CostRubies      ;cost (rubies)
  db    UsasUnitLevel1HP              ;hp
  db    UsasUnitLevel1Speed           ;speed
  db    UsasUnitLevel1Attack          ;attack
  db    UsasUnitLevel1Defense         ;defense
  db    UsasUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Bonefin",255,"    "

Monster054Table:                        ;Zomblet (Usas)
  dw    Monster054Idle
  dw    Monster054Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    UsasUnitLevel3CostGold        ;cost (gold)
  db    UsasUnitLevel3CostGems        ;cost (gems)
  db    UsasUnitLevel3CostRubies      ;cost (rubies)
  db    UsasUnitLevel3HP              ;hp
  db    UsasUnitLevel3Speed           ;speed
  db    UsasUnitLevel3Attack          ;attack
  db    UsasUnitLevel3Defense         ;defense
  db    UsasUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Zomblet",255,"    "

Monster055Table:                        ;Cheek (Goemon) (white kimono, long sleeves)
  dw    Monster055Idle
  dw    Monster055Move
  dw    Monster055AttackPatternRight
  dw    Monster055AttackPatternLeft
  dw    Monster055AttackPatternLeftUp
  dw    Monster055AttackPatternLeftDown
  dw    Monster055AttackPatternRightUp
  dw    Monster055AttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel1CostGold        ;cost (gold)
  db    GoemonUnitLevel1CostGems        ;cost (gems)
  db    GoemonUnitLevel1CostRubies      ;cost (rubies)
  db    GoemonUnitLevel1HP              ;hp
  db    GoemonUnitLevel1Speed           ;speed
  db    GoemonUnitLevel1Attack          ;attack
  db    GoemonUnitLevel1Defense         ;defense
  db    GoemonUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Cheek",255,"      "

Monster056Table:                        ;Official (with the white cup thing) (Goemon)
  dw    Monster056Idle
  dw    Monster056Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel4CostGold        ;cost (gold)
  db    GoemonUnitLevel4CostGems        ;cost (gems)
  db    GoemonUnitLevel4CostRubies      ;cost (rubies)
  db    GoemonUnitLevel4HP              ;hp
  db    GoemonUnitLevel4Speed           ;speed
  db    GoemonUnitLevel4Attack          ;attack
  db    GoemonUnitLevel4Defense         ;defense
  db    GoemonUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Official",255,"   "

Monster057Table:                        ;Kasa-obake (jumping freaky) (Goemon)
  dw    Monster057Idle
  dw    Monster057Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel2CostGold        ;cost (gold)
  db    GoemonUnitLevel2CostGems        ;cost (gems)
  db    GoemonUnitLevel2CostRubies      ;cost (rubies)
  db    GoemonUnitLevel2HP              ;hp
  db    GoemonUnitLevel2Speed           ;speed
  db    GoemonUnitLevel2Attack          ;attack
  db    GoemonUnitLevel2Defense         ;defense
  db    GoemonUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Kasa Obake",255," "

Monster058Table:                        ;Fishmonger (Goemon)
  dw    Monster058Idle
  dw    Monster058Move
  dw    Monster058AttackPatternRight
  dw    Monster058AttackPatternLeft
  dw    Monster058AttackPatternLeftUp
  dw    Monster058AttackPatternLeftDown
  dw    Monster058AttackPatternRightUp
  dw    Monster058AttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel2CostGold        ;cost (gold)
  db    GoemonUnitLevel2CostGems        ;cost (gems)
  db    GoemonUnitLevel2CostRubies      ;cost (rubies)
  db    GoemonUnitLevel2HP              ;hp
  db    GoemonUnitLevel2Speed           ;speed
  db    GoemonUnitLevel2Attack          ;attack
  db    GoemonUnitLevel2Defense         ;defense
  db    GoemonUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Fishmonger",255," "

Monster059Table:                        ;Ronin (Goemon)
  dw    Monster059Idle
  dw    Monster059Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel6CostGold        ;cost (gold)
  db    GoemonUnitLevel6CostGems        ;cost (gems)
  db    GoemonUnitLevel6CostRubies      ;cost (rubies)
  db    GoemonUnitLevel6HP              ;hp
  db    GoemonUnitLevel6Speed           ;speed
  db    GoemonUnitLevel6Attack          ;attack
  db    GoemonUnitLevel6Defense         ;defense
  db    GoemonUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Ronin",255,"      "

Monster060Table:                        ;Bucket Head (Goemon)
  dw    Monster060Idle
  dw    Monster060Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel3CostGold        ;cost (gold)
  db    GoemonUnitLevel3CostGems        ;cost (gems)
  db    GoemonUnitLevel3CostRubies      ;cost (rubies)
  db    GoemonUnitLevel3HP              ;hp
  db    GoemonUnitLevel3Speed           ;speed
  db    GoemonUnitLevel3Attack          ;attack
  db    GoemonUnitLevel3Defense         ;defense
  db    GoemonUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Bucket Head",255

Monster061Table:                        ;Headmaster (with the stick) (Goemon)
  dw    Monster061Idle
  dw    Monster061Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    48                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel5CostGold        ;cost (gold)
  db    GoemonUnitLevel5CostGems        ;cost (gems)
  db    GoemonUnitLevel5CostRubies      ;cost (rubies)
  db    GoemonUnitLevel5HP              ;hp
  db    GoemonUnitLevel5Speed           ;speed
  db    GoemonUnitLevel5Attack          ;attack
  db    GoemonUnitLevel5Defense         ;defense
  db    GoemonUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Headmaster",255," "

Monster062Table:                        ;Granola (Goemon)
  dw    Monster062Idle
  dw    Monster062Move
  dw    Monster062AttackPatternRight
  dw    Monster062AttackPatternLeft
  dw    Monster062AttackPatternLeftUp
  dw    Monster062AttackPatternLeftDown
  dw    Monster062AttackPatternRightUp
  dw    Monster062AttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    GoemonUnitLevel1CostGold        ;cost (gold)
  db    GoemonUnitLevel1CostGems        ;cost (gems)
  db    GoemonUnitLevel1CostRubies      ;cost (rubies)
  db    GoemonUnitLevel1HP              ;hp
  db    GoemonUnitLevel1Speed           ;speed
  db    GoemonUnitLevel1Attack          ;attack
  db    GoemonUnitLevel1Defense         ;defense
  db    GoemonUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Granola",255,"    "

Monster063Table:                        ;Rouge Gazer (white grey with red eye) (Psycho World)
  dw    Monster063Idle
  dw    Monster063Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel2CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel2CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel2CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel2HP              ;hp
  db    PsychoWorldUnitLevel2Speed           ;speed
  db    PsychoWorldUnitLevel2Attack          ;attack
  db    PsychoWorldUnitLevel2Defense         ;defense
  db    PsychoWorldUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Rouge Gazer",255

Monster064Table:                        ;Glacierling (Psycho World)
  dw    Monster064Idle
  dw    Monster064Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel3CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel3CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel3CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel3HP              ;hp
  db    PsychoWorldUnitLevel3Speed           ;speed
  db    PsychoWorldUnitLevel3Attack          ;attack
  db    PsychoWorldUnitLevel3Defense         ;defense
  db    PsychoWorldUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Glacierling",255

Monster065Table:                        ;Floatwing (Psycho World)
  dw    Monster065Idle
  dw    Monster065Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel4CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel4CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel4CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel4HP              ;hp
  db    PsychoWorldUnitLevel4Speed           ;speed
  db    PsychoWorldUnitLevel4Attack          ;attack
  db    PsychoWorldUnitLevel4Defense         ;defense
  db    PsychoWorldUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Floatwing",255,"  "

Monster066Table:                        ;CrimsonPeek (red with blue eye) (Psycho World)
  dw    Monster066Idle
  dw    Monster066Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel1CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel1CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel1CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel1HP              ;hp
  db    PsychoWorldUnitLevel1Speed           ;speed
  db    PsychoWorldUnitLevel1Attack          ;attack
  db    PsychoWorldUnitLevel1Defense         ;defense
  db    PsychoWorldUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "CrimsonPeek",255

Monster067Table:                        ;Fernling (green little plant) (Psycho World)
  dw    Monster067Idle
  dw    Monster067Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel2CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel2CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel2CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel2HP              ;hp
  db    PsychoWorldUnitLevel2Speed           ;speed
  db    PsychoWorldUnitLevel2Attack          ;attack
  db    PsychoWorldUnitLevel2Defense         ;defense
  db    PsychoWorldUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Fernling",255,"   "

Monster068Table:                        ;Bladezilla (Psycho World)
  dw    Monster068Idle
  dw    Monster068Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    PsychoWorldUnitLevel6CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel6CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel6CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel6HP              ;hp
  db    PsychoWorldUnitLevel6Speed           ;speed
  db    PsychoWorldUnitLevel6Attack          ;attack
  db    PsychoWorldUnitLevel6Defense         ;defense
  db    PsychoWorldUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Bladezilla",255," "

Monster069Table:                        ;Spitvine (Psycho World)
  dw    Monster069Idle
  dw    Monster069Move
  dw    Monster069AttackPatternRight
  dw    Monster069AttackPatternLeft
  dw    Monster069AttackPatternLeft
  dw    Monster069AttackPatternLeft
  dw    Monster069AttackPatternRight
  dw    Monster069AttackPatternRight
  db    BattleMonsterSpriteSheet6Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    PsychoWorldUnitLevel5CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel5CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel5CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel5HP              ;hp
  db    PsychoWorldUnitLevel5Speed           ;speed
  db    PsychoWorldUnitLevel5Attack          ;attack
  db    PsychoWorldUnitLevel5Defense         ;defense
  db    PsychoWorldUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Spitvine",255,"   "

Monster070Table:                        ;OptiLeaper (1 eyes white blue jumper) (Psycho World)
  dw    Monster070Idle
  dw    Monster070Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    PsychoWorldUnitLevel1CostGold        ;cost (gold)
  db    PsychoWorldUnitLevel1CostGems        ;cost (gems)
  db    PsychoWorldUnitLevel1CostRubies      ;cost (rubies)
  db    PsychoWorldUnitLevel1HP              ;hp
  db    PsychoWorldUnitLevel1Speed           ;speed
  db    PsychoWorldUnitLevel1Attack          ;attack
  db    PsychoWorldUnitLevel1Defense         ;defense
  db    PsychoWorldUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "OptiLeaper",255," "

Monster071Table:                        ;huge boo (bubble bobble)
  dw    Monster071Idle
  dw    Monster071Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    64                              ;nx  
  db    64+04                           ;ny
  db    BubbleBobbleGroupAUnitLevel6CostGold        ;cost (gold)
  db    BubbleBobbleGroupAUnitLevel6CostGems        ;cost (gems)
  db    BubbleBobbleGroupAUnitLevel6CostRubies      ;cost (rubies)
  db    BubbleBobbleGroupAUnitLevel6HP              ;hp
  db    BubbleBobbleGroupAUnitLevel6Speed           ;speed
  db    BubbleBobbleGroupAUnitLevel6Attack          ;attack
  db    BubbleBobbleGroupAUnitLevel6Defense         ;defense
  db    BubbleBobbleGroupAUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Boo",255,"        "

Monster072Table:                        ;King Kong (king kong)
  dw    Monster072Idle
  dw    Monster072Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    KingKongUnitLevel6CostGold        ;cost (gold)
  db    KingKongUnitLevel6CostGems        ;cost (gems)
  db    KingKongUnitLevel6CostRubies      ;cost (rubies)
  db    KingKongUnitLevel6HP              ;hp
  db    KingKongUnitLevel6Speed           ;speed
  db    KingKongUnitLevel6Attack          ;attack
  db    KingKongUnitLevel6Defense         ;defense
  db    KingKongUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "King Kong",255,"  "

Monster073Table:                        ;RockGoliath (king kong)
  dw    Monster073Idle
  dw    Monster073Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    KingKongUnitLevel5CostGold        ;cost (gold)
  db    KingKongUnitLevel5CostGems        ;cost (gems)
  db    KingKongUnitLevel5CostRubies      ;cost (rubies)
  db    KingKongUnitLevel5HP              ;hp
  db    KingKongUnitLevel5Speed           ;speed
  db    KingKongUnitLevel5Attack          ;attack
  db    KingKongUnitLevel5Defense         ;defense
  db    KingKongUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "RockGoliath",255

Monster074Table:                        ;Stone Guard (king kong)
  dw    Monster074Idle
  dw    Monster074Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingKongUnitLevel4CostGold        ;cost (gold)
  db    KingKongUnitLevel4CostGems        ;cost (gems)
  db    KingKongUnitLevel4CostRubies      ;cost (rubies)
  db    KingKongUnitLevel4HP              ;hp
  db    KingKongUnitLevel4Speed           ;speed
  db    KingKongUnitLevel4Attack          ;attack
  db    KingKongUnitLevel4Defense         ;defense
  db    KingKongUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Stone Guard",255
  
Monster075Table:                        ;LimeCritter (king kong)
  dw    Monster075Idle
  dw    Monster075Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingKongUnitLevel2CostGold        ;cost (gold)
  db    KingKongUnitLevel2CostGems        ;cost (gems)
  db    KingKongUnitLevel2CostRubies      ;cost (rubies)
  db    KingKongUnitLevel2HP              ;hp
  db    KingKongUnitLevel2Speed           ;speed
  db    KingKongUnitLevel2Attack          ;attack
  db    KingKongUnitLevel2Defense         ;defense
  db    KingKongUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "LimeCritter",255
  
Monster076Table:                        ;Salmon Hog (king kong)
  dw    Monster076Idle
  dw    Monster076Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingKongUnitLevel3CostGold        ;cost (gold)
  db    KingKongUnitLevel3CostGems        ;cost (gems)
  db    KingKongUnitLevel3CostRubies      ;cost (rubies)
  db    KingKongUnitLevel3HP              ;hp
  db    KingKongUnitLevel3Speed           ;speed
  db    KingKongUnitLevel3Attack          ;attack
  db    KingKongUnitLevel3Defense         ;defense
  db    KingKongUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Salmon Hog",255," "

Monster077Table:                        ;Swamp Goop (king kong)
  dw    Monster077Idle
  dw    Monster077Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingKongUnitLevel1CostGold        ;cost (gold)
  db    KingKongUnitLevel1CostGems        ;cost (gems)
  db    KingKongUnitLevel1CostRubies      ;cost (rubies)
  db    KingKongUnitLevel1HP              ;hp
  db    KingKongUnitLevel1Speed           ;speed
  db    KingKongUnitLevel1Attack          ;attack
  db    KingKongUnitLevel1Defense         ;defense
  db    KingKongUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Swamp Goop",255," "









Monster078Table:                        ;Bat (Golvellius)
  dw    Monster078Idle
  dw    Monster078Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    GolvelliusUnitLevel3CostGold        ;cost (gold)
  db    GolvelliusUnitLevel3CostGems        ;cost (gems)
  db    GolvelliusUnitLevel3CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel3HP              ;hp
  db    GolvelliusUnitLevel3Speed           ;speed
  db    GolvelliusUnitLevel3Attack          ;attack
  db    GolvelliusUnitLevel3Defense         ;defense
  db    GolvelliusUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Bat",255,"        "

Monster079Table:                        ;Olive Boa (green snake) (Golvellius)
  dw    Monster079Idle
  dw    Monster079Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    GolvelliusUnitLevel2CostGold        ;cost (gold)
  db    GolvelliusUnitLevel2CostGems        ;cost (gems)
  db    GolvelliusUnitLevel2CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel2HP              ;hp
  db    GolvelliusUnitLevel2Speed           ;speed
  db    GolvelliusUnitLevel2Attack          ;attack
  db    GolvelliusUnitLevel2Defense         ;defense
  db    GolvelliusUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Olive Boa",255,"  "

Monster080Table:                        ;SilkenLarva (green caterpillar) (Golvellius)
  dw    Monster080Idle
  dw    Monster080Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    16                              ;nx  
  db    08+08                           ;ny
  db    GolvelliusUnitLevel1CostGold        ;cost (gold)
  db    GolvelliusUnitLevel1CostGems        ;cost (gems)
  db    GolvelliusUnitLevel1CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel1HP              ;hp
  db    GolvelliusUnitLevel1Speed           ;speed
  db    GolvelliusUnitLevel1Attack          ;attack
  db    GolvelliusUnitLevel1Defense         ;defense
  db    GolvelliusUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "SilkenLarva",255

Monster081Table:                        ;ChocoTusker (Golvellius)
  dw    Monster081Idle
  dw    Monster081Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    GolvelliusUnitLevel2CostGold        ;cost (gold)
  db    GolvelliusUnitLevel2CostGems        ;cost (gems)
  db    GolvelliusUnitLevel2CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel2HP              ;hp
  db    GolvelliusUnitLevel2Speed           ;speed
  db    GolvelliusUnitLevel2Attack          ;attack
  db    GolvelliusUnitLevel2Defense         ;defense
  db    GolvelliusUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "ChocoTusker",255

Monster082Table:                        ;JadeWormlet (white worm) (Golvellius)
  dw    Monster082Idle
  dw    Monster082Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    16                              ;nx  
  db    08+08                           ;ny
  db    GolvelliusUnitLevel1CostGold        ;cost (gold)
  db    GolvelliusUnitLevel1CostGems        ;cost (gems)
  db    GolvelliusUnitLevel1CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel1HP              ;hp
  db    GolvelliusUnitLevel1Speed           ;speed
  db    GolvelliusUnitLevel1Attack          ;attack
  db    GolvelliusUnitLevel1Defense         ;defense
  db    GolvelliusUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "JadeWormlet",255
  
Monster083Table:                        ;Sable Raven (Golvellius)
  dw    Monster083Idle
  dw    Monster083Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    GolvelliusUnitLevel3CostGold        ;cost (gold)
  db    GolvelliusUnitLevel3CostGems        ;cost (gems)
  db    GolvelliusUnitLevel3CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel3HP              ;hp
  db    GolvelliusUnitLevel3Speed           ;speed
  db    GolvelliusUnitLevel3Attack          ;attack
  db    GolvelliusUnitLevel3Defense         ;defense
  db    GolvelliusUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Sable Raven",255
  
Monster084Table:                        ;Headless (Golvellius)
  dw    Monster084Idle
  dw    Monster084Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    GolvelliusUnitLevel4CostGold        ;cost (gold)
  db    GolvelliusUnitLevel4CostGems        ;cost (gems)
  db    GolvelliusUnitLevel4CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel4HP              ;hp
  db    GolvelliusUnitLevel4Speed           ;speed
  db    GolvelliusUnitLevel4Attack          ;attack
  db    GolvelliusUnitLevel4Defense         ;defense
  db    GolvelliusUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Headless",255,"   "

Monster085Table:                        ;Seraph (Golvellius)
  dw    Monster085Idle
  dw    Monster085Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet4Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    GolvelliusUnitLevel5CostGold        ;cost (gold)
  db    GolvelliusUnitLevel5CostGems        ;cost (gems)
  db    GolvelliusUnitLevel5CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel5HP              ;hp
  db    GolvelliusUnitLevel5Speed           ;speed
  db    GolvelliusUnitLevel5Attack          ;attack
  db    GolvelliusUnitLevel5Defense         ;defense
  db    GolvelliusUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Seraph",255,"     "

Monster086Table:                        ;Flame Cobra (Golvellius)
  dw    Monster086Idle
  dw    Monster086Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    56                              ;nx  
  db    64+04                           ;ny
  db    GolvelliusUnitLevel6CostGold        ;cost (gold)
  db    GolvelliusUnitLevel6CostGems        ;cost (gems)
  db    GolvelliusUnitLevel6CostRubies      ;cost (rubies)
  db    GolvelliusUnitLevel6HP              ;hp
  db    GolvelliusUnitLevel6Speed           ;speed
  db    GolvelliusUnitLevel6Attack          ;attack
  db    GolvelliusUnitLevel6Defense         ;defense
  db    GolvelliusUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Flame Cobra",255
  



Monster087Table:                        ;Visage (undeadline)
  dw    Monster087Idle
  dw    Monster087Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel4CostGold        ;cost (gold)
  db    RandomAUnitLevel4CostGems        ;cost (gems)
  db    RandomAUnitLevel4CostRubies      ;cost (rubies)
  db    RandomAUnitLevel4HP              ;hp
  db    RandomAUnitLevel4Speed           ;speed
  db    RandomAUnitLevel4Attack          ;attack
  db    RandomAUnitLevel4Defense         ;defense
  db    RandomAUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Visage",255,"     "
  
Monster088Table:                        ;JungleBrute (undeadline)
  dw    Monster088Idle
  dw    Monster088Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel2CostGold        ;cost (gold)
  db    RandomAUnitLevel2CostGems        ;cost (gems)
  db    RandomAUnitLevel2CostRubies      ;cost (rubies)
  db    RandomAUnitLevel2HP              ;hp
  db    RandomAUnitLevel2Speed           ;speed
  db    RandomAUnitLevel2Attack          ;attack
  db    RandomAUnitLevel2Defense         ;defense
  db    RandomAUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "JungleBrute",255
  
Monster089Table:                        ;Lurcher (undeadline)
  dw    Monster089Idle
  dw    Monster089Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    CastleVaniaUnitLevel1CostGold        ;cost (gold)
  db    CastleVaniaUnitLevel1CostGems        ;cost (gems)
  db    CastleVaniaUnitLevel1CostRubies      ;cost (rubies)
  db    CastleVaniaUnitLevel1HP              ;hp
  db    CastleVaniaUnitLevel1Speed           ;speed
  db    CastleVaniaUnitLevel1Attack          ;attack
  db    CastleVaniaUnitLevel1Defense         ;defense
  db    CastleVaniaUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Lurcher",255,"    "



Monster090Table:                        ;Scavenger (Metal Gear)
  dw    Monster090Idle
  dw    Monster090Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    16                              ;nx  
  db    08+08                           ;ny
  db    SolidSnakeUnitLevel1CostGold        ;cost (gold)
  db    SolidSnakeUnitLevel1CostGems        ;cost (gems)
  db    SolidSnakeUnitLevel1CostRubies      ;cost (rubies)
  db    SolidSnakeUnitLevel1HP              ;hp
  db    SolidSnakeUnitLevel1Speed           ;speed
  db    SolidSnakeUnitLevel1Attack          ;attack
  db    SolidSnakeUnitLevel1Defense         ;defense
  db    SolidSnakeUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Scavenger",255,"  "

Monster091Table:                        ;Running Man (Metal Gear)
  dw    Monster091Idle
  dw    Monster091Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    SolidSnakeUnitLevel2CostGold        ;cost (gold)
  db    SolidSnakeUnitLevel2CostGems        ;cost (gems)
  db    SolidSnakeUnitLevel2CostRubies      ;cost (rubies)
  db    SolidSnakeUnitLevel2HP              ;hp
  db    SolidSnakeUnitLevel2Speed           ;speed
  db    SolidSnakeUnitLevel2Attack          ;attack
  db    SolidSnakeUnitLevel2Defense         ;defense
  db    SolidSnakeUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Running Man",255
  
Monster092Table:                        ;Trooper (Metal Gear)
  dw    Monster092Idle
  dw    Monster092Move
  dw    Monster092AttackPatternRight
  dw    Monster092AttackPatternLeft
  dw    Monster092AttackPatternLeft
  dw    Monster092AttackPatternLeft
  dw    Monster092AttackPatternRight
  dw    Monster092AttackPatternRight
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    SolidSnakeUnitLevel4CostGold        ;cost (gold)
  db    SolidSnakeUnitLevel4CostGems        ;cost (gems)
  db    SolidSnakeUnitLevel4CostRubies      ;cost (rubies)
  db    SolidSnakeUnitLevel4HP              ;hp
  db    SolidSnakeUnitLevel4Speed           ;speed
  db    SolidSnakeUnitLevel4Attack          ;attack
  db    SolidSnakeUnitLevel4Defense         ;defense
  db    SolidSnakeUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Trooper",255,"    "

Monster093Table:                        ;Antigas Man (Metal Gear)
  dw    Monster093Idle
  dw    Monster093Move
  dw    Monster093AttackPatternRight
  dw    Monster093AttackPatternLeft
  dw    Monster093AttackPatternLeft
  dw    Monster093AttackPatternLeft
  dw    Monster093AttackPatternRight
  dw    Monster093AttackPatternRight
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    SolidSnakeUnitLevel5CostGold        ;cost (gold)
  db    SolidSnakeUnitLevel5CostGems        ;cost (gems)
  db    SolidSnakeUnitLevel5CostRubies      ;cost (rubies)
  db    SolidSnakeUnitLevel5HP              ;hp
  db    SolidSnakeUnitLevel5Speed           ;speed
  db    SolidSnakeUnitLevel5Attack          ;attack
  db    SolidSnakeUnitLevel5Defense         ;defense
  db    SolidSnakeUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Antigas Man",255
  
Monster094Table:                        ;Footman (Metal Gear)
  dw    Monster094Idle
  dw    Monster094Move
  dw    Monster094AttackPatternRight
  dw    Monster094AttackPatternLeft
  dw    Monster094AttackPatternLeft
  dw    Monster094AttackPatternLeft
  dw    Monster094AttackPatternRight
  dw    Monster094AttackPatternRight
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    SolidSnakeUnitLevel3CostGold        ;cost (gold)
  db    SolidSnakeUnitLevel3CostGems        ;cost (gems)
  db    SolidSnakeUnitLevel3CostRubies      ;cost (rubies)
  db    SolidSnakeUnitLevel3HP              ;hp
  db    SolidSnakeUnitLevel3Speed           ;speed
  db    SolidSnakeUnitLevel3Attack          ;attack
  db    SolidSnakeUnitLevel3Defense         ;defense
  db    SolidSnakeUnitLevel3Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Footman",255,"    "







Monster095Table:                        ;Geld (Ys 3)
  dw    Monster095Idle
  dw    Monster095Move
  dw    Monster095AttackPatternRight
  dw    Monster095AttackPatternLeft
  dw    Monster095AttackPatternLeftUp
  dw    Monster095AttackPatternLeftDown
  dw    Monster095AttackPatternRightUp
  dw    Monster095AttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    Ys3UnitLevel5CostGold        ;cost (gold)
  db    Ys3UnitLevel5CostGems        ;cost (gems)
  db    Ys3UnitLevel5CostRubies      ;cost (rubies)
  db    Ys3UnitLevel5HP              ;hp
  db    Ys3UnitLevel5Speed           ;speed
  db    Ys3UnitLevel5Attack          ;attack
  db    Ys3UnitLevel5Defense         ;defense
  db    Ys3UnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Geld",255,"       "

Monster096Table:                        ;Raddel (Ys 3)
  dw    Monster096Idle
  dw    Monster096Move
  dw    Monster096AttackPatternRight
  dw    Monster096AttackPatternLeft
  dw    Monster096AttackPatternLeftUp
  dw    Monster096AttackPatternLeftDown
  dw    Monster096AttackPatternRightUp
  dw    Monster096AttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    Ys3UnitLevel4CostGold        ;cost (gold)
  db    Ys3UnitLevel4CostGems        ;cost (gems)
  db    Ys3UnitLevel4CostRubies      ;cost (rubies)
  db    Ys3UnitLevel4HP              ;hp
  db    Ys3UnitLevel4Speed           ;speed
  db    Ys3UnitLevel4Attack          ;attack
  db    Ys3UnitLevel4Defense         ;defense
  db    Ys3UnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Raddel",255,"     "
  
Monster097Table:                        ;Bikmorl (Ys 3)
  dw    Monster097Idle
  dw    Monster097Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    Ys3UnitLevel3CostGold        ;cost (gold)
  db    Ys3UnitLevel3CostGems        ;cost (gems)
  db    Ys3UnitLevel3CostRubies      ;cost (rubies)
  db    Ys3UnitLevel3HP              ;hp
  db    Ys3UnitLevel3Speed           ;speed
  db    Ys3UnitLevel3Attack          ;attack
  db    Ys3UnitLevel3Defense         ;defense
  db    Ys3UnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Bikmorl",255,"    "
  
Monster098Table:                        ;Slime (Ys 3)
  dw    Monster098Idle
  dw    Monster098Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    16                              ;nx  
  db    08+08                           ;ny
  db    Ys3UnitLevel1CostGold        ;cost (gold)
  db    Ys3UnitLevel1CostGems        ;cost (gems)
  db    Ys3UnitLevel1CostRubies      ;cost (rubies)
  db    Ys3UnitLevel1HP              ;hp
  db    Ys3UnitLevel1Speed           ;speed
  db    Ys3UnitLevel1Attack          ;attack
  db    Ys3UnitLevel1Defense         ;defense
  db    Ys3UnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Slime",255,"      "
  
Monster099Table:                        ;Keyron (Ys 3)
  dw    Monster099Idle
  dw    Monster099Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    Ys3UnitLevel2CostGold        ;cost (gold)
  db    Ys3UnitLevel2CostGems        ;cost (gems)
  db    Ys3UnitLevel2CostRubies      ;cost (rubies)
  db    Ys3UnitLevel2HP              ;hp
  db    Ys3UnitLevel2Speed           ;speed
  db    Ys3UnitLevel2Attack          ;attack
  db    Ys3UnitLevel2Defense         ;defense
  db    Ys3UnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Keyron",255,"     "
  
Monster100Table:                        ;Gululmus (Ys 3)
  dw    Monster100Idle
  dw    Monster100Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet5Block
  db    16                              ;nx  
  db    08+08                           ;ny
  db    Ys3UnitLevel1CostGold        ;cost (gold)
  db    Ys3UnitLevel1CostGems        ;cost (gems)
  db    Ys3UnitLevel1CostRubies      ;cost (rubies)
  db    Ys3UnitLevel1HP              ;hp
  db    Ys3UnitLevel1Speed           ;speed
  db    Ys3UnitLevel1Attack          ;attack
  db    Ys3UnitLevel1Defense         ;defense
  db    Ys3UnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Gululmus",255,"   "
  
Monster101Table:                        ;Sabre Wolf (Ys 3)
  dw    Monster101Idle
  dw    Monster101Move
  dw    Monster101AttackPatternRight
  dw    Monster101AttackPatternLeft
  dw    Monster101AttackPatternLeftUp
  dw    Monster101AttackPatternLeftDown
  dw    Monster101AttackPatternRightUp
  dw    Monster101AttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    48                              ;nx  
  db    24+08                           ;ny
  db    Ys3UnitLevel6CostGold        ;cost (gold)
  db    Ys3UnitLevel6CostGems        ;cost (gems)
  db    Ys3UnitLevel6CostRubies      ;cost (rubies)
  db    Ys3UnitLevel6HP              ;hp
  db    Ys3UnitLevel6Speed           ;speed
  db    Ys3UnitLevel6Attack          ;attack
  db    Ys3UnitLevel6Defense         ;defense
  db    Ys3UnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Sabre Wolf",255," "
  





Monster102Table:                        ;Lee Young (yie ar kung fu)
  dw    Monster102Idle
  dw    Monster102Move
  dw    Monster102AttackPatternRight
  dw    Monster102AttackPatternLeft
  dw    Monster102AttackPatternLeftUp
  dw    Monster102AttackPatternLeftDown
  dw    Monster102AttackPatternRightUp
  dw    Monster102AttackPatternRightDown
  db    BattleMonsterSpriteSheet9Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel1CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel1CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel1CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel1HP              ;hp
  db    YieArKungFuUnitLevel1Speed           ;speed
  db    YieArKungFuUnitLevel1Attack          ;attack
  db    YieArKungFuUnitLevel1Defense         ;defense
  db    YieArKungFuUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Lee Young",255,"  "
  
Monster103Table:                        ;Yen Pei (braid hair) (yie ar kung fu)
  dw    Monster103Idle
  dw    Monster103Move
  dw    Monster103AttackPatternRight
  dw    Monster103AttackPatternLeft
  dw    Monster103AttackPatternLeftUp
  dw    Monster103AttackPatternLeftDown
  dw    Monster103AttackPatternRightUp
  dw    Monster103AttackPatternRightDown
  db    BattleMonsterSpriteSheet9Block
  db    48                              ;nx  
  db    40+08                           ;ny
  db    YieArKungFuUnitLevel2CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel2CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel2CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel2HP              ;hp
  db    YieArKungFuUnitLevel2Speed           ;speed
  db    YieArKungFuUnitLevel2Attack          ;attack
  db    YieArKungFuUnitLevel2Defense         ;defense
  db    YieArKungFuUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Yen Pei",255,"    "
  
Monster104Table:                        ;Lan Fang (fan thrower) (yie ar kung fu)
  dw    Monster104Idle
  dw    Monster104Move
  dw    Monster104AttackPatternRight
  dw    Monster104AttackPatternLeft
  dw    Monster104AttackPatternLeft
  dw    Monster104AttackPatternLeft
  dw    Monster104AttackPatternRight
  dw    Monster104AttackPatternRight
  db    BattleMonsterSpriteSheet9Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel3CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel3CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel3CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel3HP              ;hp
  db    YieArKungFuUnitLevel3Speed           ;speed
  db    YieArKungFuUnitLevel3Attack          ;attack
  db    YieArKungFuUnitLevel3Defense         ;defense
  db    YieArKungFuUnitLevel3Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Lan Fang",255,"   "

Monster105Table:                        ;Po Chin (fatty) (yie ar kung fu)
  dw    Monster105Idle
  dw    Monster105Move
  dw    Monster105AttackPatternRight
  dw    Monster105AttackPatternLeft
  dw    Monster105AttackPatternLeftUp
  dw    Monster105AttackPatternLeftDown
  dw    Monster105AttackPatternRightUp
  dw    Monster105AttackPatternRightDown
  db    BattleMonsterSpriteSheet9Block
  db    48                              ;nx  
  db    40+08                           ;ny
  db    YieArKungFuUnitLevel4CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel4CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel4CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel4HP              ;hp
  db    YieArKungFuUnitLevel4Speed           ;speed
  db    YieArKungFuUnitLevel4Attack          ;attack
  db    YieArKungFuUnitLevel4Defense         ;defense
  db    YieArKungFuUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Po Chin",255,"    "

Monster106Table:                        ;Wen Hu (yie ar kung fu)
  dw    Monster106Idle
  dw    Monster106Move
  dw    Monster106AttackPatternRight
  dw    Monster106AttackPatternLeft
  dw    Monster106AttackPatternLeftUp
  dw    Monster106AttackPatternLeftDown
  dw    Monster106AttackPatternRightUp
  dw    Monster106AttackPatternRightDown
  db    BattleMonsterSpriteSheet10Block
  db    48                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel5CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel5CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel5CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel5HP              ;hp
  db    YieArKungFuUnitLevel5Speed           ;speed
  db    YieArKungFuUnitLevel5Attack          ;attack
  db    YieArKungFuUnitLevel5Defense         ;defense
  db    YieArKungFuUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Wen Hu",255,"     "

Monster107Table:                        ;Wei Chin (yie ar kung fu)
  dw    Monster107Idle
  dw    Monster107Move
  dw    Monster107AttackPatternRight
  dw    Monster107AttackPatternLeft
  dw    Monster107AttackPatternLeftUp
  dw    Monster107AttackPatternLeftDown
  dw    Monster107AttackPatternRightUp
  dw    Monster107AttackPatternRightDown
  db    BattleMonsterSpriteSheet10Block
  db    48                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel3CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel3CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel3CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel3HP              ;hp
  db    YieArKungFuUnitLevel3Speed           ;speed
  db    YieArKungFuUnitLevel3Attack          ;attack
  db    YieArKungFuUnitLevel3Defense         ;defense
  db    YieArKungFuUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Wei Chin",255,"   "

Monster108Table:                        ;Mei Ling (yie ar kung fu)
  dw    Monster108Idle
  dw    Monster108Move
  dw    Monster108AttackPatternRight
  dw    Monster108AttackPatternLeft
  dw    Monster108AttackPatternLeftUp
  dw    Monster108AttackPatternLeftDown
  dw    Monster108AttackPatternRightUp
  dw    Monster108AttackPatternRightDown
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel2CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel2CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel2CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel2HP              ;hp
  db    YieArKungFuUnitLevel2Speed           ;speed
  db    YieArKungFuUnitLevel2Attack          ;attack
  db    YieArKungFuUnitLevel2Defense         ;defense
  db    YieArKungFuUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Mei Ling",255,"   "

Monster109Table:                        ;Han Chen (bomb thrower) (yie ar kung fu)
  dw    Monster109Idle
  dw    Monster109Move
  dw    Monster109AttackPatternRight
  dw    Monster109AttackPatternLeft
  dw    Monster109AttackPatternLeft
  dw    Monster109AttackPatternLeft
  dw    Monster109AttackPatternRight
  dw    Monster109AttackPatternRight
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    YieArKungFuUnitLevel4CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel4CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel4CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel4HP              ;hp
  db    YieArKungFuUnitLevel4Speed           ;speed
  db    YieArKungFuUnitLevel4Attack          ;attack
  db    YieArKungFuUnitLevel4Defense         ;defense
  db    YieArKungFuUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Han Chen",255,"   "

Monster110Table:                        ;Li Yen (final boss) (yie ar kung fu)
  dw    Monster110Idle
  dw    Monster110Move
  dw    Monster110AttackPatternRight
  dw    Monster110AttackPatternLeft
  dw    Monster110AttackPatternLeft
  dw    Monster110AttackPatternLeft
  dw    Monster110AttackPatternRight
  dw    Monster110AttackPatternRight
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    YieArKungFuUnitLevel6CostGold        ;cost (gold)
  db    YieArKungFuUnitLevel6CostGems        ;cost (gems)
  db    YieArKungFuUnitLevel6CostRubies      ;cost (rubies)
  db    YieArKungFuUnitLevel6HP              ;hp
  db    YieArKungFuUnitLevel6Speed           ;speed
  db    YieArKungFuUnitLevel6Attack          ;attack
  db    YieArKungFuUnitLevel6Defense         ;defense
  db    YieArKungFuUnitLevel6Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Li Yen",255,"     "













Monster111Table:                        ;Queen Sora (pink bird) (akanbe dragon)
  dw    Monster111Idle
  dw    Monster111Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel5CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel5CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel5CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel5HP              ;hp
  db    AkanbeDragonGroupAUnitLevel5Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel5Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel5Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Queen Sora",255," "

Monster112Table:                        ;King Mori (akanbe dragon)
  dw    Monster112Idle
  dw    Monster112Move
  dw    Monster112AttackPatternRight
  dw    Monster112AttackPatternLeft
  dw    Monster112AttackPatternLeft
  dw    Monster112AttackPatternLeft
  dw    Monster112AttackPatternRight
  dw    Monster112AttackPatternRight
  db    BattleMonsterSpriteSheet8Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel6CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel6CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel6CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel6HP              ;hp
  db    AkanbeDragonGroupAUnitLevel6Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel6Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel6Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel6Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "King Mori",255,"  "

Monster113Table:                        ;Knight Yama (mongolface) (akanbe dragon)
  dw    Monster113Idle
  dw    Monster113Move
  dw    Monster113AttackPatternRight
  dw    Monster113AttackPatternLeft
  dw    Monster113AttackPatternLeft
  dw    Monster113AttackPatternLeft
  dw    Monster113AttackPatternRight
  dw    Monster113AttackPatternRight
  db    BattleMonsterSpriteSheet8Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel2CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel2CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel2CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel2HP              ;hp
  db    AkanbeDragonGroupAUnitLevel2Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel2Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel2Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Knight Yama",255
  
Monster114Table:                        ;Bishop Mori (monkey) (akanbe dragon)
  dw    Monster114Idle
  dw    Monster114Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel2CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel2CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel2CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel2HP              ;hp
  db    AkanbeDragonGroupBUnitLevel2Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel2Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel2Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Bishop Mori",255

Monster115Table:                        ;B. Heichi (rhino) (akanbe dragon)
  dw    Monster115Idle
  dw    Monster115Move
  dw    Monster115AttackPatternRight
  dw    Monster115AttackPatternLeft
  dw    Monster115AttackPatternLeft
  dw    Monster115AttackPatternLeft
  dw    Monster115AttackPatternRight
  dw    Monster115AttackPatternRight
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel3CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel3CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel3CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel3HP              ;hp
  db    AkanbeDragonGroupAUnitLevel3Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel3Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel3Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel3Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "B. Heichi",255,"  "

Monster116Table:                        ;Roke Mizu (zebra) (akanbe dragon)
  dw    Monster116Idle
  dw    Monster116Move
  dw    Monster116AttackPatternRight
  dw    Monster116AttackPatternLeft
  dw    Monster116AttackPatternLeftUp
  dw    Monster116AttackPatternLeftDown
  dw    Monster116AttackPatternRightUp
  dw    Monster116AttackPatternRightDown
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel3CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel3CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel3CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel3HP              ;hp
  db    AkanbeDragonGroupBUnitLevel3Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel3Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel3Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Roke Mizu",255,"  "

Monster117Table:                        ;Porn Mizu (akanbe dragon)
  dw    Monster117Idle
  dw    Monster117Move
  dw    Monster117AttackPatternRight
  dw    Monster117AttackPatternLeft
  dw    Monster117AttackPatternLeftUp
  dw    Monster117AttackPatternLeftDown
  dw    Monster117AttackPatternRightUp
  dw    Monster117AttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel1CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel1CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel1CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel1HP              ;hp
  db    AkanbeDragonGroupAUnitLevel1Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel1Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel1Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Porn Mizu",255,"  "

Monster118Table:                        ;Roke Yama (kangaroo) (akanbe dragon)
  dw    Monster118Idle
  dw    Monster118Move
  dw    Monster118AttackPatternRight
  dw    Monster118AttackPatternLeft
  dw    Monster118AttackPatternLeftUp
  dw    Monster118AttackPatternLeftDown
  dw    Monster118AttackPatternRightUp
  dw    Monster118AttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupAUnitLevel4CostGold        ;cost (gold)
  db    AkanbeDragonGroupAUnitLevel4CostGems        ;cost (gems)
  db    AkanbeDragonGroupAUnitLevel4CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupAUnitLevel4HP              ;hp
  db    AkanbeDragonGroupAUnitLevel4Speed           ;speed
  db    AkanbeDragonGroupAUnitLevel4Attack          ;attack
  db    AkanbeDragonGroupAUnitLevel4Defense         ;defense
  db    AkanbeDragonGroupAUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Roke Yama",255,"  "

Monster119Table:                        ;Porn Heichi (eliphant) (akanbe dragon)
  dw    Monster119Idle
  dw    Monster119Move
  dw    Monster119AttackPatternRight
  dw    Monster119AttackPatternLeft
  dw    Monster119AttackPatternLeft
  dw    Monster119AttackPatternLeft
  dw    Monster119AttackPatternRight
  dw    Monster119AttackPatternRight
  db    BattleMonsterSpriteSheet11Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel1CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel1CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel1CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel1HP              ;hp
  db    AkanbeDragonGroupBUnitLevel1Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel1Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel1Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel1Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Porn Heichi",255
  
Monster120Table:                        ;Yama Knight (bushman) (akanbe dragon)
  dw    Monster120Idle
  dw    Monster120Move
  dw    Monster120AttackPatternRight
  dw    Monster120AttackPatternLeft
  dw    Monster120AttackPatternLeft
  dw    Monster120AttackPatternLeft
  dw    Monster120AttackPatternRight
  dw    Monster120AttackPatternRight
  db    BattleMonsterSpriteSheet11Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel4CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel4CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel4CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel4HP              ;hp
  db    AkanbeDragonGroupBUnitLevel4Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel4Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel4Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Yama Knight",255

Monster121Table:                        ;King Heichi (endboss) (akanbe dragon)
  dw    Monster121Idle
  dw    Monster121Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    48                              ;nx  
  db    56+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel6CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel6CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel6CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel6HP              ;hp
  db    AkanbeDragonGroupBUnitLevel6Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel6Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel6Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "King Heichi",255

Monster122Table:                        ;Spooky (Spooky)
  dw    Monster122Idle
  dw    Monster122Move
  dw    Monster122AttackPatternRight
  dw    Monster122AttackPatternLeft
  dw    Monster122AttackPatternLeftUp
  dw    Monster122AttackPatternLeftDown
  dw    Monster122AttackPatternRightUp
  dw    Monster122AttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Spooky",255,"     "

Monster123Table:                        ;Ghosty (spooky)
  dw    Monster123Idle
  dw    Monster123Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Ghosty",255,"     "

Monster124Table:                        ;KuGyoku Den (legendly 9 gems)
  dw    Monster124Idle
  dw    Monster124Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomAUnitLevel3CostGold        ;cost (gold)
  db    RandomAUnitLevel3CostGems        ;cost (gems)
  db    RandomAUnitLevel3CostRubies      ;cost (rubies)
  db    RandomAUnitLevel3HP              ;hp
  db    RandomAUnitLevel3Speed           ;speed
  db    RandomAUnitLevel3Attack          ;attack
  db    RandomAUnitLevel3Defense         ;defense
  db    RandomAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "KuGyoku Den",255
  
Monster125Table:                        ;GooGoo (quinpl)
  dw    Monster125Idle
  dw    Monster125Move
  dw    Monster125AttackPatternRight
  dw    Monster125AttackPatternLeft
  dw    Monster125AttackPatternLeft
  dw    Monster125AttackPatternLeft
  dw    Monster125AttackPatternRight
  dw    Monster125AttackPatternRight
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack-2          ;attack
  db    RandomBUnitLevel2Defense-1         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "GooGoo",255,"     "

Monster126Table:                        ;sofia (sofia)
  dw    Monster126Idle
  dw    Monster126Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Sofia",255,"      "

Monster127Table:                        ;Rastan (rastan saga)
  dw    Monster127Idle
  dw    Monster127Move
  dw    Monster127AttackPatternRight
  dw    Monster127AttackPatternLeft
  dw    Monster127AttackPatternLeftUp
  dw    Monster127AttackPatternLeftDown
  dw    Monster127AttackPatternRightUp
  dw    Monster127AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    32                              ;nx  
  db    38+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Rastan",255,"     "

Monster128Table:                        ;BlasterBot
  dw    Monster128Idle
  dw    Monster128Move
  dw    Monster128AttackPatternRight
  dw    Monster128AttackPatternLeft
  dw    Monster128AttackPatternLeftUp
  dw    Monster128AttackPatternLeftDown
  dw    Monster128AttackPatternRightUp
  dw    Monster128AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel5CostGold        ;cost (gold)
  db    RandomAUnitLevel5CostGems        ;cost (gems)
  db    RandomAUnitLevel5CostRubies      ;cost (rubies)
  db    RandomAUnitLevel5HP              ;hp
  db    RandomAUnitLevel5Speed           ;speed
  db    RandomAUnitLevel5Attack          ;attack
  db    RandomAUnitLevel5Defense         ;defense
  db    RandomAUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "BlasterBot",255," "

Monster129Table:                        ;Screech
  dw    Monster129Idle
  dw    Monster129Move
  dw    Monster129AttackPatternRight
  dw    Monster129AttackPatternLeft
  dw    Monster129AttackPatternLeft
  dw    Monster129AttackPatternLeft
  dw    Monster129AttackPatternRight
  dw    Monster129AttackPatternRight
  db    BattleMonsterSpriteSheet13Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel2CostGold        ;cost (gold)
  db    RandomAUnitLevel2CostGems        ;cost (gems)
  db    RandomAUnitLevel2CostRubies      ;cost (rubies)
  db    RandomAUnitLevel2HP              ;hp
  db    RandomAUnitLevel2Speed           ;speed
  db    RandomAUnitLevel2Attack-3          ;attack
  db    RandomAUnitLevel2Defense         ;defense
  db    RandomAUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Screech",255,"    "

Monster130Table:                        ;Schaefer (predator)
  dw    Monster130Idle
  dw    Monster130Move
  dw    Monster130AttackPatternRight
  dw    Monster130AttackPatternLeft
  dw    Monster130AttackPatternLeftUp
  dw    Monster130AttackPatternLeftDown
  dw    Monster130AttackPatternRightUp
  dw    Monster130AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Schaefer",255,"   "

Monster131Table:                        ;Jon Sparkle (malaya no hihou)
  dw    Monster131Idle
  dw    Monster131Move
  dw    Monster131AttackPatternRight
  dw    Monster131AttackPatternLeft
  dw    Monster131AttackPatternLeftUp
  dw    Monster131AttackPatternLeftDown
  dw    Monster131AttackPatternRightUp
  dw    Monster131AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel3CostGold        ;cost (gold)
  db    RandomAUnitLevel3CostGems        ;cost (gems)
  db    RandomAUnitLevel3CostRubies      ;cost (rubies)
  db    RandomAUnitLevel3HP              ;hp
  db    RandomAUnitLevel3Speed           ;speed
  db    RandomAUnitLevel3Attack          ;attack
  db    RandomAUnitLevel3Defense         ;defense
  db    RandomAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Jon Sparkle",255

Monster132Table:                        ;Monmon (mon mon monster)
  dw    Monster132Idle
  dw    Monster132Move
  dw    Monster132AttackPatternRight
  dw    Monster132AttackPatternLeft
  dw    Monster132AttackPatternLeftUp
  dw    Monster132AttackPatternLeftDown
  dw    Monster132AttackPatternRightUp
  dw    Monster132AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel4CostGold        ;cost (gold)
  db    RandomBUnitLevel4CostGems        ;cost (gems)
  db    RandomBUnitLevel4CostRubies      ;cost (rubies)
  db    RandomBUnitLevel4HP              ;hp
  db    RandomBUnitLevel4Speed           ;speed
  db    RandomBUnitLevel4Attack          ;attack
  db    RandomBUnitLevel4Defense         ;defense
  db    RandomBUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Monmon",255,"     "
  
Monster133Table:                        ;Cob Crusher (mon mon monster)
  dw    Monster133Idle
  dw    Monster133Move
  dw    Monster133AttackPatternRight
  dw    Monster133AttackPatternLeft
  dw    Monster133AttackPatternLeftUp
  dw    Monster133AttackPatternLeftDown
  dw    Monster133AttackPatternRightUp
  dw    Monster133AttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Cob Crusher",255
  
Monster134Table:                        ;Limb Linger (mon mon monster)
  dw    Monster134Idle
  dw    Monster134Move
  dw    Monster134AttackPatternRight
  dw    Monster134AttackPatternLeft
  dw    Monster134AttackPatternLeftUp
  dw    Monster134AttackPatternLeftDown
  dw    Monster134AttackPatternRightUp
  dw    Monster134AttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomAUnitLevel2CostGold        ;cost (gold)
  db    RandomAUnitLevel2CostGems        ;cost (gems)
  db    RandomAUnitLevel2CostRubies      ;cost (rubies)
  db    RandomAUnitLevel2HP              ;hp
  db    RandomAUnitLevel2Speed           ;speed
  db    RandomAUnitLevel2Attack          ;attack
  db    RandomAUnitLevel2Defense         ;defense
  db    RandomAUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Limb Linger",255
  
Monster135Table:                        ;deva (deva)
  dw    Monster135Idle
  dw    Monster135Move
  dw    Monster135AttackPatternRight
  dw    Monster135AttackPatternLeft
  dw    Monster135AttackPatternLeftUp
  dw    Monster135AttackPatternLeftDown
  dw    Monster135AttackPatternRightUp
  dw    Monster135AttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    DevaUnitLevel4CostGold        ;cost (gold)
  db    DevaUnitLevel4CostGems        ;cost (gems)
  db    DevaUnitLevel4CostRubies      ;cost (rubies)
  db    DevaUnitLevel4HP              ;hp
  db    DevaUnitLevel4Speed           ;speed
  db    DevaUnitLevel4Attack          ;attack
  db    DevaUnitLevel4Defense         ;defense
  db    DevaUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Deva",255,"       "
  
Monster136Table:                        ;Spectroll (deva)
  dw    Monster136Idle
  dw    Monster136Move
  dw    Monster136AttackPatternRight
  dw    Monster136AttackPatternLeft
  dw    Monster136AttackPatternLeftUp
  dw    Monster136AttackPatternLeftDown
  dw    Monster136AttackPatternRightUp
  dw    Monster136AttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    DevaUnitLevel2CostGold        ;cost (gold)
  db    DevaUnitLevel2CostGems        ;cost (gems)
  db    DevaUnitLevel2CostRubies      ;cost (rubies)
  db    DevaUnitLevel2HP              ;hp
  db    DevaUnitLevel2Speed           ;speed
  db    DevaUnitLevel2Attack          ;attack
  db    DevaUnitLevel2Defense         ;defense
  db    DevaUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Spectroll",255,"  "
  
Monster137Table:                        ;Yurei Kage (deva)
  dw    Monster137Idle
  dw    Monster137Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    32                              ;nx  
  db    48+08                           ;ny
  db    DevaUnitLevel3CostGold        ;cost (gold)
  db    DevaUnitLevel3CostGems        ;cost (gems)
  db    DevaUnitLevel3CostRubies      ;cost (rubies)
  db    DevaUnitLevel3HP              ;hp
  db    DevaUnitLevel3Speed           ;speed
  db    DevaUnitLevel3Attack          ;attack
  db    DevaUnitLevel3Defense         ;defense
  db    DevaUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Yurei Kage",255," "
  
Monster138Table:                        ;Huge Blob (usas2)
  dw    Monster138Idle
  dw    Monster138Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    48                              ;nx  
  db    40+08                           ;ny
  db    Usas2UnitLevel5CostGold        ;cost (gold)
  db    Usas2UnitLevel5CostGems        ;cost (gems)
  db    Usas2UnitLevel5CostRubies      ;cost (rubies)
  db    Usas2UnitLevel5HP              ;hp
  db    Usas2UnitLevel5Speed           ;speed
  db    Usas2UnitLevel5Attack          ;attack
  db    Usas2UnitLevel5Defense         ;defense
  db    Usas2UnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Blob",255,"       "

Monster139Table:                        ;Emir Mystic (usas2)
  dw    Monster139Idle
  dw    Monster139Move
  dw    Monster139AttackPatternRight
  dw    Monster139AttackPatternLeft
  dw    Monster139AttackPatternLeftUp
  dw    Monster139AttackPatternLeftDown
  dw    Monster139AttackPatternRightUp
  dw    Monster139AttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    Usas2UnitLevel4CostGold        ;cost (gold)
  db    Usas2UnitLevel4CostGems        ;cost (gems)
  db    Usas2UnitLevel4CostRubies      ;cost (rubies)
  db    Usas2UnitLevel4HP              ;hp
  db    Usas2UnitLevel4Speed           ;speed
  db    Usas2UnitLevel4Attack          ;attack
  db    Usas2UnitLevel4Defense         ;defense
  db    Usas2UnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Emir Mystic",255
  
Monster140Table:                        ;duncan seven (core dump)
  dw    Monster140Idle
  dw    Monster140Move
  dw    Monster140AttackPatternRight
  dw    Monster140AttackPatternLeft
  dw    Monster140AttackPatternLeftUp
  dw    Monster140AttackPatternLeftDown
  dw    Monster140AttackPatternRightUp
  dw    Monster140AttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel5CostGold        ;cost (gold)
  db    RandomAUnitLevel5CostGems        ;cost (gems)
  db    RandomAUnitLevel5CostRubies      ;cost (rubies)
  db    RandomAUnitLevel5HP              ;hp
  db    RandomAUnitLevel5Speed           ;speed
  db    RandomAUnitLevel5Attack          ;attack
  db    RandomAUnitLevel5Defense         ;defense
  db    RandomAUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Duncan 7",255,"   "

Monster141Table:                        ;Monstrilla (core dump)
  dw    Monster141Idle
  dw    Monster141Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    64                              ;nx  
  db    64+04                           ;ny
  db    RandomAUnitLevel6CostGold        ;cost (gold)
  db    RandomAUnitLevel6CostGems        ;cost (gems)
  db    RandomAUnitLevel6CostRubies      ;cost (rubies)
  db    RandomAUnitLevel6HP              ;hp
  db    RandomAUnitLevel6Speed           ;speed
  db    RandomAUnitLevel6Attack          ;attack
  db    RandomAUnitLevel6Defense         ;defense
  db    RandomAUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Monstrilla",255," "

Monster142Table:                        ;Biolumia (core dump)
  dw    Monster142Idle
  dw    Monster142Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    RandomAUnitLevel4CostGold        ;cost (gold)
  db    RandomAUnitLevel4CostGems        ;cost (gems)
  db    RandomAUnitLevel4CostRubies      ;cost (rubies)
  db    RandomAUnitLevel4HP              ;hp
  db    RandomAUnitLevel4Speed           ;speed
  db    RandomAUnitLevel4Attack          ;attack
  db    RandomAUnitLevel4Defense         ;defense
  db    RandomAUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Biolumia",255,"   "

Monster143Table:                        ;Anna Lee (cabage patch kids)
  dw    Monster143Idle
  dw    Monster143Move
  dw    Monster143AttackPatternRight
  dw    Monster143AttackPatternLeft
  dw    Monster143AttackPatternLeftUp
  dw    Monster143AttackPatternLeftDown
  dw    Monster143AttackPatternRightUp
  dw    Monster143AttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel1CostGold        ;cost (gold)
  db    RandomAUnitLevel1CostGems        ;cost (gems)
  db    RandomAUnitLevel1CostRubies      ;cost (rubies)
  db    RandomAUnitLevel1HP              ;hp
  db    RandomAUnitLevel1Speed           ;speed
  db    RandomAUnitLevel1Attack          ;attack
  db    RandomAUnitLevel1Defense         ;defense
  db    RandomAUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Anna Lee",255,"   "

Monster144Table:                        ;Pastry Chef (comic bakery)
  dw    Monster144Idle
  dw    Monster144Move
  dw    Monster144AttackPatternRight
  dw    Monster144AttackPatternLeft
  dw    Monster144AttackPatternLeft
  dw    Monster144AttackPatternLeft
  dw    Monster144AttackPatternRight
  dw    Monster144AttackPatternRight
  db    BattleMonsterSpriteSheet14Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP-1              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack-2          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Pastry Chef",255

Monster145Table:                        ;Indy Brave (magical tree)
  dw    Monster145Idle
  dw    Monster145Move
  dw    Monster145AttackPatternRight
  dw    Monster145AttackPatternLeft
  dw    Monster145AttackPatternLeftUp
  dw    Monster145AttackPatternLeftDown
  dw    Monster145AttackPatternRightUp
  dw    Monster145AttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Indy Brave",255," "

Monster146Table:                        ;Red Lupin (arsene lupin)
  dw    Monster146Idle
  dw    Monster146Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel3CostGold        ;cost (gold)
  db    RandomAUnitLevel3CostGems        ;cost (gems)
  db    RandomAUnitLevel3CostRubies      ;cost (rubies)
  db    RandomAUnitLevel3HP              ;hp
  db    RandomAUnitLevel3Speed           ;speed
  db    RandomAUnitLevel3Attack          ;attack
  db    RandomAUnitLevel3Defense         ;defense
  db    RandomAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Red Lupin",255,"  "

Monster147Table:                        ;Green Lupin (arsene lupin)
  dw    Monster147Idle
  dw    Monster147Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Green Lupin",255
  
Monster148Table:                        ;Major Mirth (arsene lupin)
  dw    Monster148Idle
  dw    Monster148Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet14Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel2CostGold        ;cost (gold)
  db    RandomAUnitLevel2CostGems        ;cost (gems)
  db    RandomAUnitLevel2CostRubies      ;cost (rubies)
  db    RandomAUnitLevel2HP              ;hp
  db    RandomAUnitLevel2Speed           ;speed
  db    RandomAUnitLevel2Attack          ;attack
  db    RandomAUnitLevel2Defense         ;defense
  db    RandomAUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Major Mirth",255
  
Monster149Table:                        ;Vic Viper (kings valley 2)
  dw    Monster149Idle
  dw    Monster149Move
  dw    Monster149AttackPatternRight
  dw    Monster149AttackPatternLeft
  dw    Monster149AttackPatternLeft
  dw    Monster149AttackPatternLeft
  dw    Monster149AttackPatternRight
  dw    Monster149AttackPatternRight
  db    BattleMonsterSpriteSheet13Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingsValley2UnitLevel4CostGold        ;cost (gold)
  db    KingsValley2UnitLevel4CostGems        ;cost (gems)
  db    KingsValley2UnitLevel4CostRubies      ;cost (rubies)
  db    KingsValley2UnitLevel4HP              ;hp
  db    KingsValley2UnitLevel4Speed           ;speed
  db    KingsValley2UnitLevel4Attack          ;attack
  db    KingsValley2UnitLevel4Defense         ;defense
  db    KingsValley2UnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Vic Viper",255,"  "

Monster150Table:                        ;Rock Roll (kings valley 2)
  dw    Monster150Idle
  dw    Monster150Move
  dw    Monster150AttackPatternRight
  dw    Monster150AttackPatternLeft
  dw    Monster150AttackPatternLeftUp
  dw    Monster150AttackPatternLeftDown
  dw    Monster150AttackPatternRightUp
  dw    Monster150AttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingsValley2UnitLevel3CostGold        ;cost (gold)
  db    KingsValley2UnitLevel3CostGems        ;cost (gems)
  db    KingsValley2UnitLevel3CostRubies      ;cost (rubies)
  db    KingsValley2UnitLevel3HP              ;hp
  db    KingsValley2UnitLevel3Speed           ;speed
  db    KingsValley2UnitLevel3Attack          ;attack
  db    KingsValley2UnitLevel3Defense         ;defense
  db    KingsValley2UnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Rock Roll",255,"  "

Monster151Table:                        ;Slouman (kings valley 2)
  dw    Monster151Idle
  dw    Monster151Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingsValley2UnitLevel1CostGold        ;cost (gold)
  db    KingsValley2UnitLevel1CostGems        ;cost (gems)
  db    KingsValley2UnitLevel1CostRubies      ;cost (rubies)
  db    KingsValley2UnitLevel1HP              ;hp
  db    KingsValley2UnitLevel1Speed           ;speed
  db    KingsValley2UnitLevel1Attack          ;attack
  db    KingsValley2UnitLevel1Defense         ;defense
  db    KingsValley2UnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Slouman",255,"    "

Monster152Table:                        ;Pyoncy (kings valley 2)
  dw    Monster152Idle
  dw    Monster152Move
  dw    Monster152AttackPatternRight
  dw    Monster152AttackPatternLeft
  dw    Monster152AttackPatternLeftUp
  dw    Monster152AttackPatternLeftDown
  dw    Monster152AttackPatternRightUp
  dw    Monster152AttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    KingsValley2UnitLevel2CostGold        ;cost (gold)
  db    KingsValley2UnitLevel2CostGems        ;cost (gems)
  db    KingsValley2UnitLevel2CostRubies      ;cost (rubies)
  db    KingsValley2UnitLevel2HP              ;hp
  db    KingsValley2UnitLevel2Speed           ;speed
  db    KingsValley2UnitLevel2Attack          ;attack
  db    KingsValley2UnitLevel2Defense         ;defense
  db    KingsValley2UnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Pyoncy",255,"     "







Monster153Table:                        ;Andorogynus (Andorogynus)
  dw    Monster153Idle
  dw    Monster153Move
  dw    Monster153AttackPatternRight
  dw    Monster153AttackPatternLeft
  dw    Monster153AttackPatternLeft
  dw    Monster153AttackPatternLeft
  dw    Monster153AttackPatternRight
  dw    Monster153AttackPatternRight
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    RandomBUnitLevel4CostGold        ;cost (gold)
  db    RandomBUnitLevel4CostGems        ;cost (gems)
  db    RandomBUnitLevel4CostRubies      ;cost (rubies)
  db    RandomBUnitLevel4HP-2              ;hp
  db    RandomBUnitLevel4Speed           ;speed
  db    RandomBUnitLevel4Attack-2          ;attack
  db    RandomBUnitLevel4Defense         ;defense
  db    RandomBUnitLevel4Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Andorogynus",255
  
Monster154Table:                        ;Thexder (Thexder)
  dw    Monster154Idle
  dw    Monster154Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel5CostGold        ;cost (gold)
  db    RandomBUnitLevel5CostGems        ;cost (gems)
  db    RandomBUnitLevel5CostRubies      ;cost (rubies)
  db    RandomBUnitLevel5HP              ;hp
  db    RandomBUnitLevel5Speed           ;speed
  db    RandomBUnitLevel5Attack          ;attack
  db    RandomBUnitLevel5Defense         ;defense
  db    RandomBUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Thexder",255,"    "

Monster155Table:                        ;BounceBot (Thexder)
  dw    Monster155Idle
  dw    Monster155Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet6Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomAUnitLevel3CostGold        ;cost (gold)
  db    RandomAUnitLevel3CostGems        ;cost (gems)
  db    RandomAUnitLevel3CostRubies      ;cost (rubies)
  db    RandomAUnitLevel3HP              ;hp
  db    RandomAUnitLevel3Speed           ;speed
  db    RandomAUnitLevel3Attack          ;attack
  db    RandomAUnitLevel3Defense         ;defense
  db    RandomAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "BounceBot",255,"  "

Monster156Table:                        ;ColossalBot (Thexder)
  dw    Monster156Idle
  dw    Monster156Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet11Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel6CostGold        ;cost (gold)
  db    RandomBUnitLevel6CostGems        ;cost (gems)
  db    RandomBUnitLevel6CostRubies      ;cost (rubies)
  db    RandomBUnitLevel6HP              ;hp
  db    RandomBUnitLevel6Speed           ;speed
  db    RandomBUnitLevel6Attack          ;attack
  db    RandomBUnitLevel6Defense         ;defense
  db    RandomBUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "ColossalBot",255

Monster157Table:                        ;SuperRunner (SuperRunner)
  dw    Monster157Idle
  dw    Monster157Move
  dw    Monster157AttackPatternRight
  dw    Monster157AttackPatternLeft
  dw    Monster157AttackPatternLeftUp
  dw    Monster157AttackPatternLeftDown
  dw    Monster157AttackPatternRightUp
  dw    Monster157AttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomAUnitLevel3CostGold        ;cost (gold)
  db    RandomAUnitLevel3CostGems        ;cost (gems)
  db    RandomAUnitLevel3CostRubies      ;cost (rubies)
  db    RandomAUnitLevel3HP              ;hp
  db    RandomAUnitLevel3Speed           ;speed
  db    RandomAUnitLevel3Attack          ;attack
  db    RandomAUnitLevel3Defense         ;defense
  db    RandomAUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "SuperRunner",255
  
Monster158Table:                        ;Queen Sora (green bird) (akanbe dragon)
  dw    Monster158Idle
  dw    Monster158Move
  dw    Monster158AttackPatternRight
  dw    Monster158AttackPatternLeft
  dw    Monster158AttackPatternLeft
  dw    Monster158AttackPatternLeft
  dw    Monster158AttackPatternRight
  dw    Monster158AttackPatternRight
  db    BattleMonsterSpriteSheet9Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    AkanbeDragonGroupBUnitLevel5CostGold        ;cost (gold)
  db    AkanbeDragonGroupBUnitLevel5CostGems        ;cost (gems)
  db    AkanbeDragonGroupBUnitLevel5CostRubies      ;cost (rubies)
  db    AkanbeDragonGroupBUnitLevel5HP              ;hp
  db    AkanbeDragonGroupBUnitLevel5Speed           ;speed
  db    AkanbeDragonGroupBUnitLevel5Attack          ;attack
  db    AkanbeDragonGroupBUnitLevel5Defense         ;defense
  db    AkanbeDragonGroupBUnitLevel5Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Queen Sora",255," "





SenkoKyuLevel2Number:           equ 52
SenkoKyuLevel2Attack:           equ 3
SenkoKyuLevel2Defense:          equ 7
SenkoKyuLevel2HP:               equ 18
SenkoKyuLevel2Speed:            equ 3
SenkoKyuLevel2Growth:           equ 8
SenkoKyuLevel2CostGold:         equ 120/10
SenkoKyuLevel2CostGems:         equ 00+Level2Unit
SenkoKyuLevel2CostRubies:       equ 0

Monster159Table:                        ;Senko Kyu (shooting head) (hinotori)
  dw    Monster159Idle
  dw    Monster159Move
  dw    Monster159AttackPatternRight
  dw    Monster159AttackPatternLeft
  dw    Monster159AttackPatternLeft
  dw    Monster159AttackPatternLeft
  dw    Monster159AttackPatternRight
  dw    Monster159AttackPatternRight
  db    BattleMonsterSpriteSheet9Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    SenkoKyuLevel2CostGold        ;cost (gold)
  db    SenkoKyuLevel2CostGems        ;cost (gems)
  db    SenkoKyuLevel2CostRubies      ;cost (rubies)
  db    SenkoKyuLevel2HP              ;hp
  db    SenkoKyuLevel2Speed           ;speed
  db    SenkoKyuLevel2Attack          ;attack
  db    SenkoKyuLevel2Defense         ;defense
  db    SenkoKyuLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Senko Kyu",255,"  "

Monster160Table:                        ;Chucklehook (higemaru)
  dw    Monster160Idle
  dw    Monster160Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet9Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Chucklehook",255
  
Monster161Table:                        ;Sir Oji (castle excellent)
  dw    Monster161Idle
  dw    Monster161Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Sir Oji",255,"    "

Monster162Table:                        ;Pentaro (parodius)
  dw    Monster162Idle
  dw    Monster162Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Pentaro",255,"    "

Monster163Table:                        ;Moai (parodius)
  dw    Monster163Idle
  dw    Monster163Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Moai",255,"       "

Monster164Table:                        ;Thomas (kung fu master)
  dw    Monster164Idle
  dw    Monster164Move
  dw    Monster164AttackPatternRight
  dw    Monster164AttackPatternLeft
  dw    Monster164AttackPatternLeftUp
  dw    Monster164AttackPatternLeftDown
  dw    Monster164AttackPatternRightUp
  dw    Monster164AttackPatternRightDown
  db    BattleMonsterSpriteSheet7Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    RandomBUnitLevel4CostGold        ;cost (gold)
  db    RandomBUnitLevel4CostGems        ;cost (gems)
  db    RandomBUnitLevel4CostRubies      ;cost (rubies)
  db    RandomBUnitLevel4HP              ;hp
  db    RandomBUnitLevel4Speed           ;speed
  db    RandomBUnitLevel4Attack          ;attack
  db    RandomBUnitLevel4Defense         ;defense
  db    RandomBUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Thomas",255,"     "

Monster165Table:                        ;BlueSteel (knight with sword) (maze of gallious)
  dw    Monster165Idle
  dw    Monster165Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    32                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "BlueSteel",255,"  "

Monster166Table:                        ;HikoDrone (space manbow)
  dw    Monster166Idle
  dw    Monster166Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    16                              ;nx  
  db    40+08                           ;ny
  db    RandomBUnitLevel4CostGold        ;cost (gold)
  db    RandomBUnitLevel4CostGems        ;cost (gems)
  db    RandomBUnitLevel4CostRubies      ;cost (rubies)
  db    RandomBUnitLevel4HP              ;hp
  db    RandomBUnitLevel4Speed           ;speed
  db    RandomBUnitLevel4Attack          ;attack
  db    RandomBUnitLevel4Defense         ;defense
  db    RandomBUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Hikodrone",255,"  "

Monster167Table:                        ;Wonder Boy (Wonder Boy)
  dw    Monster167Idle
  dw    Monster167Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Wonder Boy",255," "

NinjaKunLevel2Number:           equ 52
NinjaKunLevel2Attack:           equ 4
NinjaKunLevel2Defense:          equ 7
NinjaKunLevel2HP:               equ 17
NinjaKunLevel2Speed:            equ 3
NinjaKunLevel2Growth:           equ 8
NinjaKunLevel2CostGold:         equ 120/10
NinjaKunLevel2CostGems:         equ 00+Level2Unit
NinjaKunLevel2CostRubies:       equ 0

Monster168Table:                        ;Ninja Kun (Ninja Kun)
  dw    Monster168Idle
  dw    Monster168Move
  dw    Monster168AttackPatternRight
  dw    Monster168AttackPatternLeft
  dw    Monster168AttackPatternLeft
  dw    Monster168AttackPatternLeft
  dw    Monster168AttackPatternRight
  dw    Monster168AttackPatternRight
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    NinjaKunLevel2CostGold        ;cost (gold)
  db    NinjaKunLevel2CostGems        ;cost (gems)
  db    NinjaKunLevel2CostRubies      ;cost (rubies)
  db    NinjaKunLevel2HP              ;hp
  db    NinjaKunLevel2Speed           ;speed
  db    NinjaKunLevel2Attack          ;attack;
  db    NinjaKunLevel2Defense         ;defense
  db    NinjaKunLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Ninja Kun",255,"  "

Monster169Table:                        ;Kubiwatari (jumping head statue) (hinotori)
  dw    Monster169Idle
  dw    Monster169Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Kubiwatari",255," "

Monster170Table:                        ;Flutterbane (maze of gallious)
  dw    Monster170Idle
  dw    Monster170Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet10Block
  db    32                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel5CostGold        ;cost (gold)
  db    RandomBUnitLevel5CostGems        ;cost (gems)
  db    RandomBUnitLevel5CostRubies      ;cost (rubies)
  db    RandomBUnitLevel5HP              ;hp
  db    RandomBUnitLevel5Speed           ;speed
  db    RandomBUnitLevel5Attack          ;attack
  db    RandomBUnitLevel5Defense         ;defense
  db    RandomBUnitLevel5Growth          ;growth
  db    000                             ;special ability
;  db    "Lepidoptera",255
  db    "Flutterbane",255

Monster171Table:                        ;Topple Zip (Topple Zip)
  dw    Monster171Idle
  dw    Monster171Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet8Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Topple Zip",255," "

Monster172Table:                        ;Topplane (Topple Zip)
  dw    Monster172Idle
  dw    Monster172Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet12Block
  db    16                              ;nx  
  db    24+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Topplane",255,"   "

Monster173Table:                        ;Nyancle (Nyancle racing)
  dw    Monster173Idle
  dw    Monster173Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Nyancle",255,"    "

Monster174Table:                        ;Ashguine (Ashguine 2)
  dw    Monster174Idle
  dw    Monster174Move
  dw    Monster174AttackPatternRight
  dw    Monster174AttackPatternLeft
  dw    Monster174AttackPatternLeftUp
  dw    Monster174AttackPatternLeftDown
  dw    Monster174AttackPatternRightUp
  dw    Monster174AttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    RandomBUnitLevel4CostGold        ;cost (gold)
  db    RandomBUnitLevel4CostGems        ;cost (gems)
  db    RandomBUnitLevel4CostRubies      ;cost (rubies)
  db    RandomBUnitLevel4HP              ;hp
  db    RandomBUnitLevel4Speed           ;speed
  db    RandomBUnitLevel4Attack          ;attack
  db    RandomBUnitLevel4Defense         ;defense
  db    RandomBUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Ashguine",255,"   "

Monster175Table:                        ;Hard Boiled (Hard Boiled)
  dw    Monster175Idle
  dw    Monster175Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    32                              ;nx  
  db    48+08                           ;ny
  db    RandomBUnitLevel3CostGold        ;cost (gold)
  db    RandomBUnitLevel3CostGems        ;cost (gems)
  db    RandomBUnitLevel3CostRubies      ;cost (rubies)
  db    RandomBUnitLevel3HP              ;hp
  db    RandomBUnitLevel3Speed           ;speed
  db    RandomBUnitLevel3Attack          ;attack
  db    RandomBUnitLevel3Defense         ;defense
  db    RandomBUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Hard Boiled",255

Monster176Table:                        ;Pingo (Doki Doki Penguin Land)
  dw    Monster176Idle
  dw    Monster176Move
  dw    Monster176AttackPatternRight
  dw    Monster176AttackPatternLeft
  dw    Monster176AttackPatternLeftUp
  dw    Monster176AttackPatternLeftDown
  dw    Monster176AttackPatternRightUp
  dw    Monster176AttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Pingo",255,"      "

Monster177Table:                        ;Doki Bear (Doki Doki Penguin Land)
  dw    Monster177Idle
  dw    Monster177Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Doki Bear",255,"  "

Monster178Table:                        ;InspecteurZ (Inspecteur Z)
  dw    Monster178Idle
  dw    Monster178Move
  dw    Monster178AttackPatternRight
  dw    Monster178AttackPatternLeft
  dw    Monster178AttackPatternLeftUp
  dw    Monster178AttackPatternLeftDown
  dw    Monster178AttackPatternRightUp
  dw    Monster178AttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "InspecteurZ",255
  
Monster179Table:                        ;Thug (Inspecteur Z) (dog with eye patch)
  dw    Monster179Idle
  dw    Monster179Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Thug",255,"       "

Monster180Table:                        ;Goblin (Ys 2) (green monster)
  dw    Monster180Idle
  dw    Monster180Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel1CostGold        ;cost (gold)
  db    RandomBUnitLevel1CostGems        ;cost (gems)
  db    RandomBUnitLevel1CostRubies      ;cost (rubies)
  db    RandomBUnitLevel1HP              ;hp
  db    RandomBUnitLevel1Speed           ;speed
  db    RandomBUnitLevel1Attack          ;attack
  db    RandomBUnitLevel1Defense         ;defense
  db    RandomBUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Goblin",255,"     "

Monster181Table:                        ;Emberhorn (Ys 2) (red horned monster)
  dw    Monster181Idle
  dw    Monster181Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    16                              ;nx  
  db    16+08                           ;ny
  db    RandomBUnitLevel2CostGold        ;cost (gold)
  db    RandomBUnitLevel2CostGems        ;cost (gems)
  db    RandomBUnitLevel2CostRubies      ;cost (rubies)
  db    RandomBUnitLevel2HP              ;hp
  db    RandomBUnitLevel2Speed           ;speed
  db    RandomBUnitLevel2Attack          ;attack
  db    RandomBUnitLevel2Defense         ;defense
  db    RandomBUnitLevel2Growth          ;growth
  db    000                             ;special ability
  db    "Emberhorn",255,"  "

Monster182Table:                        ;Kanton Man (chuka taisen) (bird man)
  dw    Monster182Idle
  dw    Monster182Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet16Block
  db    48                              ;nx  
  db    32+08                           ;ny
  db    ChukaTaisenUnitLevel1CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel1CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel1CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel1HP              ;hp
  db    ChukaTaisenUnitLevel1Speed           ;speed
  db    ChukaTaisenUnitLevel1Attack          ;attack
  db    ChukaTaisenUnitLevel1Defense         ;defense
  db    ChukaTaisenUnitLevel1Growth          ;growth
  db    000                             ;special ability
  db    "Kanton Man",255," "

Monster183Table:                        ;Sun Wukong (chuka taisen) (main character)
  dw    Monster183Idle
  dw    Monster183Move
  dw    Monster183AttackPatternRight
  dw    Monster183AttackPatternLeft
  dw    Monster183AttackPatternLeft
  dw    Monster183AttackPatternLeft
  dw    Monster183AttackPatternRight
  dw    Monster183AttackPatternRight
  db    BattleMonsterSpriteSheet16Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    ChukaTaisenUnitLevel2CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel2CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel2CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel2HP              ;hp
  db    ChukaTaisenUnitLevel2Speed           ;speed
  db    ChukaTaisenUnitLevel2Attack          ;attack
  db    ChukaTaisenUnitLevel2Defense         ;defense
  db    ChukaTaisenUnitLevel2Growth          ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Sun Wukong",255," "

Monster184Table:                        ;Shock Scout (chuka taisen) (boy with green hair)
  dw    Monster184Idle
  dw    Monster184Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet16Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    ChukaTaisenUnitLevel3CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel3CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel3CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel3HP              ;hp
  db    ChukaTaisenUnitLevel3Speed           ;speed
  db    ChukaTaisenUnitLevel3Attack          ;attack
  db    ChukaTaisenUnitLevel3Defense         ;defense
  db    ChukaTaisenUnitLevel3Growth          ;growth
  db    000                             ;special ability
  db    "Shock Scout",255
  
Monster185Table:                        ;Evil Hermit (chuka taisen) (old man with staff and crown)
  dw    Monster185Idle
  dw    Monster185Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet16Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    ChukaTaisenUnitLevel4CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel4CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel4CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel4HP              ;hp
  db    ChukaTaisenUnitLevel4Speed           ;speed
  db    ChukaTaisenUnitLevel4Attack          ;attack
  db    ChukaTaisenUnitLevel4Defense         ;defense
  db    ChukaTaisenUnitLevel4Growth          ;growth
  db    000                             ;special ability
  db    "Evil Hermit",255

Monster186Table:                        ;Bad Buddha (chuka taisen) (blue dress and mustache)
  dw    Monster186Idle
  dw    Monster186Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet16Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    ChukaTaisenUnitLevel5CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel5CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel5CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel5HP              ;hp
  db    ChukaTaisenUnitLevel5Speed           ;speed
  db    ChukaTaisenUnitLevel5Attack          ;attack
  db    ChukaTaisenUnitLevel5Defense         ;defense
  db    ChukaTaisenUnitLevel5Growth          ;growth
  db    000                             ;special ability
  db    "Bad Buddha",255," "

Monster187Table:                        ;Dualhorn (chuka taisen) (green demon with 2 heads)
  dw    Monster187Idle
  dw    Monster187Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet15Block
  db    32                              ;nx  
  db    40+08                           ;ny
  db    ChukaTaisenUnitLevel6CostGold        ;cost (gold)
  db    ChukaTaisenUnitLevel6CostGems        ;cost (gems)
  db    ChukaTaisenUnitLevel6CostRubies      ;cost (rubies)
  db    ChukaTaisenUnitLevel6HP              ;hp
  db    ChukaTaisenUnitLevel6Speed           ;speed
  db    ChukaTaisenUnitLevel6Attack          ;attack
  db    ChukaTaisenUnitLevel6Defense         ;defense
  db    ChukaTaisenUnitLevel6Growth          ;growth
  db    000                             ;special ability
  db    "Dualhorn",255,"   "

;######################################################################################
GeneralMonsterAttackPatternRight:
  db    000,003,ShowBeingHitSprite,007,000,InitiateAttack
GeneralMonsterAttackPatternLeft:
  db    000,007,ShowBeingHitSprite,003,000,InitiateAttack
GeneralMonsterAttackPatternLeftUp:
  db    000,008,ShowBeingHitSprite,004,000,InitiateAttack
GeneralMonsterAttackPatternLeftDown:
  db    000,006,ShowBeingHitSprite,002,000,InitiateAttack
GeneralMonsterAttackPatternRightUp:
  db    000,002,ShowBeingHitSprite,006,000,InitiateAttack
GeneralMonsterAttackPatternRightDown:
  db    000,004,ShowBeingHitSprite,008,000,InitiateAttack
;######################################################################################
;brown flyer (sd snatcher)

RIdle1Monster001:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster001:   equ $4000 + (000*128) + (016/2) - 128
RIdle3Monster001:   equ $4000 + (000*128) + (032/2) - 128
RIdle4Monster001:   equ $4000 + (000*128) + (048/2) - 128

LIdle1Monster001:   equ $4000 + (000*128) + (112/2) - 128
LIdle2Monster001:   equ $4000 + (000*128) + (096/2) - 128
LIdle3Monster001:   equ $4000 + (000*128) + (080/2) - 128
LIdle4Monster001:   equ $4000 + (000*128) + (064/2) - 128

Monster001Move:                     
Monster001Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster001
  dw    RIdle2Monster001
  dw    RIdle3Monster001
  dw    RIdle4Monster001
  dw    RIdle3Monster001
  dw    RIdle2Monster001
  ;facing left
  dw    LIdle1Monster001
  dw    LIdle2Monster001
  dw    LIdle3Monster001
  dw    LIdle4Monster001
  dw    LIdle3Monster001
  dw    LIdle2Monster001
;######################################################################################
;green flyer (sd snatcher)
RIdle1Monster002:   equ $4000 + (000*128) + (128/2) - 128
RIdle2Monster002:   equ $4000 + (000*128) + (144/2) - 128
RIdle3Monster002:   equ $4000 + (000*128) + (160/2) - 128
RIdle4Monster002:   equ $4000 + (000*128) + (176/2) - 128

LIdle1Monster002:   equ $4000 + (000*128) + (240/2) - 128
LIdle2Monster002:   equ $4000 + (000*128) + (224/2) - 128
LIdle3Monster002:   equ $4000 + (000*128) + (208/2) - 128
LIdle4Monster002:   equ $4000 + (000*128) + (192/2) - 128

Monster002Move:                     
Monster002Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster002
  dw    RIdle2Monster002
  dw    RIdle3Monster002
  dw    RIdle4Monster002
  dw    RIdle3Monster002
  dw    RIdle2Monster002
  ;facing left
  dw    LIdle1Monster002
  dw    LIdle2Monster002
  dw    LIdle3Monster002
  dw    LIdle4Monster002
  dw    LIdle3Monster002
  dw    LIdle2Monster002
;######################################################################################
;dark grey flyer (sd snatcher)
RIdle1Monster003:   equ $4000 + (032*128) + (000/2) - 128
RIdle2Monster003:   equ $4000 + (032*128) + (016/2) - 128
RIdle3Monster003:   equ $4000 + (032*128) + (032/2) - 128
RIdle4Monster003:   equ $4000 + (032*128) + (048/2) - 128

LIdle1Monster003:   equ $4000 + (032*128) + (112/2) - 128
LIdle2Monster003:   equ $4000 + (032*128) + (096/2) - 128
LIdle3Monster003:   equ $4000 + (032*128) + (080/2) - 128
LIdle4Monster003:   equ $4000 + (032*128) + (064/2) - 128

Monster003Move:                     
Monster003Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster003
  dw    RIdle2Monster003
  dw    RIdle3Monster003
  dw    RIdle4Monster003
  dw    RIdle3Monster003
  dw    RIdle2Monster003
  ;facing left
  dw    LIdle1Monster003
  dw    LIdle2Monster003
  dw    LIdle3Monster003
  dw    LIdle4Monster003
  dw    LIdle3Monster003
  dw    LIdle2Monster003
;######################################################################################
;light grey flyer (sd snatcher)
RIdle1Monster004:   equ $4000 + (032*128) + (128/2) - 128
RIdle2Monster004:   equ $4000 + (032*128) + (144/2) - 128
RIdle3Monster004:   equ $4000 + (032*128) + (160/2) - 128
RIdle4Monster004:   equ $4000 + (032*128) + (176/2) - 128

LIdle1Monster004:   equ $4000 + (032*128) + (240/2) - 128
LIdle2Monster004:   equ $4000 + (032*128) + (224/2) - 128
LIdle3Monster004:   equ $4000 + (032*128) + (208/2) - 128
LIdle4Monster004:   equ $4000 + (032*128) + (192/2) - 128

Monster004Move:                     
Monster004Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster004
  dw    RIdle2Monster004
  dw    RIdle3Monster004
  dw    RIdle4Monster004
  dw    RIdle3Monster004
  dw    RIdle2Monster004
  ;facing left
  dw    LIdle1Monster004
  dw    LIdle2Monster004
  dw    LIdle3Monster004
  dw    LIdle4Monster004
  dw    LIdle3Monster004
  dw    LIdle2Monster004
;######################################################################################
;big spider (sd snatcher)

RIdle1Monster005:   equ $4000 + (064*128) + (000/2) - 128
RIdle2Monster005:   equ $4000 + (064*128) + (016/2) - 128

LIdle1Monster005:   equ $4000 + (064*128) + (032/2) - 128
LIdle2Monster005:   equ $4000 + (064*128) + (048/2) - 128

Monster005Move:                     
Monster005Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster005
  dw    RIdle2Monster005
  ;facing left
  dw    LIdle1Monster005
  dw    LIdle2Monster005
;######################################################################################
;tiny spider (sd snatcher)

RIdle1Monster006:   equ $4000 + (068*128) + (064/2) - 128
RIdle2Monster006:   equ $4000 + (068*128) + (080/2) - 128

LIdle1Monster006:   equ $4000 + (068*128) + (096/2) - 128
LIdle2Monster006:   equ $4000 + (068*128) + (112/2) - 128

Monster006Move:                     
Monster006Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster006
  dw    RIdle2Monster006
  ;facing left
  dw    LIdle1Monster006
  dw    LIdle2Monster006
;######################################################################################
;Bobblun blue (bubble bobble)

RIdle1Monster007:   equ $4000 + (064*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster007:   equ $4000 + (064*128) + (144/2) - 128 ;(y*128) + (x/2)
Rattack1Monster007: equ $4000 + (064*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster007:   equ $4000 + (064*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle2Monster007:   equ $4000 + (064*128) + (192/2) - 128 ;(y*128) + (x/2)
Lattack1Monster007: equ $4000 + (064*128) + (176/2) - 128 ;(y*128) + (x/2)

Monster007Move:                     
Monster007Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster007
  dw    RIdle2Monster007
  ;facing left
  dw    LIdle1Monster007
  dw    LIdle2Monster007

Monster007AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster007 | db 000,ShootProjectile,000,WaitImpactProjectile
Monster007AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster007 | db 000,ShootProjectile,000,WaitImpactProjectile
;######################################################################################
;Bubblun green (bubble bobble)

RIdle1Monster008:   equ $4000 + (064*128) + (224/2) - 128 ;(y*128) + (x/2)
RIdle2Monster008:   equ $4000 + (064*128) + (240/2) - 128 ;(y*128) + (x/2)
Rattack1Monster008: equ $4000 + (088*128) + (000/2) - 128 ;(y*128) + (x/2)

LIdle1Monster008:   equ $4000 + (088*128) + (048/2) - 128 ;(y*128) + (x/2)
LIdle2Monster008:   equ $4000 + (088*128) + (032/2) - 128 ;(y*128) + (x/2)
Lattack1Monster008: equ $4000 + (088*128) + (016/2) - 128 ;(y*128) + (x/2)

Monster008Move:                     
Monster008Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster008
  dw    RIdle2Monster008
  ;facing left
  dw    LIdle1Monster008
  dw    LIdle2Monster008

Monster008AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster008 | db 000,ShootProjectile,000,WaitImpactProjectile
Monster008AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster008 | db 000,ShootProjectile,000,WaitImpactProjectile
;######################################################################################
;zen chan blue robotic (bubble bobble)

RIdle1Monster009:   equ $4000 + (088*128) + (064/2) - 128 ;(y*128) + (x/2)
RIdle2Monster009:   equ $4000 + (088*128) + (080/2) - 128 ;(y*128) + (x/2)

LIdle1Monster009:   equ $4000 + (088*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle2Monster009:   equ $4000 + (088*128) + (112/2) - 128 ;(y*128) + (x/2)

Monster009Move:                     
Monster009Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster009
  dw    RIdle2Monster009
  ;facing left
  dw    LIdle1Monster009
  dw    LIdle2Monster009
;######################################################################################
;mad zen chan red robotic (bubble bobble)

RIdle1Monster010:   equ $4000 + (088*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster010:   equ $4000 + (088*128) + (144/2) - 128 ;(y*128) + (x/2)

LIdle1Monster010:   equ $4000 + (088*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster010:   equ $4000 + (088*128) + (160/2) - 128 ;(y*128) + (x/2)

Monster010Move:                     
Monster010Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster010
  dw    RIdle2Monster010
  ;facing left
  dw    LIdle1Monster010
  dw    LIdle2Monster010
;######################################################################################
;mighta ghoul (bubble bobble)

RIdle1Monster011:   equ $4000 + (088*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster011:   equ $4000 + (088*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster011:   equ $4000 + (088*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster011:   equ $4000 + (088*128) + (240/2) - 128 ;(y*128) + (x/2)

Monster011Move:                     
Monster011Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster011
  dw    RIdle2Monster011
  ;facing left
  dw    LIdle1Monster011
  dw    LIdle2Monster011
;######################################################################################
;skell monsta ghost whale (bubble bobble)

RIdle1Monster012:   equ $4000 + (112*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster012:   equ $4000 + (112*128) + (016/2) - 128 ;(y*128) + (x/2)

LIdle1Monster012:   equ $4000 + (112*128) + (048/2) - 128 ;(y*128) + (x/2)
LIdle2Monster012:   equ $4000 + (112*128) + (032/2) - 128 ;(y*128) + (x/2)

Monster012Move:                     
Monster012Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster012
  dw    RIdle2Monster012
  ;facing left
  dw    LIdle1Monster012
  dw    LIdle2Monster012
;######################################################################################
;Banebou spring jumper (bubble bobble)

RIdle1Monster013:   equ $4000 + (112*128) + (064/2) - 128 ;(y*128) + (x/2)
RIdle2Monster013:   equ $4000 + (112*128) + (080/2) - 128 ;(y*128) + (x/2)
RIdle3Monster013:   equ $4000 + (112*128) + (096/2) - 128 ;(y*128) + (x/2)

LIdle1Monster013:   equ $4000 + (112*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster013:   equ $4000 + (112*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle3Monster013:   equ $4000 + (112*128) + (112/2) - 128 ;(y*128) + (x/2)

Monster013Move:                     
Monster013Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster013
  dw    RIdle2Monster013
  dw    RIdle3Monster013
  dw    RIdle2Monster013
  ;facing left
  dw    LIdle1Monster013
  dw    LIdle2Monster013
  dw    LIdle3Monster013
  dw    LIdle2Monster013
;######################################################################################
;Hidegons blue fuzzy (bubble bobble)

RIdle1Monster014:   equ $4000 + (112*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster014:   equ $4000 + (112*128) + (176/2) - 128 ;(y*128) + (x/2)

LIdle1Monster014:   equ $4000 + (112*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle2Monster014:   equ $4000 + (112*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster014Move:                     
Monster014Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster014
  dw    RIdle2Monster014
  ;facing left
  dw    LIdle1Monster014
  dw    LIdle2Monster014
;######################################################################################
;drunk green (bubble bobble)

RIdle1Monster015:   equ $4000 + (112*128) + (224/2) - 128 ;(y*128) + (x/2)
RIdle2Monster015:   equ $4000 + (112*128) + (240/2) - 128 ;(y*128) + (x/2)

LIdle1Monster015:   equ $4000 + (136*128) + (000/2) - 128 ;(y*128) + (x/2)
LIdle2Monster015:   equ $4000 + (136*128) + (016/2) - 128 ;(y*128) + (x/2)

Monster015Move:                     
Monster015Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster015
  dw    RIdle2Monster015
  ;facing left
  dw    LIdle1Monster015
  dw    LIdle2Monster015
;######################################################################################
;super drunk green (bubble bobble)

RIdle1Monster016:   equ $4000 + (068*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster016:   equ $4000 + (068*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster016:   equ $4000 + (068*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle2Monster016:   equ $4000 + (068*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster016Move:                     
Monster016Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster016
  dw    RIdle2Monster016
  ;facing left
  dw    LIdle1Monster016
  dw    LIdle2Monster016
;######################################################################################
;super mighta ghoul (bubble bobble)

RIdle1Monster017:   equ $4000 + (136*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle2Monster017:   equ $4000 + (136*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster017:   equ $4000 + (136*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle2Monster017:   equ $4000 + (136*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster017Move:                     
Monster017Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster017
  dw    RIdle2Monster017
  ;facing left
  dw    LIdle1Monster017
  dw    LIdle2Monster017
;######################################################################################
;Fish Man (Castlevania)
RIdle1Monster018:   equ $4000 + (136*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster018:   equ $4000 + (136*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle3Monster018:   equ $4000 + (136*128) + (224/2) - 128 ;(y*128) + (x/2)
RAttack1Monster018: equ $4000 + (176*128) + (000/2) - 128 ;(y*128) + (x/2)

LIdle1Monster018:   equ $4000 + (176*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle2Monster018:   equ $4000 + (176*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle3Monster018:   equ $4000 + (176*128) + (064/2) - 128 ;(y*128) + (x/2)
LAttack1Monster018: equ $4000 + (176*128) + (032/2) - 128 ;(y*128) + (x/2)

Monster018Move:                     
Monster018Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster018
  dw    RIdle2Monster018
  dw    RIdle3Monster018
  ;facing left
  dw    LIdle1Monster018
  dw    LIdle2Monster018
  dw    LIdle3Monster018

Monster018AttackPatternRight:
  db    000,003,000,AnimateAttack | dw Rattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster018 | db 000,007,InitiateAttack
Monster018AttackPatternRightUp:
  db    000,008,000,AnimateAttack | dw Rattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster018 | db 000,004,InitiateAttack
Monster018AttackPatternRightDown:
  db    000,006,000,AnimateAttack | dw Rattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster018 | db 000,002,InitiateAttack

Monster018AttackPatternLeft:
  db    000,007,000,AnimateAttack | dw Lattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster018 | db 000,003,InitiateAttack
Monster018AttackPatternLeftUp:
  db    000,002,000,AnimateAttack | dw Lattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster018 | db 000,006,InitiateAttack
Monster018AttackPatternLeftDown:
  db    000,004,000,AnimateAttack | dw Lattack1Monster018 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster018 | db 000,008,InitiateAttack
;######################################################################################
;Zombie (Castlevania)

RIdle1Monster019:   equ $4000 + (176*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster019:   equ $4000 + (176*128) + (176/2) - 128 ;(y*128) + (x/2)

LIdle1Monster019:   equ $4000 + (176*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle2Monster019:   equ $4000 + (176*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster019Move:                     
Monster019Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster019
  dw    RIdle2Monster019
  ;facing left
  dw    LIdle1Monster019
  dw    LIdle2Monster019
;######################################################################################
;Mummy Man (Castlevania)

RIdle1Monster020:   equ $4000 + (136*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster020:   equ $4000 + (136*128) + (016/2) - 128 ;(y*128) + (x/2)
RIdle3Monster020:   equ $4000 + (136*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster020:   equ $4000 + (136*128) + (080/2) - 128 ;(y*128) + (x/2)
LIdle2Monster020:   equ $4000 + (136*128) + (064/2) - 128 ;(y*128) + (x/2)
LIdle3Monster020:   equ $4000 + (136*128) + (048/2) - 128 ;(y*128) + (x/2)

Monster020Move:                     
Monster020Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster020
  dw    RIdle2Monster020
  dw    RIdle3Monster020
  dw    RIdle2Monster020
  ;facing left
  dw    LIdle1Monster020
  dw    LIdle2Monster020
  dw    LIdle3Monster020
  dw    LIdle2Monster020
;######################################################################################
;Spear Guard (Castlevania)

RIdle1Monster021:   equ $4000 + (176*128) + (224/2) - 128 ;(y*128) + (x/2)
RIdle2Monster021:   equ $4000 + (176*128) + (240/2) - 128 ;(y*128) + (x/2)
RIdle3Monster021:   equ $4000 + (216*128) + (000/2) - 128 ;(y*128) + (x/2)
RAttack1Monster021: equ $4000 + (216*128) + (016/2) - 128 ;(y*128) + (x/2)
RAttack2Monster021: equ $4000 + (216*128) + (048/2) - 128 ;(y*128) + (x/2)

LIdle1Monster021:   equ $4000 + (216*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster021:   equ $4000 + (216*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle3Monster021:   equ $4000 + (216*128) + (144/2) - 128 ;(y*128) + (x/2)
LAttack1Monster021: equ $4000 + (216*128) + (112/2) - 128 ;(y*128) + (x/2)
LAttack2Monster021: equ $4000 + (216*128) + (080/2) - 128 ;(y*128) + (x/2)

Monster021Move:                     
Monster021Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster021
  dw    RIdle2Monster021
  dw    RIdle3Monster021
  dw    RIdle2Monster021
  ;facing left
  dw    LIdle1Monster021
  dw    LIdle2Monster021
  dw    LIdle3Monster021
  dw    LIdle2Monster021

Monster021AttackPatternRight:
  db    000,128+32,AnimateAttack | dw Rattack1Monster021 | db 000,AnimateAttack | dw Rattack2Monster021 | db 003,ShowBeingHitSprite,AnimateAttack | dw Rattack1Monster021 | db 000,AnimateAttack | dw Rattack2Monster021 | db 007,128+16,AnimateAttack | dw RIdle1Monster021 | db 000,InitiateAttack
Monster021AttackPatternRightUp:
  db    000,128+32,AnimateAttack | dw Rattack1Monster021 | db 008,AnimateAttack | dw Rattack2Monster021 | db 000,ShowBeingHitSprite,AnimateAttack | dw Rattack1Monster021 | db 000,AnimateAttack | dw Rattack2Monster021 | db 000,128+16,AnimateAttack | dw RIdle1Monster021 | db 004,InitiateAttack
Monster021AttackPatternRightDown:
  db    000,128+32,AnimateAttack | dw Rattack1Monster021 | db 006,AnimateAttack | dw Rattack2Monster021 | db 000,ShowBeingHitSprite,AnimateAttack | dw Rattack1Monster021 | db 000,AnimateAttack | dw Rattack2Monster021 | db 000,128+16,AnimateAttack | dw RIdle1Monster021 | db 002,InitiateAttack

Monster021AttackPatternLeft:
  db    000,128+32,AnimateAttack | dw Lattack1Monster021 | db DisplaceLeft,000,AnimateAttack | dw Lattack2Monster021 | db 007,ShowBeingHitSprite,AnimateAttack | dw Lattack1Monster021 | db 000,AnimateAttack | dw Lattack2Monster021 | db 003,128+16,AnimateAttack | dw LIdle1Monster021 | db DisplaceRight,000,InitiateAttack
Monster021AttackPatternLeftUp:
  db    000,128+32,AnimateAttack | dw Lattack1Monster021 | db DisplaceLeft,002,AnimateAttack | dw Lattack2Monster021 | db 000,ShowBeingHitSprite,AnimateAttack | dw Lattack1Monster021 | db 000,AnimateAttack | dw Lattack2Monster021 | db 000,128+16,AnimateAttack | dw LIdle1Monster021 | db DisplaceRight,006,InitiateAttack
Monster021AttackPatternLeftDown:
  db    000,128+32,AnimateAttack | dw Lattack1Monster021 | db DisplaceLeft,004,AnimateAttack | dw Lattack2Monster021 | db 000,ShowBeingHitSprite,AnimateAttack | dw Lattack1Monster021 | db 000,AnimateAttack | dw Lattack2Monster021 | db 000,128+16,AnimateAttack | dw LIdle1Monster021 | db DisplaceRight,008,InitiateAttack
;######################################################################################
;Medusa Head (Castlevania)

RIdle1Monster022:   equ $4000 + (024*128) + (240/2) - 128 ;(y*128) + (x/2)
RIdle2Monster022:   equ $4000 + (080*128) + (048/2) - 128 ;(y*128) + (x/2)

LIdle1Monster022:   equ $4000 + (080*128) + (080/2) - 128 ;(y*128) + (x/2)
LIdle2Monster022:   equ $4000 + (080*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster022Move:                     
Monster022Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster022
  dw    RIdle2Monster022
  ;facing left
  dw    LIdle1Monster022
  dw    LIdle2Monster022
;######################################################################################
;Flea Man (Castlevania)

RIdle1Monster023:   equ $4000 + (000*128) + (240/2) - 128 ;(y*128) + (x/2)
RIdle2Monster023:   equ $4000 + (056*128) + (048/2) - 128 ;(y*128) + (x/2)
RAttack1Monster023: equ $4000 + (056*128) + (064/2) - 128 ;(y*128) + (x/2)
RAttack2Monster023: equ $4000 + (056*128) + (080/2) - 128 ;(y*128) + (x/2)
RAttack3Monster023: equ $4000 + (056*128) + (096/2) - 128 ;(y*128) + (x/2)

LIdle1Monster023:   equ $4000 + (056*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster023:   equ $4000 + (056*128) + (160/2) - 128 ;(y*128) + (x/2)
LAttack1Monster023: equ $4000 + (056*128) + (144/2) - 128 ;(y*128) + (x/2)
LAttack2Monster023: equ $4000 + (056*128) + (128/2) - 128 ;(y*128) + (x/2)
LAttack3Monster023: equ $4000 + (056*128) + (112/2) - 128 ;(y*128) + (x/2)

Monster023Move:                     
Monster023Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster023
  dw    RIdle2Monster023
  ;facing left
  dw    LIdle1Monster023
  dw    LIdle2Monster023

Monster023AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster023 | db 000,000,AnimateAttack | dw Rattack2Monster023 | db 000,003,ShowBeingHitSprite,AnimateAttack | dw Rattack3Monster023 | db 000,007,AnimateAttack | dw Rattack1Monster023 | db 000,000,InitiateAttack
Monster023AttackPatternRightUp:
  db    000,AnimateAttack | dw Rattack1Monster023 | db 000,000,AnimateAttack | dw Rattack2Monster023 | db 000,002,ShowBeingHitSprite,AnimateAttack | dw Rattack3Monster023 | db 000,006,AnimateAttack | dw Rattack1Monster023 | db 000,000,InitiateAttack
Monster023AttackPatternRightDown:
  db    000,AnimateAttack | dw Rattack1Monster023 | db 000,000,AnimateAttack | dw Rattack2Monster023 | db 000,004,ShowBeingHitSprite,AnimateAttack | dw Rattack3Monster023 | db 000,008,AnimateAttack | dw Rattack1Monster023 | db 000,000,InitiateAttack
Monster023AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster023 | db 000,000,AnimateAttack | dw Lattack2Monster023 | db 000,007,ShowBeingHitSprite,AnimateAttack | dw Lattack3Monster023 | db 000,003,AnimateAttack | dw Lattack1Monster023 | db 000,000,InitiateAttack
Monster023AttackPatternLeftUp:
  db    000,AnimateAttack | dw Lattack1Monster023 | db 000,000,AnimateAttack | dw Lattack2Monster023 | db 000,008,ShowBeingHitSprite,AnimateAttack | dw Lattack3Monster023 | db 000,004,AnimateAttack | dw Lattack1Monster023 | db 000,000,InitiateAttack
Monster023AttackPatternLeftDown:
  db    000,AnimateAttack | dw Lattack1Monster023 | db 000,000,AnimateAttack | dw Lattack2Monster023 | db 000,006,ShowBeingHitSprite,AnimateAttack | dw Lattack3Monster023 | db 000,002,AnimateAttack | dw Lattack1Monster023 | db 000,000,InitiateAttack
;######################################################################################
;Grim Reaper (Castlevania)

RIdle1Monster024:   equ $4000 + (000*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster024:   equ $4000 + (000*128) + (048/2) - 128 ;(y*128) + (x/2)
RIdle3Monster024:   equ $4000 + (000*128) + (096/2) - 128 ;(y*128) + (x/2)

LIdle1Monster024:   equ $4000 + (056*128) + (000/2) - 128 ;(y*128) + (x/2)
LIdle2Monster024:   equ $4000 + (000*128) + (192/2) - 128 ;(y*128) + (x/2)
LIdle3Monster024:   equ $4000 + (000*128) + (144/2) - 128 ;(y*128) + (x/2)

Monster024Move:                     
Monster024Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster024
  dw    RIdle2Monster024
  dw    RIdle3Monster024
  dw    RIdle2Monster024
  ;facing left
  dw    LIdle1Monster024
  dw    LIdle2Monster024
  dw    LIdle3Monster024
  dw    LIdle2Monster024
;######################################################################################
;Skeleton (Castlevania)

RIdle1Monster025:   equ $4000 + (112*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster025:   equ $4000 + (112*128) + (016/2) - 128 ;(y*128) + (x/2)
RAttack1Monster025: equ $4000 + (112*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster025:   equ $4000 + (112*128) + (080/2) - 128 ;(y*128) + (x/2)
LIdle2Monster025:   equ $4000 + (112*128) + (064/2) - 128 ;(y*128) + (x/2)
LAttack1Monster025: equ $4000 + (112*128) + (048/2) - 128 ;(y*128) + (x/2)

Monster025Move:                     
Monster025Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster025
  dw    RIdle2Monster025
  ;facing left
  dw    LIdle1Monster025
  dw    LIdle2Monster025



Monster025AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster025 | db 000,000,000,003,ShowBeingHitSprite,000,007,000,000,InitiateAttack
Monster025AttackPatternRightUp:
  db    000,AnimateAttack | dw Rattack1Monster025 | db 000,000,000,002,ShowBeingHitSprite,000,006,000,000,InitiateAttack
Monster025AttackPatternRightDown:
  db    000,AnimateAttack | dw Rattack1Monster025 | db 000,000,000,004,ShowBeingHitSprite,000,008,000,000,InitiateAttack
Monster025AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster025 | db 000,000,000,007,ShowBeingHitSprite,000,003,000,000,InitiateAttack
Monster025AttackPatternLeftUp:
  db    000,AnimateAttack | dw Lattack1Monster025 | db 000,000,000,008,ShowBeingHitSprite,000,004,000,000,InitiateAttack
Monster025AttackPatternLeftDown:
  db    000,AnimateAttack | dw Lattack1Monster025 | db 000,000,000,006,ShowBeingHitSprite,000,002,000,000,InitiateAttack




;######################################################################################
;Axe man (Castlevania)

RIdle1Monster026:   equ $4000 + (184*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster026:   equ $4000 + (184*128) + (016/2) - 128 ;(y*128) + (x/2)
RAttack1Monster026: equ $4000 + (184*128) + (032/2) - 128 ;(y*128) + (x/2)
RAttack2Monster026: equ $4000 + (184*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster026:   equ $4000 + (184*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster026:   equ $4000 + (184*128) + (160/2) - 128 ;(y*128) + (x/2)
LAttack1Monster026: equ $4000 + (184*128) + (128/2) - 128 ;(y*128) + (x/2)
LAttack2Monster026: equ $4000 + (184*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster026Move:                     
Monster026Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster026
  dw    RIdle2Monster026
  ;facing left
  dw    LIdle1Monster026
  dw    LIdle2Monster026
Monster026AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster026 | db 128+32,000,000,AnimateAttack | dw Rattack2Monster026 | db ShootProjectile,000,000,000,AnimateAttack | dw RIdle1Monster026 | db 128+16,WaitImpactProjectile
Monster026AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster026 | db 128+32,DisplaceLeft,000,000,AnimateAttack | dw Lattack2Monster026 | db ShootProjectile,000,000,000,AnimateAttack | dw LIdle1Monster026 | db 128+16,DisplaceRight,WaitImpactProjectile  
;######################################################################################
;Scorpii (Dragon Slayer IV)

RIdle1Monster027:   equ $4000 + (056*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster027:   equ $4000 + (056*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster027:   equ $4000 + (056*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster027:   equ $4000 + (056*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster027Move:                     
Monster027Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster027
  dw    RIdle2Monster027
  ;facing left
  dw    LIdle1Monster027
  dw    LIdle2Monster027
;######################################################################################
;Porgi (Dragon Slayer IV)

RIdle1Monster028:   equ $4000 + (080*128) + (096/2) - 128 ;(y*128) + (x/2)
RIdle2Monster028:   equ $4000 + (080*128) + (112/2) - 128 ;(y*128) + (x/2)

LIdle1Monster028:   equ $4000 + (080*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster028:   equ $4000 + (080*128) + (128/2) - 128 ;(y*128) + (x/2)

Monster028Move:                     
Monster028Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster028
  dw    RIdle2Monster028
  ;facing left
  dw    LIdle1Monster028
  dw    LIdle2Monster028
;######################################################################################
;Rock man (Dragon Slayer IV)

RIdle1Monster029:   equ $4000 + (080*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster029:   equ $4000 + (080*128) + (176/2) - 128 ;(y*128) + (x/2)

LIdle1Monster029:   equ $4000 + (080*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle2Monster029:   equ $4000 + (080*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster029Move:                     
Monster029Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster029
  dw    RIdle2Monster029
  ;facing left
  dw    LIdle1Monster029
  dw    LIdle2Monster029
;######################################################################################
;Piglet (Dragon Slayer IV)

RIdle1Monster030:   equ $4000 + (080*128) + (224/2) - 128 ;(y*128) + (x/2)
RIdle2Monster030:   equ $4000 + (080*128) + (240/2) - 128 ;(y*128) + (x/2)

LIdle1Monster030:   equ $4000 + (104*128) + (112/2) - 128 ;(y*128) + (x/2)
LIdle2Monster030:   equ $4000 + (104*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster030Move:                     
Monster030Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster030
  dw    RIdle2Monster030
  ;facing left
  dw    LIdle1Monster030
  dw    LIdle2Monster030
;######################################################################################
;Gers (Dragon Slayer IV)

RIdle1Monster031:   equ $4000 + (104*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster031:   equ $4000 + (104*128) + (144/2) - 128 ;(y*128) + (x/2)

LIdle1Monster031:   equ $4000 + (104*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster031:   equ $4000 + (104*128) + (160/2) - 128 ;(y*128) + (x/2)

Monster031Move:                     
Monster031Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster031
  dw    RIdle2Monster031
  ;facing left
  dw    LIdle1Monster031
  dw    LIdle2Monster031
;######################################################################################
;Yashinotkin (Dragon Slayer IV)

RIdle1Monster032:   equ $4000 + (104*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster032:   equ $4000 + (104*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster032:   equ $4000 + (104*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster032:   equ $4000 + (104*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster032Move:                     
Monster032Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster032
  dw    RIdle2Monster032
  ;facing left
  dw    LIdle1Monster032
  dw    LIdle2Monster032
;######################################################################################
;King Mu (Dragon Slayer IV)

RIdle1Monster033:   equ $4000 + (128*128) + (096/2) - 128 ;(y*128) + (x/2)
RIdle2Monster033:   equ $4000 + (128*128) + (112/2) - 128 ;(y*128) + (x/2)

LIdle1Monster033:   equ $4000 + (128*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster033:   equ $4000 + (128*128) + (128/2) - 128 ;(y*128) + (x/2)

Monster033Move:                     
Monster033Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster033
  dw    RIdle2Monster033
  ;facing left
  dw    LIdle1Monster033
  dw    LIdle2Monster033
;######################################################################################
;Crawler (Dragon Slayer IV)

RIdle1Monster034:   equ $4000 + (128*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster034:   equ $4000 + (128*128) + (176/2) - 128 ;(y*128) + (x/2)

LIdle1Monster034:   equ $4000 + (128*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle2Monster034:   equ $4000 + (128*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster034Move:                     
Monster034Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster034
  dw    RIdle2Monster034
  ;facing left
  dw    LIdle1Monster034
  dw    LIdle2Monster034
;######################################################################################
;Octo (Dragon Slayer IV)

RIdle1Monster035:   equ $4000 + (128*128) + (224/2) - 128 ;(y*128) + (x/2)
RIdle2Monster035:   equ $4000 + (128*128) + (240/2) - 128 ;(y*128) + (x/2)

LIdle1Monster035:   equ $4000 + (152*128) + (000/2) - 128 ;(y*128) + (x/2)
LIdle2Monster035:   equ $4000 + (152*128) + (016/2) - 128 ;(y*128) + (x/2)

Monster035Move:                     
Monster035Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster035
  dw    RIdle2Monster035
  ;facing left
  dw    LIdle1Monster035
  dw    LIdle2Monster035
Monster035AttackPatternLeft:
Monster035AttackPatternRight:
  db    ShootProjectile,WaitImpactProjectile
;######################################################################################
;Sarge green (Contra)

RIdle1Monster036:   equ $4000 + (216*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster036:   equ $4000 + (216*128) + (016/2) - 128 ;(y*128) + (x/2)
RIdle3Monster036:   equ $4000 + (216*128) + (032/2) - 128 ;(y*128) + (x/2)
RAttack1Monster036: equ $4000 + (216*128) + (048/2) - 128 ;(y*128) + (x/2)

LIdle1Monster036:   equ $4000 + (216*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster036:   equ $4000 + (216*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle3Monster036:   equ $4000 + (216*128) + (112/2) - 128 ;(y*128) + (x/2)
LAttack1Monster036: equ $4000 + (216*128) + (080/2) - 128 ;(y*128) + (x/2)

Monster036Move:                     
Monster036Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster036
  dw    RIdle2Monster036
  dw    RIdle3Monster036
  dw    RIdle2Monster036
  ;facing left
  dw    LIdle1Monster036
  dw    LIdle2Monster036
  dw    LIdle3Monster036
  dw    LIdle2Monster036
Monster036AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster036 | db 128+32,000,ShootProjectile,000,000,000,000,AnimateAttack | dw RIdle1Monster036 | db 128+16,WaitImpactProjectile
Monster036AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster036 | db 128+32,DisplaceLeft,000,ShootProjectile,000,000,000,000,AnimateAttack | dw LIdle1Monster036 | db DisplaceRight,128+16,WaitImpactProjectile
;######################################################################################
;Lieutenant red (Contra)

RIdle1Monster037:   equ $4000 + (000*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster037:   equ $4000 + (000*128) + (016/2) - 128 ;(y*128) + (x/2)
RIdle3Monster037:   equ $4000 + (000*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle4Monster037:   equ $4000 + (000*128) + (048/2) - 128 ;(y*128) + (x/2)
RAttack1Monster037: equ $4000 + (000*128) + (064/2) - 128 ;(y*128) + (x/2)
RAttack2Monster037: equ $4000 + (000*128) + (096/2) - 128 ;(y*128) + (x/2)

LIdle1Monster037:   equ $4000 + (000*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster037:   equ $4000 + (000*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle3Monster037:   equ $4000 + (000*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle4Monster037:   equ $4000 + (000*128) + (192/2) - 128 ;(y*128) + (x/2)
LAttack1Monster037: equ $4000 + (000*128) + (160/2) - 128 ;(y*128) + (x/2)
LAttack2Monster037: equ $4000 + (000*128) + (128/2) - 128 ;(y*128) + (x/2)

Monster037Move:                     
Monster037Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster037
  dw    RIdle2Monster037
  dw    RIdle3Monster037
  dw    RIdle4Monster037
  ;facing left
  dw    LIdle1Monster037
  dw    LIdle2Monster037
  dw    LIdle3Monster037
  dw    LIdle4Monster037
Monster037AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster037 | db 128+32,000,000,000,AnimateAttack | dw Rattack2Monster037 | db 000,ShootProjectile,000,000,000,AnimateAttack | dw RIdle1Monster037 | db 128+16,WaitImpactProjectile
Monster037AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster037 | db 128+32,DisplaceLeft,000,000,000,AnimateAttack | dw Lattack2Monster037 | db 000,ShootProjectile,000,000,000,AnimateAttack | dw LIdle1Monster037 | db DisplaceRight,128+16,WaitImpactProjectile
;######################################################################################
;FootSoldier (Contra)

RIdle1Monster038:   equ $4000 + (216*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster038:   equ $4000 + (216*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster038:   equ $4000 + (216*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster038:   equ $4000 + (216*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster038Move:                     
Monster038Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster038
  dw    RIdle2Monster038
  ;facing left
  dw    LIdle1Monster038
  dw    LIdle2Monster038
;######################################################################################
;Grenadier (Contra)

RIdle1Monster039:   equ $4000 + (040*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster039:   equ $4000 + (040*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle3Monster039:   equ $4000 + (040*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster039:   equ $4000 + (040*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle2Monster039:   equ $4000 + (040*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle3Monster039:   equ $4000 + (040*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster039Move:                     
Monster039Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    5                               ;amount of animation frames
  dw    RIdle1Monster039
  dw    RIdle2Monster039
  dw    RIdle2Monster039
  dw    RIdle3Monster039
  dw    RIdle3Monster039
  ;facing left
  dw    LIdle1Monster039
  dw    LIdle2Monster039
  dw    LIdle2Monster039
  dw    LIdle3Monster039
  dw    LIdle3Monster039
Monster039AttackPatternRight:
  db    000,AnimateAttack | dw RIdle1Monster039 | db ShootProjectile,WaitImpactProjectile
Monster039AttackPatternLeft:
  db    000,AnimateAttack | dw LIdle1Monster039 | db ShootProjectile,WaitImpactProjectile
;######################################################################################
;Sniper (Contra)

RIdle1Monster040:   equ $4000 + (080*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster040:   equ $4000 + (080*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle3Monster040:   equ $4000 + (080*128) + (064/2) - 128 ;(y*128) + (x/2)
RAttack1Monster040: equ $4000 + (080*128) + (096/2) - 128 ;(y*128) + (x/2)

LIdle1Monster040:   equ $4000 + (080*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster040:   equ $4000 + (080*128) + (192/2) - 128 ;(y*128) + (x/2)
LIdle3Monster040:   equ $4000 + (080*128) + (160/2) - 128 ;(y*128) + (x/2)
LAttack1Monster040: equ $4000 + (080*128) + (128/2) - 128 ;(y*128) + (x/2)

Monster040Move:                     
Monster040Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster040
  dw    RIdle2Monster040
  dw    RIdle3Monster040
  ;facing left
  dw    LIdle1Monster040
  dw    LIdle2Monster040
  dw    LIdle3Monster040
Monster040AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster040 | db 000,ShootProjectile,000,000,000,000,AnimateAttack | dw RIdle1Monster040 | db WaitImpactProjectile
Monster040AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster040 | db 000,ShootProjectile,000,000,000,000,AnimateAttack | dw LIdle1Monster040 | db WaitImpactProjectile
;######################################################################################
;Gigafly (Contra)

RIdle1Monster041:   equ $4000 + (224*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster041:   equ $4000 + (224*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster041:   equ $4000 + (224*128) + (192/2) - 128 ;(y*128) + (x/2)
LIdle2Monster041:   equ $4000 + (224*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster041Move:                     
Monster041Idle:
  db    1                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster041
  dw    RIdle2Monster041
  ;facing left
  dw    LIdle1Monster041
  dw    LIdle2Monster041
;######################################################################################
;Alien Grunt (Contra)

RIdle1Monster042:   equ $4000 + (120*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster042:   equ $4000 + (120*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster042:   equ $4000 + (120*128) + (064/2) - 128 ;(y*128) + (x/2)
LIdle2Monster042:   equ $4000 + (120*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster042Move:                     
Monster042Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster042
  dw    RIdle2Monster042
  ;facing left
  dw    LIdle1Monster042
  dw    LIdle2Monster042
;######################################################################################
;Infiltrant (Contra)

RIdle1Monster043:   equ $4000 + (216*128) + (160/2) - 128 ;(y*128) + (x/2)
RIdle2Monster043:   equ $4000 + (216*128) + (176/2) - 128 ;(y*128) + (x/2)
RIdle3Monster043:   equ $4000 + (216*128) + (192/2) - 128 ;(y*128) + (x/2)
RAttack1Monster043: equ $4000 + (176*128) + (192/2) - 128 ;(y*128) + (x/2)

LIdle1Monster043:   equ $4000 + (216*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster043:   equ $4000 + (216*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle3Monster043:   equ $4000 + (216*128) + (208/2) - 128 ;(y*128) + (x/2)
LAttack1Monster043: equ $4000 + (176*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster043Move:                     
Monster043Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster043
  dw    RIdle2Monster043
  dw    RIdle3Monster043
  ;facing left
  dw    LIdle1Monster043
  dw    LIdle2Monster043
  dw    LIdle3Monster043
Monster043AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster043 | db 128+32,000,ShootProjectile,000,000,000,000,AnimateAttack | dw RIdle1Monster043 | db 128+16,WaitImpactProjectile
Monster043AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster043 | db 128+32,DisplaceLeft,000,ShootProjectile,000,000,000,000,AnimateAttack | dw LIdle1Monster043 | db DisplaceRight,128+16,WaitImpactProjectile
;######################################################################################
;Red Soldier (Contra)

RIdle1Monster044:   equ $4000 + (120*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster044:   equ $4000 + (120*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster044:   equ $4000 + (120*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster044:   equ $4000 + (120*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster044Move:                     
Monster044Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster044
  dw    RIdle2Monster044
  ;facing left
  dw    LIdle1Monster044
  dw    LIdle2Monster044
;######################################################################################
;Face Hugger (Contra)

RIdle1Monster045:   equ $4000 + (224*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster045:   equ $4000 + (224*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster045:   equ $4000 + (224*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle2Monster045:   equ $4000 + (224*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster045Move:                     
Monster045Idle:
  db    9                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster045
  dw    RIdle2Monster045
  ;facing left
  dw    LIdle1Monster045
  dw    LIdle2Monster045
;######################################################################################
;Gorudea (Contra)

RIdle1Monster046:   equ $4000 + (160*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster046:   equ $4000 + (160*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster046:   equ $4000 + (160*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle2Monster046:   equ $4000 + (160*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster046Move:                     
Monster046Idle:
  db    9                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster046
  dw    RIdle2Monster046
  ;facing left
  dw    LIdle1Monster046
  dw    LIdle2Monster046
;######################################################################################
;Turret (Contra)

RIdle1Monster047:   equ $4000 + (176*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster047:   equ $4000 + (176*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle3Monster047:   equ $4000 + (176*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster047:   equ $4000 + (176*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle2Monster047:   equ $4000 + (176*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle3Monster047:   equ $4000 + (176*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster047Move:                     
Monster047Idle:
  db    13                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster047
  dw    RIdle2Monster047
  dw    RIdle1Monster047
  dw    RIdle3Monster047
  ;facing left
  dw    LIdle1Monster047
  dw    LIdle2Monster047
  dw    LIdle1Monster047
  dw    LIdle3Monster047
Monster047AttackPatternRight:
  db    000,AnimateAttack | dw RIdle1Monster047 | db 000,ShootProjectile,WaitImpactProjectile
Monster047AttackPatternLeft:
  db    000,AnimateAttack | dw LIdle1Monster047 | db 000,ShootProjectile,WaitImpactProjectile
;######################################################################################
;GraveWing (Usas)

RIdle1Monster048:   equ $4000 + (136*128) + (096/2) - 128 ;(y*128) + (x/2)
RIdle2Monster048:   equ $4000 + (136*128) + (112/2) - 128 ;(y*128) + (x/2)
RIdle3Monster048:   equ $4000 + (136*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle4Monster048:   equ $4000 + (136*128) + (144/2) - 128 ;(y*128) + (x/2)
RIdle5Monster048:   equ $4000 + (136*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster048:   equ $4000 + (136*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster048:   equ $4000 + (136*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle3Monster048:   equ $4000 + (136*128) + (208/2) - 128 ;(y*128) + (x/2)
LIdle4Monster048:   equ $4000 + (136*128) + (192/2) - 128 ;(y*128) + (x/2)
LIdle5Monster048:   equ $4000 + (136*128) + (176/2) - 128 ;(y*128) + (x/2)

Monster048Move:                     
Monster048Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    8                               ;amount of animation frames
  dw    RIdle1Monster048
  dw    RIdle2Monster048
  dw    RIdle3Monster048
  dw    RIdle4Monster048
  dw    RIdle5Monster048
  dw    RIdle4Monster048
  dw    RIdle3Monster048
  dw    RIdle2Monster048
  ;facing left
  dw    LIdle1Monster048
  dw    LIdle2Monster048
  dw    LIdle3Monster048
  dw    LIdle4Monster048
  dw    LIdle5Monster048
  dw    LIdle4Monster048
  dw    LIdle3Monster048
  dw    LIdle2Monster048
;######################################################################################
;Vanguard (Usas)

RIdle1Monster049:   equ $4000 + (224*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster049:   equ $4000 + (224*128) + (016/2) - 128 ;(y*128) + (x/2)
RAttack1Monster049: equ $4000 + (224*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster049:   equ $4000 + (224*128) + (080/2) - 128 ;(y*128) + (x/2)
LIdle2Monster049:   equ $4000 + (224*128) + (064/2) - 128 ;(y*128) + (x/2)
LAttack1Monster049: equ $4000 + (224*128) + (048/2) - 128 ;(y*128) + (x/2)

Monster049Move:                     
Monster049Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster049
  dw    RIdle2Monster049
  ;facing left
  dw    LIdle1Monster049
  dw    LIdle2Monster049
Monster049AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster049 | db 000,ShootProjectile,WaitImpactProjectile
Monster049AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster049 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Aerial Luna (Usas)

RIdle1Monster050:   equ $4000 + (184*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster050:   equ $4000 + (184*128) + (144/2) - 128 ;(y*128) + (x/2)

LIdle1Monster050:   equ $4000 + (184*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster050:   equ $4000 + (184*128) + (160/2) - 128 ;(y*128) + (x/2)

Monster050Move:                     
Monster050Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster050
  dw    RIdle2Monster050
  ;facing left
  dw    LIdle1Monster050
  dw    LIdle2Monster050
;######################################################################################
;Mini Phanto (Usas)

RIdle1Monster051:   equ $4000 + (160*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster051:   equ $4000 + (160*128) + (144/2) - 128 ;(y*128) + (x/2)

LIdle1Monster051:   equ $4000 + (160*128) + (176/2) - 128 ;(y*128) + (x/2)
LIdle2Monster051:   equ $4000 + (160*128) + (160/2) - 128 ;(y*128) + (x/2)

Monster051Move:                     
Monster051Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster051
  dw    RIdle2Monster051
  ;facing left
  dw    LIdle1Monster051
  dw    LIdle2Monster051
;######################################################################################
;Thicket Tot (Usas)

RIdle1Monster052:   equ $4000 + (160*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster052:   equ $4000 + (160*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster052:   equ $4000 + (160*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster052:   equ $4000 + (160*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster052Move:                     
Monster052Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster052
  dw    RIdle2Monster052
  ;facing left
  dw    LIdle1Monster052
  dw    LIdle2Monster052
;######################################################################################
;Bonefin (Usas)

RIdle1Monster053:   equ $4000 + (152*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle2Monster053:   equ $4000 + (152*128) + (048/2) - 128 ;(y*128) + (x/2)

LIdle1Monster053:   equ $4000 + (152*128) + (080/2) - 128 ;(y*128) + (x/2)
LIdle2Monster053:   equ $4000 + (152*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster053Move:                     
Monster053Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster053
  dw    RIdle2Monster053
  ;facing left
  dw    LIdle1Monster053
  dw    LIdle2Monster053
;######################################################################################
;Zomblet (Usas)

RIdle1Monster054:   equ $4000 + (184*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster054:   equ $4000 + (184*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster054:   equ $4000 + (184*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster054:   equ $4000 + (184*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster054Move:                     
Monster054Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster054
  dw    RIdle2Monster054
  ;facing left
  dw    LIdle1Monster054
  dw    LIdle2Monster054
;######################################################################################
;Cheek (Goemon)

RIdle1Monster055:   equ $4000 + (000*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster055:   equ $4000 + (000*128) + (032/2) - 128 ;(y*128) + (x/2)
RAttack1Monster055: equ $4000 + (000*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster055:   equ $4000 + (000*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle2Monster055:   equ $4000 + (000*128) + (128/2) - 128 ;(y*128) + (x/2)
LAttack1Monster055: equ $4000 + (000*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster055Move:                     
Monster055Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster055
  dw    RIdle2Monster055
  ;facing left
  dw    LIdle1Monster055
  dw    LIdle2Monster055
Monster055AttackPatternRight:
  db    000,AnimateAttack | dw RAttack1Monster055 | db 003,000,ShowBeingHitSprite,007,000,InitiateAttack
Monster055AttackPatternLeft:
  db    000,AnimateAttack | dw LAttack1Monster055 | db 007,000,ShowBeingHitSprite,003,000,InitiateAttack
Monster055AttackPatternLeftUp:
  db    000,AnimateAttack | dw LAttack1Monster055 | db 008,000,ShowBeingHitSprite,004,000,InitiateAttack
Monster055AttackPatternLeftDown:
  db    000,AnimateAttack | dw LAttack1Monster055 | db 006,000,ShowBeingHitSprite,002,000,InitiateAttack
Monster055AttackPatternRightUp:
  db    000,AnimateAttack | dw RAttack1Monster055 | db 002,000,ShowBeingHitSprite,006,000,InitiateAttack
Monster055AttackPatternRightDown:
  db    000,AnimateAttack | dw RAttack1Monster055 | db 004,000,ShowBeingHitSprite,008,000,InitiateAttack
;######################################################################################
;Official (Goemon)

RIdle1Monster056:   equ $4000 + (000*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster056:   equ $4000 + (000*128) + (224/2) - 128 ;(y*128) + (x/2)

LIdle1Monster056:   equ $4000 + (040*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster056:   equ $4000 + (040*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster056Move:                     
Monster056Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster056
  dw    RIdle2Monster056
  ;facing left
  dw    LIdle1Monster056
  dw    LIdle2Monster056
;######################################################################################
;Kasa-obake (Goemon)

RIdle1Monster057:   equ $4000 + (040*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster057:   equ $4000 + (040*128) + (032/2) - 128 ;(y*128) + (x/2)
RIdle3Monster057:   equ $4000 + (040*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster057:   equ $4000 + (040*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle2Monster057:   equ $4000 + (040*128) + (128/2) - 128 ;(y*128) + (x/2)
LIdle3Monster057:   equ $4000 + (040*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster057Move:                     
Monster057Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster057
  dw    RIdle2Monster057
  dw    RIdle3Monster057
  dw    RIdle2Monster057
  ;facing left
  dw    LIdle1Monster057
  dw    LIdle2Monster057
  dw    LIdle3Monster057
  dw    LIdle2Monster057
;######################################################################################
;Fishmonger (Goemon)

RIdle1Monster058:   equ $4000 + (080*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster058:   equ $4000 + (080*128) + (032/2) - 128 ;(y*128) + (x/2)
RAttack1Monster058: equ $4000 + (080*128) + (064/2) - 128 ;(y*128) + (x/2)

LIdle1Monster058:   equ $4000 + (080*128) + (160/2) - 128 ;(y*128) + (x/2)
LIdle2Monster058:   equ $4000 + (080*128) + (128/2) - 128 ;(y*128) + (x/2)
LAttack1Monster058: equ $4000 + (080*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster058Move:                     
Monster058Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster058
  dw    RIdle2Monster058
  ;facing left
  dw    LIdle1Monster058
  dw    LIdle2Monster058
Monster058AttackPatternRight:
  db    000,AnimateAttack | dw RAttack1Monster058 | db 003,000,ShowBeingHitSprite,007,000,InitiateAttack
Monster058AttackPatternLeft:
  db    000,AnimateAttack | dw LAttack1Monster058 | db 007,000,ShowBeingHitSprite,003,000,InitiateAttack
Monster058AttackPatternLeftUp:
  db    000,AnimateAttack | dw LAttack1Monster058 | db 008,000,ShowBeingHitSprite,004,000,InitiateAttack
Monster058AttackPatternLeftDown:
  db    000,AnimateAttack | dw LAttack1Monster058 | db 006,000,ShowBeingHitSprite,002,000,InitiateAttack
Monster058AttackPatternRightUp:
  db    000,AnimateAttack | dw RAttack1Monster058 | db 002,000,ShowBeingHitSprite,006,000,InitiateAttack
Monster058AttackPatternRightDown:
  db    000,AnimateAttack | dw RAttack1Monster058 | db 004,000,ShowBeingHitSprite,008,000,InitiateAttack
;######################################################################################
;Ronin (Goemon)

RIdle1Monster059:   equ $4000 + (120*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster059:   equ $4000 + (120*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster059:   equ $4000 + (120*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle2Monster059:   equ $4000 + (120*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster059Move:                     
Monster059Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster059
  dw    RIdle2Monster059
  ;facing left
  dw    LIdle1Monster059
  dw    LIdle2Monster059
;######################################################################################
;Bucket Head (Goemon)

RIdle1Monster060:   equ $4000 + (120*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster060:   equ $4000 + (120*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster060:   equ $4000 + (120*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster060:   equ $4000 + (120*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster060Move:                     
Monster060Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster060
  dw    RIdle2Monster060
  ;facing left
  dw    LIdle1Monster060
  dw    LIdle2Monster060
;######################################################################################
;Headmaster (Goemon)

RIdle1Monster061:   equ $4000 + (160*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster061:   equ $4000 + (160*128) + (048/2) - 128 ;(y*128) + (x/2)

LIdle1Monster061:   equ $4000 + (160*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster061:   equ $4000 + (160*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster061Move:                     
Monster061Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster061
  dw    RIdle2Monster061
  ;facing left
  dw    LIdle1Monster061
  dw    LIdle2Monster061
;######################################################################################
;Granola (Goemon)

RIdle1Monster062:   equ $4000 + (200*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster062:   equ $4000 + (200*128) + (032/2) - 128 ;(y*128) + (x/2)
RMove1Monster062:   equ $4000 + (200*128) + (064/2) - 128 ;(y*128) + (x/2)
RMove2Monster062:   equ $4000 + (200*128) + (096/2) - 128 ;(y*128) + (x/2)
RAttack1Monster062: equ $4000 + (080*128) + (192/2) - 128 ;(y*128) + (x/2)

LIdle1Monster062:   equ $4000 + (200*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster062:   equ $4000 + (200*128) + (192/2) - 128 ;(y*128) + (x/2)
LMove1Monster062:   equ $4000 + (200*128) + (160/2) - 128 ;(y*128) + (x/2)
LMove2Monster062:   equ $4000 + (200*128) + (128/2) - 128 ;(y*128) + (x/2)
LAttack1Monster062: equ $4000 + (160*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster062Move:                     
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RMove1Monster062
  dw    RMove2Monster062
  ;facing left
  dw    LMove1Monster062
  dw    LMove2Monster062
Monster062Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster062
  dw    RIdle2Monster062
  ;facing left
  dw    LIdle1Monster062
  dw    LIdle2Monster062
Monster062AttackPatternRight:
  db    000,AnimateAttack | dw RAttack1Monster062 | db 128+48,003,000,ShowBeingHitSprite,007,000,AnimateAttack | dw RIdle1Monster062 | db 128+32,InitiateAttack
Monster062AttackPatternLeft:
  db    000,AnimateAttack | dw LAttack1Monster062 | db 128+48,DisplaceLeft,007,000,ShowBeingHitSprite,003,000,AnimateAttack | dw LIdle1Monster062 | db 128+32,DisplaceRight,InitiateAttack
Monster062AttackPatternLeftUp:
  db    000,AnimateAttack | dw LAttack1Monster062 | db 128+48,DisplaceLeft,002,000,ShowBeingHitSprite,006,000,AnimateAttack | dw LIdle1Monster062 | db 128+32,DisplaceRight,InitiateAttack
Monster062AttackPatternLeftDown:
  db    000,AnimateAttack | dw LAttack1Monster062 | db 128+48,DisplaceLeft,004,000,ShowBeingHitSprite,008,000,AnimateAttack | dw LIdle1Monster062 | db 128+32,DisplaceRight,InitiateAttack
Monster062AttackPatternRightUp:
  db    000,AnimateAttack | dw RAttack1Monster062 | db 128+48,008,000,ShowBeingHitSprite,004,000,AnimateAttack | dw RIdle1Monster062 | db 128+32,InitiateAttack
Monster062AttackPatternRightDown:
  db    000,AnimateAttack | dw RAttack1Monster062 | db 128+48,006,000,ShowBeingHitSprite,002,000,AnimateAttack | dw RIdle1Monster062 | db 128+32,InitiateAttack 
;######################################################################################
;Rouge Gazer (Psycho World)

RIdle1Monster063:   equ $4000 + (208*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster063:   equ $4000 + (208*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster063:   equ $4000 + (208*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster063:   equ $4000 + (208*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster063Move:                     
Monster063Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster063
  dw    RIdle2Monster063
  ;facing left
  dw    LIdle1Monster063
  dw    LIdle2Monster063
;######################################################################################
;Glacierling (Psycho World)

RIdle1Monster064:   equ $4000 + (232*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster064:   equ $4000 + (232*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster064:   equ $4000 + (232*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster064:   equ $4000 + (232*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster064Move:                     
Monster064Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster064
  dw    RIdle2Monster064
  ;facing left
  dw    LIdle1Monster064
  dw    LIdle2Monster064
;######################################################################################
;Floatwing (Psycho World)

RIdle1Monster065:   equ $4000 + (000*128) + (064/2) - 128 ;(y*128) + (x/2)
RIdle2Monster065:   equ $4000 + (000*128) + (080/2) - 128 ;(y*128) + (x/2)

LIdle1Monster065:   equ $4000 + (000*128) + (112/2) - 128 ;(y*128) + (x/2)
LIdle2Monster065:   equ $4000 + (000*128) + (096/2) - 128 ;(y*128) + (x/2)

Monster065Move:                     
Monster065Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster065
  dw    RIdle2Monster065
  ;facing left
  dw    LIdle1Monster065
  dw    LIdle2Monster065
;######################################################################################
;CrimsonPeek (Psycho World)

RIdle1Monster066:   equ $4000 + (152*128) + (096/2) - 128 ;(y*128) + (x/2)
RIdle2Monster066:   equ $4000 + (152*128) + (112/2) - 128 ;(y*128) + (x/2)

LIdle1Monster066:   equ $4000 + (152*128) + (144/2) - 128 ;(y*128) + (x/2)
LIdle2Monster066:   equ $4000 + (152*128) + (128/2) - 128 ;(y*128) + (x/2)

Monster066Move:                     
Monster066Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster066
  dw    RIdle2Monster066
  ;facing left
  dw    LIdle1Monster066
  dw    LIdle2Monster066
;######################################################################################
;Fernling (Psycho World)

RIdle1Monster067:   equ $4000 + (000*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster067:   equ $4000 + (000*128) + (016/2) - 128 ;(y*128) + (x/2)

LIdle1Monster067:   equ $4000 + (000*128) + (048/2) - 128 ;(y*128) + (x/2)
LIdle2Monster067:   equ $4000 + (000*128) + (032/2) - 128 ;(y*128) + (x/2)

Monster067Move:                     
Monster067Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster067
  dw    RIdle2Monster067
  ;facing left
  dw    LIdle1Monster067
  dw    LIdle2Monster067
;######################################################################################
;Bladezilla (Psycho World)

RIdle1Monster068:   equ $4000 + (024*128) + (000/2) - 128 ;(y*128) + (x/2)
RIdle2Monster068:   equ $4000 + (024*128) + (032/2) - 128 ;(y*128) + (x/2)

LIdle1Monster068:   equ $4000 + (024*128) + (096/2) - 128 ;(y*128) + (x/2)
LIdle2Monster068:   equ $4000 + (024*128) + (064/2) - 128 ;(y*128) + (x/2)

Monster068Move:                     
Monster068Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster068
  dw    RIdle2Monster068
  ;facing left
  dw    LIdle1Monster068
  dw    LIdle2Monster068
;######################################################################################
;Spitvine (Psycho World)

RIdle1Monster069:   equ $4000 + (024*128) + (128/2) - 128 ;(y*128) + (x/2)
RIdle2Monster069:   equ $4000 + (024*128) + (160/2) - 128 ;(y*128) + (x/2)

LIdle1Monster069:   equ $4000 + (024*128) + (224/2) - 128 ;(y*128) + (x/2)
LIdle2Monster069:   equ $4000 + (024*128) + (192/2) - 128 ;(y*128) + (x/2)

Monster069Move:                     
Monster069Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster069
  dw    RIdle2Monster069
  ;facing left
  dw    LIdle1Monster069
  dw    LIdle2Monster069
Monster069AttackPatternRight:
  db    000,AnimateAttack | dw RIdle2Monster069 | db 000,ShootProjectile,WaitImpactProjectile
Monster069AttackPatternLeft:
  db    000,AnimateAttack | dw LIdle2Monster069 | db 000,ShootProjectile,WaitImpactProjectile
;######################################################################################
;OptiLeaper (Psycho World)

RIdle1Monster070:   equ $4000 + (184*128) + (192/2) - 128 ;(y*128) + (x/2)
RIdle2Monster070:   equ $4000 + (184*128) + (208/2) - 128 ;(y*128) + (x/2)

LIdle1Monster070:   equ $4000 + (184*128) + (240/2) - 128 ;(y*128) + (x/2)
LIdle2Monster070:   equ $4000 + (184*128) + (224/2) - 128 ;(y*128) + (x/2)

Monster070Move:                     
Monster070Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster070
  dw    RIdle2Monster070
  ;facing left
  dw    LIdle1Monster070
  dw    LIdle2Monster070
;######################################################################################
;huge boo (golvellius)

RIdle1Monster071:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster071:   equ $4000 + (000*128) + (064/2) - 128

LIdle1Monster071:   equ $4000 + (000*128) + (192/2) - 128
LIdle2Monster071:   equ $4000 + (000*128) + (128/2) - 128

Monster071Move:                     
Monster071Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster071
  dw    RIdle2Monster071
  ;facing left
  dw    LIdle1Monster071
  dw    LIdle2Monster071
;######################################################################################





;King Kong (king kong)

RIdle1Monster072:   equ $4000 + (064*128) + (000/2) - 128
RIdle2Monster072:   equ $4000 + (064*128) + (032/2) - 128

LIdle1Monster072:   equ $4000 + (064*128) + (096/2) - 128
LIdle2Monster072:   equ $4000 + (064*128) + (064/2) - 128

Monster072Move:                     
Monster072Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster072
  dw    RIdle2Monster072
  ;facing left
  dw    LIdle1Monster072
  dw    LIdle2Monster072
;######################################################################################
;RockGoliath (king kong)

RIdle1Monster073:   equ $4000 + (064*128) + (128/2) - 128
RIdle2Monster073:   equ $4000 + (064*128) + (160/2) - 128

LIdle1Monster073:   equ $4000 + (064*128) + (224/2) - 128
LIdle2Monster073:   equ $4000 + (064*128) + (192/2) - 128

Monster073Move:                     
Monster073Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster073
  dw    RIdle2Monster073
  ;facing left
  dw    LIdle1Monster073
  dw    LIdle2Monster073
;######################################################################################
;Stone Guard (king kong)

RIdle1Monster074:   equ $4000 + (000*128) + (128/2) - 128
RIdle2Monster074:   equ $4000 + (000*128) + (144/2) - 128

LIdle1Monster074:   equ $4000 + (000*128) + (176/2) - 128
LIdle2Monster074:   equ $4000 + (000*128) + (160/2) - 128

Monster074Move:                     
Monster074Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster074
  dw    RIdle2Monster074
  ;facing left
  dw    LIdle1Monster074
  dw    LIdle2Monster074
;######################################################################################
;LimeCritter (king kong)

RIdle1Monster075:   equ $4000 + (000*128) + (192/2) - 128
RIdle2Monster075:   equ $4000 + (000*128) + (208/2) - 128

LIdle1Monster075:   equ $4000 + (000*128) + (240/2) - 128
LIdle2Monster075:   equ $4000 + (000*128) + (224/2) - 128

Monster075Move:                     
Monster075Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster075
  dw    RIdle2Monster075
  ;facing left
  dw    LIdle1Monster075
  dw    LIdle2Monster075
;######################################################################################
;Salmon Hog (king kong)

RIdle1Monster076:   equ $4000 + (104*128) + (000/2) - 128
RIdle2Monster076:   equ $4000 + (104*128) + (016/2) - 128

LIdle1Monster076:   equ $4000 + (104*128) + (048/2) - 128
LIdle2Monster076:   equ $4000 + (104*128) + (032/2) - 128

Monster076Move:                     
Monster076Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster076
  dw    RIdle2Monster076
  ;facing left
  dw    LIdle1Monster076
  dw    LIdle2Monster076
;######################################################################################
;Swamp Goop (king kong)

RIdle1Monster077:   equ $4000 + (152*128) + (160/2) - 128
RIdle2Monster077:   equ $4000 + (152*128) + (176/2) - 128
RIdle3Monster077:   equ $4000 + (152*128) + (192/2) - 128

LIdle1Monster077:   equ $4000 + (152*128) + (160/2) - 128
LIdle2Monster077:   equ $4000 + (152*128) + (176/2) - 128
LIdle3Monster077:   equ $4000 + (152*128) + (192/2) - 128

Monster077Move:                     
Monster077Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster077
  dw    RIdle2Monster077
  dw    RIdle3Monster077
  dw    RIdle2Monster077
  ;facing left
  dw    LIdle1Monster077
  dw    LIdle2Monster077
  dw    LIdle3Monster077
  dw    LIdle2Monster077
;######################################################################################
;Bat (Golvellius)

RIdle1Monster078:   equ $4000 + (096*128) + (240/2) - 128
RIdle2Monster078:   equ $4000 + (176*128) + (240/2) - 128

LIdle1Monster078:   equ $4000 + (176*128) + (240/2) - 128
LIdle2Monster078:   equ $4000 + (096*128) + (240/2) - 128

Monster078Move:                     
Monster078Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster078
  dw    RIdle2Monster078
  ;facing left
  dw    LIdle1Monster078
  dw    LIdle2Monster078
;######################################################################################
;Olive Boa (Golvellius)

RIdle1Monster079:   equ $4000 + (104*128) + (064/2) - 128
RIdle2Monster079:   equ $4000 + (104*128) + (080/2) - 128

LIdle1Monster079:   equ $4000 + (104*128) + (112/2) - 128
LIdle2Monster079:   equ $4000 + (104*128) + (096/2) - 128

Monster079Move:                     
Monster079Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster079
  dw    RIdle2Monster079
  ;facing left
  dw    LIdle1Monster079
  dw    LIdle2Monster079
;######################################################################################
;SilkenLarva (green caterpillar) (Golvellius)

RIdle1Monster080:   equ $4000 + (240*128) + (032/2) - 128
RIdle2Monster080:   equ $4000 + (240*128) + (048/2) - 128

LIdle1Monster080:   equ $4000 + (240*128) + (080/2) - 128
LIdle2Monster080:   equ $4000 + (240*128) + (064/2) - 128

Monster080Move:                     
Monster080Idle:
  db    9                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster080
  dw    RIdle2Monster080
  ;facing left
  dw    LIdle1Monster080
  dw    LIdle2Monster080
;######################################################################################
;ChocoTusker (Golvellius)

RIdle1Monster081:   equ $4000 + (104*128) + (128/2) - 128
RIdle2Monster081:   equ $4000 + (104*128) + (144/2) - 128

LIdle1Monster081:   equ $4000 + (104*128) + (176/2) - 128
LIdle2Monster081:   equ $4000 + (104*128) + (160/2) - 128

Monster081Move:                     
Monster081Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster081
  dw    RIdle2Monster081
  ;facing left
  dw    LIdle1Monster081
  dw    LIdle2Monster081
;######################################################################################
;JadeWormlet (white worm) (Golvellius)

RIdle1Monster082:   equ $4000 + (080*128) + (240/2) - 128
RIdle2Monster082:   equ $4000 + (160*128) + (240/2) - 128

LIdle1Monster082:   equ $4000 + (240*128) + (016/2) - 128
LIdle2Monster082:   equ $4000 + (240*128) + (000/2) - 128

Monster082Move:                     
Monster082Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster082
  dw    RIdle2Monster082
  ;facing left
  dw    LIdle1Monster082
  dw    LIdle2Monster082
;######################################################################################
;Sable Raven (Golvellius)

RIdle1Monster083:   equ $4000 + (104*128) + (192/2) - 128
RIdle2Monster083:   equ $4000 + (104*128) + (208/2) - 128

LIdle1Monster083:   equ $4000 + (104*128) + (240/2) - 128
LIdle2Monster083:   equ $4000 + (104*128) + (224/2) - 128

Monster083Move:                     
Monster083Idle:
  db    6                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster083
  dw    RIdle2Monster083
  ;facing left
  dw    LIdle1Monster083
  dw    LIdle2Monster083
;######################################################################################
;Headless (Golvellius)

RIdle1Monster084:   equ $4000 + (224*128) + (128/2) - 128
RIdle2Monster084:   equ $4000 + (224*128) + (144/2) - 128

LIdle1Monster084:   equ $4000 + (224*128) + (176/2) - 128
LIdle2Monster084:   equ $4000 + (224*128) + (160/2) - 128

Monster084Move:                     
Monster084Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster084
  dw    RIdle2Monster084
  ;facing left
  dw    LIdle1Monster084
  dw    LIdle2Monster084
;######################################################################################
;Seraph (Golvellius)

RIdle1Monster085:   equ $4000 + (040*128) + (192/2) - 128
RIdle2Monster085:   equ $4000 + (040*128) + (208/2) - 128

LIdle1Monster085:   equ $4000 + (040*128) + (240/2) - 128
LIdle2Monster085:   equ $4000 + (040*128) + (224/2) - 128

Monster085Move:                     
Monster085Idle:
  db    9                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster085
  dw    RIdle2Monster085
  ;facing left
  dw    LIdle1Monster085
  dw    LIdle2Monster085
;######################################################################################
;Flame Cobra (Golvellius)

RIdle1Monster086:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster086:   equ $4000 + (000*128) + (056/2) - 128

LIdle1Monster086:   equ $4000 + (000*128) + (112/2) - 128
LIdle2Monster086:   equ $4000 + (000*128) + (168/2) - 128

Monster086Move:                     
Monster086Idle:
  db    2                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster086
  dw    RIdle2Monster086
  ;facing left
  dw    LIdle1Monster086
  dw    LIdle2Monster086
;######################################################################################
;Visage (undeadline)

RIdle1Monster087:   equ $4000 + (128*128) + (128/2) - 128
RIdle2Monster087:   equ $4000 + (128*128) + (144/2) - 128

LIdle1Monster087:   equ $4000 + (128*128) + (176/2) - 128
LIdle2Monster087:   equ $4000 + (128*128) + (160/2) - 128

Monster087Move:                     
Monster087Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster087
  dw    RIdle2Monster087
  ;facing left
  dw    LIdle1Monster087
  dw    LIdle2Monster087
;######################################################################################
;JungleBrute (undeadline)

RIdle1Monster088:   equ $4000 + (128*128) + (000/2) - 128
RIdle2Monster088:   equ $4000 + (128*128) + (016/2) - 128

LIdle1Monster088:   equ $4000 + (128*128) + (048/2) - 128
LIdle2Monster088:   equ $4000 + (128*128) + (032/2) - 128

Monster088Move:                     
Monster088Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster088
  dw    RIdle2Monster088
  ;facing left
  dw    LIdle1Monster088
  dw    LIdle2Monster088
;######################################################################################
;Lurcher (undeadline)

RIdle1Monster089:   equ $4000 + (128*128) + (064/2) - 128
RIdle2Monster089:   equ $4000 + (128*128) + (080/2) - 128

LIdle1Monster089:   equ $4000 + (128*128) + (112/2) - 128
LIdle2Monster089:   equ $4000 + (128*128) + (096/2) - 128

Monster089Move:                     
Monster089Idle:
  db    9                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster089
  dw    RIdle2Monster089
  ;facing left
  dw    LIdle1Monster089
  dw    LIdle2Monster089
;######################################################################################
;Scavenger (Metal Gear)

RIdle1Monster090:   equ $4000 + (240*128) + (096/2) - 128
RIdle2Monster090:   equ $4000 + (240*128) + (112/2) - 128

LIdle1Monster090:   equ $4000 + (240*128) + (144/2) - 128
LIdle2Monster090:   equ $4000 + (240*128) + (128/2) - 128

Monster090Move:                     
Monster090Idle:
  db    8                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster090
  dw    RIdle2Monster090
  ;facing left
  dw    LIdle1Monster090
  dw    LIdle2Monster090
;######################################################################################
;Running Man (Metal Gear)

RIdle1Monster091:   equ $4000 + (128*128) + (192/2) - 128
RIdle2Monster091:   equ $4000 + (128*128) + (208/2) - 128

LIdle1Monster091:   equ $4000 + (128*128) + (240/2) - 128
LIdle2Monster091:   equ $4000 + (128*128) + (224/2) - 128

Monster091Move:                     
Monster091Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster091
  dw    RIdle2Monster091
  ;facing left
  dw    LIdle1Monster091
  dw    LIdle2Monster091
;######################################################################################
;Trooper (Metal Gear)

RIdle1Monster092:   equ $4000 + (168*128) + (000/2) - 128
RIdle2Monster092:   equ $4000 + (168*128) + (016/2) - 128

LIdle1Monster092:   equ $4000 + (168*128) + (048/2) - 128
LIdle2Monster092:   equ $4000 + (168*128) + (032/2) - 128

Monster092Move:                     
Monster092Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster092
  dw    RIdle2Monster092
  ;facing left
  dw    LIdle1Monster092
  dw    LIdle2Monster092
Monster092AttackPatternLeft:
Monster092AttackPatternRight:
  db    ShootProjectile,WaitImpactProjectile
;######################################################################################
;Antigas Man (Metal Gear)

RIdle1Monster093:   equ $4000 + (168*128) + (064/2) - 128
RIdle2Monster093:   equ $4000 + (168*128) + (080/2) - 128

LIdle1Monster093:   equ $4000 + (168*128) + (112/2) - 128
LIdle2Monster093:   equ $4000 + (168*128) + (096/2) - 128

Monster093Move:                     
Monster093Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster093
  dw    RIdle2Monster093
  ;facing left
  dw    LIdle1Monster093
  dw    LIdle2Monster093
Monster093AttackPatternLeft:
Monster093AttackPatternRight:
  db    ShootProjectile,WaitImpactProjectile
;######################################################################################
;Footman (Metal Gear)

RIdle1Monster094:   equ $4000 + (168*128) + (128/2) - 128
RIdle2Monster094:   equ $4000 + (168*128) + (144/2) - 128

LIdle1Monster094:   equ $4000 + (168*128) + (176/2) - 128
LIdle2Monster094:   equ $4000 + (168*128) + (160/2) - 128

Monster094Move:                     
Monster094Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster094
  dw    RIdle2Monster094
  ;facing left
  dw    LIdle1Monster094
  dw    LIdle2Monster094
Monster094AttackPatternLeft:
Monster094AttackPatternRight:
  db    ShootProjectile,WaitImpactProjectile
;######################################################################################
;Geld (Ys 3)

RIdle1Monster095:   equ $4000 + (096*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle2Monster095:   equ $4000 + (096*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle3Monster095:   equ $4000 + (096*128) + (080/2) - 128  ;(y*128) + (x/2)
RAttack1Monster095: equ $4000 + (096*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack2Monster095: equ $4000 + (096*128) + (112/2) - 128  ;(y*128) + (x/2)
RAttack3Monster095: equ $4000 + (096*128) + (144/2) - 128  ;(y*128) + (x/2)

LIdle1Monster095:   equ $4000 + (128*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle2Monster095:   equ $4000 + (128*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle3Monster095:   equ $4000 + (128*128) + (016/2) - 128  ;(y*128) + (x/2)
LAttack1Monster095: equ $4000 + (128*128) + (000/2) - 128  ;(y*128) + (x/2)
LAttack2Monster095: equ $4000 + (032*128) + (224/2) - 128  ;(y*128) + (x/2)
LAttack3Monster095: equ $4000 + (096*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster095Move:                     
Monster095Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster095
  dw    RIdle2Monster095
  dw    RIdle3Monster095
  dw    RIdle2Monster095
  ;facing left
  dw    LIdle1Monster095
  dw    LIdle2Monster095
  dw    LIdle3Monster095
  dw    LIdle2Monster095
Monster095AttackPatternRight:
  db    000,000,AnimateAttack | dw RAttack1Monster095 | db 000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack3Monster095 | db 128+48,ShowBeingHitSprite,000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack1Monster095 | db 128+16,000,000,InitiateAttack
Monster095AttackPatternLeft:
  db    000,000,AnimateAttack | dw LAttack1Monster095 | db 000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceLeft,000,000,AnimateAttack | dw LAttack3Monster095 | db 128+48,DisplaceLeft,ShowBeingHitSprite,000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceRight,000,000,AnimateAttack | dw LAttack1Monster095 | db 128+16,DisplaceRight,000,000,InitiateAttack
Monster095AttackPatternLeftUp:
  db    002,000,AnimateAttack | dw LAttack1Monster095 | db 000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceLeft,000,000,AnimateAttack | dw LAttack3Monster095 | db 128+48,DisplaceLeft,ShowBeingHitSprite,000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceRight,000,000,AnimateAttack | dw LAttack1Monster095 | db 128+16,DisplaceRight,000,006,InitiateAttack
Monster095AttackPatternLeftDown:
  db    004,000,AnimateAttack | dw LAttack1Monster095 | db 000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceLeft,000,000,AnimateAttack | dw LAttack3Monster095 | db 128+48,DisplaceLeft,ShowBeingHitSprite,000,000,AnimateAttack | dw LAttack2Monster095 | db 128+32,DisplaceRight,000,000,AnimateAttack | dw LAttack1Monster095 | db 128+16,DisplaceRight,000,008,InitiateAttack
Monster095AttackPatternRightUp:
  db    008,000,AnimateAttack | dw RAttack1Monster095 | db 000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack3Monster095 | db 128+48,ShowBeingHitSprite,000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack1Monster095 | db 128+16,000,004,InitiateAttack
Monster095AttackPatternRightDown:
  db    006,000,AnimateAttack | dw RAttack1Monster095 | db 000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack3Monster095 | db 128+48,ShowBeingHitSprite,000,000,AnimateAttack | dw RAttack2Monster095 | db 128+32,000,000,AnimateAttack | dw RAttack1Monster095 | db 128+16,000,002,InitiateAttack
;######################################################################################
;Raddel (Ys 3)

RIdle1Monster096:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster096:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster096:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster096: equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack2Monster096: equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster096:   equ $4000 + (032*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle2Monster096:   equ $4000 + (032*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle3Monster096:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)
LAttack1Monster096: equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack2Monster096: equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster096Move:                     
Monster096Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster096
  dw    RIdle2Monster096
  dw    RIdle3Monster096
  dw    RIdle2Monster096
  ;facing left
  dw    LIdle1Monster096
  dw    LIdle2Monster096
  dw    LIdle3Monster096
  dw    LIdle2Monster096
Monster096AttackPatternRight:
  db    000,AnimateAttack | dw RAttack1Monster096 | db 003,000,AnimateAttack | dw RAttack2Monster096 | db ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster096 | db 007,InitiateAttack
Monster096AttackPatternLeft:
  db    000,AnimateAttack | dw LAttack1Monster096 | db 007,000,AnimateAttack | dw LAttack2Monster096 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster096 | db 003,InitiateAttack
Monster096AttackPatternLeftUp:
  db    000,AnimateAttack | dw LAttack1Monster096 | db 002,000,AnimateAttack | dw LAttack2Monster096 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster096 | db 006,InitiateAttack
Monster096AttackPatternLeftDown:
  db    000,AnimateAttack | dw LAttack1Monster096 | db 004,000,AnimateAttack | dw LAttack2Monster096 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster096 | db 008,InitiateAttack
Monster096AttackPatternRightUp:
  db    000,AnimateAttack | dw RAttack1Monster096 | db 008,000,AnimateAttack | dw RAttack2Monster096 | db ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster096 | db 004,InitiateAttack
Monster096AttackPatternRightDown:
  db    000,AnimateAttack | dw RAttack1Monster096 | db 006,000,AnimateAttack | dw RAttack2Monster096 | db ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster096 | db 002,InitiateAttack
;######################################################################################
;Bikmorl (Ys 3)

RIdle1Monster097:   equ $4000 + (128*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster097:   equ $4000 + (128*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle3Monster097:   equ $4000 + (128*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster097:   equ $4000 + (128*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster097:   equ $4000 + (128*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster097:   equ $4000 + (128*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster097Move:                     
Monster097Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster097
  dw    RIdle2Monster097
  dw    RIdle3Monster097
  ;facing left
  dw    LIdle1Monster097
  dw    LIdle2Monster097
  dw    LIdle3Monster097
;######################################################################################
;Slime (Ys 3)

RIdle1Monster098:   equ $4000 + (160*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster098:   equ $4000 + (160*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster098:   equ $4000 + (160*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle4Monster098:   equ $4000 + (160*128) + (048/2) - 128  ;(y*128) + (x/2)

LIdle1Monster098:   equ $4000 + (160*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle2Monster098:   equ $4000 + (160*128) + (016/2) - 128  ;(y*128) + (x/2)
LIdle3Monster098:   equ $4000 + (160*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle4Monster098:   equ $4000 + (160*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster098Move:                     
Monster098Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    5                               ;amount of animation frames
  dw    RIdle1Monster098
  dw    RIdle2Monster098
  dw    RIdle3Monster098
  dw    RIdle4Monster098
  dw    RIdle2Monster098
  ;facing left
  dw    LIdle1Monster098
  dw    LIdle2Monster098
  dw    LIdle3Monster098
  dw    LIdle4Monster098
  dw    LIdle2Monster098
;######################################################################################
;Keyron (Ys 3)

RIdle1Monster099:   equ $4000 + (128*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster099:   equ $4000 + (128*128) + (080/2) - 128  ;(y*128) + (x/2)
RIdle3Monster099:   equ $4000 + (128*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster099:   equ $4000 + (128*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster099:   equ $4000 + (128*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster099:   equ $4000 + (128*128) + (112/2) - 128  ;(y*128) + (x/2)

Monster099Move:                     
Monster099Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster099
  dw    RIdle2Monster099
  dw    RIdle3Monster099
  dw    RIdle2Monster099
  ;facing left
  dw    LIdle1Monster099
  dw    LIdle2Monster099
  dw    LIdle3Monster099
  dw    LIdle2Monster099
;######################################################################################
;Gululmus (Ys 3)

RIdle1Monster100:   equ $4000 + (240*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster100:   equ $4000 + (240*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster100:   equ $4000 + (240*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster100:   equ $4000 + (240*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster100Move:                     
Monster100Idle:
  db    7                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster100
  dw    RIdle2Monster100
  ;facing left
  dw    LIdle1Monster100
  dw    LIdle2Monster100
;######################################################################################
;Sabre Wolf (Ys 3)

RIdle1Monster101:   equ $4000 + (032*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster101:   equ $4000 + (032*128) + (112/2) - 128  ;(y*128) + (x/2)
RIdle3Monster101:   equ $4000 + (032*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster101: equ $4000 + (064*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster101:   equ $4000 + (064*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster101:   equ $4000 + (064*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle3Monster101:   equ $4000 + (064*128) + (096/2) - 128  ;(y*128) + (x/2)
LAttack1Monster101: equ $4000 + (064*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster101Move:                     
Monster101Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster101
  dw    RIdle2Monster101
  dw    RIdle3Monster101
  ;facing left
  dw    LIdle1Monster101
  dw    LIdle2Monster101
  dw    LIdle3Monster101
Monster101AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster101 | db 003,AnimateAttack | dw RAttack1Monster101 | db 000,ShowBeingHitSprite,000,007,InitiateAttack
Monster101AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster101 | db 007,AnimateAttack | dw LAttack1Monster101 | db 000,ShowBeingHitSprite,000,003,InitiateAttack
Monster101AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster101 | db 008,AnimateAttack | dw LAttack1Monster101 | db 000,ShowBeingHitSprite,000,004,InitiateAttack
Monster101AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster101 | db 006,AnimateAttack | dw LAttack1Monster101 | db 000,ShowBeingHitSprite,000,002,InitiateAttack
Monster101AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster101 | db 002,AnimateAttack | dw RAttack1Monster101 | db 000,ShowBeingHitSprite,000,006,InitiateAttack
Monster101AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster101 | db 004,AnimateAttack | dw RAttack1Monster101 | db 000,ShowBeingHitSprite,000,008,InitiateAttack







;######################################################################################
;Lee Young (yie ar kung fu)

RIdle1Monster102:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster102:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
Rattack1Monster102: equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
Rattack2Monster102: equ $4000 + (000*128) + (112/2) - 128  ;(y*128) + (x/2)

LIdle1Monster102:   equ $4000 + (040*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle2Monster102:   equ $4000 + (040*128) + (000/2) - 128  ;(y*128) + (x/2)
Lattack1Monster102: equ $4000 + (000*128) + (208/2) - 128  ;(y*128) + (x/2)
Lattack2Monster102: equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster102Move:
Monster102Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster102
  dw    RIdle2Monster102
  ;facing left
  dw    LIdle1Monster102
  dw    LIdle2Monster102
Monster102AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster102 | db 003,128+48,AnimateAttack | dw Rattack1Monster102 | db 000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw RIdle2Monster102 | db 007,InitiateAttack
Monster102AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster102 | db 008,128+48,AnimateAttack | dw Rattack1Monster102 | db 000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw RIdle2Monster102 | db 004,InitiateAttack
Monster102AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster102 | db 006,128+48,AnimateAttack | dw Rattack2Monster102 | db 000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw RIdle2Monster102 | db 002,InitiateAttack
Monster102AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster102 | db 000,007,128+48,AnimateAttack | dw Lattack1Monster102 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw LIdle2Monster102 | db DisplaceRight,003,000,InitiateAttack
Monster102AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster102 | db 000,002,128+48,AnimateAttack | dw Lattack1Monster102 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw LIdle2Monster102 | db DisplaceRight,006,000,InitiateAttack
Monster102AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster102 | db 000,004,128+48,AnimateAttack | dw Lattack2Monster102 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,AnimateAttack | dw LIdle2Monster102 | db DisplaceRight,008,000,InitiateAttack
;######################################################################################
;Yen Pei (braid hair) (yie ar kung fu)

RIdle1Monster103:   equ $4000 + (080*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster103:   equ $4000 + (080*128) + (048/2) - 128  ;(y*128) + (x/2)
Rattack1Monster103: equ $4000 + (080*128) + (096/2) - 128  ;(y*128) + (x/2)
Rattack2Monster103: equ $4000 + (080*128) + (144/2) - 128  ;(y*128) + (x/2)

LIdle1Monster103:   equ $4000 + (128*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster103:   equ $4000 + (128*128) + (112/2) - 128  ;(y*128) + (x/2)
Lattack1Monster103: equ $4000 + (128*128) + (064/2) - 128  ;(y*128) + (x/2)
Lattack2Monster103: equ $4000 + (128*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster103Move:
Monster103Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster103
  dw    RIdle2Monster103
  ;facing left
  dw    LIdle1Monster103
  dw    LIdle2Monster103
Monster103AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster103 | db 000,000,AnimateAttack | dw Rattack2Monster103 | db 128+64,DisplaceRight,000,ShowBeingHitSprite,000,AnimateAttack | dw Rattack1Monster103 | db 128+48,DisplaceLeft,InitiateAttack
Monster103AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster103 | db 008,AnimateAttack | dw Rattack1Monster103 | db 000,000,AnimateAttack | dw Rattack2Monster103 | db 128+64,DisplaceRight,000,ShowBeingHitSprite,000,AnimateAttack | dw Rattack1Monster103 | db 128+48,DisplaceLeft,000,000,AnimateAttack | dw RIdle2Monster103 | db 004,InitiateAttack
Monster103AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster103 | db 006,AnimateAttack | dw Rattack1Monster103 | db 000,000,AnimateAttack | dw Rattack2Monster103 | db 128+64,DisplaceRight,000,ShowBeingHitSprite,000,AnimateAttack | dw Rattack1Monster103 | db 128+48,DisplaceLeft,000,000,AnimateAttack | dw RIdle2Monster103 | db 002,InitiateAttack
Monster103AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster103 | db 000,000,AnimateAttack | dw Lattack2Monster103 | db 128+64,DisplaceLeft,DisplaceLeft,000,ShowBeingHitSprite,000,AnimateAttack | dw Lattack1Monster103 | db 128+48,DisplaceRight,DisplaceRight,InitiateAttack
Monster103AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster103 | db 002,AnimateAttack | dw Lattack1Monster103 | db 000,000,AnimateAttack | dw Lattack2Monster103 | db 128+64,DisplaceLeft,DisplaceLeft,000,ShowBeingHitSprite,000,AnimateAttack | dw Lattack1Monster103 | db 128+48,DisplaceRight,DisplaceRight,000,000,AnimateAttack | dw LIdle2Monster103 | db 006,InitiateAttack
Monster103AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster103 | db 004,AnimateAttack | dw Lattack1Monster103 | db 000,000,AnimateAttack | dw Lattack2Monster103 | db 128+64,DisplaceLeft,DisplaceLeft,000,ShowBeingHitSprite,000,AnimateAttack | dw Lattack1Monster103 | db 128+48,DisplaceRight,DisplaceRight,000,000,AnimateAttack | dw LIdle2Monster103 | db 008,InitiateAttack
;######################################################################################
;Lan Fang (fan thrower) (yie ar kung fu)

RIdle1Monster104:   equ $4000 + (040*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster104:   equ $4000 + (040*128) + (096/2) - 128  ;(y*128) + (x/2)
Rattack1Monster104: equ $4000 + (040*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster104:   equ $4000 + (040*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster104:   equ $4000 + (040*128) + (192/2) - 128  ;(y*128) + (x/2)
Lattack1Monster104: equ $4000 + (040*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster104Move:
Monster104Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster104
  dw    RIdle2Monster104
  ;facing left
  dw    LIdle1Monster104
  dw    LIdle2Monster104
Monster104AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster104 | db 000,ShootProjectile,000,000,000,000,AnimateAttack | dw RIdle1Monster104 | db WaitImpactProjectile
Monster104AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster104 | db 000,ShootProjectile,000,000,000,000,AnimateAttack | dw LIdle1Monster104 | db WaitImpactProjectile

;######################################################################################
;Po Chin (fatty) (yie ar kung fu)

RIdle1Monster105:   equ $4000 + (176*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster105:   equ $4000 + (176*128) + (048/2) - 128  ;(y*128) + (x/2)
Rattack1Monster105: equ $4000 + (080*128) + (208/2) - 128  ;(y*128) + (x/2)

LIdle1Monster105:   equ $4000 + (176*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster105:   equ $4000 + (176*128) + (096/2) - 128  ;(y*128) + (x/2)
Lattack1Monster105: equ $4000 + (128*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster105Move:
Monster105Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster105
  dw    RIdle2Monster105
  ;facing left
  dw    LIdle1Monster105
  dw    LIdle2Monster105
Monster105AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster105 | db 003,AnimateAttack | dw Rattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster105 | db 007,InitiateAttack
Monster105AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster105 | db 008,AnimateAttack | dw Rattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster105 | db 004,InitiateAttack
Monster105AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster105 | db 006,AnimateAttack | dw Rattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster105 | db 002,InitiateAttack
Monster105AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster105 | db 007,AnimateAttack | dw Lattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster105 | db 003,InitiateAttack
Monster105AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster105 | db 002,AnimateAttack | dw Lattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster105 | db 006,InitiateAttack
Monster105AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster105 | db 004,AnimateAttack | dw Lattack1Monster105 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster105 | db 008,InitiateAttack
;######################################################################################
;Wen Hu (yie ar kung fu)

RIdle1Monster106:   equ $4000 + (040*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster106:   equ $4000 + (040*128) + (048/2) - 128  ;(y*128) + (x/2)
Rattack1Monster106: equ $4000 + (120*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster106:   equ $4000 + (040*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster106:   equ $4000 + (040*128) + (160/2) - 128  ;(y*128) + (x/2)
Lattack1Monster106: equ $4000 + (120*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster106Move:
Monster106Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster106
  dw    RIdle2Monster106
  ;facing left
  dw    LIdle1Monster106
  dw    LIdle2Monster106
Monster106AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster106 | db 003,AnimateAttack | dw Rattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster106 | db 007,InitiateAttack
Monster106AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster106 | db 008,AnimateAttack | dw Rattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster106 | db 004,InitiateAttack
Monster106AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster106 | db 006,AnimateAttack | dw Rattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster106 | db 002,InitiateAttack
Monster106AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster106 | db 007,AnimateAttack | dw Lattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster106 | db 003,InitiateAttack
Monster106AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster106 | db 002,AnimateAttack | dw Lattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster106 | db 006,InitiateAttack
Monster106AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster106 | db 004,AnimateAttack | dw Lattack1Monster106 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster106 | db 008,InitiateAttack
;######################################################################################
;Wei Chin (yie ar kung fu)


RIdle1Monster107:   equ $4000 + (080*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster107:   equ $4000 + (080*128) + (048/2) - 128  ;(y*128) + (x/2)
Rattack1Monster107: equ $4000 + (120*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster107:   equ $4000 + (080*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster107:   equ $4000 + (080*128) + (160/2) - 128  ;(y*128) + (x/2)
Lattack1Monster107: equ $4000 + (120*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster107Move:
Monster107Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster107
  dw    RIdle2Monster107
  ;facing left
  dw    LIdle1Monster107
  dw    LIdle2Monster107
Monster107AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster107 | db 003,AnimateAttack | dw Rattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster107 | db 007,InitiateAttack
Monster107AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster107 | db 008,AnimateAttack | dw Rattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster107 | db 004,InitiateAttack
Monster107AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster107 | db 006,AnimateAttack | dw Rattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster107 | db 002,InitiateAttack
Monster107AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster107 | db 007,AnimateAttack | dw Lattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster107 | db 003,InitiateAttack
Monster107AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster107 | db 002,AnimateAttack | dw Lattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster107 | db 006,InitiateAttack
Monster107AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster107 | db 004,AnimateAttack | dw Lattack1Monster107 | db 000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster107 | db 008,InitiateAttack
;######################################################################################
;Mei Ling (yie ar kung fu)

RIdle1Monster108:   equ $4000 + (040*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle2Monster108:   equ $4000 + (080*128) + (096/2) - 128  ;(y*128) + (x/2)
Rattack1Monster108: equ $4000 + (160*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster108:   equ $4000 + (040*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle2Monster108:   equ $4000 + (080*128) + (128/2) - 128  ;(y*128) + (x/2)
Lattack1Monster108: equ $4000 + (160*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster108Move:
Monster108Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster108
  dw    RIdle2Monster108
  ;facing left
  dw    LIdle1Monster108
  dw    LIdle2Monster108
Monster108AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster108 | db 003,AnimateAttack | dw Rattack1Monster108 | db 128+48,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster108 | db 128+32,007,InitiateAttack
Monster108AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster108 | db 008,AnimateAttack | dw Rattack1Monster108 | db 128+48,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster108 | db 128+32,004,InitiateAttack
Monster108AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster108 | db 006,AnimateAttack | dw Rattack1Monster108 | db 128+48,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle2Monster108 | db 128+32,002,InitiateAttack
Monster108AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster108 | db 007,AnimateAttack | dw Lattack1Monster108 | db 128+48,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster108 | db 128+32,DisplaceRight,003,InitiateAttack
Monster108AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster108 | db 002,AnimateAttack | dw Lattack1Monster108 | db 128+48,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster108 | db 128+32,DisplaceRight,006,InitiateAttack
Monster108AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster108 | db 004,AnimateAttack | dw Lattack1Monster108 | db 128+48,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle2Monster108 | db 128+32,DisplaceRight,008,InitiateAttack
;######################################################################################
;Han Chen (bomb thrower) (yie ar kung fu)

RIdle1Monster109:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster109:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
Rattack1Monster109: equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
Rattack2Monster109: equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster109:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster109:   equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)
Lattack1Monster109: equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)
Lattack2Monster109: equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster109Move:
Monster109Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster109
  dw    RIdle2Monster109
  ;facing left
  dw    LIdle1Monster109
  dw    LIdle2Monster109
Monster109AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster109 | db 000,000,AnimateAttack | dw Rattack2Monster109 | db 000,ShootProjectile,000,000,AnimateAttack | dw RIdle1Monster109 | db WaitImpactProjectile
Monster109AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster109 | db 000,000,AnimateAttack | dw Lattack2Monster109 | db 000,ShootProjectile,000,000,AnimateAttack | dw LIdle1Monster109 | db WaitImpactProjectile

;######################################################################################
;Li Yen (final boss) (yie ar kung fu)

RIdle1Monster110:   equ $4000 + (200*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle2Monster110:   equ $4000 + (200*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster110:   equ $4000 + (200*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle2Monster110:   equ $4000 + (200*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster110Move:
  db    4                               ;animation speed (x frames per animation frame)
  db    1                               ;amount of animation frames
  dw    RIdle2Monster110
  ;facing left
  dw    LIdle2Monster110
Monster110Idle:
  db    12                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster110
  dw    RIdle2Monster110
  ;facing left
  dw    LIdle1Monster110
  dw    LIdle2Monster110
Monster110AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster110 | db 000,AnimateAttack | dw RIdle2Monster110 | db 000,ShootProjectile,WaitImpactProjectile
Monster110AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster110 | db 000,AnimateAttack | dw LIdle2Monster110 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################



;Queen Sora (akanbe dragon)

RIdle1Monster111:   equ $4000 + (160*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster111:   equ $4000 + (160*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle3Monster111:   equ $4000 + (160*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster111:   equ $4000 + (160*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster111:   equ $4000 + (160*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster111:   equ $4000 + (160*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster111Move:
Monster111Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster111
  dw    RIdle2Monster111
  dw    RIdle3Monster111
  ;facing left
  dw    LIdle1Monster111
  dw    LIdle2Monster111
  dw    LIdle3Monster111

;######################################################################################
;King Mori (akanbe dragon)

RIdle1Monster112:   equ $4000 + (192*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster112:   equ $4000 + (192*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack1Monster112: equ $4000 + (192*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster112:   equ $4000 + (192*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster112:   equ $4000 + (192*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster112: equ $4000 + (192*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster112Move:
Monster112Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster112
  dw    RIdle2Monster112
  ;facing left
  dw    LIdle1Monster112
  dw    LIdle2Monster112
Monster112AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster112 | db 000,ShootProjectile,WaitImpactProjectile
Monster112AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster112 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Knight Yama (mongolface) (akanbe dragon)

RIdle1Monster113:   equ $4000 + (224*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster113:   equ $4000 + (224*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack1Monster113: equ $4000 + (224*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster113:   equ $4000 + (224*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster113:   equ $4000 + (224*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster113: equ $4000 + (224*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster113Move:
Monster113Idle:
  db    09                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster113
  dw    RIdle2Monster113
  ;facing left
  dw    LIdle1Monster113
  dw    LIdle2Monster113
Monster113AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster113 | db 000,ShootProjectile,WaitImpactProjectile
Monster113AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster113 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Bishop Mori (monkey) (akanbe dragon)

RIdle1Monster114:   equ $4000 + (176*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster114:   equ $4000 + (176*128) + (032/2) - 128  ;(y*128) + (x/2)

LIdle1Monster114:   equ $4000 + (208*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle2Monster114:   equ $4000 + (208*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster114Move:
Monster114Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster114
  dw    RIdle2Monster114
  ;facing left
  dw    LIdle1Monster114
  dw    LIdle2Monster114

;######################################################################################
;B. Heichi (rhino) (akanbe dragon)

RIdle1Monster115:   equ $4000 + (120*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle2Monster115:   equ $4000 + (120*128) + (128/2) - 128  ;(y*128) + (x/2)
RAttack1Monster115: equ $4000 + (184*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster115:   equ $4000 + (152*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle2Monster115:   equ $4000 + (152*128) + (096/2) - 128  ;(y*128) + (x/2)
LAttack1Monster115: equ $4000 + (216*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster115Move:
Monster115Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster115
  dw    RIdle2Monster115
  ;facing left
  dw    LIdle1Monster115
  dw    LIdle2Monster115
Monster115AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster115 | db 000,ShootProjectile,WaitImpactProjectile
Monster115AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster115 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Roke Mizu (zebra) (akanbe dragon)

RIdle1Monster116:   equ $4000 + (160*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster116:   equ $4000 + (160*128) + (192/2) - 128  ;(y*128) + (x/2)
RAttack1Monster116: equ $4000 + (160*128) + (224/2) - 128  ;(y*128) + (x/2)

LIdle1Monster116:   equ $4000 + (192*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster116:   equ $4000 + (192*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster116: equ $4000 + (192*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster116Move:
Monster116Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster116
  dw    RIdle2Monster116
  ;facing left
  dw    LIdle1Monster116
  dw    LIdle2Monster116
Monster116AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster116 | db 003 | db ShowBeingHitSprite,000,000,000,000,007,InitiateAttack
Monster116AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster116 | db 002 | db ShowBeingHitSprite,000,000,000,000,006,InitiateAttack
Monster116AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster116 | db 004 | db ShowBeingHitSprite,000,000,000,000,008,InitiateAttack
Monster116AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster116 | db 007 | db ShowBeingHitSprite,000,000,000,000,003,InitiateAttack
Monster116AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster116 | db 008 | db ShowBeingHitSprite,000,000,000,000,004,InitiateAttack
Monster116AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster116 | db 006 | db ShowBeingHitSprite,000,000,000,000,002,InitiateAttack

;######################################################################################
;Porn Mizu (akanbe dragon)

RIdle1Monster117:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster117:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster117:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster117: equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster117:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster117:   equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster117:   equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)
LAttack1Monster117: equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster117Move:
Monster117Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster117
  dw    RIdle2Monster117
  dw    RIdle3Monster117
  ;facing left
  dw    LIdle1Monster117
  dw    LIdle2Monster117
  dw    LIdle3Monster117
Monster117AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster117 | db 003 | db ShowBeingHitSprite,000,000,000,000,007,InitiateAttack
Monster117AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster117 | db 002 | db ShowBeingHitSprite,000,000,000,000,006,InitiateAttack
Monster117AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster117 | db 004 | db ShowBeingHitSprite,000,000,000,000,008,InitiateAttack
Monster117AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster117 | db 007 | db ShowBeingHitSprite,000,000,000,000,003,InitiateAttack
Monster117AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster117 | db 008 | db ShowBeingHitSprite,000,000,000,000,004,InitiateAttack
Monster117AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster117 | db 006 | db ShowBeingHitSprite,000,000,000,000,002,InitiateAttack

;######################################################################################
;Roke Yama (kangaroo) (akanbe dragon)

RIdle1Monster118:   equ $4000 + (064*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster118:   equ $4000 + (064*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster118: equ $4000 + (064*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster118:   equ $4000 + (064*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster118:   equ $4000 + (064*128) + (128/2) - 128  ;(y*128) + (x/2)
LAttack1Monster118: equ $4000 + (064*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster118Move:
Monster118Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster118
  dw    RIdle2Monster118
  ;facing left
  dw    LIdle1Monster118
  dw    LIdle2Monster118
Monster118AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster118 | db 003 | db ShowBeingHitSprite,000,000,000,007,InitiateAttack
Monster118AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster118 | db 002 | db ShowBeingHitSprite,000,000,000,006,InitiateAttack
Monster118AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster118 | db 004 | db ShowBeingHitSprite,000,000,000,008,InitiateAttack
Monster118AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster118 | db 007 | db ShowBeingHitSprite,000,000,000,003,InitiateAttack
Monster118AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster118 | db 008 | db ShowBeingHitSprite,000,000,000,004,InitiateAttack
Monster118AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster118 | db 006 | db ShowBeingHitSprite,000,000,000,002,InitiateAttack

;######################################################################################
;Porn Heichi (eliphant) (akanbe dragon)

RIdle1Monster119:   equ $4000 + (032*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster119:   equ $4000 + (032*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster119: equ $4000 + (032*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack2Monster119: equ $4000 + (032*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster119:   equ $4000 + (032*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster119:   equ $4000 + (032*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster119: equ $4000 + (032*128) + (160/2) - 128  ;(y*128) + (x/2)
LAttack2Monster119: equ $4000 + (032*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster119Move:
Monster119Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster119
  dw    RIdle2Monster119
  ;facing left
  dw    LIdle1Monster119
  dw    LIdle2Monster119
Monster119AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster119 | db 000,000,000,AnimateAttack | dw RAttack2Monster119 | db 000,ShootProjectile,WaitImpactProjectile
Monster119AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster119 | db 000,000,000,AnimateAttack | dw LAttack2Monster119 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Yama Knight (bushman) (akanbe dragon)

RIdle1Monster120:   equ $4000 + (064*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster120:   equ $4000 + (064*128) + (224/2) - 128  ;(y*128) + (x/2)
RAttack1Monster120: equ $4000 + (096*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster120:   equ $4000 + (096*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle2Monster120:   equ $4000 + (096*128) + (064/2) - 128  ;(y*128) + (x/2)
LAttack1Monster120: equ $4000 + (096*128) + (032/2) - 128  ;(y*128) + (x/2)

Monster120Move:
Monster120Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster120
  dw    RIdle2Monster120
  ;facing left
  dw    LIdle1Monster120
  dw    LIdle2Monster120
Monster120AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster120 | db 000,ShootProjectile,WaitImpactProjectile
Monster120AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster120 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Queen (endboss) (akanbe dragon)

RIdle1Monster121:   equ $4000 + (128*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster121:   equ $4000 + (128*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle3Monster121:   equ $4000 + (128*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster121:   equ $4000 + (192*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle2Monster121:   equ $4000 + (192*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle3Monster121:   equ $4000 + (192*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster121Move:
Monster121Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster121
  dw    RIdle2Monster121
  dw    RIdle1Monster121
  dw    RIdle3Monster121
  ;facing left
  dw    LIdle1Monster121
  dw    LIdle2Monster121
  dw    LIdle1Monster121
  dw    LIdle3Monster121

;######################################################################################


;Spooky (spooky)

RIdle1Monster122:   equ $4000 + (096*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster122:   equ $4000 + (096*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle3Monster122:   equ $4000 + (096*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle4Monster122:   equ $4000 + (096*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster122:   equ $4000 + (096*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster122:   equ $4000 + (096*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster122:   equ $4000 + (096*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle4Monster122:   equ $4000 + (096*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster122Move:
Monster122Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster122
  dw    RIdle2Monster122
  dw    RIdle3Monster122
  dw    RIdle4Monster122
  dw    RIdle3Monster122
  dw    RIdle2Monster122
  ;facing left
  dw    LIdle1Monster122
  dw    LIdle2Monster122
  dw    LIdle3Monster122
  dw    LIdle4Monster122
  dw    LIdle3Monster122
  dw    LIdle2Monster122
Monster122AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster122 | db 000,AnimateAttack | dw LIdle2Monster122 | db 003,000,ShowBeingHitSprite,007,AnimateAttack | dw RIdle2Monster122 | db 000,InitiateAttack
Monster122AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster122 | db 000,AnimateAttack | dw LIdle2Monster122 | db 002,000,ShowBeingHitSprite,006,AnimateAttack | dw RIdle2Monster122 | db 000,InitiateAttack
Monster122AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster122 | db 000,AnimateAttack | dw LIdle2Monster122 | db 004,000,ShowBeingHitSprite,008,AnimateAttack | dw RIdle2Monster122 | db 000,InitiateAttack
Monster122AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster122 | db 000,AnimateAttack | dw RIdle2Monster122 | db 007,000,ShowBeingHitSprite,003,AnimateAttack | dw LIdle2Monster122 | db 000,InitiateAttack
Monster122AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster122 | db 000,AnimateAttack | dw RIdle2Monster122 | db 008,000,ShowBeingHitSprite,004,AnimateAttack | dw LIdle2Monster122 | db 000,InitiateAttack
Monster122AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster122 | db 000,AnimateAttack | dw RIdle2Monster122 | db 006,000,ShowBeingHitSprite,002,AnimateAttack | dw LIdle2Monster122 | db 000,InitiateAttack
;######################################################################################
;Ghosty (spooky) 

RIdle1Monster123:   equ $4000 + (128*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle2Monster123:   equ $4000 + (128*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle3Monster123:   equ $4000 + (128*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle4Monster123:   equ $4000 + (128*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster123:   equ $4000 + (160*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster123:   equ $4000 + (128*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle3Monster123:   equ $4000 + (128*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle4Monster123:   equ $4000 + (128*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster123Move:
Monster123Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster123
  dw    RIdle2Monster123
  dw    RIdle3Monster123
  dw    RIdle4Monster123
  dw    RIdle3Monster123
  dw    RIdle2Monster123
  ;facing left
  dw    LIdle1Monster123
  dw    LIdle2Monster123
  dw    LIdle3Monster123
  dw    LIdle4Monster123
  dw    LIdle3Monster123
  dw    LIdle2Monster123

;######################################################################################
;KuGyoku Den (legendly 9 gems)

RIdle1Monster124:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)
RIdle2Monster124:   equ $4000 + (000*128) + (240/2) - 128  ;(y*128) + (x/2)

LIdle1Monster124:   equ $4000 + (032*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster124:   equ $4000 + (032*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster124Move:
Monster124Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster124
  dw    RIdle2Monster124
  ;facing left
  dw    LIdle1Monster124
  dw    LIdle2Monster124

;######################################################################################
;GooGoo (quinpl)

RIdle1Monster125:   equ $4000 + (184*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster125:   equ $4000 + (184*128) + (144/2) - 128  ;(y*128) + (x/2)
Rattack1Monster125: equ $4000 + (184*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster125:   equ $4000 + (184*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster125:   equ $4000 + (184*128) + (192/2) - 128  ;(y*128) + (x/2)
Lattack1Monster125: equ $4000 + (184*128) + (176/2) - 128  ;(y*128) + (x/2)

Monster125Move:
Monster125Idle:
  db    07                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster125
  dw    RIdle2Monster125
  ;facing left
  dw    LIdle1Monster125
  dw    LIdle2Monster125
Monster125AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster125 | db 000,ShootProjectile,WaitImpactProjectile
Monster125AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster125 | db 000,ShootProjectile,WaitImpactProjectile
;######################################################################################









;sofia

RIdle1Monster126:   equ $4000 + (192*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle2Monster126:   equ $4000 + (192*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster126:   equ $4000 + (192*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster126:   equ $4000 + (192*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster126Move:
Monster126Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster126
  dw    RIdle2Monster126
  ;facing left
  dw    LIdle1Monster126
  dw    LIdle2Monster126
;######################################################################################
;Rastan (rastan saga)

RIdle1Monster127:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster127:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster127:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster127: equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack2Monster127: equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)
RAttack3Monster127: equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster127:   equ $4000 + (048*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle2Monster127:   equ $4000 + (048*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle3Monster127:   equ $4000 + (048*128) + (064/2) - 128  ;(y*128) + (x/2)
LAttack1Monster127: equ $4000 + (048*128) + (032/2) - 128  ;(y*128) + (x/2)
LAttack2Monster127: equ $4000 + (048*128) + (000/2) - 128  ;(y*128) + (x/2)
LAttack3Monster127: equ $4000 + (000*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster127Move:
Monster127Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster127
  dw    RIdle2Monster127
  dw    RIdle3Monster127
  dw    RIdle2Monster127
  ;facing left
  dw    LIdle1Monster127
  dw    LIdle2Monster127
  dw    LIdle3Monster127
  dw    LIdle2Monster127

Monster127AttackPatternRight:
  db    000,AnimateAttack | dw RAttack1Monster127 | db 0030,AnimateAttack | dw RAttack2Monster127 | db 000,AnimateAttack | dw RAttack3Monster127 | db 128+48,DisplaceRight8,ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster127 | db 128+32,DisplaceLeft8,000,AnimateAttack | dw RAttack1Monster127 | db 000,InitiateAttack
Monster127AttackPatternRightUp:
  db    008,AnimateAttack | dw RAttack1Monster127 | db 0030,AnimateAttack | dw RAttack2Monster127 | db 000,AnimateAttack | dw RAttack3Monster127 | db 128+48,DisplaceRight8,ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster127 | db 128+32,DisplaceLeft8,000,AnimateAttack | dw RAttack1Monster127 | db 004,InitiateAttack
Monster127AttackPatternRightDown:
  db    006,AnimateAttack | dw RAttack1Monster127 | db 0030,AnimateAttack | dw RAttack2Monster127 | db 000,AnimateAttack | dw RAttack3Monster127 | db 128+48,DisplaceRight8,ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster127 | db 128+32,DisplaceLeft8,000,AnimateAttack | dw RAttack1Monster127 | db 002,InitiateAttack
Monster127AttackPatternLeft:
  db    000,AnimateAttack | dw LAttack1Monster127 | db 0030,AnimateAttack | dw LAttack2Monster127 | db 000,AnimateAttack | dw LAttack3Monster127 | db 128+48,DisplaceLeft,DisplaceLeft8,ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster127 | db 128+32,DisplaceRight,DisplaceRight8,000,AnimateAttack | dw LAttack1Monster127 | db 000,InitiateAttack
Monster127AttackPatternLeftUp:
  db    002,AnimateAttack | dw LAttack1Monster127 | db 0030,AnimateAttack | dw LAttack2Monster127 | db 000,AnimateAttack | dw LAttack3Monster127 | db 128+48,DisplaceLeft,DisplaceLeft8,ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster127 | db 128+32,DisplaceRight,DisplaceRight8,000,AnimateAttack | dw LAttack1Monster127 | db 006,InitiateAttack
Monster127AttackPatternLeftDown:
  db    004,AnimateAttack | dw LAttack1Monster127 | db 0030,AnimateAttack | dw LAttack2Monster127 | db 000,AnimateAttack | dw LAttack3Monster127 | db 128+48,DisplaceLeft,DisplaceLeft8,ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster127 | db 128+32,DisplaceRight,DisplaceRight8,000,AnimateAttack | dw LAttack1Monster127 | db 008,InitiateAttack


;######################################################################################
;BlasterBot

RIdle1Monster128:   equ $4000 + (096*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster128:   equ $4000 + (096*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster128:   equ $4000 + (096*128) + (032/2) - 128  ;(y*128) + (x/2)

LIdle1Monster128:   equ $4000 + (096*128) + (080/2) - 128  ;(y*128) + (x/2)
LIdle2Monster128:   equ $4000 + (096*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle3Monster128:   equ $4000 + (096*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster128Move:
  db    08                              ;animation speed (x frames per animation frame)
  db    1                               ;amount of animation frames
  dw    RIdle2Monster128
  ;facing left
  dw    LIdle2Monster128
Monster128Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster128
  dw    RIdle2Monster128
  dw    RIdle3Monster128
  dw    RIdle2Monster128
  ;facing left
  dw    LIdle1Monster128
  dw    LIdle2Monster128
  dw    LIdle3Monster128
  dw    LIdle2Monster128
Monster128AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster128 | db 003 | db ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle3Monster128 | db 007,InitiateAttack
Monster128AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster128 | db 002 | db ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle3Monster128 | db 006,InitiateAttack
Monster128AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster128 | db 004 | db ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle3Monster128 | db 008,InitiateAttack
Monster128AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster128 | db 007 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle3Monster128 | db 003,InitiateAttack
Monster128AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster128 | db 008 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle3Monster128 | db 004,InitiateAttack
Monster128AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster128 | db 006 | db ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle3Monster128 | db 002,InitiateAttack

;######################################################################################
;Screech

RIdle1Monster129:   equ $4000 + (096*128) + (224/2) - 128  ;(y*128) + (x/2)
RIdle2Monster129:   equ $4000 + (136*128) + (192/2) - 128  ;(y*128) + (x/2)
RAttack1Monster129: equ $4000 + (136*128) + (224/2) - 128  ;(y*128) + (x/2)

LIdle1Monster129:   equ $4000 + (176*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster129:   equ $4000 + (176*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster129: equ $4000 + (176*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster129Move:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster129
  dw    RIdle2Monster129
  ;facing left
  dw    LIdle1Monster129
  dw    LIdle2Monster129
Monster129Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster129
  dw    RIdle2Monster129
  ;facing left
  dw    LIdle1Monster129
  dw    LIdle2Monster129
Monster129AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster129 | db 000,ShootProjectile,WaitImpactProjectile
Monster129AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster129 | db 000,ShootProjectile,WaitImpactProjectile  
;######################################################################################
;Schaefer (predator)

RIdle1Monster130:   equ $4000 + (176*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster130:   equ $4000 + (176*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster130:   equ $4000 + (176*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster130: equ $4000 + (176*128) + (048/2) - 128  ;(y*128) + (x/2)

LIdle1Monster130:   equ $4000 + (176*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster130:   equ $4000 + (176*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster130:   equ $4000 + (176*128) + (112/2) - 128  ;(y*128) + (x/2)
LAttack1Monster130: equ $4000 + (176*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster130Move:
Monster130Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster130
  dw    RIdle2Monster130
  dw    RIdle3Monster130
  dw    RIdle2Monster130
  ;facing left
  dw    LIdle1Monster130
  dw    LIdle2Monster130
  dw    LIdle3Monster130
  dw    LIdle2Monster130
Monster130AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster130 | db 003,AnimateAttack | dw RAttack1Monster130 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster130 | db 128+16,000,007,InitiateAttack
Monster130AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster130 | db 002,AnimateAttack | dw RAttack1Monster130 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster130 | db 128+16,000,006,InitiateAttack
Monster130AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster130 | db 004,AnimateAttack | dw RAttack1Monster130 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle1Monster130 | db 128+16,000,008,InitiateAttack
Monster130AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster130 | db 007,AnimateAttack | dw LAttack1Monster130 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle1Monster130 | db 128+16,DisplaceRight,000,003,InitiateAttack
Monster130AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster130 | db 008,AnimateAttack | dw LAttack1Monster130 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle1Monster130 | db 128+16,DisplaceRight,000,004,InitiateAttack
Monster130AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster130 | db 006,AnimateAttack | dw LAttack1Monster130 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle1Monster130 | db 128+16,DisplaceRight,000,002,InitiateAttack

;######################################################################################
;Jon Sparkle (malaya no hihou)

RIdle1Monster131:   equ $4000 + (216*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster131:   equ $4000 + (216*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster131:   equ $4000 + (216*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster131: equ $4000 + (216*128) + (048/2) - 128  ;(y*128) + (x/2)
RAttack2Monster131: equ $4000 + (216*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster131:   equ $4000 + (216*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster131:   equ $4000 + (216*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster131:   equ $4000 + (216*128) + (112/2) - 128  ;(y*128) + (x/2)
LAttack1Monster131: equ $4000 + (216*128) + (096/2) - 128  ;(y*128) + (x/2)
LAttack2Monster131: equ $4000 + (216*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster131Move:
Monster131Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster131
  dw    RIdle2Monster131
  dw    RIdle3Monster131
  dw    RIdle2Monster131
  ;facing left
  dw    LIdle1Monster131
  dw    LIdle2Monster131
  dw    LIdle3Monster131
  dw    LIdle2Monster131
Monster131AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster131 | db 003,AnimateAttack | dw RAttack1Monster131 | db 000,AnimateAttack | dw RAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster131 | db 007,InitiateAttack
Monster131AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster131 | db 002,AnimateAttack | dw RAttack1Monster131 | db 000,AnimateAttack | dw RAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster131 | db 006,InitiateAttack
Monster131AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster131 | db 004,AnimateAttack | dw RAttack1Monster131 | db 000,AnimateAttack | dw RAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster131 | db 008,InitiateAttack
Monster131AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster131 | db 007,AnimateAttack | dw LAttack1Monster131 | db 000,AnimateAttack | dw LAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster131 | db 003,InitiateAttack
Monster131AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster131 | db 008,AnimateAttack | dw LAttack1Monster131 | db 000,AnimateAttack | dw LAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster131 | db 004,InitiateAttack
Monster131AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster131 | db 006,AnimateAttack | dw LAttack1Monster131 | db 000,AnimateAttack | dw LAttack2Monster131 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster131 | db 002,InitiateAttack







;######################################################################################
;Monmon (mon mon monster)

RIdle1Monster132:   equ $4000 + (136*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster132:   equ $4000 + (136*128) + (016/2) - 128  ;(y*128) + (x/2)
RAttack1Monster132: equ $4000 + (136*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack2Monster132: equ $4000 + (136*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster132:   equ $4000 + (136*128) + (176/2) - 128  ;(y*128) + (x/2)
LIdle2Monster132:   equ $4000 + (136*128) + (160/2) - 128  ;(y*128) + (x/2)
LAttack1Monster132: equ $4000 + (136*128) + (128/2) - 128  ;(y*128) + (x/2)
LAttack2Monster132: equ $4000 + (136*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster132Move:
Monster132Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster132
  dw    RIdle2Monster132
  ;facing left
  dw    LIdle1Monster132
  dw    LIdle2Monster132
Monster132AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster132 | db 000,AnimateAttack | dw RAttack1Monster132 | db 128+32,000,AnimateAttack | dw RAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster132 | db 128+16,000,InitiateAttack
Monster132AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster132 | db 008,AnimateAttack | dw RAttack1Monster132 | db 128+32,000,AnimateAttack | dw RAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster132 | db 128+16,004,InitiateAttack
Monster132AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster132 | db 006,AnimateAttack | dw RAttack1Monster132 | db 128+32,000,AnimateAttack | dw RAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster132 | db 128+16,002,InitiateAttack
Monster132AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster132 | db 000,AnimateAttack | dw LAttack1Monster132 | db 128+32,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster132 | db 128+16,DisplaceRight,000,InitiateAttack
Monster132AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster132 | db 002,AnimateAttack | dw LAttack1Monster132 | db 128+32,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster132 | db 128+16,DisplaceRight,006,InitiateAttack
Monster132AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster132 | db 004,AnimateAttack | dw LAttack1Monster132 | db 128+32,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster132 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster132 | db 128+16,DisplaceRight,008,InitiateAttack

;######################################################################################
;Cob Crusher (mon mon monster)

RIdle1Monster133:   equ $4000 + (096*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle2Monster133:   equ $4000 + (096*128) + (112/2) - 128  ;(y*128) + (x/2)
RAttack1Monster133: equ $4000 + (096*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster133:   equ $4000 + (096*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster133:   equ $4000 + (096*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack1Monster133: equ $4000 + (096*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster133Move:
Monster133Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster133
  dw    RIdle2Monster133
  ;facing left
  dw    LIdle1Monster133
  dw    LIdle2Monster133
Monster133AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster133 | db 000,AnimateAttack | dw RAttack1Monster133 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster133 | db 128+16,000,InitiateAttack
Monster133AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster133 | db 008,AnimateAttack | dw RAttack1Monster133 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster133 | db 128+16,004,InitiateAttack
Monster133AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster133 | db 006,AnimateAttack | dw RAttack1Monster133 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster133 | db 128+16,002,InitiateAttack
Monster133AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster133 | db 000,AnimateAttack | dw LAttack1Monster133 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster133 | db 128+16,DisplaceRight,000,InitiateAttack
Monster133AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster133 | db 002,AnimateAttack | dw LAttack1Monster133 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster133 | db 128+16,DisplaceRight,006,InitiateAttack
Monster133AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster133 | db 004,AnimateAttack | dw LAttack1Monster133 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster133 | db 128+16,DisplaceRight,008,InitiateAttack

;######################################################################################
;Limb Linger (mon mon monster)

RIdle1Monster134:   equ $4000 + (192*128) + (240/2) - 128  ;(y*128) + (x/2)
RIdle2Monster134:   equ $4000 + (224*128) + (144/2) - 128  ;(y*128) + (x/2)
RAttack1Monster134: equ $4000 + (224*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster134:   equ $4000 + (224*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster134:   equ $4000 + (224*128) + (224/2) - 128  ;(y*128) + (x/2)
LAttack1Monster134: equ $4000 + (224*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster134Move:
Monster134Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster134
  dw    RIdle2Monster134
  ;facing left
  dw    LIdle1Monster134
  dw    LIdle2Monster134
Monster134AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster134 | db 000,AnimateAttack | dw RAttack1Monster134 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster134 | db 128+16,000,InitiateAttack
Monster134AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster134 | db 008,AnimateAttack | dw RAttack1Monster134 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster134 | db 128+16,004,InitiateAttack
Monster134AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster134 | db 006,AnimateAttack | dw RAttack1Monster134 | db 128+32,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster134 | db 128+16,002,InitiateAttack
Monster134AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster134 | db 000,AnimateAttack | dw LAttack1Monster134 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster134 | db 128+16,DisplaceRight,000,InitiateAttack
Monster134AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster134 | db 002,AnimateAttack | dw LAttack1Monster134 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster134 | db 128+16,DisplaceRight,006,InitiateAttack
Monster134AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster134 | db 004,AnimateAttack | dw LAttack1Monster134 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster134 | db 128+16,DisplaceRight,008,InitiateAttack

;######################################################################################
;deva (deva)

RIdle1Monster135:   equ $4000 + (080*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster135:   equ $4000 + (080*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster135:   equ $4000 + (080*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle4Monster135:   equ $4000 + (080*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle5Monster135:   equ $4000 + (080*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle6Monster135:   equ $4000 + (080*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster135: equ $4000 + (080*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster135:   equ $4000 + (128*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster135:   equ $4000 + (128*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle3Monster135:   equ $4000 + (128*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle4Monster135:   equ $4000 + (128*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle5Monster135:   equ $4000 + (128*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle6Monster135:   equ $4000 + (128*128) + (032/2) - 128  ;(y*128) + (x/2)
LAttack1Monster135: equ $4000 + (128*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster135Move:
Monster135Idle:
  db    02                              ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster135
  dw    RIdle2Monster135
  dw    RIdle3Monster135
  dw    RIdle4Monster135
  dw    RIdle5Monster135
  dw    RIdle6Monster135
  ;facing left
  dw    LIdle1Monster135
  dw    LIdle2Monster135
  dw    LIdle3Monster135
  dw    LIdle4Monster135
  dw    LIdle5Monster135
  dw    LIdle6Monster135
Monster135AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster135 | db 003,AnimateAttack | dw RAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster135 | db 007,InitiateAttack
Monster135AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster135 | db 008,AnimateAttack | dw RAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster135 | db 004,InitiateAttack
Monster135AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster135 | db 006,AnimateAttack | dw RAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw RIdle2Monster135 | db 002,InitiateAttack
Monster135AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster135 | db 007,AnimateAttack | dw LAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster135 | db 003,InitiateAttack
Monster135AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster135 | db 008,AnimateAttack | dw LAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster135 | db 004,InitiateAttack
Monster135AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster135 | db 006,AnimateAttack | dw LAttack1Monster135 | db 000,ShowBeingHitSprite,000,000,000,AnimateAttack | dw LIdle2Monster135 | db 002,InitiateAttack

;######################################################################################
;Spectroll (deva)

RIdle1Monster136:   equ $4000 + (136*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster136:   equ $4000 + (184*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle3Monster136:   equ $4000 + (184*128) + (016/2) - 128  ;(y*128) + (x/2)
RAttack1Monster136: equ $4000 + (136*128) + (016/2) - 128  ;(y*128) + (x/2)
RAttack2Monster136: equ $4000 + (136*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack3Monster136: equ $4000 + (136*128) + (048/2) - 128  ;(y*128) + (x/2)
RAttack4Monster136: equ $4000 + (136*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster136:   equ $4000 + (136*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster136:   equ $4000 + (184*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle3Monster136:   equ $4000 + (184*128) + (032/2) - 128  ;(y*128) + (x/2)
LAttack1Monster136: equ $4000 + (136*128) + (128/2) - 128  ;(y*128) + (x/2)
LAttack2Monster136: equ $4000 + (136*128) + (112/2) - 128  ;(y*128) + (x/2)
LAttack3Monster136: equ $4000 + (136*128) + (096/2) - 128  ;(y*128) + (x/2)
LAttack4Monster136: equ $4000 + (136*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster136Move:
Monster136Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster136
  dw    RIdle2Monster136
  dw    RIdle1Monster136
  dw    RIdle3Monster136
  ;facing left
  dw    LIdle1Monster136
  dw    LIdle2Monster136
  dw    LIdle1Monster136
  dw    LIdle3Monster136
Monster136AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack4Monster136 | db 003,003,ShowBeingHitSprite,000,007,007,000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,InitiateAttack
Monster136AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack4Monster136 | db 002,002,ShowBeingHitSprite,000,006,006,000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,InitiateAttack
Monster136AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack4Monster136 | db 004,004,ShowBeingHitSprite,000,008,008,000,AnimateAttack | dw RAttack3Monster136 | db 000,AnimateAttack | dw RAttack2Monster136 | db 000,AnimateAttack | dw RAttack1Monster136 | db 000,InitiateAttack
Monster136AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack4Monster136 | db 007,007,ShowBeingHitSprite,000,003,003,000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,InitiateAttack
Monster136AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack4Monster136 | db 008,008,ShowBeingHitSprite,000,004,004,000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,InitiateAttack
Monster136AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack4Monster136 | db 006,006,ShowBeingHitSprite,000,002,002,000,AnimateAttack | dw LAttack3Monster136 | db 000,AnimateAttack | dw LAttack2Monster136 | db 000,AnimateAttack | dw LAttack1Monster136 | db 000,InitiateAttack

;######################################################################################
;Yurei Kage (deva)

RIdle1Monster137:   equ $4000 + (088*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster137:   equ $4000 + (144*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle3Monster137:   equ $4000 + (200*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster137:   equ $4000 + (088*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster137:   equ $4000 + (144*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster137:   equ $4000 + (200*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster137Move:
Monster137Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster137
  dw    RIdle2Monster137
  dw    RIdle3Monster137
  ;facing left
  dw    LIdle1Monster137
  dw    LIdle2Monster137
  dw    LIdle3Monster137

;######################################################################################
;Blob (usas2)

RIdle1Monster138:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster138:   equ $4000 + (000*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle3Monster138:   equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle4Monster138:   equ $4000 + (000*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle5Monster138:   equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle6Monster138:   equ $4000 + (048*128) + (000/2) - 128  ;(y*128) + (x/2)

LIdle1Monster138:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle2Monster138:   equ $4000 + (000*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle3Monster138:   equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle4Monster138:   equ $4000 + (000*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle5Monster138:   equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle6Monster138:   equ $4000 + (048*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster138Move:
Monster138Idle:
  db    02                              ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle6Monster138
  dw    RIdle1Monster138
  dw    RIdle2Monster138
  dw    RIdle3Monster138
  dw    RIdle4Monster138
  dw    RIdle5Monster138
  ;facing left
  dw    LIdle6Monster138
  dw    LIdle1Monster138
  dw    LIdle2Monster138
  dw    LIdle3Monster138
  dw    LIdle4Monster138
  dw    LIdle5Monster138

;######################################################################################
;Emir Mystic (usas2)

RIdle1Monster139:   equ $4000 + (096*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster139:   equ $4000 + (096*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster139:   equ $4000 + (096*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle4Monster139:   equ $4000 + (096*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle5Monster139:   equ $4000 + (096*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle6Monster139:   equ $4000 + (096*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle7Monster139:   equ $4000 + (136*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle8Monster139:   equ $4000 + (136*128) + (032/2) - 128  ;(y*128) + (x/2)
Rattack1Monster139: equ $4000 + (136*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster139:   equ $4000 + (176*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster139:   equ $4000 + (176*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster139:   equ $4000 + (176*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle4Monster139:   equ $4000 + (176*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle5Monster139:   equ $4000 + (176*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle6Monster139:   equ $4000 + (176*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle7Monster139:   equ $4000 + (216*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle8Monster139:   equ $4000 + (216*128) + (128/2) - 128  ;(y*128) + (x/2)
Lattack1Monster139: equ $4000 + (216*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster139Move:
Monster139Idle:
  db    02                              ;animation speed (x frames per animation frame)
  db    8                               ;amount of animation frames
  dw    RIdle1Monster139
  dw    RIdle2Monster139
  dw    RIdle3Monster139
  dw    RIdle4Monster139
  dw    RIdle5Monster139
  dw    RIdle6Monster139
  dw    RIdle7Monster139
  dw    RIdle8Monster139
  ;facing left
  dw    LIdle1Monster139
  dw    LIdle2Monster139
  dw    LIdle3Monster139
  dw    LIdle4Monster139
  dw    LIdle5Monster139
  dw    LIdle6Monster139
  dw    LIdle7Monster139
  dw    LIdle8Monster139
Monster139AttackPatternRight:
  db    000,AnimateAttack | dw Rattack1Monster139 | db 128+48,000,003,000,ShowBeingHitSprite,007,000,AnimateAttack | dw RIdle1Monster139 | db 128+32,InitiateAttack
Monster139AttackPatternRightUp:
  db    000,AnimateAttack | dw Rattack1Monster139 | db 128+48,000,002,000,ShowBeingHitSprite,006,000,AnimateAttack | dw RIdle1Monster139 | db 128+32,InitiateAttack
Monster139AttackPatternRightDown:
  db    000,AnimateAttack | dw Rattack1Monster139 | db 128+48,000,004,000,ShowBeingHitSprite,008,000,AnimateAttack | dw RIdle1Monster139 | db 128+32,InitiateAttack
Monster139AttackPatternLeft:
  db    000,AnimateAttack | dw Lattack1Monster139 | db 128+48,DisplaceLeft,000,007,000,ShowBeingHitSprite,003,000,AnimateAttack | dw LIdle1Monster139 | db 128+32,DisplaceRight,InitiateAttack
Monster139AttackPatternLeftUp:
  db    000,AnimateAttack | dw Lattack1Monster139 | db 128+48,DisplaceLeft,000,008,000,ShowBeingHitSprite,004,000,AnimateAttack | dw LIdle1Monster139 | db 128+32,DisplaceRight,InitiateAttack
Monster139AttackPatternLeftDown:
  db    000,AnimateAttack | dw Lattack1Monster139 | db 128+48,DisplaceLeft,000,006,000,ShowBeingHitSprite,002,000,AnimateAttack | dw LIdle1Monster139 | db 128+32,DisplaceRight,InitiateAttack
;######################################################################################
;duncan seven (core dump)

RIdle1Monster140:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster140:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster140:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster140: equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
RAttack2Monster140: equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster140:   equ $4000 + (040*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster140:   equ $4000 + (040*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle3Monster140:   equ $4000 + (040*128) + (128/2) - 128  ;(y*128) + (x/2)
LAttack1Monster140: equ $4000 + (040*128) + (064/2) - 128  ;(y*128) + (x/2)
LAttack2Monster140: equ $4000 + (040*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster140Move:
Monster140Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster140
  dw    RIdle3Monster140
  dw    RIdle2Monster140
  dw    RIdle3Monster140
  ;facing left
  dw    LIdle1Monster140
  dw    LIdle3Monster140
  dw    LIdle2Monster140
  dw    LIdle3Monster140
Monster140AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster140 | db 000,AnimateAttack | dw RAttack1Monster140 | db 128+64,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RIdle1Monster140 | db 128+32,000,InitiateAttack
Monster140AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster140 | db 008,AnimateAttack | dw RAttack1Monster140 | db 128+64,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RIdle1Monster140 | db 128+32,004,InitiateAttack
Monster140AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster140 | db 006,AnimateAttack | dw RAttack1Monster140 | db 128+64,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw RAttack2Monster140 | db 000,AnimateAttack | dw RIdle1Monster140 | db 128+32,002,InitiateAttack
Monster140AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster140 | db 000,AnimateAttack | dw LAttack1Monster140 | db 128+64,DisplaceLeft,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LIdle1Monster140 | db 128+32,DisplaceRight,DisplaceRight,000,InitiateAttack
Monster140AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster140 | db 002,AnimateAttack | dw LAttack1Monster140 | db 128+64,DisplaceLeft,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LIdle1Monster140 | db 128+32,DisplaceRight,DisplaceRight,006,InitiateAttack
Monster140AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster140 | db 004,AnimateAttack | dw LAttack1Monster140 | db 128+64,DisplaceLeft,DisplaceLeft,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LAttack1Monster140 | db ShowBeingHitSprite,000,AnimateAttack | dw LAttack2Monster140 | db 000,AnimateAttack | dw LIdle1Monster140 | db 128+32,DisplaceRight,DisplaceRight,008,InitiateAttack

;######################################################################################
;Monstrilla (core dump)

RIdle1Monster141:   equ $4000 + (068*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster141:   equ $4000 + (068*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster141:   equ $4000 + (068*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster141:   equ $4000 + (068*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster141Move:
Monster141Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster141
  dw    RIdle2Monster141
  ;facing left
  dw    LIdle1Monster141
  dw    LIdle2Monster141

;######################################################################################
;Biolumia (core dump)

RIdle1Monster142:   equ $4000 + (136*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster142:   equ $4000 + (136*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle3Monster142:   equ $4000 + (136*128) + (224/2) - 128  ;(y*128) + (x/2)

LIdle1Monster142:   equ $4000 + (136*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster142:   equ $4000 + (136*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster142:   equ $4000 + (136*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster142Move:
Monster142Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster142
  dw    RIdle2Monster142
  dw    RIdle3Monster142
  ;facing left
  dw    LIdle1Monster142
  dw    LIdle2Monster142
  dw    LIdle3Monster142

;######################################################################################
;Anna Lee (cabage patch kids)

RIdle1Monster143:   equ $4000 + (176*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster143:   equ $4000 + (176*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster143:   equ $4000 + (176*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster143: equ $4000 + (176*128) + (048/2) - 128  ;(y*128) + (x/2)

LIdle1Monster143:   equ $4000 + (176*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster143:   equ $4000 + (176*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle3Monster143:   equ $4000 + (176*128) + (080/2) - 128  ;(y*128) + (x/2)
LAttack1Monster143: equ $4000 + (176*128) + (064/2) - 128  ;(y*128) + (x/2)

Monster143Move:
Monster143Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster143
  dw    RIdle2Monster143
  dw    RIdle1Monster143
  dw    RIdle3Monster143
  ;facing left
  dw    LIdle1Monster143
  dw    LIdle2Monster143
  dw    LIdle1Monster143
  dw    LIdle3Monster143
Monster143AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster143 | db 003,000,ShowBeingHitSprite,000,007,InitiateAttack
Monster143AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster143 | db 002,000,ShowBeingHitSprite,000,006,InitiateAttack
Monster143AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster143 | db 004,000,ShowBeingHitSprite,000,008,InitiateAttack
Monster143AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster143 | db 007,000,ShowBeingHitSprite,000,003,InitiateAttack
Monster143AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster143 | db 008,000,ShowBeingHitSprite,000,004,InitiateAttack
Monster143AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster143 | db 006,000,ShowBeingHitSprite,000,002,InitiateAttack

;######################################################################################
;Pastry Chef (comic bakery)

RIdle1Monster144:   equ $4000 + (216*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle2Monster144:   equ $4000 + (216*128) + (048/2) - 128  ;(y*128) + (x/2)
RAttack1Monster144: equ $4000 + (216*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster144:   equ $4000 + (216*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster144:   equ $4000 + (216*128) + (096/2) - 128  ;(y*128) + (x/2)
LAttack1Monster144: equ $4000 + (216*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster144Move:
Monster144Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster144
  dw    RIdle2Monster144
  ;facing left
  dw    LIdle1Monster144
  dw    LIdle2Monster144
Monster144AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster144 | db 000,ShootProjectile,000,WaitImpactProjectile
Monster144AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster144 | db 000,ShootProjectile,000,WaitImpactProjectile

;######################################################################################
;Indy Brave (magical tree)

RIdle1Monster145:   equ $4000 + (216*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster145:   equ $4000 + (216*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle3Monster145:   equ $4000 + (216*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster145: equ $4000 + (216*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster145:   equ $4000 + (216*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster145:   equ $4000 + (216*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster145:   equ $4000 + (216*128) + (208/2) - 128  ;(y*128) + (x/2)
LAttack1Monster145: equ $4000 + (216*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster145Move:
Monster145Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster145
  dw    RIdle2Monster145
  dw    RIdle3Monster145
  ;facing left
  dw    LIdle1Monster145
  dw    LIdle2Monster145
  dw    LIdle3Monster145
Monster145AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster145 | db 003,000,ShowBeingHitSprite,000,007,InitiateAttack
Monster145AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster145 | db 002,000,ShowBeingHitSprite,000,006,InitiateAttack
Monster145AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster145 | db 004,000,ShowBeingHitSprite,000,008,InitiateAttack
Monster145AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster145 | db 007,000,ShowBeingHitSprite,000,003,InitiateAttack
Monster145AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster145 | db 008,000,ShowBeingHitSprite,000,004,InitiateAttack
Monster145AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster145 | db 006,000,ShowBeingHitSprite,000,002,InitiateAttack



;######################################################################################
;Red Lupin (arsene lupin)

RIdle1Monster146:   equ $4000 + (176*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster146:   equ $4000 + (176*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle3Monster146:   equ $4000 + (176*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster146:   equ $4000 + (176*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster146:   equ $4000 + (176*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster146:   equ $4000 + (176*128) + (176/2) - 128  ;(y*128) + (x/2)

Monster146Move:
Monster146Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster146
  dw    RIdle2Monster146
  dw    RIdle3Monster146
  ;facing left
  dw    LIdle1Monster146
  dw    LIdle2Monster146
  dw    LIdle3Monster146

;######################################################################################
;Green Lupin (arsene lupin)

RIdle1Monster147:   equ $4000 + (216*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster147:   equ $4000 + (216*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle3Monster147:   equ $4000 + (216*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster147:   equ $4000 + (216*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster147:   equ $4000 + (216*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster147:   equ $4000 + (216*128) + (208/2) - 128  ;(y*128) + (x/2)

Monster147Move:
Monster147Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster147
  dw    RIdle2Monster147
  dw    RIdle3Monster147
  ;facing left
  dw    LIdle1Monster147
  dw    LIdle2Monster147
  dw    LIdle3Monster147

;######################################################################################
;Major Mirth (arsene lupin)

RIdle1Monster148:   equ $4000 + (176*128) + (224/2) - 128  ;(y*128) + (x/2)
RIdle2Monster148:   equ $4000 + (176*128) + (240/2) - 128  ;(y*128) + (x/2)

LIdle1Monster148:   equ $4000 + (216*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle2Monster148:   equ $4000 + (216*128) + (016/2) - 128  ;(y*128) + (x/2)

Monster148Move:
Monster148Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster148
  dw    RIdle2Monster148
  ;facing left
  dw    LIdle1Monster148
  dw    LIdle2Monster148

;######################################################################################
;Vic Viper (kings valley 2)

RIdle1Monster149:   equ $4000 + (048*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster149:   equ $4000 + (048*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle3Monster149:   equ $4000 + (048*128) + (192/2) - 128  ;(y*128) + (x/2)
RAttack1Monster149: equ $4000 + (048*128) + (208/2) - 128  ;(y*128) + (x/2)
RAttack2Monster149: equ $4000 + (048*128) + (224/2) - 128  ;(y*128) + (x/2)
RAttack3Monster149: equ $4000 + (048*128) + (240/2) - 128  ;(y*128) + (x/2)

LIdle1Monster149:   equ $4000 + (072*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster149:   equ $4000 + (072*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster149:   equ $4000 + (072*128) + (208/2) - 128  ;(y*128) + (x/2)
LAttack1Monster149: equ $4000 + (072*128) + (192/2) - 128  ;(y*128) + (x/2)
LAttack2Monster149: equ $4000 + (072*128) + (176/2) - 128  ;(y*128) + (x/2)
LAttack3Monster149: equ $4000 + (072*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster149Move:
Monster149Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster149
  dw    RIdle2Monster149
  dw    RIdle3Monster149
  ;facing left
  dw    LIdle1Monster149
  dw    LIdle2Monster149
  dw    LIdle3Monster149

Monster149AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster149 | db 000,000,000,AnimateAttack | dw Rattack2Monster149 | db 000,000,000,AnimateAttack | dw Rattack3Monster149 | db 000,ShootProjectile,WaitImpactProjectile
Monster149AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster149 | db 000,000,000,AnimateAttack | dw Lattack2Monster149 | db 000,000,000,AnimateAttack | dw Lattack3Monster149 | db 000,ShootProjectile,WaitImpactProjectile

;######################################################################################
;Rock Roll (kings valley 2)

RIdle1Monster150:   equ $4000 + (208*128) + (128/2) - 128  ;(y*128) + (x/2)
RAttack1Monster150: equ $4000 + (208*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster150:   equ $4000 + (208*128) + (144/2) - 128  ;(y*128) + (x/2)
LAttack1Monster150: equ $4000 + (208*128) + (176/2) - 128  ;(y*128) + (x/2)

Monster150Move:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RAttack1Monster150
  dw    LAttack1Monster150
  ;facing left
  dw    LAttack1Monster150
  dw    RAttack1Monster150

Monster150Idle:
  db    10                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster150
  dw    LIdle1Monster150
  ;facing left
  dw    LIdle1Monster150
  dw    RIdle1Monster150

Monster150AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster150 | db 000,003,ShowBeingHitSprite,007,000,InitiateAttack
Monster150AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster150 | db 000,007,ShowBeingHitSprite,003,000,InitiateAttack
Monster150AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster150 | db 000,008,ShowBeingHitSprite,004,000,InitiateAttack
Monster150AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster150 | db 000,006,ShowBeingHitSprite,002,000,InitiateAttack
Monster150AttackPatternRightUp:
  db    AnimateAttack | dw Rattack1Monster150 | db 000,002,ShowBeingHitSprite,006,000,InitiateAttack
Monster150AttackPatternRightDown:
  db    AnimateAttack | dw Rattack1Monster150 | db 000,004,ShowBeingHitSprite,008,000,InitiateAttack

;######################################################################################
;Slouman (kings valley 2)

RIdle1Monster151:   equ $4000 + (232*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster151:   equ $4000 + (232*128) + (144/2) - 128  ;(y*128) + (x/2)

LIdle1Monster151:   equ $4000 + (232*128) + (176/2) - 128  ;(y*128) + (x/2)
LIdle2Monster151:   equ $4000 + (232*128) + (160/2) - 128  ;(y*128) + (x/2)

Monster151Move:
Monster151Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster151
  dw    RIdle2Monster151
  ;facing left
  dw    LIdle1Monster151
  dw    LIdle2Monster151

;######################################################################################
;Pyoncy (kings valley 2)

RIdle1Monster152:   equ $4000 + (208*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster152:   equ $4000 + (208*128) + (208/2) - 128  ;(y*128) + (x/2)

LIdle1Monster152:   equ $4000 + (208*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster152:   equ $4000 + (208*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster152Move:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster152
  dw    RIdle2Monster152
  ;facing left
  dw    LIdle1Monster152
  dw    LIdle2Monster152

Monster152Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    3                               ;amount of animation frames
  dw    RIdle1Monster152
  dw    RIdle1Monster152
  dw    RIdle2Monster152
  ;facing left
  dw    LIdle1Monster152
  dw    LIdle1Monster152
  dw    LIdle2Monster152

Monster152AttackPatternRight:
  db    AnimateAttack | dw RIdle2Monster152 | db 000,003,ShowBeingHitSprite,007,000,InitiateAttack
Monster152AttackPatternLeft:
  db    AnimateAttack | dw LIdle2Monster152 | db 000,007,ShowBeingHitSprite,003,000,InitiateAttack
Monster152AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle2Monster152 | db 000,008,ShowBeingHitSprite,004,000,InitiateAttack
Monster152AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle2Monster152 | db 000,006,ShowBeingHitSprite,002,000,InitiateAttack
Monster152AttackPatternRightUp:
  db    AnimateAttack | dw RIdle2Monster152 | db 000,002,ShowBeingHitSprite,006,000,InitiateAttack
Monster152AttackPatternRightDown:
  db    AnimateAttack | dw RIdle2Monster152 | db 000,004,ShowBeingHitSprite,008,000,InitiateAttack

;######################################################################################
;Andorogynus (Andorogynus)

RIdle1Monster153:   equ $4000 + (208*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster153:   equ $4000 + (208*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster153:   equ $4000 + (208*128) + (032/2) - 128  ;(y*128) + (x/2)
RAttack1Monster153: equ $4000 + (208*128) + (048/2) - 128  ;(y*128) + (x/2)

LIdle1Monster153:   equ $4000 + (208*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster153:   equ $4000 + (208*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle3Monster153:   equ $4000 + (208*128) + (080/2) - 128  ;(y*128) + (x/2)
LAttack1Monster153: equ $4000 + (208*128) + (064/2) - 128  ;(y*128) + (x/2)

Monster153Move:
Monster153Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster153
  dw    RIdle2Monster153
  dw    RIdle3Monster153
  dw    RIdle2Monster153
  ;facing left
  dw    LIdle1Monster153
  dw    LIdle2Monster153
  dw    LIdle3Monster153
  dw    LIdle2Monster153

Monster153AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster153 | db 000,ShootProjectile,000,000,000,AnimateAttack | dw RIdle2Monster153 | db WaitImpactProjectile
Monster153AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster153 | db 000,ShootProjectile,000,000,000,AnimateAttack | dw LIdle2Monster153 | db WaitImpactProjectile
;######################################################################################
;Thexder (Thexder)

RIdle1Monster154:   equ $4000 + (168*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster154:   equ $4000 + (168*128) + (208/2) - 128  ;(y*128) + (x/2)

LIdle1Monster154:   equ $4000 + (168*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster154:   equ $4000 + (168*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster154Move:
Monster154Idle:
  db    09                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster154
  dw    RIdle2Monster154
  ;facing left
  dw    LIdle1Monster154
  dw    LIdle2Monster154

;######################################################################################
;BounceBot (Thexder)

RIdle1Monster155:   equ $4000 + (232*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster155:   equ $4000 + (232*128) + (208/2) - 128  ;(y*128) + (x/2)

LIdle1Monster155:   equ $4000 + (232*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster155:   equ $4000 + (232*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster155Move:
Monster155Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster155
  dw    RIdle2Monster155
  ;facing left
  dw    LIdle1Monster155
  dw    LIdle2Monster155

;######################################################################################
;ColossalBot (Thexder)

RIdle1Monster156:   equ $4000 + (160*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster156:   equ $4000 + (160*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster156:   equ $4000 + (192*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster156:   equ $4000 + (160*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster156Move:
Monster156Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster156
  dw    RIdle2Monster156
  ;facing left
  dw    LIdle1Monster156
  dw    LIdle2Monster156

;######################################################################################
;SuperRunner (SuperRunner)

RIdle1Monster157:   equ $4000 + (136*128) + (112/2) - 128  ;(y*128) + (x/2)
RIdle2Monster157:   equ $4000 + (136*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle3Monster157:   equ $4000 + (136*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle4Monster157:   equ $4000 + (136*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster157: equ $4000 + (136*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster157:   equ $4000 + (216*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle2Monster157:   equ $4000 + (216*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle3Monster157:   equ $4000 + (216*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle4Monster157:   equ $4000 + (216*128) + (016/2) - 128  ;(y*128) + (x/2)
LAttack1Monster157: equ $4000 + (216*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster157Move:
Monster157Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster157
  dw    RIdle2Monster157
  dw    RIdle4Monster157
  dw    RIdle3Monster157
  ;facing left
  dw    LIdle1Monster157
  dw    LIdle2Monster157
  dw    LIdle4Monster157
  dw    LIdle3Monster157
Monster157AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster157 | db 000,003,ShowBeingHitSprite,007,000,InitiateAttack
Monster157AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster157 | db 000,007,ShowBeingHitSprite,003,000,InitiateAttack
Monster157AttackPatternLeftUp:
  db    AnimateAttack | dw LAttack1Monster157 | db 000,008,ShowBeingHitSprite,004,000,InitiateAttack
Monster157AttackPatternLeftDown:
  db    AnimateAttack | dw LAttack1Monster157 | db 000,006,ShowBeingHitSprite,002,000,InitiateAttack
Monster157AttackPatternRightUp:
  db    AnimateAttack | dw RAttack1Monster157 | db 000,002,ShowBeingHitSprite,006,000,InitiateAttack
Monster157AttackPatternRightDown:
  db    AnimateAttack | dw RAttack1Monster157 | db 000,004,ShowBeingHitSprite,008,000,InitiateAttack

 
 
 
;######################################################################################
;Queen Sora (green bird) (akanbe dragon)

RIdle1Monster158:   equ $4000 + (224*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster158:   equ $4000 + (224*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster158:   equ $4000 + (224*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster158: equ $4000 + (224*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster158:   equ $4000 + (224*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster158:   equ $4000 + (224*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster158:   equ $4000 + (224*128) + (160/2) - 128  ;(y*128) + (x/2)
LAttack1Monster158: equ $4000 + (224*128) + (128/2) - 128  ;(y*128) + (x/2)

Monster158Move:
Monster158Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster158
  dw    RIdle2Monster158
  dw    RIdle1Monster158
  dw    RIdle3Monster158
  ;facing left
  dw    LIdle1Monster158
  dw    LIdle2Monster158
  dw    LIdle1Monster158
  dw    LIdle3Monster158
Monster158AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster158 | db 000,ShootProjectile,WaitImpactProjectile
Monster158AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster158 | db 000,ShootProjectile,WaitImpactProjectile
 

;######################################################################################
;Senko Kyu (shooting head) (hinotori)

RIdle1Monster159:   equ $4000 + (176*128) + (224/2) - 128  ;(y*128) + (x/2)
RAttack1Monster159: equ $4000 + (176*128) + (240/2) - 128  ;(y*128) + (x/2)

LIdle1Monster159:   equ $4000 + (176*128) + (224/2) - 128  ;(y*128) + (x/2)
LAttack1Monster159: equ $4000 + (176*128) + (240/2) - 128  ;(y*128) + (x/2)

Monster159Move:
Monster159Idle:
  db    10                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster159
  dw    RAttack1Monster159
  ;facing left
  dw    LIdle1Monster159
  dw    LAttack1Monster159
Monster159AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster159 | db 000,ShootProjectile,WaitImpactProjectile
Monster159AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster159 | db 000,ShootProjectile,WaitImpactProjectile
 
;######################################################################################
;Chucklehook (higemaru)

RIdle1Monster160:   equ $4000 + (200*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster160:   equ $4000 + (200*128) + (208/2) - 128  ;(y*128) + (x/2)

LIdle1Monster160:   equ $4000 + (200*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster160:   equ $4000 + (200*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster160Move:
Monster160Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster160
  dw    RIdle2Monster160
  ;facing left
  dw    LIdle1Monster160
  dw    LIdle2Monster160

;######################################################################################
;Sir Oji (castle excellent)

RIdle1Monster161:   equ $4000 + (184*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster161:   equ $4000 + (184*128) + (080/2) - 128  ;(y*128) + (x/2)

LIdle1Monster161:   equ $4000 + (184*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster161:   equ $4000 + (184*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster161Move:
Monster161Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster161
  dw    RIdle2Monster161
  ;facing left
  dw    LIdle1Monster161
  dw    LIdle2Monster161

;######################################################################################
;Pentaro (parodius)

RIdle1Monster162:   equ $4000 + (232*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster162:   equ $4000 + (232*128) + (016/2) - 128  ;(y*128) + (x/2)

LIdle1Monster162:   equ $4000 + (232*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle2Monster162:   equ $4000 + (232*128) + (032/2) - 128  ;(y*128) + (x/2)

Monster162Move:
Monster162Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster162
  dw    RIdle2Monster162
  ;facing left
  dw    LIdle1Monster162
  dw    LIdle2Monster162

;######################################################################################
;Moai (parodius)

RIdle1Monster163:   equ $4000 + (208*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster163:   equ $4000 + (208*128) + (080/2) - 128  ;(y*128) + (x/2)
RIdle3Monster163:   equ $4000 + (232*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle4Monster163:   equ $4000 + (232*128) + (080/2) - 128  ;(y*128) + (x/2)

LIdle1Monster163:   equ $4000 + (232*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle2Monster163:   equ $4000 + (208*128) + (080/2) - 128  ;(y*128) + (x/2)
LIdle3Monster163:   equ $4000 + (208*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle4Monster163:   equ $4000 + (232*128) + (080/2) - 128  ;(y*128) + (x/2)

Monster163Move:
Monster163Idle:
  db    05                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster163
  dw    RIdle2Monster163
  dw    RIdle3Monster163
  dw    RIdle4Monster163
  ;facing left
  dw    LIdle1Monster163
  dw    LIdle2Monster163
  dw    LIdle3Monster163
  dw    LIdle4Monster163

;######################################################################################
;Thomas (kung fu master)

RIdle1Monster164:   equ $4000 + (208*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle2Monster164:   equ $4000 + (208*128) + (112/2) - 128  ;(y*128) + (x/2)
RIdle3Monster164:   equ $4000 + (208*128) + (128/2) - 128  ;(y*128) + (x/2)
RAttack1Monster164: equ $4000 + (208*128) + (144/2) - 128  ;(y*128) + (x/2)

LIdle1Monster164:   equ $4000 + (208*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster164:   equ $4000 + (208*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster164:   equ $4000 + (208*128) + (208/2) - 128  ;(y*128) + (x/2)
LAttack1Monster164: equ $4000 + (208*128) + (176/2) - 128  ;(y*128) + (x/2)

Monster164Move:
Monster164Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster164
  dw    RIdle2Monster164
  dw    RIdle3Monster164
  dw    RIdle2Monster164
  ;facing left
  dw    LIdle1Monster164
  dw    LIdle2Monster164
  dw    LIdle3Monster164
  dw    LIdle2Monster164

Monster164AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster164 | db 000,003,AnimateAttack | dw RAttack1Monster164 | db 128+32,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle1Monster164 | db 128+16,007,000,InitiateAttack
Monster164AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster164 | db 000,002,AnimateAttack | dw RAttack1Monster164 | db 128+32,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle1Monster164 | db 128+16,006,000,InitiateAttack
Monster164AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster164 | db 000,004,AnimateAttack | dw RAttack1Monster164 | db 128+32,000,ShowBeingHitSprite,000,000,AnimateAttack | dw RIdle1Monster164 | db 128+16,008,000,InitiateAttack
Monster164AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster164 | db 000,007,AnimateAttack | dw LAttack1Monster164 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster164 | db 128+16,DisplaceRight,003,000,InitiateAttack
Monster164AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster164 | db 000,008,AnimateAttack | dw LAttack1Monster164 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster164 | db 128+16,DisplaceRight,004,000,InitiateAttack
Monster164AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster164 | db 000,006,AnimateAttack | dw LAttack1Monster164 | db 128+32,DisplaceLeft,000,ShowBeingHitSprite,000,000,AnimateAttack | dw LIdle1Monster164 | db 128+16,DisplaceRight,002,000,InitiateAttack

;######################################################################################
;BlueSteel (knight with sword) (maze of gallious)

RIdle1Monster165:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster165:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)

LIdle1Monster165:   equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle2Monster165:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)

Monster165Move:
Monster165Idle:
  db    08                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster165
  dw    RIdle2Monster165
  ;facing left
  dw    LIdle1Monster165
  dw    LIdle2Monster165

;######################################################################################
;HikoDrone (space manbow)

RIdle1Monster166:   equ $4000 + (048*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle2Monster166:   equ $4000 + (048*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle3Monster166:   equ $4000 + (048*128) + (080/2) - 128  ;(y*128) + (x/2)
RIdle4Monster166:   equ $4000 + (048*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster166:   equ $4000 + (048*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster166:   equ $4000 + (048*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle3Monster166:   equ $4000 + (048*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle4Monster166:   equ $4000 + (048*128) + (112/2) - 128  ;(y*128) + (x/2)

Monster166Move:
Monster166Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster166
  dw    RIdle2Monster166
  dw    RIdle3Monster166
  dw    RIdle4Monster166
  dw    RIdle3Monster166
  dw    RIdle2Monster166
  ;facing left
  dw    LIdle1Monster166
  dw    LIdle2Monster166
  dw    LIdle3Monster166
  dw    LIdle4Monster166
  dw    LIdle3Monster166
  dw    LIdle2Monster166

;######################################################################################
;Wonder Boy (Wonder Boy)

RIdle1Monster167:   equ $4000 + (024*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster167:   equ $4000 + (024*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster167:   equ $4000 + (024*128) + (032/2) - 128  ;(y*128) + (x/2)

LIdle1Monster167:   equ $4000 + (024*128) + (080/2) - 128  ;(y*128) + (x/2)
LIdle2Monster167:   equ $4000 + (024*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle3Monster167:   equ $4000 + (024*128) + (048/2) - 128  ;(y*128) + (x/2)

Monster167Move:
Monster167Idle:
  db    03                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle3Monster167
  dw    RIdle2Monster167
  dw    RIdle1Monster167
  dw    RIdle2Monster167
  ;facing left
  dw    LIdle3Monster167
  dw    LIdle2Monster167
  dw    LIdle1Monster167
  dw    LIdle2Monster167

;######################################################################################
;Ninja Kun (Ninja Kun)

RIdle1Monster168:   equ $4000 + (064*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster168:   equ $4000 + (064*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster168:   equ $4000 + (064*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle4Monster168:   equ $4000 + (064*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle5Monster168:   equ $4000 + (064*128) + (064/2) - 128  ;(y*128) + (x/2)
RAttack1Monster168: equ $4000 + (064*128) + (080/2) - 128  ;(y*128) + (x/2)
RAttack2Monster168: equ $4000 + (064*128) + (096/2) - 128  ;(y*128) + (x/2)

LIdle1Monster168:   equ $4000 + (064*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster168:   equ $4000 + (064*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster168:   equ $4000 + (064*128) + (176/2) - 128  ;(y*128) + (x/2)
LIdle4Monster168:   equ $4000 + (064*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle5Monster168:   equ $4000 + (064*128) + (144/2) - 128  ;(y*128) + (x/2)
LAttack1Monster168: equ $4000 + (064*128) + (128/2) - 128  ;(y*128) + (x/2)
LAttack2Monster168: equ $4000 + (064*128) + (112/2) - 128  ;(y*128) + (x/2)

Monster168Move:
Monster168Idle:
  db    03                              ;animation speed (x frames per animation frame)
  db    5                               ;amount of animation frames
  dw    RIdle1Monster168
  dw    RIdle2Monster168
  dw    RIdle3Monster168
  dw    RIdle4Monster168
  dw    RIdle5Monster168
  ;facing left
  dw    LIdle1Monster168
  dw    LIdle2Monster168
  dw    LIdle3Monster168
  dw    LIdle4Monster168
  dw    LIdle5Monster168
Monster168AttackPatternRight:
  db    AnimateAttack | dw RAttack1Monster168 | db 000,000,000,AnimateAttack | dw RAttack2Monster168 | db 000,ShootProjectile,WaitImpactProjectile
Monster168AttackPatternLeft:
  db    AnimateAttack | dw LAttack1Monster168 | db 000,000,000,AnimateAttack | dw LAttack2Monster168 | db 000,ShootProjectile,WaitImpactProjectile
 
;######################################################################################
;Kubiwatari (jumping head statue) (hinotori)

RIdle1Monster169:   equ $4000 + (088*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster169:   equ $4000 + (088*128) + (016/2) - 128  ;(y*128) + (x/2)
RIdle3Monster169:   equ $4000 + (088*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle4Monster169:   equ $4000 + (088*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle5Monster169:   equ $4000 + (088*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle6Monster169:   equ $4000 + (088*128) + (080/2) - 128  ;(y*128) + (x/2)
RIdle7Monster169:   equ $4000 + (088*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle8Monster169:   equ $4000 + (088*128) + (112/2) - 128  ;(y*128) + (x/2)

LIdle1Monster169:   equ $4000 + (088*128) + (000/2) - 128  ;(y*128) + (x/2)
LIdle2Monster169:   equ $4000 + (088*128) + (016/2) - 128  ;(y*128) + (x/2)
LIdle3Monster169:   equ $4000 + (088*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle4Monster169:   equ $4000 + (088*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle5Monster169:   equ $4000 + (088*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle6Monster169:   equ $4000 + (088*128) + (080/2) - 128  ;(y*128) + (x/2)
LIdle7Monster169:   equ $4000 + (088*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle8Monster169:   equ $4000 + (088*128) + (112/2) - 128  ;(y*128) + (x/2)

Monster169Move:
Monster169Idle:
  db    01                              ;animation speed (x frames per animation frame)
  db    20                               ;amount of animation frames
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle2Monster169
  dw    RIdle3Monster169
  dw    RIdle4Monster169
  dw    RIdle5Monster169
  dw    RIdle6Monster169
  dw    RIdle7Monster169
  dw    RIdle8Monster169
  dw    RIdle8Monster169
  dw    RIdle7Monster169
  dw    RIdle6Monster169
  dw    RIdle5Monster169
  dw    RIdle4Monster169
  dw    RIdle3Monster169
  dw    RIdle2Monster169
  dw    RIdle1Monster169
  ;facing left
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle1Monster169
  dw    RIdle2Monster169
  dw    RIdle3Monster169
  dw    RIdle4Monster169
  dw    RIdle5Monster169
  dw    RIdle6Monster169
  dw    RIdle7Monster169
  dw    RIdle8Monster169
  dw    RIdle8Monster169
  dw    RIdle7Monster169
  dw    RIdle6Monster169
  dw    RIdle5Monster169
  dw    RIdle4Monster169
  dw    RIdle3Monster169
  dw    RIdle2Monster169
  dw    RIdle1Monster169

;######################################################################################
;Flutterbane (maze of gallious)

RIdle1Monster170:   equ $4000 + (224*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster170:   equ $4000 + (224*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster170:   equ $4000 + (224*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster170:   equ $4000 + (224*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster170Move:
Monster170Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster170
  dw    RIdle2Monster170
  ;facing left
  dw    LIdle1Monster170
  dw    LIdle2Monster170

;######################################################################################
;Topple Zip (Topple Zip)

RIdle1Monster171:   equ $4000 + (096*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster171:   equ $4000 + (096*128) + (016/2) - 128  ;(y*128) + (x/2)

LIdle1Monster171:   equ $4000 + (096*128) + (032/2) - 128  ;(y*128) + (x/2)
LIdle2Monster171:   equ $4000 + (064*128) + (240/2) - 128  ;(y*128) + (x/2)

Monster171Move:
Monster171Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster171
  dw    RIdle2Monster171
  ;facing left
  dw    LIdle1Monster171
  dw    LIdle2Monster171

;######################################################################################
;Topplane (Topple Zip)

RIdle1Monster172:   equ $4000 + (048*128) + (176/2) - 128  ;(y*128) + (x/2)
RIdle2Monster172:   equ $4000 + (048*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster172:   equ $4000 + (048*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster172:   equ $4000 + (048*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster172Move:
Monster172Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster172
  dw    RIdle2Monster172
  ;facing left
  dw    LIdle1Monster172
  dw    LIdle2Monster172

;######################################################################################
;Nyancle (Nyancle racing)

RIdle1Monster173:   equ $4000 + (144*128) + (160/2) - 128  ;(y*128) + (x/2)
RIdle2Monster173:   equ $4000 + (144*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster173:   equ $4000 + (144*128) + (208/2) - 128  ;(y*128) + (x/2)
LIdle2Monster173:   equ $4000 + (144*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster173Move:
Monster173Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster173
  dw    RIdle2Monster173
  ;facing left
  dw    LIdle1Monster173
  dw    LIdle2Monster173

;######################################################################################
;Ashguine (Ashguine 2)

RIdle1Monster174:   equ $4000 + (024*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle2Monster174:   equ $4000 + (024*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle3Monster174:   equ $4000 + (024*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster174: equ $4000 + (024*128) + (192/2) - 128  ;(y*128) + (x/2)
RAttack2Monster174: equ $4000 + (024*128) + (224/2) - 128  ;(y*128) + (x/2)

LIdle1Monster174:   equ $4000 + (144*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle2Monster174:   equ $4000 + (144*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle3Monster174:   equ $4000 + (144*128) + (064/2) - 128  ;(y*128) + (x/2)
LAttack1Monster174: equ $4000 + (144*128) + (032/2) - 128  ;(y*128) + (x/2)
LAttack2Monster174: equ $4000 + (144*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster174Move:
Monster174Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster174
  dw    RIdle2Monster174
  dw    RIdle3Monster174
  dw    RIdle2Monster174
  ;facing left
  dw    LIdle1Monster174
  dw    LIdle2Monster174
  dw    LIdle3Monster174
  dw    LIdle2Monster174

Monster174AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster174 | db 000,003,000,AnimateAttack | dw Rattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Rattack2Monster174 | db 000,AnimateAttack | dw Rattack1Monster174 | db 000,AnimateAttack | dw RIdle2Monster174 | db 000,007,InitiateAttack
Monster174AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster174 | db 000,008,000,AnimateAttack | dw Rattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Rattack2Monster174 | db 000,AnimateAttack | dw Rattack1Monster174 | db 000,AnimateAttack | dw RIdle2Monster174 | db 000,004,InitiateAttack
Monster174AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster174 | db 000,006,000,AnimateAttack | dw Rattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Rattack2Monster174 | db 000,AnimateAttack | dw Rattack1Monster174 | db 000,AnimateAttack | dw RIdle2Monster174 | db 000,002,InitiateAttack

Monster174AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster174 | db 000,007,000,AnimateAttack | dw Lattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Lattack2Monster174 | db 000,AnimateAttack | dw Lattack1Monster174 | db 000,AnimateAttack | dw LIdle2Monster174 | db 000,003,InitiateAttack
Monster174AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster174 | db 000,002,000,AnimateAttack | dw Lattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Lattack2Monster174 | db 000,AnimateAttack | dw Lattack1Monster174 | db 000,AnimateAttack | dw LIdle2Monster174 | db 000,006,InitiateAttack
Monster174AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster174 | db 000,004,000,AnimateAttack | dw Lattack1Monster174 | db 000,ShowBeingHitSprite,AnimateAttack | dw Lattack2Monster174 | db 000,AnimateAttack | dw Lattack1Monster174 | db 000,AnimateAttack | dw LIdle2Monster174 | db 000,008,InitiateAttack

;######################################################################################
;Hard Boiled (Hard Boiled)

RIdle1Monster175:   equ $4000 + (088*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster175:   equ $4000 + (088*128) + (160/2) - 128  ;(y*128) + (x/2)

LIdle1Monster175:   equ $4000 + (088*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster175:   equ $4000 + (088*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster175Move:
Monster175Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster175
  dw    RIdle2Monster175
  ;facing left
  dw    LIdle1Monster175
  dw    LIdle2Monster175

;######################################################################################
;Pingo (Doki Doki Penguin Land)

RIdle1Monster176:   equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle2Monster176:   equ $4000 + (000*128) + (144/2) - 128  ;(y*128) + (x/2)
RIdle3Monster176:   equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster176: equ $4000 + (000*128) + (176/2) - 128  ;(y*128) + (x/2)

LIdle1Monster176:   equ $4000 + (000*128) + (240/2) - 128  ;(y*128) + (x/2)
LIdle2Monster176:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle3Monster176:   equ $4000 + (000*128) + (208/2) - 128  ;(y*128) + (x/2)
LAttack1Monster176: equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)

Monster176Move:
Monster176Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster176
  dw    RIdle2Monster176
  dw    RIdle1Monster176
  dw    RIdle3Monster176
  ;facing left
  dw    LIdle1Monster176
  dw    LIdle2Monster176
  dw    LIdle1Monster176
  dw    LIdle3Monster176

Monster176AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster176 | db 003,000,AnimateAttack | dw RAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster176 | db 000,007,InitiateAttack
Monster176AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster176 | db 008,000,AnimateAttack | dw RAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster176 | db 000,004,InitiateAttack
Monster176AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster176 | db 006,000,AnimateAttack | dw RAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster176 | db 000,002,InitiateAttack

Monster176AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster176 | db 007,000,AnimateAttack | dw LAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster176 | db 000,003,InitiateAttack
Monster176AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster176 | db 002,000,AnimateAttack | dw LAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster176 | db 000,006,InitiateAttack
Monster176AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster176 | db 004,000,AnimateAttack | dw LAttack1Monster176 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster176 | db 000,008,InitiateAttack

;######################################################################################
;Doki Bear (Doki Doki Penguin Land)

RIdle1Monster177:   equ $4000 + (120*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster177:   equ $4000 + (120*128) + (016/2) - 128  ;(y*128) + (x/2)

LIdle1Monster177:   equ $4000 + (120*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle2Monster177:   equ $4000 + (120*128) + (032/2) - 128  ;(y*128) + (x/2)

Monster177Move:
Monster177Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster177
  dw    RIdle2Monster177
  ;facing left
  dw    LIdle1Monster177
  dw    LIdle2Monster177

;######################################################################################
;InspecteurZ (Inspecteur Z)

RIdle1Monster178:   equ $4000 + (064*128) + (224/2) - 128  ;(y*128) + (x/2)
RIdle2Monster178:   equ $4000 + (064*128) + (240/2) - 128  ;(y*128) + (x/2)
RAttack1Monster178: equ $4000 + (184*128) + (128/2) - 128  ;(y*128) + (x/2)

LIdle1Monster178:   equ $4000 + (184*128) + (176/2) - 128  ;(y*128) + (x/2)
LIdle2Monster178:   equ $4000 + (184*128) + (160/2) - 128  ;(y*128) + (x/2)
LAttack1Monster178: equ $4000 + (184*128) + (144/2) - 128  ;(y*128) + (x/2)

Monster178Move:
Monster178Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster178
  dw    RIdle2Monster178
  ;facing left
  dw    LIdle1Monster178
  dw    LIdle2Monster178

Monster178AttackPatternRight:
  db    AnimateAttack | dw RIdle1Monster178 | db 003,000,AnimateAttack | dw RAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster178 | db 000,007,InitiateAttack
Monster178AttackPatternRightUp:
  db    AnimateAttack | dw RIdle1Monster178 | db 008,000,AnimateAttack | dw RAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster178 | db 000,004,InitiateAttack
Monster178AttackPatternRightDown:
  db    AnimateAttack | dw RIdle1Monster178 | db 006,000,AnimateAttack | dw RAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw RIdle2Monster178 | db 000,002,InitiateAttack

Monster178AttackPatternLeft:
  db    AnimateAttack | dw LIdle1Monster178 | db 007,000,AnimateAttack | dw LAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster178 | db 000,003,InitiateAttack
Monster178AttackPatternLeftUp:
  db    AnimateAttack | dw LIdle1Monster178 | db 002,000,AnimateAttack | dw LAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster178 | db 000,006,InitiateAttack
Monster178AttackPatternLeftDown:
  db    AnimateAttack | dw LIdle1Monster178 | db 004,000,AnimateAttack | dw LAttack1Monster178 | db 000,ShowBeingHitSprite,000,AnimateAttack | dw LIdle2Monster178 | db 000,008,InitiateAttack


;######################################################################################
;Thug (Inspecteur Z) (dog with eye patch)

RIdle1Monster179:   equ $4000 + (120*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster179:   equ $4000 + (120*128) + (080/2) - 128  ;(y*128) + (x/2)

LIdle1Monster179:   equ $4000 + (120*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster179:   equ $4000 + (120*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster179Move:
Monster179Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster179
  dw    RIdle2Monster179
  ;facing left
  dw    LIdle1Monster179
  dw    LIdle2Monster179

;######################################################################################
;Goblin (Ys 2) (green monster)

RIdle1Monster180:   equ $4000 + (184*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster180:   equ $4000 + (184*128) + (016/2) - 128  ;(y*128) + (x/2)

LIdle1Monster180:   equ $4000 + (184*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle2Monster180:   equ $4000 + (184*128) + (032/2) - 128  ;(y*128) + (x/2)

Monster180Move:
Monster180Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster180
  dw    RIdle2Monster180
  ;facing left
  dw    LIdle1Monster180
  dw    LIdle2Monster180

;######################################################################################
;Emberhorn (Ys 2) (red horned monster)

RIdle1Monster181:   equ $4000 + (184*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle2Monster181:   equ $4000 + (184*128) + (080/2) - 128  ;(y*128) + (x/2)

LIdle1Monster181:   equ $4000 + (184*128) + (112/2) - 128  ;(y*128) + (x/2)
LIdle2Monster181:   equ $4000 + (184*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster181Move:
Monster181Idle:
  db    06                              ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster181
  dw    RIdle2Monster181
  ;facing left
  dw    LIdle1Monster181
  dw    LIdle2Monster181

;######################################################################################
;Kanton Man (chuka taisen) (bird man)

RIdle1Monster182:   equ $4000 + (080*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster182:   equ $4000 + (080*128) + (048/2) - 128  ;(y*128) + (x/2)
RIdle3Monster182:   equ $4000 + (080*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle4Monster182:   equ $4000 + (080*128) + (144/2) - 128  ;(y*128) + (x/2)

LIdle1Monster182:   equ $4000 + (216*128) + (144/2) - 128  ;(y*128) + (x/2)
LIdle2Monster182:   equ $4000 + (216*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle3Monster182:   equ $4000 + (216*128) + (048/2) - 128  ;(y*128) + (x/2)
LIdle4Monster182:   equ $4000 + (216*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster182Move:
Monster182Idle:
  db    03                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster182
  dw    RIdle2Monster182
  dw    RIdle3Monster182
  dw    RIdle4Monster182
  ;facing left
  dw    LIdle1Monster182
  dw    LIdle2Monster182
  dw    LIdle3Monster182
  dw    LIdle4Monster182

;######################################################################################
;Sun Wukong (chuka taisen) (main character)

RIdle1Monster183:   equ $4000 + (000*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster183:   equ $4000 + (000*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster183:   equ $4000 + (000*128) + (064/2) - 128  ;(y*128) + (x/2)
RIdle4Monster183:   equ $4000 + (000*128) + (096/2) - 128  ;(y*128) + (x/2)
RIdle5Monster183:   equ $4000 + (000*128) + (128/2) - 128  ;(y*128) + (x/2)
RIdle6Monster183:   equ $4000 + (000*128) + (160/2) - 128  ;(y*128) + (x/2)
RAttack1Monster183: equ $4000 + (000*128) + (192/2) - 128  ;(y*128) + (x/2)

LIdle1Monster183:   equ $4000 + (040*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle2Monster183:   equ $4000 + (040*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle3Monster183:   equ $4000 + (040*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle4Monster183:   equ $4000 + (040*128) + (096/2) - 128  ;(y*128) + (x/2)
LIdle5Monster183:   equ $4000 + (040*128) + (064/2) - 128  ;(y*128) + (x/2)
LIdle6Monster183:   equ $4000 + (040*128) + (032/2) - 128  ;(y*128) + (x/2)
LAttack1Monster183: equ $4000 + (040*128) + (000/2) - 128  ;(y*128) + (x/2)

Monster183Move:
Monster183Idle:
  db    03                              ;animation speed (x frames per animation frame)
  db    8                               ;amount of animation frames
  dw    RIdle1Monster183
  dw    RIdle2Monster183
  dw    RIdle3Monster183
  dw    RIdle4Monster183
  dw    RIdle5Monster183
  dw    RIdle6Monster183
  dw    RIdle3Monster183
  dw    RIdle4Monster183
  ;facing left
  dw    LIdle1Monster183
  dw    LIdle2Monster183
  dw    LIdle3Monster183
  dw    LIdle4Monster183
  dw    LIdle5Monster183
  dw    LIdle6Monster183
  dw    LIdle3Monster183
  dw    LIdle4Monster183

Monster183AttackPatternRight:
  db    AnimateAttack | dw Rattack1Monster183 | db 000,ShootProjectile,000,WaitImpactProjectile
Monster183AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster183 | db 000,ShootProjectile,000,WaitImpactProjectile

;######################################################################################
;Shock Scout (chuka taisen) (boy with green hair)

RIdle1Monster184:   equ $4000 + (120*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster184:   equ $4000 + (120*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster184:   equ $4000 + (120*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster184:   equ $4000 + (120*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster184:   equ $4000 + (120*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster184:   equ $4000 + (120*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster184Move:
Monster184Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster184
  dw    RIdle2Monster184
  dw    RIdle3Monster184
  dw    RIdle2Monster184
  ;facing left
  dw    LIdle1Monster184
  dw    LIdle2Monster184
  dw    LIdle3Monster184
  dw    LIdle2Monster184

;######################################################################################
;Evil Hermit (chuka taisen) (old man with staff and crown)

RIdle1Monster185:   equ $4000 + (168*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster185:   equ $4000 + (168*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster185:   equ $4000 + (168*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster185:   equ $4000 + (168*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster185:   equ $4000 + (168*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster185:   equ $4000 + (168*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster185Move:
Monster185Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster185
  dw    RIdle2Monster185
  dw    RIdle3Monster185
  dw    RIdle2Monster185
  ;facing left
  dw    LIdle1Monster185
  dw    LIdle2Monster185
  dw    LIdle3Monster185
  dw    LIdle2Monster185

;######################################################################################
;Bad Buddha (chuka taisen) (blue dress and mustache)

RIdle1Monster186:   equ $4000 + (120*128) + (192/2) - 128  ;(y*128) + (x/2)
RIdle2Monster186:   equ $4000 + (120*128) + (224/2) - 128  ;(y*128) + (x/2)
RIdle3Monster186:   equ $4000 + (000*128) + (224/2) - 128  ;(y*128) + (x/2)

LIdle1Monster186:   equ $4000 + (168*128) + (224/2) - 128  ;(y*128) + (x/2)
LIdle2Monster186:   equ $4000 + (168*128) + (192/2) - 128  ;(y*128) + (x/2)
LIdle3Monster186:   equ $4000 + (048*128) + (224/2) - 128  ;(y*128) + (x/2)

Monster186Move:
Monster186Idle:
  db    04                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster186
  dw    RIdle2Monster186
  dw    RIdle3Monster186
  dw    RIdle2Monster186
  ;facing left
  dw    LIdle1Monster186
  dw    LIdle2Monster186
  dw    LIdle3Monster186
  dw    LIdle2Monster186

;######################################################################################
;Dualhorn (chuka taisen) (green demon with 2 heads)

RIdle1Monster187:   equ $4000 + (208*128) + (000/2) - 128  ;(y*128) + (x/2)
RIdle2Monster187:   equ $4000 + (208*128) + (032/2) - 128  ;(y*128) + (x/2)
RIdle3Monster187:   equ $4000 + (208*128) + (064/2) - 128  ;(y*128) + (x/2)

LIdle1Monster187:   equ $4000 + (208*128) + (160/2) - 128  ;(y*128) + (x/2)
LIdle2Monster187:   equ $4000 + (208*128) + (128/2) - 128  ;(y*128) + (x/2)
LIdle3Monster187:   equ $4000 + (208*128) + (096/2) - 128  ;(y*128) + (x/2)

Monster187Move:
Monster187Idle:
  db    03                              ;animation speed (x frames per animation frame)
  db    4                               ;amount of animation frames
  dw    RIdle1Monster187
  dw    RIdle2Monster187
  dw    RIdle3Monster187
  dw    RIdle2Monster187
  ;facing left
  dw    LIdle1Monster187
  dw    LIdle2Monster187
  dw    LIdle3Monster187
  dw    LIdle2Monster187







