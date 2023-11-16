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
  
Monster102Table:                        ;huge snake (golvellius)
  dw    Monster002Idle
  dw    Monster002Move
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  db    BattleMonsterSpriteSheet1Block
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
  db    "Huge Snake",255," " 

Monster106Table:                        ;huge boo (golvellius)
  dw    Monster006Idle
  dw    Monster006Move
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
;huge snake (golvellius)

RIdle1Monster102:   equ $4000 + (088*128) + (000/2) - 128
RIdle2Monster102:   equ $4000 + (088*128) + (056/2) - 128

LIdle1Monster102:   equ $4000 + (088*128) + (112/2) - 128
LIdle2Monster102:   equ $4000 + (088*128) + (168/2) - 128

Monster102Move:                     
Monster102Idle:
  db    2                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster102
  dw    RIdle2Monster102
  ;facing left
  dw    LIdle1Monster102
  dw    LIdle2Monster102
;######################################################################################
;huge boo (golvellius)

RIdle1Monster106:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster106:   equ $4000 + (000*128) + (064/2) - 128

LIdle1Monster106:   equ $4000 + (000*128) + (192/2) - 128
LIdle2Monster106:   equ $4000 + (000*128) + (128/2) - 128

Monster106Move:                     
Monster106Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster106
  dw    RIdle2Monster106
  ;facing left
  dw    LIdle1Monster106
  dw    LIdle2Monster106
;######################################################################################

kut:
