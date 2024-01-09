AnimateAutoCombatButton:
  ld    a,(AutoCombatButtonPressed?)
  or    a
  jr    z,.AutoCombatNotOn

  ld    a,(framecounter)
  and   15

  cp    4
  ld    hl,$4000 + (072*128) + (196/2) - 128
  jr    c,.SetAutoCombatButton

  cp    8
  ld    hl,$4000 + (072*128) + (214/2) - 128
  jr    c,.SetAutoCombatButton

  cp    12
  ld    hl,$4000 + (072*128) + (232/2) - 128
  jr    c,.SetAutoCombatButton

  ld    hl,$4000 + (090*128) + (196/2) - 128

  .SetAutoCombatButton:
  ld    (1+GenericButtonTable+(GenericButtonTableLenghtPerButton*6)),hl  
  ld    (3+GenericButtonTable+(GenericButtonTableLenghtPerButton*6)),hl  
  ld    a,(GenericButtonTable+(GenericButtonTableLenghtPerButton*6))
  or    %0000 0011
  ld    (GenericButtonTable+(GenericButtonTableLenghtPerButton*6)),a
  ret

  .AutoCombatNotOn:
  ld    hl,$4000 + (054*128) + (214/2) - 128
  ld    (1+GenericButtonTable+(GenericButtonTableLenghtPerButton*6)),hl  
  ld    hl,$4000 + (054*128) + (232/2) - 128
  ld    (3+GenericButtonTable+(GenericButtonTableLenghtPerButton*6)),hl  
  ret

HandleEnemyAI:                          ;in: d=SpecialAbility, c=speed
  inc   c                               ;increase movement speed by 1
  ld    a,d
  cp    128
  jp    z,HandleEnemyAIRangeMonster

HandleEnemyAIMeleeMonster:
  ld    a,c
  exx
  ld    c,a                             ;copy of movement speed
  ld    b,18                            ;we can extrend monsters movement speed by 18 to find at least the nearest target

  ld    a,(CurrentActiveMonster)        ;left or right player is currently active ?
  cp    7
  jr    nc,.RightPlayerIsCurrentlyActive
  
  .LeftPlayerIsCurrentlyActive:
  exx
  ld    ix,Monster7 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range
  ld    ix,Monster8 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range
  ld    ix,Monster9 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range
  ld    ix,Monster10 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range
  ld    ix,Monster11 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range
  ld    ix,Monster12 | call .Checkpass1CheckAttackFromTheLeftFirst  ;check if monster amount>9 and monster is in range

  ld    ix,Monster7 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range
  ld    ix,Monster8 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range
  ld    ix,Monster9 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range
  ld    ix,Monster10 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range
  ld    ix,Monster11 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range
  ld    ix,Monster12 | call .Checkpass2CheckAttackFromTheLeftFirst  ;check if monster is in range

  ;at this point monster has not found an enemy within range, increase monster's range, but monster then cant attack anymore. So put 255 at the end of the MonsterMovementPath
  inc   c
  exx
  djnz  .LeftPlayerIsCurrentlyActive
  ;in case monster can't reach a target, it will just defend instead
  ld    a,1
  ld    (DefendButtonPressed?),a  
  ret

  .RightPlayerIsCurrentlyActive:
  exx
  ld    ix,Monster1 | call .Checkpass1  ;check if monster amount>9 and monster is in range
  ld    ix,Monster2 | call .Checkpass1  ;check if monster amount>9 and monster is in range
  ld    ix,Monster3 | call .Checkpass1  ;check if monster amount>9 and monster is in range
  ld    ix,Monster4 | call .Checkpass1  ;check if monster amount>9 and monster is in range
  ld    ix,Monster5 | call .Checkpass1  ;check if monster amount>9 and monster is in range
  ld    ix,Monster6 | call .Checkpass1  ;check if monster amount>9 and monster is in range

  ld    ix,Monster1 | call .Checkpass2  ;check if monster is in range
  ld    ix,Monster2 | call .Checkpass2  ;check if monster is in range
  ld    ix,Monster3 | call .Checkpass2  ;check if monster is in range
  ld    ix,Monster4 | call .Checkpass2  ;check if monster is in range
  ld    ix,Monster5 | call .Checkpass2  ;check if monster is in range
  ld    ix,Monster6 | call .Checkpass2  ;check if monster is in range

  ;at this point monster has not found an enemy within range, increase monster's range, but monster then cant attack anymore. So put 255 at the end of the MonsterMovementPath
  inc   c
  exx
  djnz  .RightPlayerIsCurrentlyActive
  ;in case monster can't reach a target, it will just defend instead
  ld    a,1
  ld    (DefendButtonPressed?),a  
  ret
  
  .Checkpass2:                          ;check if monster is in range
  ld    (MonsterThatIsBeingAttacked),ix
  jr    .endCheckAmount

  .Checkpass1:                          ;check if monster amount>9 and monster is in range
  ld    (MonsterThatIsBeingAttacked),ix
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    de,10  
  call  CompareHLwithDE
  ret   c                               ;don't check if amount>10
  .endCheckAmount:
  ld    a,(ix+MonsterHP)
  or    a
  ret   z                               ;don't check if monster is dead
  ld    a,(ix+MonsterX)
  ld    (MonsterThatIsBeingAttackedX),a
  ld    a,(ix+MonsterNX)
  ld    (MonsterThatIsBeingAttackedNX),a
  ld    a,(ix+MonsterY)
  ld    (MonsterThatIsBeingAttackedY),a
  ld    a,(ix+MonsterNY)
  ld    (MonsterThatIsBeingAttackedNY),a

  call  .CanMonsterBeAttackedFromTheRIght?
  call  .CanMonsterBeAttackedFromTheRIghtBottom?
  call  .CanMonsterBeAttackedFromTheRIghtTop?
  call  .CanMonsterBeAttackedFromTheLeft?
  call  .CanMonsterBeAttackedFromTheLeftBottom?
  call  .CanMonsterBeAttackedFromTheLeftTop?
  ret


  .Checkpass2CheckAttackFromTheLeftFirst:                          ;check if monster is in range
  ld    (MonsterThatIsBeingAttacked),ix
  jr    .endCheckAmountCheckAttackFromTheLeftFirst

  .Checkpass1CheckAttackFromTheLeftFirst:                          ;check if monster amount>9 and monster is in range
  ld    (MonsterThatIsBeingAttacked),ix
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    de,10  
  call  CompareHLwithDE
  ret   c                               ;don't check if amount>10
  .endCheckAmountCheckAttackFromTheLeftFirst:
  ld    a,(ix+MonsterHP)
  or    a
  ret   z                               ;don't check if monster is dead
  ld    a,(ix+MonsterX)
  ld    (MonsterThatIsBeingAttackedX),a
  ld    a,(ix+MonsterNX)
  ld    (MonsterThatIsBeingAttackedNX),a
  ld    a,(ix+MonsterY)
  ld    (MonsterThatIsBeingAttackedY),a
  ld    a,(ix+MonsterNY)
  ld    (MonsterThatIsBeingAttackedNY),a

  call  .CanMonsterBeAttackedFromTheLeft?
  call  .CanMonsterBeAttackedFromTheLeftBottom?
  call  .CanMonsterBeAttackedFromTheLeftTop?
  call  .CanMonsterBeAttackedFromTheRIght?
  call  .CanMonsterBeAttackedFromTheRIghtBottom?
  call  .CanMonsterBeAttackedFromTheRIghtTop?
  ret

  .CanMonsterBeAttackedFromTheLeftBottom?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  dec   hl
  ld    de,LenghtBattleField
  add   hl,de
  call  .CheckLeftBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftBottomWidth1Tile
  ret
  .CheckLeftBottomWidth1Tile:
  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,012                           ;initiate attack right up
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret

  .CanMonsterBeAttackedFromTheLeftTop?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  dec   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  call  .CheckLeftTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  inc   hl
  inc   hl
  call  .CheckLeftTopWidth1Tile
  ret
  .CheckLeftTopWidth1Tile:
  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,014                           ;initiate attack right bottom
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret

  .CanMonsterBeAttackedFromTheRIghtBottom?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  inc   hl
  ld    de,LenghtBattleField
  add   hl,de
  call  .CheckRightBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightBottomWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightBottomWidth1Tile
  ret
  .CheckRightBottomWidth1Tile:
  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,018                           ;initiate attack left up
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret

  .CanMonsterBeAttackedFromTheRIghtTop?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  inc   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  call  .CheckRightTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightTopWidth1Tile
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  inc   hl
  inc   hl
  call  .CheckRightTopWidth1Tile
  ret
  .CheckRightTopWidth1Tile:
  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,016                           ;initiate attack left bottom
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret

  .CanMonsterBeAttackedFromTheLeft?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  dec   hl
  dec   hl

  push  ix
  push  hl
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterNX)
  pop   hl
  pop   ix

  cp    17
  jr    c,.MonsterWidthFound_Left       ;Monster Is 1 Tile Wide
  dec   hl
  dec   hl
  cp    33
  jr    c,.MonsterWidthFound_Left       ;Monster Is 2 Tiles Wide
  dec   hl
  dec   hl
  cp    57
  jr    c,.MonsterWidthFound_Left       ;Monster Is 3 Tiles Wide
  dec   hl
  dec   hl                              ;Monster Is 4 Tiles Wide
  .MonsterWidthFound_Left:
  
  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,013                           ;initiate attack right
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret
  
  .CanMonsterBeAttackedFromTheRIght?:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  inc   hl
  inc   hl

  ld    a,(ix+MonsterNX)
  cp    17
  jr    c,.MonsterWidthFound_Right      ;Monster Is 1 Tile Wide
  inc   hl
  inc   hl
  cp    33
  jr    c,.MonsterWidthFound_Right      ;Monster Is 2 Tiles Wide
  inc   hl
  inc   hl
  cp    57
  jr    c,.MonsterWidthFound_Right      ;Monster Is 3 Tiles Wide
  inc   hl
  inc   hl                              ;Monster Is 4 Tiles Wide
  .MonsterWidthFound_Right:

  ld    a,(hl)
  cp    255                             ;unable to move here
  ret   z  
  cp    c                               ;movement speed monster
  ret   nc
  pop   af
  pop   af
  push  bc                              ;c=monster movement speed
  ld    c,017                           ;initiate attack left
  call  CheckSpaceToMoveMonster.CursorLocationSet
  pop   bc                              ;c=monster movement speed
  
  exx
  ld    hl,MonsterMovementPath
  ld    d,0
  ld    e,c
  dec   e
  add   hl,de
  ld    (hl),255                        ;255=end movement(normal walk)
  ret

HandleEnemyAIRangeMonster:
  ld    a,(CurrentActiveMonster)        ;left or right player is currently active ?
  cp    7
  jp    nc,.RightPlayerIsCurrentlyActive

  .LeftPlayerIsCurrentlyActive:
;pass 1: check in range AND amount>9
  ld    ix,Monster7 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster8 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster9 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster10 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster11 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster12 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9

;pass 2: check amount>9
  ld    ix,Monster7 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster8 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster9 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster10 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster11 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster12 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9

;pass 3: check in range
  ld    ix,Monster7 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster8 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster9 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster10 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster11 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster12 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range

;pass 4: attack any monster attackable
  ld    ix,Monster7 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster8 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster9 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster10 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster11 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster12 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ret

  .RightPlayerIsCurrentlyActive:
;pass 1: check in range AND amount>9
  ld    ix,Monster1 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster2 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster3 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster4 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster5 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9
  ld    ix,Monster6 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass1 ;check in range AND amount>9

;pass 2: check amount>9
  ld    ix,Monster1 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster2 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster3 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster4 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster5 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9
  ld    ix,Monster6 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass2 ;check amount>9

;pass 3: check in range
  ld    ix,Monster1 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster2 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster3 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster4 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster5 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range
  ld    ix,Monster6 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass3 ;check in range

;pass 4: attack any monster attackable
  ld    ix,Monster1 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster2 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster3 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster4 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster5 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ld    ix,Monster6 | call .CheckIfMonsterCanBeAttacked | call  .CheckPass4 ;attack any monster attackable
  ret

  .CheckPass4:                          ;attack any monster attackable
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   z                               ;check if this monster can be attacked
  pop   af                              ;pop the call to this routine and attack this monster
  ret

  .CheckPass3:                          ;check amount>9
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   z                               ;check if this monster can be attacked
  ld    a,(BrokenArrow?)                ;check if in range            
  or    a
  ret   nz  
  pop   af                              ;pop the call to this routine and attack this monster
  ret

  .CheckPass2:                          ;check amount>9
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   z                               ;check if this monster can be attacked
  ld    ix,(MonsterThatIsBeingAttacked)
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    de,10  
  call  CompareHLwithDE                 ;check if monster amount>10
  ret   c
  pop   af                              ;pop the call to this routine and attack this monster
  ret

  .CheckPass1:                          ;check in range AND amount>9
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   z                               ;check if this monster can be attacked
  ld    a,(BrokenArrow?)                ;check if in range            
  or    a
  ret   nz
  ld    ix,(MonsterThatIsBeingAttacked)
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    de,10 
  call  CompareHLwithDE                 ;check if monster amount>10
  ret   c
  pop   af                              ;pop the call to this routine and attack this monster
  ret

  .CheckIfMonsterCanBeAttacked:
  xor   a
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster

  ld    (MonsterThatIsBeingAttacked),ix
  ld    a,(ix+MonsterHP)
  or    a
  ret   z                               ;don't check if monster is dead
  ld    a,(ix+MonsterX)
  ld    (MonsterThatIsBeingAttackedX),a
  ld    a,(ix+MonsterNX)
  ld    (MonsterThatIsBeingAttackedNX),a
  ld    a,(ix+MonsterY)
  ld    (MonsterThatIsBeingAttackedY),a
  ld    a,(ix+MonsterNY)
  ld    (MonsterThatIsBeingAttackedNY),a
  
  ;we check if monster in ix can be attacked, and we check full damage (bowandarrow) or 50% damage (brokenarrow)
  call  RangedMonsterCheck

  ld    a,(BrokenArrow?)                
  cp    2                               ;2=2=monster dead/if there is any enemy right next to active monster, we can not attack monsters out of melee range at all 
  ret   z

  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterX)
  ld    iy,(MonsterThatIsBeingAttacked)
  cp    (iy+MonsterX)
  ld    c,013                           ;initiate attack right
  jr    c,.DirectionFound
  ld    c,017                           ;initiate attack left
  .DirectionFound:
  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ld    iy,MonsterMovementPath
  ld    (iy),c                          ;255=end movement(normal walk), 10=attack right, 
  ret

SetBattlefieldCasualtiesDefender:
  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  push  ix
  pop   hl
  ld    a,l
  or    h
  jp    z,.SetBattlefieldCasualtiesDefenderNeutralMonster

  ld    a,173+16
  ld    (CasualtiesOverviewCopy+dy),a

  ld    hl,$4000 + (142*128) + (044/2) - 128
  ld    de,$0000 + ((212+16)*128) + (020/2) - 128
  ld    bc,$0000 + (022*256) + (138/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    b,004                           ;dx number
  ld    c,0                             ;amount of slots with casualties
  ld    de,$0000 + ((214+16)*128) + (024/2) - 128 ;dx 14x14 unit portrait

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+0)              ;monster type/nr
  ld    l,(iy+HeroUnits+1)
  ld    h,(iy+HeroUnits+2)              ;amount units slot 1
  ld    ix,Monster7
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+3)              ;monster type/nr
  ld    l,(iy+HeroUnits+4)
  ld    h,(iy+HeroUnits+5)              ;amount units slot 1
  ld    ix,Monster8
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+6)              ;monster type/nr
  ld    l,(iy+HeroUnits+7)
  ld    h,(iy+HeroUnits+8)              ;amount units slot 1
  ld    ix,Monster9
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+9)              ;monster type/nr
  ld    l,(iy+HeroUnits+10)
  ld    h,(iy+HeroUnits+11)             ;amount units slot 1
  ld    ix,Monster10
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+12)             ;monster type/nr
  ld    l,(iy+HeroUnits+13)
  ld    h,(iy+HeroUnits+14)             ;amount units slot 1
  ld    ix,Monster11
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,(HeroThatGetsAttacked)      ;defending hero
  ld    a,(iy+HeroUnits+15)             ;monster type/nr
  ld    l,(iy+HeroUnits+16)
  ld    h,(iy+HeroUnits+17)             ;amount units slot 1
  ld    ix,Monster12
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied
  jp    SetBattlefieldCasualtiesAttacker.AllSlotsChecked

.SetBattlefieldCasualtiesDefenderNeutralMonster:
  ld    a,173+16
  ld    (CasualtiesOverviewCopy+dy),a

  ld    hl,$4000 + (142*128) + (044/2) - 128
  ld    de,$0000 + ((212+16)*128) + (020/2) - 128
  ld    bc,$0000 + (022*256) + (138/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    b,004                           ;dx number
  ld    c,0                             ;amount of slots with casualties
  ld    de,$0000 + ((214+16)*128) + (024/2) - 128 ;dx 14x14 unit portrait

  ld    iy,ListOfMonstersToPutMonster7
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster7
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,ListOfMonstersToPutMonster8
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster8
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,ListOfMonstersToPutMonster9
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster9
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,ListOfMonstersToPutMonster10
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster10
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,ListOfMonstersToPutMonster11
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster11
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied

  ld    iy,ListOfMonstersToPutMonster12
  ld    a,(iy+0)              ;monster type/nr
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster12
  call  SetBattlefieldCasualtiesAttacker.CheckAmountOfMonstersSlotDied
  jp    SetBattlefieldCasualtiesAttacker.AllSlotsChecked

SetBattlefieldCasualtiesAttacker:
  ld    a,144+16
  ld    (CasualtiesOverviewCopy+dy),a

  ld    hl,$4000 + (142*128) + (044/2) - 128
  ld    de,$0000 + ((212+16)*128) + (020/2) - 128
  ld    bc,$0000 + (022*256) + (138/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    b,004                           ;dx number
  ld    c,0                             ;amount of slots with casualties
  ld    de,$0000 + ((214+16)*128) + (024/2) - 128 ;dx 14x14 unit portrait

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+0)              ;monster type/nr
  ld    l,(iy+HeroUnits+1)
  ld    h,(iy+HeroUnits+2)              ;amount units slot 1
  ld    ix,Monster1
  call  .CheckAmountOfMonstersSlotDied

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+3)              ;monster type/nr
  ld    l,(iy+HeroUnits+4)
  ld    h,(iy+HeroUnits+5)              ;amount units slot 1
  ld    ix,Monster2
  call  .CheckAmountOfMonstersSlotDied

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+6)              ;monster type/nr
  ld    l,(iy+HeroUnits+7)
  ld    h,(iy+HeroUnits+8)              ;amount units slot 1
  ld    ix,Monster3
  call  .CheckAmountOfMonstersSlotDied

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+9)              ;monster type/nr
  ld    l,(iy+HeroUnits+10)
  ld    h,(iy+HeroUnits+11)             ;amount units slot 1
  ld    ix,Monster4
  call  .CheckAmountOfMonstersSlotDied

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+12)             ;monster type/nr
  ld    l,(iy+HeroUnits+13)
  ld    h,(iy+HeroUnits+14)             ;amount units slot 1
  ld    ix,Monster5
  call  .CheckAmountOfMonstersSlotDied

  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    a,(iy+HeroUnits+15)             ;monster type/nr
  ld    l,(iy+HeroUnits+16)
  ld    h,(iy+HeroUnits+17)             ;amount units slot 1
  ld    ix,Monster6
  call  .CheckAmountOfMonstersSlotDied
  .AllSlotsChecked:

  ld    a,c                             ;amount of slots with casualties
  or    a
  ret   z
  dec   a
  ld    b,1*22                          ;nx
  ld    c,068+ 5*11                     ;dx
  jr    z,.AmountOfSlotsWithCasualtiesFound
  dec   a
  ld    b,2*22                          ;nx
  ld    c,068+ 4*11                     ;dx
  jr    z,.AmountOfSlotsWithCasualtiesFound
  dec   a
  ld    b,3*22                          ;nx
  ld    c,068+ 3*11                     ;dx
  jr    z,.AmountOfSlotsWithCasualtiesFound
  dec   a
  ld    b,4*22                          ;nx
  ld    c,068+ 2*11                     ;dx
  jr    z,.AmountOfSlotsWithCasualtiesFound
  dec   a
  ld    b,5*22                          ;nx
  ld    c,068+ 1*11                     ;dx
  jr    z,.AmountOfSlotsWithCasualtiesFound
  ld    b,6*22                          ;nx
  ld    c,068+ 0*11                     ;dx

  .AmountOfSlotsWithCasualtiesFound:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  ld    a,1
  jr    z,.ActivePageFound
  xor   a
  .ActivePageFound:
  ld    (CasualtiesOverviewCopy+sPage),a
  ld    (CasualtiesOverviewCopy+dPage),a
  
  ld    a,b
  ld    (CasualtiesOverviewCopy+nx),a
  ld    a,c
  ld    (CasualtiesOverviewCopy+dx),a
  
  ld    hl,CasualtiesOverviewCopy
  call  docopy
  ret

  .CheckAmountOfMonstersSlotDied:
  ex    af,af'
  ;left hero
  call  .CalculateAmountOfUnitsLost
  ret   z

  ;set amount
  push  bc
  ld    c,212+17+16                           ;dy
  push  de
  ld    a,b
  add   a,20
  ld    b,a
  call  SetNumber16BitCastle
  
  ex    af,af'
  call  SetSYSX14x14
  pop   de
  push  de
;  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  push  hl
  ld    hl,128
  add   hl,de
  add   hl,hl
  ex    de,hl
  pop   hl
  
  call  CopyTransparantImageBattleCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  pop   de
  pop   bc

  inc   c                            ;amount of slots with casualties

  ld    a,b
  add   a,22
  ld    b,a

  ld    hl,22/2
  add   hl,de
  ex    de,hl
  ret

  .CalculateAmountOfUnitsLost:
  push  de
  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)

  or    a
  sbc   hl,de                           ;sub monster at start of fight - monsters at end
  pop   de
  ret

SetSYSX14x14:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable14x14Portraits2
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  push  bc
  pop   hl

  ld    a,Enemy14x14PortraitsBlock      ;Map block
  ld    bc,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ret

                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128
UnitSYSXTable14x14Portraits2:  
                dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(14*128)+(00/2)-128, $4000+(14*128)+(14/2)-128, $4000+(14*128)+(28/2)-128, $4000+(14*128)+(42/2)-128, $4000+(14*128)+(56/2)-128, $4000+(14*128)+(70/2)-128, $4000+(14*128)+(84/2)-128, $4000+(14*128)+(98/2)-128, $4000+(14*128)+(112/2)-128, $4000+(14*128)+(126/2)-128, $4000+(14*128)+(140/2)-128, $4000+(14*128)+(154/2)-128, $4000+(14*128)+(168/2)-128, $4000+(14*128)+(182/2)-128, $4000+(14*128)+(196/2)-128, $4000+(14*128)+(210/2)-128, $4000+(14*128)+(224/2)-128, $4000+(14*128)+(238/2)-128
                dw $4000+(28*128)+(00/2)-128, $4000+(28*128)+(14/2)-128, $4000+(28*128)+(28/2)-128, $4000+(28*128)+(42/2)-128, $4000+(28*128)+(56/2)-128, $4000+(28*128)+(70/2)-128, $4000+(28*128)+(84/2)-128, $4000+(28*128)+(98/2)-128, $4000+(28*128)+(112/2)-128, $4000+(28*128)+(126/2)-128, $4000+(28*128)+(140/2)-128, $4000+(28*128)+(154/2)-128, $4000+(28*128)+(168/2)-128, $4000+(28*128)+(182/2)-128, $4000+(28*128)+(196/2)-128, $4000+(28*128)+(210/2)-128, $4000+(28*128)+(224/2)-128, $4000+(28*128)+(238/2)-128
                dw $4000+(42*128)+(00/2)-128, $4000+(42*128)+(14/2)-128, $4000+(42*128)+(28/2)-128, $4000+(42*128)+(42/2)-128, $4000+(42*128)+(56/2)-128, $4000+(42*128)+(70/2)-128, $4000+(42*128)+(84/2)-128, $4000+(42*128)+(98/2)-128, $4000+(42*128)+(112/2)-128, $4000+(42*128)+(126/2)-128, $4000+(42*128)+(140/2)-128, $4000+(42*128)+(154/2)-128, $4000+(42*128)+(168/2)-128, $4000+(42*128)+(182/2)-128, $4000+(42*128)+(196/2)-128, $4000+(42*128)+(210/2)-128, $4000+(42*128)+(224/2)-128, $4000+(42*128)+(238/2)-128
                dw $4000+(56*128)+(00/2)-128, $4000+(56*128)+(14/2)-128, $4000+(56*128)+(28/2)-128, $4000+(56*128)+(42/2)-128, $4000+(56*128)+(56/2)-128, $4000+(56*128)+(70/2)-128, $4000+(56*128)+(84/2)-128, $4000+(56*128)+(98/2)-128, $4000+(56*128)+(112/2)-128, $4000+(56*128)+(126/2)-128, $4000+(56*128)+(140/2)-128, $4000+(56*128)+(154/2)-128, $4000+(56*128)+(168/2)-128, $4000+(56*128)+(182/2)-128, $4000+(56*128)+(196/2)-128, $4000+(56*128)+(210/2)-128, $4000+(56*128)+(224/2)-128, $4000+(56*128)+(238/2)-128
                dw $4000+(70*128)+(00/2)-128, $4000+(70*128)+(14/2)-128, $4000+(70*128)+(28/2)-128, $4000+(70*128)+(42/2)-128, $4000+(70*128)+(56/2)-128, $4000+(70*128)+(70/2)-128, $4000+(70*128)+(84/2)-128, $4000+(70*128)+(98/2)-128, $4000+(70*128)+(112/2)-128, $4000+(70*128)+(126/2)-128, $4000+(70*128)+(140/2)-128, $4000+(70*128)+(154/2)-128, $4000+(70*128)+(168/2)-128, $4000+(70*128)+(182/2)-128, $4000+(70*128)+(196/2)-128, $4000+(70*128)+(210/2)-128, $4000+(70*128)+(224/2)-128, $4000+(70*128)+(238/2)-128
                dw $4000+(84*128)+(00/2)-128, $4000+(84*128)+(14/2)-128, $4000+(84*128)+(28/2)-128, $4000+(84*128)+(42/2)-128, $4000+(84*128)+(56/2)-128, $4000+(84*128)+(70/2)-128, $4000+(84*128)+(84/2)-128, $4000+(84*128)+(98/2)-128, $4000+(84*128)+(112/2)-128, $4000+(84*128)+(126/2)-128, $4000+(84*128)+(140/2)-128, $4000+(84*128)+(154/2)-128, $4000+(84*128)+(168/2)-128, $4000+(84*128)+(182/2)-128, $4000+(84*128)+(196/2)-128, $4000+(84*128)+(210/2)-128, $4000+(84*128)+(224/2)-128, $4000+(84*128)+(238/2)-128

                dw $4000+(98*128)+(00/2)-128, $4000+(98*128)+(14/2)-128, $4000+(98*128)+(28/2)-128, $4000+(98*128)+(42/2)-128, $4000+(98*128)+(56/2)-128, $4000+(98*128)+(70/2)-128, $4000+(98*128)+(84/2)-128, $4000+(98*128)+(98/2)-128, $4000+(98*128)+(112/2)-128, $4000+(98*128)+(126/2)-128, $4000+(98*128)+(140/2)-128, $4000+(98*128)+(154/2)-128, $4000+(98*128)+(168/2)-128, $4000+(98*128)+(182/2)-128, $4000+(98*128)+(196/2)-128, $4000+(98*128)+(210/2)-128, $4000+(98*128)+(224/2)-128, $4000+(98*128)+(238/2)-128
                dw $4000+(112*128)+(00/2)-128, $4000+(112*128)+(14/2)-128, $4000+(112*128)+(28/2)-128, $4000+(112*128)+(42/2)-128, $4000+(112*128)+(56/2)-128, $4000+(112*128)+(70/2)-128, $4000+(112*128)+(84/2)-128, $4000+(112*128)+(98/2)-128, $4000+(112*128)+(112/2)-128, $4000+(112*128)+(126/2)-128, $4000+(112*128)+(140/2)-128, $4000+(112*128)+(154/2)-128, $4000+(112*128)+(168/2)-128, $4000+(112*128)+(182/2)-128, $4000+(112*128)+(196/2)-128, $4000+(112*128)+(210/2)-128, $4000+(112*128)+(224/2)-128, $4000+(112*128)+(238/2)-128
                dw $4000+(126*128)+(00/2)-128, $4000+(126*128)+(14/2)-128, $4000+(126*128)+(28/2)-128, $4000+(126*128)+(42/2)-128, $4000+(126*128)+(56/2)-128, $4000+(126*128)+(70/2)-128, $4000+(126*128)+(84/2)-128, $4000+(126*128)+(98/2)-128, $4000+(126*128)+(112/2)-128, $4000+(126*128)+(126/2)-128, $4000+(126*128)+(140/2)-128, $4000+(126*128)+(154/2)-128, $4000+(126*128)+(168/2)-128, $4000+(126*128)+(182/2)-128, $4000+(126*128)+(196/2)-128, $4000+(126*128)+(210/2)-128, $4000+(126*128)+(224/2)-128, $4000+(126*128)+(238/2)-128
                dw $4000+(140*128)+(00/2)-128, $4000+(140*128)+(14/2)-128, $4000+(140*128)+(28/2)-128, $4000+(140*128)+(42/2)-128, $4000+(140*128)+(56/2)-128, $4000+(140*128)+(70/2)-128, $4000+(140*128)+(84/2)-128, $4000+(140*128)+(98/2)-128, $4000+(140*128)+(112/2)-128, $4000+(140*128)+(126/2)-128, $4000+(140*128)+(140/2)-128, $4000+(140*128)+(154/2)-128, $4000+(140*128)+(168/2)-128, $4000+(140*128)+(182/2)-128, $4000+(140*128)+(196/2)-128, $4000+(140*128)+(210/2)-128, $4000+(140*128)+(224/2)-128, $4000+(140*128)+(238/2)-128

UnitSYSXTable14x24Portraits2:  
                dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(24*128)+(00/2)-128, $4000+(24*128)+(14/2)-128, $4000+(24*128)+(28/2)-128, $4000+(24*128)+(42/2)-128, $4000+(24*128)+(56/2)-128, $4000+(24*128)+(70/2)-128, $4000+(24*128)+(84/2)-128, $4000+(24*128)+(98/2)-128, $4000+(24*128)+(112/2)-128, $4000+(24*128)+(126/2)-128, $4000+(24*128)+(140/2)-128, $4000+(24*128)+(154/2)-128, $4000+(24*128)+(168/2)-128, $4000+(24*128)+(182/2)-128, $4000+(24*128)+(196/2)-128, $4000+(24*128)+(210/2)-128, $4000+(24*128)+(224/2)-128, $4000+(24*128)+(238/2)-128
                dw $4000+(48*128)+(00/2)-128, $4000+(48*128)+(14/2)-128, $4000+(48*128)+(28/2)-128, $4000+(48*128)+(42/2)-128, $4000+(48*128)+(56/2)-128, $4000+(48*128)+(70/2)-128, $4000+(48*128)+(84/2)-128, $4000+(48*128)+(98/2)-128, $4000+(48*128)+(112/2)-128, $4000+(48*128)+(126/2)-128, $4000+(48*128)+(140/2)-128, $4000+(48*128)+(154/2)-128, $4000+(48*128)+(168/2)-128, $4000+(48*128)+(182/2)-128, $4000+(48*128)+(196/2)-128, $4000+(48*128)+(210/2)-128, $4000+(48*128)+(224/2)-128, $4000+(48*128)+(238/2)-128
                dw $4000+(72*128)+(00/2)-128, $4000+(72*128)+(14/2)-128, $4000+(72*128)+(28/2)-128, $4000+(72*128)+(42/2)-128, $4000+(72*128)+(56/2)-128, $4000+(72*128)+(70/2)-128, $4000+(72*128)+(84/2)-128, $4000+(72*128)+(98/2)-128, $4000+(72*128)+(112/2)-128, $4000+(72*128)+(126/2)-128, $4000+(72*128)+(140/2)-128, $4000+(72*128)+(154/2)-128, $4000+(72*128)+(168/2)-128, $4000+(72*128)+(182/2)-128, $4000+(72*128)+(196/2)-128, $4000+(72*128)+(210/2)-128, $4000+(72*128)+(224/2)-128, $4000+(72*128)+(238/2)-128
                dw $4000+(96*128)+(00/2)-128, $4000+(96*128)+(14/2)-128, $4000+(96*128)+(28/2)-128, $4000+(96*128)+(42/2)-128, $4000+(96*128)+(56/2)-128, $4000+(96*128)+(70/2)-128, $4000+(96*128)+(84/2)-128, $4000+(96*128)+(98/2)-128, $4000+(96*128)+(112/2)-128, $4000+(96*128)+(126/2)-128, $4000+(96*128)+(140/2)-128, $4000+(96*128)+(154/2)-128, $4000+(96*128)+(168/2)-128, $4000+(96*128)+(182/2)-128, $4000+(96*128)+(196/2)-128, $4000+(96*128)+(210/2)-128, $4000+(96*128)+(224/2)-128, $4000+(96*128)+(238/2)-128
                dw $4000+(120*128)+(00/2)-128, $4000+(120*128)+(14/2)-128, $4000+(120*128)+(28/2)-128, $4000+(120*128)+(42/2)-128, $4000+(120*128)+(56/2)-128, $4000+(120*128)+(70/2)-128, $4000+(120*128)+(84/2)-128, $4000+(120*128)+(98/2)-128, $4000+(120*128)+(112/2)-128, $4000+(120*128)+(126/2)-128, $4000+(120*128)+(140/2)-128, $4000+(120*128)+(154/2)-128, $4000+(120*128)+(168/2)-128, $4000+(120*128)+(182/2)-128, $4000+(120*128)+(196/2)-128, $4000+(120*128)+(210/2)-128, $4000+(120*128)+(224/2)-128, $4000+(120*128)+(238/2)-128
                dw $4000+(144*128)+(00/2)-128, $4000+(144*128)+(14/2)-128, $4000+(144*128)+(28/2)-128, $4000+(144*128)+(42/2)-128, $4000+(144*128)+(56/2)-128, $4000+(144*128)+(70/2)-128, $4000+(144*128)+(84/2)-128, $4000+(144*128)+(98/2)-128, $4000+(144*128)+(112/2)-128, $4000+(144*128)+(126/2)-128, $4000+(144*128)+(140/2)-128, $4000+(144*128)+(154/2)-128, $4000+(144*128)+(168/2)-128, $4000+(144*128)+(182/2)-128, $4000+(144*128)+(196/2)-128, $4000+(144*128)+(210/2)-128, $4000+(144*128)+(224/2)-128, $4000+(144*128)+(238/2)-128

                dw $4000+(168*128)+(00/2)-128, $4000+(168*128)+(14/2)-128, $4000+(168*128)+(28/2)-128, $4000+(168*128)+(42/2)-128, $4000+(168*128)+(56/2)-128, $4000+(168*128)+(70/2)-128, $4000+(168*128)+(84/2)-128, $4000+(168*128)+(98/2)-128, $4000+(168*128)+(112/2)-128, $4000+(168*128)+(126/2)-128, $4000+(168*128)+(140/2)-128, $4000+(168*128)+(154/2)-128, $4000+(168*128)+(168/2)-128, $4000+(168*128)+(182/2)-128, $4000+(168*128)+(196/2)-128, $4000+(168*128)+(210/2)-128, $4000+(168*128)+(224/2)-128, $4000+(168*128)+(238/2)-128
                dw $4000+(192*128)+(00/2)-128, $4000+(192*128)+(14/2)-128, $4000+(192*128)+(28/2)-128, $4000+(192*128)+(42/2)-128, $4000+(192*128)+(56/2)-128, $4000+(192*128)+(70/2)-128, $4000+(192*128)+(84/2)-128, $4000+(192*128)+(98/2)-128, $4000+(192*128)+(112/2)-128, $4000+(192*128)+(126/2)-128, $4000+(192*128)+(140/2)-128, $4000+(192*128)+(154/2)-128, $4000+(192*128)+(168/2)-128, $4000+(192*128)+(182/2)-128, $4000+(192*128)+(196/2)-128, $4000+(192*128)+(210/2)-128, $4000+(192*128)+(224/2)-128, $4000+(192*128)+(238/2)-128
                dw $4000+(216*128)+(00/2)-128, $4000+(216*128)+(14/2)-128, $4000+(216*128)+(28/2)-128, $4000+(216*128)+(42/2)-128, $4000+(216*128)+(56/2)-128, $4000+(216*128)+(70/2)-128, $4000+(216*128)+(84/2)-128, $4000+(216*128)+(98/2)-128, $4000+(216*128)+(112/2)-128, $4000+(216*128)+(126/2)-128, $4000+(216*128)+(140/2)-128, $4000+(216*128)+(154/2)-128, $4000+(216*128)+(168/2)-128, $4000+(216*128)+(182/2)-128, $4000+(216*128)+(196/2)-128, $4000+(216*128)+(210/2)-128, $4000+(216*128)+(224/2)-128, $4000+(216*128)+(238/2)-128
                dw $4000+(230*128)+(00/2)-128, $4000+(230*128)+(14/2)-128, $4000+(230*128)+(28/2)-128, $4000+(230*128)+(42/2)-128, $4000+(230*128)+(56/2)-128, $4000+(230*128)+(70/2)-128, $4000+(230*128)+(84/2)-128, $4000+(230*128)+(98/2)-128, $4000+(230*128)+(112/2)-128, $4000+(230*128)+(126/2)-128, $4000+(230*128)+(140/2)-128, $4000+(230*128)+(154/2)-128, $4000+(230*128)+(168/2)-128, $4000+(230*128)+(182/2)-128, $4000+(230*128)+(196/2)-128, $4000+(230*128)+(210/2)-128, $4000+(230*128)+(224/2)-128, $4000+(230*128)+(238/2)-128


ClearBattleFieldGridStartOfBattle:
  ld    hl,.BattleFieldGrid
  ld    de,BattleFieldGrid
  ld    bc,EndBattleFieldGrid-BattleFieldGrid
  ldir
  ret

.BattleFieldGrid: ;0C15Ch
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000 
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000

SetFontPage0Y212:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetFontPage0Y250:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (250*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetBattleButtons:
  ld    hl,BattleButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*9)
  ldir

  call  .CheckRetreatButton

  .CheckAutoCombatButton:
  ;turn autocombat button off, when fighting vs human player
  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  ret   z

  ld    a,(PlayerThatGetsAttacked)      ;check if player that gets attacked is human
  ld    hl,player1human?-1
  ld    d,0
  ld    e,a
  add   hl,de
  ld    a,(hl)
  or    a
  ret   z                               ;if right player is computer autocombat is possible

  xor   a
  ld    (GenericButtonTable+6*GenericButtonTableLenghtPerButton),a
  ret

  .CheckRetreatButton:
  ;turn retreat button off, when fighting vs neutral monsters (monsters without hero)
  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  ret   nz

  xor   a
  ld    (GenericButtonTable+2*GenericButtonTableLenghtPerButton),a
  ret

BattleButton1Ytop:           equ 193 + 16
BattleButton1YBottom:        equ BattleButton1Ytop + 018
BattleButton1XLeft:          equ 002
BattleButton1XRight:         equ BattleButton1XLeft + 018

BattleButton2Ytop:           equ 193 + 16
BattleButton2YBottom:        equ BattleButton2Ytop + 018
BattleButton2XLeft:          equ 020
BattleButton2XRight:         equ BattleButton2XLeft + 018

BattleButton3Ytop:           equ 193 + 16
BattleButton3YBottom:        equ BattleButton3Ytop + 018
BattleButton3XLeft:          equ 038
BattleButton3XRight:         equ BattleButton3XLeft + 018

BattleButton4Ytop:           equ 193 + 16
BattleButton4YBottom:        equ BattleButton4Ytop + 018
BattleButton4XLeft:          equ 180
BattleButton4XRight:         equ BattleButton4XLeft + 018

BattleButton5Ytop:           equ 193 + 16
BattleButton5YBottom:        equ BattleButton5Ytop + 018
BattleButton5XLeft:          equ 198
BattleButton5XRight:         equ BattleButton5XLeft + 018

BattleButton6Ytop:           equ 193 + 16
BattleButton6YBottom:        equ BattleButton6Ytop + 018
BattleButton6XLeft:          equ 218
BattleButton6XRight:         equ BattleButton6XLeft + 018

BattleButton7Ytop:           equ 193 + 16
BattleButton7YBottom:        equ BattleButton7Ytop + 018
BattleButton7XLeft:          equ 236
BattleButton7XRight:         equ BattleButton7XLeft + 018

BattleButton8Ytop:           equ 192 + 16
BattleButton8YBottom:        equ BattleButton8Ytop + 010
BattleButton8XLeft:          equ 170
BattleButton8XRight:         equ BattleButton8XLeft + 010

BattleButton9Ytop:           equ 192+10 + 16
BattleButton9YBottom:        equ BattleButton9Ytop + 010
BattleButton9XLeft:          equ 170
BattleButton9XRight:         equ BattleButton9XLeft + 010


BattleButtonTableGfxBlock:  db  LevelUpBlock
BattleButtonTableAmountOfButtons:  db  9
BattleButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (160/2) - 128 | dw $4000 + (000*128) + (178/2) - 128 | dw $4000 + (000*128) + (196/2) - 128 | db BattleButton1Ytop,BattleButton1YBottom,BattleButton1XLeft,BattleButton1XRight | dw $0000 + (BattleButton1Ytop*128) + (BattleButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (214/2) - 128 | dw $4000 + (000*128) + (232/2) - 128 | dw $4000 + (018*128) + (160/2) - 128 | db BattleButton2Ytop,BattleButton2YBottom,BattleButton2XLeft,BattleButton2XRight | dw $0000 + (BattleButton2Ytop*128) + (BattleButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (018*128) + (178/2) - 128 | dw $4000 + (018*128) + (196/2) - 128 | dw $4000 + (018*128) + (214/2) - 128 | db BattleButton3Ytop,BattleButton3YBottom,BattleButton3XLeft,BattleButton3XRight | dw $0000 + (BattleButton3Ytop*128) + (BattleButton3XLeft/2) - 128

  db  %1100 0011 | dw $4000 + (054*128) + (160/2) - 128 | dw $4000 + (054*128) + (178/2) - 128 | dw $4000 + (054*128) + (196/2) - 128 | db BattleButton4Ytop,BattleButton4YBottom,BattleButton4XLeft,BattleButton4XRight | dw $0000 + (BattleButton4Ytop*128) + (BattleButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (018*128) + (232/2) - 128 | dw $4000 + (036*128) + (160/2) - 128 | dw $4000 + (036*128) + (178/2) - 128 | db BattleButton5Ytop,BattleButton5YBottom,BattleButton5XLeft,BattleButton5XRight | dw $0000 + (BattleButton5Ytop*128) + (BattleButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (036*128) + (196/2) - 128 | dw $4000 + (036*128) + (214/2) - 128 | dw $4000 + (036*128) + (232/2) - 128 | db BattleButton6Ytop,BattleButton6YBottom,BattleButton6XLeft,BattleButton6XRight | dw $0000 + (BattleButton6Ytop*128) + (BattleButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (054*128) + (214/2) - 128 | dw $4000 + (054*128) + (232/2) - 128 | dw $4000 + (072*128) + (160/2) - 128 | db BattleButton7Ytop,BattleButton7YBottom,BattleButton7XLeft,BattleButton7XRight | dw $0000 + (BattleButton7Ytop*128) + (BattleButton7XLeft/2) - 128
;text arrow up/down
  db  %1100 0011 | dw $4000 + (090*128) + (160/2) - 128 | dw $4000 + (090*128) + (170/2) - 128 | dw $4000 + (090*128) + (180/2) - 128 | db BattleButton8Ytop,BattleButton8YBottom,BattleButton8XLeft,BattleButton8XRight | dw $0000 + (BattleButton8Ytop*128) + (BattleButton8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (100*128) + (160/2) - 128 | dw $4000 + (100*128) + (170/2) - 128 | dw $4000 + (100*128) + (180/2) - 128 | db BattleButton9Ytop,BattleButton9YBottom,BattleButton9XLeft,BattleButton9XRight | dw $0000 + (BattleButton9Ytop*128) + (BattleButton9XLeft/2) - 128


HandleNecromancy:                       ;a percentage of dead enemy monsters will be revived as skeletons for the attacking hero
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillNecromancy
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillNecromancy
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillNecromancy
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillNecromancy
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillNecromancy
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillNecromancy
  ret

  .CheckSkillNecromancy:
  cp    31                              ;Basic Necromancy  (Revives 10% of enemy creatures fallen in battle)  
  jp    z,.BasicNecromancyFound
  cp    32                              ;Advanced Necromancy  (Revives 20% of enemy creatures fallen in battle)  
  jp    z,.AdvancedNecromancyFound
  cp    33                              ;Expert Necromancy  (Revives 30% of enemy creatures fallen in battle)  
  jp    z,.ExpertNecromancyFound
  ret

  .BasicNecromancyFound:
  call  CalculateTotalNumberOfUnitsLostDefender ;out: hl and bc=total dead units defender
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  DivideBCbyDE                    ;in: BC/DE. Out: BC = result, HL = rest
  call  SetMinimumOf1Unit
  call  SetSkeletonsInHeroUnitSlot      ;in: BC amount of skeletons
  jp    HandleSkullOfTheUnborn          ;another 10% of enemy units converted if hero has skull of the unborn

  .AdvancedNecromancyFound:
  call  CalculateTotalNumberOfUnitsLostDefender ;out: hl and bc=total dead units defender
  ld    de,05                           ;divide total attack by 5 to get 20%
  call  DivideBCbyDE                    ;in: BC/DE. Out: BC = result, HL = rest
  call  SetMinimumOf1Unit
  call  SetSkeletonsInHeroUnitSlot      ;in: BC amount of skeletons
  jp    HandleSkullOfTheUnborn          ;another 10% of enemy units converted if hero has skull of the unborn

  .ExpertNecromancyFound:
  call  CalculateTotalNumberOfUnitsLostDefender ;out: hl and bc=total dead units defender
  ld    de,03                           ;divide total attack by 3 to get 33.33%
  call  DivideBCbyDE                    ;in: BC/DE. Out: BC = result, HL = rest
  call  SetMinimumOf1Unit
  call  SetSkeletonsInHeroUnitSlot      ;in: BC amount of skeletons
  jp    HandleSkullOfTheUnborn          ;another 10% of enemy units converted if hero has skull of the unborn

HandleSkullOfTheUnborn:
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroInventory+7)          ;neclace
  cp    038                             ;item nr skull of the unborn
  ret   nz

  call  CalculateTotalNumberOfUnitsLostDefender ;out: hl and bc=total dead units defender
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  DivideBCbyDE                    ;in: BC/DE. Out: BC = result, HL = rest
  call  SetMinimumOf1Unit
  call  SetSkeletonsInHeroUnitSlot      ;in: BC amount of skeletons
  ret

SetMinimumOf1Unit:
  ld    a,b                             ;skeleton amount
  or    c                               ;skeleton amount
  ret   nz
  inc   bc
  ret

CalculateTotalNumberOfUnitsLostDefender:
  ld    bc,0                            ;total amount of units lost

  ld    iy,ListOfMonstersToPutMonster7
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster7
  call  .CalculateAmountOfUnitsLost

  ld    iy,ListOfMonstersToPutMonster8
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster8
  call  .CalculateAmountOfUnitsLost

  ld    iy,ListOfMonstersToPutMonster9
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster9
  call  .CalculateAmountOfUnitsLost

  ld    iy,ListOfMonstersToPutMonster10
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster10
  call  .CalculateAmountOfUnitsLost

  ld    iy,ListOfMonstersToPutMonster11
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster11
  call  .CalculateAmountOfUnitsLost

  ld    iy,ListOfMonstersToPutMonster12
  ld    l,(iy+1)
  ld    h,(iy+2)              ;amount units
  ld    ix,Monster12
  call  .CalculateAmountOfUnitsLost
  ret

  .CalculateAmountOfUnitsLost:
  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)

  or    a
  sbc   hl,de                           ;sub monster at start of fight - monsters at end

  add   hl,bc
  push  hl
  pop   bc
  ret

SetSkeletonsInHeroUnitSlot:
  ld    d,6                             ;6 unit slots to check

  ld    ix,(plxcurrentheroAddress)      ;attacking hero
  .loop:
  ld    a,(ix+HeroUnits+0)
  or    a
  jr    z,.EmptyUnitSlotFound
  cp    25                              ;already skeletons in this slot ?
  jr    z,.SlotWithSkeletonsFound
  
  inc   ix
  inc   ix
  inc   ix
  dec   d
  jr    nz,.loop
  ret

  .SlotWithSkeletonsFound:
  ld    l,(ix+HeroUnits+1)              ;skeleton amount
  ld    h,(ix+HeroUnits+2)              ;skeleton amount
  add   hl,bc
  ld    (ix+HeroUnits+1),l              ;skeleton amount
  ld    (ix+HeroUnits+2),h              ;skeleton amount
  ret

  .EmptyUnitSlotFound:
  ld    (ix+HeroUnits+0),25             ;skeleton unit
  ld    (ix+HeroUnits+1),c              ;skeleton amount
  ld    (ix+HeroUnits+2),b              ;skeleton amount
  ret







HandleProjectileSprite:
;  ld    a,(ShootProjectile?)          ;1=initiate, 2=handle projectile
  dec   a
  jr    nz,.HandleProjectile
    
  ;initiate
  ld    a,2
  ld    (ShootProjectile?),a          ;1=initiate, 2=handle projectile
  
  ;set starting coordinates
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterY)
  add   a,(ix+MonsterNY)
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  ld    a,(ix+MonsterNX)
  sub   a,16
  srl   a
  add   a,(ix+MonsterX)
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a  
;  ret

  .HandleProjectile:
  ld    a,(spat+4*16+1)
  ld    e,a                           ;x1
  ld    a,(spat+4*16)
  ld    d,a                           ;y1

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                      ;/2
  add   a,b                           ;explosion x
  ld    l,a                           ;x2

  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b
  sub   a,16
  ld    h,a                           ;y2

  ;check if endpoint is reached
  ld    a,d                           ;y1
  cp    h                             ;y2
  jr    nz,.EndCheckEndPointReached
  ld    a,e                           ;x1
  cp    l                             ;x2
  jp    z,.EndProjectile
  .EndCheckEndPointReached:


  ;(x1(e), y1(d)) are in DE, (x2(l), y2(h)) are in HL
  ld    a,h
  sub   a,d                           ;y2-y1
  jr    nc,.notcarry1
  neg
  .notcarry1:
  ld    c,a                           ;c is change in y-coordinate
  
  ld    a,l
  sub   a,e                           ;x2-x1
  jr    nc,.notcarry2
  neg
  .notcarry2:
  ld    b,a                           ;b is change in x-coordinate

  ; Check if the line is more horizontal or vertical
  cp    c
  jr    c,.MoreVertical

  .MoreHorizontal:
  ;we move more horizontal than vertical. 
  ;if b/c=1 its Movex 2x, Movey 2y
  ;if b/c=2 its Movex 3x, Movey 2y
  ;if b/c=3 its Movex 3x, Movey 1y
  ;if b/c=4 its Movex 4x, Movey 1y

  push  bc
  push  de
  ld    e,b
  call  Div8                          ;In: Divide E by divider C,  Out: A = result, B = rest
  pop   de
  pop   bc
  cp    2
  jr    c,.Move2x2y
  cp    3
  jr    c,.Move3x2y
  cp    4
  jr    c,.Move3x1y
  cp    5
  jr    c,.Move4x1y

  .Move4x1y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  jp    .SetCoordinates

  .Move3x1y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  jp    .SetCoordinates

  .Move3x2y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  call  .MoveY
  jp    .SetCoordinates

  .Move2x2y:  
  call  .MoveX
  call  .MoveX
  call  .MoveY
  call  .MoveY
  jp    .SetCoordinates

  .MoreVertical:
  ;we move more vertical than horizontal. 
  ;if c/b=1 its Movey 2x, Movex 2y
  ;if c/b=2 its Movey 3x, Movex 2y
  ;if c/b=3 its Movey 3x, Movex 1y
  ;if c/b=4 its Movey 4x, Movex 1y

  push  bc
  push  de
  ld    e,c
  ld    c,b
  call  Div8                          ;In: Divide E by divider C,  Out: A = result, B = rest
  pop   de
  pop   bc
  cp    2
  jr    c,.Move2y2x
  cp    3
  jr    c,.Move3y2x
  cp    4
  jr    c,.Move3y1x
  cp    5
  jr    c,.Move4y1x

  .Move4y1x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  jr    .SetCoordinates

  .Move3y1x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  jr    .SetCoordinates

  .Move3y2x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  call  .MoveX
  jr    .SetCoordinates

  .Move2y2x:  
  call  .MoveY
  call  .MoveY
  call  .MoveX
  call  .MoveX
  jr    .SetCoordinates

  .SetCoordinates:
  ld    a,e                           ;x1
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a
  ld    a,d                           ;y1
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteCharBeingHit + 0*96
	ld		c,$98
	call	outix96			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteColorBeingHit
	ld		c,$98
	call	outix48			;write sprite color of pointer and hand to vram
  ret

  .MoveY:
  ld    a,d                           ;y1
  cp    h                             ;y2
  ret   z
  inc   d
  ret   c
  dec   d
  dec   d
  ret

  .MoveX:
  ld    a,e                           ;x1
  cp    l                             ;x2
  ret   z
  inc   e
  ret   c
  dec   e
  dec   e
  ret

.EndProjectile:
  ld    a,213+16                        ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShootProjectile?),a  
  ret  


SpriteCharExplosion:
	include "../sprites/explosions.tgs.gen"
SpriteColorExplosion:
	include "../sprites/explosions.tcs.gen"

SpriteCharBeingHit:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/BeingHitSprite.spr"
SpriteColorBeingHit:
  ds 16,colorred| ds 16,colorsnowishwhite+64 | ds 16,colorwhite+64

HandleExplosionSprite:
;  ld    a,(ShowExplosionSprite?)      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
;  or    a
;  ret   z
  dec   a
  jp    z,BeingHitSprite

  ld    a,(MonsterThatIsBeingAttackedNX)
  cp    17
  jp    c,SmallExplosionSprite
  jp    BigExplosionSprite

  BeingHitSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  ;if nx=16 add 0 to monsterx
  ;if nx=32 add 8 to monsterx
  ;if nx=48 add 16 to monsterx
  ;if nx=64 add 24 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    2
  ld    hl,SpriteCharBeingHit + 0*96
  jr    c,.CharFound
  cp    4
  ld    hl,SpriteCharBeingHit + 1*96
  jr    c,.CharFound
  ld    hl,SpriteCharBeingHit + 2*96
  .CharFound:
	ld		c,$98
	call	outix96			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteColorBeingHit
	ld		c,$98
	call	outix48			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    6
  ret   c
  
  ld    a,213+16                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShowExplosionSprite?),a  
  ret  

  SmallExplosionSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a

  ;if nx=16 add 0 to monsterx
  ;if nx=32 add 8 to monsterx
  ;if nx=48 add 16 to monsterx
  ;if nx=64 add 24 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteCharExplosion + 0*64 + 5*256
  jr    c,.CharFound
  cp    8
  ld    hl,SpriteCharExplosion + 1*64 + 5*256
  jr    c,.CharFound
  cp    12
  ld    hl,SpriteCharExplosion + 2*64 + 5*256
  jr    c,.CharFound
  ld    hl,SpriteCharExplosion + 3*64 + 5*256
  .CharFound:
	ld		c,$98
	call	outix64			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteColorExplosion + 0*32 + 5*128
  jr    c,.ColorFound
  cp    8
  ld    hl,SpriteColorExplosion + 1*32 + 5*128
  jr    c,.ColorFound
  cp    12
  ld    hl,SpriteColorExplosion + 2*32 + 5*128
  jr    c,.ColorFound
  ld    hl,SpriteColorExplosion + 3*32 + 5*128
  .ColorFound:
	ld		c,$98
	call	outix32			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    16
  ret   c
  
  ld    a,213+16                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShowExplosionSprite?),a  
  ret

  BigExplosionSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,32
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a
  ld    (spat+4*19),a
  add   a,16
  ld    (spat+4*20),a
  ld    (spat+4*21),a
  ld    (spat+4*22),a
  ld    (spat+4*23),a

  ;if nx=32 add 0 to monsterx
  ;if nx=48 add 8 to monsterx
  ;if nx=64 add 16 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,32
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*20+1),a
  ld    (spat+4*21+1),a  
  add   a,16
  ld    (spat+4*18+1),a
  ld    (spat+4*19+1),a
  ld    (spat+4*22+1),a
  ld    (spat+4*23+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteCharExplosion + 0*256
  jr    c,.CharFound
  cp    8
  ld    hl,SpriteCharExplosion + 1*256
  jr    c,.CharFound
  cp    12
  ld    hl,SpriteCharExplosion + 2*256
  jr    c,.CharFound
  cp    16
  ld    hl,SpriteCharExplosion + 3*256
  jr    c,.CharFound
  ld    hl,SpriteCharExplosion + 4*256
  .CharFound:
	ld		c,$98
	call	outix256			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteColorExplosion + 0*128
  jr    c,.ColorFound
  cp    8
  ld    hl,SpriteColorExplosion + 1*128
  jr    c,.ColorFound
  cp    12
  ld    hl,SpriteColorExplosion + 2*128
  jr    c,.ColorFound
  cp    16
  ld    hl,SpriteColorExplosion + 3*128
  jr    c,.ColorFound
  ld    hl,SpriteColorExplosion + 4*128
  .ColorFound:
	ld		c,$98
	call	outix128			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    20
  ret   c
  
  ld    a,213+16                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a
  ld    (spat+4*19),a
  ld    (spat+4*20),a
  ld    (spat+4*21),a
  ld    (spat+4*22),a
  ld    (spat+4*23),a

  xor   a
  ld    (ShowExplosionSprite?),a  
  ret

ClearBattleText:
  ld    hl,.BattleTextPointer
  ld    de,BattleTextPointer
  ld    bc,.EndBattleText-.BattleTextPointer
  ldir
  ret

.BattleTextPointer:  dw  BattleText2
.BattleRound:  db  1
.SetBattleText?: db  2                               ;amount of frames/pages text will be put        
.BattleText8: db 0 | dw 0000 | db 0    ,"           ",255  ;example next round:  Round 4 begins
.BattleText7: db 0 | dw 0000 | db 0    ,"           ",255  ;example next round:  Round 4 begins
.BattleText6: db 0 | dw 0000 | db 0    ,"           ",255  ;example next round:  Round 4 begins
.BattleText5: db 0 | dw 0000 | db 0    ,"           ",255  ;example next round:  Round 4 begins
.BattleText4: db 0 | dw 0000 | db 0    ,"           ",255  ;example units dead:  300 SilkenLarva(s) die 
.BattleText3: db 0 | dw 0000 | db 0    ,"           ",255  ;example deal damage: SilkenLarva do/deal 2222 dmg
.BattleText2: db 0 | dw 0000 | db 0    ,"           ",255  ;example defend:      SilkenLarva(s): +10 defense
.BattleText1: db 5 | dw 0001 | db 0    ,"           ",255  ;example wait:        The SilkenLarva(s) wait
.BattleTextQ: db 0 | dw 0000 | db 0    ,"           ",255  ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
.EndBattleText:

SetBattleText:
  ld    a,(LeftOrRightPlayerLostEntireArmy?)
  or    a
  ret   nz

  ld    a,(SetBattleText?)
  dec   a
  ret   m
  ld    (SetBattleText?),a
  dec   a
  call  z,.MoveEveryTextEntry1PositionUp;the first frame we set text, setup the text in the list
;  cp    10
;  jp    z,.ResetBattleTextPointer
  cp    7
  jp    z,.EndSetBattleText

  .SetBattleTextWithoutMovingEntries:
  call  .CleanTextField

  ld    ix,(BattleTextPointer)
  ld    c,195+16                           ;dy
  call  .SetText
  ld    de,BattleTextQ-BattleText1
  add   ix,de
  ld    c,203+16                           ;dy
  call  .SetText
  ret

  .SetText:
  ld    b,060                           ;dx

  ld    a,(ix)                          ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
  dec   a
  jp    z,.wait
  dec   a
  jp    z,.defend
  dec   a
  jp    z,.DealDamage
  dec   a
;  jp    z,.UnitsDie
  dec   a
  jp    z,.NextRound
  ret

  .NextRound:
  ld    a,(ix+1)                        ;round nr
  dec   a
  jr    z,.CombatStart

  ld    hl,.TextRound
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  ld    a,(ix+1)                        ;round nr
  ld    h,0
  ld    l,a
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetNumber16BitCastle
  pop   bc

  ld    hl,.TextBegins
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
;  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
;  pop   bc
  ret

  .CombatStart:
  ld    hl,.TextCombatStart
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  ret
  
.TextCombatStart: db "      Combat Start",255
.TextRound: db "Round ",255
.TextBegins: db " begins.",255

  .defend:
  push  ix
  pop   hl
  ld    de,4
  add   hl,de                           ;monster name
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  dec   hl
  ld    a,(hl)
  cp    "s"
  ld    hl,.TextdefendMultipleUnits
  jr    nz,.EndCheckNameEndsWithS_defend
  ld    hl,.TextdefendMultipleUnits+1
  .EndCheckNameEndsWithS_defend:

  ld    a,(ix+3)                        ;single unit ?
  dec   a
  jr    nz,.AmountFound2
  ld    hl,.TextdefendSingleUnit
  .AmountFound2:
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  ld    hl,.TextdefendOpenPlus
  ld    a,(PutLetter+dx)                ;set dx of text  
  add   a,2
  ld    b,a                             ;dx
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  ld    a,(ix+1)                        ;amount of added defense
  ld    h,0
  ld    l,a
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetNumber16BitCastle
  pop   bc

  ld    hl,.Textdef
  ld    a,(PutLetter+dx)                ;set dx of text  
  add   a,1
  ld    b,a                             ;dx
;  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
;  pop   bc
  ret

.TextdefendOpenPlus: db "(+",255
.TextdefendSingleUnit: db " defends.",255
.TextdefendMultipleUnits: db "s defend.",255
.Textdef: db "def)",255

  .wait:
  ld    hl,.TextThe
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  push  ix
  pop   hl
  ld    de,4
  add   hl,de                           ;monster name
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc


  dec   hl
  ld    a,(hl)
  cp    "s"
  ld    hl,.TextwaitsMultipleUnits
  jr    nz,.EndCheckNameEndsWithS_wait
  ld    hl,.TextwaitsMultipleUnits+1
  .EndCheckNameEndsWithS_wait:

  ld    a,(ix+3)                        ;single unit ?
  dec   a
  jr    nz,.AmountFound1
  ld    hl,.TextwaitsSingleUnit
  .AmountFound1:

  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
;  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
;  pop   bc
  ret
.TextThe: db "The ",255
.TextwaitsSingleUnit: db " waits.",255
.TextwaitsMultipleUnits: db "s wait.",255


.DealDamage:
  push  ix
  pop   hl
  ld    de,4
  add   hl,de                           ;monster name
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc


  dec   hl
  ld    a,(hl)
  cp    "s"
  ld    hl,.TextdealdamageMultipleUnits
  jr    nz,.EndCheckNameEndsWithS_dealdamage
  ld    hl,.TextdealdamageMultipleUnits+1
  .EndCheckNameEndsWithS_dealdamage:



  ld    a,(ix+3)                        ;single unit ?
  dec   a
  jr    nz,.AmountFound3
  ld    hl,.TextdealdamageSingleUnit
  .AmountFound3:

  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
  pop   bc

  ld    l,(ix+1)                        ;amount of damage
  ld    h,(ix+2)                        ;amount of damage
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
  push  bc
  call  SetNumber16BitCastle
  pop   bc

  ld    hl,.TextsDMG
  ld    a,(PutLetter+dx)                ;set dx of text  
  ld    b,a                             ;dx
;  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text    
;  pop   bc
  ret
.TextdealdamageSingleUnit: db " deals ",255
.TextdealdamageMultipleUnits: db "s deal ",255
.TextsDMG: db " dmg.",255

.EndSetBattleText:
  xor   a
  ld    (SetBattleText?),a
  ret

.MoveEveryTextEntry1PositionUp:
  ld    hl,BattleText7
  ld    de,BattleText8
  ld    bc,BattleTextQ-BattleText8
  ldir
;  jp    .ResetBattleTextPointer

.ResetBattleTextPointer:
  ld    hl,BattleText2
  ld    (BattleTextPointer),hl
  ret

.CleanTextField:
  ld    hl,$4000 + (195*128) + (060/2) - 128
  ld    de,$0000 + ((195+16)*128) + (060/2) - 128
  ld    bc,$0000 + (014*256) + (118/2)
  ld    a,BattleFieldWinterBlock         ;font graphics block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

;defending hero died, and loses items
AttackingHeroTakesItemsDefendingHero:
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  push  iy
  pop   hl
  ld    a,l
  or    h
  ret   z                               ;we cant take items from neutral monsters

  ld    d,9 + 6                         ;9 body slots, 6 open slots
  .PassItemLoop:
  call  .PassItem
  inc   ix
  inc   iy
  dec   d
  jr    nz,.PassItemLoop
  ret
  
  .PassItem:
  ld    a,(iy+HeroInventory)
  cp    045                             ;empty slot ? (no item to pass)
  ret   z
  ld    c,a
  ld    a,(ix+HeroInventory)
  cp    045                             ;empty slot to put item ?
  jr    z,.EmptyBodySlotFound
  ;at this point receiving hero has no empty body slots, see if there is an empty open slot and put item there
  push  ix
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ld    b,6                             ;amount of open slots
  .loop:
  ld    a,(ix+HeroInventory+9)
  cp    045
  jr    z,.EmptyOpenSlotFound
  inc   ix
  djnz  .loop
  pop   ix
  ret

  .EmptyBodySlotFound:
  ld    (ix+HeroInventory),c
  ret
  .EmptyOpenSlotFound:
  ld    (ix+HeroInventory+9),c
  pop   ix
  ret

SetSpellExplanation:
  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
  ld    (MenuOptionSelected?Backup),a

  ld    a,1
  ld    (SpellExplanationDisplayed?),a

  xor   a                 ;hack to set text in current page
  ld    (SetText.SelfModifyingCodeSetTextInCurrentPage),a

  call  .SetDescriptionTexticonCostAndDamage
;  call  .GoSetText
;  call  .SetSpellIcon
;  call  .SetCost
;  call  .SetDamage

  ld    a,1               ;back to set text in buffer page
  ld    (SetText.SelfModifyingCodeSetTextInCurrentPage),a
  ret










  .SetDescriptionTexticonCostAndDamage:
  ld    a,(MenuOptionSelected?Backup)
  dec   a
  ld    hl,SpellDescriptionsBattle.DescriptionAllSpellSchools1
  ld    de,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  ld    b,CostAllSpellSchools1
  ld    c,DamageAllSpellSchools1
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  dec   a
  ld    hl,SpellDescriptionsBattle.DescriptionAllSpellSchools2
  ld    de,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  ld    b,CostAllSpellSchools2
  ld    c,DamageAllSpellSchools2
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  dec   a
  ld    hl,SpellDescriptionsBattle.DescriptionAllSpellSchools3
  ld    de,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  ld    b,CostAllSpellSchools3
  ld    c,DamageAllSpellSchools3
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  dec   a
  ld    hl,SpellDescriptionsBattle.DescriptionAllSpellSchools4
  ld    de,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  ld    b,CostAllSpellSchools4
  ld    c,DamageAllSpellSchools4
  jp    z,.GoSetDescriptionTexticonCostAndDamage

  ld    a,(SelectedElementInSpellBook)  ;0=earth, 1=fire, 2=air, 3=water
  or    a
  jp    z,.SetSpellExplanationEarth
  dec   a
  jp    z,.SetSpellExplanationFire
  dec   a
  jp    z,.SetSpellExplanationAir
  
  .SetSpellExplanationWater:
  ld    a,(MenuOptionSelected?Backup)
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.Descriptionwater1
  ld    de,$4000 + (Spell16IconSY*128) + (Spell16IconSX/2) -128
  ld    b,CostWaterSpell1
  ld    c,DamageWaterSpell1
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.Descriptionwater2
  ld    de,$4000 + (Spell15IconSY*128) + (Spell15IconSX/2) -128
  ld    b,CostWaterSpell2
  ld    c,DamageWaterSpell2
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.Descriptionwater3
  ld    de,$4000 + (Spell14IconSY*128) + (Spell14IconSX/2) -128
  ld    b,CostWaterSpell3
  ld    c,DamageWaterSpell3
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  ld    hl,SpellDescriptionsBattle.Descriptionwater4
  ld    de,$4000 + (Spell13IconSY*128) + (Spell13IconSX/2) -128
  ld    b,CostWaterSpell4
  ld    c,DamageWaterSpell4
  jp    .GoSetDescriptionTexticonCostAndDamage

  .SetSpellExplanationAir:
  ld    a,(MenuOptionSelected?Backup)
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionAir1
  ld    de,$4000 + (Spell12IconSY*128) + (Spell12IconSX/2) -128
  ld    b,CostAirSpell1
  ld    c,DamageAirSpell1
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionAir2
  ld    de,$4000 + (Spell11IconSY*128) + (Spell11IconSX/2) -128
  ld    b,CostAirSpell2
  ld    c,DamageAirSpell2
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionAir3
  ld    de,$4000 + (Spell10IconSY*128) + (Spell10IconSX/2) -128
  ld    b,CostAirSpell3
  ld    c,DamageAirSpell3
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  ld    hl,SpellDescriptionsBattle.DescriptionAir4
  ld    de,$4000 + (Spell09IconSY*128) + (Spell09IconSX/2) -128
  ld    b,CostAirSpell4
  ld    c,DamageAirSpell4
  jp    .GoSetDescriptionTexticonCostAndDamage

  .SetSpellExplanationFire:
  ld    a,(MenuOptionSelected?Backup)
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionFire1
  ld    de,$4000 + (Spell08IconSY*128) + (Spell08IconSX/2) -128
  ld    b,CostFireSpell1
  ld    c,DamageFireSpell1
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionFire2
  ld    de,$4000 + (Spell07IconSY*128) + (Spell07IconSX/2) -128
  ld    b,CostFireSpell2
  ld    c,DamageFireSpell2
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionFire3
  ld    de,$4000 + (Spell06IconSY*128) + (Spell06IconSX/2) -128
  ld    b,CostFireSpell3
  ld    c,DamageFireSpell3
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  ld    hl,SpellDescriptionsBattle.DescriptionFire4
  ld    de,$4000 + (Spell05IconSY*128) + (Spell05IconSX/2) -128
  ld    b,CostFireSpell4
  ld    c,DamageFireSpell4
  jp    .GoSetDescriptionTexticonCostAndDamage

  .SetSpellExplanationEarth:
  ld    a,(MenuOptionSelected?Backup)
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionEarth1
  ld    de,$4000 + (Spell04IconSY*128) + (Spell04IconSX/2) -128
  ld    b,CostEarthSpell1
  ld    c,DamageEarthSpell1
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionEarth2
  ld    de,$4000 + (Spell03IconSY*128) + (Spell03IconSX/2) -128
  ld    b,CostEarthSpell2
  ld    c,DamageEarthSpell2
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptionsBattle.DescriptionEarth3
  ld    de,$4000 + (Spell02IconSY*128) + (Spell02IconSX/2) -128
  ld    b,CostEarthSpell3
  ld    c,DamageEarthSpell3
  jp    z,.GoSetDescriptionTexticonCostAndDamage
  ld    hl,SpellDescriptionsBattle.DescriptionEarth4
  ld    de,$4000 + (Spell01IconSY*128) + (Spell01IconSX/2) -128
  ld    b,CostEarthSpell4
  ld    c,DamageEarthSpell4
  jp    .GoSetDescriptionTexticonCostAndDamage


  .GoSetDescriptionTexticonCostAndDamage:
  push  bc                              ;cost and damage
  push  de                              ;spell icon SY SX
  
  ;description
  ld    b,SpellBookX + 030
  ld    c,SpellBookY + 159
  call  SetText
  
  pop   hl                              ;spell icon SY SX
  ld    de,$0000 + ((SpellBookY + 160) *128) + ((SpellBookX+10)/2)
  ld    bc,$0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  pop   bc                              ;cost and damage
  push  bc
  .CostAmountFound:
  ld    l,b
  ld    h,0
  ld    b,SpellBookX + 174
  ld    c,SpellBookY + 159
  push  iy
  call  SetNumber16BitCastle
  pop   iy

  ld    b,SpellBookX + 148
  ld    c,SpellBookY + 159
  ld    hl,.TextCost
  call  SetText

  pop   bc                              ;cost and damage
  .DamageAmountFound:
  ld    a,c
  or    a
  ret   z
  ld    b,SpellBookX + 168
  ld    c,SpellBookY + 173
  push  iy
  ld    l,a
  ld    h,0
  call  SetNumber16BitCastle
  pop   iy

  ld    b,SpellBookX + 132
  ld    c,SpellBookY + 173
  ld    hl,.TextDamage
  jp    SetText
  .TextDamage: db  "Damage:",255
  .TextCost: db  "Cost:",255  
  











SpellDescriptionsBattle:
.DescriptionEarth4:       db  "Ethereal Chains",254
                          db  "Reduces the speed of the selected",254
                          db  "enemy unit by 50%",255

.DescriptionEarth3:       db  "Plate Armor",254
                          db  "Increases the defense of the selected",254
                          db  "friendly unit by 5.",255

.DescriptionEarth2:       db  "Resurrection",254
                          db  "Reanimates 40 HP of killed living",254
                          db  "friendly creatures.",255

.DescriptionEarth1:       db  "Meteor Shower",254
                          db  "Deals damage to all creatures in target",254
                          db  "and adjacent hexes.",255


.DescriptionFire4:        db  "Curse",254
                          db  "Causes the selected enemy unit to deal",254
                          db  "-3 damage when attacking.",255

.DescriptionFire3:        db  "Blur",254
                          db  "Target ranged unit deals 50% less",254
                          db  "damage.",255

.DescriptionFire2:        db  "Fireball",254
                          db  "Deals damage to target unit and",254
                          db  "adjecent units.",255

.DescriptionFire1:        db  "Inferno",254
                          db  "Deals damage in a 5 hex area of",254
                          db  "effect.",255


.Descriptionair4:         db  "Haste",254
                          db  "Increases the speed of the selected",254
                          db  "friendly unit by 4.",255

.Descriptionair3:         db  "Disrupting Ray",254
                          db  "Reduces the defense of the selected ",254
                          db  "unit by 4.",255

.Descriptionair2:         db  "Counterstrike",254
                          db  "Target allied unit has unlimited",254
                          db  "retaliations each round.",255

.Descriptionair1:         db  "Chain Lightning",254
                          db  "Strikes up to 5 troops on the",254
                          db  "battlefield.",255


.Descriptionwater4:       db  "Cure",254
                          db  "Removes all negative spell effects",254
                          db  "and heals for 20 HP",255

.Descriptionwater3:       db  "Ice Bolt",254
                          db  "Deals damage to a single enemy unit.",254
                          db  " ",255

.Descriptionwater2:       db  "Ice Trap",254
                          db  "Enemy unit cant attack until attacked,",254
                          db  "dispelled or effect wears off",255


.Descriptionwater1:       db  "Frost Ring",254
                          db  "Causes damage to all units adjacent to",254
                          db  "the central hex.",255


.DescriptionAllSpellSchools4:  db  "Magic Arrow",254
                              db  "Deals damage to selected enemy unit.",254
                              db  " ",255

.DescriptionAllSpellSchools3:  db  "Frenzy",254
                              db  "Unit's defense is added to it's attack,",254
                              db  "while defense is set to 0.",255

.DescriptionAllSpellSchools2:  db  "Teleport",254
                              db  "Teleport allied troop to an unoccupied",254
                              db  "space.",255

.DescriptionAllSpellSchools1:  db  "Inner Beast",254
                              db  "Friendly unit receievs +3 attack,",254
                              db  "+3 defense and +3 speed.",255










SpellBookX:  equ 032
SpellBookY:  equ 002+BattleScreenVerticalOffset
HandleSpellBook:
  ld    a,(SpellBookButtonPressed?)
  or    a
  ret   z
	ld		a,(activepage)
  or    a
  ret   z                               ;wait until we are in page 1
  xor   a
  ld    (SpellBookButtonPressed?),a
  ;build up all graphics in page 0
  call  SetGraphicsSpellBook

  ld    ix,(plxcurrentheroAddress)
  call  SetGraphicsElementalSpells
  call  SetGraphicsElementalSpells.SetUniversalSpells
  call  LightUpCurrentActiveElementalButton
  halt                                  ;swap page on vblank for smooth transition
  call  SwapAndSetPage                  ;swap and set page 0


  .engine:
  call  PopulateControls                ;read out keys


  ;handle interaction mouse - elemental buttons (4 buttons on the left side)
  ld    ix,BattleSpellBookButtonTable
  ld    iy,ButtonTableSpellBookSYSX_Water
  call  CheckButtonMouseInteraction4ElementalButtons
  ld    a,b
  or    a
  call  nz,.ElementalButtonPressed
;  call  CheckEndHeroOverviewSpellBook   ;check if mouse is clicked outside of window. If so, return to game
  ld    ix,BattleSpellBookButtonTable
  call  .CopyButtons                      ;copies button state from rom -> vram
  ;/handle interaction mouse - elemental buttons (4 buttons on the left side)


  ;handle interaction mouse - spell buttons (elemental and universal)
  ld    ix,BattleSpellIconButtons
  ld    a,(SelectedElementInSpellBook)  ;0=earth, 1=fire, 2=air, 3=water
  or    a
  ld    iy,ButtonTableSpellIconsEarthSYSX
  jp    z,.ElementFound
  dec   a
  ld    iy,ButtonTableSpellIconsFireSYSX
  jp    z,.ElementFound
  dec   a
  ld    iy,ButtonTableSpellIconsAirSYSX
  jp    z,.ElementFound
  ld    iy,ButtonTableSpellIconsWaterSYSX
  .ElementFound:
  call  .CheckButtonMouseInteraction
;  ld    a,(MenuOptionSelected?)
;  or    a
;  jp    nz,.SpellIconPressed
  ld    ix,BattleSpellIconButtons
  call  .CopyButtons                      ;copies button state from rom -> vram
  ;/handle interaction mouse - spell buttons (elemental and universal)

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  jp    nz,ExitSpellBook
  call  CheckMouseClickOutsideSpellBook ;check if mouse is clicked outside of window. If so, return to battle
  jp    .engine


  .ElementalButtonPressed:
  ld    a,%1000 0011
  ld    (BattleSpellBookButtonTable + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    (BattleSpellBookButtonTable + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    (BattleSpellBookButtonTable + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    (BattleSpellBookButtonTable + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  

  call  .HandleSelectedElementButton

  ld    ix,(plxcurrentheroAddress)
  jp    SetGraphicsElementalSpells

  .HandleSelectedElementButton:
  ld    a,b
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,.Water
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,.AirSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,.FireSelected
;  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
;  jp    z,.EarthSelected

  .EarthSelected:
  xor   a
  ld    (BattleSpellBookButtonTable + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    (SelectedElementInSpellBook),a  ;0=earth, 1=fire, 2=air, 3=water
  ret

  .FireSelected:
  xor   a
  ld    (BattleSpellBookButtonTable + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,1
  ld    (SelectedElementInSpellBook),a  ;0=earth, 1=fire, 2=air, 3=water
  ret

  .AirSelected:
  xor   a
  ld    (BattleSpellBookButtonTable + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,2
  ld    (SelectedElementInSpellBook),a  ;0=earth, 1=fire, 2=air, 3=water
  ret

  .Water:
  xor   a
  ld    (BattleSpellBookButtonTable + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,3
  ld    (SelectedElementInSpellBook),a  ;0=earth, 1=fire, 2=air, 3=water
  ret



.CopyButtons:                       ;copies button state from rom -> vram. in IX->ix,HeroOverview*****ButtonTable, bc->$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
;  ld    ix,HeroOverviewSpellBookButtonTable
;  ld    iy,ButtonTableSpellBookSYSX
;  ld    bc,$0000 + (HeroOverViewSpellBookWindowButtonNY*256) + (HeroOverViewSpellBookWindowButtonNX/2)

  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,ButtonTableLenght
  add   ix,de
  ld    de,6                            ;lenght of button data
  add   iy,de
  djnz  .loop
  ret

  .Setbutton:
  bit   0,(ix+HeroOverviewWindowButtonStatus)
  jr    nz,.bit0isSet
  bit   1,(ix+HeroOverviewWindowButtonStatus)
  ret   z
  
  .bit1isSet:
  res   1,(ix+HeroOverviewWindowButtonStatus)
  jr    .goCopyButton
  .bit0isSet:
  res   0,(ix+HeroOverviewWindowButtonStatus)  
  .goCopyButton:

  bit   7,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonOff)
  ld    h,(iy+ButtonOff+1)
  jr    nz,.go                          ;(bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  bit   6,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonMouseOver)
  ld    h,(iy+ButtonMouseOver+1)
  jr    nz,.go                          ;(bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
;  bit   5,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonOMouseClicked)
  ld    h,(iy+ButtonOMouseClicked+1)
  .go:
  
  ld    e,(ix+HeroOverviewWindowButton_de)
  ld    d,(ix+HeroOverviewWindowButton_de+1)

  ld    c,(ix+Buttonnynx)
  ld    b,(ix+Buttonnynx+1)

  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
















.CheckButtonMouseInteraction:
  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  ld    de,ButtonTableLenght

  .loop2:
  call  .check
  add   ix,de
  djnz  .loop2

  ld    a,(SpellExplanationDisplayed?)  
  or    a
  ret   z
  xor   a
  ld    (SpellExplanationDisplayed?),a  

  ;if there is a spell explanation displayed and mouse is not over any spell icon, erase the spell explanation
;  ld    hl,$4000 + (000*128) + (000/2) -128
;  ld    de,$0000 + (SpellBookY*128) + (SpellBookX/2)
;  ld    bc,$0000 + (HeroOverViewSpellBookWindowNY*256) + (HeroOverViewSpellBookWindowNX/2)

  ld    hl,$4000 + (158*128) + (010/2) -128
  ld    de,$0000 + ((SpellBookY+158)*128) + ((SpellBookX+10)/2)
  ld    bc,$0000 + (20*256) + (176/2)
  ld    a,SpellBookGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
  .check:
  ld    a,(ix+HeroOverviewWindowButtonStatus)
  or    a
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+HeroOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+HeroOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonXright)
  jr    nc,.NotOverButton
  ;at this point mouse pointer is over button, so light the edge of the button. Check if mouse button is pressed, in that case light entire button  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ld    a,(Controls)
  bit   4,a                             ;check trigger a / space
  jr    nz,.MouseOverButtonAndSpacePressed
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.MenuOptionSelected           ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  pop   af                              ;no need to check the other buttons
  bit   6,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ret   nz
  ld    (ix+HeroOverviewWindowButtonStatus),%0100 0011
  jp    SetSpellExplanation             ;when first time hovering over a button, show the spell explanation

  .MouseOverButtonAndSpacePressed:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  pop   af                              ;no need to check the other buttons
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  pop   af                              ;no need to check the other buttons
  ret

   .NotOverButton:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.buttonIsStillLit
  bit   6,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  pop   af                              ;no need to check the other buttons
  ret

.MenuOptionSelected:
  ld    (ix+HeroOverviewWindowButtonStatus),%1010 0011

  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
;  ld    (MenuOptionSelected?),a
  pop   af                                    ;pop the call in the button check loop 
  ret






CheckButtonMouseInteraction4ElementalButtons:
  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  ld    de,ButtonTableLenght

  .loop2:
  call  .check
  add   ix,de
  djnz  .loop2
  ret
  
  .check:
  ld    a,(ix+HeroOverviewWindowButtonStatus)
  or    a
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+HeroOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+HeroOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonXright)
  jr    nc,.NotOverButton
  ;at this point mouse pointer is over button, so light the edge of the button. Check if mouse button is pressed, in that case light entire button  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ld    a,(Controls)
  bit   4,a                             ;check trigger a / space
  jr    nz,.MouseOverButtonAndSpacePressed
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.MenuOptionSelected           ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  bit   6,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ret   nz
  ld    (ix+HeroOverviewWindowButtonStatus),%0100 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  ret

   .NotOverButton:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.buttonIsStillLit
  bit   6,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  ret

.MenuOptionSelected:
  ld    (ix+HeroOverviewWindowButtonStatus),%1010 0011

  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
;  ld    (MenuOptionSelected?),a
  pop   af                                    ;pop the call in the button check loop 
  ret








LightUpCurrentActiveElementalButton:
  ld    a,(SelectedElementInSpellBook)  ;0=earth, 1=fire, 2=air, 3=water
  or    a
  jr    z,.Earth
  dec   a
  jr    z,.Fire
  dec   a
  jr    z,.Air

  .Water:
  ld    a,%0010 0011
  ld    (BattleSpellBookButtonTable + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  call  .LightUpButton
  xor   a
  ld    (BattleSpellBookButtonTable + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ret

  .Air:
  ld    a,%0010 0011
  ld    (BattleSpellBookButtonTable + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  call  .LightUpButton
  xor   a
  ld    (BattleSpellBookButtonTable + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ret

  .Fire:
  ld    a,%0010 0011
  ld    (BattleSpellBookButtonTable + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  call  .LightUpButton
  xor   a
  ld    (BattleSpellBookButtonTable + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ret
  
  .Earth:
  ld    a,%0010 0011
  ld    (BattleSpellBookButtonTable + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  call  .LightUpButton
  xor   a
  ld    (BattleSpellBookButtonTable + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ret

  .LightUpButton:
  ld    ix,BattleSpellBookButtonTable
  ld    iy,ButtonTableSpellBookSYSX_Water
  jp    HandleSpellBook.CopyButtons     ;copies button state from rom -> vram




CheckMouseClickOutsideSpellBook:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    SpellBookY
  jr    c,.NotOverHeroOverViewSpellBookWindow
  cp    SpellBookY+HeroOverViewSpellBookWindowNY
  jr    nc,.NotOverHeroOverViewSpellBookWindow
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    SpellBookX
  jr    c,.NotOverHeroOverViewSpellBookWindow
  cp    SpellBookX+HeroOverViewSpellBookWindowNX
  ret   c

  .NotOverHeroOverViewSpellBookWindow:
  pop   af
  jp    ExitSpellBook

ExitSpellBook:
  ld    hl,CheckVictoryOrDefeat.CopyPage1toPage0
  call  docopy
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  halt                                  ;return to battle on vblank for smooth transition
  ret

SetGraphicsElementalSpells:
  xor   a
  ld    (BattleSpellIconButtons + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    a,(SelectedElementInSpellBook)  ;0=earth, 1=fire, 2=air, 3=water
  or    a
  jp    z,.SetEarthSpells
  dec   a
  jp    z,.SetFireSpells
  dec   a
  jp    z,.SetAirSpells
  jp    .SetWaterSpells

  .EraseElementalSpellLevel1:
  ld    hl,$4000 + ((.HeroOverViewSpell1backdropDY-SpellBookY)*128) + ((.HeroOverViewSpell1backdropDX-SpellBookX)/2) -128
  ld    de,$0000 + (.HeroOverViewSpell1backdropDY*128) + (.HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop

  .EraseElementalSpellLevel2:
  ld    hl,$4000 + ((.HeroOverViewSpell2backdropDY-SpellBookY)*128) + ((.HeroOverViewSpell2backdropDX-SpellBookX)/2) -128
  ld    de,$0000 + (.HeroOverViewSpell2backdropDY*128) + (.HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop

  .EraseElementalSpellLevel3:
  ld    hl,$4000 + ((.HeroOverViewSpell3backdropDY-SpellBookY)*128) + ((.HeroOverViewSpell3backdropDX-SpellBookX)/2) -128
  ld    de,$0000 + (.HeroOverViewSpell3backdropDY*128) + (.HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop

  .EraseElementalSpellLevel4:
  ld    hl,$4000 + ((.HeroOverViewSpell4backdropDY-SpellBookY)*128) + ((.HeroOverViewSpell4backdropDX-SpellBookX)/2) -128
  ld    de,$0000 + (.HeroOverViewSpell4backdropDY*128) + (.HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop

.SetEarthSpells:
  ;earth spells
  bit   0,(ix+HeroEarthSpells)
  jr    nz,.PlaceEarthSpell1
  call  .EraseElementalSpellLevel1
  jr    .EndPlaceEarthSpell1
  .PlaceEarthSpell1:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell1backdropDY*128) + (.HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell01IconSY*128) + (Spell01IconSX/2) -128
  ld    de,$0000 + (.Spell1DY*128) + (.Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell1:

  bit   1,(ix+HeroEarthSpells)
  jr    nz,.PlaceEarthSpell2
  call  .EraseElementalSpellLevel2
  jr    .EndPlaceEarthSpell2
  .PlaceEarthSpell2:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell2backdropDY*128) + (.HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell02IconSY*128) + (Spell02IconSX/2) -128
  ld    de,$0000 + (.Spell2DY*128) + (.Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell2:

  bit   2,(ix+HeroEarthSpells)
  jr    nz,.PlaceEarthSpell3
  call  .EraseElementalSpellLevel3
  jr    .EndPlaceEarthSpell3
  .PlaceEarthSpell3:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell3backdropDY*128) + (.HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell03IconSY*128) + (Spell03IconSX/2) -128
  ld    de,$0000 + (.Spell3DY*128) + (.Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell3:

  bit   3,(ix+HeroEarthSpells)
  jr    nz,.PlaceEarthSpell4
  jp    .EraseElementalSpellLevel4
  .PlaceEarthSpell4:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell4backdropDY*128) + (.HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell04IconSY*128) + (Spell04IconSX/2) -128
  ld    de,$0000 + (.Spell4DY*128) + (.Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell

.SetFireSpells:
  ;fire spells
  bit   0,(ix+HeroFireSpells)
  jr    nz,.PlaceFireSpell1
  call  .EraseElementalSpellLevel1
  jr    .EndPlaceFireSpell1
  .PlaceFireSpell1:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell1backdropDY*128) + (.HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell05IconSY*128) + (Spell05IconSX/2) -128
  ld    de,$0000 + (.Spell1DY*128) + (.Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell1:

  bit   1,(ix+HeroFireSpells)
  jr    nz,.PlaceFireSpell2
  call  .EraseElementalSpellLevel2
  jr    .EndPlaceFireSpell2
  .PlaceFireSpell2:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell2backdropDY*128) + (.HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell06IconSY*128) + (Spell06IconSX/2) -128
  ld    de,$0000 + (.Spell2DY*128) + (.Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell2:

  bit   2,(ix+HeroFireSpells)
  jr    nz,.PlaceFireSpell3
  call  .EraseElementalSpellLevel3
  jr    .EndPlaceFireSpell3
  .PlaceFireSpell3:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell3backdropDY*128) + (.HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell07IconSY*128) + (Spell07IconSX/2) -128
  ld    de,$0000 + (.Spell3DY*128) + (.Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell3:

  bit   3,(ix+HeroFireSpells)
  jr    nz,.PlaceFireSpell4
  jp    .EraseElementalSpellLevel4
  .PlaceFireSpell4:

  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell4backdropDY*128) + (.HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell08IconSY*128) + (Spell08IconSX/2) -128
  ld    de,$0000 + (.Spell4DY*128) + (.Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell

.SetAirSpells:
  ;air spells
  bit   0,(ix+HeroAirSpells)
  jr    nz,.PlaceAirSpell1
  call  .EraseElementalSpellLevel1
  jr    .EndPlaceAirSpell1
  .PlaceAirSpell1:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell1backdropDY*128) + (.HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell09IconSY*128) + (Spell09IconSX/2) -128
  ld    de,$0000 + (.Spell1DY*128) + (.Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell1:

  bit   1,(ix+HeroAirSpells)
  jr    nz,.PlaceAirSpell2
  call  .EraseElementalSpellLevel2
  jr    .EndPlaceAirSpell2
  .PlaceAirSpell2:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell2backdropDY*128) + (.HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell10IconSY*128) + (Spell10IconSX/2) -128
  ld    de,$0000 + (.Spell2DY*128) + (.Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell2:

  bit   2,(ix+HeroAirSpells)
  jr    nz,.PlaceAirSpell3
  call  .EraseElementalSpellLevel3
  jr    .EndPlaceAirSpell3
  .PlaceAirSpell3:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell3backdropDY*128) + (.HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell11IconSY*128) + (Spell11IconSX/2) -128
  ld    de,$0000 + (.Spell3DY*128) + (.Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell3:

  bit   3,(ix+HeroAirSpells)
  jr    nz,.PlaceAirSpell4
  jp    .EraseElementalSpellLevel4  
  .PlaceAirSpell4:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell4backdropDY*128) + (.HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell12IconSY*128) + (Spell12IconSX/2) -128
  ld    de,$0000 + (.Spell4DY*128) + (.Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell

.SetWaterSpells:
  ;water spells
  bit   0,(ix+HeroWaterSpells)
  jr    nz,.PlaceWaterSpell1
  call  .EraseElementalSpellLevel1
  jr    .EndPlaceWaterSpell1
  .PlaceWaterSpell1:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell1backdropDY*128) + (.HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell13IconSY*128) + (Spell13IconSX/2) -128
  ld    de,$0000 + (.Spell1DY*128) + (.Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell1:

  bit   1,(ix+HeroWaterSpells)
  jr    nz,.PlaceWaterSpell2
  call  .EraseElementalSpellLevel2
  jr    .EndPlaceWaterSpell2
  .PlaceWaterSpell2:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell2backdropDY*128) + (.HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell14IconSY*128) + (Spell14IconSX/2) -128
  ld    de,$0000 + (.Spell2DY*128) + (.Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell2:

  bit   2,(ix+HeroWaterSpells)
  jr    nz,.PlaceWaterSpell3
  call  .EraseElementalSpellLevel3
  jr    .EndPlaceWaterSpell3
  .PlaceWaterSpell3:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell3backdropDY*128) + (.HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell15IconSY*128) + (Spell15IconSX/2) -128
  ld    de,$0000 + (.Spell3DY*128) + (.Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell3:

  bit   3,(ix+HeroWaterSpells)
  jr    nz,.PlaceWaterSpell4
  jp    .EraseElementalSpellLevel4
  .PlaceWaterSpell4:
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell4backdropDY*128) + (.HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell16IconSY*128) + (Spell16IconSX/2) -128
  ld    de,$0000 + (.Spell4DY*128) + (.Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell  

.SetUniversalSpells:
  xor   a
  ld    (BattleSpellIconButtons + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    (BattleSpellIconButtons + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ;all spellschools
  bit   0,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell1  
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
 
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell5backdropDY*128) + (.HeroOverViewSpell5backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  ld    de,$0000 + (.Spell5DY*128) + (.Spell5DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell1:

  bit   1,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell2  
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell6backdropDY*128) + (.HeroOverViewSpell6backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  ld    de,$0000 + (.Spell6DY*128) + (.Spell6DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell2:

  bit   2,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell3  
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell7backdropDY*128) + (.HeroOverViewSpell7backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  ld    de,$0000 + (.Spell7DY*128) + (.Spell7DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell3:

  bit   3,(ix+HeroAllSchoolsSpells)
  ret   z
  ld    a,%1000 0011
  ld    (BattleSpellIconButtons + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (.HeroOverViewSpell8backdropDY*128) + (.HeroOverViewSpell8backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  ld    de,$0000 + (.Spell8DY*128) + (.Spell8DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell


.HeroOverViewSpell1backdropDY:  equ SpellBookY + 044
.HeroOverViewSpell1backdropDX:  equ SpellBookX + 034
.HeroOverViewSpell2backdropDY:  equ SpellBookY + 048
.HeroOverViewSpell2backdropDX:  equ SpellBookX + 064
.HeroOverViewSpell3backdropDY:  equ SpellBookY + 089
.HeroOverViewSpell3backdropDX:  equ SpellBookX + 032
.HeroOverViewSpell4backdropDY:  equ SpellBookY + 093
.HeroOverViewSpell4backdropDX:  equ SpellBookX + 062
.HeroOverViewSpell5backdropDY:  equ SpellBookY + 048
.HeroOverViewSpell5backdropDX:  equ SpellBookX + 102
.HeroOverViewSpell6backdropDY:  equ SpellBookY + 044
.HeroOverViewSpell6backdropDX:  equ SpellBookX + 132
.HeroOverViewSpell7backdropDY:  equ SpellBookY + 093
.HeroOverViewSpell7backdropDX:  equ SpellBookX + 104
.HeroOverViewSpell8backdropDY:  equ SpellBookY + 089
.HeroOverViewSpell8backdropDX:  equ SpellBookX + 134

.Spell1DY:  equ SpellBookY + 050
.Spell1DX:  equ SpellBookX + 040
.Spell2DY:  equ SpellBookY + 054
.Spell2DX:  equ SpellBookX + 070
.Spell3DY:  equ SpellBookY + 095
.Spell3DX:  equ SpellBookX + 038
.Spell4DY:  equ SpellBookY + 099
.Spell4DX:  equ SpellBookX + 068
.Spell5DY:  equ SpellBookY + 054
.Spell5DX:  equ SpellBookX + 108
.Spell6DY:  equ SpellBookY + 050
.Spell6DX:  equ SpellBookX + 138
.Spell7DY:  equ SpellBookY + 099
.Spell7DX:  equ SpellBookX + 110
.Spell8DY:  equ SpellBookY + 095
.Spell8DX:  equ SpellBookX + 140


SetGraphicsUniversalSpells:
  ret

SetGraphicsSpellBook:
  ld    hl,$4000 + (000*128) + (000/2) -128
  ld    de,$0000 + (SpellBookY*128) + (SpellBookX/2)
  ld    bc,$0000 + (HeroOverViewSpellBookWindowNY*256) + (HeroOverViewSpellBookWindowNX/2)
  ld    a,SpellBookGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY



;Magic abilities:

;                level cost      dmg             aoe               notes
;earth
;Ethereal chains 1     6                                           50% less speed
;Plate Armor     2     5                                           +5 defense
;resurrection    3     20                                          Reanimates 40 + (power×40) HP of killed friendly living creatures for the current battle/permanently.
;meteor shower   4     16        50+(powerx10)   3 hex tiles wide

;fire
;curse           1     5                                           attack -3
;blur            2     11                                          -50% damage for ranged units
;fireball        3     15        15+(powerx10)   3 hex tiles wide
;inferno         4     16        20+(powerx10)   5 hex tiles wide

;air
;haste           1     6                                           increase speed of unit by 4
;disrupting ray  2     4                                           -4 defense
;counterstrike   3     30                                          unlimited retaliations
;chain lightning 4     24        60+(powerx10)                     strikes up to 5 troops

;water
;cure            1     6                                           Removes all negative spell effects from the selected unit and heals for 20+(power x 5) HP
;ice bolt        2     8         30+(powerx10)
;ice trap        3     10                                          cant attack until attacked, dispelled or effect wears off
;frost ring      4     12        30+(powerx10)   3 hex tiles wide  does not damage center hex

;universal
;magic arrow     1     5         10+(powerx10)
;frenzy          2     14                                          Friendly troop's attack is increased by 100% of its defense and its defense is reduced to 0.
;teleport        3     15                                          Target allied troop instantly moves to an unoccupied target hex.
;inner beast     4     16                                          +3 attack, defense and speed








;extra
;magic mirror    4     25                                          30% change to reflect spell to random enemy
;anti-magic      4     15                                          immune to spells
;implosion       5     25        100+(powerx75)
;slayer          4     16                                          +8 attack vs units level 5 and higher
;armageddon      4     24        30+(powerx50)                     damages all troops


