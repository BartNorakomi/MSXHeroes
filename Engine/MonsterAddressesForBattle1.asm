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
RangedHero:                   equ 128

LengthMonsterAddressesTable: equ Monster002Table-Monster001Table
Monster001Table:                        ;yie ar kung fu
  dw    Monster001Idle
  dw    Monster001Move
  dw    Monster001AttackPatternRight
  dw    Monster001AttackPatternLeft
  dw    Monster001AttackPatternLeftUp
  dw    Monster001AttackPatternLeftDown
  dw    Monster001AttackPatternRightUp
  dw    Monster001AttackPatternRightDown
  db    BattleMonsterSpriteSheet2Block
  db    32                              ;nx  
  db    32+08                           ;ny
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    053                             ;hp
  db    011                             ;speed
  db    001                             ;attack
  db    012                             ;defense
  db    012                             ;growth
;  db    000                             ;special ability
  db    RangedHero                      ;special ability, 128=ranged hero
  
Monster002Table:                        ;huge snake (golvellius)
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
  db    002                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability
  
Monster003Table:                        ;big spider (sd snatcher)
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
  db    16+08                           ;ny
  db    004                             ;cost (gold)
  db    001                             ;cost (gems)
  db    000                             ;cost (rubies)
  db    003                             ;hp
  db    003                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability

Monster004Table:                        ;green flyer (sd snatcher)
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
  db    004                             ;speed
  db    004                             ;attack
  db    012                             ;defense
  db    012                             ;growth
  db    000                             ;special ability

Monster005Table:                        ;tiny spider (sd snatcher)
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

Monster006Table:                        ;huge boo (golvellius)
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

Monster007Table:                        ;brown flyer (sd snatcher)
  dw    Monster007Idle
  dw    Monster007Move
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
;yie ar kung fu  

RIdle1Monster001:   equ $4000 + (072*128) + (000/2) - 128
RIdle2Monster001:   equ $4000 + (072*128) + (032/2) - 128
Rattack1Monster001: equ $4000 + (072*128) + (064/2) - 128
Rattack2Monster001: equ $4000 + (112*128) + (000/2) - 128

LIdle1Monster001:   equ $4000 + (072*128) + (192/2) - 128
LIdle2Monster001:   equ $4000 + (072*128) + (160/2) - 128
Lattack1Monster001: equ $4000 + (072*128) + (112/2) - 128
Lattack2Monster001: equ $4000 + (112*128) + (048/2) - 128

Monster001Move:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster001
  dw    RIdle2Monster001
  ;facing left
  dw    LIdle1Monster001
  dw    LIdle2Monster001
Monster001Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster001
  dw    RIdle2Monster001
  ;facing left
  dw    LIdle1Monster001
  dw    LIdle2Monster001
Monster001AttackPatternRight:
  db    LenghtMonster001AttackPatternRight,020 | dw RIdle1Monster001 | db 003,128+48,020 | dw Rattack1Monster001 | db 000,ShootProjectile,000,128+32,020 | dw RIdle2Monster001 | db 007,WaitImpactProjectile
;  db    LenghtMonster001AttackPatternRight,020 | dw RIdle1Monster001 | db 003,128+48,020 | dw Rattack1Monster001 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster001 | db 007,InitiateAttack
LenghtMonster001AttackPatternRight: equ $-Monster001AttackPatternRight-1
Monster001AttackPatternRightUp:
  db    LenghtMonster001AttackPatternRightUp,020 | dw RIdle1Monster001 | db 008,128+48,020 | dw Rattack1Monster001 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster001 | db 004,InitiateAttack
LenghtMonster001AttackPatternRightUp: equ $-Monster001AttackPatternRightUp-1
Monster001AttackPatternRightDown:
  db    LenghtMonster001AttackPatternRightDown,020 | dw RIdle1Monster001 | db 006,128+48,020 | dw Rattack2Monster001 | db 000,ShowBeingHitSprite,000,128+32,020 | dw RIdle2Monster001 | db 002,InitiateAttack
LenghtMonster001AttackPatternRightDown: equ $-Monster001AttackPatternRightDown-1

Monster001AttackPatternLeft:
  db    LenghtMonster001AttackPatternLeft,020 | dw LIdle1Monster001 | db 000,007,128+48,020 | dw Lattack1Monster001 | db DisplaceLeft,000,ShootProjectile,000,128+32,020 | dw LIdle2Monster001 | db DisplaceRight,003,000,WaitImpactProjectile
;  db    LenghtMonster001AttackPatternLeft,020 | dw LIdle1Monster001 | db 000,007,128+48,020 | dw Lattack1Monster001 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster001 | db DisplaceRight,003,000,InitiateAttack
LenghtMonster001AttackPatternLeft: equ $-Monster001AttackPatternLeft-1
Monster001AttackPatternLeftUp:
  db    LenghtMonster001AttackPatternLeftUp,020 | dw LIdle1Monster001 | db 000,002,128+48,020 | dw Lattack1Monster001 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster001 | db DisplaceRight,006,000,InitiateAttack
LenghtMonster001AttackPatternLeftUp: equ $-Monster001AttackPatternLeftUp-1
Monster001AttackPatternLeftDown:
  db    LenghtMonster001AttackPatternLeftDown,020 | dw LIdle1Monster001 | db 000,004,128+48,020 | dw Lattack2Monster001 | db DisplaceLeft,000,ShowBeingHitSprite,000,128+32,020 | dw LIdle2Monster001 | db DisplaceRight,008,000,InitiateAttack
LenghtMonster001AttackPatternLeftDown: equ $-Monster001AttackPatternLeftDown-1
;######################################################################################
;huge snake (golvellius)

RIdle1Monster002:   equ $4000 + (088*128) + (000/2) - 128
RIdle2Monster002:   equ $4000 + (088*128) + (056/2) - 128

LIdle1Monster002:   equ $4000 + (088*128) + (112/2) - 128
LIdle2Monster002:   equ $4000 + (088*128) + (168/2) - 128

Monster002Move:                     
Monster002Idle:
  db    2                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster002
  dw    RIdle2Monster002
  ;facing left
  dw    LIdle1Monster002
  dw    LIdle2Monster002
;######################################################################################
;big spider (sd snatcher)

RIdle1Monster003:   equ $4000 + (064*128) + (000/2) - 128
RIdle2Monster003:   equ $4000 + (064*128) + (016/2) - 128

LIdle1Monster003:   equ $4000 + (064*128) + (032/2) - 128
LIdle2Monster003:   equ $4000 + (064*128) + (048/2) - 128

Monster003Move:                     
Monster003Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster003
  dw    RIdle2Monster003
  ;facing left
  dw    LIdle1Monster003
  dw    LIdle2Monster003
;######################################################################################
;green flyer (sd snatcher)

RIdle1Monster004:   equ $4000 + (000*128) + (128/2) - 128
RIdle2Monster004:   equ $4000 + (000*128) + (144/2) - 128
RIdle3Monster004:   equ $4000 + (000*128) + (160/2) - 128
RIdle4Monster004:   equ $4000 + (000*128) + (176/2) - 128

LIdle1Monster004:   equ $4000 + (000*128) + (240/2) - 128
LIdle2Monster004:   equ $4000 + (000*128) + (224/2) - 128
LIdle3Monster004:   equ $4000 + (000*128) + (208/2) - 128
LIdle4Monster004:   equ $4000 + (000*128) + (192/2) - 128

Monster004Move:                     
Monster004Idle:
  db    3                               ;animation speed (x frames per animation frame)
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
;tiny spider (sd snatcher)

RIdle1Monster005:   equ $4000 + (068*128) + (064/2) - 128
RIdle2Monster005:   equ $4000 + (068*128) + (080/2) - 128

LIdle1Monster005:   equ $4000 + (068*128) + (096/2) - 128
LIdle2Monster005:   equ $4000 + (068*128) + (112/2) - 128

Monster005Move:                     
Monster005Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster005
  dw    RIdle2Monster005
  ;facing left
  dw    LIdle1Monster005
  dw    LIdle2Monster005
;######################################################################################
;huge boo (golvellius)

RIdle1Monster006:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster006:   equ $4000 + (000*128) + (064/2) - 128

LIdle1Monster006:   equ $4000 + (000*128) + (192/2) - 128
LIdle2Monster006:   equ $4000 + (000*128) + (128/2) - 128

Monster006Move:                     
Monster006Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    RIdle1Monster006
  dw    RIdle2Monster006
  ;facing left
  dw    LIdle1Monster006
  dw    LIdle2Monster006
;######################################################################################
;brown flyer (sd snatcher)

RIdle1Monster007:   equ $4000 + (000*128) + (000/2) - 128
RIdle2Monster007:   equ $4000 + (000*128) + (016/2) - 128
RIdle3Monster007:   equ $4000 + (000*128) + (032/2) - 128
RIdle4Monster007:   equ $4000 + (000*128) + (048/2) - 128

LIdle1Monster007:   equ $4000 + (000*128) + (112/2) - 128
LIdle2Monster007:   equ $4000 + (000*128) + (096/2) - 128
LIdle3Monster007:   equ $4000 + (000*128) + (080/2) - 128
LIdle4Monster007:   equ $4000 + (000*128) + (064/2) - 128

Monster007Move:                     
Monster007Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    RIdle1Monster007
  dw    RIdle2Monster007
  dw    RIdle3Monster007
  dw    RIdle4Monster007
  dw    RIdle3Monster007
  dw    RIdle2Monster007
  ;facing left
  dw    LIdle1Monster007
  dw    LIdle2Monster007
  dw    LIdle3Monster007
  dw    LIdle4Monster007
  dw    LIdle3Monster007
  dw    LIdle2Monster007
;######################################################################################

