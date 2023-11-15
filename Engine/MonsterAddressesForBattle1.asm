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
  db    009                             ;speed
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
  db    LenghtGeneralMonsterAttackPatternRight,000,003,ShowBeingHitSprite,007,000,InitiateAttack
LenghtGeneralMonsterAttackPatternRight: equ $-GeneralMonsterAttackPatternRight-1

GeneralMonsterAttackPatternLeft:
  db    LenghtGeneralMonsterAttackPatternLeft,000,007,ShowBeingHitSprite,003,000,InitiateAttack
LenghtGeneralMonsterAttackPatternLeft: equ $-GeneralMonsterAttackPatternLeft-1

GeneralMonsterAttackPatternLeftUp:
  db    LenghtGeneralMonsterAttackPatternLeftUp,000,008,ShowBeingHitSprite,004,000,InitiateAttack
LenghtGeneralMonsterAttackPatternLeftUp: equ $-GeneralMonsterAttackPatternLeftUp-1

GeneralMonsterAttackPatternLeftDown:
  db    LenghtGeneralMonsterAttackPatternLeftDown,000,006,ShowBeingHitSprite,002,000,InitiateAttack
LenghtGeneralMonsterAttackPatternLeftDown: equ $-GeneralMonsterAttackPatternLeftDown-1

GeneralMonsterAttackPatternRightUp:
  db    LenghtGeneralMonsterAttackPatternRightUp,000,002,ShowBeingHitSprite,006,000,InitiateAttack
LenghtGeneralMonsterAttackPatternRightUp: equ $-GeneralMonsterAttackPatternRightUp-1

GeneralMonsterAttackPatternRightDown:
  db    LenghtGeneralMonsterAttackPatternRightDown,000,004,ShowBeingHitSprite,008,000,InitiateAttack
LenghtGeneralMonsterAttackPatternRightDown: equ $-GeneralMonsterAttackPatternRightDown-1
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
  db    LenghtMonster007AttackPatternRight,AnimateAttack | dw Rattack1Monster007 | db 000,ShootProjectile,000,WaitImpactProjectile
LenghtMonster007AttackPatternRight: equ $-Monster007AttackPatternRight-1

Monster007AttackPatternLeft:
  db    LenghtMonster007AttackPatternLeft,AnimateAttack | dw Lattack1Monster007 | db 000,ShootProjectile,000,WaitImpactProjectile
LenghtMonster007AttackPatternLeft: equ $-Monster007AttackPatternLeft-1
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
  db    LenghtMonster008AttackPatternRight,AnimateAttack | dw Rattack1Monster008 | db 000,ShootProjectile,000,WaitImpactProjectile
LenghtMonster008AttackPatternRight: equ $-Monster008AttackPatternRight-1

Monster008AttackPatternLeft:
  db    LenghtMonster008AttackPatternLeft,AnimateAttack | dw Lattack1Monster008 | db 000,ShootProjectile,000,WaitImpactProjectile
LenghtMonster008AttackPatternLeft: equ $-Monster008AttackPatternLeft-1
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


