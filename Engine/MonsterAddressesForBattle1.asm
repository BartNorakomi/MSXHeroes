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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    007                             ;speed
  db    001                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    006                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    006                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    006                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    008                             ;hp
  db    007                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    005                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Mad ZenChan",255

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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "SuperMighta",255

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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Grim Reaper",255
  
Monster025Table:                        ;Skeleton (Castlevania)
  dw    Monster025Idle
  dw    Monster025Move
  dw    Monster025AttackPatternRight
  dw    Monster025AttackPatternLeft
  dw    Monster025AttackPatternLeft
  dw    Monster025AttackPatternLeft
  dw    Monster025AttackPatternRight
  dw    Monster025AttackPatternRight
  db    BattleMonsterSpriteSheet3Block
  db    16                              ;nx  
  db    32+08                           ;ny
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Axe man",255,"    "





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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Scorpii",255,"    "


Monster028Table:                        ;Porgi (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Porgi",255,"      "

Monster029Table:                        ;Rock man (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Rock Man",255,"   "

Monster030Table:                        ;Piglet (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Piglet",255,"     "

Monster031Table:                        ;Gers (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Gers",255,"       "

Monster032Table:                        ;Yashinotkin (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "King Mu",255,"    "

Monster034Table:                        ;Crawler (Dragon Slayer IV)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    002                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "GraveWing",255,"  "

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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Zomblet",255,"    "

Monster055Table:                        ;Cheek (Goemon)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Cheek",255,"      "

Monster056Table:                        ;Official (Goemon)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Official",255,"   "

Monster057Table:                        ;Kasa-obake (Goemon)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Bucket Head",255

Monster061Table:                        ;Headmaster (Goemon)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Granola",255,"    "

Monster063Table:                        ;Rouge Gazer (Psycho World)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Floatwing",255,"  "

Monster066Table:                        ;CrimsonPeek (Psycho World)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "CrimsonPeek",255

Monster067Table:                        ;Fernling (Psycho World)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Spitvine",255,"   "

Monster070Table:                        ;OptiLeaper (Psycho World)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "OptiLeaper",255," "

Monster071Table:                        ;huge boo (golvellius)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    006                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Bat",255,"        "

Monster079Table:                        ;Olive Boa (Golvellius)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "Olive Boa",255,"  "

Monster080Table:                        ;SilkenLarva (Golvellius)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  db    "ChocoTusker",255

Monster082Table:                        ;JadeWormlet (Golvellius)
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    008                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
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
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    009                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Footman",255,"    "






Monster101Table:                        ;yie ar kung fu
  dw    Monster101Idle
  dw    Monster101Move
  dw    Monster101AttackPatternRight
  dw    Monster101AttackPatternLeft
  dw    Monster101AttackPatternLeftUp
  dw    Monster101AttackPatternLeftDown
  dw    Monster101AttackPatternRightUp
  dw    Monster101AttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    053                             ;hp
  db    011                             ;speed
  db    060                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    RangedMonster                   ;special ability, 128=ranged hero
  db    "Yie Ar Kung",255
  







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

LIdle1Monster020:   equ $4000 + (136*128) + (180/2) - 128 ;(y*128) + (x/2)
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
  db    AnimateAttack | dw Rattack1Monster025 | db 000,000,000,000,000,AnimateAttack | dw RIdle1Monster025 | db ShootProjectile,WaitImpactProjectile
Monster025AttackPatternLeft:
  db    AnimateAttack | dw Lattack1Monster025 | db 000,000,000,000,000,AnimateAttack | dw LIdle1Monster025 | db ShootProjectile,WaitImpactProjectile
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
  db    000,AnimateAttack | dw RIdle1Monster069 | db 000,ShootProjectile,WaitImpactProjectile
Monster069AttackPatternLeft:
  db    000,AnimateAttack | dw LIdle1Monster069 | db 000,ShootProjectile,WaitImpactProjectile
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
;SilkenLarva (Golvellius)

RIdle1Monster080:   equ $4000 + (080*128) + (240/2) - 128
RIdle2Monster080:   equ $4000 + (160*128) + (240/2) - 128

LIdle1Monster080:   equ $4000 + (240*128) + (016/2) - 128
LIdle2Monster080:   equ $4000 + (240*128) + (000/2) - 128

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
;JadeWormlet (Golvellius)

RIdle1Monster082:   equ $4000 + (240*128) + (032/2) - 128
RIdle2Monster082:   equ $4000 + (240*128) + (048/2) - 128

LIdle1Monster082:   equ $4000 + (240*128) + (080/2) - 128
LIdle2Monster082:   equ $4000 + (240*128) + (064/2) - 128

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
;yie ar kung fu  

RIdle1Monster101:   equ $4000 + (072*128) + (000/2) - 128
RIdle2Monster101:   equ $4000 + (072*128) + (032/2) - 128
Rattack1Monster101: equ $4000 + (072*128) + (064/2) - 128
Rattack2Monster101: equ $4000 + (112*128) + (000/2) - 128

LIdle1Monster101:   equ $4000 + (072*128) + (192/2) - 128
LIdle2Monster101:   equ $4000 + (072*128) + (160/2) - 128
Lattack1Monster101: equ $4000 + (072*128) + (112/2) - 128
Lattack2Monster101: equ $4000 + (112*128) + (048/2) - 128

Monster101Move:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster101
  dw    RIdle2Monster101
  ;facing left
  dw    LIdle1Monster101
  dw    LIdle2Monster101
Monster101Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster101
  dw    RIdle2Monster101
  ;facing left
  dw    LIdle1Monster101
  dw    LIdle2Monster101
Monster101AttackPatternRight:
  db    LenghtMonster101AttackPatternRight,020 | dw RIdle1Monster101 | db 003,128+48,020 | dw Rattack1Monster101 | db 000,ShootProjectile,000,128+32,020 | dw RIdle2Monster101 | db 007,WaitImpactProjectile
;  db    LenghtMonster101AttackPatternRight,020 | dw RIdle1Monster101 | db 003,128+48,020 | dw Rattack1Monster101 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster101 | db 007,InitiateAttack
LenghtMonster101AttackPatternRight: equ $-Monster101AttackPatternRight-1
Monster101AttackPatternRightUp:
  db    LenghtMonster101AttackPatternRightUp,020 | dw RIdle1Monster101 | db 008,128+48,020 | dw Rattack1Monster101 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster101 | db 004,InitiateAttack
LenghtMonster101AttackPatternRightUp: equ $-Monster101AttackPatternRightUp-1
Monster101AttackPatternRightDown:
  db    LenghtMonster101AttackPatternRightDown,020 | dw RIdle1Monster101 | db 006,128+48,020 | dw Rattack2Monster101 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster101 | db 002,InitiateAttack
LenghtMonster101AttackPatternRightDown: equ $-Monster101AttackPatternRightDown-1

Monster101AttackPatternLeft:
  db    LenghtMonster101AttackPatternLeft,020 | dw LIdle1Monster101 | db 000,007,128+48,020 | dw Lattack1Monster101 | db DisplaceLeft,000,ShootProjectile,000,128+32,020 | dw LIdle2Monster101 | db DisplaceRight,003,000,WaitImpactProjectile
;  db    LenghtMonster101AttackPatternLeft,020 | dw LIdle1Monster101 | db 000,007,128+48,020 | dw Lattack1Monster101 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster101 | db DisplaceRight,003,000,InitiateAttack
LenghtMonster101AttackPatternLeft: equ $-Monster101AttackPatternLeft-1
Monster101AttackPatternLeftUp:
  db    LenghtMonster101AttackPatternLeftUp,020 | dw LIdle1Monster101 | db 000,002,128+48,020 | dw Lattack1Monster101 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster101 | db DisplaceRight,006,000,InitiateAttack
LenghtMonster101AttackPatternLeftUp: equ $-Monster101AttackPatternLeftUp-1
Monster101AttackPatternLeftDown:
  db    LenghtMonster101AttackPatternLeftDown,020 | dw LIdle1Monster101 | db 000,004,128+48,020 | dw Lattack2Monster101 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster101 | db DisplaceRight,008,000,InitiateAttack
LenghtMonster101AttackPatternLeftDown: equ $-Monster101AttackPatternLeftDown-1
;######################################################################################
