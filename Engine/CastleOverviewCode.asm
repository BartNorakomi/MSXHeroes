;  call  CastleOverviewCode
;  call  CastleOverviewBuildCode
;  call  CastleOverviewRecruitCode
;  call  CastleOverviewMagicGuildCode
;  call  CastleOverviewMarketPlaceCode
;  call  CastleOverviewTavernCode
;  call  TradeMenuCode
;  call  HudCode
;  call  DisplayStartOfTurnMessageCode
;  call  DisplayQuickTipsCode
;  call  DisplayScrollCode
;  call  DisplayChestCode
;  call  HeroLevelUpCode
;  call  ShowEnemyStats
;  call  ShowEnemyHeroStats
;  call  DisplayLearningStoneCode
;  call  DisplaySpireOfWisdomCode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           WARNING                      ;;
;;  The following routine is called while                 ;;
;;  ld    a,HeroOverviewCodeBlock                         ;;
;;  call  block34                                         ;;
;;  Therefor this routine can ABSOLUTELY NOT be in page 2 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ShowRecruitWindowForSelectedUnit:       ;in b=which level unit is selected ?
  xor   a                               ;turn all recruit buttons off
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 
  ld    a,%1100 0011
  ld    (RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton),a ;BUY button
  ld    (RecruitButtonMAXBUYTable+1*RecruitButtonMAXBUYTableLenghtPerButton),a ;MAX button
  ld    (RecruitButtonMAXBUYTable+2*RecruitButtonMAXBUYTableLenghtPerButton),a ;+ button
  ld    (RecruitButtonMAXBUYTable+3*RecruitButtonMAXBUYTableLenghtPerButton),a ;- button

  call  .SetUnit                        ;set selected unit in (SelectedCastleRecruitLevelUnit)

  ;show recruit window for selected unit
  ld    hl,$4000 + (047*128) + (000/2) - 128
  ld    de,$0000 + (032*128) + (048/2) - 128
  ld    bc,$0000 + (084*256) + (162/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0

  call  .army
  call  .name
  call  .cost
  call  .Gemscost
  call  .Rubiescost

  call  .amountavailable
  call  .recruitamount
  ret

.TotalRubiescost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+123                       ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + ((074+97)/2) - 128  
  call  .SetTotalRubiescost
  ret

.TotalGemscost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+123                       ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + ((074+97)/2) - 128  
  call  .SetTotalGemscost
  ret

  .SetTotalGemscost:
  push  de
  call  SetGemsCostSelectedCreatureInHL
  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  push  bc
  call  MultiplyHlWithDE
  pop   bc

  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy
  
  ;set Gems Icon
  ld    hl,$4000 + (000*128) + (228/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetTotalRubiescost:
  push  de
  call  SetRubiesCostSelectedCreatureInHL

  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  push  bc
  call  MultiplyHlWithDE
  pop   bc

  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy
  
  ;set Ruby Icon
  ld    hl,$4000 + (000*128) + (242/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .Zero:                                ;skip putting number and icon if amount is 0
  pop   de
  ret

.totalcost:
  ld    hl,(SelectedCastleRecruitLevelUnitTotalGoldCost)
  ld    b,177
  ld    c,071 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.Rubiescost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+6                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  call  SetAvailableRecruitArmy.SetRubiescost

.Gemscost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+6                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  jp    SetAvailableRecruitArmy.SetGemscost

.cost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,072                           ;dx
  ld    c,071                           ;dy

  call  SetCostSelectedCreatureInHL     ;in: a=creature nr. pushes and pops bc
  call  SetNumber16BitCastle
  ret
    
.name:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,125                           ;dx
  ld    c,038                           ;dy

  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc

  push  ix
  pop   hl
  ld    de,MonsterTableName
  add   hl,de
  call  SetText

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

.recruitamount:
  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)
  ld    b,177
  ld    c,103 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.amountavailable:
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    b,090
  ld    c,103 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.army:
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,050*256 + 120                ;(dy*256 + dx)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

.SetUnit:
  ld    hl,SelectedCastleRecruitLevelUnit
  ld    a,b  
  ld    (SelectedCastleRecruitUnitWindow),a
  
  cp    6
  ld    c,(iy+CastleLevel1Units+00)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+00)
  ld    d,(iy+CastleLevel1UnitsAvail+01)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    5
  ld    c,(iy+CastleLevel1Units+01)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+02)
  ld    d,(iy+CastleLevel1UnitsAvail+03)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    4
  ld    c,(iy+CastleLevel1Units+02)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+04)
  ld    d,(iy+CastleLevel1UnitsAvail+05)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    3
  ld    c,(iy+CastleLevel1Units+03)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+06)
  ld    d,(iy+CastleLevel1UnitsAvail+07)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    2
  ld    c,(iy+CastleLevel1Units+04)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+08)
  ld    d,(iy+CastleLevel1UnitsAvail+09)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
;  cp    1
  ld    c,(iy+CastleLevel1Units+05)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+10)
  ld    d,(iy+CastleLevel1UnitsAvail+11)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
;  ret   z
  ret












DisplayMonsterNames:
  ld    a,(StartingTownLevel1Unit)
  ld    b,058+(0*48)                    ;dx
  ld    c,086                           ;dy
  call  .SetMonsterName
  ld    a,(StartingTownLevel2Unit)
  ld    b,062+(1*48)                    ;dx
  ld    c,086                           ;dy
  call  .SetMonsterName
  ld    a,(StartingTownLevel3Unit)
  ld    b,066+(2*48)                    ;dx
  ld    c,086                           ;dy
  call  .SetMonsterName

  ld    a,(StartingTownLevel4Unit)
  ld    b,058+(0*48)                    ;dx
  ld    c,130                           ;dy
  call  .SetMonsterName
  ld    a,(StartingTownLevel5Unit)
  ld    b,062+(1*48)                    ;dx
  ld    c,130                           ;dy
  call  .SetMonsterName
  ld    a,(StartingTownLevel6Unit)
  ld    b,066+(2*48)                    ;dx
  ld    c,130                           ;dy
;  call  .SetMonsterName
;  ret

  .SetMonsterName:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  push  ix
  pop   hl
  ld    de,MonsterTableName
  add   hl,de

  call  CenterHeroNameHasGainedALevel
  jp    SetText



SetAvailableRecruitArmy:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  .army
  call  .NamesAndAmount
  call  .cost
  call  .Gemscost
  call  .Rubiescost
  call  .attack
  call  .defense
  call  .HP
  call  .SetBrownRecruitBarIf0UnitsAvailable
  call  .SetInactiveWindowIfUnavailable
  ret

.SetBrownRecruitBarIf0UnitsAvailable:
  ld    a,(iy+CastleLevel1UnitsAvail+00)
  or    (iy+CastleLevel1UnitsAvail+01)
  call  z,.Level1Units0Available

  ld    a,(iy+CastleLevel2UnitsAvail+00)
  or    (iy+CastleLevel2UnitsAvail+01)
  call  z,.Level2Units0Available

  ld    a,(iy+CastleLevel3UnitsAvail+00)
  or    (iy+CastleLevel3UnitsAvail+01)
  call  z,.Level3Units0Available

  ld    a,(iy+CastleLevel4UnitsAvail+00)
  or    (iy+CastleLevel4UnitsAvail+01)
  call  z,.Level4Units0Available

  ld    a,(iy+CastleLevel5UnitsAvail+00)
  or    (iy+CastleLevel5UnitsAvail+01)
  call  z,.Level5Units0Available

  ld    a,(iy+CastleLevel6UnitsAvail+00)
  or    (iy+CastleLevel6UnitsAvail+01)
  call  z,.Level6Units0Available
  ret

  .Level1Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((034+30)*128) + ((005+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ret
  
  .Level2Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((034+30)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ret

  .Level3Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((034+30)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ret

  .Level4Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((090+30)*128) + ((005+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ret

  .Level5Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((090+30)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ret

  .Level6Units0Available:
  ld    hl,$4000 + (063*128) + (162/2) - 128
  ld    de,$0000 + ((090+30)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (009*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 
  ret

 
.SetInactiveWindowIfUnavailable:
  ld    a,(iy+CastleBarracksLevel+00)
  cp    6
  ret   z
  cp    5
  jr    z,.Level6UnitsUnavailable
  cp    4
  jr    z,.Level5UnitsUnavailable
  cp    3
  jr    z,.Level4UnitsUnavailable
  cp    2
  jr    z,.Level3UnitsUnavailable

  .Level2UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((034-09)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 

  .Level3UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((034-09)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 

  .Level4UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((005+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 

  .Level5UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 

  .Level6UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 
  ret

.Rubiescost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((173+030)/2) - 128  
  call  .SetRubiescost
  ret

  .SetRubiescost:
  push  de
  call  SetRubiesCostSelectedCreatureInHL
  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  call  SetNumber16BitCastle
  
  ;set Ruby Icon
  ld    hl,$4000 + (000*128) + (242/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

.Gemscost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+45                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+45                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((173+030)/2) - 128  
  call  .SetGemscost
  ret

  .SetGemscost:
  push  de
  call  SetGemsCostSelectedCreatureInHL
  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  call  SetNumber16BitCastle
  
  ;set Gems Icon
  ld    hl,$4000 + (000*128) + (228/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .Zero:                                ;skip putting number and icon if amount is 0
  pop   de
  ret


  .attack:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,038                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,038                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,038                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,038+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,038+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,038+56                        ;dy
  call  .SetAttack  
  ret

  .SetAttack:
  call  SetAttackSelectedCreatureInHL   ;in: a=creature nr. pushes and pops bc
  call  SetNumber16BitCastle
  ret
  
  .defense:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense  
  ret

  .SetDefense:
  call  SetDefenseSelectedCreatureInHL  ;in: a=creature nr. pushes and pops bc
  call  SetNumber16BitCastle
  ret

  .HP:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,056                           ;dy
  call  .SetHP

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,056                           ;dy
  call  .SetHP

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,056                           ;dy
  call  .SetHP

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,056+56                        ;dy
  call  .SetHP

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,056+56                        ;dy
  call  .SetHP

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,056+56                        ;dy
  call  .SetHP  
  ret

  .SetHP:
  call  SetHPSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  call  SetNumber16BitCastle
  ret
  
  .cost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+023                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+023                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+023                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+023                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+023                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+023                       ;dx
  ld    c,111                           ;dy
  call  .SetCost
  ret

  .SetCost:
  call  SetCostSelectedCreatureInHL     ;in: a=creature nr. pushes and pops bc

  call  SetNumber16BitCastle
  ret
  
  .setname:
  ret
  
  .NamesAndAmount:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,007                           ;dx
  ld    c,027                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+00);amount
  ld    h,(iy+CastleLevel1UnitsAvail+01)  
  call  .SetNameAndAmount

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,091                           ;dx
  ld    c,027                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+02);amount
  ld    h,(iy+CastleLevel1UnitsAvail+03)  
  call  .SetNameAndAmount

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,175                           ;dx
  ld    c,027                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+04);amount
  ld    h,(iy+CastleLevel1UnitsAvail+05)  
  call  .SetNameAndAmount

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,007                           ;dx
  ld    c,083                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+06);amount
  ld    h,(iy+CastleLevel1UnitsAvail+07)
  call  .SetNameAndAmount

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,091                           ;dx
  ld    c,083                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+08);amount
  ld    h,(iy+CastleLevel1UnitsAvail+09)
  call  .SetNameAndAmount

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,175                           ;dx
  ld    c,083                           ;dy
  ld    l,(iy+CastleLevel1UnitsAvail+10);amount
  ld    h,(iy+CastleLevel1UnitsAvail+11)
  call  .SetNameAndAmount
  ret

  .SetNameAndAmount:
  push  hl                              ;push amount

  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc

  push  ix
  pop   hl
  ld    de,MonsterTableName
  add   hl,de

  push  bc
  call  SetText
  pop   bc

  ld    a,(PutLetter+dx)                ;dx of text that was just put
  ld    b,a
  
  ld    hl,.TextSemiColon
  push  bc
  call  SetText
  pop   bc

  ld    a,(PutLetter+dx)                ;dx of text that was just put
  add   a,3
  ld    b,a
  pop   hl                              ;pop amount
  call  SetNumber16BitCastle

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

.TextSemiColon: db ":",255
  
.army:
  ld    a,(iy+CastleLevel1Units)        ;unit slot 1, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit1Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel2Units)        ;unit slot 2, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit2Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel3Units)        ;unit slot 3, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit3Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel4Units)        ;unit slot 4, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit4Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel5Units)        ;unit slot 5, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit5Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel6Units)        ;unit slot 6, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit6Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

DYDXUnit1Window:               equ 038*256 + 008+1                ;(dy*256 + dx)
DYDXUnit2Window:               equ 038*256 + 092+1                ;(dy*256 + dx)
DYDXUnit3Window:               equ 038*256 + 176+1                ;(dy*256 + dx)
DYDXUnit4Window:               equ 094*256 + 008+1                ;(dy*256 + dx)
DYDXUnit5Window:               equ 094*256 + 092+1                ;(dy*256 + dx)
DYDXUnit6Window:               equ 094*256 + 176+1                ;(dy*256 + dx)

SetCostSelectedCreatureInHL:            ;in: a=creature nr. pushes and pops bc
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableCostGold)

  add   hl,hl                           ;*2
  push  hl
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  pop   de
  add   hl,de                           ;*10  

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetGemsCostSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableCostGems)

  res   7,l                             ;bit 5,6 and 7 are used for the creature's level
  res   6,l
  res   5,l

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetRubiesCostSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableCostRubies)

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetHPSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableHp)

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetAttackSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableAttack)

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetDefenseSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableDefense)

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetGrowthSelectedCreatureInHL:
  call  SetMonsterTableInIXCastleOverview ;in: a=creature nr. pushes and pops bc
  ld    h,0
  ld    l,(ix+MonsterTableGrowth)

  ;now set engine back in page 1+2 in rom
  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetMonsterTableInIXCastleOverview:      ;in: a=creature nr
  ld    h,0
  ld    l,a                             ;creature nr in hl
  
  ld    a,MonsterAddressesForBattle1Block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  push  bc
  ld    ix,Monster001Table-LengthMonsterAddressesTable           
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   de
  add   ix,de                           ;iy->monster table idle
  pop   bc
  ret

SettavernHeroSkill:
  ld    a,HeroOverviewCodeBlock         ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    a,(ix+TavernHero1)
  ld    b,004+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,(ix+TavernHero2)
  ld    b,090+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,(ix+TavernHero3)
  ld    b,176+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetHeroSkill:
  or    a
  ret   z

  push  ix                              ;tavern hero table
  push  bc
  ld    b,a
  ld    ix,HeroAddressesAdol-heroAddressesLenght
  ld    de,heroAddressesLenght
  .loop:
  add   ix,de
  djnz  .loop
  pop   bc
  
  ld    a,(ix+HeroInfoSkill)            ;hero skill  
  ld    l,a
  ld    h,0
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  push  hl
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  add   hl,hl                           ;*64
  add   hl,hl                           ;*128
  pop   de
  add   hl,de                           ;*136
  ld    de,SkillEmpty+$4000
  add   hl,de

  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   ix                              ;tavern hero table
  ret

SetTextBuildingWhenClicked:
  ld    a,(SetTextBuilding)
  dec   a
  ret   z
  ld    (SetTextBuilding),a

  call  ClearTextBuildWindow
  call  SetSingleBuildButtonColor
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    hl,(PutWhichBuildText)
  ld    b,182
  ld    c,047
  jp    SetText


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           WARNING                      ;;
;;  The above routine is called while                     ;;
;;  ld    a,HeroOverviewCodeBlock                         ;;
;;  call  block34                                         ;;
;;  Therefor this routine can ABSOLUTELY NOT be in page 2 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ShowEnemyHeroStats:







SetTradingHeroesInventoryIcons:
  ld    ix,(plxcurrentheroAddress)
  ld    de,9                            ;skip the first 9 equiped inventory items, and go to the 6 open slots
  add   ix,de

  ;6 open slots
  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (036/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (058/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (080/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (102/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (124/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (076*128) + (146/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    ix,(HeroWeTradeWith)            ;which hero are we trading with
  ld    de,9                            ;skip the first 9 equiped inventory items, and go to the 6 open slots
  add   ix,de

  ;6 open slots
  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (036/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (058/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (080/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (102/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (124/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (140*128) + (146/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret

  .SetIconHLBCandA:
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15
  call  .CheckScrollIcon                ;scroll icons have nr 46-65 (but all use the same icon)
  add   a,a                             ;*2
  add   a,a                             ;*2
  ld    iy,.InventoryIconTableSYSX
  ld    d,0
  ld    e,a
  add   iy,de
  ld    l,(iy)
  ld    h,(iy+1)
  inc   ix
  ld    bc,$0000 + (InventoryItemNY*256) + (InventoryItemNX/2)
  ld    a,InventoryGraphicsBlock;Map block  
  ret
  
  .CheckScrollIcon:
  cp    ScrollIconNR
  ret   c
  ld    a,ScrollIconNR
  ret  

.InventoryIconTableSYSX: 
                    dw $4000 + (InventoryItem00ButtonOffSY*128) + (InventoryItem00ButtonOffSX/2) - 128  ;sword 1
                    dw $4000 + (InventoryItem00MouseOverSY*128) + (InventoryItem00MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem01ButtonOffSY*128) + (InventoryItem01ButtonOffSX/2) - 128  ;sword 2
                    dw $4000 + (InventoryItem01MouseOverSY*128) + (InventoryItem01MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem02ButtonOffSY*128) + (InventoryItem02ButtonOffSX/2) - 128  ;sword 3
                    dw $4000 + (InventoryItem02MouseOverSY*128) + (InventoryItem02MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem03ButtonOffSY*128) + (InventoryItem03ButtonOffSX/2) - 128  ;sword 4
                    dw $4000 + (InventoryItem03MouseOverSY*128) + (InventoryItem03MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem04ButtonOffSY*128) + (InventoryItem04ButtonOffSX/2) - 128  ;sword 5
                    dw $4000 + (InventoryItem04MouseOverSY*128) + (InventoryItem04MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem05ButtonOffSY*128) + (InventoryItem05ButtonOffSX/2) - 128  ;armor 1
                    dw $4000 + (InventoryItem05MouseOverSY*128) + (InventoryItem05MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem06ButtonOffSY*128) + (InventoryItem06ButtonOffSX/2) - 128  ;armor 2
                    dw $4000 + (InventoryItem06MouseOverSY*128) + (InventoryItem06MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem07ButtonOffSY*128) + (InventoryItem07ButtonOffSX/2) - 128  ;armor 3
                    dw $4000 + (InventoryItem07MouseOverSY*128) + (InventoryItem07MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem08ButtonOffSY*128) + (InventoryItem08ButtonOffSX/2) - 128  ;armor 4
                    dw $4000 + (InventoryItem08MouseOverSY*128) + (InventoryItem08MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem09ButtonOffSY*128) + (InventoryItem09ButtonOffSX/2) - 128  ;armor 5
                    dw $4000 + (InventoryItem09MouseOverSY*128) + (InventoryItem09MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem10ButtonOffSY*128) + (InventoryItem10ButtonOffSX/2) - 128  ;shield 1
                    dw $4000 + (InventoryItem10MouseOverSY*128) + (InventoryItem10MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem11ButtonOffSY*128) + (InventoryItem11ButtonOffSX/2) - 128  ;shield 2
                    dw $4000 + (InventoryItem11MouseOverSY*128) + (InventoryItem11MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem12ButtonOffSY*128) + (InventoryItem12ButtonOffSX/2) - 128  ;shield 3
                    dw $4000 + (InventoryItem12MouseOverSY*128) + (InventoryItem12MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem13ButtonOffSY*128) + (InventoryItem13ButtonOffSX/2) - 128  ;shield 4
                    dw $4000 + (InventoryItem13MouseOverSY*128) + (InventoryItem13MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem14ButtonOffSY*128) + (InventoryItem14ButtonOffSX/2) - 128  ;shield 5
                    dw $4000 + (InventoryItem14MouseOverSY*128) + (InventoryItem14MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem15ButtonOffSY*128) + (InventoryItem15ButtonOffSX/2) - 128  ;helmet 1
                    dw $4000 + (InventoryItem15MouseOverSY*128) + (InventoryItem15MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem16ButtonOffSY*128) + (InventoryItem16ButtonOffSX/2) - 128  ;helmet 2
                    dw $4000 + (InventoryItem16MouseOverSY*128) + (InventoryItem16MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem17ButtonOffSY*128) + (InventoryItem17ButtonOffSX/2) - 128  ;helmet 3
                    dw $4000 + (InventoryItem17MouseOverSY*128) + (InventoryItem17MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem18ButtonOffSY*128) + (InventoryItem18ButtonOffSX/2) - 128  ;helmet 4
                    dw $4000 + (InventoryItem18MouseOverSY*128) + (InventoryItem18MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem19ButtonOffSY*128) + (InventoryItem19ButtonOffSX/2) - 128  ;helmet 5
                    dw $4000 + (InventoryItem19MouseOverSY*128) + (InventoryItem19MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem20ButtonOffSY*128) + (InventoryItem20ButtonOffSX/2) - 128  ;boots 1
                    dw $4000 + (InventoryItem20MouseOverSY*128) + (InventoryItem20MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem21ButtonOffSY*128) + (InventoryItem21ButtonOffSX/2) - 128  ;boots 2
                    dw $4000 + (InventoryItem21MouseOverSY*128) + (InventoryItem21MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem22ButtonOffSY*128) + (InventoryItem22ButtonOffSX/2) - 128  ;boots 3
                    dw $4000 + (InventoryItem22MouseOverSY*128) + (InventoryItem22MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem23ButtonOffSY*128) + (InventoryItem23ButtonOffSX/2) - 128  ;boots 4
                    dw $4000 + (InventoryItem23MouseOverSY*128) + (InventoryItem23MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem24ButtonOffSY*128) + (InventoryItem24ButtonOffSX/2) - 128  ;boots 5
                    dw $4000 + (InventoryItem24MouseOverSY*128) + (InventoryItem24MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem25ButtonOffSY*128) + (InventoryItem25ButtonOffSX/2) - 128  ;gloves 1
                    dw $4000 + (InventoryItem25MouseOverSY*128) + (InventoryItem25MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem26ButtonOffSY*128) + (InventoryItem26ButtonOffSX/2) - 128  ;gloves 2
                    dw $4000 + (InventoryItem26MouseOverSY*128) + (InventoryItem26MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem27ButtonOffSY*128) + (InventoryItem27ButtonOffSX/2) - 128  ;gloves 3
                    dw $4000 + (InventoryItem27MouseOverSY*128) + (InventoryItem27MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem28ButtonOffSY*128) + (InventoryItem28ButtonOffSX/2) - 128  ;gloves 4
                    dw $4000 + (InventoryItem28MouseOverSY*128) + (InventoryItem28MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem29ButtonOffSY*128) + (InventoryItem29ButtonOffSX/2) - 128  ;gloves 5
                    dw $4000 + (InventoryItem29MouseOverSY*128) + (InventoryItem29MouseOverSX/2) - 128



                    dw $4000 + (InventoryItem30ButtonOffSY*128) + (InventoryItem30ButtonOffSX/2) - 128  ;ring 1
                    dw $4000 + (InventoryItem30MouseOverSY*128) + (InventoryItem30MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem31ButtonOffSY*128) + (InventoryItem31ButtonOffSX/2) - 128  ;ring 2
                    dw $4000 + (InventoryItem31MouseOverSY*128) + (InventoryItem31MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem32ButtonOffSY*128) + (InventoryItem32ButtonOffSX/2) - 128  ;ring 3
                    dw $4000 + (InventoryItem32MouseOverSY*128) + (InventoryItem32MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem33ButtonOffSY*128) + (InventoryItem33ButtonOffSX/2) - 128  ;ring 4
                    dw $4000 + (InventoryItem33MouseOverSY*128) + (InventoryItem33MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem34ButtonOffSY*128) + (InventoryItem34ButtonOffSX/2) - 128  ;ring 5
                    dw $4000 + (InventoryItem34MouseOverSY*128) + (InventoryItem34MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem35ButtonOffSY*128) + (InventoryItem35ButtonOffSX/2) - 128  ;Necklace 1
                    dw $4000 + (InventoryItem35MouseOverSY*128) + (InventoryItem35MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem36ButtonOffSY*128) + (InventoryItem36ButtonOffSX/2) - 128  ;Necklace 2
                    dw $4000 + (InventoryItem36MouseOverSY*128) + (InventoryItem36MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem37ButtonOffSY*128) + (InventoryItem37ButtonOffSX/2) - 128  ;Necklace 3
                    dw $4000 + (InventoryItem37MouseOverSY*128) + (InventoryItem37MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem38ButtonOffSY*128) + (InventoryItem38ButtonOffSX/2) - 128  ;Necklace 4
                    dw $4000 + (InventoryItem38MouseOverSY*128) + (InventoryItem38MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem39ButtonOffSY*128) + (InventoryItem39ButtonOffSX/2) - 128  ;Necklace 5
                    dw $4000 + (InventoryItem39MouseOverSY*128) + (InventoryItem39MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem40ButtonOffSY*128) + (InventoryItem40ButtonOffSX/2) - 128  ;robe 1
                    dw $4000 + (InventoryItem40MouseOverSY*128) + (InventoryItem40MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem41ButtonOffSY*128) + (InventoryItem41ButtonOffSX/2) - 128  ;robe 2
                    dw $4000 + (InventoryItem41MouseOverSY*128) + (InventoryItem41MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem42ButtonOffSY*128) + (InventoryItem42ButtonOffSX/2) - 128  ;robe 3
                    dw $4000 + (InventoryItem42MouseOverSY*128) + (InventoryItem42MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem43ButtonOffSY*128) + (InventoryItem43ButtonOffSX/2) - 128  ;robe 4
                    dw $4000 + (InventoryItem43MouseOverSY*128) + (InventoryItem43MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem44ButtonOffSY*128) + (InventoryItem44ButtonOffSX/2) - 128  ;robe 5
                    dw $4000 + (InventoryItem44MouseOverSY*128) + (InventoryItem44MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem45ButtonOffSY*128) + (InventoryItem45ButtonOffSX/2) - 128  ;empty slot
                    dw $4000 + (InventoryItem45MouseOverSY*128) + (InventoryItem45MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem46ButtonOffSY*128) + (InventoryItem46ButtonOffSX/2) - 128  ;scroll
                    dw $4000 + (InventoryItem46MouseOverSY*128) + (InventoryItem46MouseOverSX/2) - 128





UpdateHudCode:
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a  
  call  SetHeroArmyAndStatusInHud  
	ret

HudCode:
  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		z

  call  SetHeroArmyAndStatusInHud  
	call	SetCastlesInWindows             ;erase castle windows, then put the castles in the windows
  call  SetResources

  ;handle all hud buttons
;  ld    ix,GenericButtonTable3
;  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked               ;in: carry=button clicked, b=button number

  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		z

	call	SetHeroesInWindows              ;erase hero windows, then put the heroes in the windows
;  call  CheckIfHeroButtonShouldRemainLit
	call	SetManaAndMovementBars          ;erase hero mana and movement bars, then set the mana and movement bars of the heroes

  ld    ix,GenericButtonTable3
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/handle all hud buttons
  ret

.CheckButtonClicked:  
  ld    a,(WhichHudButtonClicked?)
  or    a
  ret   z
  ld    b,a
  xor   a
  ld    (WhichHudButtonClicked?),a

  ld    a,b
  cp    12
  jp    z,CheckHeroArrowUp
  cp    11
  jp    z,FirstHeroWindowClicked
  cp    10
  jp    z,SecondHeroWindowClicked
  cp    09
  jp    z,ThirdHeroWindowClicked
  cp    08
  jp    z,CheckHeroArrowDown

  cp    07
  jp    z,CheckCastleArrowUp
  cp    06
  jp    z,FirstCastleWindowClicked
  cp    05
  jp    z,SecondCastleWindowClicked
  cp    04
  jp    z,ThirdCastleWindowClicked
  cp    03
  jp    z,CheckCastleArrowDown

  cp    02
  jp    z,EndTurn
  ret

EndTurn:
  ld    a,2
  ld    (DisplayStartOfTurnMessage?),a

  call  SetHero1ForCurrentPlayerInIX

  ;reset all heroes' mana and movement for this player
	ld		b,amountofheroesperplayer 
  .loop:

  ;if hero has more mana than total mana, skip this entire process
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)  
  ld    e,(ix+HeroMana+0)
  ld    d,(ix+HeroMana+1)
  or    a
  sbc   hl,de
  jr    c,.EndSetMana
  ;/if hero has more mana than total mana, skip this entire process
  ld    l,(ix+HeroMana+0)
  ld    h,(ix+HeroMana+1)
  ld    d,0
  ld    e,(ix+HeroManarec+0)
  add   hl,de                     ;hl=current mana + daily mana recovery points
  ld    e,(ix+HeroTotalMana+0)
  ld    d,(ix+HeroTotalMana+1)  
  sbc   hl,de
	jp		c,.nooverflowmana
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)  
  jr    .SetMana
	.nooverflowmana:
  add   hl,de
  .SetMana:
  ld    (ix+HeroMana+0),l
  ld    (ix+HeroMana+1),h
  .EndSetMana:

	ld		a,(ix+HeroTotalMove)		  ;total movement
	ld		(ix+HeroMove),a		        ;reset total movement
	ld		de,lenghtherotable
	add		ix,de				              ;next hero
	djnz	.loop

  call  SetNextPlayersTurnAndCheckPlayerEliminated
  
  ld    hl,(Date)                       ;don't add income on day 1
  ld    a,h
  or    l
  jr    z,.EndCheckNoIncomeDay1  
  call  AddCastlesIncomeToPlayer        ;add total income of castles to player
  call  AddCastlesSawmillResources      ;add sawmill's resources of castles to player
  call  AddCastlesMineResources         ;add mine's resources of castles to player
  call  AddEstatesIncomeToPlayer        ;add total income of heroes with 'estates' to player
  call  AddKingsGarmentIncomeToPlayer   ;add 125 income to hero with Kings Garment to player
  .EndCheckNoIncomeDay1:

  call  ActivateFirstActiveHeroForCurrentPlayer
  xor   a
  ld    (SetHeroOverViewMenu?),a        ;hackjob
  ret

IncDatePlayer1AddCreaturesRotateTavernHeroesRefillManaClearAlreadyBuiltThisTurn:
  ld    hl,(Date)
  inc   hl
  ld    (Date),hl
  call  AddCreaturesToPools             ;At start of player 1's turn first day of the week, add all creatures to all castles
  call  SetAndRotateTavernHeroes        ;At start of player 1's turn, rotate all tavern heroes
  call  RefillManaHeroesInCastles       ;At start of player 1's turn, refil mana for all heroes in castles
  jp    ClearAlreadyBuiltThisTurnCastles;At start of player 1's turn, clear all these bytes

SetNextPlayersTurnAndCheckPlayerEliminated:
  call  SetNextPlayersTurn

	ld		a,(whichplayernowplaying?)      ;increase the date if it's player 1's turn
  dec   a
  call  z,IncDatePlayer1AddCreaturesRotateTavernHeroesRefillManaClearAlreadyBuiltThisTurn

	ld		a,(whichplayernowplaying?)      ;if this player is eliminated, go set next player
  ld    b,a
  dec   a
  ld    hl,pl1hero1y+HeroStatus         ;check if this player has active heroes
  jr    z,.PlayerFound
  dec   a
  ld    hl,pl2hero1y+HeroStatus         ;check if this player has active heroes
  jr    z,.PlayerFound
  dec   a
  ld    hl,pl3hero1y+HeroStatus         ;check if this player has active heroes
  jr    z,.PlayerFound
;  dec   a
  ld    hl,pl4hero1y+HeroStatus         ;check if this player has active heroes
;  jr    z,.PlayerFound

  .PlayerFound:
  ld    a,(hl)                          ;check if this player has active heroes
  inc   a                               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  ret   nz
  ;at this point this player has no active heroes. Check if he owns any castles
  ld    a,(Castle1+CastlePlayer)
  cp    b
  ret   z
  ld    a,(Castle2+CastlePlayer)
  cp    b
  ret   z
  ld    a,(Castle3+CastlePlayer)
  cp    b
  ret   z
  ld    a,(Castle4+CastlePlayer)
  cp    b
  ret   z
  ;at this point this player has no active heroes nor castles, switch to next player
  jr    SetNextPlayersTurnAndCheckPlayerEliminated

AddCreaturesToPools:                    ;add creatures to pool. bonus 50% for citadel, and 100% for capitol
  ;set day
  ld    bc,(Date)
  ld    de,7                            ;divide the days by 7, the rest is the day of the week
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ld    a,h                             ;day 1 is when hl=0
  or    l
  ret   nz

  ld    ix,Castle1
  call  .AddCreatures
  ld    ix,Castle2
  call  .AddCreatures
  ld    ix,Castle3
  call  .AddCreatures
  ld    ix,Castle4
  call  .AddCreatures
  ret
  
  .AddCreatures:
  ld    a,(ix+CastleBarracksLevel)
  or    a
  ret   z
  dec   a
  jp    z,.BarracksLevel1
  dec   a
  jp    z,.BarracksLevel2
  dec   a
  jp    z,.BarracksLevel3
  dec   a
  jp    z,.BarracksLevel4
  dec   a
  jp    z,.BarracksLevel5

  .BarracksLevel6:
  ld    a,(ix+CastleLevel6Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix  
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel6UnitsAvail)
  ld    d,(ix+CastleLevel6UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel6UnitsAvail),l
  ld    (ix+CastleLevel6UnitsAvail+1),h

  .BarracksLevel5:
  ld    a,(ix+CastleLevel5Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel5UnitsAvail)
  ld    d,(ix+CastleLevel5UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel5UnitsAvail),l
  ld    (ix+CastleLevel5UnitsAvail+1),h

  .BarracksLevel4:
  ld    a,(ix+CastleLevel4Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel4UnitsAvail)
  ld    d,(ix+CastleLevel4UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel4UnitsAvail),l
  ld    (ix+CastleLevel4UnitsAvail+1),h

  .BarracksLevel3:
  ld    a,(ix+CastleLevel3Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel3UnitsAvail)
  ld    d,(ix+CastleLevel3UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel3UnitsAvail),l
  ld    (ix+CastleLevel3UnitsAvail+1),h

  .BarracksLevel2:
  ld    a,(ix+CastleLevel2Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel2UnitsAvail)
  ld    d,(ix+CastleLevel2UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel2UnitsAvail),l
  ld    (ix+CastleLevel2UnitsAvail+1),h

  .BarracksLevel1:
  ld    a,(ix+CastleLevel1Units)
  push  ix
  call  SetGrowthSelectedCreatureInHL    ;in: a=creature nr. pushes and pops bc
  pop   ix
  call  .Apply50or100PercentAddedGrowthForCitadelOrCapitol
  ld    e,(ix+CastleLevel1UnitsAvail)
  ld    d,(ix+CastleLevel1UnitsAvail+1)
  add   hl,de
  ld    (ix+CastleLevel1UnitsAvail),l
  ld    (ix+CastleLevel1UnitsAvail+1),h
  ret

.Apply50or100PercentAddedGrowthForCitadelOrCapitol:
  ld    a,(ix+CastleLevel)
  cp    4                               ;citadel ? (increases the production of all creatures by 50%
  ld    de,02                           ;divide total attack by 2 to get 50%
  jp    z,SetChestText.ApplyPercentBasedBoost
  cp    5                               ;capitol ? (increases the production of all creatures by 100%
  ld    de,01                           ;divide total attack by 1 to get 100%
  jp    nc,SetChestText.ApplyPercentBasedBoost
  ret

SetManaAndMovementToMax:
  call  SetHeroMaxMovementPoints.IxAlreadySet
	ld		(ix+HeroMove),a		        ;reset total movement

  ld    de,ItemIntelligencePointsTable
  push  ix
  call  SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet    
  pop   ix
  call  SetTotalManaHero.SetAdditionalStatFromInventoryItemsInHLDone

  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  ld    (ix+HeroMana+0),l
  ld    (ix+HeroMana+1),h
  ret

ClearAlreadyBuiltThisTurnCastles:
  xor   a
  ld    (Castle1+AlreadyBuiltThisTurn?),a
  ld    (Castle2+AlreadyBuiltThisTurn?),a
  ld    (Castle3+AlreadyBuiltThisTurn?),a
  ld    (Castle4+AlreadyBuiltThisTurn?),a
  ret


RefillManaHeroesInCastles:
  ld    ix,pl1hero1y
  call  .RefillThisPlayer
  ld    ix,pl2hero1y
  call  .RefillThisPlayer
  ld    ix,pl3hero1y
  call  .RefillThisPlayer
  ld    ix,pl4hero1y
;  call  .RefillThisPlayer

  .RefillThisPlayer:
  ld    b,amountofheroesperplayer
  ld    de,lenghtherotable
  
  .loop:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    2
  jr    z,.Refill
  cp    254
  jr    z,.Refill
  add   ix,de
  djnz  .loop  
  ret

  .Refill:
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)  
  ld    (ix+HeroMana+0),l
  ld    (ix+HeroMana+1),h
  djnz  .loop  
  ret

SetAndRotateTavernHeroes:               ;At start of player 1's turn, rotate all tavern heroes
  ld    hl,TavernHeroesPlayer1+1
  ld    de,TavernHeroesPlayer1
  ld    bc,TavernHeroesPlayer1+TavernHeroTableLenght-2
  call  .RotateForThisPlayer            ;Player 1
  ld    hl,TavernHeroesPlayer2+1
  ld    de,TavernHeroesPlayer2
  ld    bc,TavernHeroesPlayer2+TavernHeroTableLenght-2
  call  .RotateForThisPlayer            ;Player 2
  ld    hl,TavernHeroesPlayer3+1;
  ld    de,TavernHeroesPlayer3
  ld    bc,TavernHeroesPlayer3+TavernHeroTableLenght-2
  call  .RotateForThisPlayer            ;Player 3
  ld    hl,TavernHeroesPlayer4+1
  ld    de,TavernHeroesPlayer4
  ld    bc,TavernHeroesPlayer4+TavernHeroTableLenght-2
  call  .RotateForThisPlayer            ;Player 4
  ret

  .RotateForThisPlayer:
  push  bc
  ld    a,(de)                          ;first hero in tavern hero table
  ex    af,af'                          ;store first hero in tavern hero table
  ld    bc,TavernHeroTableLenght-1
  ldir
  
  ;now start looking at end of table, keep moving left until we found a hero. Then set the stored hero 1 slot right of that hero
  pop   hl
  .loop:
  ld    a,(hl)
  or    a
  jr    nz,.HeroFound
  dec   hl
  jr    .loop

  .HeroFound:
  inc   hl
  ex    af,af'                          ;recall first hero in tavern hero table
  ld    (hl),a
  ret

AddKingsGarmentIncomeToPlayer:
  call  SetHero1ForCurrentPlayerInIX

  ld    b,amountofheroesperplayer
  .loop:
  push  ix
  call  .CheckSkill
  pop   ix
  
  ld    de,lenghtherotable
  add   ix,de                           ;next hero
  djnz  .loop
  ret
  
  .CheckSkill:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255
  ret   z                               ;dont add King's Garment gold if hero is inactive/died/retreated
  ld    a,(ix+Heroy)
  cp    255                             ;a retreated or fled hero has x=255
  ret   z                               ;dont add King's Garment gold if hero is inactive/died/retreated

  ld    a,(ix+HeroInventory+8)          ;robe
  cp    040                             ;The King's Garment (+125 gold per day)
  ret   nz

   call  SetResourcesCurrentPlayerinIX  
 ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)
  ld    de,125
  add   hl,de
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h
  ret

AddEstatesIncomeToPlayer:  
  call  SetHero1ForCurrentPlayerInIX

  ld    c,amountofheroesperplayer
  .loop:
  ld    b,6                             ;each hero has 6 skills
  push  ix
  call  .CheckSkill
  pop   ix
  
  ld    de,lenghtherotable
  add   ix,de                           ;next hero
  dec   c
  jr    nz,.loop
  ret
  
  .CheckSkill:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255
  ret   z                               ;dont add estates gold if hero is inactive/died/retreated
  ld    a,(ix+Heroy)
  cp    255                             ;a retreated or fled hero has x=255
  ret   z                               ;dont add estates gold if hero is inactive/died/retreated

  ld    a,(ix+HeroSkills)
  cp    13
  ld    de,125
  jr    z,.EstatesFound                 ;basic estates (125 gold per day)
  cp    14
  ld    de,250
  jr    z,.EstatesFound                 ;advanced estates (250 gold per day)
  cp    15
  ld    de,500
  jr    z,.EstatesFound                 ;expert estates (500 gold per day)

  inc   ix                              ;next skill
  djnz  .CheckSkill
  ret

.EstatesFound:
   call  SetResourcesCurrentPlayerinIX  
 ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)
  add   hl,de
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h
  ret

AddCastlesMineResources:                ;add resources from castles' mines
  call  SetResourcesCurrentPlayerinIX  

  ld    iy,Castle1
  call  .CheckCastle
  ld    iy,Castle2
  call  .CheckCastle
  ld    iy,Castle3
  call  .CheckCastle
  ld    iy,Castle4
  call  .CheckCastle
  ret

  .CheckCastle:
	ld		a,(whichplayernowplaying?)      ;check which player is now playing
	cp    (iy+CastlePlayer)               ;check if this castle belongs to this player
  ret   nz                              ;return if its an enemy castle

  ld    a,(iy+CastleMineLevel)          ;Mine 1=1 ore pd, Mine 2=2 ore pd, Mine 3=3 ore pd
  or    a
  ret   z
  cp    1
  ld    de,0001                         ;Mine level 1=1 ore per day
  ld    bc,000                          ;Mine level 1=0 gems per day
  ld    hl,000                          ;Mine level 1=0 rubies per day
  jr    z,.MineLevelFound
  cp    2
  ld    de,0002                         ;Mine level 1=2 ore per day
  ld    bc,001                          ;Mine level 2=1 gems per day
  ld    hl,000                          ;Mine level 2=0 rubies per day
  jr    z,.MineLevelFound
  ld    de,0003                         ;Mine level 1=3 ore per day
  ld    bc,001                          ;Mine level 2=1 gems per day
  ld    hl,001                          ;Mine level 3=1 rubies per day
  .MineLevelFound:

  push  de
  ;rubies
  ld    e,(ix+8)
  ld    d,(ix+9)
  add   hl,de
  pop   de
  ret   c
  ld    (ix+8),l
  ld    (ix+9),h

  ;ore
  ld    l,(ix+6)
  ld    h,(ix+7)
  add   hl,bc
  ret   c
  ld    (ix+6),l
  ld    (ix+7),h

  ;ore
  ld    l,(ix+4)
  ld    h,(ix+5)
  add   hl,de
  ret   c
  ld    (ix+4),l
  ld    (ix+5),h
  ret

AddCastlesSawmillResources:             ;add resources from castles' sawmills
  call  SetResourcesCurrentPlayerinIX  

  ld    iy,Castle1
  call  .CheckCastle
  ld    iy,Castle2
  call  .CheckCastle
  ld    iy,Castle3
  call  .CheckCastle
  ld    iy,Castle4
  call  .CheckCastle
  ret

  .CheckCastle:
	ld		a,(whichplayernowplaying?)      ;check which player is now playing
	cp    (iy+CastlePlayer)               ;check if this castle belongs to this player
  ret   nz                              ;return if its an enemy castle

  ld    a,(iy+CastleSawmillLevel)       ;sawmill 1=1 wood pd, sawmill 2=2 wood pd, sawmill 3=3 wood pd
  or    a
  ret   z
  cp    1
  ld    de,0001                         ;Sawmill level 1=1 wood per day
  jr    z,.SawmillLevelFound
  cp    2
  ld    de,0002                         ;Sawmill level 1=2 wood per day
  jr    z,.SawmillLevelFound
  ld    de,0003                         ;Sawmill level 1=3 wood per day
  .SawmillLevelFound:

  ;wood
  ld    l,(ix+2)
  ld    h,(ix+3)
  add   hl,de
  ret   c
  ld    (ix+2),l
  ld    (ix+3),h
  ret

AddCastlesIncomeToPlayer:               ;add total income of castles and heroes with 'estates' to player's gold
  call  SetResourcesCurrentPlayerinIX  

  ld    iy,Castle1
  call  .CheckCastle
  ld    iy,Castle2
  call  .CheckCastle
  ld    iy,Castle3
  call  .CheckCastle
  ld    iy,Castle4
  call  .CheckCastle
  ret

  .CheckCastle:
	ld		a,(whichplayernowplaying?)      ;check which player is now playing
	cp    (iy+CastlePlayer)               ;check if this castle belongs to this player
  ret   nz                              ;return if its an enemy castle

  ld    a,(iy+CastleLevel)              ;castle level 1=500 gpd, level 2=1000 gpd, level 3=2000 gpd, level 4=3000 gpd, level 5=4000 gpd
  cp    1
  ld    de,500                          ;castle level 1=500 gold per day
  jr    z,.CastleLevelFound
  cp    2
  ld    de,1000                         ;castle level 2=1000 gold per day
  jr    z,.CastleLevelFound
  cp    3
  ld    de,2000                         ;castle level 3=2000 gold per day
  jr    z,.CastleLevelFound
  cp    4
  ld    de,3000                         ;castle level 4=3000 gold per day
  jr    z,.CastleLevelFound
  ld    de,4000                         ;castle level 5=4000 gold per day
  .CastleLevelFound:

  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)
  add   hl,de
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h
  ret

SetResources:
	ld		a,(SetResources?)
	dec		a
	ret		z
	ld		(SetResources?),a

  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
  call  ClearResourcesHud
  call  SetResourcesCurrentPlayerinIX

  ;gold
  ld    b,229                           ;dx
  ld    c,204                           ;dy
  ld    l,(ix+0)
  ld    h,(ix+1)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;wood
  ld    b,032+004                       ;dx
  ld    c,204                           ;dy
  ld    l,(ix+2)
  ld    h,(ix+3)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;ore
  ld    b,078+004                       ;dx
  ld    c,204                           ;dy
  ld    l,(ix+4)
  ld    h,(ix+5)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;gems
  ld    b,124+004                       ;dx
  ld    c,204                           ;dy
  ld    l,(ix+6)
  ld    h,(ix+7)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;rubies
  ld    b,169+004                       ;dx
  ld    c,204                           ;dy
  ld    l,(ix+8)
  ld    h,(ix+9)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ret

ClearResourcesHud:  
  ;clear resources
  ld    hl,$4000 + (204*128) + (032/2) - 128
  ld    de,$0000 + (204*128) + (032/2) - 128
  ld    bc,$0000 + (005*256) + (224/2)
  ld    a,HudNewBlock                   ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroArmyAndStatusInHud:
  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		z

	ld		a,(SetHeroArmyAndStatusInHud?)
	dec		a
	ret		z
	ld		(SetHeroArmyAndStatusInHud?),a

  call  ClearHeroStatsAndArmyUnitsAmount
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ret   z                                 ;don't set hero in hud, if player has no active heroes

  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0
  call  SetArmyUnits
  call  SetArmyUnitsAmount
  call  SetHeroPortrait10x18
  call  SetHeroStats
  ret

ClearHeroStatsAndArmyUnitsAmount:
  ld    hl,$4000 + (122*128) + (202/2) - 128
  ld    de,$0000 + (122*128) + (202/2) - 128
  ld    bc,$0000 + (075*256) + (052/2)
  ld    a,HudNewBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroStats:
  ld    ix,(plxcurrentheroAddress)

  ld    de,ItemAttackPointsTable
  call  SetAdditionalStatFromInventoryItemsInHL
  ld    e,(ix+HeroStatAttack)           ;attack
  ld    d,0
  add   hl,de
  ld    b,216+001                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    de,ItemDefencePointsTable
  call  SetAdditionalStatFromInventoryItemsInHL
  ld    e,(ix+HeroStatDefense)          ;defense
  ld    d,0
  add   hl,de
  
  bit   7,h                             ;defense is the only stat that can drop below 0 (with hell slayer), if so, set def=0
  jr    z,.SetDefense
  ld    hl,0
  .SetDefense:
  
  ld    b,225+001                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    de,ItemIntelligencePointsTable
  call  SetAdditionalStatFromInventoryItemsInHL
  ld    e,(ix+HeroStatKnowledge)        ;knowledge
  ld    d,0
  add   hl,de
  ld    b,234+001                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    de,ItemSpellDamagePointsTable
  call  SetAdditionalStatFromInventoryItemsInHL
  ld    e,(ix+HeroStatSpelldamage)      ;spell damage
  ld    d,0
  add   hl,de
  ld    b,243+001                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle
  ret

SetAdditionalStatFromInventoryItemsInHL:
  ld    ix,(plxcurrentheroAddress)
  .IxAlreadySet:

  ld    b,05                            ;total amount of items (per inventory slot)
  ld    c,0                             ;item number
  ld    hl,0                            ;stat bonus

  call  .loop                           ;sword
  call  .loop                           ;armor
  call  .loop                           ;shield
  call  .loop                           ;helmet
  call  .loop                           ;boots
  call  .loop                           ;gloves
  call  .loop                           ;ring
  call  .loop                           ;neclace
  call  .loop                           ;rober
  ld    ix,(plxcurrentheroAddress)
  ret

  .loop:
  call  .Check
  inc   de                              ;next item in table
  inc   c                               ;next item number
  djnz  .loop

  inc   ix
  ld    b,05                            ;total amount of items (per inventory slot)
  ret

  .Check:
  ld    a,(ix+HeroInventory+0)          ;sword
  cp    c                               ;item number
  ret   nz
  ld    a,(de)                          ;amount of damage this item provides
  push  bc
  ld    b,0

  or    a
  jp    p,.positive
  dec   b
  .positive:

  ld    c,a
  add   hl,bc
  pop   bc
  ret  

ItemSpellDamagePointsTable:
;sword (0)
  db    0
  db    0
  db    0
  db    ButterflySpellDamage ;(1)
  db    0
;armor (5)
  db    0
  db    0
  db    0
  db    0
  db    0
;shield (10)
  db    0
  db    0
  db    0
  db    0
  db    0
;helmet (15)
  db    YattaShiNeSpellDamage ;(1)
  db    FireHoodSpellDamage ;(2)
  db    0
  db    0
  db    0
;boots (20)
  db    0
  db    0
  db    0
  db    0
  db    0
;gloves (25)
  db    0
  db    0
  db    0
  db    0
  db    0
;ring (30)
  db    SmallRingSpellDamage ;(1)
  db    0
  db    ScarletRingSpellPower ;(2)
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    NegligeeOfTeethSpellPower ;(2)
  db    0
  db    TheChokerSpellPower ;(6)
;robe (40)
  db    0
  db    0
  db    EnchantedRobeSpellPower ;(3)
  db    0
  db    LabCoatSpellPower ;(7)
  
ItemIntelligencePointsTable:
;sword (0)
  db    0
  db    0
  db    0
  db    ButterflyIntelligence ;(1)
  db    0
;armor (5)
  db    0
  db    0
  db    0
  db    0
  db    0
;shield (10)
  db    0
  db    0
  db    0
  db    0
  db    0
;helmet (15)
  db    0
  db    0
  db    CerebroIntelligence ;(3)
  db    0
  db    0
;boots (20)
  db    0
  db    0
  db    0
  db    0
  db    0
;gloves (25)
  db    0
  db    0
  db    0
  db    0
  db    EmeraldGlovesIntelligence ;(5)
;ring (30)
  db    0
  db    CyclopsIntelligence ;(2)
  db    ScarletRingSpellPower ;(2)
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    NegligeeOfTeethIntelligence ;(1)
  db    0
  db    0
;robe (40)
  db    0
  db    PriestsCopeIntelligence ;(2)
  db    0
  db    0
  db    0
  
ItemDefencePointsTable:
;sword (0)
  db    0
  db    0
  db    HellSlayerDefence ;(-2)
  db    ButterflyDefence ;(1)
  db    0
;armor (5)
  db    RegaliaDiPlebDefence ;(1)
  db    YoungBloodsArmorDefence ;(2)
  db    TheJuggernautDefence ;(4)
  db    YojumboTheRoninDefence ;(4)
  db    CeasarsChestplateDefence ;(5)
;shield (10)
  db    GreenLeafShieldDefence ;(1)
  db    WoodenShieldDefence ;(2)
  db    TheBramStokerDefence ;(3)
  db    ImpenetrableShieldDefence ;(4)
  db    TrainingShieldDefence ;(5)
;helmet (15)
  db    YattaShiNeDefence ;(1)
  db    0
  db    0
  db    TheViridescentDefence ;(3)
  db    PikemensHelmetDefence ;(5)
;boots (20)
  db    0
  db    0
  db    0
  db    0
  db    0
;gloves (25)
  db    0
  db    0
  db    0
  db    0
  db    0
;ring (30)
  db    0
  db    0
  db    ScarletRingDefence ;(2)
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    0
  db    0
  db    0
;robe (40)
  db    0
  db    0
  db    0
  db    0
  db    0
  
ItemAttackPointsTable:
;sword (0)
  db    DaggerTimeAttack ;(1)
  db    SwordOfBahrainAttack;(2)
  db    HellSlayerAttack;(6)
  db    ButterflyAttack;(1)
  db    SwiftbladeAttack;(5)
;armor (5)
  db    0
  db    0
  db    0
  db    0
  db    0
;shield (10)
  db    0
  db    0
  db    0
  db    0
  db    0
;helmet (15)
  db    0
  db    0
  db    0
  db    0
  db    0
;boots (20)
  db    0
  db    0
  db    0
  db    0
  db    0
;gloves (25)
  db    0
  db    0
  db    ElkSkinGlovesAttack ;(2)
  db    0
  db    0
;ring (30)
  db    0
  db    0
  db    ScarletRingAttack ;(2)
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    0
  db    0
  db    0
;robe (40)
  db    0
  db    0
  db    0
  db    0
  db    0

ItemUnitSpeedPointsTable:
;sword (0)
  db    0
  db    0
  db    0
  db    0
  db    SwiftbladeUnitSpeed;(+1)
;armor (5)
  db    RegaliaDiPlebUnitSpeed;(+1)
  db    0
  db    TheJuggernautUnitSpeed;(-1)
  db    0
  db    0
;shield (10)
  db    0
  db    0
  db    0
  db    0
  db    0
;helmet (15)
  db    0
  db    0
  db    0
  db    0
  db    PikemensHelmetUnitSpeed;(+1)
;boots (20)
  db    ShadowTramperUnitSpeed;(+1)
  db    0
  db    0
  db    0
  db    SturdyBootsUnitSpeed;(+3)
;gloves (25)
  db    0
  db    IronHandUnitSpeed;(-1)
  db    0
  db    0
  db    0
;ring (30)
  db    0
  db    0
  db    0
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    0
  db    0
  db    0
;robe (40)
  db    0
  db    0
  db    0
  db    0
  db    0

ItemUnitHpPointsTable:
;sword (0)
  db    0
  db    0
  db    0
  db    0
  db    0
;armor (5)
  db    0
  db    0
  db    0
  db    0
  db    CaesarsChestplateUnitHp;(+2)
;shield (10)
  db    0
  db    0
  db    0
  db    0
  db    0
;helmet (15)
  db    0
  db    0
  db    0
  db    TheViridescentUnitHp;(+3)
  db    0
;boots (20)
  db    0
  db    0
  db    0
  db    0
  db    0
;gloves (25)
  db    0
  db    0
  db    ElkSkinGlovesUnitHp;(+2)
  db    0
  db    0
;ring (30)
  db    0
  db    0
  db    0
  db    0
  db    0
;neclace (35)
  db    0
  db    0
  db    0
  db    0
  db    0
;robe (40)
  db    0
  db    0
  db    0
  db    RuralVestUnitHp;(+4)
  db    LabcoatUnitHp;(-2)


SetHeroPortrait10x18:
  ld    ix,(plxcurrentheroAddress)
  ld    c,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    b,(ix+HeroSpecificInfo+1)
  push  bc
  pop   ix
  ld    a,Hero10x18PortraitsBlock       ;Map block
  ld    l,(ix+HeroInfoPortrait10x18SYSX+0)  ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait10x18SYSX+1)  
  ld    de,DYDXHeroWindow10x18InHud          ;(dy*128 + dx/2) = (204,132)
  ld    bc,NXAndNY10x18HeroPortraits    ;(ny*256 + nx/2) = (10x18)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

HeroPortrait10x18SYSXAdol:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGoemon1:      equ $4000+(000*128)+(010/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPixy:         equ $4000+(000*128)+(020/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle1:      equ $4000+(000*128)+(030/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLatok:        equ $4000+(000*128)+(040/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle2:      equ $4000+(000*128)+(050/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSnake1:       equ $4000+(000*128)+(060/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle3:      equ $4000+(000*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXSnake2:       equ $4000+(000*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle4:      equ $4000+(000*128)+(090/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXAshguine:     equ $4000+(000*128)+(100/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline1:  equ $4000+(000*128)+(110/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPsychoWorld:  equ $4000+(000*128)+(120/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline2:  equ $4000+(000*128)+(130/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGoemon2:      equ $4000+(000*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline3:  equ $4000+(000*128)+(150/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXFray:         equ $4000+(000*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBlackColor:   equ $4000+(000*128)+(170/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXWit:          equ $4000+(000*128)+(180/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXMitchell:     equ $4000+(000*128)+(190/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXJanJackGibson:equ $4000+(000*128)+(200/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGillianSeed:  equ $4000+(000*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSnatcher:     equ $4000+(000*128)+(220/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGolvellius:   equ $4000+(000*128)+(230/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXBillRizer:    equ $4000+(000*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPochi:        equ $4000+(018*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGreyFox:      equ $4000+(018*128)+(010/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXTrevorBelmont:equ $4000+(018*128)+(020/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBigBoss:      equ $4000+(018*128)+(030/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSimonBelmont: equ $4000+(018*128)+(040/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrPettrovich: equ $4000+(018*128)+(050/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXRichterBelmont:equ $4000+(018*128)+(060/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXUltrabox:     equ $4000+(018*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLoganSerios:  equ $4000+(018*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXHollyWhite:   equ $4000+(018*128)+(090/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXMercies:      equ $4000+(018*128)+(100/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXNatashaRomanenko:  equ $4000+(018*128)+(110/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXRuth:         equ $4000+(018*128)+(120/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGeera:        equ $4000+(018*128)+(130/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXYoungNoble:   equ $4000+(018*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXDawel:        equ $4000+(018*128)+(150/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPocky:        equ $4000+(018*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXKelesisTheCook:  equ $4000+(018*128)+(170/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLolo:         equ $4000+(018*128)+(180/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPippols:      equ $4000+(018*128)+(190/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXRandar:       equ $4000+(018*128)+(200/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXCles:         equ $4000+(018*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLuice:        equ $4000+(018*128)+(220/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXDick:              equ $4000+(018*128)+(230/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXAphrodite:         equ $4000+(018*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXTienRen:           equ $4000+(036*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPopolon:           equ $4000+(036*128)+(010/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXHoMei:             equ $4000+(036*128)+(020/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPriestessKi:       equ $4000+(036*128)+(030/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXMeiHong:           equ $4000+(036*128)+(040/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPrinceGilgamesh:   equ $4000+(036*128)+(050/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXRandomHajile:      equ $4000+(036*128)+(060/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBensonCunningham:  equ $4000+(036*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXJamieSeed:         equ $4000+(036*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXArmoredSnatcher:   equ $4000+(036*128)+(090/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDruid:             equ $4000+(036*128)+(100/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXMomotaru:          equ $4000+(036*128)+(110/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLuka:              equ $4000+(036*128)+(120/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXHeiwaAndButako:    equ $4000+(036*128)+(130/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXAce:               equ $4000+(036*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSpaceExplorer01:   equ $4000+(036*128)+(150/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXFern:              equ $4000+(036*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXHorn:              equ $4000+(036*128)+(170/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPixie:             equ $4000+(036*128)+(180/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXFreyaJerbain:      equ $4000+(036*128)+(190/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLanceBean:         equ $4000+(036*128)+(200/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXThiharis:          equ $4000+(036*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPampas:            equ $4000+(036*128)+(220/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSelene:            equ $4000+(036*128)+(230/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSkooter:           equ $4000+(036*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXJeddaChef:         equ $4000+(054*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2







SetArmyUnits:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit1WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit2WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit3WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit4WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit5WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit6WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

NXAndNY14x14CharaterPortraits:      equ 014*256 + (014/2)            ;(ny*256 + nx/2) = (14x14)
DYDXUnit1WindowInHud:               equ 153*256 + 204      ;(dy*256 + dx)
DYDXUnit2WindowInHud:               equ 153*256 + 220      ;(dy*256 + dx)
DYDXUnit3WindowInHud:               equ 153*256 + 236      ;(dy*256 + dx)
DYDXUnit4WindowInHud:               equ 176*256 + 204      ;(dy*256 + dx)
DYDXUnit5WindowInHud:               equ 176*256 + 220      ;(dy*256 + dx)
DYDXUnit6WindowInHud:               equ 176*256 + 236      ;(dy*256 + dx)

SetArmyUnitsAmount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,204 + 1
  ld    c,169
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,220 + 1
  ld    c,169
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,236 + 1
  ld    c,169
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,204 + 1
  ld    c,192
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,220 + 1
  ld    c,192
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,236 + 1
  ld    c,192
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

SetManaAndMovementBars:
	ld		a,(ChangeManaAndMovement?)
	dec		a
	ret		z
	ld		(ChangeManaAndMovement?),a

	call	EraseManaandMovementBars
	call	.PutManaandMovementBars
;	call	SwapButDontSetPage                ;lets put the movement bars 2x in case we run into a hero trade situation
;	call	.PutManaandMovementBars
;	call	SwapButDontSetPage	
  ret

.PutManaandMovementBars:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX

  ld    de,$0000 + (067*128) + (226/2) - 128
  ld    hl,$0000 + (067*128) + (204/2) - 128
  call  .PutManaAndMovement               ;hero in window1

  ld    de,$0000 + (078*128) + (226/2) - 128
  ld    hl,$0000 + (078*128) + (204/2) - 128
  call  .PutManaAndMovement               ;hero in window2

  ld    de,$0000 + (089*128) + (226/2) - 128
  ld    hl,$0000 + (089*128) + (204/2) - 128
  call  .PutManaAndMovement               ;hero in window3
  ret

  .PutManaAndMovement:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255                             ;inactive
  ret   z
  cp    254                             ;in castle
  jp    nz,.EndCheckInCastle
  ;if hero is in castle, we stay in the same hero window, but we skip to the next hero
	ld		bc,lenghtherotable
	add		ix,bc                           ;next hero
  jp    .PutManaAndMovement
  .EndCheckInCastle:
  push  hl
	call	PutManaBar 	                  ;put hero mana
  pop   de
	call	PutMovementBar 	                ;put hero movement
	ld		bc,lenghtherotable
	add		ix,bc                           ;next hero
	ret

  PutManaBar:
  exx

  ;multiply current mana by 10, then divide by the total mana, the result will be percentage per 10
  ld    l,(ix+HeroMana+0)               ;mana
  ld    h,(ix+HeroMana+1)               ;mana
  ld    de,10
  call  MultiplyHlWithDE                ;In: HL/DE. HL = result

  push  hl
  pop   bc
  ld    e,(ix+HeroTotalMana+0)          ;total mana
  ld    d,(ix+HeroTotalMana+1)          ;total mana
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ld    a,c
  or    a
  ld    bc,$4000 + ((107+25+76)*128) + (042/2) - 128
  jr    z,.EndSearchPercentageMovementSmallExceptionWhenAlmost0
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (040/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (038/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (036/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (034/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (032/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (030/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (028/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (026/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (024/2) - 128
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + ((107+25+76)*128) + (022/2) - 128
  jr    .EndSearchPercentageMovement

  .EndSearchPercentageMovementSmallExceptionWhenAlmost0:
  ld    a,(ix+HeroMana+0)               ;mana
  ld    h,(ix+HeroMana+1)               ;mana
  or    h
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + ((107+25+76)*128) + (040/2) - 128

  .EndSearchPercentageMovement:
  push  bc
  exx
  pop   hl
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
	ret

  PutMovementBar:
  exx
  ;multiply current move by 10, then divide by the total move, the result will be percentage per 10
  ld    h,0
  ld    l,(ix+HeroMove)                 ;mana
  ld    de,10
  call  MultiplyHlWithDE                ;In: HL/DE. HL = result

  push  hl
  pop   bc
  ld    d,0
  ld    e,(ix+HeroTotalMove)            ;total mana
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ld    a,c
  or    a
  ld    bc,$4000 + ((107+25+76)*128) + (020/2) - 128
  jr    z,.EndSearchPercentageMovementSmallExceptionWhenAlmost0
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (018/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (016/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (014/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (012/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (010/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (008/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (006/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (004/2) - 128
  jr    z,.EndSearchPercentageMovement
  dec   a
  ld    bc,$4000 + ((107+25+76)*128) + (002/2) - 128
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + ((107+25+76)*128) + (000/2) - 128
  jr    .EndSearchPercentageMovement

  .EndSearchPercentageMovementSmallExceptionWhenAlmost0:
  ld    a,(ix+HeroMove)                 ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  and   a
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + ((107+25+76)*128) + (018/2) - 128

  .EndSearchPercentageMovement:
  push  bc
  exx
  pop   hl
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
	ret

EraseManaandMovementBars:
  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (067*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (078*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (089*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (067*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (078*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + ((107+25+76)*128) + (020/2) - 128
  ld    de,$0000 + (089*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero20x11PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetCastlesInWindows:                    ;erase castle windows, then put the castles in the windows
	ld		a,(SetCastlesInWindows?)
	dec		a
	ret		z
	ld		(SetCastlesInWindows?),a

  call  ClearCastleButtons              ;first clear the buttons, before we set the castle buttons

  call  SetCastleUsingCastleWindowPointerInIX
  ld    de,GenericButtonTable3+(6*GenericButtonTableLenghtPerButton)
	call	.setCastlewindow

  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  ld    de,GenericButtonTable3+(7*GenericButtonTableLenghtPerButton)
	call	.setCastlewindow

  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle  
  ld    de,GenericButtonTable3+(8*GenericButtonTableLenghtPerButton)
	jp		.setCastlewindow

  .setCastlewindow:
 ; ld    a,(ix+CastleTerrainSY)      ;terrain 0=grassland,1=swamp,2=hell,3=snow
 ; or    a
  ld    hl,CastleButtonGrassLand
 ; jr    z,.EndCheckTerrain
 ; dec   a
 ; ld    hl,CastleButtonSwamp
 ; jr    z,.EndCheckTerrain
 ; dec   a
 ; ld    hl,CastleButtonHell
 ; jr    z,.EndCheckTerrain
 ; ld    hl,CastleButtonSnow

 ; .EndCheckTerrain:
  ld    bc,7
  ldir
	ret

CastleButton20x11SYSXEmpty: db  %1100 0011 | dw $4000 + ((139+25+76)*128) + (156/2) - 128 | dw $4000 + ((139+25+76)*128) + (176/2) - 128 | dw $4000 + ((139+25+76)*128) + (196/2) - 128
CastleButtonGrassLand:      db  %1100 0011 | dw $4000 + ((117+25+76)*128) + (000/2) - 128 | dw $4000 + ((117+25+76)*128) + (020/2) - 128 | dw $4000 + ((117+25+76)*128) + (040/2) - 128
CastleButtonSwamp:          db  %1100 0011 | dw $4000 + ((117+25+76)*128) + (060/2) - 128 | dw $4000 + ((117+25+76)*128) + (080/2) - 128 | dw $4000 + ((117+25+76)*128) + (100/2) - 128
CastleButtonHell:           db  %1100 0011 | dw $4000 + ((117+25+76)*128) + (120/2) - 128 | dw $4000 + ((117+25+76)*128) + (140/2) - 128 | dw $4000 + ((117+25+76)*128) + (160/2) - 128
CastleButtonSnow:           db  %1100 0011 | dw $4000 + ((117+25+76)*128) + (180/2) - 128 | dw $4000 + ((117+25+76)*128) + (200/2) - 128 | dw $4000 + ((117+25+76)*128) + (220/2) - 128

ClearCastleButtons:
  ld    hl,CastleButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(6*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,CastleButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(7*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,CastleButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(8*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir
  ret


ThirdCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle  
  jp    GoCenterAndCheckEnter
  
SecondCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  jp    GoCenterAndCheckEnter

FirstCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
;  jp    GoCenterAndCheckEnter

  GoCenterAndCheckEnter:  
	ld		a,(mappointery)
	ld    b,a
	ld		a,(mappointerx)
  ld    c,a
  push  bc  
  
  call  centrescreenforthisCastle

  pop   bc
  
	ld		a,(mappointery)
	ld    h,a
	ld		a,(mappointerx)
  ld    l,a
  xor   a
  sbc   hl,bc
  ret   nz

  ld    (WhichCastleIsPointerPointingAt?),ix
  ld    a,1
  ld    (EnterCastle?),a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetHeroesInWindows:
	ld		a,(SetHeroesInWindows?)
	dec		a
	ret		z
	ld		(SetHeroesInWindows?),a

  call  ClearHeroButtons                ;first clear the buttons, before we set the hero buttons
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX

  ld    de,GenericButtonTable3+(1*GenericButtonTableLenghtPerButton)
	call	.setherowindow
  ld    de,GenericButtonTable3+(2*GenericButtonTableLenghtPerButton)
	call	.setherowindow
  ld    de,GenericButtonTable3+(3*GenericButtonTableLenghtPerButton)

  .setherowindow:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
	cp		255
	ret		z
  cp    254                             ;in castle
  jp    nz,.EndCheckInCastle
  ;if hero is in castle, we stay in the same hero window, but we skip to the next hero
	ld		bc,lenghtherotable
	add		ix,bc                           ;next hero
  jp    .setherowindow
  .EndCheckInCastle:

  ld    c,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    b,(ix+HeroSpecificInfo+1)
  push  bc
  pop   iy
  ld    l,(iy+HeroButton20x11SYSX+0)    ;find hero portrait 20x11 address
  ld    h,(iy+HeroButton20x11SYSX+1)  

  ld    bc,7
  ldir

	ld		de,lenghtherotable
	add		ix,de                           ;next hero
	ret

ClearHeroButtons:
  ld    hl,HeroButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(1*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,HeroButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(2*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,HeroButton20x11SYSXEmpty
  ld    de,GenericButtonTable3+(3*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir
  ret

HeroButton20x11SYSXEmpty:           db  %1100 0011 | dw $4000 + ((139+25+76)*128) + (096/2) - 128 | dw $4000 + ((139+25+76)*128) + (116/2) - 128 | dw $4000 + ((139+25+76)*128) + (136/2) - 128

HeroButton20x11SYSXAdol:            db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (020/2) - 128 | dw $4000 + (000*128) + (040/2) - 128
HeroButton20x11SYSXGoemon1:         db  %1100 0011 | dw $4000 + (000*128) + (060/2) - 128 | dw $4000 + (000*128) + (080/2) - 128 | dw $4000 + (000*128) + (100/2) - 128
HeroButton20x11SYSXPixy:            db  %1100 0011 | dw $4000 + (000*128) + (120/2) - 128 | dw $4000 + (000*128) + (140/2) - 128 | dw $4000 + (000*128) + (160/2) - 128
HeroButton20x11SYSXDrasle1:         db  %1100 0011 | dw $4000 + (000*128) + (180/2) - 128 | dw $4000 + (000*128) + (200/2) - 128 | dw $4000 + (000*128) + (220/2) - 128

HeroButton20x11SYSXLatok:           db  %1100 0011 | dw $4000 + (011*128) + (000/2) - 128 | dw $4000 + (011*128) + (020/2) - 128 | dw $4000 + (011*128) + (040/2) - 128
HeroButton20x11SYSXDrasle2:         db  %1100 0011 | dw $4000 + (011*128) + (060/2) - 128 | dw $4000 + (011*128) + (080/2) - 128 | dw $4000 + (011*128) + (100/2) - 128
HeroButton20x11SYSXSnake1:          db  %1100 0011 | dw $4000 + (011*128) + (120/2) - 128 | dw $4000 + (011*128) + (140/2) - 128 | dw $4000 + (011*128) + (160/2) - 128
HeroButton20x11SYSXDrasle3:         db  %1100 0011 | dw $4000 + (011*128) + (180/2) - 128 | dw $4000 + (011*128) + (200/2) - 128 | dw $4000 + (011*128) + (220/2) - 128

HeroButton20x11SYSXSnake2:          db  %1100 0011 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (022*128) + (020/2) - 128 | dw $4000 + (022*128) + (040/2) - 128
HeroButton20x11SYSXDrasle4:         db  %1100 0011 | dw $4000 + (022*128) + (060/2) - 128 | dw $4000 + (022*128) + (080/2) - 128 | dw $4000 + (022*128) + (100/2) - 128
HeroButton20x11SYSXAshguine:        db  %1100 0011 | dw $4000 + (022*128) + (120/2) - 128 | dw $4000 + (022*128) + (140/2) - 128 | dw $4000 + (022*128) + (160/2) - 128
HeroButton20x11SYSXUndeadline1:     db  %1100 0011 | dw $4000 + (022*128) + (180/2) - 128 | dw $4000 + (022*128) + (200/2) - 128 | dw $4000 + (022*128) + (220/2) - 128

HeroButton20x11SYSXPsychoWorld:     db  %1100 0011 | dw $4000 + (033*128) + (000/2) - 128 | dw $4000 + (033*128) + (020/2) - 128 | dw $4000 + (033*128) + (040/2) - 128
HeroButton20x11SYSXUndeadline2:     db  %1100 0011 | dw $4000 + (033*128) + (060/2) - 128 | dw $4000 + (033*128) + (080/2) - 128 | dw $4000 + (033*128) + (100/2) - 128
HeroButton20x11SYSXGoemon2:         db  %1100 0011 | dw $4000 + (033*128) + (120/2) - 128 | dw $4000 + (033*128) + (140/2) - 128 | dw $4000 + (033*128) + (160/2) - 128
HeroButton20x11SYSXUndeadline3:     db  %1100 0011 | dw $4000 + (033*128) + (180/2) - 128 | dw $4000 + (033*128) + (200/2) - 128 | dw $4000 + (033*128) + (220/2) - 128

HeroButton20x11SYSXFray:            db  %1100 0011 | dw $4000 + (044*128) + (000/2) - 128 | dw $4000 + (044*128) + (020/2) - 128 | dw $4000 + (044*128) + (040/2) - 128
HeroButton20x11SYSXBlackColor:      db  %1100 0011 | dw $4000 + (044*128) + (060/2) - 128 | dw $4000 + (044*128) + (080/2) - 128 | dw $4000 + (044*128) + (100/2) - 128
HeroButton20x11SYSXWit:             db  %1100 0011 | dw $4000 + (044*128) + (120/2) - 128 | dw $4000 + (044*128) + (140/2) - 128 | dw $4000 + (044*128) + (160/2) - 128
HeroButton20x11SYSXMitchell:        db  %1100 0011 | dw $4000 + (044*128) + (180/2) - 128 | dw $4000 + (044*128) + (200/2) - 128 | dw $4000 + (044*128) + (220/2) - 128

HeroButton20x11SYSXJanJackGibson:   db  %1100 0011 | dw $4000 + (055*128) + (000/2) - 128 | dw $4000 + (055*128) + (020/2) - 128 | dw $4000 + (055*128) + (040/2) - 128
HeroButton20x11SYSXGillianSeed:     db  %1100 0011 | dw $4000 + (055*128) + (060/2) - 128 | dw $4000 + (055*128) + (080/2) - 128 | dw $4000 + (055*128) + (100/2) - 128
HeroButton20x11SYSXSnatcher:        db  %1100 0011 | dw $4000 + (055*128) + (120/2) - 128 | dw $4000 + (055*128) + (140/2) - 128 | dw $4000 + (055*128) + (160/2) - 128
HeroButton20x11SYSXGolvellius:      db  %1100 0011 | dw $4000 + (055*128) + (180/2) - 128 | dw $4000 + (055*128) + (200/2) - 128 | dw $4000 + (055*128) + (220/2) - 128

HeroButton20x11SYSXBillRizer:       db  %1100 0011 | dw $4000 + (066*128) + (000/2) - 128 | dw $4000 + (066*128) + (020/2) - 128 | dw $4000 + (066*128) + (040/2) - 128
HeroButton20x11SYSXPochi:           db  %1100 0011 | dw $4000 + (066*128) + (060/2) - 128 | dw $4000 + (066*128) + (080/2) - 128 | dw $4000 + (066*128) + (100/2) - 128
HeroButton20x11SYSXGreyFox:         db  %1100 0011 | dw $4000 + (066*128) + (120/2) - 128 | dw $4000 + (066*128) + (140/2) - 128 | dw $4000 + (066*128) + (160/2) - 128
HeroButton20x11SYSXTrevorBelmont:   db  %1100 0011 | dw $4000 + (066*128) + (180/2) - 128 | dw $4000 + (066*128) + (200/2) - 128 | dw $4000 + (066*128) + (220/2) - 128

HeroButton20x11SYSXBigBoss:         db  %1100 0011 | dw $4000 + (077*128) + (000/2) - 128 | dw $4000 + (077*128) + (020/2) - 128 | dw $4000 + (077*128) + (040/2) - 128
HeroButton20x11SYSXSimonBelmont:    db  %1100 0011 | dw $4000 + (077*128) + (060/2) - 128 | dw $4000 + (077*128) + (080/2) - 128 | dw $4000 + (077*128) + (100/2) - 128
HeroButton20x11SYSXDrPettrovich:    db  %1100 0011 | dw $4000 + (077*128) + (120/2) - 128 | dw $4000 + (077*128) + (140/2) - 128 | dw $4000 + (077*128) + (160/2) - 128
HeroButton20x11SYSXRichterBelmont:  db  %1100 0011 | dw $4000 + (077*128) + (180/2) - 128 | dw $4000 + (077*128) + (200/2) - 128 | dw $4000 + (077*128) + (220/2) - 128

HeroButton20x11SYSXUltrabox:        db  %1100 0011 | dw $4000 + (088*128) + (000/2) - 128 | dw $4000 + (088*128) + (020/2) - 128 | dw $4000 + (088*128) + (040/2) - 128
HeroButton20x11SYSXLoganSerios:     db  %1100 0011 | dw $4000 + (088*128) + (060/2) - 128 | dw $4000 + (088*128) + (080/2) - 128 | dw $4000 + (088*128) + (100/2) - 128
HeroButton20x11SYSXHollyWhite:      db  %1100 0011 | dw $4000 + (088*128) + (120/2) - 128 | dw $4000 + (088*128) + (140/2) - 128 | dw $4000 + (088*128) + (160/2) - 128
HeroButton20x11SYSXMercies:         db  %1100 0011 | dw $4000 + (088*128) + (180/2) - 128 | dw $4000 + (088*128) + (200/2) - 128 | dw $4000 + (088*128) + (220/2) - 128

HeroButton20x11SYSXNatashaRomanenko:db  %1100 0011 | dw $4000 + (099*128) + (000/2) - 128 | dw $4000 + (099*128) + (020/2) - 128 | dw $4000 + (099*128) + (040/2) - 128
HeroButton20x11SYSXRuth:            db  %1100 0011 | dw $4000 + (099*128) + (060/2) - 128 | dw $4000 + (099*128) + (080/2) - 128 | dw $4000 + (099*128) + (100/2) - 128
HeroButton20x11SYSXGeera:           db  %1100 0011 | dw $4000 + (099*128) + (120/2) - 128 | dw $4000 + (099*128) + (140/2) - 128 | dw $4000 + (099*128) + (160/2) - 128
HeroButton20x11SYSXYoungNoble:      db  %1100 0011 | dw $4000 + (099*128) + (180/2) - 128 | dw $4000 + (099*128) + (200/2) - 128 | dw $4000 + (099*128) + (220/2) - 128

HeroButton20x11SYSXDawel:           db  %1100 0011 | dw $4000 + (110*128) + (000/2) - 128 | dw $4000 + (110*128) + (020/2) - 128 | dw $4000 + (110*128) + (040/2) - 128
HeroButton20x11SYSXPocky:           db  %1100 0011 | dw $4000 + (110*128) + (060/2) - 128 | dw $4000 + (110*128) + (080/2) - 128 | dw $4000 + (110*128) + (100/2) - 128
HeroButton20x11SYSXKelesisTheCook:  db  %1100 0011 | dw $4000 + (110*128) + (120/2) - 128 | dw $4000 + (110*128) + (140/2) - 128 | dw $4000 + (110*128) + (160/2) - 128
HeroButton20x11SYSXLolo:            db  %1100 0011 | dw $4000 + (110*128) + (180/2) - 128 | dw $4000 + (110*128) + (200/2) - 128 | dw $4000 + (110*128) + (220/2) - 128

HeroButton20x11SYSXPippols:         db  %1100 0011 | dw $4000 + (121*128) + (000/2) - 128 | dw $4000 + (121*128) + (020/2) - 128 | dw $4000 + (121*128) + (040/2) - 128
HeroButton20x11SYSXRandar:          db  %1100 0011 | dw $4000 + (121*128) + (060/2) - 128 | dw $4000 + (121*128) + (080/2) - 128 | dw $4000 + (121*128) + (100/2) - 128
HeroButton20x11SYSXCles:            db  %1100 0011 | dw $4000 + (121*128) + (120/2) - 128 | dw $4000 + (121*128) + (140/2) - 128 | dw $4000 + (121*128) + (160/2) - 128
HeroButton20x11SYSXLuice:           db  %1100 0011 | dw $4000 + (121*128) + (180/2) - 128 | dw $4000 + (121*128) + (200/2) - 128 | dw $4000 + (121*128) + (220/2) - 128

HeroButton20x11SYSXDick:              db  %1100 0011 | dw $4000 + (132*128) + (000/2) - 128 | dw $4000 + (132*128) + (020/2) - 128 | dw $4000 + (132*128) + (040/2) - 128
HeroButton20x11SYSXAphrodite:         db  %1100 0011 | dw $4000 + (132*128) + (060/2) - 128 | dw $4000 + (132*128) + (080/2) - 128 | dw $4000 + (132*128) + (100/2) - 128
HeroButton20x11SYSXTienRen:           db  %1100 0011 | dw $4000 + (132*128) + (120/2) - 128 | dw $4000 + (132*128) + (140/2) - 128 | dw $4000 + (132*128) + (160/2) - 128
HeroButton20x11SYSXPopolon:           db  %1100 0011 | dw $4000 + (132*128) + (180/2) - 128 | dw $4000 + (132*128) + (200/2) - 128 | dw $4000 + (132*128) + (220/2) - 128

HeroButton20x11SYSXHoMei:             db  %1100 0011 | dw $4000 + (143*128) + (000/2) - 128 | dw $4000 + (143*128) + (020/2) - 128 | dw $4000 + (143*128) + (040/2) - 128
HeroButton20x11SYSXPriestessKi:       db  %1100 0011 | dw $4000 + (143*128) + (060/2) - 128 | dw $4000 + (143*128) + (080/2) - 128 | dw $4000 + (143*128) + (100/2) - 128
HeroButton20x11SYSXMeiHong:           db  %1100 0011 | dw $4000 + (143*128) + (120/2) - 128 | dw $4000 + (143*128) + (140/2) - 128 | dw $4000 + (143*128) + (160/2) - 128
HeroButton20x11SYSXPrinceGilgamesh:   db  %1100 0011 | dw $4000 + (143*128) + (180/2) - 128 | dw $4000 + (143*128) + (200/2) - 128 | dw $4000 + (143*128) + (220/2) - 128

HeroButton20x11SYSXRandomHajile:      db  %1100 0011 | dw $4000 + (154*128) + (000/2) - 128 | dw $4000 + (154*128) + (020/2) - 128 | dw $4000 + (154*128) + (040/2) - 128
HeroButton20x11SYSXBensonCunningham:  db  %1100 0011 | dw $4000 + (154*128) + (060/2) - 128 | dw $4000 + (154*128) + (080/2) - 128 | dw $4000 + (154*128) + (100/2) - 128
HeroButton20x11SYSXJamieSeed:         db  %1100 0011 | dw $4000 + (154*128) + (120/2) - 128 | dw $4000 + (154*128) + (140/2) - 128 | dw $4000 + (154*128) + (160/2) - 128
HeroButton20x11SYSXArmoredSnatcher:   db  %1100 0011 | dw $4000 + (154*128) + (180/2) - 128 | dw $4000 + (154*128) + (200/2) - 128 | dw $4000 + (154*128) + (220/2) - 128

HeroButton20x11SYSXDruid:             db  %1100 0011 | dw $4000 + (165*128) + (000/2) - 128 | dw $4000 + (165*128) + (020/2) - 128 | dw $4000 + (165*128) + (040/2) - 128
HeroButton20x11SYSXMomotaru:          db  %1100 0011 | dw $4000 + (165*128) + (060/2) - 128 | dw $4000 + (165*128) + (080/2) - 128 | dw $4000 + (165*128) + (100/2) - 128
HeroButton20x11SYSXLuka:              db  %1100 0011 | dw $4000 + (165*128) + (120/2) - 128 | dw $4000 + (165*128) + (140/2) - 128 | dw $4000 + (165*128) + (160/2) - 128
HeroButton20x11SYSXHeiwaAndButako:    db  %1100 0011 | dw $4000 + (165*128) + (180/2) - 128 | dw $4000 + (165*128) + (200/2) - 128 | dw $4000 + (165*128) + (220/2) - 128

HeroButton20x11SYSXAce:               db  %1100 0011 | dw $4000 + (176*128) + (000/2) - 128 | dw $4000 + (176*128) + (020/2) - 128 | dw $4000 + (176*128) + (040/2) - 128
HeroButton20x11SYSXSpaceExplorer01:   db  %1100 0011 | dw $4000 + (176*128) + (060/2) - 128 | dw $4000 + (176*128) + (080/2) - 128 | dw $4000 + (176*128) + (100/2) - 128
HeroButton20x11SYSXFern:              db  %1100 0011 | dw $4000 + (176*128) + (120/2) - 128 | dw $4000 + (176*128) + (140/2) - 128 | dw $4000 + (176*128) + (160/2) - 128
HeroButton20x11SYSXHorn:              db  %1100 0011 | dw $4000 + (176*128) + (180/2) - 128 | dw $4000 + (176*128) + (200/2) - 128 | dw $4000 + (176*128) + (220/2) - 128

HeroButton20x11SYSXPixie:             db  %1100 0011 | dw $4000 + (187*128) + (000/2) - 128 | dw $4000 + (187*128) + (020/2) - 128 | dw $4000 + (187*128) + (040/2) - 128
HeroButton20x11SYSXFreyaJerbain:      db  %1100 0011 | dw $4000 + (187*128) + (060/2) - 128 | dw $4000 + (187*128) + (080/2) - 128 | dw $4000 + (187*128) + (100/2) - 128
HeroButton20x11SYSXLanceBean:         db  %1100 0011 | dw $4000 + (187*128) + (120/2) - 128 | dw $4000 + (187*128) + (140/2) - 128 | dw $4000 + (187*128) + (160/2) - 128
HeroButton20x11SYSXThiharis:          db  %1100 0011 | dw $4000 + (187*128) + (180/2) - 128 | dw $4000 + (187*128) + (200/2) - 128 | dw $4000 + (187*128) + (220/2) - 128

HeroButton20x11SYSXPampas:            db  %1100 0011 | dw $4000 + (198*128) + (060/2) - 128 | dw $4000 + (198*128) + (080/2) - 128 | dw $4000 + (198*128) + (220/2) - 128
HeroButton20x11SYSXSelene:            db  %1100 0011 | dw $4000 + (198*128) + (120/2) - 128 | dw $4000 + (198*128) + (140/2) - 128 | dw $4000 + (198*128) + (040/2) - 128
HeroButton20x11SYSXSkooter:           db  %1100 0011 | dw $4000 + (198*128) + (180/2) - 128 | dw $4000 + (198*128) + (200/2) - 128 | dw $4000 + (198*128) + (100/2) - 128
HeroButton20x11SYSXJeddaChef:         db  %1100 0011 | dw $4000 + (240*128) + (000/2) - 128 | dw $4000 + (240*128) + (020/2) - 128 | dw $4000 + (240*128) + (160/2) - 128


HeroLevelUpCode:
;call ScreenOn
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroTotalMana)
  ld    (HeroTotalManaBeforeLevelingUp),a

  ld    a,r
  ld    (framecounter),a                ;sloppy code to randomise framecounter, which then provides us our random Primairy Skill Up

  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a  
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix

  call  SetLevelUpButtons
  call  IncreasePrimairySkill

  call  SetLevelUpGraphics              ;put gfx
  call  SetLevelUpHeroIcon
  call  SetPrimairySkillUpIcon          ;which primairy skill does the hero get ?
  call  SetLevelUpText
  call  SwapAndSetPage                  ;swap and set page
  call  SetLevelUpGraphics              ;put gfx
  call  SetLevelUpHeroIcon
  call  SetPrimairySkillUpIcon          ;which primairy skill does the hero get ?
  call  SetLevelUpText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
;  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number



  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton               ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton:
  ;we mark previous button clicked


  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram


  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state



;  call  .CheckEndWindow                 ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc
  ld    a,%1100 0011
  ld    (GenericButtonTable),a          ;enable the V button once any other button is pressed

  ld    a,b
  cp    3                               ;V button pressed ?
  jr    z,.VButton
  ld    (PreviousButtonClicked),a
  ld    (PreviousButtonClickedIX),ix
  cp    2                               ;left skill button pressed ?
  jr    z,.LeftSkillButton
  
  .RightSkillButton:                    ;right skill button pressed
  ld    a,(SkillInLevelUpSlot2)
  jp    SetLevelUpHeroSkillsInTable

  .LeftSkillButton:
  ld    a,(SkillInLevelUpSlot1)
  jp    SetLevelUpHeroSkillsInTable
  
  .VButton:
  pop   af                              ;end DisplayLevelUpCode
  ld    a,(PreviousButtonClicked)
  cp    2                               
  jr    z,.AddSkillOnTheLeft

  .AddSkillOnTheRight:
  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)
  ld    a,(SkillInLevelUpSlot2)
  ld    b,a
  ld    a,(PlaceSkillInLevelUpSlot2IntoWhichHeroSlot?)
  jp    AddThisSkillToHero

  .AddSkillOnTheLeft:
  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)
  ld    a,(SkillInLevelUpSlot1)
  ld    b,a
  ld    a,(PlaceSkillInLevelUpSlot1IntoWhichHeroSlot?)
  jp    AddThisSkillToHero

SetLevelUpHeroSkillsInTable:
  ex    af,af'
  ld    a,HeroOverviewCodeBlock         ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ex    af,af'
  ld    de,TextSkillsWindowButton1
  call  .SetheroSkill

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    hl,$4000 + (147*128) + (006/2) - 128
  ld    de,$0000 + (162*128) + (028/2) - 128
  ld    bc,$0000 + (020*256) + (148/2)
  ld    a,LevelUpBlock         ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    b,030                           ;dx
  ld    c,162                           ;dy
  ld    hl,TextSkillsWindowButton1+LenghtTextSkillsDescription
  call  SetText                         ;in: b=dx, c=dy, hl->text  
  call  SwapAndSetPage                  ;swap and set page

  ld    hl,$4000 + (147*128) + (006/2) - 128
  ld    de,$0000 + (162*128) + (028/2) - 128
  ld    bc,$0000 + (020*256) + (148/2)
  ld    a,LevelUpBlock         ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    b,030                           ;dx
  ld    c,162                           ;dy
  ld    hl,TextSkillsWindowButton1+LenghtTextSkillsDescription
  jp    SetText                         ;in: b=dx, c=dy, hl->text  

  .SetheroSkill:
  ld    l,a
  ld    h,0
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  push  hl
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  add   hl,hl                           ;*64
  add   hl,hl                           ;*128
  pop   bc
  add   hl,bc                           ;*136
  ld    bc,SkillEmpty+$4000
  add   hl,bc
  ld    bc,LenghtSkillDescription
  ldir
  ret









AddThisSkillToHero:
  call  .goAdd
  call  SetTotalManaHero
  ld    a,(HeroTotalManaBeforeLevelingUp)
  ld    b,a
  ld    a,(ix+HeroTotalMana)
  sub   a,b                         ;check the difference between total mana before and after leveling up
  add   a,(ix+HeroMana)             ;add this difference to current mana pool
  ld    (ix+HeroMana),a
  ret

  .goAdd:
  cp    1
  jr    z,.HeroSlot1
  cp    2
  jr    z,.HeroSlot2
  cp    3
  jr    z,.HeroSlot3
  cp    4
  jr    z,.HeroSlot4
  cp    5
  jr    z,.HeroSlot5
  cp    6
  jr    z,.HeroSlot6
  
  .SkillShouldBePlacedInaFreeSlot:
  xor   a
  cp    (ix+HeroSkills+1)
  jr    z,.HeroSlot2
  cp    (ix+HeroSkills+2)
  jr    z,.HeroSlot3
  cp    (ix+HeroSkills+3)
  jr    z,.HeroSlot4
  cp    (ix+HeroSkills+4)
  jr    z,.HeroSlot5

  .HeroSlot6:
  ld    (ix+HeroSkills+5),b
  ret
  .HeroSlot5:
  ld    (ix+HeroSkills+4),b
  ret
  .HeroSlot4:
  ld    (ix+HeroSkills+3),b
  ret
  .HeroSlot3:
  ld    (ix+HeroSkills+2),b
  ret
  .HeroSlot2:
  ld    (ix+HeroSkills+1),b
  ret
  .HeroSlot1:
  ld    (ix+HeroSkills+0),b
  ret  












SetLevelUpButtons:
  ld    hl,LevelUpButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*03)
  ldir

  call  .SetButtons

  ld    a,(SkillInLevelUpSlot1)
  ld    hl,SkillInLevelUpSlot2
  cp    (hl)
  ret   nz

  ld    a,86
  ld    (GenericButtonTable+(GenericButtonTableLenghtPerButton*01)+GenericButtonXleft),a
  ld    (GenericButtonTable+(GenericButtonTableLenghtPerButton*02)+GenericButtonXleft),a
  ld    a,86+30
  ld    (GenericButtonTable+(GenericButtonTableLenghtPerButton*01)+GenericButtonXright),a
  ld    (GenericButtonTable+(GenericButtonTableLenghtPerButton*02)+GenericButtonXright),a
  ret


  .SetButtons:

  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)
  ;                                       Might                                                               Adventure                                           Wizzardry
  ld    a,(ix+HeroSkills+0)             ;1-3=knight|4-6=barbarian|7-9=death knight|10-12=overlord       |      13-15=alchemist|16-18=sage|19-21=ranger      |      22-24=wizzard|25-27=battle mage|28-30=scholar|31-33=necromancer       
  ;the first skill the hero has tells us which class this hero is
  ;first button should always be a button in that hero's class

  exx
  ld    hl,SkillInLevelUpSlot1
  ld    bc,PlaceSkillInLevelUpSlot1IntoWhichHeroSlot?
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*01+1
  exx

  cp    13
  jp    c,.SetLeftButtonMightRightButtonAdventureOrWizzardry
  cp    22
  jp    c,.SetLeftButtonAdventureRightButtonWizzardryOrMight
  jp    .SetLeftButtonWizzardryRightButtonMightOrAdventure

  .SetLeftButtonWizzardryRightButtonMightOrAdventure:
  call  SetButtonWizzardry
  exx
  ld    hl,SkillInLevelUpSlot2
  ld    bc,PlaceSkillInLevelUpSlot2IntoWhichHeroSlot?
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*02+1
  exx
  ld    a,r
  and   1
  jp    z,SetButtonMight
  jp    SetButtonAdventure

  .SetLeftButtonMightRightButtonAdventureOrWizzardry:
  call  SetButtonMight
  exx
  ld    hl,SkillInLevelUpSlot2
  ld    bc,PlaceSkillInLevelUpSlot2IntoWhichHeroSlot?
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*02+1
  exx
  ld    a,r
  and   1
  jp    z,SetButtonAdventure
  jp    SetButtonWizzardry

  .SetLeftButtonAdventureRightButtonWizzardryOrMight:
  call  SetButtonAdventure
  exx
  ld    hl,SkillInLevelUpSlot2
  ld    bc,PlaceSkillInLevelUpSlot2IntoWhichHeroSlot?
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*02+1
  exx
  ld    a,r
  and   1
  jp    z,SetButtonWizzardry
  jp    SetButtonMight

SetSkillButton:  
  inc   b                               ;next level skill
  ld    a,b
  exx
  ld    (hl),a                          ;set this skill in slot 1
  exx
  ld    a,c
  exx
  ld    (bc),a
  push  de
  exx
  pop   de
  ld    bc,6
  ldir
  ret

CheckAmountOfExpertSkills_Wizzardry:
  ld    b,0                           ;amount of expert skills found
  ld    a,24                          ;24=expert intelligence
  call  SearchExpertSkill
  ld    a,27                          ;27=expert Sorcery
  call  SearchExpertSkill
  ld    a,30                          ;30=expert Wisdom
  call  SearchExpertSkill
  ld    a,33                          ;33=expert Necromancy
  call  SearchExpertSkill
  ret

CheckAmountOfExpertSkills_Adventure:
  ld    b,0                           ;amount of expert skills found
  ld    a,15                          ;15=expert estates
  call  SearchExpertSkill
  ld    a,18                          ;18=expert learning
  call  SearchExpertSkill
  ld    a,21                          ;21=expert logistics
  call  SearchExpertSkill
  ret



SetButtonWizzardry:
  call  IsItPossibleToLevelOrSetAWizzardrySkill?
  jp    c,SetButtonAdventure            ;if there is no free spot or all current might skills are maxed, set adventure skill

  call  CheckAmountOfExpertSkills_Wizzardry
  ld    a,b
  cp    4
  jp    z,SetButtonAdventure            ;if all expert wizzardry skills are leveled up, set adventure button instead

  ld    a,r
  and   3
  jr    z,.Intelligence
  dec   a
  jr    z,.Sorcery
  dec   a
  jr    z,.Wisdom

  .Necromancy:
  call  IsItPossibleToLevelOrSetNecromancy?
  jr    c,.Wisdom                     ;if there is no free spot or necromancy is maxed, set wisdom

  ld    b,31                            ;31=basic necromancy
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Wisdom                       ;carry: skill is maxed out, set next skill
  ld    hl,ButtonNecromancy
  jp    SetSkillButton

  .Wisdom:
  call  IsItPossibleToLevelOrSetWisdom?
  jr    c,.Sorcery                      ;if there is no free spot or wisdom is maxed, set sorcery

  ld    b,28                            ;28=basic wisdom
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Sorcery                      ;carry: skill is maxed out, set next skill
  ld    hl,ButtonWisdom
  jp    SetSkillButton

  .Sorcery:
  call  IsItPossibleToLevelOrSetSorcery?
  jr    c,.Intelligence                 ;if there is no free spot or sorcery is maxed, set intelligence

  ld    b,25                            ;25=basic sorcery
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Intelligence                 ;carry: skill is maxed out, set next skill
  ld    hl,ButtonSorcery
  jp    SetSkillButton

  .Intelligence:                        ;22=basic intelligence, 23=advanced intelligence, 24=expert intelligence
  call  IsItPossibleToLevelOrSetIntelligence?
  jr    c,.Necromancy                   ;if there is no free spot or intelligence is maxed, set necromancy

  ld    b,22                            ;22=basic intelligence
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Necromancy                   ;carry: skill is maxed out, set next skill
  ld    hl,ButtonIntelligence
  jp    SetSkillButton

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetButtonAdventure:
  call  IsItPossibleToLevelOrSetAnAdventureSkill?
  jp    c,SetButtonMight                ;if there is no free spot or all current adventure skills are maxed, set might skill

  call  CheckAmountOfExpertSkills_Adventure
  ld    a,b
  cp    3
  jp    z,SetButtonMight                ;if all expert adventure skills are leveled up, set might button instead

  ld    a,r
  and   3
  jr    z,.Estates
  dec   a
  jr    z,.Learning
  dec   a
  jr    z,.Logistics

  .Learning:
  call  IsItPossibleToLevelOrSetLearning?
  jr    c,.Logistics                    ;if there is no free spot or learning is maxed, set logistics

  ld    b,16                            ;16=basic learning
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Logistics                    ;carry: skill is maxed out, set next skill
  ld    hl,ButtonLearning
  jp    SetSkillButton

  .Logistics:
  call  IsItPossibleToLevelOrSetLogistics?
  jr    c,.Estates                      ;if there is no free spot or logistics is maxed, set estates

  ld    b,19                            ;19=basic logistics
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Estates                      ;carry: skill is maxed out, set next skill
  ld    hl,ButtonLogistics
  jp    SetSkillButton
  
  .Estates:
  call  IsItPossibleToLevelOrSetEstates?
  jr    c,.Learning                     ;if there is no free spot or estates is maxed, set learning

  ld    b,13                            ;13=basic estates
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Learning                     ;carry: skill is maxed out, set next skill
  ld    hl,ButtonEstates
  jp    SetSkillButton


CheckAmountOfExpertSkills_Might:
  ld    b,0                           ;amount of expert skills found
  ld    a,03                          ;03=expert archery
  call  SearchExpertSkill
  ld    a,06                          ;06=expert offence
  call  SearchExpertSkill
  ld    a,09                          ;09=expert armourer
  call  SearchExpertSkill
  ld    a,12                          ;12=expert resistance
  call  SearchExpertSkill
  ret

SearchExpertSkill:
  cp    (ix+HeroSkills+0)             ;check Skill slot 1
  jr    z,.ExpertSkillFound
  cp    (ix+HeroSkills+1)             ;check Skill slot 2
  jr    z,.ExpertSkillFound
  cp    (ix+HeroSkills+2)             ;check Skill slot 3
  jr    z,.ExpertSkillFound
  cp    (ix+HeroSkills+3)             ;check Skill slot 4
  jr    z,.ExpertSkillFound
  cp    (ix+HeroSkills+4)             ;check Skill slot 5
  jr    z,.ExpertSkillFound
  cp    (ix+HeroSkills+5)             ;check Skill slot 6
  jr    z,.ExpertSkillFound
  ret
  .ExpertSkillFound:
  inc   b
  ret

;there are 6 skills slot, check if there is a might skill that is not maxed yet, OR check if there is an empty slot for a new might skill
IsItPossibleToLevelOrSetAMightSkill?: ;out: carry=no empty slot
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,1                           
  call  CheckSkill                   ;check for basic archery 
  ld    a,2                           
  call  CheckSkill                   ;check for advanced archery 

  ld    a,4                           
  call  CheckSkill                   ;check for basic offence 
  ld    a,5                           
  call  CheckSkill                   ;check for advanced offence 

  ld    a,7                           
  call  CheckSkill                   ;check for basic Armourer 
  ld    a,8                           
  call  CheckSkill                   ;check for advanced Armourer 

  ld    a,10                           
  call  CheckSkill                   ;check for basic resistance 
  ld    a,11                          
  call  CheckSkill                   ;check for advanced resistance 

  scf
  ret

;there are 6 skills slot, check if there is an adventure skill that is not maxed yet, OR check if there is an empty slot for a new adventure skill
IsItPossibleToLevelOrSetAnAdventureSkill?: ;out: carry=no empty slot
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,13                           
  call  CheckSkill                   ;check for basic estates 
  ld    a,14                           
  call  CheckSkill                   ;check for advanced estates 

  ld    a,16                           
  call  CheckSkill                   ;check for basic learning 
  ld    a,17                           
  call  CheckSkill                   ;check for advanced learning 

  ld    a,19                           
  call  CheckSkill                   ;check for basic logistics 
  ld    a,20                           
  call  CheckSkill                   ;check for advanced logistics 

  scf
  ret

;there are 6 skills slot, check if there is a wizzardry skill that is not maxed yet, OR check if there is an empty slot for a new wizzardry skill
IsItPossibleToLevelOrSetAWizzardrySkill?: ;out: carry=no empty slot
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,22                           
  call  CheckSkill                   ;check for basic intelligency 
  ld    a,23                           
  call  CheckSkill                   ;check for advanced intelligency 

  ld    a,25                           
  call  CheckSkill                   ;check for basic sorcery 
  ld    a,26                           
  call  CheckSkill                   ;check for advanced sorcery 

  ld    a,28                           
  call  CheckSkill                   ;check for basic wisdom 
  ld    a,29                           
  call  CheckSkill                   ;check for advanced wisdom 

  ld    a,31                           
  call  CheckSkill                   ;check for basic necromancy 
  ld    a,32                          
  call  CheckSkill                   ;check for advanced necromancy 

  scf
  ret
  
IsItPossibleToLevelOrSetNecromancy?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,31                           
  call  CheckSkill                   ;check for basic necromancy 
  ld    a,32                          
  call  CheckSkill                   ;check for advanced necromancy 

  scf
  ret

IsItPossibleToLevelOrSetWisdom?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,28                           
  call  CheckSkill                   ;check for basic wisdom 
  ld    a,29                          
  call  CheckSkill                   ;check for advanced wisdom 

  scf
  ret

IsItPossibleToLevelOrSetSorcery?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,25                           
  call  CheckSkill                   ;check for basic sorcery 
  ld    a,26                           
  call  CheckSkill                   ;check for advanced sorcery 

  scf
  ret

IsItPossibleToLevelOrSetIntelligence?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,22                           
  call  CheckSkill                   ;check for basic intelligence 
  ld    a,23                           
  call  CheckSkill                   ;check for advanced intelligence 

  scf
  ret

IsItPossibleToLevelOrSetLogistics?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,19                           
  call  CheckSkill                   ;check for basic logistics 
  ld    a,20                           
  call  CheckSkill                   ;check for advanced logistics 

  scf
  ret

IsItPossibleToLevelOrSetLearning?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,16                           
  call  CheckSkill                   ;check for basic learning 
  ld    a,17                           
  call  CheckSkill                   ;check for advanced learning 

  scf
  ret

IsItPossibleToLevelOrSetEstates?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,13                           
  call  CheckSkill                   ;check for basic estates 
  ld    a,14                           
  call  CheckSkill                   ;check for advanced estates 

  scf
  ret

IsItPossibleToLevelOrSetResistance?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,10                           
  call  CheckSkill                   ;check for basic resistance 
  ld    a,11                          
  call  CheckSkill                   ;check for advanced resistance 

  scf
  ret

IsItPossibleToLevelOrSetArmourer?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,7                           
  call  CheckSkill                   ;check for basic Armourer 
  ld    a,8                           
  call  CheckSkill                   ;check for advanced Armourer 

  scf
  ret

IsItPossibleToLevelOrSetOffence?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,4                           
  call  CheckSkill                   ;check for basic offence 
  ld    a,5                           
  call  CheckSkill                   ;check for advanced offence 

  scf
  ret

IsItPossibleToLevelOrSetArchery?:
  xor   a
  call  CheckSkill                   ;check if there is an empty slot
  ld    a,1                           
  call  CheckSkill                   ;check for basic archery 
  ld    a,2                           
  call  CheckSkill                   ;check for advanced archery 

  scf
  ret

CheckSkill:
  cp    (ix+HeroSkills+0)             ;check Skill slot 1
  jr    z,.SkillFound
  cp    (ix+HeroSkills+1)             ;check Skill slot 2
  jr    z,.SkillFound
  cp    (ix+HeroSkills+2)             ;check Skill slot 3
  jr    z,.SkillFound
  cp    (ix+HeroSkills+3)             ;check Skill slot 4
  jr    z,.SkillFound
  cp    (ix+HeroSkills+4)             ;check Skill slot 5
  jr    z,.SkillFound
  cp    (ix+HeroSkills+5)             ;check Skill slot 6
  jr    z,.SkillFound
  ret
  .SkillFound:
  pop   bc                            ;pop the call to this routine
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetButtonMight:
  call  IsItPossibleToLevelOrSetAMightSkill?
  jp    c,SetButtonWizzardry            ;if there is no free spot or all current might skills are maxed, set wizzardry skill
  
  call  CheckAmountOfExpertSkills_Might
  ld    a,b
  cp    4
  jp    z,SetButtonWizzardry            ;if all expert might skills are leveled up, set wizzardry button instead
  
  ld    a,r
  and   3
  jr    z,.Archery
  dec   a
  jr    z,.Offence
  dec   a
  jr    z,.Armourer

  .Resistance:
  call  IsItPossibleToLevelOrSetResistance?
  jr    c,.Armourer                     ;if there is no free spot or resistance is maxed, set armourer

  ld    b,10                            ;10=basic resistance
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Armourer                     ;carry: skill is maxed out, set next skill
  ld    hl,ButtonResistance
  jp    SetSkillButton

  .Armourer:
  call  IsItPossibleToLevelOrSetArmourer?
  jr    c,.Offence                      ;if there is no free spot or armour is maxed, set offence
  
  ld    b,07                            ;07=basic armourer
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Offence                      ;carry: skill is maxed out, set next skill
  ld    hl,ButtonArmourer
  jp    SetSkillButton

  .Offence:
  call  IsItPossibleToLevelOrSetOffence?
  jr    c,.Archery                      ;if there is no free spot or offence is maxed, set archery

  ld    b,04                            ;04=basic offence
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Archery                      ;carry: skill is maxed out, set next skill
  ld    hl,ButtonOffence
  jp    SetSkillButton
  
  .Archery:
  call  IsItPossibleToLevelOrSetArchery?
  jr    c,.Resistance                   ;if there is no free spot or archery is maxed, set resistance

  ld    b,01                            ;01=basic archery
  call  CheckSkillAvailable             ;out: zero flag, skill is not maxed yet
  jr    c,.Resistance                   ;carry: skill is maxed out, set next skill
  ld    hl,ButtonArchery
  jp    SetSkillButton


;Might
ButtonArchery:     dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (033*128) + (000/2) - 128 | dw $4000 + (066*128) + (000/2) - 128
ButtonOffence:     dw $4000 + (000*128) + (030/2) - 128 | dw $4000 + (033*128) + (030/2) - 128 | dw $4000 + (066*128) + (030/2) - 128
ButtonArmourer:    dw $4000 + (000*128) + (060/2) - 128 | dw $4000 + (033*128) + (060/2) - 128 | dw $4000 + (066*128) + (060/2) - 128
ButtonResistance:  dw $4000 + (000*128) + (090/2) - 128 | dw $4000 + (033*128) + (090/2) - 128 | dw $4000 + (066*128) + (090/2) - 128
;Adventure
ButtonEstates:     dw $4000 + (000*128) + (120/2) - 128 | dw $4000 + (033*128) + (120/2) - 128 | dw $4000 + (066*128) + (120/2) - 128
ButtonLearning:    dw $4000 + (000*128) + (150/2) - 128 | dw $4000 + (033*128) + (150/2) - 128 | dw $4000 + (066*128) + (150/2) - 128
ButtonLogistics:   dw $4000 + (000*128) + (180/2) - 128 | dw $4000 + (033*128) + (180/2) - 128 | dw $4000 + (066*128) + (180/2) - 128
;Wizzardry
ButtonIntelligence:dw $4000 + (000*128) + (210/2) - 128 | dw $4000 + (033*128) + (210/2) - 128 | dw $4000 + (066*128) + (210/2) - 128
ButtonSorcery:     dw $4000 + (099*128) + (000/2) - 128 | dw $4000 + (099*128) + (030/2) - 128 | dw $4000 + (099*128) + (060/2) - 128
ButtonWisdom:      dw $4000 + (099*128) + (090/2) - 128 | dw $4000 + (099*128) + (120/2) - 128 | dw $4000 + (099*128) + (150/2) - 128
ButtonNecromancy:  dw $4000 + (099*128) + (180/2) - 128 | dw $4000 + (099*128) + (210/2) - 128 | dw $4000 + (132*128) + (000/2) - 128

CheckSkillAvailable:
  ;check if basic skill is already available, if so, ret
  ld    a,(ix+HeroSkills+0)             ;check Skill slot 1
  ld    c,1                             ;Hero Slot 1
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+1)             ;check Skill slot 2
  ld    c,2                             ;Hero Slot 2
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+2)             ;check Skill slot 3
  ld    c,3                             ;Hero Slot 3
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+3)             ;check Skill slot 4
  ld    c,4                             ;Hero Slot 4
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+4)             ;check Skill slot 5
  ld    c,5                             ;Hero Slot 5
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+5)             ;check Skill slot 6
  ld    c,6                             ;Hero Slot 6
  cp    b
  ret   z
  ;check if advanced skill is already available, if so, ret
  inc   b
  ld    a,(ix+HeroSkills+0)             ;check Skill slot 1
  ld    c,1                             ;Hero Slot 1
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+1)             ;check Skill slot 2
  ld    c,2                             ;Hero Slot 2
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+2)             ;check Skill slot 3
  ld    c,3                             ;Hero Slot 3
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+3)             ;check Skill slot 4
  ld    c,4                             ;Hero Slot 4
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+4)             ;check Skill slot 5
  ld    c,5                             ;Hero Slot 5
  cp    b
  ret   z
  ld    a,(ix+HeroSkills+5)             ;check Skill slot 6
  ld    c,6                             ;Hero Slot 6
  cp    b
  ret   z
  ;check if expert skill is already learned, if so, set carry flag
  inc   b
  ld    a,(ix+HeroSkills+0)             ;check Skill slot 1
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  ld    a,(ix+HeroSkills+1)             ;check Skill slot 2
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  ld    a,(ix+HeroSkills+2)             ;check Skill slot 3
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  ld    a,(ix+HeroSkills+3)             ;check Skill slot 4
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  ld    a,(ix+HeroSkills+4)             ;check Skill slot 5
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  ld    a,(ix+HeroSkills+5)             ;check Skill slot 6
  cp    b
  jr    z,.ExpertSkillAlreadyLearned
  dec   b
  dec   b
  dec   b
  ld    c,7                             ;Skill should be placed in a free slot
  or    a                               ;reset carry
  ret

  .ExpertSkillAlreadyLearned:
  scf
  ret


;            knight   |   barbarian   |   death knight   |   overlord   |   alchemist   |   sage   |   ranger   |   wizzard   |   battle mage   |   scholar   |   necromancer       
;Might:
;Archery    1
;Offence                1
;Armourer                               1
;Resistance                                               1

;Adventure:
;estates                                                                   1
;learning                                                                                  1
;logistics                                                                                             1

;Wizardry:
;intelligence                                                                                                        1
;sorcery                                                                                                                           1
;wisdom                                                                                                                                            1
;necromancy                                                                                                                                                      1



LevelUpButtonTableGfxBlock:  db  SecondarySkillsButtonsBlock
LevelUpButtonTableAmountOfButtons:  db  3
LevelUpButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  ;V button
  db  %0100 0011 | dw $4000 + (132*128) + (030/2) - 128 | dw $4000 + (132*128) + (050/2) - 128 | dw $4000 + (132*128) + (070/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  ;left skill button
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (033*128) + (000/2) - 128 | dw $4000 + (066*128) + (000/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  ;right skill button
  db  %1100 0011 | dw $4000 + (000*128) + (030/2) - 128 | dw $4000 + (033*128) + (030/2) - 128 | dw $4000 + (066*128) + (030/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128

.Button1Ytop:           equ 137
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 156
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 111
.Button2YBottom:        equ .Button2Ytop + 033
.Button2XLeft:          equ 062
.Button2XRight:         equ .Button2XLeft + 030

.Button3Ytop:           equ 111
.Button3YBottom:        equ .Button3Ytop + 033
.Button3XLeft:          equ 112
.Button3XRight:         equ .Button3XLeft + 030

SetLevelUpHeroIcon:
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc
  ld    de,$0000 + (034*128) + (094/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

TextLevelUp2:
                db "has gained a level",255
TextLevelUp3:
                db "level",255
TextLevelUp5a:
                db "  Attack + 1",255
TextLevelUp5b:
                db "  Defense + 1",255
TextLevelUp5c:
                db " Knowledge + 1",255
TextLevelUp5d:
                db "Spell Power + 1",255
TextLevelUp6:
                db "or",255
       
CenterHeroNameHasGainedALevel:
  ld    d,0                             ;amount of letters of hero name
  push  hl
  .loop:
  ld    a,(hl)
  cp    255
  jr    z,.EndNameFound
  inc   d
  inc   hl
  dec   b
  dec   b
  jr    .loop
  .EndNameFound:
  pop   hl
  ret
                
SetLevelUpText:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  ;hero name
  ld    b,032+(17*2)                        ;dx
  ld    c,022+00                        ;dy
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,5
  ;has gained a level
  ld    b,a                             ;dx
  ld    c,022+00                        ;dy
  ld    hl,TextLevelUp2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ;level text
  ld    b,073-00                        ;dx
  ld    c,071+00                        ;dy
  ld    hl,TextLevelUp3
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ;level number
  ld    a,(ix+HeroLevel)                ;current level
  ld    l,a
  ld    h,0
  ld    b,094-00                        ;dx
  ld    c,071+00                        ;dy
  call  SetNumber16BitCastle
  ;class
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoClass
  add   hl,de

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,5
  ld    b,a  
  ld    c,071+00                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  call  SetPrimairySkillLevelUpInA
  or    a
  ld    hl,TextLevelUp5a                ;attack
  jr    z,.PrimairySkillUpFound
  dec   a
  ld    hl,TextLevelUp5b                ;defense
  jr    z,.PrimairySkillUpFound
  dec   a
  ld    hl,TextLevelUp5c                ;knowledge
  jr    z,.PrimairySkillUpFound
  ld    hl,TextLevelUp5d                ;spell power
  .PrimairySkillUpFound:  
  ld    b,072+00                        ;dx
  ld    c,102+00                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,099+00                        ;dx
  ld    c,125+00                        ;dy
  ld    hl,TextLevelUp6
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(SkillInLevelUpSlot1)
  ld    l,a
  ld    h,0
  add   hl,hl                           ;*2
  push  hl
  pop   bc
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  push  hl
  pop   de
  add   hl,hl                           ;*16
  add   hl,de                           ;*24
  add   hl,bc                           ;*26
  ld    de,SkillTextEmpty
  add   hl,de

  ld    a,(SkillInLevelUpSlot1)
  ld    b,a
  ld    a,(SkillInLevelUpSlot2)
  cp    b
  ld    b,(062+112)/2                   ;dx
  jp    z,.SkillsAreTheSame
    
  ld    b,062+00                        ;dx
  ld    c,145+00                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(SkillInLevelUpSlot2)
  ld    l,a
  ld    h,0
  add   hl,hl                           ;*2
  push  hl
  pop   bc
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  push  hl
  pop   de
  add   hl,hl                           ;*16
  add   hl,de                           ;*24
  add   hl,bc                           ;*26
  ld    de,SkillTextEmpty
  add   hl,de
  ld    b,112+00                        ;dx

  .SkillsAreTheSame:
  ld    c,145+00                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

SkillTextEmpty:
                          db  "            ",254   ;SkillTextnr# 000
                          db  "            ",255
SkillTextArcheryBasic:
                          db  "Basic       ",254   ;SkillTextnr# 001
                          db  "Archery     ",255
SkillTextArcheryAdvanced:
                          db  "Advanced    ",254
                          db  "Archery     ",255
SkillTextArcheryExpert:
                          db  "Expert      ",254
                          db  "Archery     ",255
SkillTextOffenceBasic:
                          db  "Basic       ",254   ;SkillTextnr# 004
                          db  "Offence     ",255
SkillTextOffenceAdvanced:
                          db  "Advanced    ",254
                          db  "Offence     ",255
SkillTextOffenceExpert:
                          db  "Expert      ",254
                          db  "Offence     ",255
SkillTextArmourerBasic:
                          db  "Basic       ",254   ;SkillTextnr# 007
                          db  "Armorer     ",255
SkillTextArmourerAdvanced:
                          db  "Advanced    ",254
                          db  "Armorer     ",255
SkillTextArmourerExpert:
                          db  "Expert      ",254
                          db  "Armorer     ",255
SkillTextresistanceBasic:
                          db  "Basic       ",254   ;SkillTextnr# 010
                          db  "Resistance  ",255
SkillTextresistanceAdvanced:
                          db  "Advanced    ",254
                          db  "Resistance  ",255
SkillTextresistanceExpert:
                          db  "Expert      ",254
                          db  "Resistance  ",255
SkillTextestatesBasic:
                          db  "Basic       ",254   ;SkillTextnr# 013
                          db  "Estates     ",255
SkillTextestatesAdvanced:
                          db  "Advanced    ",254
                          db  "Estates     ",255
SkillTextestatesExpert:
                          db  "Expert      ",254
                          db  "Estates     ",255
SkillTextlearningBasic:
                          db  "Basic       ",254   ;SkillTextnr# 016
                          db  "Learning    ",255
SkillTextlearningAdvanced:
                          db  "Advanced    ",254
                          db  "Learning    ",255
SkillTextlearningExpert:
                          db  "Expert      ",254
                          db  "Learning    ",255
SkillTextlogisticsBasic:
                          db  "Basic       ",254   ;SkillTextnr# 019
                          db  "Logistics   ",255
SkillTextlogisticsAdvanced:
                          db  "Advanced    ",254
                          db  "Logistics   ",255
SkillTextlogisticsExpert:
                          db  "Expert      ",254
                          db  "Logistics   ",255
SkillTextintelligenceBasic:
                          db  "Basic       ",254   ;SkillTextnr# 022
                          db  "Intelligence",255
SkillTextintelligenceAdvanced:
                          db  "Advanced    ",254
                          db  "Intelligence",255
SkillTextintelligenceExpert:
                          db  "Expert      ",254
                          db  "Intelligence",255
SkillTextsorceryBasic:
                          db  "Basic       ",254   ;SkillTextnr# 025
                          db  "Sorcery     ",255
SkillTextsorceryAdvanced:
                          db  "Advanced    ",254
                          db  "Sorcery     ",255
SkillTextsorceryExpert:
                          db  "Expert      ",254
                          db  "Sorcery     ",255
SkillTextwisdomBasic:
                          db  "Basic       ",254   ;SkillTextnr# 028
                          db  "Wisdom      ",255
SkillTextwisdomAdvanced:
                          db  "Advanced    ",254
                          db  "Wisdom      ",255
SkillTextwisdomExpert:
                          db  "Expert      ",254
                          db  "Wisdom      ",255
SkillTextnecromancyBasic:
                          db  "Basic       ",254   ;SkillTextnr# 031
                          db  "Necromancy  ",255
SkillTextnecromancyAdvanced:
                          db  "Advanced    ",254
                          db  "Necromancy  ",255
SkillTextnecromancyExpert:
                          db  "Expert      ",254
                          db  "Necromancy  ",255

SetLevelUpGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128          ;red LevelUp (rubies)
  ld    de,$0000 + (015*128) + (022/2) - 128
  ld    bc,$0000 + (173*256) + (160/2)
  ld    a,LevelUpBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetPrimairySkillUpIcon:
  call  SetPrimairySkillLevelUpInA
  or    a                               ;attack
  ld    hl,$4000 + (132*128) + (090/2) - 128 ;attack
  jr    z,.PrimairySkillUpFound
  dec   a                               ;defence
  ld    hl,$4000 + (132*128) + (106/2) - 128 ;defense
  jr    z,.PrimairySkillUpFound
  dec   a                               ;knowledge
  ld    hl,$4000 + (132*128) + (122/2) - 128 ;knowledge
  jr    z,.PrimairySkillUpFound
  ld    hl,$4000 + (132*128) + (138/2) - 128 ;spell power
  .PrimairySkillUpFound:  

  ld    de,$0000 + (081*128) + (094/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,SecondarySkillsButtonsBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

IncreasePrimairySkill:
  ld    a,3
 	ld		(SetHeroArmyAndStatusInHud?),a

  call  SetPrimairySkillLevelUpInA
  or    a                               ;attack
  jr    z,.AttackUp
  dec   a                               ;defence
  jr    z,.DefenseUp
  dec   a                               ;knowledge
  jr    z,.KnowledgeUp

  .SpellDamageUp:                       ;spell damage
  inc   (ix+HeroStatSpellDamage)
  ret
  .KnowledgeUp:
  inc   (ix+HeroStatKnowledge)
  ret
  .DefenseUp:
  inc   (ix+HeroStatDefense)
  ret
  .AttackUp:
  inc   (ix+HeroStatAttack)
  ret

PrimairySkillLevelUpMight:
  db    0,1,0,1,0,1,2,3
PrimairySkillLevelUpAdventure:
  db    0,1,2,3,0,1,2,3
PrimairySkillLevelUpWizzardry:
  db    2,3,2,3,2,3,0,1

SetPrimairySkillLevelUpInA:
  ld    ix,(plxcurrentheroAddress)      ;

  ld    a,(ix+HeroSkills+0)             ;1-3=knight|4-6=barbarian|7-9=death knight|10-12=overlord       |      13-15=alchemist|16-18=sage|19-21=ranger      |      22-24=wizzard|25-27=battle mage|28-30=scholar|31-33=necromancer       
  ;the first skill the hero has tells us which class this hero is
  cp    13
  ld    hl,PrimairySkillLevelUpMight
  jp    c,.ClassFound
  cp    22
  ld    hl,PrimairySkillLevelUpAdventure
  jp    c,.ClassFound
  ld    hl,PrimairySkillLevelUpWizzardry
  .ClassFound:

  ld    a,(framecounter)
  and   7
  ld    d,0
  ld    e,a
  add   hl,de
  ld    a,(hl)
  ret






DisplayChestCode:
call ScreenOn
  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a  
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix

  call  SetChestButtons
  
  call  SetChestGraphics                ;put gfx
  call  SetChestText
  call  SwapAndSetPage                  ;swap and set page
  call  SetChestGraphics                ;put gfx
  call  SetChestText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
;  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number



  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton               ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton:
  ;we mark previous button clicked


  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram


  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state
  ;/Trading Heroes Inventory buttons




;  call  .CheckEndWindow                 ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc
  ld    a,%1100 0011
  ld    (GenericButtonTable),a          ;enable the V button once any other button is pressed

  ld    a,b
  cp    3                               ;V button pressed ?
  jr    z,.VButton
  ld    (PreviousButtonClicked),a
  ld    (PreviousButtonClickedIX),ix
  cp    2                               ;money button pressed ?
  jr    z,.MoneyButton
  
  .XPButton:                            ;XP button pressed
  ret

  .MoneyButton:
  ret
  
  .VButton:
  pop   af                              ;end DisplayChestCode
  ld    a,(PreviousButtonClicked)
  cp    2                               ;money was selected ?
  jr    z,.AddMoney

  .AddXp:
  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)

  ld    a,(BigChest?)
  or    a
  ld    hl,750                          ;gold
  jr    z,.SetAmountOfXp                ;zero flag: chest is red
  ld    hl,1000                         ;gold
  .SetAmountOfXp:


;  ld    ix,(plxcurrentheroAddress)      ;defending hero
  call  SetChestText.AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  

  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  ret   c
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  ret

  .AddMoney:
   call  SetResourcesCurrentPlayerinIX  
 
  ld    a,(BigChest?)
  or    a
  ld    de,1000                         ;gold
  jr    z,.SetAmountOfGold              ;zero flag: chest is red
  ld    de,1500                         ;gold
  .SetAmountOfGold: 
 ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)
  add   hl,de
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h
  ld    a,3
	ld		(SetResources?),a  
  ret  

SetChestButtons:
  ld    hl,ChestButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*03)
  ldir
  ret

ChestButtonTableGfxBlock:  db  PlayerStartTurnBlock
ChestButtonTableAmountOfButtons:  db  3
ChestButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  ;V button
  db  %0100 0011 | dw $4000 + (000*128) + (144/2) - 128 | dw $4000 + (019*128) + (144/2) - 128 | dw $4000 + (038*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  ;money button
  db  %1100 0011 | dw $4000 + (000*128) + (184/2) - 128 | dw $4000 + (032*128) + (184/2) - 128 | dw $4000 + (064*128) + (184/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  ;xp button
  db  %1100 0011 | dw $4000 + (000*128) + (216/2) - 128 | dw $4000 + (032*128) + (216/2) - 128 | dw $4000 + (064*128) + (216/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128

.Button1Ytop:           equ 157
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 164
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 137
.Button2YBottom:        equ .Button2Ytop + 032
.Button2XLeft:          equ 058
.Button2XRight:         equ .Button2XLeft + 032

.Button3Ytop:           equ 137
.Button3YBottom:        equ .Button3Ytop + 032
.Button3XLeft:          equ 116
.Button3XRight:         equ .Button3XLeft + 032


TextChest1:
                db "Chest",255
TextChest2:
                db "Having scoured the land you stumble",254
                db "upon hidden treasure: The choice lies",254
                db "between claiming the gold or bestowing",254
                db "it upon peasants for enlightenment.",255
TextChest3:
                db "Which do you choose ?",255
TextChest4:
                db "or",255

                
SetChestText:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    b,093+00                        ;dx
  ld    c,022+00                        ;dy
  ld    hl,TextChest1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,025+00                        ;dx
  ld    c,032+00                        ;dy
  ld    hl,TextChest2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,061+00                        ;dx
  ld    c,130+00                        ;dy
  ld    hl,TextChest3
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,097+00                        ;dx
  ld    c,151+00                        ;dy
  ld    hl,TextChest4
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(BigChest?)
  or    a
  ld    hl,1000                         ;gold
  jr    z,.SetAmountOfGold              ;zero flag: chest is red
  ld    hl,1500                         ;gold
  .SetAmountOfGold:
  ld    b,065+00                        ;dx
  ld    c,171+00                        ;dy
  call  SetNumber16BitCastle

  ld    a,(BigChest?)
  or    a
  ld    hl,750                          ;gold
  jr    z,.SetAmountOfXp                ;zero flag: chest is red
  ld    hl,1000                         ;gold
  .SetAmountOfXp:

  ld    ix,(plxcurrentheroAddress)      ;defending hero
  call  .AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  

  
  ld    b,121+00                        ;dx
  ld    c,171+00                        ;dy
  call  SetNumber16BitCastle
  ret



.AddXPBoostFromLearning:                 ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillLearning
  ret

  .CheckSkillLearning:
  cp    16                              ;Basic Learning  (xp +10%)  
  jr    z,.BasicLearningFound
  cp    17                              ;Advanced Learning  (xp +20%)  
  jr    z,.AdvancedLearningFound
  cp    18                              ;Expert Learning  (xp +30%)  
  jr    z,.ExpertLearningFound
  ret

  .BasicLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  jp    .ApplyPercentBasedBoost

  .AdvancedLearningFound:
  ld    de,5                            ;divide total attack by 5 to get 20%
  jp    .ApplyPercentBasedBoost

  .ExpertLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  .ApplyPercentBasedBoost
  add   hl,bc                           ;add that 10% again to get 20%
  add   hl,bc                           ;add that 10% again to get 30%
  ret

.ApplyPercentBasedBoost:
  push  hl                              ;hl=current total attack monster (after applying damage boosts from items)
  
  push  hl
  pop   bc
;  ld    de,2                            ;divide total attack by 2 to get 50%
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  pop   hl
  add   hl,bc                           ;add the 50% boost to total attack monster
  ret


SetChestGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128          ;red chest (rubies)
  ld    de,$0000 + (015*128) + (016/2) - 128
  ld    bc,$0000 + (168*256) + (174/2)
  ld    a,ChestBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    a,(BigChest?)
  or    a
  ret   nz                                            ;non zero flag: chest is red

  ld    hl,$4000 + (000*128) + (174/2) - 128          ;green chest (gems)
  ld    de,$0000 + (064*128) + (074/2) - 128
  ld    bc,$0000 + (062*256) + (058/2)
  ld    a,ChestBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


DisplayLearningStoneCOde:
  call  SetScrollVButton
  
  call  SetLearningStoneGraphics               ;put gfx
  call  SetLearningStoneText
  call  SwapAndSetPage                  ;swap and set page
  call  SetLearningStoneGraphics               ;put gfx
  call  SetLearningStoneText

  ld    ix,(plxcurrentheroAddress)      ;defending hero
  ld    hl,1000
  call  .AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jp    c,DisplayScrollCode.engine
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  jp    DisplayScrollCode.engine

.AddXPBoostFromLearning:                 ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillLearning
  ret

  .CheckSkillLearning:
  cp    16                              ;Basic Learning  (xp +10%)  
  jr    z,.BasicLearningFound
  cp    17                              ;Advanced Learning  (xp +20%)  
  jr    z,.AdvancedLearningFound
  cp    18                              ;Expert Learning  (xp +30%)  
  jr    z,.ExpertLearningFound
  ret

  .BasicLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  jp    .ApplyPercentBasedBoost

  .AdvancedLearningFound:
  ld    de,5                            ;divide total attack by 5 to get 20%
  jp    .ApplyPercentBasedBoost

  .ExpertLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  .ApplyPercentBasedBoost
  add   hl,bc                           ;add that 10% again to get 20%
  add   hl,bc                           ;add that 10% again to get 30%
  ret

.ApplyPercentBasedBoost:
  push  hl                              ;hl=current total attack monster (after applying damage boosts from items)
  
  push  hl
  pop   bc
;  ld    de,2                            ;divide total attack by 2 to get 50%
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  pop   hl
  add   hl,bc                           ;add the 50% boost to total attack monster
  ret

SetLearningStoneText:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    b,077+00                        ;dx
  ld    c,031+00                        ;dy
  ld    hl,TextLearningStone1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,030+00                        ;dx
  ld    c,114+00                        ;dy
  ld    hl,TextLearningStone2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,083+00                        ;dx
  ld    c,160+00                        ;dy
  ld    hl,TextLearningStone3
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    ix,(plxcurrentheroAddress)      ;defending hero
  ld    hl,1000
  call  DisplayLearningStoneCOde.AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ld    b,092+00                        ;dx
  ld    c,160+00                        ;dy
  jp    SetNumber16BitCastle

TextLearningStone1:
                db "Learning Stone",255
TextLearningStone2:
                db "Peering into the learning stone,",254
                db "you are amazed to see answers to",254
                db "questions you have pondered for",254
                db "years. The stone abruptly stills,",254
                db "but the realization washes over",254
                db "you - you have learned much.",255
TextLearningStone3:
                db "+     XP",255

DisplayScrollCode:
  call  SetScrollVButton
  
  call  SetScrollGraphics               ;put gfx
  call  SetScrollText
  call  SwapAndSetPage                  ;swap and set page
  call  SetScrollGraphics               ;put gfx
  call  SetScrollText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

  call  .CheckEndWindow                 ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc
  pop   af
  ret

  .CheckEndWindow:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    024                             ;dy
  jr    c,.Exit
  cp    024+148                         ;dy+ny
  jr    nc,.Exit
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    020                             ;dx
  jr    c,.Exit
  cp    020+162                         ;dx+nx
  ret   c

  .Exit:
  pop   af
  ret


SetScrollVButton:
  ld    hl,SetScrollVButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*01)
  ldir
  ret

SetScrollVButtonTableGfxBlock:  db  PlayerStartTurnBlock
SetScrollVButtonTableAmountOfButtons:  db  01
SetScrollVButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (144/2) - 128 | dw $4000 + (019*128) + (144/2) - 128 | dw $4000 + (038*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 

.Button1Ytop:           equ 146
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 154
.Button1XRight:         equ .Button1XLeft + 020


TextScroll1:
                db "Ancient scroll discovered",255
TextScroll2:
                db "Unearthing an ancient scroll, you",254
                db "imbue your spellbook with its",254
                db "mystic spell.",255
TextScroll3:
                db "Hypnotism",255

EarthSpellLevel1:        db  "  Earthbound   ",255
EarthSpellLevel2:        db  "  Plate Armor  ",255
EarthSpellLevel3:        db  " Resurrection  ",255
EarthSpellLevel4:        db  "  Earthshock   ",255
FireSpellLevel1:         db  "    Curse      ",255
FireSpellLevel2:         db  " Blinding Fog  ",255
FireSpellLevel3:         db  "   Implosion   ",255
FireSpellLevel4:         db  "   Sunstrike   ",255
AirSpellLevel1:          db  "    Haste      ",255
AirSpellLevel2:          db  " ShieldBreaker ",255
AirSpellLevel3:          db  "   Claw Back   ",255
AirSpellLevel4:          db  " Spell Bubble  ",255
WaterSpellLevel1:        db  "     Cure      ",255
WaterSpellLevel2:        db  "   Ice Peak    ",255
WaterSpellLevel3:        db  "   Hypnosis    ",255
WaterSpellLevel4:        db  "   Frost Ring  ",255
UniversalSpellLevel1:    db  " Magic Arrows  ",255
UniversalSpellLevel2:    db  "    Frenzy     ",255
UniversalSpellLevel3:    db  "   Teleport    ",255
UniversalSpellLevel4:    db  "Primal Instinct",255

                
SetScrollText:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    b,053+00                        ;dx
  ld    c,031+00                        ;dy
  ld    hl,TextScroll1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,030+00                        ;dx
  ld    c,041+00                        ;dy
  ld    hl,TextScroll2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(SpellScrollInventoryNumber)  ;from 46 (earth level 1) - 65 (universal level 4)
  sub   a,46
  ld    h,0
  ld    l,a
  ld    de,16
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,EarthSpellLevel1
  add   hl,de

  ld    b,073+00                        ;dx
  ld    c,147+00                        ;dy
;  ld    hl,TextScroll3
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret


SetLearningStoneGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (024*128) + (020/2) - 128
  ld    bc,$0000 + (148*256) + (162/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (139*128) + (044/2) - 128
  ld    de,$0000 + ((024+53)*128) + ((020+30)/2) - 128
  ld    bc,$0000 + (060*256) + (104/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (000*128) + (210/2) - 128
  ld    de,$0000 + ((024+19)*128) + ((020+60)/2) - 128
  ld    bc,$0000 + (068*256) + (038/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetScrollGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (024*128) + (020/2) - 128
  ld    bc,$0000 + (148*256) + (162/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

DisplayQuickTipsCode:
  call  SetQuickTipsButtons
  halt
  halt
  halt
  halt
  call  SetPlayerStartTurnGraphics      ;put gfx at (24,30)

  if  Promo?
  ld    a,(QuickTipsNumber)
  inc   a
  cp    LastQuickTip
  jr    nz,.EndCheckLastQuickTip
  xor   a
  .EndCheckLastQuickTip:
  ld    (QuickTipsNumber),a
  else
  ld    a,r
  endif

  push  af                              ;store random number for quicktips
  call  SetQuickTipsText
  call  SwapAndSetPage                  ;swap and set page
  call  SetPlayerStartTurnGraphics      ;put gfx at (24,30)
  pop   af                              ;recall random number for quicktips
  call  SetQuickTipsText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

  call  .CheckEndWindow                 ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc

  ld    a,(DisplayQuickTips?)
  xor   1
  ld    (DisplayQuickTips?),a
  ld    hl,QuicktipsOff
  jr    z,.SetQuicktipsOnOff
  ld    hl,QuicktipsOn
  .SetQuicktipsOnOff:
  ld    de,GenericButtonTable+1
  ld    bc,6
  ldir
  ret

  .CheckEndWindow:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    046                             ;dy
  jr    c,.Exit
  cp    046+095                         ;dy+ny
  jr    nc,.Exit
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    030                             ;dx
  jr    c,.Exit
  cp    030+144                         ;dx+nx
  ret   c

  .Exit:
  pop   af
  ret

TextDidYouKnow:       db "Did you know ?",255
TextShowTipsAtStart:  db "Show tips at start of turn ?",255

ListOfQuickTips: 
  dw TextQuickTip1 ,TextQuickTip2 ,TextQuickTip3 ,TextQuickTip4 ,TextQuickTip5 ,TextQuickTip6 ,TextQuickTip7 ,TextQuickTip8 ,TextQuickTip9 ,TextQuickTip10
  dw TextQuickTip11,TextQuickTip12,TextQuickTip13,TextQuickTip14,TextQuickTip15,TextQuickTip16,TextQuickTip17,TextQuickTip18,TextQuickTip19,TextQuickTip20
  dw TextQuickTip21,TextQuickTip22,TextQuickTip23,TextQuickTip24,TextQuickTip25,TextQuickTip26,TextQuickTip27,TextQuickTip28,TextQuickTip29,TextQuickTip30
  dw TextQuickTip31,TextQuickTip32,TextQuickTip33,TextQuickTip34,TextQuickTip35,TextQuickTip36,TextQuickTip37,TextQuickTip38,TextQuickTip39,TextQuickTip40
  dw TextQuickTip41,TextQuickTip42,TextQuickTip43,TextQuickTip44,TextQuickTip45
  
TotalAmountOfQuickTips: equ 45


SetQuickTipsText:
;  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0
  push  af                              ;random number

  ld    b,069+00                        ;dx
  ld    c,053+00                        ;dy
  ld    hl,TextDidYouKnow
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,QuickTipsBlock                ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  pop   af                              ;random number
  ld    b,0
  ld    c,a
  ld    de,TotalAmountOfQuickTips       ;divide the days by 7, the rest is the day of the week
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  add   hl,hl
  ld    de,ListOfQuickTips
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  ex    de,hl

;ld hl,TextQuickTip45

  ld    b,038+00                        ;dx
  ld    c,064+00                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,047+00                        ;dx
  ld    c,115+00                        ;dy
  ld    hl,TextShowTipsAtStart  
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

SetQuickTipsButtons:
  ld    hl,QuickTipsButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*01)
  ldir
  ret

QuicktipsOn:  dw $4000 + (057*128) + (144/2) - 128 | dw $4000 + (069*128) + (144/2) - 128 | dw $4000 + (081*128) + (144/2) - 128
QuicktipsOff: dw $4000 + (057*128) + (158/2) - 128 | dw $4000 + (069*128) + (158/2) - 128 | dw $4000 + (081*128) + (158/2) - 128

QuickTipsButtonTableGfxBlock:  db  PlayerStartTurnBlock
QuickTipsButtonTableAmountOfButtons:  db  01
QuickTipsButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (057*128) + (144/2) - 128 | dw $4000 + (069*128) + (144/2) - 128 | dw $4000 + (081*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 

.Button1Ytop:           equ 122
.Button1YBottom:        equ .Button1Ytop + 012
.Button1XLeft:          equ 096
.Button1XRight:         equ .Button1XLeft + 014






CopyInactivePageToActivePage:
  ld    a,(activepage)
  or    a
  ld    hl,CopyPage1To0
  jp    z,DoCopy
  ld    hl,CopyPage0To1PlayingField
  jp    DoCopy
  

DisplayStartOfTurnMessageCode:
;call ScreenOn
  call  SetPlayerStartTurnVButton
  
  call  SetPlayerStartTurnGraphics      ;put gfx at (24,30)
  call  SetPlayerStartTurnText
  call  CopyInactivePageToActivePage

;  call  SwapAndSetPage                  ;swap and set page
;  call  SetPlayerStartTurnGraphics     ;put gfx at (24,30)
;  call  SetPlayerStartTurnText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

;  call  CheckEndTradeMenuWindow   ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc
  pop   af
  ret

TextDate:           db "Day:   Week:   Month:",255
TextPlayerTurn:     db "Player  's turn",255

SetPlayerStartTurnText:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    b,056+00                        ;dx
  ld    c,053+00                        ;dy
  ld    hl,TextDate  
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ;set day
  ld    bc,(Date)
  ld    de,7                            ;divide the days by 7, the rest is the day of the week
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  inc   hl                              ;1-7
  ld    b,069+04                        ;dx
  ld    c,053+00                        ;dy
  call  SetNumber16BitCastle

  ;set week
  ld    bc,(Date)
  ld    de,7                            ;divide days by 7, the result is the weeks
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ;set week
  ld    de,4                            ;divide weeks by 4, the result is the months, and the rest is the weeks of the month
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc                              ;months
  inc   hl
  ld    b,104+04                        ;dx
  ld    c,053+00                        ;dy
  call  SetNumber16BitCastle

  ;set month
  pop   hl
  inc   hl
  ld    b,142+04                        ;dx
  ld    c,053+00                        ;dy
  call  SetNumber16BitCastle

  ld    b,075+00                        ;dx
  ld    c,091+00                        ;dy
  ld    hl,TextPlayerTurn  
  call  SetText                         ;in: b=dx, c=dy, hl->text

	ld		a,(whichplayernowplaying?)
	ld    h,0
	ld    l,a
  ld    b,095+06                        ;dx
  ld    c,091+00                        ;dy
  call  SetNumber16BitCastle
  ret

SetPlayerStartTurnGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (046*128) + (030/2) - 128
  ld    bc,$0000 + (095*256) + (144/2)
  ld    a,PlayerStartTurnBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetPlayerStartTurnVButton:
  ld    hl,PlayerStartTurnVButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*01)
  ldir
  ret

PlayerStartTurnVButtonTableGfxBlock:  db  PlayerStartTurnBlock
PlayerStartTurnVButtonTableAmountOfButtons:  db  01
PlayerStartTurnVButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (144/2) - 128 | dw $4000 + (019*128) + (144/2) - 128 | dw $4000 + (038*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 

.Button1Ytop:           equ 114
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 092
.Button1XRight:         equ .Button1XLeft + 020




TradeMenuCode:
	ld		a,3					                    ;put new heros in windows (page 0 and page 1) 
;	ld		(SetHeroArmyAndStatusInHud?),a
	ld		(ChangeManaAndMovement?),a  

  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  ld    (PreviousButton2Clicked),a
  
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix

  ld    ix,GenericButtonTable2
  ld    (PreviousButton2ClickedIX),ix

  call  SetTradingHeroesArmyButtons
  call  SetTradingHeroesInventoryButtons
  call  SetHeroArmyTransferGraphics     ;put gfx at (24,30)
  call  SetTradingHeroesAndArmy
  call  SetTradingHeroesInventoryIcons
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroArmyTransferGraphics     ;put gfx at (24,30)
  call  SetTradingHeroesAndArmy
  call  SetTradingHeroesInventoryIcons

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  call  UpdateHUd
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle  

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable2
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClickedTradingHeroesInventory             ;in: carry=button clicked, b=button number

  ;we mark previous button clicked
  ld    ix,(PreviousButton2ClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButton2Clicked)
  cp    255
  jr    z,.EndMarkButton2               ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton2:
  ;we mark previous button clicked

  ld    ix,GenericButtonTable2
  call  SetGenericButtons               ;copies button state from rom -> vram

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButton2ClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state
  ;/Trading Heroes Inventory buttons



  ;VisitingAndDefendingHeroesAndArmy buttons
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClickedTradingHeroesArmy             ;in: carry=button clicked, b=button number

  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton                ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1001 0011
  .EndMarkButton:
  ;we mark previous button clicked

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state
  ;/VisitingAndDefendingHeroesAndArmy buttons





  call  CheckEndTradeMenuWindow   ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine



.CheckButtonClickedTradingHeroesInventory:
  ret   nc                              ;carry=button pressed, b=which button

  ld    a,255
  ld    (PreviousButtonClicked),a


  ;at this point a button has been clicked. Check 3 possibilities:
  ;1. previously the same button was clicked-> reset
  ;2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ;3. previously a different button was clicked->swap

  ;check 1. previously the same button was clicked-> reset
  ld    a,(PreviousButton2Clicked)
  cp    b
  jr    nz,.EndCheck1b
  ld    a,255
  ld    (PreviousButton2Clicked),a
  ret
  .EndCheck1b:

  ;check 2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ld    a,(PreviousButton2Clicked)
  cp    255                             ;check if there is a button already highlighted
  jr    nz,.EndCheck2b

  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    6
  jp    nc,.CheckTradingHero            ;did we click the defending or visiting hero's windows ?

  .CheckHeroWeTradeWith:
  push  ix
  ld    ix,(HeroWeTradeWith)            ;hero who gets traded with
  ld    a,6
  sub   a,b  
  ld    d,0
  ld    e,a
  add   ix,de  

  ld    a,(ix+HeroInventory+9)          ;selected inventory slot for this hero
  cp    045                             ;045=empty
  pop   ix
  ret   z
  jp    .HighlightNewButton2  
  
  .CheckTradingHero:                      ;check empty inventory slot
  push  ix
  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)
  ld    a,12
  sub   a,b  
  ld    d,0
  ld    e,a
  add   ix,de  

  ld    a,(ix+HeroInventory+9)          ;selected inventory slot for this hero
  cp    045                             ;045=empty
  pop   ix
  ret   z
  jp    .HighlightNewButton2  
  .EndCheck2b:

  ;3. previously a different button was clicked->swap
  ld    d,b                             ;trading:  12 11 10 9 8 7 tradewith: 6 5 4 3 2 1
  call  .SetInventorySlotOfHeroInIX     ;in: d=slot
  ld    c,(ix+HeroInventory+9)          ;store item in selected inventory slot for this hero

  ld    a,(PreviousButton2Clicked)
  ld    d,a
  call  .SetInventorySlotOfHeroInIX     ;in: d=slot
  ld    d,(ix+HeroInventory+9)          ;selected inventory slot for this hero
  ld    (ix+HeroInventory+9),c          ;selected inventory slot for this hero
  ld    c,d

  ld    d,b                             ;trading:  12 11 10 9 8 7 tradewith: 6 5 4 3 2 1
  call  .SetInventorySlotOfHeroInIX     ;in: b=slot
  ld    (ix+HeroInventory+9),c          ;selected inventory slot for this hero

  pop   af
  jp    TradeMenuCode

  .HighlightNewButton2:
  ld    a,b                             ;current button clicked now becomes previous button clicked (for future references)
  ld    (PreviousButton2Clicked),a
  ld    (PreviousButton2ClickedIX),ix
  ret

.SetInventorySlotOfHeroInIX:
  ld    a,d
  cp    7
  jp    nc,.TradingHero                 ;did we click the defending or visiting hero's windows ?

  .HeroWeTradeWith:
  ld    ix,(HeroWeTradeWith)            ;hero who gets traded with
  ld    a,6
  sub   a,d
  ld    d,0
  ld    e,a
  add   ix,de  
  ret
  
  .TradingHero:                      ;check empty inventory slot
  ld    ix,(plxcurrentheroAddress)      ;current active hero (who trades)
  ld    a,12
  sub   a,d
  ld    d,0
  ld    e,a
  add   ix,de  
  ret


.CheckButtonClickedTradingHeroesArmy:                    ;in: carry=button clicked, b=button number
  ret   nc                              ;carry=button pressed, b=which button

  ld    a,255
  ld    (PreviousButton2Clicked),a

  ;at this point a button has been clicked. Check 3 possibilities:
  ;1. previously the same button was clicked-> reset
  ;2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ;3. previously a different button was clicked->swap

  ;check 1. previously the same button was clicked-> reset
  ld    a,(PreviousButtonClicked)
  cp    b
  jr    nz,.EndCheck1
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck1:

  ;check 2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ld    a,(PreviousButtonClicked)
  cp    255                             ;check if there is a button already highlighted
  jr    nz,.EndCheck2

  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    8
  jp    c,.CheckVisitingHero            ;did we click the defending or visiting hero's windows ?

  .CheckDefendingHero:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   ix
  pop   bc
;  ret   c                               ;no defending hero found, no need to highlight any button
  ;defending hero found, but now check if content of creature-button is empty, if so, ignore
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    14
  jp    z,.HighlightNewButton           ;if hero button is pressed, highlight button, since hero is in this slot
  ;check empty creature slot for defending hero
  ld    b,a
  ld    a,13
  sub   a,b  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  cp    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  ret   z
  ;/check empty creature slot for defending hero
  jp    .HighlightNewButton  
  
  .CheckVisitingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   ix
  pop   bc
;  ret   c                               ;no visiting hero found, no need to highlight any button
  ;defending hero found, but now check if content of creature-button is empty, if so, ignore
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    07
  jp    z,.HighlightNewButton           ;if hero button is pressed, highlight button, since hero is in this slot
  ;check empty creature slot for visiting hero
  ld    b,a
  ld    a,06
  sub   a,b  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  cp    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  ret   z
  ;/check empty creature slot for defending hero
  jp    .HighlightNewButton  
  .EndCheck2:

  ;check 3. previously a different button was clicked->swap

;Here we have multiple possibilities.First handle hero slots:

;4. This castle has a visiting AND a defending hero. Swap visiting with defending hero
;5. This castle has ONLY a defending hero. Change defending hero into visiting hero
;6. This castle has ONLY a visiting hero. Change visiting hero into defending hero
;7. Defending hero slot is highlighted, but now a non hero slot is clicked ->reset
;8. Visiting hero slot is highlighted, but now a non hero slot is clicked ->reset

;at this point we are only dealing only with creatures

;9. Both creature slots clicked belong to the same hero. Second slot clicked is empty, move (and split if possible) 1 unit
;10. Both creature slots clicked belong to the same hero. second slot clicked  has the same unit type, combine them 

;11. Both creature slots clicked belong to different heroes. Second slot clicked is empty, move all units if possible
;12. Both creature slots clicked belong to different heroes. second slot clicked  has the same unit type, combine them is possible 

;13. both slots have different units, swap them

;4. This castle has a visiting AND a defending hero. Swap visiting with defending hero
  ;check if there is a visiting AND a defending hero
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   ix
  pop   bc
;  jr    c,.EndCheck4
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   ix
  pop   bc
;  jr    c,.EndCheck4
  ;check if defending hero was previously clicked, and visiting hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    014                             ;check if defending hero was previously clicked
  jr    nz,.EndCheckPreviousButtonClickedWasDefendingHero
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    7                               ;check if visiting hero is now clicked
  jr    z,.SwapVisitingHeroWithDefendingHero
  .EndCheckPreviousButtonClickedWasDefendingHero:
  ;check if visiting hero was previously clicked, and defending hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck4
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if defending hero is now clicked
  jr    nz,.EndCheck4

  .SwapVisitingHeroWithDefendingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  push  ix                              ;swap after we handled defending hero
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  ld    (ix+HeroStatus),002             ;defending hero now becomes visiting hero 
  pop   ix                              ;now we can swap visiting hero at the same time
  ld    (ix+HeroStatus),254             ;visiting hero now becomes defending hero   
  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine

  jp    .ExitVisitingAndDefendingArmyRoutine
  .EndCheck4:

;5. This castle has ONLY a defending hero. Change defending hero into visiting hero
   ;check if defending hero was previously clicked, and visiting hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    014                             ;check if defending hero was previously clicked
  jr    nz,.EndCheck5
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    7                               ;check if visiting hero slot is now clicked
  jr    nz,.EndCheck5
 
  .ChangeDefendingHeroIntoVisitingHero:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  ld    (ix+HeroStatus),002             ;change defending hero into visiting hero 
  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  .EndCheck5:

;6. This castle has ONLY a visiting hero. Change visiting hero into defending hero
   ;check if visiting hero was previously clicked, and defending hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck6
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if defending hero slot is now clicked
  jr    nz,.EndCheck6

  .ChangeVisitingHeroIntoDefendingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  ld    (ix+HeroStatus),254             ;change defending hero into visiting hero 
  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  .EndCheck6:

;7. Defending hero slot is highlighted, but now a non hero slot is clicked ->reset
  ld    a,(PreviousButtonClicked)       ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck7
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck7:

;8. Visiting hero slot is highlighted, but now a non hero slot is clicked ->reset
  ld    a,(PreviousButtonClicked)       ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck8
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck8:

;at this point we are only dealing only with creatures
;check if one of the 2 slots click is a hero slot. If so, reset buttons
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    14                              ;hero slot defending hero
  jp    z,.ResetButtons
  cp    07                              ;hero slot visiting hero
  jp    z,.ResetButtons
  ld    a,(PreviousButtonClicked)
  cp    14                              ;hero slot defending hero
  jp    z,.ResetButtons
  cp    07                              ;hero slot visiting hero
  jp    z,.ResetButtons

;9. Both creature slots clicked belong to the same hero. Second slot clicked is empty, move (and split if possible) 1 unit
  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8
  jp    nc,.EndCheck9
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    nc,.EndCheck9

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck9
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;reduce amount of unit we want to split
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed
  dec   hl
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  ld    l,(ix+HeroUnits+0)              ;unit type

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jr    nz,.EndCheckZero
  ld    (ix+HeroUnits+0),0              ;unit type (remove when amount is zero)
  .EndCheckZero:
  pop   ix
  pop   bc
  ;/reduce amount of unit we want to split

  ;put one unit in the second slot/botton pressed
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    (ix+HeroUnits+0),l              ;unit type
  ld    (ix+HeroUnits+1),1              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed
  pop   ix
  pop   bc
  ;/put one unit in the second slot/botton pressed

  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  .EndCheck9:

;9b. same as 9, but then for defending hero
  ld    a,b                             ;both buttons pressed belong to defending hero?
  cp    8
  jp    c,.EndCheck9b
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    c,.EndCheck9b

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck9b
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;reduce amount of unit we want to split
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed
  dec   hl
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  ld    l,(ix+HeroUnits+0)              ;unit type

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jr    nz,.EndCheckZerob
  ld    (ix+HeroUnits+0),0              ;unit type (remove when amount is zero)
  .EndCheckZerob:
  pop   ix
  pop   bc
  ;/reduce amount of unit we want to split

  ;put one unit in the second slot/botton pressed
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    (ix+HeroUnits+0),l              ;unit type
  ld    (ix+HeroUnits+1),1              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed
  pop   ix
  pop   bc
  ;/put one unit in the second slot/botton pressed

  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  .EndCheck9b:


;10. Both creature slots clicked belong to the same hero. second slot clicked  has the same unit type, combine them 
  ;check if 2nd slot clicked has the same unit type (as the first slot clicked)
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8
  jp    nc,.EndCheck10
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    nc,.EndCheck10

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+0)              ;unit type
  pop   ix
  pop   bc

  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  cp    l
  jp    nz,.EndCheck10WithPopIXandBC

  ld    (ix+HeroUnits+0),0              ;unit type second button pressed
  ld    l,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit type second button pressed

  ld    (ix+HeroUnits+1),0              ;unit type second button pressed
  ld    (ix+HeroUnits+2),0              ;unit type second button pressed
  
  ;/check if 2nd slot clicked has the same unit type (as the first slot clicked)
  pop   ix
  pop   bc
  
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit type second button pressed
  add   hl,de

  ld    (ix+HeroUnits+1),l              ;unit type second button pressed
  ld    (ix+HeroUnits+2),h              ;unit type second button pressed

  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine

  .EndCheck10WithPopIXandBC:
  pop   ix
  pop   bc
  .EndCheck10:

;10b. same as 10 but then for defending hero
  ld    a,b                             ;both buttons pressed belong to defending hero?
  cp    8
  jp    c,.EndCheck10b
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    c,.EndCheck10b

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending

  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+0)              ;unit type
  pop   ix
  pop   bc


  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  cp    l
  jp    nz,.EndCheck10bWithPopIXandBC

  ld    (ix+HeroUnits+0),0              ;unit type second button pressed
  ld    l,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit type second button pressed

  ld    (ix+HeroUnits+1),0              ;unit type second button pressed
  ld    (ix+HeroUnits+2),0              ;unit type second button pressed
  
  ;/check if 2nd slot clicked has the same unit type (as the first slot clicked)
  pop   ix
  pop   bc
  
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit type second button pressed
  add   hl,de

  ld    (ix+HeroUnits+1),l              ;unit type second button pressed
  ld    (ix+HeroUnits+2),h              ;unit type second button pressed

  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine

  .EndCheck10bWithPopIXandBC:
  pop   ix
  pop   bc
  .EndCheck10b:

;11. Both creature slots clicked belong to different heroes. 
  ;Second slot clicked is empty, move all units if possible
  ;first check if castle has both a defending and a visiting hero present
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   ix
  pop   bc
;  jp    c,.EndCheck12b

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   ix
  pop   bc
;  jp    c,.EndCheck12b
  ;/first check if castle has both a defending and a visiting hero present

  ;check if visiting hero has AT LEAST 2 creature slots filled
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck11                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to defending hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    c,.EndCheck11

  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck11
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;move all selected units from visiting hero to defending hero
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  ;/move all selected units from visiting hero to defending hero
  .EndCheck11:

;11b same as 11 but then for opposite hero





  ;check if defending hero has AT LEAST 2 creature slots filled
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck11b                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if defending hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to visiting hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    nc,.EndCheck11b

  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck11b
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;move all selected units from defending hero to visiting hero
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  ;/move all selected units from visiting hero to defending hero
  .EndCheck11b:

;12. Both creature slots clicked belong to different heroes. second slot clicked  has the same unit type, combine them if possible 

  ;check if visiting hero has AT LEAST 2 creature slots filled
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck12                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to defending hero
  ld    a,b                             ;last  button pressed belongs to defending hero?
  cp    8
  jp    c,.EndCheck12

  ;check if the unit type is the same for both buttons clicked
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    l,(ix+HeroUnits+0)              ;unit type visiting hero
  pop   ix
  pop   bc
  
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    a,(ix+HeroUnits+0)              ;unit type defending hero
  cp    l
  pop   ix
  pop   bc
  jp    nz,.EndCheck12
  ;/check if the unit type is the same for both buttons clicked

  ;move and merge all selected units from visiting hero to defending hero 
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit amount second button pressed
  add   hl,de
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck12:
  
;12b. same as 12, but then for opposite heroes
  ;check if defending hero has AT LEAST 2 creature slots filled
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck12b                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to visiting hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    nc,.EndCheck12b

  ;check if the unit type is the same for both buttons clicked
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    l,(ix+HeroUnits+0)              ;unit type visiting hero
  pop   ix
  pop   bc
  
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    a,(ix+HeroUnits+0)              ;unit type defending hero
  cp    l
  pop   ix
  pop   bc
  jp    nz,.EndCheck12b
  ;/check if the unit type is the same for both buttons clicked

  ;move and merge all selected units from defending hero to visiting hero 
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit amount second button pressed
  add   hl,de
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck12b:

;13. both slots have different units, swap them

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to defending hero
  ld    a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    a,l
  or    h
  jp    z,.ResetButtons                 ;no need to swap if this slot has no units
  exx

  ld    a,(PreviousButtonClicked)       ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    a,l
  or    h
  jp    z,.ResetButtons                 ;no need to swap if this slot has no units

  exx
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  ld    a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX
  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  exx
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  
  pop   af                              ;pop the call to this routine
  jp    .ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck13:
  
  .HighlightNewButton:
  ld    a,b                             ;current button clicked now becomes previous button clicked (for future references)
  ld    (PreviousButtonClicked),a
  ld    (PreviousButtonClickedIX),ix
  ret

  .ResetButtons:
  ld    a,255                           ;reset previous button clicked  
  ld    (PreviousButtonClicked),a
  ret

.SetHeroUnitsInIX:
  cp    8
  jp    c,.VisitingHero

  .DefendingHero:
  ld    c,a
  ld    a,13
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  pop   de
  pop   bc
  add   ix,de  
  add   ix,de  
  add   ix,de  
  ret
  
  .VisitingHero:  
  ld    c,a
  ld    a,06
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
;  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    ix,(HeroWeTradeWith)      ;lets call this visiting
  pop   de
  pop   bc
  add   ix,de  
  add   ix,de  
  add   ix,de  
  ret


.ExitVisitingAndDefendingArmyRoutine:    ;a jump to this routine is made when refreshing the visiting and defending army heroes and creatures overview
  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0
;  call  SetVisitingAndDefendingHeroesAndArmyWindow  
;  call  SetVisitingAndDefendingHeroesAndArmy
;  call  SwapAndSetPage                  ;swap and set page
;  call  SetVisitingAndDefendingHeroesAndArmyWindow  
;  call  SetVisitingAndDefendingHeroesAndArmy


  call  SetHeroArmyTransferGraphics     ;put gfx at (24,30)
  call  SetTradingHeroesAndArmy
  call  SetTradingHeroesInventoryIcons
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroArmyTransferGraphics     ;put gfx at (24,30)
  call  SetTradingHeroesInventoryIcons
  call  SetTradingHeroesAndArmy
  jp    .engine


























































CheckEndTradeMenuWindow:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    030                             ;dy
  jr    c,.Exit
  cp    030+137                         ;dy+ny
  jr    nc,.Exit
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    024                             ;dx
  jr    c,.Exit
  cp    024+156                         ;dx+nx
  ret   c

  .Exit:
  pop   af
  ret








SetTradingHeroesInventoryButtons:
  ld    hl,TradingHeroesInventoryButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*12)
  ldir

  .CreateInventoryListTradingHeroes:         ;writes icon coordinates to list:ButtonTableInventoryIconsSYSX
  ld    ix,(plxcurrentheroAddress)
  ld    de,9                            ;skip the first 9 equiped inventory items, and go to the 6 open slots
  add   ix,de

  ld    iy,GenericButtonTable2+1
  ld    b,6                             ;6 inventory slots
  call  .loop


  ld    ix,(HeroWeTradeWith)
  ld    de,9                            ;skip the first 9 equiped inventory items, and go to the 6 open slots
  add   ix,de

  ld    b,6                             ;6 inventory slots
  .loop:
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15
  call  SetTradingHeroesInventoryIcons.CheckScrollIcon                ;scroll icons have nr 46-65 (but all use the same icon)
  add   a,a                             ;*2
  add   a,a                             ;*4
  ld    d,0
  ld    e,a
  ld    hl,SetTradingHeroesInventoryIcons.InventoryIconTableSYSX
  add   hl,de
  ld    a,(hl)
  ld    (iy+0),a
  inc   hl
  ld    a,(hl)
  ld    (iy+1),a
  inc   hl
  ld    a,(hl)
  ld    (iy+2),a
  inc   hl
  ld    a,(hl)
  ld    (iy+3),a
  ld    de,GenericButtonTableLenghtPerButton
  add   iy,de                           ;next button in ButtonTableInventoryIconsSYSX
  inc   ix                              ;next hero-inventory item
  djnz  .loop
  ret



TradingHeroesInventoryButtonTableGfxBlock:  db  InventoryGraphicsBlock
TradingHeroesInventoryButtonTableAmountOfButtons:  db  12
TradingHeroesInventoryButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (021*128) + (170/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (180*128) + (100/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button4Ytop,.Button4YBottom,.Button4XLeft,.Button4XRight | dw $0000 + (.Button4Ytop*128) + (.Button4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (050*128) + (050/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button5Ytop,.Button5YBottom,.Button5XLeft,.Button5XRight | dw $0000 + (.Button5Ytop*128) + (.Button5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (060*128) + (060/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button6Ytop,.Button6YBottom,.Button6XLeft,.Button6XRight | dw $0000 + (.Button6Ytop*128) + (.Button6XLeft/2) - 128

  db  %1100 0011 | dw $4000 + (040*128) + (040/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button7Ytop,.Button7YBottom,.Button7XLeft,.Button7XRight | dw $0000 + (.Button7Ytop*128) + (.Button7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (030*128) + (030/2) - 128 | dw $4000 + (000*128) + (176/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button8Ytop,.Button8YBottom,.Button8XLeft,.Button8XRight | dw $0000 + (.Button8Ytop*128) + (.Button8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (020*128) + (020/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button9Ytop,.Button9YBottom,.Button9XLeft,.Button9XRight | dw $0000 + (.Button9Ytop*128) + (.Button9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button10Ytop,.Button10YBottom,.Button10XLeft,.Button10XRight | dw $0000 + (.Button10Ytop*128) + (.Button10XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button11Ytop,.Button11YBottom,.Button11XLeft,.Button11XRight | dw $0000 + (.Button11Ytop*128) + (.Button11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (056*128) + (176/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128 | db .Button12Ytop,.Button12YBottom,.Button12XLeft,.Button12XRight | dw $0000 + (.Button12Ytop*128) + (.Button12XLeft/2) - 128

.Button1Ytop:           equ 077
.Button1YBottom:        equ .Button1Ytop + 020
.Button1XLeft:          equ 036
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 077
.Button2YBottom:        equ .Button2Ytop + 020
.Button2XLeft:          equ 058
.Button2XRight:         equ .Button2XLeft + 020

.Button3Ytop:           equ 077
.Button3YBottom:        equ .Button3Ytop + 020
.Button3XLeft:          equ 080
.Button3XRight:         equ .Button3XLeft + 020

.Button4Ytop:           equ 077
.Button4YBottom:        equ .Button4Ytop + 020
.Button4XLeft:          equ 102
.Button4XRight:         equ .Button4XLeft + 020

.Button5Ytop:           equ 077
.Button5YBottom:        equ .Button5Ytop + 020
.Button5XLeft:          equ 124
.Button5XRight:         equ .Button5XLeft + 020

.Button6Ytop:           equ 077
.Button6YBottom:        equ .Button6Ytop + 020
.Button6XLeft:          equ 146
.Button6XRight:         equ .Button6XLeft + 020



.Button7Ytop:           equ 141
.Button7YBottom:        equ .Button7Ytop + 020
.Button7XLeft:          equ 036
.Button7XRight:         equ .Button7XLeft + 020

.Button8Ytop:           equ 141
.Button8YBottom:        equ .Button8Ytop + 020
.Button8XLeft:          equ 058
.Button8XRight:         equ .Button8XLeft + 020

.Button9Ytop:           equ 141
.Button9YBottom:        equ .Button9Ytop + 020
.Button9XLeft:          equ 080
.Button9XRight:         equ .Button9XLeft + 020

.Button10Ytop:           equ 141
.Button10YBottom:        equ .Button10Ytop + 020
.Button10XLeft:          equ 102
.Button10XRight:         equ .Button10XLeft + 020

.Button11Ytop:           equ 141
.Button11YBottom:        equ .Button11Ytop + 020
.Button11XLeft:          equ 124
.Button11XRight:         equ .Button11XLeft + 020

.Button12Ytop:           equ 141
.Button12YBottom:        equ .Button12Ytop + 020
.Button12XLeft:          equ 146
.Button12XRight:         equ .Button12XLeft + 020








SetTradingHeroesArmyButtons:
  ld    hl,TradingHeroesButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*14)
  ldir
  ret

TradingHeroesButtonTableGfxBlock:  db  HeroArmyTransferGraphicsBlock
TradingHeroesButtonTableAmountOfButtons:  db  14
TradingHeroesButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  db  %0100 0011 | dw $4000 + (000*128) + (156/2) - 128 | dw $4000 + (000*128) + (176/2) - 128 | dw $4000 + (000*128) + (196/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button4Ytop,.Button4YBottom,.Button4XLeft,.Button4XRight | dw $0000 + (.Button4Ytop*128) + (.Button4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button5Ytop,.Button5YBottom,.Button5XLeft,.Button5XRight | dw $0000 + (.Button5Ytop*128) + (.Button5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button6Ytop,.Button6YBottom,.Button6XLeft,.Button6XRight | dw $0000 + (.Button6Ytop*128) + (.Button6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button7Ytop,.Button7YBottom,.Button7XLeft,.Button7XRight | dw $0000 + (.Button7Ytop*128) + (.Button7XLeft/2) - 128

  db  %0100 0011 | dw $4000 + (000*128) + (156/2) - 128 | dw $4000 + (000*128) + (176/2) - 128 | dw $4000 + (000*128) + (196/2) - 128 | db .Button8Ytop,.Button8YBottom,.Button8XLeft,.Button8XRight | dw $0000 + (.Button8Ytop*128) + (.Button8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button9Ytop,.Button9YBottom,.Button9XLeft,.Button9XRight | dw $0000 + (.Button9Ytop*128) + (.Button9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button10Ytop,.Button10YBottom,.Button10XLeft,.Button10XRight | dw $0000 + (.Button10Ytop*128) + (.Button10XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button11Ytop,.Button11YBottom,.Button11XLeft,.Button11XRight | dw $0000 + (.Button11Ytop*128) + (.Button11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button12Ytop,.Button12YBottom,.Button12XLeft,.Button12XRight | dw $0000 + (.Button12Ytop*128) + (.Button12XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button13Ytop,.Button13YBottom,.Button13XLeft,.Button13XRight | dw $0000 + (.Button13Ytop*128) + (.Button13XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (034*128) + (156/2) - 128 | dw $4000 + (034*128) + (174/2) - 128 | dw $4000 + (034*128) + (192/2) - 128 | db .Button14Ytop,.Button14YBottom,.Button14XLeft,.Button14XRight | dw $0000 + (.Button14Ytop*128) + (.Button14XLeft/2) - 128

.Button1Ytop:           equ 038
.Button1YBottom:        equ .Button1Ytop + 034
.Button1XLeft:          equ 032
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 040
.Button2YBottom:        equ .Button2Ytop + 030
.Button2XLeft:          equ 054
.Button2XRight:         equ .Button2XLeft + 018

.Button3Ytop:           equ 040
.Button3YBottom:        equ .Button3Ytop + 030
.Button3XLeft:          equ 074
.Button3XRight:         equ .Button3XLeft + 018

.Button4Ytop:           equ 040
.Button4YBottom:        equ .Button4Ytop + 030
.Button4XLeft:          equ 094
.Button4XRight:         equ .Button4XLeft + 018

.Button5Ytop:           equ 040
.Button5YBottom:        equ .Button5Ytop + 030
.Button5XLeft:          equ 114
.Button5XRight:         equ .Button5XLeft + 018

.Button6Ytop:           equ 040
.Button6YBottom:        equ .Button6Ytop + 030
.Button6XLeft:          equ 134
.Button6XRight:         equ .Button6XLeft + 018

.Button7Ytop:           equ 040
.Button7YBottom:        equ .Button7Ytop + 030
.Button7XLeft:          equ 154
.Button7XRight:         equ .Button7XLeft + 018



.Button8Ytop:           equ 102
.Button8YBottom:        equ .Button8Ytop + 034
.Button8XLeft:          equ 032
.Button8XRight:         equ .Button8XLeft + 020

.Button9Ytop:           equ 104
.Button9YBottom:        equ .Button9Ytop + 030
.Button9XLeft:          equ 054
.Button9XRight:         equ .Button9XLeft + 018

.Button10Ytop:           equ 104
.Button10YBottom:        equ .Button10Ytop + 030
.Button10XLeft:          equ 074
.Button10XRight:         equ .Button10XLeft + 018

.Button11Ytop:           equ 104
.Button11YBottom:        equ .Button11Ytop + 030
.Button11XLeft:          equ 094
.Button11XRight:         equ .Button11XLeft + 018

.Button12Ytop:           equ 104
.Button12YBottom:        equ .Button12Ytop + 030
.Button12XLeft:          equ 114
.Button12XRight:         equ .Button12XLeft + 018

.Button13Ytop:           equ 104
.Button13YBottom:        equ .Button13Ytop + 030
.Button13XLeft:          equ 134
.Button13XRight:         equ .Button13XLeft + 018

.Button14Ytop:           equ 104
.Button14YBottom:        equ .Button14Ytop + 030
.Button14XLeft:          equ 154
.Button14XRight:         equ .Button14XLeft + 018




















SetTradingHeroesAndArmy:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetActiveTradingHero
  call  SetHeroWhoGetsTradeWith
  call  SetActiveTradingHeroArmyAndAmount
  call  SetHeroWhoGetsTradeWithArmyAndAmount
  ret







SetActiveTradingHero:                   ;which hero commences trade ?
  ld    ix,(plxcurrentheroAddress)
  ld    de,$0000 + (040*128) + (034/2) - 128
  jp    DoSetVisitingOrDefendingHero
  
SetHeroWhoGetsTradeWith:  
  ld    ix,(HeroWeTradeWith)            ;which hero are we trading with
  ld    de,$0000 + (104*128) + (034/2) - 128
  jp    DoSetVisitingOrDefendingHero





SetActiveTradingHeroArmyAndAmount:
  ld    ix,(plxcurrentheroAddress)


  call  .army
;  call  .amount
;  ret

  .amount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,056
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,076
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,096
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,116
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,136
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,156
  ld    c,061
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

  .army:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXDefendingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

.DYDXDefendingHeroUnit1:          equ 044*256 + 056      ;(dy*256 + dx)
.DYDXDefendingHeroUnit2:          equ 044*256 + 076      ;(dy*256 + dx)
.DYDXDefendingHeroUnit3:          equ 044*256 + 096      ;(dy*256 + dx)
.DYDXDefendingHeroUnit4:          equ 044*256 + 116      ;(dy*256 + dx)
.DYDXDefendingHeroUnit5:          equ 044*256 + 136      ;(dy*256 + dx)
.DYDXDefendingHeroUnit6:          equ 044*256 + 156      ;(dy*256 + dx)

SetHeroWhoGetsTradeWithArmyAndAmount:
  ld    ix,(HeroWeTradeWith)


  call  .army
;  call  .amount
;  ret

  .amount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,056
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,076
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,096
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,116
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,136
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,156
  ld    c,125
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

  .army:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,.DYDXVisitingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

.DYDXVisitingHeroUnit1:          equ 108*256 + 056      ;(dy*256 + dx)
.DYDXVisitingHeroUnit2:          equ 108*256 + 076      ;(dy*256 + dx)
.DYDXVisitingHeroUnit3:          equ 108*256 + 096      ;(dy*256 + dx)
.DYDXVisitingHeroUnit4:          equ 108*256 + 116      ;(dy*256 + dx)
.DYDXVisitingHeroUnit5:          equ 108*256 + 136      ;(dy*256 + dx)
.DYDXVisitingHeroUnit6:          equ 108*256 + 156      ;(dy*256 + dx)





























ExitVisitingAndDefendingArmyRoutine:    ;a jump to this routine is made when refreshing the visiting and defending army heroes and creatures overview
  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetVisitingAndDefendingHeroesAndArmyWindow  
  call  SetVisitingAndDefendingHeroesAndArmy
  call  SwapAndSetPage                  ;swap and set page
  call  SetVisitingAndDefendingHeroesAndArmyWindow  
  call  SetVisitingAndDefendingHeroesAndArmy

  ld    a,(AreWeInTavern1OrRecruit2?)
  dec   a
  jp    z,CastleOverviewTavernCode.engine
  jp    CastleOverviewRecruitCode.engine


FirstLineintHeightCastleTavern: equ 125
SecondLineintHeightCastleTavern: equ 160

;FirstLineintHeightCastleTavern: equ 125
;SecondLineintHeightCastleTavern: equ 158
SetCastleTavernInterruptHandler:
  di
  ld    hl,CastleInterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
 
  ld    a,(VDP_0)           ;set ei1
  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  out   ($99),a

  ld    a,FirstLineintHeightCastleTavern
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

CastleOverviewTavernCode:
  call  SetScreenOff

  ld    a,1
  ld    (AreWeInTavern1OrRecruit2?),a

  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix

  call  SetTavernButtons
  call  SetDefendingAndVisitingHeroButtons

  ld    hl,InGamePalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,132
  call  SetExitButtonHeight
  
  call  SetTavernGraphics               ;put gfx in page 1
  call  SetResourcesPlayer
  call  SetVisitingAndDefendingHeroesAndArmy
  call  SetTavernHeroes

  ld    hl,CopyPage1To0
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetCastleTavernInterruptHandler
	
  .engine:
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,CastleOverviewCode

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;VisitingAndDefendingHeroesAndArmy buttons
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClickedVisitingAndDefendingHeroesAndArmy             ;in: carry=button clicked, b=button number

  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton                ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1001 0011
  .EndMarkButton:
  ;we mark previous button clicked

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state


  ;/VisitingAndDefendingHeroesAndArmy buttons

  ;tavern buttons
  ld    ix,GenericButtonTable2 
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckTavernButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable2
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/tavern buttons

  call  WaitVblank
  call  SetScreenOn
  jp  .engine

.CheckButtonClickedVisitingAndDefendingHeroesAndArmy:                    ;in: carry=button clicked, b=button number
  ret   nc                              ;carry=button pressed, b=which button

  ;at this point a button has been click. Check 3 possibilities:
  ;1. previously the same button was clicked-> reset
  ;2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ;3. previously a different button was clicked->swap

  ;check 1. previously the same button was clicked-> reset
  ld    a,(PreviousButtonClicked)
  cp    b
  jr    nz,.EndCheck1
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck1:

  ;check 2. previously a button has not been clicked/highlighted-> check if content of button is empty, if so, ignore, otherwise -> highlight
  ld    a,(PreviousButtonClicked)
  cp    255                             ;check if there is a button already highlighted
  jr    nz,.EndCheck2

  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    8
  jp    c,.CheckVisitingHero            ;did we click the defending or visiting hero's windows ?

  .CheckDefendingHero:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  ret   c                               ;no defending hero found, no need to highlight any button
  ;defending hero found, but now check if content of creature-button is empty, if so, ignore
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    14
  jp    z,.HighlightNewButton           ;if hero button is pressed, highlight button, since hero is in this slot
  ;check empty creature slot for defending hero
  ld    b,a
  ld    a,13
  sub   a,b  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  cp    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  ret   z
  ;/check empty creature slot for defending hero
  jp    .HighlightNewButton  
  
  .CheckVisitingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  ret   c                               ;no visiting hero found, no need to highlight any button
  ;defending hero found, but now check if content of creature-button is empty, if so, ignore
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    07
  jp    z,.HighlightNewButton           ;if hero button is pressed, highlight button, since hero is in this slot
  ;check empty creature slot for visiting hero
  ld    b,a
  ld    a,06
  sub   a,b  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  cp    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  ret   z
  ;/check empty creature slot for defending hero
  jp    .HighlightNewButton  
  .EndCheck2:

  ;check 3. previously a different button was clicked->swap

;Here we have multiple possibilities.First handle hero slots:

;4. This castle has a visiting AND a defending hero. Swap visiting with defending hero
;5. This castle has ONLY a defending hero. Change defending hero into visiting hero
;6. This castle has ONLY a visiting hero. Change visiting hero into defending hero
;7. Defending hero slot is highlighted, but now a non hero slot is clicked ->reset
;8. Visiting hero slot is highlighted, but now a non hero slot is clicked ->reset

;at this point we are only dealing only with creatures

;9. Both creature slots clicked belong to the same hero. Second slot clicked is empty, move (and split if possible) 1 unit
;10. Both creature slots clicked belong to the same hero. second slot clicked  has the same unit type, combine them 

;11. Both creature slots clicked belong to different heroes. Second slot clicked is empty, move all units if possible
;12. Both creature slots clicked belong to different heroes. second slot clicked  has the same unit type, combine them is possible 

;13. both slots have different units, swap them

;4. This castle has a visiting AND a defending hero. Swap visiting with defending hero
  ;check if there is a visiting AND a defending hero
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  jr    c,.EndCheck4
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  jr    c,.EndCheck4
  ;check if defending hero was previously clicked, and visiting hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    014                             ;check if defending hero was previously clicked
  jr    nz,.EndCheckPreviousButtonClickedWasDefendingHero
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    7                               ;check if visiting hero is now clicked
  jr    z,.SwapVisitingHeroWithDefendingHero
  .EndCheckPreviousButtonClickedWasDefendingHero:
  ;check if visiting hero was previously clicked, and defending hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck4
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if defending hero is now clicked
  jr    nz,.EndCheck4

  .SwapVisitingHeroWithDefendingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  push  ix                              ;swap after we handled defending hero
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    (ix+HeroStatus),002             ;defending hero now becomes visiting hero 
  pop   ix                              ;now we can swap visiting hero at the same time
  ld    (ix+HeroStatus),254             ;visiting hero now becomes defending hero   
  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine

  jp    ExitVisitingAndDefendingArmyRoutine
  .EndCheck4:

;5. This castle has ONLY a defending hero. Change defending hero into visiting hero
   ;check if defending hero was previously clicked, and visiting hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    014                             ;check if defending hero was previously clicked
  jr    nz,.EndCheck5
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    7                               ;check if visiting hero slot is now clicked
  jr    nz,.EndCheck5
 
  .ChangeDefendingHeroIntoVisitingHero:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    (ix+HeroStatus),002             ;change defending hero into visiting hero 
  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  .EndCheck5:

;6. This castle has ONLY a visiting hero. Change visiting hero into defending hero
   ;check if visiting hero was previously clicked, and defending hero is now clicked
  ld    a,(PreviousButtonClicked)
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck6
  ld    a,b                             ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if defending hero slot is now clicked
  jr    nz,.EndCheck6

  .ChangeVisitingHeroIntoDefendingHero:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ld    (ix+HeroStatus),254             ;change defending hero into visiting hero 
  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  .EndCheck6:

;7. Defending hero slot is highlighted, but now a non hero slot is clicked ->reset
  ld    a,(PreviousButtonClicked)       ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    014                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck7
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck7:

;8. Visiting hero slot is highlighted, but now a non hero slot is clicked ->reset
  ld    a,(PreviousButtonClicked)       ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1
  cp    007                             ;check if visiting hero was previously clicked
  jr    nz,.EndCheck8
  ld    a,255
  ld    (PreviousButtonClicked),a
  ret
  .EndCheck8:

;at this point we are only dealing only with creatures
;check if one of the 2 slots click is a hero slot. If so, reset buttons
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    14                              ;hero slot defending hero
  jp    z,.ResetButtons
  cp    07                              ;hero slot visiting hero
  jp    z,.ResetButtons
  ld    a,(PreviousButtonClicked)
  cp    14                              ;hero slot defending hero
  jp    z,.ResetButtons
  cp    07                              ;hero slot visiting hero
  jp    z,.ResetButtons

;9. Both creature slots clicked belong to the same hero. Second slot clicked is 
  ;empty, move (and split if possible) 1 unit
  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8
  jp    nc,.EndCheck9
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    nc,.EndCheck9

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck9
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;reduce amount of unit we want to split
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed
  dec   hl
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  ld    l,(ix+HeroUnits+0)              ;unit type

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jr    nz,.EndCheckZero
  ld    (ix+HeroUnits+0),0              ;unit type (remove when amount is zero)
  .EndCheckZero:
  pop   ix
  pop   bc
  ;/reduce amount of unit we want to split

  ;put one unit in the second slot/botton pressed
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    (ix+HeroUnits+0),l              ;unit type
  ld    (ix+HeroUnits+1),1              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed
  pop   ix
  pop   bc
  ;/put one unit in the second slot/botton pressed

  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  .EndCheck9:

;9b. same as 9, but then for defending hero
  ld    a,b                             ;both buttons pressed belong to defending hero?
  cp    8
  jp    c,.EndCheck9b
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    c,.EndCheck9b

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck9b
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;reduce amount of unit we want to split
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed
  dec   hl
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  ld    l,(ix+HeroUnits+0)              ;unit type

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jr    nz,.EndCheckZerob
  ld    (ix+HeroUnits+0),0              ;unit type (remove when amount is zero)
  .EndCheckZerob:
  pop   ix
  pop   bc
  ;/reduce amount of unit we want to split

  ;put one unit in the second slot/botton pressed
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    (ix+HeroUnits+0),l              ;unit type
  ld    (ix+HeroUnits+1),1              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed
  pop   ix
  pop   bc
  ;/put one unit in the second slot/botton pressed

  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  .EndCheck9b:


;10. Both creature slots clicked belong to the same hero. second slot clicked  has the same unit type, combine them 
  ;check if 2nd slot clicked has the same unit type (as the first slot clicked)
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8
  jp    nc,.EndCheck10
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    nc,.EndCheck10

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+0)              ;unit type
  pop   ix
  pop   bc

  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  cp    l
  jp    nz,.EndCheck10WithPopIXandBC

  ld    (ix+HeroUnits+0),0              ;unit type second button pressed
  ld    l,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit type second button pressed

  ld    (ix+HeroUnits+1),0              ;unit type second button pressed
  ld    (ix+HeroUnits+2),0              ;unit type second button pressed
  
  ;/check if 2nd slot clicked has the same unit type (as the first slot clicked)
  pop   ix
  pop   bc
  
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit type second button pressed
  add   hl,de

  ld    (ix+HeroUnits+1),l              ;unit type second button pressed
  ld    (ix+HeroUnits+2),h              ;unit type second button pressed

  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine

  .EndCheck10WithPopIXandBC:
  pop   ix
  pop   bc
  .EndCheck10:

;10b. same as 10 but then for defending hero
  ld    a,b                             ;both buttons pressed belong to defending hero?
  cp    8
  jp    c,.EndCheck10b
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    c,.EndCheck10b

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+0)              ;unit type
  pop   ix
  pop   bc


  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  cp    l
  jp    nz,.EndCheck10bWithPopIXandBC

  ld    (ix+HeroUnits+0),0              ;unit type second button pressed
  ld    l,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit type second button pressed

  ld    (ix+HeroUnits+1),0              ;unit type second button pressed
  ld    (ix+HeroUnits+2),0              ;unit type second button pressed
  
  ;/check if 2nd slot clicked has the same unit type (as the first slot clicked)
  pop   ix
  pop   bc
  
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit type second button pressed
  add   hl,de

  ld    (ix+HeroUnits+1),l              ;unit type second button pressed
  ld    (ix+HeroUnits+2),h              ;unit type second button pressed

  pop   ix
  pop   bc  
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine

  .EndCheck10bWithPopIXandBC:
  pop   ix
  pop   bc
  .EndCheck10b:

;11. Both creature slots clicked belong to different heroes. 
  ;Second slot clicked is empty, move all units if possible
  ;first check if castle has both a defending and a visiting hero present
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  jp    c,.EndCheck12b

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   ix
  pop   bc
  jp    c,.EndCheck12b
  ;/first check if castle has both a defending and a visiting hero present

  ;check if visiting hero has AT LEAST 2 creature slots filled
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck11                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to defending hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    c,.EndCheck11

  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck11
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;move all selected units from visiting hero to defending hero
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  ;/move all selected units from visiting hero to defending hero
  .EndCheck11:

;11b same as 11 but then for opposite hero
  ;check if defending hero has AT LEAST 2 creature slots filled
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck11b                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if defending hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to visiting hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    nc,.EndCheck11b

  ;check if 2nd slot clicked is an empty creature slot for visiting hero
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  pop   bc
  jp    nz,.EndCheck11b
  ;/check if 2nd slot clicked is an empty creature slot for visiting hero

  ;move all selected units from defending hero to visiting hero
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  ;/move all selected units from visiting hero to defending hero
  .EndCheck11b:

;12. Both creature slots clicked belong to different heroes. second slot clicked  has the same unit type, combine them is possible 

  ;check if visiting hero has AT LEAST 2 creature slots filled
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck12                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to defending hero
  ld    a,b                             ;last  button pressed belongs to defending hero?
  cp    8
  jp    c,.EndCheck12

  ;check if the unit type is the same for both buttons clicked
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    l,(ix+HeroUnits+0)              ;unit type visiting hero
  pop   ix
  pop   bc
  
  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    a,(ix+HeroUnits+0)              ;unit type defending hero
  cp    l
  pop   ix
  pop   bc
  jp    nz,.EndCheck12
  ;/check if the unit type is the same for both buttons clicked

  ;move and merge all selected units from visiting hero to defending hero 
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,06
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,13
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit amount second button pressed
  add   hl,de
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck12:
  
;12b. same as 12, but then for opposite heroes
  ;check if defending hero has AT LEAST 2 creature slots filled
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero  
  call  CheckHeroHasAtLeast2CreatureSlotsFilled
  pop   ix
  pop   bc
  jp    c,.EndCheck12b                 ;carry=hero does NOT have 2 or more creature slots filled
  ;/check if visiting hero has AT LEAST 2 creature slots filled

  ;at this point both buttons pressed always belong to different heros. Check first if last button pressed belongs to visiting hero
  ld    a,b                             ;last  button pressed belongs to visiting hero?
  cp    8
  jp    nc,.EndCheck12b

  ;check if the unit type is the same for both buttons clicked
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    l,(ix+HeroUnits+0)              ;unit type visiting hero
  pop   ix
  pop   bc
  
  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    a,(ix+HeroUnits+0)              ;unit type defending hero
  cp    l
  pop   ix
  pop   bc
  jp    nz,.EndCheck12b
  ;/check if the unit type is the same for both buttons clicked

  ;move and merge all selected units from defending hero to visiting hero 
  ld    a,(PreviousButtonClicked)
  ld    c,a
  ld    a,13
  sub   a,c
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    (ix+HeroUnits+0),0              ;unit type
  ld    (ix+HeroUnits+1),0              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed

  pop   ix
  pop   bc

  ld    a,06
  sub   a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  ix
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de

  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    e,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit amount second button pressed
  add   hl,de
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  pop   ix
  pop   bc
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck12b:

;13. both slots have different units, swap them


  ;check if both slots clicked belong to defending hero
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8                               ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  jp    c,.EndCheckbothSlotsClickedBelongToDefendingHero
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    nc,.Swap
  .EndCheckbothSlotsClickedBelongToDefendingHero:

  ;check if both slots clicked belong to visiting hero
  ld    a,b                             ;both buttons pressed belong to visiting hero?
  cp    8                               ;def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  jp    nc,.EndCheckbothSlotsClickedBelongToVisitingHero
  ld    a,(PreviousButtonClicked)
  cp    8
  jp    c,.Swap
  .EndCheckbothSlotsClickedBelongToVisitingHero:

  ;at this point both buttons pressed belong to different heros. Check if there is a defending AND a visiting hero
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no visiting/defending hero found / ix-> hero
  pop   de
  pop   bc
  jp    c,.ResetButtons                 ;carry=no defending/visiting hero found
  
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no visiting/defending hero found / ix-> hero
  pop   de
  pop   bc
  jp    c,.ResetButtons                 ;carry=no defending/visiting hero found






  .Swap:
  ld    a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    a,l
  or    h
  jp    z,.ResetButtons                 ;no need to swap if this slot has no units
  exx

  ld    a,(PreviousButtonClicked)       ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX

  ld    a,(ix+HeroUnits+0)              ;unit type
  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed

  ld    a,l
  or    h
  jp    z,.ResetButtons                 ;no need to swap if this slot has no units

  exx
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed

  ld    a,b                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  call  .SetHeroUnitsInIX
  ex    af,af'
  ld    (ix+HeroUnits+0),a              ;unit type
  exx
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  
  pop   af                              ;pop the call to this routine
  jp    ExitVisitingAndDefendingArmyRoutine
  ;/move and merge all selected units from visiting hero to defending hero IF THE UNIT TYPE IS THE SAME
  .EndCheck13:
  
  .HighlightNewButton:
  ld    a,b                             ;current button clicked now becomes previous button clicked (for future references)
  ld    (PreviousButtonClicked),a
  ld    (PreviousButtonClickedIX),ix
  ret

  .ResetButtons:
  ld    a,255                           ;reset previous button clicked  
  ld    (PreviousButtonClicked),a
  ret

.SetHeroUnitsInIX:
  cp    8
  jp    c,.VisitingHero

  .DefendingHero:
  ld    c,a
  ld    a,13
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de
  pop   bc
  add   ix,de  
  add   ix,de  
  add   ix,de  
  ret
  
  .VisitingHero:  
  ld    c,a
  ld    a,06
  sub   a,c                             ;b= def: 14 13 12 11 10 9 8  vis: 7 6 5 4 3 2 1  
  ld    d,0
  ld    e,a

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc
  push  de
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   de
  pop   bc
  add   ix,de  
  add   ix,de  
  add   ix,de  
  ret







.CheckTavernButtonClicked:              ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,002                           ;set recruiting hero as visiting
  ld    (EmptyHeroRecruitedAtTavern+HeroStatus),a
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc                              ;store which tavern button was pressed
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   bc                              ;recall which tavern button was pressed
  jr    c,.go                           ;unable to recruit hero if there is already a visiting hero here

  ld    a,254                           ;set recruiting hero as defending
  ld    (EmptyHeroRecruitedAtTavern+HeroStatus),a
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc                              ;store which tavern button was pressed
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   bc                              ;recall which tavern button was pressed
  ret   nc                              ;unable to recruit hero if there is already a defending hero here
  .go:

  ld    a,b
  cp    3
  jr    z,.TavernButton1Pressed
  cp    2
  jr    z,.TavernButton2Pressed
;  cp    1
;  jr    z,.TavernButton3Pressed

  .TavernButton3Pressed:
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    a,(ix+TavernHero3)              ;recruit hero 3
  pop   ix
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    (ix+TavernHero3),000            ;remove hero 3 from tavern
  pop   ix
  jp    .HeroRecruited

  .TavernButton2Pressed:
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    a,(ix+TavernHero2)              ;recruit hero 2
  pop   ix
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    (ix+TavernHero2),000            ;remove hero 2 from tavern
  pop   ix
  jp    .HeroRecruited

  .TavernButton1Pressed:
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    a,(ix+TavernHero1)              ;recruit hero 1
  pop   ix
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  push  ix
  call  SetTavernHeroesTablePlayerinIX
  ld    (ix+TavernHero1),000            ;remove hero 1 from tavern
  pop   ix
  jp    .HeroRecruited

  .HeroRecruited:
  call  SetResourcesPlayer
  call  SetVisitingAndDefendingHeroesAndArmy
  call  SetTavernHeroes
  call  SetTavernButtons
  ld    ix,GenericButtonTable2
  call  SetGenericButtons               ;copies button state from rom -> vram

  call  SwapAndSetPage                  ;swap and set page

  call  SetResourcesPlayer
  call  SetVisitingAndDefendingHeroesAndArmy
  call  SetTavernHeroes
  call  SetTavernButtons
  ld    ix,GenericButtonTable2
  call  SetGenericButtons               ;copies button state from rom -> vram
  pop   af                              ;pop the call to this routine
  jp    CastleOverviewTavernCode.engine

  .SetHeroStats:                        ;set status=2, set y, set x, herospecific address
  push  af                              ;a,(iy+TavernHeroxDayRemain)
  call  .CheckIsHeroAHeroThatHasFled?
  call  SetEmptyHeroSlotForCurrentPlayerInIX
  call  .ClearHeroSlot                  ;use empty template to fill free hero slot
  call  .SetYX                          ;place hero in the castle
  pop   af                              ;a,(iy+TavernHeroxDayRemain)

  ;set hero specific info
  ld    b,a                             ;hero number
  ld    hl,HeroAddressesAdol-heroAddressesLenght
  ld    de,heroAddressesLenght          ;search hero specific info address
  .loop2:
  add   hl,de
  djnz  .loop2
  ld    (ix+HeroSpecificInfo+0),l
  ld    (ix+HeroSpecificInfo+1),h
  
  ;set hero skill
  ld    de,HeroInfoSkill
  add   hl,de
  ld    a,(hl)
  ld    (ix+HeroSkills),a
  
  ;set hero primairy skills
  inc   hl                              ;hero number
  ld    a,(hl)
  dec   a
  ld    b,0
  ld    c,a
  ld    de,11
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ;there are 11 hero classes, we divide hero number by 11, the rest is then our class
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  ld    de,.HeroSkillPerClassTable
  add   hl,de
  ld    a,(hl)
  ld    (ix+HeroStatAttack),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatDefense),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatKnowledge),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatSpellDamage),a
  
  ;give the hero 1 level 1 unit, which is the same as the level 1 units in this castle (the amount is set in EmptyHeroRecruitedAtTavern:)
  ld    a,(iy+CastleLevel1Units)        ;castle x  
  ld    (ix+HeroUnits),a

  ;when a surrendered or retreated hero is purchased from tavern, reset it's stats
  call  SetManaAndMovementToMax         ;in: ix->hero
  ret
  
  .HeroSkillPerClassTable:
;       A D I S
  db    2,1,1,1                         ;knight (Archery)
  db    3,1,1,0                         ;barbarian (Offence)
  db    1,3,1,0                         ;shieldbearer(Armourer)
  db    1,2,1,1                         ;overlord (Resistance)
  
  db    1,2,1,1                         ;alchemist (Estates)
  db    1,1,2,1                         ;sage (Learning)
  db    2,1,1,1                         ;ranger (Logistics)
  
  db    0,0,3,2                         ;wizzard (Intelligence)
  db    1,0,1,3                         ;battle mage (Sorcery)
  db    0,1,2,2                         ;scholar (Wisdom)
  db    1,1,2,1                         ;necromancer (Necromancy)
  
  .Reduce2000Gold:
  call  SetResourcesCurrentPlayerinIX   ;subtract 2000 gold (cost of any hero)
  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;gold
  ld    de,2000
  xor   a
  sbc   hl,de
  ld    (ix+0),l
  ld    (ix+1),h                        ;gold   
  ret

  .ClearHeroSlot:
  ld    hl,EmptyHeroRecruitedAtTavern
  push  ix
  pop   de
  ld    bc,lenghtherotable-2            ;don't copy .HeroDYDX:  dw $ffff 
  ldir
  ret

  .SetYX:
  ld    a,(iy+CastleY)                  ;castle y
  dec   a
  ld    (ix+HeroY),a                    ;set hero y  
  ld    a,(iy+Castlex)                  ;castle x
  inc   a
  inc   a
  ld    (ix+HeroX),a                    ;set hero x
  ret




.CheckIsHeroAHeroThatHasFled?:
  ld    c,a                             ;Tavern Hero HeroNumber
  ld    b,amountofheroesperplayer
	ld		a,(whichplayernowplaying?)
  cp    1 | ld ix,pl1hero1y |	jr z,.GoFindHero
  cp    2 | ld ix,pl2hero1y |	jr z,.GoFindHero
  cp    3 | ld ix,pl3hero1y |	jr z,.GoFindHero
  cp    4 | ld ix,pl4hero1y |	jr z,.GoFindHero

  .GoFindHero:
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoNumber
  add   hl,de
  ld    a,(hl)                          ;hero number
  cp    c
  jr    z,.HeroFound
  ld    de,lenghtherotable
  add   ix,de
  djnz  .GoFindHero
  ret

  .HeroFound:
  ;if the hero retreated, give the hero 1 level 1 unit, which is the same as the level 1 units in this castle
  ;if the hero surrendered, we don't need to give the hero any units, since all units are saved at surrendering
  ld    a,(ix+HeroUnits)
  cp    UnitWhenRetreated
  jr    nz,.EndCheckRetreated
  ld    a,(iy+CastleLevel1Units)        ;castle x  
  ld    (ix+HeroUnits),a
  ld    (ix+HeroUnits+1),1
  .EndCheckRetreated:
  ;
  pop   af                              ;pop the call to this routine
  ;check which slot is empty (visiting or defending)
  ld    a,(EmptyHeroRecruitedAtTavern+HeroStatus)
  ld    (ix+heroStatus),a               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

  ;when a surrendered or retreated hero is purchased from tavern, reset it's stats
  call  SetManaAndMovementToMax         ;in: ix->hero

  call  .SetYX
  call  .FaceHeroLookingDown
  call  .Reduce2000Gold                 ;Hero cost = 2000 gold

  pop   af
  ret  

  .FaceHeroLookingDown:
  ;face hero looking down
  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix                              ;hero specific info table in ix

  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroinfoSYSX+0),a
  ret




CheckHeroHasAtLeast2CreatureSlotsFilled:
  ld    b,0                             ;amount of filled creature slots
  ld    a,(ix+HeroUnits+1)              ;unit amount first slot
  or    (ix+HeroUnits+2)                
  jr    z,.DefendingHeroCreatureSlot1Empty
  inc   b
  .DefendingHeroCreatureSlot1Empty:
  ld    a,(ix+HeroUnits+4)              ;unit amount 1st slot
  or    (ix+HeroUnits+5)                
  jr    z,.DefendingHeroCreatureSlot2Empty
  inc   b
  .DefendingHeroCreatureSlot2Empty:
  ld    a,(ix+HeroUnits+7)              ;unit amount 2nd slot
  or    (ix+HeroUnits+8)                
  jr    z,.DefendingHeroCreatureSlot3Empty
  inc   b
  .DefendingHeroCreatureSlot3Empty:
  ld    a,(ix+HeroUnits+10)              ;unit amount 3d slot
  or    (ix+HeroUnits+11)                
  jr    z,.DefendingHeroCreatureSlot4Empty
  inc   b
  .DefendingHeroCreatureSlot4Empty:
  ld    a,(ix+HeroUnits+13)              ;unit amount 4th slot
  or    (ix+HeroUnits+14)                
  jr    z,.DefendingHeroCreatureSlot5Empty
  inc   b
  .DefendingHeroCreatureSlot5Empty:
  ld    a,(ix+HeroUnits+16)              ;unit amount 5th slot
  or    (ix+HeroUnits+17)                
  jr    z,.DefendingHeroCreatureSlot6Empty
  inc   b
  .DefendingHeroCreatureSlot6Empty:
  ld    a,b
  cp    2
  ret

SetEmptyHeroSlotForCurrentPlayerInIX:
  ld    b,amountofheroesperplayer
	ld		a,(whichplayernowplaying?)
  cp    1 | ld ix,pl1hero1y |	jr z,.GoFindEmptySlotLoop
  cp    2 | ld ix,pl2hero1y |	jr z,.GoFindEmptySlotLoop
  cp    3 | ld ix,pl3hero1y |	jr z,.GoFindEmptySlotLoop
  cp    4 | ld ix,pl4hero1y |	jr z,.GoFindEmptySlotLoop

  .GoFindEmptySlotLoop:
  ld    a,(ix+HeroStatus)
  cp    255
  ret   z
  ld    de,lenghtherotable
  add   ix,de
  djnz  .GoFindEmptySlotLoop

  pop   af                              ;pop the call to this routine
  pop   af                              ;pop the push in the previous routine (.SetHeroStats:)
  pop   af                              ;pop the call to .TavernButtonxPressed:
  ret

SetTavernHeroes:
  call  SetTavernHeroesTablePlayerinIX
  call  SettavernHeroIcons
  call  SettavernHeroNames
  call  SettavernHeroClass
  call  SettavernHeroSkill
  call  EraseTavernHeroWindowWhenUnavailable
  ret

SetTavernHeroesTablePlayerinIX:
	ld		a,(whichplayernowplaying?)
  ld    ix,TavernHeroesPlayer1
  cp    1
  ret   z
  ld    ix,TavernHeroesPlayer2
  cp    2
  ret   z
  ld    ix,TavernHeroesPlayer3
  cp    3
  ret   z
  ld    ix,TavernHeroesPlayer4
;  cp    4
;  ret   z
  ret

EraseTavernHeroWindowWhenUnavailable:
  ld    a,(ix+TavernHero1)
  or    a
  ld    de,$0000 + (045*128) + (006/2) - 128
  call  z,.EraseWindow
  ld    a,(ix+TavernHero2)
  or    a
  ld    de,$0000 + (045*128) + (092/2) - 128
  call  z,.EraseWindow
  ld    a,(ix+TavernHero3)
  or    a
  ld    de,$0000 + (045*128) + (178/2) - 128
  call  z,.EraseWindow
  ret

  .EraseWindow:
  ld    hl,$4000 + (055*128) + (180/2) - 128
  ld    bc,$0000 + (070*256) + (072/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




















TextClass: db "Class:",255
SettavernHeroClass:
  ld    hl,TextClass
  ld    b,004+28                        ;dx
  ld    c,048+02                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    hl,TextClass
  ld    b,090+28                        ;dx
  ld    c,048+02                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    hl,TextClass
  ld    b,176+28                        ;dx
  ld    c,048+02                        ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(ix+TavernHero1)
  ld    b,004+28                        ;dx
  ld    c,058+00                        ;dy
  call  .SetHeroClass

  ld    a,(ix+TavernHero2)
  ld    b,090+28                        ;dx
  ld    c,058+00                        ;dy
  call  .SetHeroClass

  ld    a,(ix+TavernHero3)
  ld    b,176+28                        ;dx
  ld    c,058+00                        ;dy
  call  .SetHeroClass
  ret

  .SetHeroClass:
  or    a
  ret   z

  push  bc

  ld    b,a
  ld    hl,HeroAddressesAdol-heroAddressesLenght+HeroInfoClass
  ld    de,heroAddressesLenght
  .loop:
  add   hl,de
  djnz  .loop

  pop   bc
    
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret



SettavernHeroNames:
  ;erase all names
  ld    hl,$4000 + (034*128) + (004/2) - 128
  ld    de,$0000 + (034*128) + (004/2) - 128
  ld    bc,$0000 + (007*256) + (248/2)
  ld    a,TavernBlock                    ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    a,(ix+TavernHero1)
  ld    b,004+06+(17*2)                        ;dx
  ld    c,035+00                        ;dy
  call  .SetHeroName

  ld    a,(ix+TavernHero2)
  ld    b,090+06+(17*2)                        ;dx
  ld    c,035+00                        ;dy
  call  .SetHeroName

  ld    a,(ix+TavernHero3)
  ld    b,176+06+(17*2)                        ;dx
  ld    c,035+00                        ;dy
  call  .SetHeroName
  ret

  .SetHeroName:
  or    a
  ret   z

  push  bc

  ld    b,a
  ld    hl,HeroAddressesAdol-heroAddressesLenght
  ld    de,heroAddressesLenght
  .loop:
  add   hl,de
  djnz  .loop

  pop   bc

  call  CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret
  
SettavernHeroIcons:  
  ld    a,(ix+TavernHero1)
  ld    de,DYDX16x30HeroIconTavernWindow1
  call  .SetHeroIcon
  ld    a,(ix+TavernHero2)
  ld    de,DYDX16x30HeroIconTavernWindow2
  call  .SetHeroIcon
  ld    a,(ix+TavernHero3)
  ld    de,DYDX16x30HeroIconTavernWindow3
  call  .SetHeroIcon
  ret
  
  .SetHeroIcon:
  or    a
  ret   z

  push  ix                              ;tavern hero table
  push  de  
  ld    b,a
  ld    ix,HeroAddressesAdol-heroAddressesLenght
  ld    de,heroAddressesLenght
  .loop:
  add   ix,de
  djnz  .loop

  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)  ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc

  pop   de                              ;DYDX16x30HeroIconTavernWindow1,2,3
  pop   ix                              ;tavern hero table
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock        ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

DYDX16x30HeroIconTavernWindow1: equ $0000 + (047*128) + (008/2) - 128
DYDX16x30HeroIconTavernWindow2: equ $0000 + (047*128) + (094/2) - 128
DYDX16x30HeroIconTavernWindow3: equ $0000 + (047*128) + (180/2) - 128


SetVisitingAndDefendingHeroesAndArmy:
  call  SetVisitingHero
  call  SetDefendingHero
  call  SetVisitingHeroArmyAndAmount
  call  SetDefendingHeroArmyAndAmount
  ret

SetDefendingHeroArmyAndAmount:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ret   c

  call  .army
;  call  .amount
;  ret

  .amount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,029
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,045
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,061
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,077
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,093
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,109
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

  .army:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit1       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit2       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit3       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit4       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit5       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXDefendingHeroUnit6       ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable14x14Portraits
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
UnitSYSXTable14x14Portraits:  
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

DYDXDefendingHeroUnit1:          equ 256*181 + 028      ;(dy*256 + dx)
DYDXDefendingHeroUnit2:          equ 256*181 + 044      ;(dy*256 + dx)
DYDXDefendingHeroUnit3:          equ 256*181 + 060      ;(dy*256 + dx)
DYDXDefendingHeroUnit4:          equ 256*181 + 076      ;(dy*256 + dx)
DYDXDefendingHeroUnit5:          equ 256*181 + 092      ;(dy*256 + dx)
DYDXDefendingHeroUnit6:          equ 256*181 + 108      ;(dy*256 + dx)

SetVisitingHeroArmyAndAmount:
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ret   c

  call  .army
;  call  .amount
;  ret

  .amount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,157
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,173
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,189
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,205
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,221
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,237
  ld    c,197
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

  .army:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit1        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit2        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit3        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit4        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit5        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  SetDefendingHeroArmyAndAmount.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXVisitingHeroUnit6        ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImage            ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

DYDXVisitingHeroUnit1:          equ 256*181 + 156      ;(dy*256 + dx)
DYDXVisitingHeroUnit2:          equ 256*181 + 172      ;(dy*256 + dx)
DYDXVisitingHeroUnit3:          equ 256*181 + 188      ;(dy*256 + dx)
DYDXVisitingHeroUnit4:          equ 256*181 + 204      ;(dy*256 + dx)
DYDXVisitingHeroUnit5:          equ 256*181 + 220      ;(dy*256 + dx)
DYDXVisitingHeroUnit6:          equ 256*181 + 236      ;(dy*256 + dx)

SetVisitingOrDefendingHeroInIX:         ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
	ld		a,(whichplayernowplaying?)
  cp    1 | ld ix,pl1hero1y |	jr z,.CheckHeroVisitingOrDefendingCastle
  cp    2 | ld ix,pl2hero1y |	jr z,.CheckHeroVisitingOrDefendingCastle
  cp    3 | ld ix,pl3hero1y |	jr z,.CheckHeroVisitingOrDefendingCastle
  cp    4 | ld ix,pl4hero1y |	jr z,.CheckHeroVisitingOrDefendingCastle	

	.CheckHeroVisitingOrDefendingCastle:
  ld    b,amountofheroesperplayer
  .loop:
  call  .DoCheckHero                    ;check if this hero is visiting or defending castle
	ld		de,lenghtherotable
  add   ix,de                           ;next hero
  djnz  .loop
  add   ix,de                           ;next hero (in this case its out of the hero table, which registers as NO hero)
  scf                                   ;carry=no visiting/defending hero found
  ret

  .DoCheckHero:
  ld    a,(iy+CastleY)                  ;check if hero enters castle
  dec   a
  cp    (ix+Heroy)
  ret   nz
  ld    a,(iy+CastleX)
  inc   a
  inc   a
  cp    (ix+Herox)
  ret   nz
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    c                               ;is this hero defending (254) or visiting (002) the castle ?
  ret   nz

  pop   bc                              ;defending hero found, no need to check other heroes
  ret

SetDefendingHero:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero

  ld    de,$0000 + (176*128) + (004/2) - 128
  jp    c,SetNoHeroVisitingOrDefendingCastle
  ld    de,DYDX16x30HeroIconAtDefendingHeroWindow
  jp    DoSetVisitingOrDefendingHero
  
SetVisitingHero:  
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero

  ld    de,$0000 + (176*128) + (132/2) - 128
  jp    c,SetNoHeroVisitingOrDefendingCastle
  ld    de,DYDX16x30HeroIconAtVisitingHeroWindow
  jp    DoSetVisitingOrDefendingHero

SetNoHeroVisitingOrDefendingCastle:
  ld    hl,$4000 + (013*128) + (230/2) - 128
  ld    bc,$0000 + (028*256) + (020/2)
  ld    a,ButtonsRecruitBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

DoSetVisitingOrDefendingHero:
  ;defending hero found. ix->defending hero
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix

  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)  ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc

  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock        ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

DYDX16x30HeroIconAtVisitingHeroWindow: equ $0000 + (176*128) + (134/2) - 128
DYDX16x30HeroIconAtDefendingHeroWindow: equ $0000 + (176*128) + (006/2) - 128

SetDefendingAndVisitingHeroButtons:
  ld    hl,DefendingAndVisitingHeroButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*14)
  ldir
  ret

DefendingAndVisitingHeroButtonTableGfxBlock:  db  ButtonsRecruitBlock
DefendingAndVisitingHeroButtonTableAmountOfButtons:  db  14
DefendingAndVisitingHeroButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  db  %1100 0011 | dw $4000 + (072*128) + (162/2) - 128 | dw $4000 + (072*128) + (182/2) - 128 | dw $4000 + (072*128) + (202/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button4Ytop,.Button4YBottom,.Button4XLeft,.Button4XRight | dw $0000 + (.Button4Ytop*128) + (.Button4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button5Ytop,.Button5YBottom,.Button5XLeft,.Button5XRight | dw $0000 + (.Button5Ytop*128) + (.Button5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button6Ytop,.Button6YBottom,.Button6XLeft,.Button6XRight | dw $0000 + (.Button6Ytop*128) + (.Button6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button7Ytop,.Button7YBottom,.Button7XLeft,.Button7XRight | dw $0000 + (.Button7Ytop*128) + (.Button7XLeft/2) - 128

  db  %1100 0011 | dw $4000 + (072*128) + (162/2) - 128 | dw $4000 + (072*128) + (182/2) - 128 | dw $4000 + (072*128) + (202/2) - 128 | db .Button8Ytop,.Button8YBottom,.Button8XLeft,.Button8XRight | dw $0000 + (.Button8Ytop*128) + (.Button8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button9Ytop,.Button9YBottom,.Button9XLeft,.Button9XRight | dw $0000 + (.Button9Ytop*128) + (.Button9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button10Ytop,.Button10YBottom,.Button10XLeft,.Button10XRight | dw $0000 + (.Button10Ytop*128) + (.Button10XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button11Ytop,.Button11YBottom,.Button11XLeft,.Button11XRight | dw $0000 + (.Button11Ytop*128) + (.Button11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button12Ytop,.Button12YBottom,.Button12XLeft,.Button12XRight | dw $0000 + (.Button12Ytop*128) + (.Button12XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button13Ytop,.Button13YBottom,.Button13XLeft,.Button13XRight | dw $0000 + (.Button13Ytop*128) + (.Button13XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (106*128) + (162/2) - 128 | dw $4000 + (106*128) + (178/2) - 128 | dw $4000 + (106*128) + (194/2) - 128 | db .Button14Ytop,.Button14YBottom,.Button14XLeft,.Button14XRight | dw $0000 + (.Button14Ytop*128) + (.Button14XLeft/2) - 128

.Button1Ytop:           equ 174
.Button1YBottom:        equ .Button1Ytop + 034
.Button1XLeft:          equ 004
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 176
.Button2YBottom:        equ .Button2Ytop + 030
.Button2XLeft:          equ 027
.Button2XRight:         equ .Button2XLeft + 016

.Button3Ytop:           equ 176
.Button3YBottom:        equ .Button3Ytop + 030
.Button3XLeft:          equ 043
.Button3XRight:         equ .Button3XLeft + 016

.Button4Ytop:           equ 176
.Button4YBottom:        equ .Button4Ytop + 030
.Button4XLeft:          equ 059
.Button4XRight:         equ .Button4XLeft + 016

.Button5Ytop:           equ 176
.Button5YBottom:        equ .Button5Ytop + 030
.Button5XLeft:          equ 075
.Button5XRight:         equ .Button5XLeft + 016

.Button6Ytop:           equ 176
.Button6YBottom:        equ .Button6Ytop + 030
.Button6XLeft:          equ 091
.Button6XRight:         equ .Button6XLeft + 016

.Button7Ytop:           equ 176
.Button7YBottom:        equ .Button7Ytop + 030
.Button7XLeft:          equ 107
.Button7XRight:         equ .Button7XLeft + 016



.Button8Ytop:           equ 174
.Button8YBottom:        equ .Button8Ytop + 034
.Button8XLeft:          equ 004 + 128
.Button8XRight:         equ .Button8XLeft + 020

.Button9Ytop:           equ 176
.Button9YBottom:        equ .Button9Ytop + 030
.Button9XLeft:          equ 027 + 128
.Button9XRight:         equ .Button9XLeft + 016

.Button10Ytop:           equ 176
.Button10YBottom:        equ .Button10Ytop + 030
.Button10XLeft:          equ 043 + 128
.Button10XRight:         equ .Button10XLeft + 016

.Button11Ytop:           equ 176
.Button11YBottom:        equ .Button11Ytop + 030
.Button11XLeft:          equ 059 + 128
.Button11XRight:         equ .Button11XLeft + 016

.Button12Ytop:           equ 176
.Button12YBottom:        equ .Button12Ytop + 030
.Button12XLeft:          equ 075 + 128
.Button12XRight:         equ .Button12XLeft + 016

.Button13Ytop:           equ 176
.Button13YBottom:        equ .Button13Ytop + 030
.Button13XLeft:          equ 091 + 128
.Button13XRight:         equ .Button13XLeft + 016

.Button14Ytop:           equ 176
.Button14YBottom:        equ .Button14Ytop + 030
.Button14XLeft:          equ 107 + 128
.Button14XRight:         equ .Button14XLeft + 016
















SetTavernButtons:
  ld    hl,TavernButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*3)
  ldir

  call  .SetRedButtonsIfPlayerHasInsufficientFunds
  call  .SetBrownButtonIfHeroIsAlreadyRecruited
  ret

  .SetBrownButtonIfHeroIsAlreadyRecruited:
  call  SetTavernHeroesTablePlayerinIX
  ld    a,(ix+TavernHero1)              
  or    a
  ld    de,GenericButtonTable2+1+(GenericButtonTableLenghtPerButton*0)
  call  z,.AlreadyRecruitedSetBrown

  ld    a,(ix+TavernHero2)              
  or    a
  ld    de,GenericButtonTable2+1+(GenericButtonTableLenghtPerButton*1)
  call  z,.AlreadyRecruitedSetBrown

  ld    a,(ix+TavernHero3)              
  or    a
  ld    de,GenericButtonTable2+1+(GenericButtonTableLenghtPerButton*2)
  call  z,.AlreadyRecruitedSetBrown
  ret

  .AlreadyRecruitedSetBrown:
  ld    hl,.BrownButton
  ld    bc,6
  ldir
  ret

  .BrownButton:
  dw $4000 + (038*128) + (076/2) - 128 | dw $4000 + (038*128) + (076/2) - 128 | dw $4000 + (038*128) + (076/2) - 128
  
  .SetRedButtonsIfPlayerHasInsufficientFunds:
  call  SetResourcesCurrentPlayerinIX

  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;gold
  ld    de,2000
  xor   a
  sbc   hl,de
  ret   nc
  
  ld    hl,TavernButtonTableWhenNotEnoughCash
  ld    de,GenericButtonTable2
  ld    bc,GenericButtonTableLenghtPerButton*3
  ldir
  ret







TavernButton1Ytop:           equ 118
TavernButton1YBottom:        equ TavernButton1Ytop + 009
TavernButton1XLeft:          equ 004
TavernButton1XRight:         equ TavernButton1XLeft + 076

TavernButton2Ytop:           equ 118
TavernButton2YBottom:        equ TavernButton2Ytop + 009
TavernButton2XLeft:          equ 090
TavernButton2XRight:         equ TavernButton2XLeft + 076

TavernButton3Ytop:           equ 118
TavernButton3YBottom:        equ TavernButton3Ytop + 009
TavernButton3XLeft:          equ 176
TavernButton3XRight:         equ TavernButton3XLeft + 076

TavernButtonTableLenghtPerButton:  equ TavernButtonTable.endlenght-TavernButtonTable
TavernButtonTableGfxBlock:  db  ButtonsRecruitBlock
TavernButtonTableAmountOfButtons:  db  3
TavernButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db TavernButton1Ytop,TavernButton1YBottom,TavernButton1XLeft,TavernButton1XRight | dw $0000 + (TavernButton1Ytop*128) + (TavernButton1XLeft/2) - 128 
  .endlenght:
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db TavernButton2Ytop,TavernButton2YBottom,TavernButton2XLeft,TavernButton2XRight | dw $0000 + (TavernButton2Ytop*128) + (TavernButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db TavernButton3Ytop,TavernButton3YBottom,TavernButton3XLeft,TavernButton3XRight | dw $0000 + (TavernButton3Ytop*128) + (TavernButton3XLeft/2) - 128

TavernButtonTableWhenNotEnoughCash: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | db TavernButton1Ytop,TavernButton1YBottom,TavernButton1XLeft,TavernButton1XRight | dw $0000 + (TavernButton1Ytop*128) + (TavernButton1XLeft/2) - 128 
  .endlenght:
  db  %1100 0011 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | db TavernButton2Ytop,TavernButton2YBottom,TavernButton2XLeft,TavernButton2XRight | dw $0000 + (TavernButton2Ytop*128) + (TavernButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | dw $4000 + (063*128) + (162/2) - 128 | db TavernButton3Ytop,TavernButton3YBottom,TavernButton3XLeft,TavernButton3XRight | dw $0000 + (TavernButton3Ytop*128) + (TavernButton3XLeft/2) - 128







FirstLineintHeightCastleMarket: equ 074
SecondLineintHeightCastleMarket: equ 117
ThirdLineintHeightCastleMarket: equ 159
SetCastleMarketInterruptHandler:
  di
  ld    hl,CastleInterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
 
  ld    a,(VDP_0)           ;set ei1
  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  out   ($99),a

  ld    a,FirstLineintHeightCastleMarket
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

SetCastleMarketInterruptSecondLine:
  ld    a,SecondLineintHeightCastleMarket
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

SetCastleMarketInterruptThirdLine:
  ld    a,ThirdLineintHeightCastleMarket
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

CastleOverviewMarketPlaceCode:
  call  SetScreenOff

  call  SetMarketPlaceButtons

  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  ld    (PreviousButton2Clicked),a
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix
  ld    (PreviousButton2ClickedIX),ix

  ld    hl,InGamePalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  call  SetMarketPlaceGraphics          ;put gfx in page 1
  call  SetResourcesPlayer

  ld    hl,CopyPage1To0
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetCastleMarketInterruptHandler
	
  .engine:
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,CastleOverviewCode

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;market place buttons
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number



  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton                ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton:
  ;we mark previous button clicked

  ;we mark previous button 2 clicked
  ld    ix,(PreviousButton2ClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButton2Clicked)
  cp    255
  jr    z,.EndMarkButton2               ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton2:
  ;we mark previous button 2 clicked





  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram


  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButton2ClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state




  ;/market place buttons

;  halt
  call  SetScreenOn
  jp  .engine

.CheckButtonClicked:                    ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b                             ;only set the i can offer you window if you clicked on buttons in the 2nd or 3d window
  cp    9                               ;check if a button in the 1st window is clicked
  jp    nc,.WhichResourceDoYouNeedClicked
  cp    4                               ;check if a button in the 2nd window is clicked
  jp    nc,.WhichResourceWillYouTradeClicked
  cp    3
  jp    z,.PlusButtonPressed
  cp    2
  jp    z,.BuyButtonPressed
  cp    1
  jp    z,.MinusButtonPressed
  ret
  
  .BuyButtonPressed:
  ;Check if we overflow the amount we gain
  call  SetResourcesCurrentPlayerinIX
  ld    a,(MarketPlaceResourceNeeded)
  cp    09                              ;gold
  jr    z,.IXPointsToResourceNeededCheckOverflow
  inc   ix
  inc   ix
  cp    13                              ;wood
  jr    z,.IXPointsToResourceNeededCheckOverflow
  inc   ix
  inc   ix
  cp    12                              ;stone
  jr    z,.IXPointsToResourceNeededCheckOverflow
  inc   ix
  inc   ix
  cp    11                              ;gems
  jr    z,.IXPointsToResourceNeededCheckOverflow
  inc   ix
  inc   ix
  cp    10                              ;rubies
  jr    z,.IXPointsToResourceNeededCheckOverflow

  .IXPointsToResourceNeededCheckOverflow:
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;resource needed
  ld    de,(AmountOfResourcesOffered)
  add   hl,de                           ;amount of resources offered
  ret   c
  ;/Check if we overflow the amount we gain

  ;reduce the amount of resources we have to invest
  call  SetResourcesCurrentPlayerinIX
  ld    a,(MarketPlaceResourceToTrade)  
  cp    04                              ;gold
  jr    z,.IXPointsToResourceRequired
  inc   ix
  inc   ix
  cp    08                              ;wood
  jr    z,.IXPointsToResourceRequired
  inc   ix
  inc   ix
  cp    07                              ;stone
  jr    z,.IXPointsToResourceRequired
  inc   ix
  inc   ix
  cp    06                              ;gems
  jr    z,.IXPointsToResourceRequired
  inc   ix
  inc   ix
  cp    05                              ;rubies
  jr    z,.IXPointsToResourceRequired

  .IXPointsToResourceRequired:
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;resource required
  ld    de,(AmountOfResourcesRequired)
  xor   a
  sbc   hl,de                           ;amount of resources required
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h                        ;resource required
  ;/reduce the amount of resources we have to invest

  ;increase the amount of resources we gain/buy
  call  SetResourcesCurrentPlayerinIX
  ld    a,(MarketPlaceResourceNeeded)
  cp    09                              ;gold
  jr    z,.IXPointsToResourceNeeded
  inc   ix
  inc   ix
  cp    13                              ;wood
  jr    z,.IXPointsToResourceNeeded
  inc   ix
  inc   ix
  cp    12                              ;stone
  jr    z,.IXPointsToResourceNeeded
  inc   ix
  inc   ix
  cp    11                              ;gems
  jr    z,.IXPointsToResourceNeeded
  inc   ix
  inc   ix
  cp    10                              ;rubies
  jr    z,.IXPointsToResourceNeeded

  .IXPointsToResourceNeeded:
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;resource needed
  ld    de,(AmountOfResourcesOffered)
  add   hl,de                           ;amount of resources offered
  ld    (ix+0),l
  ld    (ix+1),h                        ;resource needed
  ;/increase the amount of resources we gain/buy

  call  SetResourcesPlayer
  call  SwapAndSetPage                  ;swap and set page  
  call  SetResourcesPlayer
  ret
  
  .WoodNeeded:
  inc   ix
  inc   ix                              ;wood
  ret
  
  .MinusButtonPressed:
  call  .SetTradeCostInHL  
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;amount of resources offered
  inc   hl
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;amount of resources required

  ;add the amounts offered and cost/requirement
  ld    hl,(AmountOfResourcesOffered)
  xor   a
  sbc   hl,de
  ret   z
  ld    (AmountOfResourcesOffered),hl
  ld    hl,(AmountOfResourcesRequired)
  xor   a
  sbc   hl,bc
  ld    (AmountOfResourcesRequired),hl

  call  .ClearAmountsOfferedAndRequired
  call  .SetTotalAmountOfferedVSRequired
  call  SwapAndSetPage                  ;swap and set page
  call  .ClearAmountsOfferedAndRequired
  call  .SetTotalAmountOfferedVSRequired
  ret
  
  .PlusButtonPressed:
  call  .SetTradeCostInHL  
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;amount of resources offered
  inc   hl
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;amount of resources required

  ;add the amounts offered and cost/requirement
  ld    hl,(AmountOfResourcesRequired)
  add   hl,bc
  ret   c

  ld    hl,(AmountOfResourcesOffered)
  add   hl,de
  ret   c
  ld    (AmountOfResourcesOffered),hl
  ld    hl,(AmountOfResourcesRequired)
  add   hl,bc
  ld    (AmountOfResourcesRequired),hl

  call  .ClearAmountsOfferedAndRequired
  call  .SetTotalAmountOfferedVSRequired
  call  SwapAndSetPage                  ;swap and set page
  call  .ClearAmountsOfferedAndRequired
  call  .SetTotalAmountOfferedVSRequired
  ret

  .ClearAmountsOfferedAndRequired:
  ld    hl,$4000 + (131*128) + (052/2) - 128
  ld    de,$0000 + (147*128) + (054/2) - 128
  ld    bc,$0000 + (006*256) + (036/2)
  ld    a,ChamberOfCommerceButtonsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (131*128) + (052/2) - 128
  ld    de,$0000 + (147*128) + (170/2) - 128
  ld    bc,$0000 + (006*256) + (036/2)
  ld    a,ChamberOfCommerceButtonsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY 
  ret
  
  .WhichResourceWillYouTradeClicked:
  ld    (PreviousButton2Clicked),a       ;current button clicked now becomes previous button clicked (for future references)
  ld    (PreviousButton2ClickedIX),ix  
  
  ld    (MarketPlaceResourceToTrade),a

  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0

  ld    a,%1100 0011                    ;enable which resource will you trade buttons
  ld    (GenericButtonTable+10*GenericButtonTableLenghtPerButton),a ;+
  ld    (GenericButtonTable+11*GenericButtonTableLenghtPerButton),a ;buy
  ld    (GenericButtonTable+12*GenericButtonTableLenghtPerButton),a ;-
  
  .EntryPointWhenClickedOnWhichResourceDoYouNeed:
  call  .SetIcanOfferYouWindow
  call  .SetIconResourceNeeded
  call  .SetIconResourceToTrade
  call  .SetTextResourceNeeded
  call  .SetTextResourceToTrade
  call  .SetCost
  call  .SetTotalAmountOfferedVSRequired
  call  SwapAndSetPage                  ;swap and set page
  call  .SetIcanOfferYouWindow
  call  .SetIconResourceNeeded
  call  .SetIconResourceToTrade
  call  .SetTextResourceNeeded
  call  .SetTextResourceToTrade
  call  .SetCost
  call  .SetTotalAmountOfferedVSRequired
  ret

  .SetTotalAmountOfferedVSRequired:
  ld    b,054                           ;dx
  ld    c,147                           ;dy
  ld    hl,(AmountOfResourcesOffered)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    b,181                           ;dx
  ld    c,147                           ;dy
  ld    hl,(AmountOfResourcesRequired)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ret

  .SetCost:
  call  .SetTradeCostInHL
    
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  ld    (AmountOfResourcesOffered),de
  inc   hl
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  ld    (AmountOfResourcesRequired),de

  ld    b,069+005                       ;dx
  ld    c,128                           ;dy
  ld    hl,(AmountOfResourcesOffered)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    b,167                           ;dx
  ld    c,128                           ;dy
  ld    hl,(AmountOfResourcesRequired)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ret

;1 market place:
.TextCostRequireWoodTradeStone:  dw 0001,0010
.TextCostRequireWoodTradeGems:   dw 0001,0005
.TextCostRequireWoodTradeGold:   dw 0001,2500
.TextCostRequireGemTradeStone:   dw 0001,0020
.TextCostRequireGemTradeGems:    dw 0001,0010
.TextCostRequireGemTradeGold:    dw 0001,5000
.TextCostRequireGoldTradeWood:   dw 0025,0001
.TextCostRequireGoldTradeRuby:   dw 0050,0001
.TextCostRequireGoldTradeGold:   dw 0001,0001
;2 market places:
.TextCostRequireWoodTradeStone2: dw 0001,0007
.TextCostRequireWoodTradeGems2:  dw 0001,0003
.TextCostRequireWoodTradeGold2:  dw 0001,1667
.TextCostRequireGemTradeStone2:  dw 0001,0013
.TextCostRequireGemTradeGems2:   dw 0001,0007
.TextCostRequireGemTradeGold2:   dw 0001,3333
.TextCostRequireGoldTradeWood2:  dw 0037,0001
.TextCostRequireGoldTradeRuby2:  dw 0075,0001
.TextCostRequireGoldTradeGold2:  dw 0001,0001
;3 market places:
.TextCostRequireWoodTradeStone3: dw 0001,0005
.TextCostRequireWoodTradeGems3:  dw 0001,0002
.TextCostRequireWoodTradeGold3:  dw 0001,1250
.TextCostRequireGemTradeStone3:  dw 0001,0010
.TextCostRequireGemTradeGems3:   dw 0001,0005
.TextCostRequireGemTradeGold3:   dw 0001,2500
.TextCostRequireGoldTradeWood3:  dw 0050,0001
.TextCostRequireGoldTradeRuby3:  dw 0100,0001
.TextCostRequireGoldTradeGold3:  dw 0001,0001


  .SetTradeCostInHL:
  call  .DoSetTradeCost
  call  .SetAmountOfMarketPlacesInB  
  ld    a,b
  or    a
  ret   z
  cp    3
  jr    c,.loop
  ld    b,2                               ;maximum of 2 discount tables (increase this if we want 1 more table)
  .loop:
  ld    de,36
  add   hl,de
  djnz  .loop
  ret
  
  .SetAmountOfMarketPlacesInB:
  ld		a,(whichplayernowplaying?)
  ld    b,-1                              ;amount of market places
  ld    ix,Castle1 | cp (ix+CastlePlayer) | call z,.check
  ld    ix,Castle2 | cp (ix+CastlePlayer) | call z,.check
  ld    ix,Castle3 | cp (ix+CastlePlayer) | call z,.check
  ld    ix,Castle4 | cp (ix+CastlePlayer) | call z,.check
  ret

  .check:
  bit   0,(ix+CastleMarket)
  ret   z
  inc   b
  ret

  
  .DoSetTradeCost:
  ld    a,(MarketPlaceResourceNeeded)
  cp    12                              ;13=wood, 12=stone
  jp    nc,.RequireWoodOrStone
  cp    10                              ;11=gems, 10=rubies
  jp    nc,.RequireGemsOrRubies

  .RequireGold:
  ld    a,(MarketPlaceResourceToTrade)  
  cp    07                              ;08=wood, 07=stone
  ld    hl,.TextCostRequireGoldTradeWood
  ret   nc
  cp    05                              ;06=gems, 05=rubies
  ld    hl,.TextCostRequireGoldTradeRuby
  ret   nc
  ld    hl,.TextCostRequireGoldTradeGold
  ret 
  
  .RequireGemsOrRubies:
  ld    a,(MarketPlaceResourceToTrade)  
  cp    07                              ;08=wood, 07=stone
  ld    hl,.TextCostRequireGemTradeStone
  ret   nc
  cp    05                              ;06=gems, 05=rubies
  ld    hl,.TextCostRequireGemTradeGems
  ret   nc
  ld    hl,.TextCostRequireGemTradeGold
  ret
  
  .RequireWoodOrStone:
  ld    a,(MarketPlaceResourceToTrade)  
  cp    07                              ;08=wood, 07=stone
  ld    hl,.TextCostRequireWoodTradeStone
  ret   nc
  cp    05                              ;06=gems, 05=rubies
  ld    hl,.TextCostRequireWoodTradeGems
  ret   nc
  ld    hl,.TextCostRequireWoodTradeGold
  ret

  .SetTextResourceNeeded:
  ld    a,(MarketPlaceResourceNeeded)
  call  .SetTextResourceInHL
  ld    b,127
  ld    c,128
  jp    SetText

  .SetTextResourceToTrade:
  ld    a,(MarketPlaceResourceToTrade)
  call  .SetTextResourceInHL
  ld    b,227
  ld    c,128
  jp    SetText

  .SetTextResourceInHL:
  ld    hl,.TextWood
  cp    13
  ret   z
  cp    8
  ret   z

  ld    hl,.TextStone
  cp    12
  ret   z
  cp    7
  ret   z

  ld    hl,.TextGems
  cp    11
  ret   z
  cp    6
  ret   z

  ld    hl,.TextRubies
  cp    10
  ret   z
  cp    5
  ret   z

  ld    hl,.TextGold
;  cp    9
;  ret   z  
;  cp    4
;  ret   z  
  ret

.TextWood:    db  "wood",255
.TextStone:   db  "stone",255
.TextGems:    db  "gems",255
.TextRubies:  db  "rubies",255
.TextGold:    db  "gold",255

  
  .SetIcanOfferYouWindow:
  ld    hl,$4000 + (109*128) + (000/2) - 128
  ld    de,$0000 + (123*128) + (000/2) - 128
  ld    bc,$0000 + (043*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  jp    SetCastleMarketInterruptThirdLine

  .SetIconResourceNeeded:
  ld    a,(MarketPlaceResourceNeeded)
  call  .SetResourceInHL  
;  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (138*128) + (024/2) - 128
  ld    bc,$0000 + (022*256) + (028/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetIconResourceToTrade:
  ld    a,(MarketPlaceResourceToTrade)
  call  .SetResourceInHL
;  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (138*128) + (206/2) - 128
  ld    bc,$0000 + (022*256) + (028/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetResourceInHL:
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;wood
  cp    13
  ret   z
  cp    8
  ret   z

  ld    hl,$4000 + (000*128) + (028/2) - 128  ;stone
  cp    12
  ret   z
  cp    7
  ret   z

  ld    hl,$4000 + (000*128) + (056/2) - 128  ;gem
  cp    11
  ret   z
  cp    6
  ret   z

  ld    hl,$4000 + (000*128) + (084/2) - 128  ;ruby
  cp    10
  ret   z
  cp    5
  ret   z

  ld    hl,$4000 + (000*128) + (112/2) - 128  ;gold
;  cp    9
;  ret   z  
;  cp    4
;  ret   z  
  ret

    
  .WhichResourceDoYouNeedClicked:
  ld    (PreviousButtonClicked),a       ;current button clicked now becomes previous button clicked (for future references)
  ld    (PreviousButtonClickedIX),ix
  
  ld    (MarketPlaceResourceNeeded),a

  ld    a,(GenericButtonTable+10*GenericButtonTableLenghtPerButton) ;+
  bit   7,a                             ;if the +, buy and - button are visible then set resource in bottom window
  jp    nz,.EntryPointWhenClickedOnWhichResourceDoYouNeed
  
  ld    a,(GenericButtonTable+5*GenericButtonTableLenghtPerButton) ;check if this window is already active
  bit   7,a
  ret   nz
  
  ld    a,%1100 0011                    ;enable which resource will you trade buttons
  ld    (GenericButtonTable+5*GenericButtonTableLenghtPerButton),a ;wood
  ld    (GenericButtonTable+6*GenericButtonTableLenghtPerButton),a ;ore
  ld    (GenericButtonTable+7*GenericButtonTableLenghtPerButton),a ;gems
  ld    (GenericButtonTable+8*GenericButtonTableLenghtPerButton),a ;rubies
  ld    (GenericButtonTable+9*GenericButtonTableLenghtPerButton),a ;gold
  
  call  .SetWhichResourceWillYouTradeWindow
  call  SwapAndSetPage                  ;swap and set page
  .SetWhichResourceWillYouTradeWindow:
  ld    hl,$4000 + (066*128) + (000/2) - 128
  ld    de,$0000 + (080*128) + (000/2) - 128
  ld    bc,$0000 + (043*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  jp    SetCastleMarketInterruptSecondLine
  
SetMarketPlaceButtons:
  ld    hl,MarketPlaceButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*13)
  ldir
  ret

MarketPlaceButton1Ytop:           equ 052
MarketPlaceButton1YBottom:        equ MarketPlaceButton1Ytop + 022
MarketPlaceButton1XLeft:          equ 030
MarketPlaceButton1XRight:         equ MarketPlaceButton1XLeft + 028

MarketPlaceButton2Ytop:           equ 052
MarketPlaceButton2YBottom:        equ MarketPlaceButton2Ytop + 022
MarketPlaceButton2XLeft:          equ 072
MarketPlaceButton2XRight:         equ MarketPlaceButton2XLeft + 028

MarketPlaceButton3Ytop:           equ 052
MarketPlaceButton3YBottom:        equ MarketPlaceButton3Ytop + 022
MarketPlaceButton3XLeft:          equ 114
MarketPlaceButton3XRight:         equ MarketPlaceButton3XLeft + 028

MarketPlaceButton4Ytop:           equ 052
MarketPlaceButton4YBottom:        equ MarketPlaceButton4Ytop + 022
MarketPlaceButton4XLeft:          equ 156
MarketPlaceButton4XRight:         equ MarketPlaceButton4XLeft + 028

MarketPlaceButton5Ytop:           equ 052
MarketPlaceButton5YBottom:        equ MarketPlaceButton5Ytop + 022
MarketPlaceButton5XLeft:          equ 198
MarketPlaceButton5XRight:         equ MarketPlaceButton5XLeft + 028

MarketPlaceButton6Ytop:           equ 095
MarketPlaceButton6YBottom:        equ MarketPlaceButton6Ytop + 022
MarketPlaceButton6XLeft:          equ 030
MarketPlaceButton6XRight:         equ MarketPlaceButton6XLeft + 028

MarketPlaceButton7Ytop:           equ 095
MarketPlaceButton7YBottom:        equ MarketPlaceButton7Ytop + 022
MarketPlaceButton7XLeft:          equ 072
MarketPlaceButton7XRight:         equ MarketPlaceButton7XLeft + 028

MarketPlaceButton8Ytop:           equ 095
MarketPlaceButton8YBottom:        equ MarketPlaceButton8Ytop + 022
MarketPlaceButton8XLeft:          equ 114
MarketPlaceButton8XRight:         equ MarketPlaceButton8XLeft + 028

MarketPlaceButton9Ytop:           equ 095
MarketPlaceButton9YBottom:        equ MarketPlaceButton9Ytop + 022
MarketPlaceButton9XLeft:          equ 156
MarketPlaceButton9XRight:         equ MarketPlaceButton9XLeft + 028

MarketPlaceButton10Ytop:           equ 095
MarketPlaceButton10YBottom:        equ MarketPlaceButton10Ytop + 022
MarketPlaceButton10XLeft:          equ 198
MarketPlaceButton10XRight:         equ MarketPlaceButton10XLeft + 028



MarketPlaceButton11Ytop:           equ 143
MarketPlaceButton11YBottom:        equ MarketPlaceButton11Ytop + 014
MarketPlaceButton11XLeft:          equ 092
MarketPlaceButton11XRight:         equ MarketPlaceButton11XLeft + 014

MarketPlaceButton12Ytop:           equ 141
MarketPlaceButton12YBottom:        equ MarketPlaceButton12Ytop + 018
MarketPlaceButton12XLeft:          equ 116
MarketPlaceButton12XRight:         equ MarketPlaceButton12XLeft + 026

MarketPlaceButton13Ytop:           equ 143
MarketPlaceButton13YBottom:        equ MarketPlaceButton13Ytop + 014
MarketPlaceButton13XLeft:          equ 152
MarketPlaceButton13XRight:         equ MarketPlaceButton13XLeft + 014

MarketPlaceButtonTableLenghtPerButton:  equ MarketPlaceButtonTable.endlenght-MarketPlaceButtonTable
MarketPlaceButtonTableGfxBlock:  db  ChamberOfCommerceButtonsBlock
MarketPlaceButtonTableAmountOfButtons:  db  13
MarketPlaceButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (044*128) + (000/2) - 128 | db MarketPlaceButton1Ytop,MarketPlaceButton1YBottom,MarketPlaceButton1XLeft,MarketPlaceButton1XRight | dw $0000 + (MarketPlaceButton1Ytop*128) + (MarketPlaceButton1XLeft/2) - 128 
  .endlenght:
  db  %1010 0011 | dw $4000 + (000*128) + (028/2) - 128 | dw $4000 + (022*128) + (028/2) - 128 | dw $4000 + (044*128) + (028/2) - 128 | db MarketPlaceButton2Ytop,MarketPlaceButton2YBottom,MarketPlaceButton2XLeft,MarketPlaceButton2XRight | dw $0000 + (MarketPlaceButton2Ytop*128) + (MarketPlaceButton2XLeft/2) - 128 
  db  %1001 0011 | dw $4000 + (000*128) + (056/2) - 128 | dw $4000 + (022*128) + (056/2) - 128 | dw $4000 + (044*128) + (056/2) - 128 | db MarketPlaceButton3Ytop,MarketPlaceButton3YBottom,MarketPlaceButton3XLeft,MarketPlaceButton3XRight | dw $0000 + (MarketPlaceButton3Ytop*128) + (MarketPlaceButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (084/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | dw $4000 + (044*128) + (084/2) - 128 | db MarketPlaceButton4Ytop,MarketPlaceButton4YBottom,MarketPlaceButton4XLeft,MarketPlaceButton4XRight | dw $0000 + (MarketPlaceButton4Ytop*128) + (MarketPlaceButton4XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (112/2) - 128 | dw $4000 + (022*128) + (112/2) - 128 | dw $4000 + (044*128) + (112/2) - 128 | db MarketPlaceButton5Ytop,MarketPlaceButton5YBottom,MarketPlaceButton5XLeft,MarketPlaceButton5XRight | dw $0000 + (MarketPlaceButton5Ytop*128) + (MarketPlaceButton5XLeft/2) - 128 
  ;which resource will you offer window
  db  %0100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (044*128) + (000/2) - 128 | db MarketPlaceButton6Ytop,MarketPlaceButton6YBottom,MarketPlaceButton6XLeft,MarketPlaceButton6XRight | dw $0000 + (MarketPlaceButton6Ytop*128) + (MarketPlaceButton6XLeft/2) - 128 
  db  %0010 0011 | dw $4000 + (000*128) + (028/2) - 128 | dw $4000 + (022*128) + (028/2) - 128 | dw $4000 + (044*128) + (028/2) - 128 | db MarketPlaceButton7Ytop,MarketPlaceButton7YBottom,MarketPlaceButton7XLeft,MarketPlaceButton7XRight | dw $0000 + (MarketPlaceButton7Ytop*128) + (MarketPlaceButton7XLeft/2) - 128 
  db  %0001 0011 | dw $4000 + (000*128) + (056/2) - 128 | dw $4000 + (022*128) + (056/2) - 128 | dw $4000 + (044*128) + (056/2) - 128 | db MarketPlaceButton8Ytop,MarketPlaceButton8YBottom,MarketPlaceButton8XLeft,MarketPlaceButton8XRight | dw $0000 + (MarketPlaceButton8Ytop*128) + (MarketPlaceButton8XLeft/2) - 128
  db  %0100 0011 | dw $4000 + (000*128) + (084/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | dw $4000 + (044*128) + (084/2) - 128 | db MarketPlaceButton9Ytop,MarketPlaceButton9YBottom,MarketPlaceButton9XLeft,MarketPlaceButton9XRight | dw $0000 + (MarketPlaceButton9Ytop*128) + (MarketPlaceButton9XLeft/2) - 128 
  db  %0100 0011 | dw $4000 + (000*128) + (112/2) - 128 | dw $4000 + (022*128) + (112/2) - 128 | dw $4000 + (044*128) + (112/2) - 128 | db MarketPlaceButton10Ytop,MarketPlaceButton10YBottom,MarketPlaceButton10XLeft,MarketPlaceButton10XRight | dw $0000 + (MarketPlaceButton10Ytop*128) + (MarketPlaceButton10XLeft/2) - 128 
  ;+ buy - window
  db  %0100 0011 | dw $4000 + (000*128) + (140/2) - 128 | dw $4000 + (014*128) + (140/2) - 128 | dw $4000 + (028*128) + (140/2) - 128 | db MarketPlaceButton11Ytop,MarketPlaceButton11YBottom,MarketPlaceButton11XLeft,MarketPlaceButton11XRight | dw $0000 + (MarketPlaceButton11Ytop*128) + (MarketPlaceButton11XLeft/2) - 128 
  db  %0010 0011 | dw $4000 + (042*128) + (140/2) - 128 | dw $4000 + (042*128) + (166/2) - 128 | dw $4000 + (042*128) + (192/2) - 128 | db MarketPlaceButton12Ytop,MarketPlaceButton12YBottom,MarketPlaceButton12XLeft,MarketPlaceButton12XRight | dw $0000 + (MarketPlaceButton12Ytop*128) + (MarketPlaceButton12XLeft/2) - 128 
  db  %0001 0011 | dw $4000 + (000*128) + (154/2) - 128 | dw $4000 + (014*128) + (154/2) - 128 | dw $4000 + (028*128) + (140/2) - 128 | db MarketPlaceButton13Ytop,MarketPlaceButton13YBottom,MarketPlaceButton13XLeft,MarketPlaceButton13XRight | dw $0000 + (MarketPlaceButton13Ytop*128) + (MarketPlaceButton13XLeft/2) - 128


FirstLineintHeightCastleMagicGuild: equ 023
SecondLineintHeightCastleMagicGuild: equ 173
SetCastleMagicGuildInterruptHandler:
  di
  ld    hl,CastleInterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
 
  ld    a,(VDP_0)           ;set ei1
  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  out   ($99),a

  ld    a,FirstLineintHeightCastleMagicGuild
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

CastleOverviewMagicGuildCode:
  call  SetScreenOff

  call  SetMagicGuildButtons

  ld    hl,InGamePalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  call  SetMagicGuildGraphics           ;put gfx in page 1

  ld    hl,CopyPage1To0
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetCastleMagicGuildInterruptHandler
	
  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,CastleOverviewCode

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;magic skill icons in the magic guild
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/magic skill icons in the magic guild

  call  WaitVblank
  call  SetScreenOn
  jp  .engine

.CheckButtonClicked:                    ;in: carry=button clicked, b=button number
  ret   nc

  push  bc                              ;store button number
  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
  call  .ClearTextWindow
  call  .SetSpellIcon
  pop   bc                              ;recall button number
  push  bc                              ;store button number
  call  .SetText
  call  SwapAndSetPage                  ;swap and set page
  call  .ClearTextWindow
  call  .SetSpellIcon
  pop   bc                              ;recall button number
  call  .SetText
  ret

  .ClearTextWindow:
  ld    hl,$4000 + (154*128) + (006/2) - 128
  ld    de,$0000 + (154*128) + (006/2) - 128
  ld    bc,$0000 + (020*256) + (244/2)
  ld    a,MagicGuildBlock                 ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetSpellIcon:
  ld    hl,$4000 + (126*128) + (196/2) - 128
  ld    de,$0000 + (154*128) + (008/2) - 128
  ld    bc,$0000 + (020*256) + (020/2)
  ld    a,SpellBookGraphicsBlock        ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

.SetText:
  ld    a,b
  cp    8
  ld    de,(GenericButtonTable+1+0*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    7
  ld    de,(GenericButtonTable+1+1*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    6
  ld    de,(GenericButtonTable+1+2*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    5
  ld    de,(GenericButtonTable+1+3*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    4
  ld    de,(GenericButtonTable+1+4*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    3
  ld    de,(GenericButtonTable+1+5*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    2
  ld    de,(GenericButtonTable+1+6*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  ld    de,(GenericButtonTable+1+7*GenericButtonTableLenghtPerButton)
  .ButtonFound:
  ld    hl,EarthLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth4
  jp    z,.SpellFound
  ld    hl,EarthLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth3
  jp    z,.SpellFound
  ld    hl,EarthLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth2
  jp    z,.SpellFound
  ld    hl,EarthLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth1
  jp    z,.SpellFound

  ld    hl,FireLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire4
  jp    z,.SpellFound
  ld    hl,FireLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire3
  jp    z,.SpellFound
  ld    hl,FireLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire2
  jp    z,.SpellFound
  ld    hl,FireLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire1
  jp    z,.SpellFound

  ld    hl,AirLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir4
  jp    z,.SpellFound
  ld    hl,AirLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir3
  jp    z,.SpellFound
  ld    hl,AirLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir2
  jp    z,.SpellFound
  ld    hl,AirLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir1
  jp    z,.SpellFound

  ld    hl,WaterLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater4
  jp    z,.SpellFound
  ld    hl,WaterLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater3
  jp    z,.SpellFound
  ld    hl,WaterLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater2
  jp    z,.SpellFound
  ld    hl,WaterLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater1
  jp    z,.SpellFound
  
  .SpellFound:
  push  hl
  
  ex    de,hl
;  ld    hl,FireLevel1Untouched
  ld    de,$0000 + (156*128) + (010/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,SpellBookGraphicsBlock        ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  pop   hl
  ld    b,031
  ld    c,154
  jp    SetText

SpellDescriptionsMagicGuild:

.DescriptionEarth4:       db  "Earthbound",254
                          db  "Applies a 50% movement speed debuff to the selected",254
                          db  "enemy unit.",255

.DescriptionEarth3:       db  "Plate Armor",254
                          db  "Increases the defense of the selected friendly unit",254
                          db  "by 5.",255

.DescriptionEarth2:       db  "Resurrection",254
                          db  "Revives a segment of deceased friendly living",254
                          db  "creatures.",255

.DescriptionEarth1:       db  "Earthshock",254
                          db  "Deals damage to all creatures in target and adjacent",254
                          db  "hexes.",255


.DescriptionFire4:        db  "Curse",254
                          db  "Causes the selected enemy unit to deal -3 damage",254
                          db  "when attacking.",255

.DescriptionFire3:        db  "Blinding Fog",254
                          db  "Target ranged unit deals 50% less damage.",255

.DescriptionFire2:        db  "Implosion",254
                          db  "Deals damage to enemy unit and adjecent units.",255

.DescriptionFire1:        db  "Sunstrike",254
                          db  "Calls down a solar beam to incinerate a single enemy",254
                          db  "unit.",255

.Descriptionair4:         db  "Haste",254
                          db  "Increases the speed of the selected friendly unit by 3.",255

.Descriptionair3:         db  "Shieldbreaker",254
                          db  "Reduces the defense of the selected enemy unit by 4.",255

.Descriptionair2:         db  "Claw Back",254
                          db  "Target allied unit has unlimited retaliations each round.",255

.Descriptionair1:         db  "Spell Bubble",254
                          db  "Target friendly unit has a 75% chance to deflect a",254
                          db  "single enemy spell.",255


.Descriptionwater4:       db  "Cure",254
                          db  "Dissipates all harmful spell effects while restoring a set",254
                          db  "amount of HP.",255

.Descriptionwater3:       db  "Ice Peak",254
                          db  "Conjures an ice shard from the ground, impaling a",254
                          db  "single enemy.",255

.Descriptionwater2:       db  "Hypnosis",254
                          db  "Enemy unit cant attack until attacked, dispelled or",254
                          db  "effect wears off.",255


.Descriptionwater1:       db  "Frost Ring",254
                          db  "Causes damage to all units adjacent to the central hex.",255


SetGenericButtons:                      ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    a,(ix+GenericButtonGfxBlock)
  ld    (ButtonGfxBlockCopy),a

  ld    b,(ix+GenericButtonAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,GenericButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+GenericButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+GenericButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+GenericButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+GenericButtonStatus)
  res   1,(ix+GenericButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+GenericButton_SYSX_Ontouched)
  ld    h,(ix+GenericButton_SYSX_Ontouched+1)
  bit   6,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_MovedOver)
  ld    h,(ix+GenericButton_SYSX_MovedOver+1)
  bit   5,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_Clicked)
  ld    h,(ix+GenericButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+GenericButton_DYDX)
  ld    d,(ix+GenericButton_DYDX+1)

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    b,a                             ;ny
  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  srl   a                               ;/2
  ld    c,a                             ;nx / 2
;  ld    bc,$0000 + (016*256) + (016/2)        ;ny,nx

  ld    a,(ButtonGfxBlockCopy)



;  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
;  call  CopyTransparantButtons          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




;  halt


;  ret

;CopyTransparantButtons:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+dx),a
  ld    a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+dy),a

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+ny),a

  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+nx),a

  ld    hl,CopyCastleButton2
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret

CheckButtonMouseInteractionGenericButtons:
  ld    b,(ix+GenericButtonAmountOfButtons)
  ld    de,GenericButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+GenericButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+GenericButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06
  
  cp    (ix+GenericButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonXright)
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
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+GenericButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+GenericButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+GenericButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+GenericButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+GenericButtonStatus),%1010 0011
  scf                                     ;button has been clicked


  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
  ld    (MenuOptionSelected?),a
  ret

MagicGuildButtonTableGfxBlock:  db  SpellBookGraphicsBlock
MagicGuildButtonTableAmountOfButtons:  db  8
MagicGuildButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
;level 1 spells
EarthLevel1Button:
  db  %1100 0011 | dw EarthLevel1Untouched   | dw EarthLevel1Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel1Y ,MagicGuildEarthLevel1Y+16 ,MagicGuildEarthLevel1X ,MagicGuildEarthLevel1X+16  | dw $0000 + (MagicGuildEarthLevel1Y*128)  + (MagicGuildEarthLevel1X/2)  - 128 |
FireLevel1Button:
  db  %1100 0011 | dw FireLevel1Untouched    | dw FireLevel1Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel1Y , MagicGuildFireLevel1Y+16 , MagicGuildFireLevel1X , MagicGuildFireLevel1X+16   | dw $0000 + (MagicGuildFireLevel1Y*128)  +  (MagicGuildFireLevel1X/2)  - 128  |
AirLevel1Button:
  db  %1100 0011 | dw AirLevel1Untouched     | dw AirLevel1Touched      | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel1Y ,  MagicGuildAirLevel1Y+16 ,  MagicGuildAirLevel1X ,  MagicGuildAirLevel1X+16    | dw $0000 + (MagicGuildAirLevel1Y*128)  +   (MagicGuildAirLevel1X/2)  - 128   |
WaterLevel1Button:
  db  %1100 0011 | dw WaterLevel1Untouched   | dw WaterLevel1Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel1Y, MagicGuildWaterLevel1Y+16, MagicGuildWaterLevel1X, MagicGuildWaterLevel1X+16  | dw $0000 + (MagicGuildWaterLevel1Y*128) +  (MagicGuildWaterLevel1X/2) - 128  | 

;level 2 spells
EarthLevel2Button:
  db  %1100 0011 | dw EarthLevel2Untouched   | dw EarthLevel2Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel2Y ,MagicGuildEarthLevel2Y+16 ,MagicGuildEarthLevel2X ,MagicGuildEarthLevel2X+16  | dw $0000 + (MagicGuildEarthLevel2Y*128)  + (MagicGuildEarthLevel2X/2)  - 128 |
FireLevel2Button:
  db  %1100 0011 | dw FireLevel2Untouched    | dw FireLevel2Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel2Y , MagicGuildFireLevel2Y+16 , MagicGuildFireLevel2X , MagicGuildFireLevel2X+16   | dw $0000 + (MagicGuildFireLevel2Y*128)  +  (MagicGuildFireLevel2X/2)  - 128  |
AirLevel2Button:
  db  %1100 0011 | dw AirLevel2Untouched     | dw AirLevel2Touched      | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel2Y ,  MagicGuildAirLevel2Y+16 ,  MagicGuildAirLevel2X ,  MagicGuildAirLevel2X+16    | dw $0000 + (MagicGuildAirLevel2Y*128)  +   (MagicGuildAirLevel2X/2)  - 128   |
WaterLevel2Button:
  db  %1100 0011 | dw WaterLevel2Untouched   | dw WaterLevel2Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel2Y, MagicGuildWaterLevel2Y+16, MagicGuildWaterLevel2X, MagicGuildWaterLevel2X+16  | dw $0000 + (MagicGuildWaterLevel2Y*128) +  (MagicGuildWaterLevel2X/2) - 128  | 

;level 3 spells
EarthLevel3Button:
  db  %1100 0011 | dw EarthLevel3Untouched   | dw EarthLevel3Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel3Y ,MagicGuildEarthLevel3Y+16 ,MagicGuildEarthLevel3X ,MagicGuildEarthLevel3X+16  | dw $0000 + (MagicGuildEarthLevel3Y*128)  + (MagicGuildEarthLevel3X/2)  - 128 |
FireLevel3Button:
  db  %1100 0011 | dw FireLevel3Untouched    | dw FireLevel3Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel3Y , MagicGuildFireLevel3Y+16 , MagicGuildFireLevel3X , MagicGuildFireLevel3X+16   | dw $0000 + (MagicGuildFireLevel3Y*128)  +  (MagicGuildFireLevel3X/2)  - 128  |
AirLevel3Button:
  db  %1100 0011 | dw AirLevel3Untouched     | dw AirLevel3Touched      | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel3Y ,  MagicGuildAirLevel3Y+16 ,  MagicGuildAirLevel3X ,  MagicGuildAirLevel3X+16    | dw $0000 + (MagicGuildAirLevel3Y*128)  +   (MagicGuildAirLevel3X/2)  - 128   |
WaterLevel3Button:
  db  %1100 0011 | dw WaterLevel3Untouched   | dw WaterLevel3Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel3Y, MagicGuildWaterLevel3Y+16, MagicGuildWaterLevel3X, MagicGuildWaterLevel3X+16  | dw $0000 + (MagicGuildWaterLevel3Y*128) +  (MagicGuildWaterLevel3X/2) - 128  | 

;level 4 spells
EarthLevel4Button:
  db  %1100 0011 | dw EarthLevel4Untouched   | dw EarthLevel4Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel4Y ,MagicGuildEarthLevel4Y+16 ,MagicGuildEarthLevel4X ,MagicGuildEarthLevel4X+16  | dw $0000 + (MagicGuildEarthLevel4Y*128)  + (MagicGuildEarthLevel4X/2)  - 128 |
FireLevel4Button:
  db  %1100 0011 | dw FireLevel4Untouched    | dw FireLevel4Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel4Y , MagicGuildFireLevel4Y+16 , MagicGuildFireLevel4X , MagicGuildFireLevel4X+16   | dw $0000 + (MagicGuildFireLevel4Y*128)  +  (MagicGuildFireLevel4X/2)  - 128  |
AirLevel4Button:
  db  %1100 0011 | dw AirLevel4Untouched     | dw AirLevel4Touched      | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel4Y ,  MagicGuildAirLevel4Y+16 ,  MagicGuildAirLevel4X ,  MagicGuildAirLevel4X+16    | dw $0000 + (MagicGuildAirLevel4Y*128)  +   (MagicGuildAirLevel4X/2)  - 128   |
WaterLevel4Button:
  db  %1100 0011 | dw WaterLevel4Untouched   | dw WaterLevel4Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel4Y, MagicGuildWaterLevel4Y+16, MagicGuildWaterLevel4X, MagicGuildWaterLevel4X+16  | dw $0000 + (MagicGuildWaterLevel4Y*128) +  (MagicGuildWaterLevel4X/2) - 128  | 

SetCastleSpellsInIX:
  push  iy
  pop   de
  ld    hl,Castle1
  ld    ix,Castle1Spells
  call  CompareHLwithDE
  ret   z

  ld    hl,Castle2
  ld    ix,Castle2Spells
  call  CompareHLwithDE
  ret   z

  ld    hl,Castle3
  ld    ix,Castle3Spells
  call  CompareHLwithDE
  ret   z

  ld    hl,Castle4
  ld    ix,Castle4Spells
  call  CompareHLwithDE
  ret   z
  ret

SetMagicGuildButtons:
  ld    hl,MagicGuildButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*8)
  ldir

  call  SetCastleSpellsInIX
  ld    de,GenericButtonTable

  ;set all spells in magic guild
  ld    hl,EarthLevel1Button
  bit   0,(ix+0)
  call  nz,.AddButton
  ld    hl,FireLevel1Button
  bit   0,(ix+1)
  call  nz,.AddButton
  ld    hl,AirLevel1Button
  bit   0,(ix+2)
  call  nz,.AddButton
  ld    hl,WaterLevel1Button
  bit   0,(ix+3)
  call  nz,.AddButton

  ld    hl,EarthLevel2Button
  bit   1,(ix+0)
  call  nz,.AddButton
  ld    hl,FireLevel2Button
  bit   1,(ix+1)
  call  nz,.AddButton
  ld    hl,AirLevel2Button
  bit   1,(ix+2)
  call  nz,.AddButton
  ld    hl,WaterLevel2Button
  bit   1,(ix+3)
  call  nz,.AddButton

  ld    hl,EarthLevel3Button
  bit   2,(ix+0)
  call  nz,.AddButton
  ld    hl,FireLevel3Button
  bit   2,(ix+1)
  call  nz,.AddButton
  ld    hl,AirLevel3Button
  bit   2,(ix+2)
  call  nz,.AddButton
  ld    hl,WaterLevel3Button
  bit   2,(ix+3)
  call  nz,.AddButton

  ld    hl,EarthLevel4Button
  bit   3,(ix+0)
  call  nz,.AddButton
  ld    hl,FireLevel4Button
  bit   3,(ix+1)
  call  nz,.AddButton
  ld    hl,AirLevel4Button
  bit   3,(ix+2)
  call  nz,.AddButton
  ld    hl,WaterLevel4Button
  bit   3,(ix+3)
  call  nz,.AddButton

  ld    a,(iy+CastleMageGuildLevel)
  cp    4
  ret   z
  xor   a
  ld    (GenericButtonTable+6*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+7*GenericButtonTableLenghtPerButton),a

  ld    a,(iy+CastleMageGuildLevel)
  cp    3
  ret   z
  xor   a
  ld    (GenericButtonTable+4*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+5*GenericButtonTableLenghtPerButton),a

  ld    a,(iy+CastleMageGuildLevel)
  cp    2
  ret   z
  xor   a
  ld    (GenericButtonTable+2*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+3*GenericButtonTableLenghtPerButton),a
  ret

  .AddButton:
  ld    bc,GenericButtonTableLenghtPerButton
  ldir
  ret

;DYDX of icons in the Magic Guild overview screen
MagicGuildEarthLevel1Y:    equ 046
MagicGuildEarthLevel1X:    equ 034
MagicGuildEarthLevel2Y:    equ 046
MagicGuildEarthLevel2X:    equ 072
MagicGuildEarthLevel3Y:    equ 069
MagicGuildEarthLevel3X:    equ 034
MagicGuildEarthLevel4Y:    equ 069
MagicGuildEarthLevel4X:    equ 072

MagicGuildFireLevel1Y:   equ 105
MagicGuildFireLevel1X:   equ 034
MagicGuildFireLevel2Y:   equ 105
MagicGuildFireLevel2X:   equ 072
MagicGuildFireLevel3Y:   equ 128
MagicGuildFireLevel3X:   equ 034
MagicGuildFireLevel4Y:   equ 128
MagicGuildFireLevel4X:   equ 072

MagicGuildAirLevel1Y:     equ 046
MagicGuildAirLevel1X:     equ 166
MagicGuildAirLevel2Y:     equ 046
MagicGuildAirLevel2X:     equ 204
MagicGuildAirLevel3Y:     equ 069
MagicGuildAirLevel3X:     equ 166
MagicGuildAirLevel4Y:     equ 069
MagicGuildAirLevel4X:     equ 204

MagicGuildWaterLevel1Y:   equ 105
MagicGuildWaterLevel1X:   equ 166
MagicGuildWaterLevel2Y:   equ 105
MagicGuildWaterLevel2X:   equ 204
MagicGuildWaterLevel3Y:   equ 128
MagicGuildWaterLevel3X:   equ 166
MagicGuildWaterLevel4Y:   equ 128
MagicGuildWaterLevel4X:   equ 204

;SYSX of the icons Touched and Untouched
EarthLevel1Untouched:    equ $4000 + (000*128) + (224/2) - 128
EarthLevel1Touched:      equ $4000 + (000*128) + (240/2) - 128
EarthLevel2Untouched:    equ $4000 + (016*128) + (224/2) - 128
EarthLevel2Touched:      equ $4000 + (016*128) + (240/2) - 128
EarthLevel3Untouched:    equ $4000 + (032*128) + (224/2) - 128
EarthLevel3Touched:      equ $4000 + (032*128) + (240/2) - 128
EarthLevel4Untouched:    equ $4000 + (048*128) + (224/2) - 128
EarthLevel4Touched:      equ $4000 + (048*128) + (240/2) - 128

FireLevel1Untouched:   equ $4000 + (064*128) + (224/2) - 128
FireLevel1Touched:     equ $4000 + (064*128) + (240/2) - 128
FireLevel2Untouched:   equ $4000 + (080*128) + (224/2) - 128
FireLevel2Touched:     equ $4000 + (080*128) + (240/2) - 128
FireLevel3Untouched:   equ $4000 + (096*128) + (224/2) - 128
FireLevel3Touched:     equ $4000 + (096*128) + (240/2) - 128
FireLevel4Untouched:   equ $4000 + (112*128) + (224/2) - 128
FireLevel4Touched:     equ $4000 + (112*128) + (240/2) - 128

AirLevel1Untouched:     equ $4000 + (128*128) + (224/2) - 128
AirLevel1Touched:       equ $4000 + (128*128) + (240/2) - 128
AirLevel2Untouched:     equ $4000 + (144*128) + (224/2) - 128
AirLevel2Touched:       equ $4000 + (144*128) + (240/2) - 128
AirLevel3Untouched:     equ $4000 + (160*128) + (224/2) - 128
AirLevel3Touched:       equ $4000 + (160*128) + (240/2) - 128
AirLevel4Untouched:     equ $4000 + (176*128) + (224/2) - 128
AirLevel4Touched:       equ $4000 + (176*128) + (240/2) - 128

WaterLevel1Untouched:   equ $4000 + (184*128) + (000/2) - 128
WaterLevel1Touched:     equ $4000 + (184*128) + (016/2) - 128
WaterLevel2Untouched:   equ $4000 + (184*128) + (032/2) - 128
WaterLevel2Touched:     equ $4000 + (184*128) + (048/2) - 128
WaterLevel3Untouched:   equ $4000 + (184*128) + (064/2) - 128
WaterLevel3Touched:     equ $4000 + (184*128) + (080/2) - 128
WaterLevel4Untouched:   equ $4000 + (184*128) + (096/2) - 128
WaterLevel4Touched:     equ $4000 + (184*128) + (112/2) - 128


SetExitButtonHeight:
  ld    (CastleOverviewButtonTable + (5*CastleOverviewButtonTableLenghtPerButton) + CastleOverviewWindowButtonYtop),a
  ld    (CopyCastleButton+dy),a
  add   a,31
  ld    (CastleOverviewButtonTable + (5*CastleOverviewButtonTableLenghtPerButton) + CastleOverviewWindowButtonYbottom),a
  ret

CastleOverviewRecruitCode:
  call  SetScreenOff

  ld    a,2
  ld    (AreWeInTavern1OrRecruit2?),a


  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix
  call  SetDefendingAndVisitingHeroButtons
  ld    hl,InGamePalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    (SelectedCastleRecruitLevelUnitTotalGoldCost),hl
  ld    (SelectedCastleRecruitLevelUnitTotalCostGems),hl
  ld    (SelectedCastleRecruitLevelUnitTotalCostRubies),hl
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,133
  call  SetExitButtonHeight

  xor   a
  ld    (RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton),a ;BUY button
  ld    (RecruitButtonMAXBUYTable+1*RecruitButtonMAXBUYTableLenghtPerButton),a ;MAX button
  ld    (RecruitButtonMAXBUYTable+2*RecruitButtonMAXBUYTableLenghtPerButton),a ;+ button
  ld    (RecruitButtonMAXBUYTable+3*RecruitButtonMAXBUYTableLenghtPerButton),a ;- button

  ld    a,%1100 0011                    ;turn all recruit buttons on
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 

  call  SetRecruitGraphics              ;put gfx in page 1
  call  SetResourcesPlayer
  call  SetVisitingAndDefendingHeroesAndArmy
  call  SetAvailableRecruitArmy         ;put army icons, amount and info in the 6 windows
  call  SetVisitingAndDefendingHeroesAndArmy

;  ld    b,3                             ;which unit ?
;  call  ShowRecruitWindowForSelectedUnit

  ld    hl,CopyPage1To0
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetCastleRecruitInterruptHandler
	
  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton) ;BUY button
  or    a
  ld    a,(Controls)
  jr    z,.NotInRecruitMAXBUYWindow
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  call  nz,ExitSingleUnitRecruitWindow
  .NotInRecruitMAXBUYWindow:
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,CastleOverviewCode

  ;VisitingAndDefendingHeroesAndArmy buttons
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons

  call  CastleOverviewTavernCode.CheckButtonClickedVisitingAndDefendingHeroesAndArmy             ;in: carry=button clicked, b=button number

  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton                ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1001 0011
  .EndMarkButton:
  ;we mark previous button clicked

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state
  ;/VisitingAndDefendingHeroesAndArmy buttons

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;recruit button for level 1-6 creatures
  ld    ix,RecruitButtonTable 
  call  CheckButtonMouseInteractionRecruitButtons

  ld    ix,RecruitButtonTable
  call  SetRecruitButtons                ;copies button state from rom -> vram
  ;/recruit button for level 1-6 creatures

;WE SET UP TO COPY THE BUTTON TWICE, SINCE CLICKING THE BUTTON
;INSTANTLY POPS UP A SUBMENU, WHICH PREVENTS THE BUTTON FROM BEING COPIED TWICE
;RESULTING IN FLICKERING OF THE BUTTON
  call  SwapAndSetPage                  ;swap and set page
  ld    ix,RecruitButtonTable
  call  SetRecruitButtons                ;copies button state from rom -> vram
  call  SwapAndSetPage                  ;swap and set page

  ;recruit buttons MAX and BUY
  ld    ix,RecruitButtonMAXBUYTable 
  call  CheckButtonMouseInteractionRecruitMAXBUYButtons

  ld    ix,RecruitButtonMAXBUYTable
  call  SetRecruitMAXBUYButtons                ;copies button state from rom -> vram
  ;/recruit buttons MAX and BUY

  call  CheckEndRecruitUnitWindow   ;check if mouse is clicked outside of recruit single unit window. If so, close this window

  call  WaitVblank
  call  SetScreenOn
  jp  .engine

FirstLineintHeightCastleRecruit: equ 126
SecondLineintHeightCastleRecruit: equ 160
SetCastleRecruitInterruptHandler:
  di
  ld    hl,CastleInterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
 
  ld    a,(VDP_0)           ;set ei1
  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  out   ($99),a

  ld    a,FirstLineintHeightCastleRecruit
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

CheckEndRecruitUnitWindow:
  ld    a,(RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton) ;BUY button
  or    a
  ret   z

	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    032                             ;dy
  jr    c,ExitSingleUnitRecruitWindow
  cp    032+092                         ;dy+ny
  jr    nc,ExitSingleUnitRecruitWindow
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    048                             ;dx
  jr    c,ExitSingleUnitRecruitWindow
  cp    048+162                         ;dx+nx
  ret   c

ExitSingleUnitRecruitWindow:
  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    (SelectedCastleRecruitLevelUnitTotalGoldCost),hl
  ld    (SelectedCastleRecruitLevelUnitTotalCostGems),hl
  ld    (SelectedCastleRecruitLevelUnitTotalCostRubies),hl

  xor   a
  ld    (RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton),a ;BUY button
  ld    (RecruitButtonMAXBUYTable+1*RecruitButtonMAXBUYTableLenghtPerButton),a ;MAX button
  ld    (RecruitButtonMAXBUYTable+2*RecruitButtonMAXBUYTableLenghtPerButton),a ;+ button
  ld    (RecruitButtonMAXBUYTable+3*RecruitButtonMAXBUYTableLenghtPerButton),a ;- button

  ld    a,%1100 0011                    ;turn all recruit buttons on
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 

  call  SetRecruitGraphics6CreatureWindows              ;put gfx in page 1
  call  SetAvailableRecruitArmy         ;put army icons, amount and info in the 6 windows
  call  SetResourcesPlayer
  call  SwapAndSetPage                  ;swap and set page
  call  SetRecruitGraphics6CreatureWindows              ;put gfx in page 1
  call  SetAvailableRecruitArmy         ;put army icons, amount and info in the 6 windows
  call  SetResourcesPlayer
  
  pop   af                                ;pop the call to this routine

  jp    ExitVisitingAndDefendingArmyRoutine

;  jp    CastleOverviewRecruitCode.engine




SetRecruitMAXBUYButtons:                  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,(ix+AmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,RecruitButtonMAXBUYTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+RecruitButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+RecruitButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+RecruitButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+RecruitButtonStatus)
  res   1,(ix+RecruitButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+RecruitButton_SYSX_Ontouched)
  ld    h,(ix+RecruitButton_SYSX_Ontouched+1)
  bit   6,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_MovedOver)
  ld    h,(ix+RecruitButton_SYSX_MovedOver+1)
  bit   5,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_Clicked)
  ld    h,(ix+RecruitButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+RecruitButton_DYDX)
  ld    d,(ix+RecruitButton_DYDX+1)


  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    b,a                             ;ny
  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  srl   a                               ;/2
  ld    c,a                             ;nx / 2
;  ld    bc,$0000 + (016*256) + (016/2)        ;ny,nx


;  ld    bc,$0000 + (018*256) + (026/2)        ;ny,nx
  ld    a,ButtonsRecruitBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
;  halt
  ret










CheckButtonMouseInteractionRecruitMAXBUYButtons:
  ld    b,(ix+AmountOfButtons)
  ld    de,RecruitButtonMAXBUYTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+RecruitButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+RecruitButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+RecruitButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonXright)
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
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+RecruitButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+RecruitButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+RecruitButtonStatus),%1010 0011
  ld    a,b
  cp    4
  jr    z,.BuyButtonPressed
  cp    3
  jr    z,.MaxButtonPressed
  cp    2
  jr    z,.PlusButtonPressed
  cp    1
  jr    z,.MinusButtonPressed
  ret

  .MinusButtonPressed:
  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)
  ld    a,l
  or    h
  ret   z                               ;return if recruit amount=0
  
  dec   hl
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl

  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  inc   hl
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  call  .GoSetAvailableAmountRecruitAmountAndTotalCost
  call  SwapAndSetPage                  ;swap and set page
  jp    .GoSetAvailableAmountRecruitAmountAndTotalCost

  .PlusButtonPressed:
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    a,l
  or    h
  ret   z                               ;return if amount available=0

  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)
  inc   hl

;ld hl,344
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl

  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  dec   hl

;ld hl,100
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  call  .GoSetAvailableAmountRecruitAmountAndTotalCost
  call  SwapAndSetPage                  ;swap and set page
  jp    .GoSetAvailableAmountRecruitAmountAndTotalCost



  .MaxButtonPressed:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  .SetAvailableAmountRecruitAmountAndTotalCost
  call  SwapAndSetPage                  ;swap and set page
  call  .SetAvailableAmountRecruitAmountAndTotalCost
  ret

  .BuyButtonPressed:
  ;check if any unit has been purchase, or did the amount stay on 0 ?
  ld    de,(SelectedCastleRecruitLevelUnitTotalGoldCost)
  ld    a,d
  or    e
  jp    z,ExitSingleUnitRecruitWindow   ;return if amount stayed on 0

  ;add the units to visiting or defending hero
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  call  .CheckAddCreaturesToVisitingHero
  jr    nc,.UnitsAdded                  ;not carry=units added to hero. carry=no visiting hero, no empty slots or no similar creatures in slots
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  .CheckAddCreaturesToVisitingHero
  jr    nc,.UnitsAdded                  ;not carry=units added to hero. carry=no visiting hero, no empty slots or no similar creatures in slots
  jp    ExitSingleUnitRecruitWindow
  .UnitsAdded:
  
  call  SetResourcesCurrentPlayerinIX
  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;player gold in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalGoldCost)
  xor   a
  sbc   hl,de
  ld    (ix+0),l
  ld    (ix+1),h                        ;player gold in hl

  ld    l,(ix+6)
  ld    h,(ix+7)                        ;player gold in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalCostGems)
  xor   a
  sbc   hl,de
  ld    (ix+6),l
  ld    (ix+7),h                        ;player gold in hl

  ld    l,(ix+8)
  ld    h,(ix+9)                        ;player gold in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalCostRubies)
  xor   a
  sbc   hl,de
  ld    (ix+8),l
  ld    (ix+9),h                        ;player gold in hl

  call  .SubtractPurchasedUnitsFromCastle
  jp    ExitSingleUnitRecruitWindow

  .CheckAddCreaturesToVisitingHero:
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  ret   c                               ;carry=no visiting/defending hero found

  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,a
  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)

  ;check if any of the slots has the same creature that we just purchased
  ld    a,(SelectedCastleRecruitLevelUnit)
  cp    (ix+HeroUnits+0)                ;check if 1st creature slot has the same type of unit that we purchased
  jp    z,.Slot1SameUnit
  cp    (ix+HeroUnits+3)                ;check if 2nd creature slot has the same type of unit that we purchased
  jp    z,.Slot2SameUnit
  cp    (ix+HeroUnits+6)                ;check if 3d creature slot has the same type of unit that we purchased
  jp    z,.Slot3SameUnit
  cp    (ix+HeroUnits+9)                ;check if 4th creature slot has the same type of unit that we purchased
  jp    z,.Slot4SameUnit
  cp    (ix+HeroUnits+12)                ;check if 5th creature slot has the same type of unit that we purchased
  jp    z,.Slot5SameUnit
  cp    (ix+HeroUnits+15)                ;check if 6th creature slot has the same type of unit that we purchased
  jp    z,.Slot6SameUnit
  
  ;check if any of the slots are empty
  xor   a
  cp    (ix+HeroUnits+0)                ;check if 1st creature slot has the same type of unit that we purchased
  jp    z,.Slot1IsEmpty
  cp    (ix+HeroUnits+3)                ;check if 2nd creature slot has the same type of unit that we purchased
  jp    z,.Slot2IsEmpty
  cp    (ix+HeroUnits+6)                ;check if 3d creature slot has the same type of unit that we purchased
  jp    z,.Slot3IsEmpty
  cp    (ix+HeroUnits+9)                ;check if 4th creature slot has the same type of unit that we purchased
  jp    z,.Slot4IsEmpty
  cp    (ix+HeroUnits+12)                ;check if 5th creature slot has the same type of unit that we purchased
  jp    z,.Slot5IsEmpty
  cp    (ix+HeroUnits+15)                ;check if 6th creature slot has the same type of unit that we purchased
  jp    z,.Slot6IsEmpty
  scf
  ret
  
  .Slot1SameUnit:
  ld    e,(ix+HeroUnits+1)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+2)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+1),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+2),h              ;unit amount (16 bit)
  ret
  .Slot2SameUnit:
  ld    e,(ix+HeroUnits+4)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+5)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+4),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+5),h              ;unit amount (16 bit)
  ret
  .Slot3SameUnit:
  ld    e,(ix+HeroUnits+7)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+8)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+7),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+8),h              ;unit amount (16 bit)
  ret
  .Slot4SameUnit:
  ld    e,(ix+HeroUnits+10)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+11)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+10),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+11),h              ;unit amount (16 bit)
  ret
  .Slot5SameUnit:
  ld    e,(ix+HeroUnits+13)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+14)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+13),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+14),h              ;unit amount (16 bit)
  ret
  .Slot6SameUnit:
  ld    e,(ix+HeroUnits+16)              ;unit amount (16 bit)
  ld    d,(ix+HeroUnits+17)              ;unit amount (16 bit)
  add   hl,de
  ld    (ix+HeroUnits+16),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+17),h              ;unit amount (16 bit)
  ret

  .Slot1IsEmpty:
  ld    (ix+HeroUnits+0),b              ;unit type
  ld    (ix+HeroUnits+1),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+2),h              ;unit amount (16 bit)
  ret
  .Slot2IsEmpty:
  ld    (ix+HeroUnits+3),b              ;unit type
  ld    (ix+HeroUnits+4),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+5),h              ;unit amount (16 bit)
  ret
  .Slot3IsEmpty:
  ld    (ix+HeroUnits+6),b              ;unit type
  ld    (ix+HeroUnits+7),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+8),h              ;unit amount (16 bit)
  ret
  .Slot4IsEmpty:
  ld    (ix+HeroUnits+9),b              ;unit type
  ld    (ix+HeroUnits+10),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+11),h              ;unit amount (16 bit)
  ret
  .Slot5IsEmpty:
  ld    (ix+HeroUnits+12),b              ;unit type
  ld    (ix+HeroUnits+13),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+14),h              ;unit amount (16 bit)
  ret
  .Slot6IsEmpty:
  ld    (ix+HeroUnits+15),b              ;unit type
  ld    (ix+HeroUnits+16),l              ;unit amount (16 bit)
  ld    (ix+HeroUnits+17),h              ;unit amount (16 bit)
  ret




.SubtractPurchasedUnitsFromCastle:
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  ld    a,(SelectedCastleRecruitUnitWindow)
  cp    6
  jr    nz,.EndCheckUnitLevel1  
  ld    l,(iy+CastleLevel1UnitsAvail+00)
  ld    h,(iy+CastleLevel1UnitsAvail+01)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+00),l
  ld    (iy+CastleLevel1UnitsAvail+01),h
  ret
  .EndCheckUnitLevel1:

  cp    5
  jr    nz,.EndCheckUnitLevel2  
  ld    l,(iy+CastleLevel1UnitsAvail+02)
  ld    h,(iy+CastleLevel1UnitsAvail+03)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+02),l
  ld    (iy+CastleLevel1UnitsAvail+03),h
  ret
  .EndCheckUnitLevel2:

  cp    4
  jr    nz,.EndCheckUnitLevel3 
  ld    l,(iy+CastleLevel1UnitsAvail+04)
  ld    h,(iy+CastleLevel1UnitsAvail+05)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+04),l
  ld    (iy+CastleLevel1UnitsAvail+05),h
  ret
  .EndCheckUnitLevel3:

  cp    3
  jr    nz,.EndCheckUnitLevel4
  ld    l,(iy+CastleLevel1UnitsAvail+06)
  ld    h,(iy+CastleLevel1UnitsAvail+07)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+06),l
  ld    (iy+CastleLevel1UnitsAvail+07),h
  ret
  .EndCheckUnitLevel4:

  cp    2
  jr    nz,.EndCheckUnitLevel5
  ld    l,(iy+CastleLevel1UnitsAvail+08)
  ld    h,(iy+CastleLevel1UnitsAvail+09)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+08),l
  ld    (iy+CastleLevel1UnitsAvail+09),h
  ret
  .EndCheckUnitLevel5:

  cp    1
  jr    nz,.EndCheckUnitLevel6
  ld    l,(iy+CastleLevel1UnitsAvail+10)
  ld    h,(iy+CastleLevel1UnitsAvail+11)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+10),l
  ld    (iy+CastleLevel1UnitsAvail+11),h
  ret
  .EndCheckUnitLevel6:
  ret






.SetAvailableAmountRecruitAmountAndTotalCost:
  ;add amount available to recruit amount to select all units ready for recruitment
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  .GoSetAvailableAmountRecruitAmountAndTotalCost:

  ;erase available number
  ld    hl,$4000 + (118*128) + (040/2) - 128
  ld    de,$0000 + (103*128) + (088/2) - 128
  ld    bc,$0000 + (005*256) + (026/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;erase total cost and recruit amount
  ld    hl,$4000 + (086*128) + (122/2) - 128
  ld    de,$0000 + (071*128) + (170/2) - 128
  ld    bc,$0000 + (037*256) + (036/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetTotalCost                   ;set total gold, gems and rubies (store in ram)

  ;check if player has enough gold for all these units
  call  SetResourcesCurrentPlayerinIX
  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;player gold in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalGoldCost)
  xor   a
  sbc   hl,de                           ;player gold - total cost. carry=player has not enough gold
  jr    nc,.EndCheckEnoughGoldToRecruitALLunits

  ;check how many units we CAN buy with the total amount of gold we have
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetCostSelectedCreatureInHL     ;cost per creature in hl
  push  hl                              ;push cost per creature
  call  SetResourcesCurrentPlayerinIX
  ;gold
  ld    c,(ix+0)
  ld    b,(ix+1)                        ;player gold in bc
  pop   de                              ;cost per creature in DE
  ;now lets divide the total gold by the cost per unit
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ;set the amount we CAN NOT recruit (they remain in the 'available' section)
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  sbc   hl,bc
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),bc
  call  .SetTotalCost
  .EndCheckEnoughGoldToRecruitALLunits:




  ;check if player has enough gems for all these units
  call  SetResourcesCurrentPlayerinIX
  ;gems
  ld    l,(ix+6)
  ld    h,(ix+7)                        ;Player gems in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalCostGems)
  xor   a
  sbc   hl,de                           ;player gems - total cost. carry=player has not enough gold
  jr    nc,.EndCheckEnoughGemsToRecruitALLunits

  ;reset amount available and recruit amount
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  ;check how many units we CAN buy with the total amount of gems we have
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetGemsCostSelectedCreatureInHL ;cost per creature in hl
  push  hl                              ;push cost per creature
  call  SetResourcesCurrentPlayerinIX
  ;gems
  ld    c,(ix+6)
  ld    b,(ix+7)                        ;Player gems in hl
  pop   de                              ;cost per creature in DE
  ;now lets divide the total gems by the cost per unit
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ;set the amount we CAN NOT recruit (they remain in the 'available' section)
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  sbc   hl,bc
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),bc
  call  .SetTotalCost 
  .EndCheckEnoughGemsToRecruitALLunits:






  ;check if player has enough rubies for all these units
  call  SetResourcesCurrentPlayerinIX
  ;rubies
  ld    l,(ix+8)
  ld    h,(ix+9)                        ;Player rubies in hl
  ld    de,(SelectedCastleRecruitLevelUnitTotalCostRubies)
  xor   a
  sbc   hl,de                           ;player rubies - total cost. carry=player has not enough gold
  jr    nc,.EndCheckEnoughRubiesToRecruitALLunits

  ;reset amount available and recruit amount
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  ;check how many units we CAN buy with the total amount of rubies we have
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetRubiesCostSelectedCreatureInHL ;cost per creature in hl
  push  hl                              ;push cost per creature
  call  SetResourcesCurrentPlayerinIX
  ;rubies
  ld    c,(ix+8)
  ld    b,(ix+9)                        ;Player rubies in hl
  pop   de                              ;cost per creature in DE
  ;now lets divide the total rubies by the cost per unit
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ;set the amount we CAN NOT recruit (they remain in the 'available' section)
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  sbc   hl,bc
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),bc
  call  .SetTotalCost
  .EndCheckEnoughRubiesToRecruitALLunits:


  call  ShowRecruitWindowForSelectedUnit.amountavailable
  call  ShowRecruitWindowForSelectedUnit.recruitamount

  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)
  ld    a,h
  or    l
  ret   z

  call  ShowRecruitWindowForSelectedUnit.totalcost
  call  ShowRecruitWindowForSelectedUnit.TotalGemscost
  call  ShowRecruitWindowForSelectedUnit.TotalRubiescost
  ret

  .SetTotalCost:
  ;set total cost gold
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetCostSelectedCreatureInHL  
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  call  MultiplyHlWithDE
  ld    (SelectedCastleRecruitLevelUnitTotalGoldCost),hl

  ;set total cost gems
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetGemsCostSelectedCreatureInHL  
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  call  MultiplyHlWithDE
  ld    (SelectedCastleRecruitLevelUnitTotalCostGems),hl

  ;set total cost rubies
  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetRubiesCostSelectedCreatureInHL  
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  call  MultiplyHlWithDE
  ld    (SelectedCastleRecruitLevelUnitTotalCostRubies),hl
  ret














SetRecruitButtons:                        ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,6
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,RecruitButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+RecruitButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+RecruitButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+RecruitButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+RecruitButtonStatus)
  res   1,(ix+RecruitButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+RecruitButton_SYSX_Ontouched)
  ld    h,(ix+RecruitButton_SYSX_Ontouched+1)
  bit   6,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_MovedOver)
  ld    h,(ix+RecruitButton_SYSX_MovedOver+1)
  bit   5,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_Clicked)
  ld    h,(ix+RecruitButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+RecruitButton_DYDX)
  ld    d,(ix+RecruitButton_DYDX+1)

  ld    bc,$0000 + (009*256) + (076/2)        ;ny,nx
  ld    a,ButtonsRecruitBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
;  halt
  ret












CheckButtonMouseInteractionRecruitButtons:
  ld    b,6
  ld    de,RecruitButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+RecruitButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+RecruitButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+RecruitButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonXright)
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
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+RecruitButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+RecruitButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
;  ld    (ix+RecruitButtonStatus),%1010 0011
;  ld    a,b

  push  bc                              ;b=unit selected
  call  ShowRecruitWindowForSelectedUnit
  call  SwapAndSetPage                  ;swap and set page
  pop   bc
  call  ShowRecruitWindowForSelectedUnit
  ret












 
 
















CastleOverviewBuildCode:                ;in: iy-castle
  call  SetScreenOff

  call  Set9BuildButtons                ;check which buttons should be blue, green and red

  ld    hl,CastleOverviewPalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  call  SetBuildGraphics                ;put gfx in page 1
  call  SetResourcesPlayer

  ld    hl,CopyPage1To0
  call  docopy

  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,%1100 0011
  ld    (BuildButtonTable+0*BuildButtonTableLenghtPerButton),a ;castle
  ld    (BuildButtonTable+1*BuildButtonTableLenghtPerButton),a ;market place
  ld    (BuildButtonTable+2*BuildButtonTableLenghtPerButton),a ;tavern
  ld    (BuildButtonTable+3*BuildButtonTableLenghtPerButton),a ;magic guild
  ld    (BuildButtonTable+4*BuildButtonTableLenghtPerButton),a ;sawmill
  ld    (BuildButtonTable+5*BuildButtonTableLenghtPerButton),a ;mine
  ld    (BuildButtonTable+6*BuildButtonTableLenghtPerButton),a ;barracks
  ld    (BuildButtonTable+7*BuildButtonTableLenghtPerButton),a ;barracks tower
  ld    (BuildButtonTable+8*BuildButtonTableLenghtPerButton),a ;city walls

  ld    hl,SetSingleBuildButtonColor.putgreen
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetCastleBuildInterruptHandler
	
  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,CastleOverviewCode

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;9 build buttons
  ld    ix,BuildButtonTable 
  call  CheckButtonMouseInteractionBuildButtons

  ld    ix,BuildButtonTable
  call  SetBuildButtons                 ;copies button state from rom -> vram
  call  SetTextBuildingWhenClicked      ;when a building is clicked display text on the right side
  ;/9 build buttons

  call  SetVandXSymbols


  ;single build button
  ld    ix,SingleBuildButtonTable 
  call  CheckButtonMouseInteractionSingleBuildButton

  ld    ix,SingleBuildButtonTable
  call  SetSingleBuildButton            ;copies button state from rom -> vram
  ;/single build button

  call  WaitVblank
  call  SetScreenOn
  jp  .engine

lineintheightCastleBuild: equ 14
SetCastleBuildInterruptHandler:
  di
  ld    hl,CastleInterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
 
  ld    a,(VDP_0)           ;set ei1
  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  out   ($99),a

  ld    a,lineintheightCastleBuild
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  ei
  out   ($99),a 
  ret

xOffsetVandX: equ 39
YOffsetVandX: equ +0

BlueBuildButton:  equ $4000 + (000*128) + (000/2) - 128
GreenBuildButton: equ $4000 + (000*128) + (150/2) - 128
RedBuildButton:   equ $4000 + (038*128) + (050/2) - 128


SetVandXSymbols:
  ;castle
  ld    hl,(BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetGreenButton

  ;market place
  ld    hl,(BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetGreenButton

  ;tavern place
  ld    hl,(BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetGreenButton

  ;magic guild
  ld    hl,(BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetGreenButton

  ;sawmill
  ld    hl,(BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetGreenButton

  ;mine
  ld    hl,(BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetGreenButton

  ;barracks
  ld    hl,(BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetGreenButton

  ;barracks tower
  ld    hl,(BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetGreenButton

  ;city walls
  ld    hl,(BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetGreenButton

  ;castle
  ld    hl,(BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetRedButton

  ;market place
  ld    hl,(BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetRedButton

  ;tavern place
  ld    hl,(BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetRedButton

  ;magic guild
  ld    hl,(BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetRedButton

  ;sawmill
  ld    hl,(BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetRedButton

  ;mine
  ld    hl,(BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetRedButton

  ;barracks
  ld    hl,(BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (004 + xOffsetVandX)
  call  z,.SetRedButton

  ;barracks tower
  ld    hl,(BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (064 + xOffsetVandX)
  call  z,.SetRedButton

  ;city walls
  ld    hl,(BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (124 + xOffsetVandX)
  call  z,.SetRedButton
  ret

.SetGreenButton:
  ld    hl,$4000 + (114*128) + (200/2) - 128  ;y,x
  ld    bc,$0000 + (017*256) + (018/2)        ;ny,nx
  ld    a,ButtonsBuildBlock      ;font graphics block
  call  CopyTransparantImage
  ret

.SetRedButton:
  ld    hl,$4000 + (115*128) + (218/2) - 128  ;y,x
  ld    bc,$0000 + (016*256) + (014/2)        ;ny,nx
  ld    a,ButtonsBuildBlock      ;font graphics block
  call  CopyTransparantImage
  ret


CopyTransparantImageEXX:
  ex    af,af'
  exx
;  Example of input:
;  ld    de,256*(42+YOffsetVandX) + (064 + xOffsetVandX)
;  ld    hl,$4000 + (114*128) + (200/2) - 128  ;y,x
;  ld    bc,$0000 + (017*256) + (018/2)        ;ny,nx
;  ld    a,ButtonsBuildBlock      ;font graphics block
CopyTransparantImage: 
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  push  af
  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a
  pop   af

  push  de
  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  pop   de

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  jp    docopy

CheckButtonMouseInteractionSingleBuildButton:  
  bit   7,(ix+BuildButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+BuildButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+BuildButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonXright)
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
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+BuildButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+BuildButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  

  
  ld    (ix+BuildButtonStatus),%1010 0011

  ;only build if single build button is blue
  ld    a,(SingleBuildButtonTable+1)
  ld    e,a
  ld    a,(SingleBuildButtonTable+2)
  ld    d,a
  ld    hl,$4000 + (148*128) + (144/2) - 128
  xor   a
  sbc   hl,de
  ret   nz
  

  ld    a,(WhichBuildingWasClicked?)
  cp    1                                     ;city walls
  jr    z,.CityWalls
  cp    2                                     ;barracks tower
  jr    z,.BarracksTower
  cp    3                                     ;barracks
  jr    z,.Barracks
  cp    4                                     ;mine
  jr    z,.Mine
  cp    5                                     ;sawmill
  jr    z,.Sawmill
  cp    6                                     ;magic guild
  jr    z,.MagicGuild
  cp    7                                     ;tavern
  jr    z,.Tavern
  cp    8                                     ;market place
  jr    z,.MarketPlace
  cp    9                                     ;castle
  jr    z,.Castle

  .CityWalls:  
  .Castle:
  ld    a,(iy+CastleLevel)
  cp    5
  jr    z,.CityWallsNewBuilding
  inc   (iy+CastleLevel)
  jp    PurchaseBuilding
  .CityWallsNewBuilding:
  ld    a,8                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .MarketPlace:  
  ld    a,7                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .Tavern:
  ld    a,6                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .MagicGuild:
  ld    a,(iy+CastleMageGuildLevel)
  or    a
  jr    z,.MagicGuildNewBuilding
  inc   (iy+CastleMageGuildLevel)
  jp    PurchaseBuilding
  .MagicGuildNewBuilding:
  ld    a,5                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .Sawmill:
  ld    a,(iy+CastleSawmillLevel)
  or    a
  jr    z,.SawmillNewBuilding
  inc   (iy+CastleSawmillLevel)
  jp    PurchaseBuilding
  .SawmillNewBuilding:
  ld    a,3                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .Mine:
  ld    a,(iy+CastleMineLevel)
  or    a
  jr    z,.MineNewBuilding
  inc   (iy+CastleMineLevel)
  jp    PurchaseBuilding
  .MineNewBuilding:
  ld    a,4                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

  .BarracksTower:
  .Barracks:
  ld    a,(iy+CastleBarracksLevel)
  or    a
  jr    z,.BarracksNewBuilding
  cp    5
  jr    z,.BarracksTowerNewBuilding
  inc   (iy+CastleBarracksLevel)
  jp    PurchaseBuilding
  .BarracksTowerNewBuilding:
  ld    a,2                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding
  .BarracksNewBuilding:
  ld    a,1                             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  ld    (SetNewBuilding?),a
  jp    PurchaseBuilding

PurchaseBuilding:
  if    UnlimitedBuildsPerTurn?=0
  ld    (iy+AlreadyBuiltThisTurn?),1
  endif

  ;gold
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    e,(ix+0)
  ld    d,(ix+1)                        ;Gold cost
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;Total Gold Player
  xor   a
  sbc   hl,de
  ld    (ix+0),l
  ld    (ix+1),h                        ;Total Gold Player-Gold cost

  ;wood
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    e,(ix+2)
  ld    d,(ix+3)                        ;wood cost
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+2)
  ld    h,(ix+3)                        ;Total woodPlayer
  xor   a
  sbc   hl,de
  ld    (ix+2),l
  ld    (ix+3),h                        ;Total wood Player-wood cost

  ;ore
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    e,(ix+4)
  ld    d,(ix+5)                        ;ore cost
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+4)
  ld    h,(ix+5)                        ;Total ore Player
  xor   a
  sbc   hl,de
  ld    (ix+4),l
  ld    (ix+5),h                        ;Total ore Player-ore cost

  ;gems
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    e,(ix+6)
  ld    d,(ix+7)                        ;gems cost
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+6)
  ld    h,(ix+7)                        ;Total gems Player
  xor   a
  sbc   hl,de
  ld    (ix+6),l
  ld    (ix+7),h                        ;Total gems Player-gems cost

  ;rubies
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    e,(ix+8)
  ld    d,(ix+9)                        ;rubies cost
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+8)
  ld    h,(ix+9)                        ;Total rubies Player
  xor   a
  sbc   hl,de
  ld    (ix+8),l
  ld    (ix+9),h                        ;Total rubies Player-rubies cost

  pop   af
  jp    CastleOverviewCode
;  jp    CastleOverviewBuildCode


;CheckRequirementsWhichBuilding->
;CityWallsCost:
;.Gold:    dw  2000
;.Wood:    dw  301
;.Ore:     dw  100
;.Gems:    dw  60
;.Rubies:  dw  30






SetSingleBuildButton:                   ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  bit   7,(ix+BuildButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+BuildButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+BuildButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+BuildButtonStatus)
  res   1,(ix+BuildButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+BuildButton_SYSX_Ontouched)
  ld    h,(ix+BuildButton_SYSX_Ontouched+1)
  bit   6,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_MovedOver)
  ld    h,(ix+BuildButton_SYSX_MovedOver+1)
  bit   5,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_Clicked)
  ld    h,(ix+BuildButton_SYSX_Clicked+1)
  .go:

  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$0000 + (168*128) + (180/2) - 128  ;dy,dx
  ld    bc,$0000 + (009*256) + (072/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
;  halt
  ret















Set9BuildButtons:                       ;check which buttons should be blue, green and red
  call  .Castle
  call  .MarketPlace
  call  .Tavern
  call  .MagicGuild
  call  .Sawmill
  call  .Mine
  call  .Barracks
  call  .BarracksTower
  call  .CityWalls
  ret

  .CityWalls:
  ld    de,BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleLevel)
  cp    6
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,CityWallsCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMetCityWalls

  .BarracksTower:
  ld    de,BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleBarracksLevel)
  cp    6
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,BarracksTowerCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMetBarracksTower

  .Barracks:
  ld    de,BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleBarracksLevel)
  cp    5
  jp    nc,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
;  ld    hl,BarracksLevel1Cost





  ld    a,(iy+CastleBarracksLevel)
  or    a
  ld    hl,BarracksLevel1Cost
  jp    z,.BarracksLevelFound
  dec   a
  ld    hl,BarracksLevel2Cost
  jp    z,.BarracksLevelFound
  dec   a
  ld    hl,BarracksLevel3Cost
  jp    z,.BarracksLevelFound
  dec   a
  ld    hl,BarracksLevel4Cost
  jp    z,.BarracksLevelFound
  ld    hl,BarracksLevel5Cost
  .BarracksLevelFound:










  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet


  .Mine:
  ld    de,BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMineLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
;  ld    hl,MineLevel1Cost




  ld    a,(iy+CastleMineLevel)
  or    a
  ld    hl,MineLevel1Cost
  jp    z,.MineLevelFound
  dec   a
  ld    hl,MineLevel2Cost
  jp    z,.MineLevelFound
  ld    hl,MineLevel3Cost
  .MineLevelFound:










  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Sawmill:
  ld    de,BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleSawmillLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
;  ld    hl,SawmillLevel1Cost



  ld    a,(iy+CastleSawmillLevel)
  or    a
  ld    hl,SawmillLevel1Cost
  jp    z,.SawmillLevelFound
  dec   a
  ld    hl,SawmillLevel2Cost
  jp    z,.SawmillLevelFound
  ld    hl,SawmillLevel3Cost
  .SawmillLevelFound:







  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .MagicGuild:
  ld    de,BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMageGuildLevel)
  cp    4
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
;  ld    hl,MagicGuildLevel1Cost



  ld    a,(iy+CastleMageGuildLevel)
  or    a
  ld    hl,MagicGuildLevel1Cost
  jp    z,.MagicGuildLevelFound
  dec   a
  ld    hl,MagicGuildLevel2Cost
  jp    z,.MagicGuildLevelFound
  dec   a
  ld    hl,MagicGuildLevel3Cost
  jp    z,.MagicGuildLevelFound
  ld    hl,MagicGuildLevel4Cost
  .MagicGuildLevelFound:











  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Tavern:
  ld    de,BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton)
  bit   0,(iy+CastleTavern)
  jp    nz,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,TavernCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet
  
  .MarketPlace:
  ld    de,BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton)
  bit   0,(iy+CastleMarket)
  jp    nz,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MarketPlaceCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet
    
  .Castle:
  ld    de,BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton)
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red

  ld    a,(iy+CastleLevel)
  cp    5
  jp    nc,.Green

  ld    a,(iy+CastleLevel)
  cp    1
  ld    hl,CastleLevel2Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    z,.CheckRequirementsBuildingMetCastleLevel2

  cp    2
  ld    hl,CastleLevel3Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    z,.CheckRequirementsBuildingMetCastleLevel3

  cp    3
  ld    hl,CastleLevel4Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    z,.CheckRequirementsBuildingMet

;  cp    4
  ld    hl,CastleLevel5Cost
  ld    (CheckRequirementsWhichBuilding?),hl
;  jp    z,.CheckRequirementsBuildingMet
  jp    .CheckRequirementsBuildingMet
  
  .Blue:
  ld    hl,.BlueButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret
  
  .Red:
  ld    hl,.RedButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret
  
  .Green:
  ld    hl,.GreenButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret

.BlueButton:  dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128
.GreenButton: dw $4000 + (000*128) + (150/2) - 128 | dw $4000 + (000*128) + (200/2) - 128 | dw $4000 + (038*128) + (000/2) - 128
.RedButton:   dw $4000 + (038*128) + (050/2) - 128 | dw $4000 + (038*128) + (100/2) - 128 | dw $4000 + (038*128) + (150/2) - 128

.CheckRequirementsBuildingMetCastleLevel2:
  ld    a,(iy+CastleTavern)             ;tavern is required for CastleLevel2
  or    a
  jp    z,.Red
  jp    .CheckRequirementsBuildingMet

.CheckRequirementsBuildingMetCastleLevel3:
  ld    a,(iy+CastleMarket)             ;market place is required for CastleLevel3
  or    a
  jp    z,.Red
  ld    a,(iy+CastleMageGuildLevel)     ;magic guild is required for CastleLevel3
  or    a
  jp    z,.Red
  jp    .CheckRequirementsBuildingMet

.CheckRequirementsBuildingMetBarracksTower:
  ld    a,(iy+CastleBarracksLevel)      ;barracks 5 is required for barracks tower
  cp    5
  jp    nz,.Red
  jp    .CheckRequirementsBuildingMet

.CheckRequirementsBuildingMetCityWalls:
  ld    a,(iy+CastleLevel)              ;castle level 5 is required for city walls
  cp    5
  jp    nz,.Red
  jp    .CheckRequirementsBuildingMet

.CheckRequirementsBuildingMet:
  ;check if gold requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;Gold
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+0)
  ld    b,(ix+1)                        ;Gold
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if wood requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+2)
  ld    h,(ix+3)                        ;Wood
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+2)
  ld    b,(ix+3)                        ;Wood
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if ore requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+4)
  ld    h,(ix+5)                        ;Ore
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+4)
  ld    b,(ix+5)                        ;Ore
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if gems requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+6)
  ld    h,(ix+7)                        ;Gems
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+6)
  ld    b,(ix+7)                        ;Gems
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if rubies requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+8)
  ld    h,(ix+9)                        ;Rubies
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+8)
  ld    b,(ix+9)                        ;Rubies
  xor   a
  sbc   hl,bc
  jp    c,.Red  
  jp    .Blue  

SetSingleBuildButtonColor:
  push  iy

  ld    a,(WhichBuildingWasClicked?)

  cp    1                                     ;city walls
  ld    iy,BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    2                                     ;barracks tower
  ld    iy,BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    3                                     ;barracks
  ld    iy,BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    4                                     ;mine
  ld    iy,BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    5                                     ;sawmill
  ld    iy,BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    6                                     ;magic guild
  ld    iy,BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    7                                     ;tavern
  ld    iy,BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    8                                     ;market place
  ld    iy,BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    9                                     ;castle
  ld    iy,BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound


  .BuildingFound:
  ld    e,(iy)
  ld    d,(iy+1)                              ;Button_SYSX_Ontouched

  pop   iy

  ld    hl,$4000 + (000*128) + (000/2) - 128  ;blue button
  xor   a
  sbc   hl,de
  jr    z,.blue
  
  ld    hl,$4000 + (000*128) + (150/2) - 128  ;green button
  xor   a
  sbc   hl,de
  jr    z,.green

  ld    hl,$4000 + (038*128) + (050/2) - 128  ;red button
  xor   a
  sbc   hl,de
  jr    z,.red

  
  .red:
  ld    hl,.putred
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret
  
  .green:
  ld    hl,.putgreen
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret
  
  .blue:
  ld    hl,.putblue
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret

.putred:    db  %1100 0011 | dw $4000 + (148*128) + (072/2) - 128 | dw $4000 + (148*128) + (072/2) - 128 | dw $4000 + (148*128) + (072/2) - 128
.putgreen:  db  %1100 0011 | dw $4000 + (148*128) + (000/2) - 128 | dw $4000 + (148*128) + (000/2) - 128 | dw $4000 + (148*128) + (000/2) - 128
.putblue:   db  %1100 0011 | dw $4000 + (148*128) + (144/2) - 128 | dw $4000 + (157*128) + (000/2) - 128 | dw $4000 + (157*128) + (072/2) - 128






































CheckButtonMouseInteractionBuildButtons:
  ld    b,9
  ld    de,BuildButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+BuildButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+BuildButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+BuildButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonXright)
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
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+BuildButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+BuildButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+BuildButtonStatus),%1010 0011

  ld    a,3
  ld    (SetTextBuilding),a

  ld    a,b
  cp    1                                     ;CityWalls
  jp    z,.CityWalls
  cp    2                                     ;BarracksTower
  jp    z,.BarracksTower
  cp    3                                     ;Barracks
  jp    z,.Barracks
  cp    4                                     ;Mine
  jp    z,.Mine
  cp    5                                     ;Sawmill
  jp    z,.Sawmill
  cp    6                                     ;MagicGuild
  jp    z,.MagicGuild
  cp    7                                     ;Tavern
  jp    z,.Tavern
  cp    8                                     ;MarketPlace
  jp    z,.MarketPlace
  cp    9                                     ;Castle
  jp    z,.Castle

  .MarketPlace:
  ld    a,(iy+CastleMarket)
  or    a
  ld    de,MarketPlaceCost
  ld    hl,TextMarketPlace
  jp    z,.SetWhichTextToPut
  ld    hl,TextMarketPlaceFinished
  jp    .SetWhichTextToPut

  .Tavern:
  ld    a,(iy+CastleTavern)
  or    a
  ld    de,TavernCost
  ld    hl,TextTavern
  jp    z,.SetWhichTextToPut
  ld    hl,TextTavernFinished
  jp    .SetWhichTextToPut

  .BarracksTower:
  ld    a,(iy+CastleBarracksLevel)
  cp    6
  ld    de,BarracksTowerCost
  ld    hl,TextBarracksTower
  jp    nz,.SetWhichTextToPut
  ld    hl,TextBarracksTowerFinished
  jp    .SetWhichTextToPut

  .CityWalls:
  ld    a,(iy+CastleLevel)
  cp    6
  ld    de,CityWallsCost
  ld    hl,TextCityWalls
  jp    nz,.SetWhichTextToPut
  ld    hl,TextCityWallsFinished
  jp    .SetWhichTextToPut
  
  .Barracks:
  ld    a,(iy+CastleBarracksLevel)
  cp    0
  ld    de,BarracksLevel1Cost
  ld    hl,TextBarracksLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    de,BarracksLevel2Cost
  ld    hl,TextBarracksLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    de,BarracksLevel3Cost
  ld    hl,TextBarracksLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    de,BarracksLevel4Cost
  ld    hl,TextBarracksLevel4
  jp    z,.SetWhichTextToPut
  cp    4
  ld    de,BarracksLevel5Cost
  ld    hl,TextBarracksLevel5
  jp    z,.SetWhichTextToPut
  ld    hl,TextBarracksLevel5Finished
  jp    .SetWhichTextToPut

  .Mine:
  ld    a,(iy+CastleMineLevel)
  cp    0
  ld    de,MineLevel1Cost
  ld    hl,TextMineLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    de,MineLevel2Cost
  ld    hl,TextMineLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    de,MineLevel3Cost
  ld    hl,TextMineLevel3
  jp    z,.SetWhichTextToPut
  ld    hl,TextMineLevel3Finished
  jp    .SetWhichTextToPut

  .Sawmill:
  ld    a,(iy+CastleSawmillLevel)
  cp    0
  ld    de,SawmillLevel1Cost  
  ld    hl,TextSawmillLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    de,SawmillLevel2Cost  
  ld    hl,TextSawmillLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    de,SawmillLevel3Cost  
  ld    hl,TextSawmillLevel3
  jp    z,.SetWhichTextToPut
  ld    hl,TextSawmillLevel3Finished
  jp    .SetWhichTextToPut

  .MagicGuild:
  ld    a,(iy+CastleMageGuildLevel)
  cp    0
  ld    de,MagicGuildLevel1Cost
  ld    hl,TextMagicGuildLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    de,MagicGuildLevel2Cost
  ld    hl,TextMagicGuildLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    de,MagicGuildLevel3Cost
  ld    hl,TextMagicGuildLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    de,MagicGuildLevel4Cost
  ld    hl,TextMagicGuildLevel4
  jp    z,.SetWhichTextToPut
  ld    hl,TextMagicGuildLevel4Finished
  jp    .SetWhichTextToPut

  .Castle:
  ld    a,(iy+CastleLevel)
  cp    1
  ld    de,CastleLevel2Cost
  ld    hl,TextCastleLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    de,CastleLevel3Cost
  ld    hl,TextCastleLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    de,CastleLevel4Cost
  ld    hl,TextCastleLevel4
  jp    z,.SetWhichTextToPut
  cp    4
  ld    de,CastleLevel5Cost
  ld    hl,TextCastleLevel5
  jp    z,.SetWhichTextToPut
  ld    hl,TextCastleLevel5Finished
  jp    .SetWhichTextToPut

  .SetWhichTextToPut:
  ld    (CheckRequirementsWhichBuilding?),de
  ld    (PutWhichBuildText),hl
  ld    a,b
  ld    (WhichBuildingWasClicked?),a
  ret

TextCastleLevel2:        
                          db  "   Town Hall",254
                          db  " ",254
                          db  "Generates 1000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2500 Gold",254
                          db  " ",254
                          db  "Requirements:",254
                          db  "Tavern",255

;ds $3000


CastleLevel2Cost:             ;Town Hall
.Gold:    dw  2500
.Wood:    dw  000
.Ore:     dw  000
.Gems:    dw  000
.Rubies:  dw  000



TextCastleLevel3:        
                          db  "   City Hall",254
                          db  " ",254
                          db  "Generates 2000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "5000 Gold",254
                          db  " ",254
                          db  "Requirements:",254
                          db  "Magic Guild",254
                          db  "Level 1",254
                          db  "Market Place",255

CastleLevel3Cost:             ;City Hall
.Gold:    dw  5000
.Wood:    dw  000
.Ore:     dw  000
.Gems:    dw  000
.Rubies:  dw  000

TextCastleLevel4:        
                          db  "    Citadel",254
                          db  " ",254
                          db  "Generates 3000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "increases the",254
                          db  "production of",254
                          db  "all creatures",254
                          db  "by 50%",254
                          db  " ",254
                          db  "Cost:",254
                          db  "7500 Gold",254
                          db  "+10 wood",254
                          db  "+10 ore",255

CastleLevel4Cost:             ;Citadel
.Gold:    dw  7500
.Wood:    dw  010
.Ore:     dw  010
.Gems:    dw  000
.Rubies:  dw  000

TextCastleLevel5:        
                          db  "    Capitol",254
                          db  " ",254
                          db  "Generates 4000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "increases the",254
                          db  "production of",254
                          db  "all creatures",254
                          db  "by 100%",254
                          db  " ",254
                          db  "Cost:",254
                          db  "10000 Gold",254
                          db  "+20 wood",254
                          db  "+20 ore",255
TextCastleLevel5Finished:        
                          db  "    Capitol",254
                          db  " ",254
                          db  "Generates 4000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "increases the",254
                          db  "production of",254
                          db  "all creatures",254
                          db  "by 100%",255

CastleLevel5Cost:             ;Capitol
.Gold:    dw  10000
.Wood:    dw  020
.Ore:     dw  020
.Gems:    dw  000
.Rubies:  dw  000

TextMarketPlace:        
                          db  "  Market Place",254
                          db  " ",254
                          db  "Facilitates the",254
                          db  "commerce of",254
                          db  "crucial resources",254
                          db  " ",254
                          db  "Cost:",254
                          db  "500 Gold",254
                          db  "+5 Wood",255
TextMarketPlaceFinished:        
                          db  "  Market Place",254
                          db  " ",254
                          db  "Facilitates the",254
                          db  "commerce of",254
                          db  "crucial resources",255

MarketPlaceCost:
.Gold:    dw  500
.Wood:    dw  05
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextTavern:        
                          db  "    Tavern",254
                          db  " ",254
                          db  "Grants the ",254
                          db  "capability to",254
                          db  "enlist visiting",254
                          db  "heroes into",254
                          db  "service",254
                          db  " ",254
                          db  "Cost:",254
                          db  "500 Gold",254
                          db  "+5 Wood",255
TextTavernFinished:        
                          db  "    Tavern",254
                          db  " ",254
                          db  "Grants the ",254
                          db  "capability to",254
                          db  "enlist visiting",254
                          db  "heroes into",254
                          db  "service",255
                          
TavernCost:
.Gold:    dw  500
.Wood:    dw  05
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextMagicGuildLevel1:        
                          db  " Magic Guild 1",254
                          db  " ",254
                          db  "Adds two level 1",254
                          db  "spells to the",254
                          db  "magic guild",254
                          db  " ",254
                          db  "An overnight stay",254
                          db  "at the Castle",254
                          db  "completely refills",254
                          db  "heroes' magic",254
                          db  "points.",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",255

MagicGuildLevel1Cost:
.Gold:    dw  2000
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  00
.Rubies:  dw  00

TextMagicGuildLevel2:        
                          db  " Magic Guild 2",254
                          db  " ",254
                          db  "Adds two level 2",254
                          db  "spells to the",254
                          db  "magic guild",254
                          db  " ",254
                          db  "Visiting heroes",254
                          db  "can learn these",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",254
                          db  "+5 Gems",254
                          db  "+5 Rubies",255

MagicGuildLevel2Cost:
.Gold:    dw  1000
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  05
.Rubies:  dw  05

TextMagicGuildLevel3:        
                          db  " Magic Guild 3",254
                          db  " ",254
                          db  "Adds two level 3",254
                          db  "spells to the",254
                          db  "magic guild",254
                          db  " ",254
                          db  "Visiting heroes",254
                          db  "can learn these",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",254
                          db  "+10 Gems",254
                          db  "+10 Rubies",255

MagicGuildLevel3Cost:
.Gold:    dw  1000
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  10
.Rubies:  dw  10

TextMagicGuildLevel4:        
                          db  " Magic Guild 4",254
                          db  " ",254
                          db  "Adds two level 4",254
                          db  "spells to the",254
                          db  "magic guild",254
                          db  " ",254
                          db  "Visiting heroes",254
                          db  "can learn these",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",254
                          db  "+15 Gems",254
                          db  "+15 Rubies",255
TextMagicGuildLevel4Finished:        
                          db  " Magic Guild 4",254
                          db  " ",254
                          db  "Adds two level 4",254
                          db  "spells to the",254
                          db  "magic guild",254
                          db  " ",254
                          db  "Visiting heroes",254
                          db  "can learn these",254
                          db  "spells if their",254
                          db  "skill requirements",254
                          db  "are met",255
MagicGuildLevel4Cost:
.Gold:    dw  1000
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  15
.Rubies:  dw  15

TextSawmillLevel1:        
                          db  "  Sawmill 1",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+1 wood",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",255

SawmillLevel1Cost:
.Gold:    dw  1000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextSawmillLevel2:        
                          db  "  Sawmill 2",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+2 wood",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1500 Gold",255

SawmillLevel2Cost:
.Gold:    dw  1500
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextSawmillLevel3:        
                          db  "  Sawmill 3",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+3 wood",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextSawmillLevel3Finished:        
                          db  "  Sawmill 3",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+3 wood",254
                          db  "per day",255
SawmillLevel3Cost:
.Gold:    dw  2000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextMineLevel1:        
                          db  "   Mine 1",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+1 ore",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",255

MineLevel1Cost:
.Gold:    dw  1000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextMineLevel2:        
                          db  "   Mine 2",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+2 ore",254
                          db  "+1 gem",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "3000 Gold",255

MineLevel2Cost:
.Gold:    dw  3000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextMineLevel3:        
                          db  "   Mine 3",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+3 ore",254
                          db  "+1 gem",254
                          db  "+1 ruby",254
                          db  "per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "5000 Gold",255
TextMineLevel3Finished:        
                          db  "   Mine 3",254
                          db  " ",254
                          db  "Produces:",254
                          db  "+3 ore",254
                          db  "+1 gem",254
                          db  "+1 ruby",254
                          db  "per day",255
                          
MineLevel3Cost:
.Gold:    dw  5000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksLevel1:        
                          db  "  Barracks 1",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 1 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "500 Gold",254
                          db  "+10 Ore",255

BarracksLevel1Cost:
.Gold:    dw  500
.Wood:    dw  00
.Ore:     dw  10
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksLevel2:        
                          db  "  Barracks 2",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 2 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1000 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",255

BarracksLevel2Cost:
.Gold:    dw  1000
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksLevel3:        
                          db  "  Barracks 3",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 3 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1500 Gold",254
                          db  "+15 Ore",255

BarracksLevel3Cost:
.Gold:    dw  1500
.Wood:    dw  00
.Ore:     dw  15
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksLevel4:        
                          db  "  Barracks 4",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 4 creatures",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "1500 Gold",254
                          db  "+5 Wood",254
                          db  "+5 Ore",254
                          db  "+4 Gems",254
                          db  "+4 Rubies",255

BarracksLevel4Cost:
.Gold:    dw  1500
.Wood:    dw  05
.Ore:     dw  05
.Gems:    dw  04
.Rubies:  dw  04

TextBarracksLevel5:        
                          db  "  Barracks 5",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 5 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "5000 Gold",254
                          db  "+20 Wood",255
TextBarracksLevel5Finished:
                          db  "  Barracks 5",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 5 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",255


BarracksLevel5Cost:
.Gold:    dw  5000
.Wood:    dw  20
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksTower:        
                          db  " Barracks Tower",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 6 creatures",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "20000 Gold",254
                          db  "+20 Gems",254
                          db  "+20 Rubies",254
                          db  " ",254
                          db  "Requirements:",254
                          db  "Barracks 5",255
TextBarracksTowerFinished:        
                          db  " Barracks Tower",254
                          db  " ",254
                          db  "Manufactures",254
                          db  "level 6 creatures",254
                          db  "each bearing",254
                          db  "their own unique",254
                          db  "attributes and",254
                          db  "powers",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",255
                          
BarracksTowerCost:
.Gold:    dw  20000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  20
.Rubies:  dw  20

TextCityWalls:        
                          db  "   City Walls",254
                          db  " ",254
                          
                          db  "Strengthens city",254
                          db  "defenses with",254
                          db  "fortified walls,",254
                          db  "granting heroes in",254
                          db  "the defending hero",254
                          db  "slot + 5 defense",254
                          
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "+15 Wood",254
                          db  "+15 Ore",254
                          db  " ",254
                          db  "Requirements:",254
                          db  "Capitol",255
TextCityWallsFinished:        
                          db  "   City Walls",254
                          db  " ",254
                          db  "Enhances your",254
                          db  "city's security",254
                          db  "through fortified",254
                          db  "walls that stand",254
                          db  "resolute against",254
                          db  "relentless sieges",254
                          db  " ",254
                          db  "The defending hero",254
                          db  "slot grants heroes",254
                          db  "+5 defense",255




CityWallsCost:
.Gold:    dw  2000
.Wood:    dw  15
.Ore:     dw  15
.Gems:    dw  00
.Rubies:  dw  00












SetBuildButtons:                        ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,9
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,BuildButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+BuildButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+BuildButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+BuildButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+BuildButtonStatus)
  res   1,(ix+BuildButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+BuildButton_SYSX_Ontouched)
  ld    h,(ix+BuildButton_SYSX_Ontouched+1)
  bit   6,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_MovedOver)
  ld    h,(ix+BuildButton_SYSX_MovedOver+1)
  bit   5,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_Clicked)
  ld    h,(ix+BuildButton_SYSX_Clicked+1)
  .go:

  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  ld    bc,$0000 + (038*256) + (050/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyBuildButton+dPage),a
	ld    (CopyBuildButtonImage+dPage),a

  ;set dx, dy button and button image
  ld    a,(ix+BuildButtonYtop)
  ld    (CopyBuildButton+dy),a
  ld    (CopyBuildButtonImage+dy),a
  ld    a,(ix+BuildButtonXleft)
  ld    (CopyBuildButton+dx),a
  ld    (CopyBuildButtonImage+dx),a

  ld    hl,CopyBuildButton
  call  docopy

  ;copy image on top of button
  ld    l,(ix+BuildButtonImage_SYSX)
  ld    h,(ix+BuildButtonImage_SYSX+1)
  ld    de,$8000 + (212*128) + (050/2) - 128  ;dy,dx
  ld    bc,$0000 + (033*256) + (050/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
  ld    hl,CopyBuildButtonImage
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret



















TextGoldPerDay: db "Gold/day",255

SetNameCastleAndDailyIncome:
  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
  ld    b,200
  ld    c,2

  push  iy
  pop   hl
  ld    de,CastleName
  add   hl,de
  call  SetText

  ld    c,009                           ;dy
  ld    b,196+004                       ;dx

  ld    a,(iy+CastleLevel)
  cp    1                               ;village hall (500 gold per day)
  ld    hl,500
  jr    z,.CastleLevelFound

  ld    b,196                           ;dx

  cp    2                               ;town hall (1000 gold per day). costs: 2500 gold, requires tavern
  ld    hl,1000
  jr    z,.CastleLevelFound

  cp    3                               ;city hall (2000 gold per day). costs: 5000 gold, requires mage guild level 1, market place
  ld    hl,2000
  jr    z,.CastleLevelFound

  cp    4                               ;citadel (3000 gold per day). increase creature production by 50%. costs: 7500 gold +10 wood +10 ore
  ld    hl,3000
  jr    z,.CastleLevelFound

  cp    5                               ;capitol (4000 gold per day). increase creature production by 100%. costs: 10000 gold +20 wood +20 ore
  ld    hl,4000
  jr    z,.CastleLevelFound
  
  .CastleLevelFound:

  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    b,219
  ld    c,009
  ld    hl,TextGoldPerDay
  call  SetText
  ret

HandleAllHeroesLearnMagicGuildSpells:
  push  iy
  
  ld    ix,pl1hero1y
  ld    b,amountofheroesperplayer
  call  .loop
  ld    ix,pl2hero1y
  ld    b,amountofheroesperplayer
  call  .loop
  ld    ix,pl3hero1y
  ld    b,amountofheroesperplayer
  call  .loop
  ld    ix,pl4hero1y
  ld    b,amountofheroesperplayer
  call  .loop

  pop   iy
  ret

  .loop:
  call  .CheckHero
  ld    de,lenghtherotable
  add   ix,de
  djnz  .loop
  ret

  .CheckHero:  
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    2
  jr    z,.CheckWhichCastle
  cp    254
  ret   nz

  .CheckWhichCastle:                    ;at this point hero is in castle, find castle and put in IY
  ld    iy,Castle1
  call  .FindCastle
  ld    iy,Castle2
  call  .FindCastle
  ld    iy,Castle3
  call  .FindCastle
  ld    iy,Castle4
  call  .FindCastle
  ld    iy,Castle5
  call  .FindCastle
  ret

  .FindCastle:
  ld    a,(ix+HeroY)                    ;y hero
  inc   a                               ;y hero + 1
  cp    (iy+CastleY)
  ret   nz

  ld    a,(ix+HeroX)                    ;x hero (2)
  dec   a                               ;a=x hero-1
  dec   a                               ;a=x hero-1
  cp    (iy+CastleX)
  ret   nz
  ;castle found
  pop   af                              ;no need to check the other castles

  ld    b,(iy+CastleMageGuildLevel)     ;b=mage guild level
  
  push  ix


                      ;E4E3E2E1   F4F3F2F1   A4A3A2A1   W4W3W2W1
;Castle1Spells:   db  % 1 1 0 0, % 0 1 0 1, % 1 0 1 0, % 0 0 1 1
;Castle2Spells:   db  % 0 1 1 0, % 1 0 1 0, % 0 1 0 1, % 1 0 0 1
;Castle3Spells:   db  % 0 0 1 1, % 0 1 0 1, % 1 0 1 0, % 1 1 0 0
;Castle4Spells:   db  % 1 0 0 1, % 1 0 1 0, % 0 1 0 1, % 0 1 1 0


  call  SetCastleSpellsInIX             ;ix=castle spells
  pop   iy                              ;iy=heroy

  ld    c,(ix+0)                        ;earth spell belonging to this castle's mage guild
  call  .CheckLevel234SpellsPossibleToLearn
  ld    a,c
  or    (iy+HeroEarthSpells)
  ld    (iy+HeroEarthSpells),a
  ld    c,(ix+1)                        ;fire spell belonging to this castle's mage guild
  call  .CheckLevel234SpellsPossibleToLearn
  ld    a,c
  or    (iy+HeroFireSpells)
  ld    (iy+HeroFireSpells),a
  ld    c,(ix+2)                        ;air spell belonging to this castle's mage guild
  call  .CheckLevel234SpellsPossibleToLearn
  ld    a,c
  or    (iy+HeroAirSpells)
  ld    (iy+HeroAirSpells),a
  ld    c,(ix+3)                        ;water spell belonging to this castle's mage guild
  call  .CheckLevel234SpellsPossibleToLearn
  ld    a,c
  or    (iy+HeroWaterSpells)
  ld    (iy+HeroWaterSpells),a
  
  push  iy
  pop   ix                              ;back to heroy in ix, and go check next hero
  ret

.CheckLevel234SpellsPossibleToLearn:    ;in: c=spells belonging to this castle's mage guild (;E4E3E2E1   F4F3F2F1   A4A3A2A1   W4W3W2W1)
  call  .CheckMageGuildLevel

  ;CAUTION IY=Heroy
  ld    a,30                            ;expert wisdom skill
  cp    (iy+HeroSkills+0)
  ret   z
  cp    (iy+HeroSkills+1)
  ret   z
  cp    (iy+HeroSkills+2)
  ret   z
  cp    (iy+HeroSkills+3)
  ret   z
  cp    (iy+HeroSkills+4)
  ret   z
  cp    (iy+HeroSkills+5)
  ret   z

  res   3,c                             ;without expert wisdom level 4 spells are not possible to learn

  ld    a,29                            ;advanced wisdom skill
  cp    (iy+HeroSkills+0)
  ret   z
  cp    (iy+HeroSkills+1)
  ret   z
  cp    (iy+HeroSkills+2)
  ret   z
  cp    (iy+HeroSkills+3)
  ret   z
  cp    (iy+HeroSkills+4)
  ret   z
  cp    (iy+HeroSkills+5)
  ret   z

  res   2,c                             ;without advanced wisdom level 3 spells are not possible to learn

  ld    a,28                            ;basic wisdom skill
  cp    (iy+HeroSkills+0)
  ret   z
  cp    (iy+HeroSkills+1)
  ret   z
  cp    (iy+HeroSkills+2)
  ret   z
  cp    (iy+HeroSkills+3)
  ret   z
  cp    (iy+HeroSkills+4)
  ret   z
  cp    (iy+HeroSkills+5)
  ret   z

  res   1,c                             ;without basic wisdom level 2 spells are not possible to learn
  ret

.CheckMageGuildLevel:
  ld    a,b                             ;b=mage guild level
  cp    4
  ret   z
  res   3,c                             ;without mage guild level 4, level 4 spells are not possible to learn

  cp    3
  ret   z
  res   2,c                             ;without mage guild level 3, level 3 spells are not possible to learn

  cp    2
  ret   z
  res   1,c                             ;without mage guild level 2, level 2 spells are not possible to learn
  
  cp    1
  ret   z
  res   0,c                             ;without mage guild level 1, level 1 spells are not possible to learn
  ret

                      ;E4E3E2E1   F4F3F2F1   A4A3A2A1   W4W3W2W1
;Castle1Spells:   db  % 1 1 0 0, % 0 1 0 1, % 1 0 1 0, % 0 0 1 1
;Castle2Spells:   db  % 0 1 1 0, % 1 0 1 0, % 0 1 0 1, % 1 0 0 1
;Castle3Spells:   db  % 0 0 1 1, % 0 1 0 1, % 1 0 1 0, % 1 1 0 0
;Castle4Spells:   db  % 1 0 0 1, % 1 0 1 0, % 0 1 0 1, % 0 1 1 0


CastleOverviewCode:                     ;in: iy-castle
  call  SetInterruptHandler             ;normal ingame interrupt handler

  ld    a,3
	ld		(SetResources?),a

;What we do here is check if visiting hero and defending hero are the same when entering and leaving castle
;if they are not the same, then reset active hero in game

  ;store current visiting and defending heroes
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  push  ix
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  push  ix
  ;/store current visiting and defending heroes

  call  .goEnterCastle

  ;compare old visiting and defending heroes with new
  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  push  ix
  pop   hl
  pop   de
  call  CompareHLwithDE                 ;check if 
  jr    z,.Same

  pop   af  
  jp    ActivateFirstActiveHeroForCurrentPlayer  
  
  .Same:
  ld    c,254                           ;check if hero status=002 (visiting) or 254 (defending)
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  push  ix
  pop   hl
  pop   de
  call  CompareHLwithDE                 ;check if 
  ret   z
  jp    ActivateFirstActiveHeroForCurrentPlayer  
  ;/compare old visiting and defending heroes with new
  .goEnterCastle:

  call  SetScreenOff

  ld    hl,CastleOverviewPalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  ld    a,(ShowNewlyBoughtBuildingFadingIn?)
  or    a
  jr    nz,.EndCheckShowNewlyBoughtBuilding
  call  EnableNewBuilding
  xor   a
  ld    (SetNewBuilding?),a
  .EndCheckShowNewlyBoughtBuilding:

  call  SetCastleOverviewGraphics       ;put gfx in page 1
  call  SwapAndSetPage                  ;swap to and set page 1
  call  SetIndividualBuildings          ;put buildings in page 0, then docopy them from page 0 to page 1 transparantly
  call  SwapAndSetPage                  ;swap to and set page 0 
  call  SetNameCastleAndDailyIncome

  ld    hl,CopyPage1To0
  call  docopy

  call  FadeInNewlyBoughtBuilding

  ld    a,179
  call  SetExitButtonHeight
  call  SetActiveCastleOverviewButtons
  
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  call  HandleAllHeroesLearnMagicGuildSpells

  .engine:
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    ix,CastleOverviewButtonTable ;  ld    iy,ButtonTableArmyIconsSYSX (;deze shit mag erin verwerkt zijn)
  call  CheckButtonMouseInteractionCastleMainScreen

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram

  call  WaitVblank
  call  SetScreenOn    
  jp  .engine

WaitVblank:
  ld    a,(vblankintflag)               ;waiting for vblank gives more stability to the output of the spritedata on vblank
  ld    hl,vblankintflag
  .checkflag:
  cp    (hl)
  jr    z,.checkflag
  ret

CopyPage2To0:
	db		0,0,0,2
	db		0,0,0,0
	db		0,1,212,0
	db		0,0,$d0	
CopyPage0To2:
	db		0,0,0,0
	db		0,0,0,2
	db		0,1,212,0
	db		0,0,$d0	
	
EnableNewBuilding:
  ld    a,(SetNewBuilding?)             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  dec   a
  jr    z,.barracks
  dec   a
  jr    z,.barracksUpgrade
  dec   a
  jr    z,.sawmill
  dec   a
  jr    z,.mine
  dec   a
  jr    z,.mageguild
  dec   a
  jr    z,.tavern
  dec   a
  jr    z,.market
  dec   a
  jr    z,.citywalls
  ret

  .citywalls:
  ld    (iy+CastleLevel),6
  ret

  .market:
  ld    (iy+CastleMarket),1
  ret

  .tavern:
  ld    (iy+CastleTavern),1
  ret

  .mageguild:
  ld    (iy+CastleMageGuildLevel),1
  ret

  .mine:
  ld    (iy+CastleMineLevel),1
  ret

  .sawmill:
  ld    (iy+CastleSawmillLevel),1
  ret

  .barracksUpgrade:
  ld    (iy+CastleBarracksLevel),6
  ret

  .barracks:
  ld    (iy+CastleBarracksLevel),1
  ret

SetVariablesNewBuilding:
  ld    a,(SetNewBuilding?)             ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
  dec   a
  jr    z,.barracks
  dec   a
  jr    z,.barracksUpgrade
  dec   a
  jr    z,.sawmill
  dec   a
  jr    z,.mine
  dec   a
  jr    z,.mageguild
  dec   a
  jr    z,.tavern
  dec   a
  jr    z,.market
  dec   a
  jr    z,.citywalls
  ret

  .citywalls:
  ld    b,CityWallsSX
  ld    c,CityWallsSY
  ld    l,CityWallsSX+CityWallsNX
  ld    h,CityWallsSY+CityWallsNY
  ld    e,1                             ;buildings that touch right edge?
  ret

  .market:
  ld    b,MarketSX
  ld    c,MarketSY
  ld    l,MarketSX+MarketNX
  ld    h,MarketSY+MarketNY
  ld    e,1                             ;buildings that touch right edge?
  ret

  .tavern:
  ld    b,TavernSX
  ld    c,TavernSY
  ld    l,TavernSX+TavernNX
  ld    h,TavernSY+TavernNY
  ld    e,0                             ;buildings that touch right edge?
  ret

  .mageguild:
  ld    b,MageGuildSX
  ld    c,MageGuildSY
  ld    l,MageGuildSX+MageGuildNX
  ld    h,MageGuildSY+MageGuildNY
  ld    e,0                             ;buildings that touch right edge?
  ret

  .mine:
  ld    b,mineSX
  ld    c,mineSY
  ld    l,mineSX+mineNX
  ld    h,mineSY+mineNY
  ld    e,0                             ;buildings that touch right edge?
  ret

  .sawmill:
  ld    b,sawmillSX
  ld    c,sawmillSY
  ld    l,sawmillSX+sawmillNX
  ld    h,sawmillSY+sawmillNY
  ld    e,0                             ;buildings that touch right edge?
  ret

  .barracksUpgrade:
  ld    b,barracksUpgradeSX
  ld    c,barracksUpgradeSY
  ld    l,barracksUpgradeSX+barracksUpgradeNX
  ld    h,barracksUpgradeSY+barracksUpgradeNY
  ld    e,1                             ;buildings that touch right edge?
  ret

  .barracks:
  ld    b,BarracksSX
  ld    c,BarracksSY
  ld    l,BarracksSX+BarracksNX
  ld    h,BarracksSY+BarracksNY
  ld    e,1                             ;buildings that touch right edge?
  ret

  BarracksSX:  equ 176-2
  BarracksSY:  equ 057
  BarracksNX:  equ 080
  BarracksNY:  equ 101

  BarracksUpgradeSX:  equ 202
  BarracksUpgradeSY:  equ 006
  BarracksUpgradeNX:  equ 048 + 5
  BarracksUpgradeNY:  equ 088

  SawMillSX:  equ 032
  SawMillSY:  equ 101
  SawMillNX:  equ 060
  SawMillNY:  equ 035

  MineSX:  equ 050
  MineSY:  equ 126
  MineNX:  equ 126
  MineNY:  equ 052

  MageGuildSX:  equ 000
  MageGuildSY:  equ 019
  MageGuildNX:  equ 048
  MageGuildNY:  equ 168

  TavernSX:  equ 060
  TavernSY:  equ 097
  TavernNX:  equ 158
  TavernNY:  equ 115

  MarketSX:  equ 166
  MarketSY:  equ 106
  MarketNX:  equ 090 - 2
  MarketNY:  equ 088

  CityWallsSX:  equ 000
  CityWallsSY:  equ 185
  CityWallsNX:  equ 255
  CityWallsNY:  equ 027

FadeInNewlyBoughtBuilding:
  ld    a,(SetNewBuilding?)
  or    a
  ret   z

  ld    a,1
  ld    (ReloadAllObjectsInVram?),a     ;THIS ONLY NEEDS TO BE DONE IF WE USED PAGE 2 IN CASTLE (SO WHEN FADING IN NEW BUILDING IN FIRST PAGE)

  ld    a,(VDP_0+8)                     ;sprites off
  or    %00000010
  ld    (VDP_0+8),a
  di
  out   ($99),a
  ld    a,8+128
  ei
  out   ($99),a

  ld    hl,CopyPage0To2
  call  docopy                          ;copy whole castle with old buildings to page 2
  call  SetScreenOn    

  xor   a
	ld		(activepage),a                  ;start in page 0  
  call  SetCastleOverviewGraphics       ;put gfx in page 1
  ld    a,2*32+31
  call  SetPageSpecial.setpage          ;set page 2

  ld    a,1
	ld		(activepage),a                  ;start in page 0

  call  EnableNewBuilding
  call  SetIndividualBuildings          ;put buildings in page 0, then docopy them from page 0 to page 1 transparantly

  xor   a
	ld		(activepage),a                  ;start in page 0  
  call  SetNameCastleAndDailyIncome

  ;at this point we have our old graphics in page 2 and our new graphics (with new building) in page 1

  call  SetVariablesNewBuilding
  ld    d,.AmountOfBuildingSteps
  .AmountOfBuildingSteps:  equ 13

  exx
  ld    c,$9b                             ;outport for docopy
  ld    d,32                              ;value to write to register at docopy
  ld    e,17+128                          ;register for writing at docopy
  exx

  ld    a,b                               ;sx
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart
  call  GoBuildBuildingPart

  ld    hl,CopyPage2To0
  call  docopy
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  xor   a
  ld    (SetNewBuilding?),a

  ld    a,(VDP_0+8)                     ;sprites on
  and   %11111101
  ld    (VDP_0+8),a
  di
  out   ($99),a
  ld    a,8+128
  ei
  out   ($99),a
  ret

GoBuildBuildingPartBuildingThatTouchRightEdge:
  .loop:
  exx
  ld    hl,BuildingFadeIn                  ;copy from page 1 to page 0
  ld    a,d
  di
  out   ($99),a
  ld    a,e
  ei
  out   ($99),a

	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed
  exx
  
  ld    a,(BuildingFadeIn+sx)
  add   a,d                               ;.AmountOfBuildingSteps
  jr    nc,.go
  add   a,b                               ;add sx
  ld    (BuildingFadeIn+sx),a
  ld    (BuildingFadeIn+dx),a

  ld    a,(BuildingFadeIn+sy)
  inc   a
  cp    h                                 ;sy+ny
  ret   nc
  ld    (BuildingFadeIn+sy),a
  ld    (BuildingFadeIn+dy),a
  jp    .loop

  .go:
  ld    (BuildingFadeIn+sx),a
  ld    (BuildingFadeIn+dx),a
  jp    .loop

GoBuildBuildingPart:
  push  af

  ld    (BuildingFadeIn+sx),a
  ld    (BuildingFadeIn+dx),a
  ld    a,c                               ;sy
  ld    (BuildingFadeIn+sy),a
  ld    (BuildingFadeIn+dy),a  
  bit   0,e
  call  nz,GoBuildBuildingPartBuildingThatTouchRightEdge.loop
  bit   0,e
  call  z,.loop

  pop   af
  inc   a
  ret

  .loop:
  exx
  ld    hl,BuildingFadeIn                  ;copy from page 1 to page 0
  ld    a,d
  di
  out   ($99),a
  ld    a,e
  ei
  out   ($99),a

	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed
  exx
  
  ld    a,(BuildingFadeIn+sx)
  add   a,d                               ;.AmountOfBuildingSteps
  cp    l                                 ;sx+nx
  jr    c,.go
  sub   a,l                               ;overflow right
  add   a,b                               ;add sx
  ld    (BuildingFadeIn+sx),a
  ld    (BuildingFadeIn+dx),a

  ld    a,(BuildingFadeIn+sy)
  inc   a
  cp    h                                 ;sy+ny
  ret   nc
  ld    (BuildingFadeIn+sy),a
  ld    (BuildingFadeIn+dy),a
  jp    .loop

  .go:
  ld    (BuildingFadeIn+sx),a
  ld    (BuildingFadeIn+dx),a
  jp    .loop


SetActiveCastleOverviewButtons:
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,(iy+CastleBarracksLevel)
  or    a
  jr    z,.EndCheckBarracks
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  .EndCheckBarracks:

  ld    a,(iy+CastleMageGuildLevel)
  or    a
  jr    z,.EndCheckMageGuild
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  .EndCheckMageGuild:

  ld    a,(iy+CastleMarket)
  or    a
  jr    z,.EndCheckMarket
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  .EndCheckMarket:

  ld    a,(iy+CastleTavern)
  or    a
  jr    z,.EndCheckTavern
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes
  .EndCheckTavern:
  ret

SetCastleButtons:                       ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,6
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,CastleOverviewButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+CastleOverviewWindowButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.bit0isSet
  bit   1,(ix+CastleOverviewWindowButtonStatus)
  ret   z
  
  .bit1isSet:
  res   1,(ix+CastleOverviewWindowButtonStatus)
  jr    .goCopyButton
  .bit0isSet:
  res   0,(ix+CastleOverviewWindowButtonStatus)  
  .goCopyButton:

  ld    l,(ix+CastleOverviewWindowButton_SYSX_Ontouched)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_Ontouched+1)
  bit   6,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+CastleOverviewWindowButton_SYSX_MovedOver)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_MovedOver+1)
  bit   5,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+CastleOverviewWindowButton_SYSX_Clicked)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_Clicked+1)
;  bit   4,(ix+CastleOverviewWindowButtonStatus)
;  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)  
  .go:

;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$8000 + (212*128) + (012/2) - 128  ;dy,dx
  ld    bc,$0000 + (031*256) + (040/2)        ;ny,nx
  ld    a,ButtonsBlock                  ;buttons block
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton+dPage),a

  ld    a,(ix+CastleOverviewWindowButton_dx)
  ld    (CopyCastleButton+dx),a

  ld    hl,CopyCastleButton
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret

CheckButtonMouseInteractionCastleMainScreen:
  ld    b,6
  ld    de,CastleOverviewButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+CastleOverviewWindowButtonStatus)
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+CastleOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+CastleOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonXright)
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
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+CastleOverviewWindowButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  ld    a,b
  cp    1                                     ;exit
  jr    nz,.EndCheckExit
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  ret
  .EndCheckExit:

  cp    2                                     ;tavern
  jr    nz,.EndCheckTavern
  ;market place
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewTavernCode              ;jump to the tavern code
  ret
  .EndCheckTavern:

  cp    3                                     ;market
  jr    nz,.EndCheckMarket
  ;market place
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewMarketPlaceCode         ;jump to the market place code
  .EndCheckMarket:

  cp    4                                     ;magic guild
  jr    nz,.EndCheckMagicGuild
  ;magic guild
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewMagicGuildCode          ;jump to the magic guild code
  .EndCheckMagicGuild:

  cp    5                                     ;recruit
  jr    nz,.EndCheckRecruit
  ;recruit
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewRecruitCode             ;jump to the recruit code
  .EndCheckRecruit:

  ;build
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewBuildCode               ;jump to the build code

;THIS ROUTINE IS FROM ONE OF THE 5 INTERNAL WINDOWS (build, recruit, mageguild, tade, heroes)
CheckButtonMouseInteractionCastle:
  ld    b,6
  ld    de,CastleOverviewButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+CastleOverviewWindowButtonStatus)
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+CastleOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    (ix+CastleOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonXright)
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
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+CastleOverviewWindowButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to this internal window in the castle
  jp    CastleOverviewCode
 

SetIndividualBuildings:
;barracks
  ld    a,(iy+CastleBarracksLevel)
  or    a
  jr    z,.EndCheckBarracks
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (057*128) + (176/2) - 128  ;y,x
  ld    bc,$0000 + (101*256) + (080/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyBarracks
  call  docopy
  .EndCheckBarracks:

;barracks upgrade
  ld    a,(iy+CastleBarracksLevel)
  cp    6
  jr    nz,.EndCheckBarracksUpgrade
  ld    hl,$4000 + (100*128) + (160/2) - 128  ;y,x
  ld    de,$0000 + (006*128) + (202/2) - 128  ;y,x
  ld    bc,$0000 + (088*256) + (048/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyBarracksUpgrade
  call  docopy
  .EndCheckBarracksUpgrade:

;sawmill
  ld    a,(iy+CastleSawmillLevel)
  or    a
  jr    z,.EndCheckSawmill
  ld    hl,$4000 + (101*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (101*128) + (032/2) - 128  ;y,x
  ld    bc,$0000 + (035*256) + (060/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopySawmill
  call  docopy
  .EndCheckSawmill:

;mine
  ld    a,(iy+CastleMineLevel)
  or    a
  jr    z,.EndCheckMine
  ld    hl,$4000 + (136*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (150*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (052*256) + (126/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyMine
  call  docopy
  .EndCheckMine:

;mage guild
  ld    a,(iy+CastleMageGuildLevel)
  or    a
  jr    z,.EndCheckMageGuild
  ld    hl,$4000 + (000*128) + (208/2) - 128  ;y,x
  ld    de,$0000 + (019*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (168*256) + (048/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyMageGuild
  call  docopy
  .EndCheckMageGuild:

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

;tavern
  ld    a,(iy+CastleTavern)
  or    a
  jr    z,.EndCheckTavern
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (097*128) + (060/2) - 128  ;y,x
  ld    bc,$0000 + (115*256) + (158/2)        ;ny,nx
  ld    a,IndividualBuildingsPage2Block       ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyTavern
  call  docopy
  .EndCheckTavern:

;market
  ld    a,(iy+CastleMarket)
  or    a
  jr    z,.EndCheckMarket
  ld    hl,$4000 + (000*128) + (080/2) - 128  ;y,x
  ld    de,$0000 + (000*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (088*256) + (090/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock            ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyChamberOfCommerce
  call  docopy
  .EndCheckMarket:

;city walls
  ld    a,(iy+CastleLevel)
  cp    6
  jr    nz,.EndCheckCityWalls
  ld    hl,$4000 + (115*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (185*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (027*256) + (256/2)        ;ny,nx
  ld    a,IndividualBuildingsPage2Block       ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyCityWalls
  call  docopy
  .EndCheckCityWalls:
  ret

SetCastleOverviewGraphics:              
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,CastleOverviewBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetBuildGraphics:              
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set recourse window
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (020*256) + (256/2)
  ld    a,ChamberOfCommerceBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

ClearTextBuildWindow:
  ld    hl,$4000 + (046*128) + (180/2) - 128
  ld    de,$0000 + (046*128) + (180/2) - 128
  ld    bc,$0000 + (131*256) + (072/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetCastleOverViewFontPage0Y212:           ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetRecruitGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,RecruitCreaturesBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ;set monster
  ld    a,r
  and   3
  ld    hl,$4000 + (000*128) + (000/2) - 128
  jr    z,.MonsterFound
  dec   a
  ld    hl,$4000 + (030*128) + (000/2) - 128
  jr    z,.MonsterFound
  dec   a
  ld    hl,$4000 + (060*128) + (000/2) - 128
  jr    z,.MonsterFound
  ld    hl,$4000 + (090*128) + (000/2) - 128
  .MonsterFound:
  ld    de,$0000 + (133*128) + (000/2) - 128
  ld    bc,$0000 + (030*256) + (256/2)
  ld    a,RecruitCreatures4MonstersBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetRecruitGraphics6CreatureWindows:
  ld    hl,$4000 + (026*128) + (000/2) - 128
  ld    de,$0000 + (026*128) + (000/2) - 128
  ld    bc,$0000 + (103*256) + (256/2)
  ld    a,RecruitCreaturesBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetVisitingAndDefendingHeroesAndArmyWindow:
  ld    hl,$4000 + (174*128) + (004/2) - 128
  ld    de,$0000 + (174*128) + (004/2) - 128
  ld    bc,$0000 + (034*256) + (248/2)
  ld    a,RecruitCreaturesBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetMagicGuildGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,MagicGuildBlock                 ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetMarketPlaceGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,ChamberOfCommerceBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetTavernGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,TavernBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroArmyTransferGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (030*128) + (024/2) - 128
  ld    bc,$0000 + (137*256) + (156/2)
  ld    a,HeroArmyTransferGraphicsBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

CopyBarracks:
	db		176,0,057,0
	db		176,0,057,1
	db		080,0,101,0
	db		0,%0000 0000,$98

CopyBarracksUpgrade:
	db		202,0,006,0
	db		202,0,006,1
	db		048,0,088,0
	db		0,%0000 0000,$98

CopySawmill:
	db		032,0,101,0
	db		032,0,101,1
	db		060,0,035,0
	db		0,%0000 0000,$98

CopyMine:
	db		000,0,150,0
	db		050,0,126,1
	db		126,0,052,0
	db		0,%0000 0000,$98

CopyMageGuild:
	db		000,0,019,0
	db		000,0,019,1
	db		048,0,168,0
	db		0,%0000 0000,$98

CopyTavern:
	db		060,0,097,0
	db		060,0,097,1
	db		158,0,115,0
	db		0,%0000 0000,$98

CopyChamberOfCommerce:
	db		000,0,000,0
	db		166,0,106,1
	db		090,0,088,0
	db		0,%0000 0000,$98

CopyCityWalls:
	db		000,0,185,0
	db		000,0,185,1
	db		000,1,027,0
	db		0,%0000 0000,$98

SetResourcesPlayer:
  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
  ;clear resources
  ld    hl,$4000 + (007*128) + (032/2) - 128
  ld    de,$0000 + (007*128) + (032/2) - 128
  ld    bc,$0000 + (005*256) + (220/2)
  ld    a,ChamberOfCommerceBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetResourcesCurrentPlayerinIX

  ;gold
  ld    b,217                           ;dx
  ld    c,007                           ;dy
  ld    l,(ix+0)
  ld    h,(ix+1)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;wood
  ld    b,035                           ;dx
  ld    c,007                           ;dy
  ld    l,(ix+2)
  ld    h,(ix+3)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;ore
  ld    b,078                           ;dx
  ld    c,007                           ;dy
  ld    l,(ix+4)
  ld    h,(ix+5)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;gems
  ld    b,122                           ;dx
  ld    c,007                           ;dy
  ld    l,(ix+6)
  ld    h,(ix+7)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ;rubies
  ld    b,166                           ;dx
  ld    c,007                           ;dy
  ld    l,(ix+8)
  ld    h,(ix+9)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ret



