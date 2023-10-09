;  call  CastleOverviewCode
;  call  CastleOverviewBuildCode
;  call  CastleOverviewRecruitCode
;  call  CastleOverviewMagicGuildCode
;  call  CastleOverviewMarketPlaceCode
;  call  CastleOverviewTavernCode
;  call  TradeMenuCode
;  call  HudCode

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
  ld    bc,$0000 + (092*256) + (162/2)
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
  ld    b,063                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  call  SetAvailableRecruitArmy.SetRubiescost

.Gemscost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  jp    SetAvailableRecruitArmy.SetGemscost

.cost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,072                           ;dx
  ld    c,071                           ;dy
  jp    SetAvailableRecruitArmy.SetCost

.name:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,125                           ;dx
  ld    c,038                           ;dy
  jp    SetAvailableRecruitArmy.SetName

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
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetAvailableRecruitArmy.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,050*128 + (120/2) - 128      ;(dy*128 + dx/2) = (204,153)              
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

.SetUnit:
  ld    hl,SelectedCastleRecruitLevelUnit
  ld    a,b
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

















SetAvailableRecruitArmy:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  .army
  call  .amount
  call  .names
  call  .cost
  call  .Gemscost
  call  .Rubiescost
  call  .speed
  call  .defense
  call  .attack
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
  ld    b,005+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+038                       ;dx
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
  ld    b,005+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+038                       ;dx
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
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack  
  ret

  .SetAttack:
  ld    h,0
  ld    l,a
  ld    de,AttackCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
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
  ld    h,0
  ld    l,a
  ld    de,DefenseCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret

  .speed:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed  
  ret

  .SetSpeed:
  ld    h,0
  ld    l,a
  ld    de,SpeedCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret





  .cost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost
  ret

  .SetCost:
  call  SetCostSelectedCreatureInHL

  call  SetNumber16BitCastle
  ret
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret

  .names:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,007                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,091                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,175                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,007                           ;dx
  ld    c,083                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,091                           ;dx
  ld    c,083                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,175                           ;dx
  ld    c,083                           ;dy
  call  .SetName
  ret

  .SetName:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,CreatureNameTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret

  .amount:
  ld    l,(iy+CastleLevel1UnitsAvail+00)
  ld    h,(iy+CastleLevel1UnitsAvail+01)
  ld    b,081 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+02)
  ld    h,(iy+CastleLevel1UnitsAvail+03)
  ld    b,166 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+04)
  ld    h,(iy+CastleLevel1UnitsAvail+05)
  ld    b,251 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+06)
  ld    h,(iy+CastleLevel1UnitsAvail+07)
  ld    b,081 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+08)
  ld    h,(iy+CastleLevel1UnitsAvail+09)
  ld    b,166 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+10)
  ld    h,(iy+CastleLevel1UnitsAvail+11)
  ld    b,251 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle
  ret
  
.army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(iy+CastleLevel1Units)        ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit1Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel2Units)        ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit2Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel3Units)        ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit3Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel4Units)        ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit4Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel5Units)        ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit5Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel6Units)        ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit6Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,.Unit14x14SYSXTable
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

.Unit14x14SYSXTable:  
                dw $8000+(00*128)+(00/2)-128, $8000+(00*128)+(14/2)-128, $8000+(00*128)+(28/2)-128, $8000+(00*128)+(42/2)-128, $8000+(00*128)+(56/2)-128, $8000+(00*128)+(70/2)-128, $8000+(00*128)+(84/2)-128, $8000+(00*128)+(98/2)-128, $8000+(00*128)+(112/2)-128, $8000+(00*128)+(126/2)-128, $8000+(00*128)+(140/2)-128, $8000+(00*128)+(154/2)-128, $8000+(00*128)+(168/2)-128, $8000+(00*128)+(182/2)-128, $8000+(00*128)+(196/2)-128, $8000+(00*128)+(210/2)-128, $8000+(00*128)+(224/2)-128, $8000+(00*128)+(238/2)-128
                dw $8000+(14*128)+(00/2)-128, $8000+(14*128)+(14/2)-128, $8000+(14*128)+(28/2)-128, $8000+(14*128)+(42/2)-128, $8000+(14*128)+(56/2)-128, $8000+(14*128)+(70/2)-128, $8000+(14*128)+(84/2)-128, $8000+(14*128)+(98/2)-128, $8000+(14*128)+(112/2)-128, $8000+(14*128)+(126/2)-128, $8000+(14*128)+(140/2)-128, $8000+(14*128)+(154/2)-128, $8000+(14*128)+(168/2)-128, $8000+(14*128)+(182/2)-128, $8000+(14*128)+(196/2)-128, $8000+(14*128)+(210/2)-128, $8000+(14*128)+(224/2)-128, $8000+(14*128)+(238/2)-128
                dw $8000+(28*128)+(00/2)-128, $8000+(28*128)+(14/2)-128, $8000+(28*128)+(28/2)-128, $8000+(28*128)+(42/2)-128, $8000+(28*128)+(56/2)-128, $8000+(28*128)+(70/2)-128, $8000+(28*128)+(84/2)-128, $8000+(28*128)+(98/2)-128, $8000+(28*128)+(112/2)-128, $8000+(28*128)+(126/2)-128, $8000+(28*128)+(140/2)-128, $8000+(28*128)+(154/2)-128, $8000+(28*128)+(168/2)-128, $8000+(28*128)+(182/2)-128, $8000+(28*128)+(196/2)-128, $8000+(28*128)+(210/2)-128, $8000+(28*128)+(224/2)-128, $8000+(28*128)+(238/2)-128
                dw $8000+(42*128)+(00/2)-128, $8000+(42*128)+(14/2)-128, $8000+(42*128)+(28/2)-128, $8000+(42*128)+(42/2)-128, $8000+(42*128)+(56/2)-128, $8000+(42*128)+(70/2)-128, $8000+(42*128)+(84/2)-128, $8000+(42*128)+(98/2)-128, $8000+(42*128)+(112/2)-128, $8000+(42*128)+(126/2)-128, $8000+(42*128)+(140/2)-128, $8000+(42*128)+(154/2)-128, $8000+(42*128)+(168/2)-128, $8000+(42*128)+(182/2)-128, $8000+(42*128)+(196/2)-128, $8000+(42*128)+(210/2)-128, $8000+(42*128)+(224/2)-128, $8000+(42*128)+(238/2)-128
                dw $8000+(56*128)+(00/2)-128, $8000+(56*128)+(14/2)-128, $8000+(56*128)+(28/2)-128, $8000+(56*128)+(42/2)-128, $8000+(56*128)+(56/2)-128, $8000+(56*128)+(70/2)-128, $8000+(56*128)+(84/2)-128, $8000+(56*128)+(98/2)-128, $8000+(56*128)+(112/2)-128, $8000+(56*128)+(126/2)-128, $8000+(56*128)+(140/2)-128, $8000+(56*128)+(154/2)-128, $8000+(56*128)+(168/2)-128, $8000+(56*128)+(182/2)-128, $8000+(56*128)+(196/2)-128, $8000+(56*128)+(210/2)-128, $8000+(56*128)+(224/2)-128, $8000+(56*128)+(238/2)-128
                dw $8000+(70*128)+(00/2)-128, $8000+(70*128)+(14/2)-128, $8000+(70*128)+(28/2)-128, $8000+(70*128)+(42/2)-128, $8000+(70*128)+(56/2)-128, $8000+(70*128)+(70/2)-128, $8000+(70*128)+(84/2)-128, $8000+(70*128)+(98/2)-128, $8000+(70*128)+(112/2)-128, $8000+(70*128)+(126/2)-128, $8000+(70*128)+(140/2)-128, $8000+(70*128)+(154/2)-128, $8000+(70*128)+(168/2)-128, $8000+(70*128)+(182/2)-128, $8000+(70*128)+(196/2)-128, $8000+(70*128)+(210/2)-128, $8000+(70*128)+(224/2)-128, $8000+(70*128)+(238/2)-128
                dw $8000+(84*128)+(00/2)-128, $8000+(84*128)+(14/2)-128, $8000+(84*128)+(28/2)-128, $8000+(84*128)+(42/2)-128, $8000+(84*128)+(56/2)-128, $8000+(84*128)+(70/2)-128, $8000+(84*128)+(84/2)-128, $8000+(84*128)+(98/2)-128, $8000+(84*128)+(112/2)-128, $8000+(84*128)+(126/2)-128, $8000+(84*128)+(140/2)-128, $8000+(84*128)+(154/2)-128, $8000+(84*128)+(168/2)-128, $8000+(84*128)+(182/2)-128, $8000+(84*128)+(196/2)-128, $8000+(84*128)+(210/2)-128, $8000+(84*128)+(224/2)-128, $8000+(84*128)+(238/2)-128

;NXAndNY14x14CharaterPortraits:      equ 014*256 + (014/2)            ;(ny*256 + nx/2) = (14x14)
DYDXUnit1Window:               equ 038*128 + (008/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit2Window:               equ 038*128 + (092/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit3Window:               equ 038*128 + (176/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit4Window:               equ 094*128 + (008/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit5Window:               equ 094*128 + (092/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit6Window:               equ 094*128 + (176/2) - 128      ;(dy*128 + dx/2) = (204,153)






SettavernHeroSkill:
  ld    a,HeroOverviewCodeBlock         ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    a,(iy+TavernHero1DayRemain)     ;hero number
  ld    b,004+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,(iy+TavernHero2DayRemain)     ;hero number
  ld    b,090+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,(iy+TavernHero3DayRemain)     ;hero number
  ld    b,176+04                        ;dx
  ld    c,043+44                        ;dy
  call  .SetHeroSkill

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetHeroSkill:
  or    a
  ret   z

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
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  push  hl
  add   hl,hl                           ;*64
  pop   de
  add   hl,de                           ;*96
  ld    de,SkillEmpty+$4000
  add   hl,de
  
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

SetText:                                ;in: b=dx, c=dy, hl->text
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text
  ld    (TextAddresspointer),hl  
  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
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
  ld    a,182
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,047
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  .SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret

  .SetText:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
  ld    (PutLetter+dPage),a             ;set page where to put text

  ld    a,-1
  ld    (TextPointer),a                 ;increase text pointer
  .NextLetter:
  ld    a,(TextPointer)
  inc   a
  ld    (TextPointer),a                 ;increase text pointer

  ld    hl,(TextAddresspointer)

  ld    d,0
  ld    e,a
  add   hl,de

  ld    a,(hl)                          ;letter
  cp    255                             ;end
  ret   z
  cp    254                             ;next line
  jr    z,.NextLine
  cp    TextSpace                       ;space
  jr    z,.Space
  cp    TextPercentageSymbol            ;%
  jr    z,.TextPercentageSymbol
  cp    TextPlusSymbol                  ;+
  jr    z,.TextPlusSymbol
  cp    TextMinusSymbol                 ;-
  jr    z,.TextMinusSymbol
  cp    TextApostrofeSymbol             ;'
  jr    z,.TextApostrofeSymbol
  cp    TextColonSymbol                 ;:
  jr    z,.TextColonSymbol
  cp    TextSlashSymbol                 ;/
  jr    z,.TextSlashSymbol




  cp    TextNumber0+10
  jr    c,.Number


  sub   $41
  ld    hl,.TextCoordinateTable  
  add   a,a                             ;*2
  ld    d,0
  ld    e,a

  add   hl,de
  
  .GoPutLetter:
  ld    a,(hl)                          ;sx
  ld    (PutLetter+sx),a                ;set sx of letter
  inc   hl
  ld    a,(hl)                          ;nx
  ld    (PutLetter+nx),a                ;set nx of letter

  ld    hl,PutLetter
  call  DoCopy

  ld    hl,PutLetter+nx                 ;nx of letter
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  add   a,(hl)                          ;add lenght
  inc   a                               ;+1
  ld    (PutLetter+dx),a                ;set dx of next letter
  
  jp    .NextLetter

  .Number:
  sub   TextNumber0                     ;hex value of number "0"
  add   a,a                             ;*2
  ld    d,0
  ld    e,a  

  ld    hl,.TextNumberSymbolsSXNX
  add   hl,de
  jr    .GoPutLetter
  
  .TextPercentageSymbol:
  ld    hl,.TextPercentageSymbolSXNX  
  jr    .GoPutLetter

  .TextPlusSymbol:
  ld    hl,.TextPlusSymbolSXNX  
  jr    .GoPutLetter

  .TextMinusSymbol:
  ld    hl,.TextMinusSymbolSXNX  
  jr    .GoPutLetter

  .TextApostrofeSymbol:
  ld    hl,.TextApostrofeSymbolSXNX  
  jr    .GoPutLetter

  .TextColonSymbol:
  ld    hl,.TextColonSymbolSXNX  
  jr    .GoPutLetter

  .TextSlashSymbol:
  ld    hl,.TextSlashSymbolSXNX  
  jr    .GoPutLetter

  .Space:
  ld    a,(PutLetter+dx)                ;set dx of next letter
  add   a,5
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter

  .NextLine:
  ld    a,(PutLetter+dy)                ;set dy of next letter
  add   a,7
  ld    (PutLetter+dy),a                ;set dy of next letter
  ld    a,(TextDX)
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter


;                          0       1       2       3       4       5       6       7       8       9
.TextNumberSymbolsSXNX: db 171,4,  175,2,  177,4,  181,3,  184,3,  187,4,  191,4,  195,4,  199,4,  203,4,  158,4  
.TextSlashSymbolSXNX: db  158+49,4  ;"/"
.TextPercentageSymbolSXNX: db  162+49,4 ;"%"
.TextPlusSymbolSXNX: db  166+49,5 ;"+"
.TextMinusSymbolSXNX: db  169+49,5 ;"-"
.TextApostrofeSymbolSXNX: db  195,1  ;"'"
.TextColonSymbolSXNX: db  008,1  ;":"

;                               A      B      C      D      E      F      G      H      I      J      K      L      M      N      O      P      Q      R      S      T      U      V      W      X      Y      Z
.TextCoordinateTable:       db  084,3, 087,3, 090,3, 093,3, 096,3, 099,3, 102,5, 107,3, 110,3, 113,3, 116,4, 120,3, 123,6, 129,4, 133,3, 136,3, 139,3, 142,3, 145,3, 148,3, 151,3, 154,3, 157,5, 162,3, 165,3, 168,3
;                               a      b      c      d      e      f      g      h      i      j      k      l      m      n      o      p      q      r      s      t      u      v      w      x      y      z     
ds 12
.TextCoordinateTableSmall:  db  000,4, 004,3, 007,3, 010,3, 013,3, 016,2, 018,4, 022,3, 025,1, 026,2, 028,4, 032,1, 033,5, 038,4, 042,4, 046,4, 050,4, 054,2, 056,4, 060,2, 062,3, 065,3, 068,5, 073,3, 076,4, 080,4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           WARNING                      ;;
;;  The above routine is called while                     ;;
;;  ld    a,HeroOverviewCodeBlock                         ;;
;;  call  block34                                         ;;
;;  Therefor this routine can ABSOLUTELY NOT be in page 2 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






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






HudCode:
  call  SetHeroArmyAndStatusInHud  
	call	SetCastlesInWindows             ;erase castle windows, then put the castles in the windows
  call  SetResources

  ;handle all hud buttons
  ld    ix,GenericButtonTable3
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked               ;in: carry=button clicked, b=button number

	call	SetHeroesInWindows              ;erase hero windows, then put the heroes in the windows
  call  CheckIfHeroButtonShouldRemainLit
	call	SetManaAndMovementBars          ;erase hero mana and movement bars, then set the mana and movement bars of the heroes

  ld    ix,GenericButtonTable3
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/handle all hud buttons
  ret

.CheckButtonClicked:
  ret   nc                              ;carry=button pressed, b=which button

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

  cp    01
  jp    z,endturn
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
	ld		a,(SetHeroArmyAndStatusInHud?)
	dec		a
	ret		z
	ld		(SetHeroArmyAndStatusInHud?),a

  ld    ix,(plxcurrentheroAddress)
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  ClearHeroStatsAndArmyUnitsAmount
  call  SetArmyUnits
  call  SetArmyUnitsAmount
  call  SetHeroPortrait10x18
  call  SetHeroStats
  ret

ClearHeroStatsAndArmyUnitsAmount:
  ld    hl,$4000 + (145*128) + (202/2) - 128
  ld    de,$0000 + (145*128) + (202/2) - 128
  ld    bc,$0000 + (052*256) + (050/2)
  ld    a,HudNewBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroStats:
  ld    ix,(plxcurrentheroAddress)

  ld    l,(ix+HeroStatAttack)           ;attack
  ld    h,0
  ld    b,216-004                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    l,(ix+HeroStatDefense)          ;defense
  ld    h,0
  ld    b,225-004                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    l,(ix+HeroStatKnowledge)        ;knowledge
  ld    h,0
  ld    b,234-004                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle

  ld    l,(ix+HeroStatSpelldamage)      ;spell damage
  ld    h,0
  ld    b,243-004                       ;dx
  ld    c,145                           ;dy
  call  SetNumber16BitCastle
  ret

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


SetArmyUnits:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit1WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit2WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit3WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit4WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit5WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,DYDXUnit6WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,.Creatures14x14SYSXTable
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
.Creatures14x14SYSXTable:  
                dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(14*128)+(00/2)-128, $4000+(14*128)+(14/2)-128, $4000+(14*128)+(28/2)-128, $4000+(14*128)+(42/2)-128, $4000+(14*128)+(56/2)-128, $4000+(14*128)+(70/2)-128, $4000+(14*128)+(84/2)-128, $4000+(14*128)+(98/2)-128, $4000+(14*128)+(112/2)-128, $4000+(14*128)+(126/2)-128, $4000+(14*128)+(140/2)-128, $4000+(14*128)+(154/2)-128, $4000+(14*128)+(168/2)-128, $4000+(14*128)+(182/2)-128, $4000+(14*128)+(196/2)-128, $4000+(14*128)+(210/2)-128, $4000+(14*128)+(224/2)-128, $4000+(14*128)+(238/2)-128
                dw $4000+(28*128)+(00/2)-128, $4000+(28*128)+(14/2)-128, $4000+(28*128)+(28/2)-128, $4000+(28*128)+(42/2)-128, $4000+(28*128)+(56/2)-128, $4000+(28*128)+(70/2)-128, $4000+(28*128)+(84/2)-128, $4000+(28*128)+(98/2)-128, $4000+(28*128)+(112/2)-128, $4000+(28*128)+(126/2)-128, $4000+(28*128)+(140/2)-128, $4000+(28*128)+(154/2)-128, $4000+(28*128)+(168/2)-128, $4000+(28*128)+(182/2)-128, $4000+(28*128)+(196/2)-128, $4000+(28*128)+(210/2)-128, $4000+(28*128)+(224/2)-128, $4000+(28*128)+(238/2)-128
                dw $4000+(42*128)+(00/2)-128, $4000+(42*128)+(14/2)-128, $4000+(42*128)+(28/2)-128, $4000+(42*128)+(42/2)-128, $4000+(42*128)+(56/2)-128, $4000+(42*128)+(70/2)-128, $4000+(42*128)+(84/2)-128, $4000+(42*128)+(98/2)-128, $4000+(42*128)+(112/2)-128, $4000+(42*128)+(126/2)-128, $4000+(42*128)+(140/2)-128, $4000+(42*128)+(154/2)-128, $4000+(42*128)+(168/2)-128, $4000+(42*128)+(182/2)-128, $4000+(42*128)+(196/2)-128, $4000+(42*128)+(210/2)-128, $4000+(42*128)+(224/2)-128, $4000+(42*128)+(238/2)-128
                dw $4000+(56*128)+(00/2)-128, $4000+(56*128)+(14/2)-128, $4000+(56*128)+(28/2)-128, $4000+(56*128)+(42/2)-128, $4000+(56*128)+(56/2)-128, $4000+(56*128)+(70/2)-128, $4000+(56*128)+(84/2)-128, $4000+(56*128)+(98/2)-128, $4000+(56*128)+(112/2)-128, $4000+(56*128)+(126/2)-128, $4000+(56*128)+(140/2)-128, $4000+(56*128)+(154/2)-128, $4000+(56*128)+(168/2)-128, $4000+(56*128)+(182/2)-128, $4000+(56*128)+(196/2)-128, $4000+(56*128)+(210/2)-128, $4000+(56*128)+(224/2)-128, $4000+(56*128)+(238/2)-128
                dw $4000+(70*128)+(00/2)-128, $4000+(70*128)+(14/2)-128, $4000+(70*128)+(28/2)-128, $4000+(70*128)+(42/2)-128, $4000+(70*128)+(56/2)-128, $4000+(70*128)+(70/2)-128, $4000+(70*128)+(84/2)-128, $4000+(70*128)+(98/2)-128, $4000+(70*128)+(112/2)-128, $4000+(70*128)+(126/2)-128, $4000+(70*128)+(140/2)-128, $4000+(70*128)+(154/2)-128, $4000+(70*128)+(168/2)-128, $4000+(70*128)+(182/2)-128, $4000+(70*128)+(196/2)-128, $4000+(70*128)+(210/2)-128, $4000+(70*128)+(224/2)-128, $4000+(70*128)+(238/2)-128
                dw $4000+(84*128)+(00/2)-128, $4000+(84*128)+(14/2)-128, $4000+(84*128)+(28/2)-128, $4000+(84*128)+(42/2)-128, $4000+(84*128)+(56/2)-128, $4000+(84*128)+(70/2)-128, $4000+(84*128)+(84/2)-128, $4000+(84*128)+(98/2)-128, $4000+(84*128)+(112/2)-128, $4000+(84*128)+(126/2)-128, $4000+(84*128)+(140/2)-128, $4000+(84*128)+(154/2)-128, $4000+(84*128)+(168/2)-128, $4000+(84*128)+(182/2)-128, $4000+(84*128)+(196/2)-128, $4000+(84*128)+(210/2)-128, $4000+(84*128)+(224/2)-128, $4000+(84*128)+(238/2)-128

SetArmyUnitsAmount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,204
  ld    c,169
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,220
  ld    c,169
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,236
  ld    c,169
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,204
  ld    c,192
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,220
  ld    c,192
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,236
  ld    c,192
  call  SetNumber16BitCastleSkipIfAmountIs0
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
  ;multiply current mana by 10
  ld    h,0
  ld    l,(ix+HeroMana)                 ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  add   hl,hl                           ;*2
  push  hl
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  pop   de
  add   hl,de                           ;*10

  ld    e,(ix+HeroTotalMana)            ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (042/2) - 128
  jr    c,.EndSearchPercentageMovementSmallExceptionWhenAlmost0
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (040/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (038/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (036/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (034/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (032/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (030/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (028/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (026/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (024/2) - 128
  jr    c,.EndSearchPercentageMovement
  ld    bc,$4000 + (107*128) + (022/2) - 128
  jr    .EndSearchPercentageMovement

  .EndSearchPercentageMovementSmallExceptionWhenAlmost0:
  ld    a,(ix+HeroMove)                 ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  and   a
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + (107*128) + (018/2) - 128

  .EndSearchPercentageMovement:
  push  bc
  exx
  pop   hl
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
	ret

  PutMovementBar:
  exx
  ;multiply current move by 10
  ld    h,0
  ld    l,(ix+HeroMove)                 ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  add   hl,hl                           ;*2
  push  hl
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  pop   de
  add   hl,de                           ;*10

  ld    e,(ix+HeroTotalMove)            ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (020/2) - 128
  jr    c,.EndSearchPercentageMovementSmallExceptionWhenAlmost0
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (018/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (016/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (014/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (012/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (010/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (008/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (006/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (004/2) - 128
  jr    c,.EndSearchPercentageMovement
  sbc   hl,de                           ;subtract total move max 10x to find percentage value per 10
  ld    bc,$4000 + (107*128) + (002/2) - 128
  jr    c,.EndSearchPercentageMovement
  ld    bc,$4000 + (107*128) + (000/2) - 128
  jr    .EndSearchPercentageMovement

  .EndSearchPercentageMovementSmallExceptionWhenAlmost0:
  ld    a,(ix+HeroMove)                 ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  and   a
  jr    z,.EndSearchPercentageMovement
  ld    bc,$4000 + (107*128) + (018/2) - 128

  .EndSearchPercentageMovement:
  push  bc
  exx
  pop   hl
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
	ret

EraseManaandMovementBars:
  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (067*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (078*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (089*128) + (204/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (067*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (078*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (107*128) + (020/2) - 128
  ld    de,$0000 + (089*128) + (226/2) - 128
  ld    bc,$0000 + (010*256) + (002/2)
  ld    a,Hero14x9PortraitsBlock          ;block to copy graphics from
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
  ld    a,(ix+CastleTerrainSY)      ;terrain 0=grassland,1=swamp,2=hell,3=snow
  or    a
  ld    hl,CastleButtonGrassLand
  jr    z,.EndCheckTerrain
  dec   a
  ld    hl,CastleButtonSwamp
  jr    z,.EndCheckTerrain
  dec   a
  ld    hl,CastleButtonHell
  jr    z,.EndCheckTerrain
  ld    hl,CastleButtonSnow

  .EndCheckTerrain:
  ld    bc,7
  ldir
	ret

CastleButton20x11SYSXEmpty: db  %1100 0011 | dw $4000 + (139*128) + (156/2) - 128 | dw $4000 + (139*128) + (176/2) - 128 | dw $4000 + (139*128) + (196/2) - 128
CastleButtonGrassLand:      db  %1100 0011 | dw $4000 + (117*128) + (000/2) - 128 | dw $4000 + (117*128) + (020/2) - 128 | dw $4000 + (117*128) + (040/2) - 128
CastleButtonSwamp:          db  %1100 0011 | dw $4000 + (117*128) + (060/2) - 128 | dw $4000 + (117*128) + (080/2) - 128 | dw $4000 + (117*128) + (100/2) - 128
CastleButtonHell:           db  %1100 0011 | dw $4000 + (117*128) + (120/2) - 128 | dw $4000 + (117*128) + (140/2) - 128 | dw $4000 + (117*128) + (160/2) - 128
CastleButtonSnow:           db  %1100 0011 | dw $4000 + (117*128) + (180/2) - 128 | dw $4000 + (117*128) + (200/2) - 128 | dw $4000 + (117*128) + (220/2) - 128

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

SetCastleUsingCastleWindowPointerInIX:
	ld		a,(CastleWindowPointer)     ;CastleWindowPointer points to the castle that should be in castlewindows1 
	ld    c,a	
  ld    a,(whichplayernowplaying?)
  ld    b,AmountOfCastles
  ld    ix,Castle1
  ld    de,LenghtCastleTable
  .SearchLoop:
  cp    (ix+CastlePlayer)
  jp    z,.CastleFound
  add   ix,de
  djnz  .SearchLoop
  ;no castle found, this player has no castles at all
  pop   af
  ret

  .CastleFound:
  dec   c
  ret   m
  add   ix,de
  djnz  .SearchLoop
  ;no castle found, this player has no castles at all
  pop   af
  ret

  .SearchNextCastle:  
  add   ix,de
  cp    (ix+CastlePlayer)
  ret   z               ;castle found
  djnz  .SearchNextCastle
  ;no castle
  pop   af
  ret  

ThirdCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle  
  jp    centrescreenforthisCastle
  
SecondCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  jp    centrescreenforthisCastle

FirstCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  jp    centrescreenforthisCastle

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
  ld    l,(iy+HeroButton20x11SYSX+0)    ;find hero portrait 16x30 address
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

HeroButton20x11SYSXEmpty:           db  %1100 0011 | dw $4000 + (139*128) + (096/2) - 128 | dw $4000 + (139*128) + (116/2) - 128 | dw $4000 + (139*128) + (136/2) - 128

HeroButton20x11SYSXAdol:            db  %1100 0011 | dw $4000 + (018*128) + (000/2) - 128 | dw $4000 + (018*128) + (020/2) - 128 | dw $4000 + (018*128) + (040/2) - 128
HeroButton20x11SYSXGoemon1:         db  %1100 0011 | dw $4000 + (018*128) + (060/2) - 128 | dw $4000 + (018*128) + (080/2) - 128 | dw $4000 + (018*128) + (100/2) - 128
HeroButton20x11SYSXPixy:            db  %1100 0011 | dw $4000 + (018*128) + (120/2) - 128 | dw $4000 + (018*128) + (140/2) - 128 | dw $4000 + (018*128) + (160/2) - 128
HeroButton20x11SYSXDrasle1:         db  %1100 0011 | dw $4000 + (018*128) + (180/2) - 128 | dw $4000 + (018*128) + (200/2) - 128 | dw $4000 + (018*128) + (220/2) - 128

HeroButton20x11SYSXLatok:           db  %1100 0011 | dw $4000 + (029*128) + (000/2) - 128 | dw $4000 + (029*128) + (020/2) - 128 | dw $4000 + (029*128) + (040/2) - 128
HeroButton20x11SYSXDrasle2:         db  %1100 0011 | dw $4000 + (029*128) + (060/2) - 128 | dw $4000 + (029*128) + (080/2) - 128 | dw $4000 + (029*128) + (100/2) - 128
HeroButton20x11SYSXSnake1:          db  %1100 0011 | dw $4000 + (029*128) + (120/2) - 128 | dw $4000 + (029*128) + (140/2) - 128 | dw $4000 + (029*128) + (160/2) - 128
HeroButton20x11SYSXDrasle3:         db  %1100 0011 | dw $4000 + (029*128) + (180/2) - 128 | dw $4000 + (029*128) + (200/2) - 128 | dw $4000 + (029*128) + (220/2) - 128

HeroButton20x11SYSXSnake2:          db  %1100 0011 | dw $4000 + (040*128) + (000/2) - 128 | dw $4000 + (040*128) + (020/2) - 128 | dw $4000 + (040*128) + (040/2) - 128
HeroButton20x11SYSXDrasle4:         db  %1100 0011 | dw $4000 + (040*128) + (060/2) - 128 | dw $4000 + (040*128) + (080/2) - 128 | dw $4000 + (040*128) + (100/2) - 128
HeroButton20x11SYSXAshguine:        db  %1100 0011 | dw $4000 + (040*128) + (120/2) - 128 | dw $4000 + (040*128) + (140/2) - 128 | dw $4000 + (040*128) + (160/2) - 128
HeroButton20x11SYSXUndeadline1:     db  %1100 0011 | dw $4000 + (040*128) + (180/2) - 128 | dw $4000 + (040*128) + (200/2) - 128 | dw $4000 + (040*128) + (220/2) - 128

HeroButton20x11SYSXPsychoWorld:     db  %1100 0011 | dw $4000 + (051*128) + (000/2) - 128 | dw $4000 + (051*128) + (020/2) - 128 | dw $4000 + (051*128) + (040/2) - 128
HeroButton20x11SYSXUndeadline2:     db  %1100 0011 | dw $4000 + (051*128) + (060/2) - 128 | dw $4000 + (051*128) + (080/2) - 128 | dw $4000 + (051*128) + (100/2) - 128
HeroButton20x11SYSXGoemon2:         db  %1100 0011 | dw $4000 + (051*128) + (120/2) - 128 | dw $4000 + (051*128) + (140/2) - 128 | dw $4000 + (051*128) + (160/2) - 128
HeroButton20x11SYSXUndeadline3:     db  %1100 0011 | dw $4000 + (051*128) + (180/2) - 128 | dw $4000 + (051*128) + (200/2) - 128 | dw $4000 + (051*128) + (220/2) - 128

HeroButton20x11SYSXFray:            db  %1100 0011 | dw $4000 + (062*128) + (000/2) - 128 | dw $4000 + (062*128) + (020/2) - 128 | dw $4000 + (062*128) + (040/2) - 128
HeroButton20x11SYSXBlackColor:      db  %1100 0011 | dw $4000 + (062*128) + (060/2) - 128 | dw $4000 + (062*128) + (080/2) - 128 | dw $4000 + (062*128) + (100/2) - 128
HeroButton20x11SYSXWit:             db  %1100 0011 | dw $4000 + (062*128) + (120/2) - 128 | dw $4000 + (062*128) + (140/2) - 128 | dw $4000 + (062*128) + (160/2) - 128
HeroButton20x11SYSXMitchell:        db  %1100 0011 | dw $4000 + (062*128) + (180/2) - 128 | dw $4000 + (062*128) + (200/2) - 128 | dw $4000 + (062*128) + (220/2) - 128

HeroButton20x11SYSXJanJackGibson:   db  %1100 0011 | dw $4000 + (073*128) + (000/2) - 128 | dw $4000 + (073*128) + (020/2) - 128 | dw $4000 + (073*128) + (040/2) - 128
HeroButton20x11SYSXGillianSeed:     db  %1100 0011 | dw $4000 + (073*128) + (060/2) - 128 | dw $4000 + (073*128) + (080/2) - 128 | dw $4000 + (073*128) + (100/2) - 128
HeroButton20x11SYSXSnatcher:        db  %1100 0011 | dw $4000 + (073*128) + (120/2) - 128 | dw $4000 + (073*128) + (140/2) - 128 | dw $4000 + (073*128) + (160/2) - 128
HeroButton20x11SYSXGolvellius:      db  %1100 0011 | dw $4000 + (073*128) + (180/2) - 128 | dw $4000 + (073*128) + (200/2) - 128 | dw $4000 + (073*128) + (220/2) - 128

HeroButton20x11SYSXBillRizer:       db  %1100 0011 | dw $4000 + (084*128) + (000/2) - 128 | dw $4000 + (084*128) + (020/2) - 128 | dw $4000 + (084*128) + (040/2) - 128
HeroButton20x11SYSXPochi:           db  %1100 0011 | dw $4000 + (084*128) + (060/2) - 128 | dw $4000 + (084*128) + (080/2) - 128 | dw $4000 + (084*128) + (100/2) - 128
HeroButton20x11SYSXGreyFox:         db  %1100 0011 | dw $4000 + (084*128) + (120/2) - 128 | dw $4000 + (084*128) + (140/2) - 128 | dw $4000 + (084*128) + (160/2) - 128
HeroButton20x11SYSXTrevorBelmont:   db  %1100 0011 | dw $4000 + (084*128) + (180/2) - 128 | dw $4000 + (084*128) + (200/2) - 128 | dw $4000 + (084*128) + (220/2) - 128

HeroButton20x11SYSXBigBoss:         db  %1100 0011 | dw $4000 + (095*128) + (000/2) - 128 | dw $4000 + (095*128) + (020/2) - 128 | dw $4000 + (095*128) + (040/2) - 128
HeroButton20x11SYSXSimonBelmont:    db  %1100 0011 | dw $4000 + (095*128) + (060/2) - 128 | dw $4000 + (095*128) + (080/2) - 128 | dw $4000 + (095*128) + (100/2) - 128
HeroButton20x11SYSXDrPettrovich:    db  %1100 0011 | dw $4000 + (095*128) + (120/2) - 128 | dw $4000 + (095*128) + (140/2) - 128 | dw $4000 + (095*128) + (160/2) - 128
HeroButton20x11SYSXRichterBelmont:  db  %1100 0011 | dw $4000 + (095*128) + (180/2) - 128 | dw $4000 + (095*128) + (200/2) - 128 | dw $4000 + (095*128) + (220/2) - 128

















TradeMenuCode:
	ld		a,3					                    ;put new heros in windows (page 0 and page 1) 
	ld		(SetHeroArmyAndStatusInHud?),a
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

;12. Both creature slots clicked belong to different heroes. second slot clicked  has the same unit type, combine them is possible 

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
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,076
  ld    c,061
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,096
  ld    c,061
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,116
  ld    c,061
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,136
  ld    c,061
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,156
  ld    c,061
  call  SetNumber16BitCastleSkipIfAmountIs0
  ret

  .army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXDefendingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,SetVisitingHeroArmyAndAmount.UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

.DYDXDefendingHeroUnit1:          equ (044*128) + (056/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXDefendingHeroUnit2:          equ (044*128) + (076/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXDefendingHeroUnit3:          equ (044*128) + (096/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXDefendingHeroUnit4:          equ (044*128) + (116/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXDefendingHeroUnit5:          equ (044*128) + (136/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXDefendingHeroUnit6:          equ (044*128) + (156/2) - 128      ;(dy*128 + dx/2) = (204,153)

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
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,076
  ld    c,125
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,096
  ld    c,125
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,116
  ld    c,125
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,136
  ld    c,125
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,156
  ld    c,125
  call  SetNumber16BitCastleSkipIfAmountIs0
  ret

  .army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,.DYDXVisitingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,.UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128
.UnitSYSXTable14x24Portraits:  
                dw $8000+(00*128)+(00/2)-128, $8000+(00*128)+(14/2)-128, $8000+(00*128)+(28/2)-128, $8000+(00*128)+(42/2)-128, $8000+(00*128)+(56/2)-128, $8000+(00*128)+(70/2)-128, $8000+(00*128)+(84/2)-128, $8000+(00*128)+(98/2)-128, $8000+(00*128)+(112/2)-128, $8000+(00*128)+(126/2)-128, $8000+(00*128)+(140/2)-128, $8000+(00*128)+(154/2)-128, $8000+(00*128)+(168/2)-128, $8000+(00*128)+(182/2)-128, $8000+(00*128)+(196/2)-128, $8000+(00*128)+(210/2)-128, $8000+(00*128)+(224/2)-128, $8000+(00*128)+(238/2)-128
                dw $8000+(14*128)+(00/2)-128, $8000+(14*128)+(14/2)-128, $8000+(14*128)+(28/2)-128, $8000+(14*128)+(42/2)-128, $8000+(14*128)+(56/2)-128, $8000+(14*128)+(70/2)-128, $8000+(14*128)+(84/2)-128, $8000+(14*128)+(98/2)-128, $8000+(14*128)+(112/2)-128, $8000+(14*128)+(126/2)-128, $8000+(14*128)+(140/2)-128, $8000+(14*128)+(154/2)-128, $8000+(14*128)+(168/2)-128, $8000+(14*128)+(182/2)-128, $8000+(14*128)+(196/2)-128, $8000+(14*128)+(210/2)-128, $8000+(14*128)+(224/2)-128, $8000+(14*128)+(238/2)-128
                dw $8000+(28*128)+(00/2)-128, $8000+(28*128)+(14/2)-128, $8000+(28*128)+(28/2)-128, $8000+(28*128)+(42/2)-128, $8000+(28*128)+(56/2)-128, $8000+(28*128)+(70/2)-128, $8000+(28*128)+(84/2)-128, $8000+(28*128)+(98/2)-128, $8000+(28*128)+(112/2)-128, $8000+(28*128)+(126/2)-128, $8000+(28*128)+(140/2)-128, $8000+(28*128)+(154/2)-128, $8000+(28*128)+(168/2)-128, $8000+(28*128)+(182/2)-128, $8000+(28*128)+(196/2)-128, $8000+(28*128)+(210/2)-128, $8000+(28*128)+(224/2)-128, $8000+(28*128)+(238/2)-128
                dw $8000+(42*128)+(00/2)-128, $8000+(42*128)+(14/2)-128, $8000+(42*128)+(28/2)-128, $8000+(42*128)+(42/2)-128, $8000+(42*128)+(56/2)-128, $8000+(42*128)+(70/2)-128, $8000+(42*128)+(84/2)-128, $8000+(42*128)+(98/2)-128, $8000+(42*128)+(112/2)-128, $8000+(42*128)+(126/2)-128, $8000+(42*128)+(140/2)-128, $8000+(42*128)+(154/2)-128, $8000+(42*128)+(168/2)-128, $8000+(42*128)+(182/2)-128, $8000+(42*128)+(196/2)-128, $8000+(42*128)+(210/2)-128, $8000+(42*128)+(224/2)-128, $8000+(42*128)+(238/2)-128
                dw $8000+(56*128)+(00/2)-128, $8000+(56*128)+(14/2)-128, $8000+(56*128)+(28/2)-128, $8000+(56*128)+(42/2)-128, $8000+(56*128)+(56/2)-128, $8000+(56*128)+(70/2)-128, $8000+(56*128)+(84/2)-128, $8000+(56*128)+(98/2)-128, $8000+(56*128)+(112/2)-128, $8000+(56*128)+(126/2)-128, $8000+(56*128)+(140/2)-128, $8000+(56*128)+(154/2)-128, $8000+(56*128)+(168/2)-128, $8000+(56*128)+(182/2)-128, $8000+(56*128)+(196/2)-128, $8000+(56*128)+(210/2)-128, $8000+(56*128)+(224/2)-128, $8000+(56*128)+(238/2)-128
                dw $8000+(70*128)+(00/2)-128, $8000+(70*128)+(14/2)-128, $8000+(70*128)+(28/2)-128, $8000+(70*128)+(42/2)-128, $8000+(70*128)+(56/2)-128, $8000+(70*128)+(70/2)-128, $8000+(70*128)+(84/2)-128, $8000+(70*128)+(98/2)-128, $8000+(70*128)+(112/2)-128, $8000+(70*128)+(126/2)-128, $8000+(70*128)+(140/2)-128, $8000+(70*128)+(154/2)-128, $8000+(70*128)+(168/2)-128, $8000+(70*128)+(182/2)-128, $8000+(70*128)+(196/2)-128, $8000+(70*128)+(210/2)-128, $8000+(70*128)+(224/2)-128, $8000+(70*128)+(238/2)-128
                dw $8000+(84*128)+(00/2)-128, $8000+(84*128)+(14/2)-128, $8000+(84*128)+(28/2)-128, $8000+(84*128)+(42/2)-128, $8000+(84*128)+(56/2)-128, $8000+(84*128)+(70/2)-128, $8000+(84*128)+(84/2)-128, $8000+(84*128)+(98/2)-128, $8000+(84*128)+(112/2)-128, $8000+(84*128)+(126/2)-128, $8000+(84*128)+(140/2)-128, $8000+(84*128)+(154/2)-128, $8000+(84*128)+(168/2)-128, $8000+(84*128)+(182/2)-128, $8000+(84*128)+(196/2)-128, $8000+(84*128)+(210/2)-128, $8000+(84*128)+(224/2)-128, $8000+(84*128)+(238/2)-128

.DYDXVisitingHeroUnit1:          equ (108*128) + (056/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXVisitingHeroUnit2:          equ (108*128) + (076/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXVisitingHeroUnit3:          equ (108*128) + (096/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXVisitingHeroUnit4:          equ (108*128) + (116/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXVisitingHeroUnit5:          equ (108*128) + (136/2) - 128      ;(dy*128 + dx/2) = (204,153)
.DYDXVisitingHeroUnit6:          equ (108*128) + (156/2) - 128      ;(dy*128 + dx/2) = (204,153)
































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

  ld    hl,World1Palette
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

  halt
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

  ld    c,002                           ;check if hero status=002 (visiting) or 254 (defending)
  push  bc                              ;store which tavern button was pressed
  call  SetVisitingOrDefendingHeroInIX  ;in: iy->castle, c=002 (check visiting), c=254 (check defending). out: carry=no defending hero found / ix-> hero
  pop   bc                              ;recall which tavern button was pressed
  ret   nc                              ;unable to recruit hero if there is already a visiting hero here

  ld    a,b
  cp    3
  jr    z,.TavernButton1Pressed
  cp    2
  jr    z,.TavernButton2Pressed
;  cp    1
;  jr    z,.TavernButton3Pressed

  .TavernButton3Pressed:
  ld    a,(iy+TavernHero3DayRemain)     ;which hero are we recruiting ?
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  ld    (iy+TavernHero3DayRemain),000   ;remove hero 2 from tavern
  jp    .HeroRecruited

  .TavernButton2Pressed:
  ld    a,(iy+TavernHero2DayRemain)     ;which hero are we recruiting ?
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  ld    (iy+TavernHero2DayRemain),000   ;remove hero 2 from tavern
  jp    .HeroRecruited

  .TavernButton1Pressed:
  ld    a,(iy+TavernHero1DayRemain)     ;which hero are we recruiting ?
  call  .SetHeroStats                   ;set status=2, set y, set x, herospecific address
  ld    (iy+TavernHero1DayRemain),000   ;remove hero 2 from tavern
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
  call  SetEmptyHeroSlotForCurrentPlayerInIX

  ;set empty hero
  ld    hl,EmptyHeroRecruitedAtTavern
  push  ix
  pop   de
  ld    bc,lenghtherotable-2            ;don't copy .HeroDYDX:  dw $ffff 
  ldir

  ;set y,x
  ld    a,(iy+CastleY)                  ;castle y
  dec   a
  ld    (ix+HeroY),a                    ;set hero y  
  ld    a,(iy+Castlex)                  ;castle x
  inc   a
  ld    (ix+HeroX),a                    ;set hero x
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
  
  ;give the hero 1 level 1 unit, which is the same as the level 1 units in this castle
  ld    a,(iy+CastleLevel1Units)        ;castle x  
  ld    (ix+HeroUnits),a
  
  call  SetResourcesCurrentPlayerinIX   ;subtract 2000 gold (cost of any hero)
  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;gold
  ld    de,2000
  xor   a
  sbc   hl,de
;  ret   nc
  ld    (ix+0),l
  ld    (ix+1),h                        ;gold   
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
  call  SettavernHeroIcons
  call  SettavernHeroNames
  call  SettavernHeroSkill
  call  EraseTavernHeroWindowWhenUnavailable
  ret

EraseTavernHeroWindowWhenUnavailable:
  ld    a,(iy+TavernHero1DayRemain)     ;hero number
  or    a
  ld    de,$0000 + (045*128) + (006/2) - 128
  call  z,.EraseWindow
  ld    a,(iy+TavernHero2DayRemain)     ;hero number
  or    a
  ld    de,$0000 + (045*128) + (092/2) - 128
  call  z,.EraseWindow
  ld    a,(iy+TavernHero3DayRemain)     ;hero number
  or    a
  ld    de,$0000 + (045*128) + (178/2) - 128
  call  z,.EraseWindow
  ret

  .EraseWindow:
  ld    hl,$4000 + (055*128) + (180/2) - 128
  ld    bc,$0000 + (069*256) + (072/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
























SettavernHeroNames:
  ld    a,(iy+TavernHero1DayRemain)     ;hero number
  ld    b,004+30                        ;dx
  ld    c,033+13                        ;dy
  call  .SetHeroName

  ld    a,(iy+TavernHero2DayRemain)     ;hero number
  ld    b,090+30                        ;dx
  ld    c,033+13                        ;dy
  call  .SetHeroName

  ld    a,(iy+TavernHero3DayRemain)     ;hero number
  ld    b,176+30                        ;dx
  ld    c,033+13                        ;dy
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
    
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret
  
SettavernHeroIcons:  
  ld    a,(iy+TavernHero1DayRemain)     ;hero number
  ld    de,DYDX16x30HeroIconTavernWindow1
  call  .SetHeroIcon
  ld    a,(iy+TavernHero2DayRemain)     ;hero number
  ld    de,DYDX16x30HeroIconTavernWindow2
  call  .SetHeroIcon
  ld    a,(iy+TavernHero3DayRemain)     ;hero number
  ld    de,DYDX16x30HeroIconTavernWindow3
  call  .SetHeroIcon
  ret
  
  .SetHeroIcon:
  or    a
  ret   z

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

  pop   de                                  ;DYDX16x30HeroIconTavernWindow1,2,3
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
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,045
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,061
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,077
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,093
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,109
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0
  ret

  .army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXDefendingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,SetVisitingHeroArmyAndAmount.UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

DYDXDefendingHeroUnit1:          equ (181*128) + (028/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXDefendingHeroUnit2:          equ (181*128) + (044/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXDefendingHeroUnit3:          equ (181*128) + (060/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXDefendingHeroUnit4:          equ (181*128) + (076/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXDefendingHeroUnit5:          equ (181*128) + (092/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXDefendingHeroUnit6:          equ (181*128) + (108/2) - 128      ;(dy*128 + dx/2) = (204,153)

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
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,173
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,189
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,205
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,221
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,237
  ld    c,197
  call  SetNumber16BitCastleSkipIfAmountIs0
  ret

  .army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit1    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit2    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit3    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit4    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit5    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXVisitingHeroUnit6    ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,.UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128
.UnitSYSXTable14x24Portraits:  
                dw $8000+(00*128)+(00/2)-128, $8000+(00*128)+(14/2)-128, $8000+(00*128)+(28/2)-128, $8000+(00*128)+(42/2)-128, $8000+(00*128)+(56/2)-128, $8000+(00*128)+(70/2)-128, $8000+(00*128)+(84/2)-128, $8000+(00*128)+(98/2)-128, $8000+(00*128)+(112/2)-128, $8000+(00*128)+(126/2)-128, $8000+(00*128)+(140/2)-128, $8000+(00*128)+(154/2)-128, $8000+(00*128)+(168/2)-128, $8000+(00*128)+(182/2)-128, $8000+(00*128)+(196/2)-128, $8000+(00*128)+(210/2)-128, $8000+(00*128)+(224/2)-128, $8000+(00*128)+(238/2)-128
                dw $8000+(14*128)+(00/2)-128, $8000+(14*128)+(14/2)-128, $8000+(14*128)+(28/2)-128, $8000+(14*128)+(42/2)-128, $8000+(14*128)+(56/2)-128, $8000+(14*128)+(70/2)-128, $8000+(14*128)+(84/2)-128, $8000+(14*128)+(98/2)-128, $8000+(14*128)+(112/2)-128, $8000+(14*128)+(126/2)-128, $8000+(14*128)+(140/2)-128, $8000+(14*128)+(154/2)-128, $8000+(14*128)+(168/2)-128, $8000+(14*128)+(182/2)-128, $8000+(14*128)+(196/2)-128, $8000+(14*128)+(210/2)-128, $8000+(14*128)+(224/2)-128, $8000+(14*128)+(238/2)-128
                dw $8000+(28*128)+(00/2)-128, $8000+(28*128)+(14/2)-128, $8000+(28*128)+(28/2)-128, $8000+(28*128)+(42/2)-128, $8000+(28*128)+(56/2)-128, $8000+(28*128)+(70/2)-128, $8000+(28*128)+(84/2)-128, $8000+(28*128)+(98/2)-128, $8000+(28*128)+(112/2)-128, $8000+(28*128)+(126/2)-128, $8000+(28*128)+(140/2)-128, $8000+(28*128)+(154/2)-128, $8000+(28*128)+(168/2)-128, $8000+(28*128)+(182/2)-128, $8000+(28*128)+(196/2)-128, $8000+(28*128)+(210/2)-128, $8000+(28*128)+(224/2)-128, $8000+(28*128)+(238/2)-128
                dw $8000+(42*128)+(00/2)-128, $8000+(42*128)+(14/2)-128, $8000+(42*128)+(28/2)-128, $8000+(42*128)+(42/2)-128, $8000+(42*128)+(56/2)-128, $8000+(42*128)+(70/2)-128, $8000+(42*128)+(84/2)-128, $8000+(42*128)+(98/2)-128, $8000+(42*128)+(112/2)-128, $8000+(42*128)+(126/2)-128, $8000+(42*128)+(140/2)-128, $8000+(42*128)+(154/2)-128, $8000+(42*128)+(168/2)-128, $8000+(42*128)+(182/2)-128, $8000+(42*128)+(196/2)-128, $8000+(42*128)+(210/2)-128, $8000+(42*128)+(224/2)-128, $8000+(42*128)+(238/2)-128
                dw $8000+(56*128)+(00/2)-128, $8000+(56*128)+(14/2)-128, $8000+(56*128)+(28/2)-128, $8000+(56*128)+(42/2)-128, $8000+(56*128)+(56/2)-128, $8000+(56*128)+(70/2)-128, $8000+(56*128)+(84/2)-128, $8000+(56*128)+(98/2)-128, $8000+(56*128)+(112/2)-128, $8000+(56*128)+(126/2)-128, $8000+(56*128)+(140/2)-128, $8000+(56*128)+(154/2)-128, $8000+(56*128)+(168/2)-128, $8000+(56*128)+(182/2)-128, $8000+(56*128)+(196/2)-128, $8000+(56*128)+(210/2)-128, $8000+(56*128)+(224/2)-128, $8000+(56*128)+(238/2)-128
                dw $8000+(70*128)+(00/2)-128, $8000+(70*128)+(14/2)-128, $8000+(70*128)+(28/2)-128, $8000+(70*128)+(42/2)-128, $8000+(70*128)+(56/2)-128, $8000+(70*128)+(70/2)-128, $8000+(70*128)+(84/2)-128, $8000+(70*128)+(98/2)-128, $8000+(70*128)+(112/2)-128, $8000+(70*128)+(126/2)-128, $8000+(70*128)+(140/2)-128, $8000+(70*128)+(154/2)-128, $8000+(70*128)+(168/2)-128, $8000+(70*128)+(182/2)-128, $8000+(70*128)+(196/2)-128, $8000+(70*128)+(210/2)-128, $8000+(70*128)+(224/2)-128, $8000+(70*128)+(238/2)-128
                dw $8000+(84*128)+(00/2)-128, $8000+(84*128)+(14/2)-128, $8000+(84*128)+(28/2)-128, $8000+(84*128)+(42/2)-128, $8000+(84*128)+(56/2)-128, $8000+(84*128)+(70/2)-128, $8000+(84*128)+(84/2)-128, $8000+(84*128)+(98/2)-128, $8000+(84*128)+(112/2)-128, $8000+(84*128)+(126/2)-128, $8000+(84*128)+(140/2)-128, $8000+(84*128)+(154/2)-128, $8000+(84*128)+(168/2)-128, $8000+(84*128)+(182/2)-128, $8000+(84*128)+(196/2)-128, $8000+(84*128)+(210/2)-128, $8000+(84*128)+(224/2)-128, $8000+(84*128)+(238/2)-128

DYDXVisitingHeroUnit1:          equ (181*128) + (156/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXVisitingHeroUnit2:          equ (181*128) + (172/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXVisitingHeroUnit3:          equ (181*128) + (188/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXVisitingHeroUnit4:          equ (181*128) + (204/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXVisitingHeroUnit5:          equ (181*128) + (220/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXVisitingHeroUnit6:          equ (181*128) + (236/2) - 128      ;(dy*128 + dx/2) = (204,153)

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
  ld    a,(iy+TavernHero1DayRemain)
  or    a
  ld    de,GenericButtonTable2+1+(GenericButtonTableLenghtPerButton*0)
  call  z,.AlreadyRecruitedSetBrown

  ld    a,(iy+TavernHero2DayRemain)
  or    a
  ld    de,GenericButtonTable2+1+(GenericButtonTableLenghtPerButton*1)
  call  z,.AlreadyRecruitedSetBrown

  ld    a,(iy+TavernHero3DayRemain)
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










CastleOverviewMarketPlaceCode:
  call  SetScreenOff


  call  SetMarketPlaceButtons




  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a
  ld    (PreviousButton2Clicked),a
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix
  ld    (PreviousButton2ClickedIX),ix



  ld    hl,World1Palette
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

  halt
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

  ld    b,069                           ;dx
  ld    c,128                           ;dy
  ld    hl,(AmountOfResourcesOffered)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    b,167                           ;dx
  ld    c,128                           ;dy
  ld    hl,(AmountOfResourcesRequired)
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  
  ret

.TextCostRequireWoodTradeStone:  dw 0001,0010 
.TextCostRequireWoodTradeGems:   dw 0001,0005
.TextCostRequireWoodTradeGold:   dw 0001,2500

.TextCostRequireGemTradeStone:   dw 0001,0020
.TextCostRequireGemTradeGems:    dw 0001,0010
.TextCostRequireGemTradeGold:    dw 0001,5000

.TextCostRequireGoldTradeWood:   dw 0025,0001
.TextCostRequireGoldTradeRuby:   dw 0050,0001
.TextCostRequireGoldTradeGold:   dw 0001,0001

  .SetTradeCostInHL:
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
  ld    a,127
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,128
  ld    (PutLetter+dy),a                ;set dy of text

  ld    a,(MarketPlaceResourceNeeded)
  call  .SetTextResourceInHL
  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret

  .SetTextResourceToTrade:
  ld    a,227
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,128
  ld    (PutLetter+dy),a                ;set dy of text

  ld    a,(MarketPlaceResourceToTrade)
  call  .SetTextResourceInHL
  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret

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
  ld    bc,$0000 + (044*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

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
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
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


CastleOverviewMagicGuildCode:
  call  SetScreenOff


  call  SetMagicGuildButtons

  ld    hl,World1Palette
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

  halt
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
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth1
  jp    z,.SpellFound
  ld    hl,EarthLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth2
  jp    z,.SpellFound
  ld    hl,EarthLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth3
  jp    z,.SpellFound
  ld    hl,EarthLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth4
  jp    z,.SpellFound

  ld    hl,FireLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire1
  jp    z,.SpellFound
  ld    hl,FireLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire2
  jp    z,.SpellFound
  ld    hl,FireLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire3
  jp    z,.SpellFound
  ld    hl,FireLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire4
  jp    z,.SpellFound

  ld    hl,AirLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir1
  jp    z,.SpellFound
  ld    hl,AirLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir2
  jp    z,.SpellFound
  ld    hl,AirLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir3
  jp    z,.SpellFound
  ld    hl,AirLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir4
  jp    z,.SpellFound

  ld    hl,WaterLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater1
  jp    z,.SpellFound
  ld    hl,WaterLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater2
  jp    z,.SpellFound
  ld    hl,WaterLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater3
  jp    z,.SpellFound
  ld    hl,WaterLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater4
  jp    z,.SpellFound
  
  .SpellFound:
  ld    a,031
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,154
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ex    de,hl
;  ld    hl,FireLevel1Untouched
  ld    de,$0000 + (156*128) + (010/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,SpellBookGraphicsBlock        ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret



SpellDescriptionsMagicGuild:
.DescriptionEarth1:        db  "earth meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth2:        db  "earth",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth3:        db  "earthstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth4:        db  "earthbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.DescriptionFire1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire2:        db  "fire",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire3:        db  "firestorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire4:        db  "firebullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.Descriptionair1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair2:        db  "air",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair3:        db  "airstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair4:        db  "airbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.Descriptionwater1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater2:        db  "water",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater3:        db  "waterstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater4:        db  "waterbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255












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
  call  CopyTransparantButtons          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




;  halt


  ret

CopyTransparantButtons:  
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

SetMagicGuildButtons:
  ld    hl,MagicGuildButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*8)
  ldir

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

MagicGuildButtonTableLenghtPerButton:  equ MagicGuildButtonTable.endlenght-MagicGuildButtonTable
MagicGuildButtonTableGfxBlock:  db  SpellBookGraphicsBlock
MagicGuildButtonTableAmountOfButtons:  db  8
MagicGuildButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
;level 1 spells
  db  %1100 0011 | dw FireLevel1Untouched   | dw FireLevel1Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel1Y ,MagicGuildFireLevel1Y+16 ,MagicGuildFireLevel1X ,MagicGuildFireLevel1X+16  | dw $0000 + (MagicGuildFireLevel1Y*128)  + (MagicGuildFireLevel1X/2)  - 128 |
  .endlenght:
  db  %1100 0011 | dw WaterLevel1Untouched  | dw WaterLevel1Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel1Y,MagicGuildWaterLevel1Y+16,MagicGuildWaterLevel1X,MagicGuildWaterLevel1X+16 | dw $0000 + (MagicGuildWaterLevel1Y*128) + (MagicGuildWaterLevel1X/2) - 128 | 
;level 2 spells
  db  %1100 0011 | dw WaterLevel2Untouched  | dw WaterLevel2Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel2Y,MagicGuildWaterLevel2Y+16,MagicGuildWaterLevel2X,MagicGuildWaterLevel2X+16 | dw $0000 + (MagicGuildWaterLevel2Y*128) + (MagicGuildWaterLevel2X/2) - 128 | 
  db  %1100 0011 | dw AirLevel2Untouched    | dw AirLevel2Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel2Y  ,MagicGuildAirLevel2Y+16  ,MagicGuildAirLevel2X  ,MagicGuildAirLevel2X+16   | dw $0000 + (MagicGuildAirLevel2Y*128)   + (MagicGuildAirLevel2X/2) - 128   | 
;level 3 spells
  db  %1100 0011 | dw FireLevel3Untouched   | dw FireLevel3Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel3Y ,MagicGuildFireLevel3Y+16 ,MagicGuildFireLevel3X ,MagicGuildFireLevel3X+16  | dw $0000 + (MagicGuildFireLevel3Y*128)  + (MagicGuildFireLevel3X/2)  - 128 |
  db  %1100 0011 | dw EarthLevel3Untouched  | dw EarthLevel3Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel3Y,MagicGuildEarthLevel3Y+16,MagicGuildEarthLevel3X,MagicGuildEarthLevel3X+16 | dw $0000 + (MagicGuildEarthLevel3Y*128) + (MagicGuildEarthLevel3X/2) - 128 | 
;level 4 spells
  db  %1100 0011 | dw AirLevel4Untouched    | dw AirLevel4Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel4Y  ,MagicGuildAirLevel4Y+16  ,MagicGuildAirLevel4X  ,MagicGuildAirLevel4X+16   | dw $0000 + (MagicGuildAirLevel4Y*128)   + (MagicGuildAirLevel4X/2) - 128   | 
  db  %1100 0011 | dw EarthLevel4Untouched  | dw EarthLevel4Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel4Y,MagicGuildEarthLevel4Y+16,MagicGuildEarthLevel4X,MagicGuildEarthLevel4X+16 | dw $0000 + (MagicGuildEarthLevel4Y*128) + (MagicGuildEarthLevel4X/2) - 128 | 

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
  ld    hl,World1Palette
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

  halt
  call  SetScreenOn
  jp  .engine

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
  ld    a,(SelectedCastleRecruitLevelUnit)

  cp    1
  jr    nz,.EndCheckUnitLevel1  
  ld    l,(iy+CastleLevel1UnitsAvail+00)
  ld    h,(iy+CastleLevel1UnitsAvail+01)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+00),l
  ld    (iy+CastleLevel1UnitsAvail+01),h
  ret
  .EndCheckUnitLevel1:

  cp    2
  jr    nz,.EndCheckUnitLevel2  
  ld    l,(iy+CastleLevel1UnitsAvail+02)
  ld    h,(iy+CastleLevel1UnitsAvail+03)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+02),l
  ld    (iy+CastleLevel1UnitsAvail+03),h
  ret
  .EndCheckUnitLevel2:

  cp    3
  jr    nz,.EndCheckUnitLevel3 
  ld    l,(iy+CastleLevel1UnitsAvail+04)
  ld    h,(iy+CastleLevel1UnitsAvail+05)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+04),l
  ld    (iy+CastleLevel1UnitsAvail+05),h
  ret
  .EndCheckUnitLevel3:

  cp    4
  jr    nz,.EndCheckUnitLevel4
  ld    l,(iy+CastleLevel1UnitsAvail+06)
  ld    h,(iy+CastleLevel1UnitsAvail+07)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+06),l
  ld    (iy+CastleLevel1UnitsAvail+07),h
  ret
  .EndCheckUnitLevel4:

  cp    5
  jr    nz,.EndCheckUnitLevel5
  ld    l,(iy+CastleLevel1UnitsAvail+08)
  ld    h,(iy+CastleLevel1UnitsAvail+09)
  sbc   hl,de
  ld    (iy+CastleLevel1UnitsAvail+08),l
  ld    (iy+CastleLevel1UnitsAvail+09),h
  ret
  .EndCheckUnitLevel5:

  cp    6
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

DivideBCbyDE:
;
; Divide 16-bit values (with 16-bit result)
; In: Divide BC by divider DE
; Out: BC = result, HL = rest
;
Div16:
    ld hl,0
    ld a,b
    ld b,8
Div16_Loop1:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd1
    add hl,de
Div16_NoAdd1:
    djnz Div16_Loop1
    rla
    cpl
    ld b,a
    ld a,c
    ld c,b
    ld b,8
Div16_Loop2:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd2
    add hl,de
Div16_NoAdd2:
    djnz Div16_Loop2
    rla
    cpl
    ld b,c
    ld c,a
    ret












SetCostSelectedCreatureInHL:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,CostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl
  ret

SetGemsCostSelectedCreatureInHL:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,GemsCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl
  ret

SetRubiesCostSelectedCreatureInHL:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,RubiesCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl
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

MultiplyHlWithDE:
  push  hl
  pop   bc
;
; Multiply 16-bit values (with 16-bit result)
; In: Multiply BC with DE
; Out: HL = result
;
Mult16:
    ld a,b
    ld b,16
Mult16_Loop:
    add hl,hl
    sla c
    rla
    jr nc,Mult16_NoAdd
    add hl,de
Mult16_NoAdd:
    djnz Mult16_Loop
    ret







SetNumber16BitCastleSkipIfAmountIs0:
  ld    a,h
  cp    l
  ret   z

SetNumber16BitCastle:                   ;in hl=number (16bit)
;  ld    a,"0"                           ;we can set number to 0, then do a zero check and jr z,.zero to put the number 0 at the furthest left side if needed
;  ld    (TextNumber),a
;  ld    a,255
;  ld    (TextNumber+1),a

  ld    a,b                             ;dx
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c                             ;dy
  ld    (PutLetter+dy),a                ;set dy of text

;  ld    a,h
;  cp    l
;  ret   z
;  jr    z,.Zero

  push  iy
  call  .ConvertToDecimal16bit
  pop   iy

;  .Zero:
  ld    hl,TextNumber
  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret



  .ConvertToDecimal16bit:
  ld    iy,TextNumber
  ld    e,0                             ;e=has an xfold already been set prior ?

  .Check10000Folds:
  ld    d,$30                           ;10000folds in d ($30 = 0)

  .Loop10000Fold:
  or    a
  ld    bc,10000
  sbc   hl,bc                           ;check for 10000 folds
  jr    c,.Set10000Fold
  inc   d
  jr  .Loop10000Fold

  .Set10000Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet10000Fold  
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 1000fold
  inc   iy
  .EndSet10000Fold:

  add   hl,bc

  .Check1000Folds:
  ld    d,$30                           ;1000folds in d ($30 = 0)

  .Loop1000Fold:
  or    a
  ld    bc,1000
  sbc   hl,bc                           ;check for 1000 folds
  jr    c,.Set1000Fold
  inc   d
  jr  .Loop1000Fold

  .Set1000Fold:
  bit   0,e
  jr    nz,.DoSet1000Fold    
  ld    a,d
  cp    $30
  jr    z,.EndSet1000Fold  
  ld    e,1                             ;e=has an xfold already been set prior ?
  .DoSet1000Fold:
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet1000Fold:

  add   hl,bc

  .Check100Folds:
  ld    d,$30                           ;100folds in d ($30 = 0)

  .Loop100Fold:
  or    a
  ld    bc,100
  sbc   hl,bc                           ;check for 100 folds
  jr    c,.Set100Fold
  inc   d
  jr  .Loop100Fold

  .Set100Fold:
  bit   0,e
  jr    nz,.DoSet100Fold  
  ld    a,d
  cp    $30
  jr    nz,.DoSet100Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,4
  ld    (PutLetter+dx),a                ;set dx of text


  jr    .EndSet100Fold  

  .DoSet100Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet100Fold:

  add   hl,bc

  .Check10Folds:
  ld    d,$30                           ;10folds in d ($30 = 0)

  .Loop10Fold:
  or    a
  ld    bc,10
  sbc   hl,bc                           ;check for 10 folds
  jr    c,.Set10Fold
  inc   d
  jr  .Loop10Fold

  .Set10Fold:
  bit   0,e
  jr    nz,.DoSet10Fold
  ld    a,d
  cp    $30
  jr    nz,.DoSet10Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,3
  ld    (PutLetter+dx),a                ;set dx of text

  jr    .EndSet10Fold  

  .DoSet10Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 10fold
  inc   iy
  .EndSet10Fold:

  .Check1Fold:
  ld    bc,10 + $30
  add   hl,bc
  
;  add   a,10 + $30
  ld    (iy),l                          ;set 1 fold
  ld    (iy+1),255                      ;end text
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

;  halt

  call  SetScreenOn
  
  jp  .engine

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
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;market place
  ld    hl,(BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;tavern place
  ld    hl,(BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton


  ;magic guild
  ld    hl,(BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (004 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;sawmill
  ld    hl,(BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;mine
  ld    hl,(BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton


  ;barracks
  ld    hl,(BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (004 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;barracks tower
  ld    hl,(BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton

  ;city walls
  ld    hl,(BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton))
  ld    de,GreenBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetGreenButton








  ;castle
  ld    hl,(BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (004 + xOffsetVandX)
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;market place
  ld    hl,(BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;tavern place
  ld    hl,(BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(042 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((042 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton


  ;magic guild
  ld    hl,(BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (004 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;sawmill
  ld    hl,(BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;mine
  ld    hl,(BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(092 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((092 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton


  ;barracks
  ld    hl,(BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (004 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((004 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;barracks tower
  ld    hl,(BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (064 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton

  ;city walls
  ld    hl,(BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton))
  ld    de,RedBuildButton
  call  CompareHLwithDE
  ld    de,256*(142 + YOffsetVandX) + (124 + xOffsetVandX)
  exx
  ld    de,$0000 + ((142 + YOffsetVandX)*128) + ((124 + xOffsetVandX)/2) - 128  ;y,x
  call  z,.SetRedButton
  ret

.SetGreenButton:
;  ld    de,256*(42+YOffsetVandX) + (064 + xOffsetVandX)
;  exx
  ld    hl,$4000 + (114*128) + (200/2) - 128  ;y,x
;  ld    de,$0000 + ((042+YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  ld    bc,$0000 + (017*256) + (018/2)        ;ny,nx
  ld    a,ButtonsBuildBlock      ;font graphics block
  call  CopyTransparantImage
  ret

.SetRedButton:
;  ld    de,256*(42+YOffsetVandX) + (064 + xOffsetVandX)
;  exx
  ld    hl,$4000 + (115*128) + (218/2) - 128  ;y,x
;  ld    de,$0000 + ((042+YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
  ld    bc,$0000 + (016*256) + (014/2)        ;ny,nx
  ld    a,ButtonsBuildBlock      ;font graphics block
  call  CopyTransparantImage
  ret



;  Example of input:
;  ld    de,256*(42+YOffsetVandX) + (064 + xOffsetVandX)
;  exx
;  ld    hl,$4000 + (114*128) + (200/2) - 128  ;y,x
;  ld    de,$0000 + ((042+YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
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

  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  exx
  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    hl,CopyCastleButton2
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  ret

;CopyCastleButton2:
;	db		000,0,212,1
;	db		100,0,100,255
;	db		020,0,030,0
;	db		0,%0000 0000,$98




CheckButtonMouseInteractionSingleBuildButton:  
  bit   7,(ix+BuildButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+BuildButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
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
  inc   (iy+CastleLevel)
  jp    PurchaseBuilding

  .MarketPlace:  
  ld    (iy+CastleMarket),1
  jp    PurchaseBuilding

  .Tavern:
  ld    (iy+CastleTavern),1
  jp    PurchaseBuilding

  .MagicGuild:
  inc   (iy+CastleMageGuildLevel)
  jp    PurchaseBuilding

  .Sawmill:
  inc   (iy+CastleSawmillLevel)
  jp    PurchaseBuilding

  .Mine:
  inc   (iy+CastleMineLevel)
  jp    PurchaseBuilding

  .BarracksTower:
  .Barracks:
  inc   (iy+CastleBarracksLevel)
  jp    PurchaseBuilding

PurchaseBuilding:
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
  ld    hl,BarracksLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet


  .Mine:
  ld    de,BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMineLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MineLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Sawmill:
  ld    de,BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleSawmillLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,SawmillLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .MagicGuild:
  ld    de,BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMageGuildLevel)
  cp    4
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MagicGuildLevel1Cost
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



SetResourcesCurrentPlayerinIX:
	ld		a,(whichplayernowplaying?)
  ld    ix,ResourcesPlayer1
  cp    1
  ret   z
  ld    ix,ResourcesPlayer2
  cp    2
  ret   z
  ld    ix,ResourcesPlayer3
  cp    3
  ret   z
  ld    ix,ResourcesPlayer4
  cp    4
  ret   z
  ret

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
  ld    de,CityWallsCost
  ld    hl,TextCityWalls
  jp    z,.SetWhichTextToPut
  cp    2                                     ;BarracksTower
  ld    de,BarracksTowerCost
  ld    hl,TextBarracksTower
  jp    z,.SetWhichTextToPut
  cp    3                                     ;Barracks
  jp    z,.Barracks
  cp    4                                     ;Mine
  jp    z,.Mine
  cp    5                                     ;Sawmill
  jp    z,.Sawmill
  cp    6                                     ;MagicGuild
  jp    z,.MagicGuild
  cp    7                                     ;Tavern
  ld    de,TavernCost
  ld    hl,TextTavern
  jp    z,.SetWhichTextToPut
  cp    8                                     ;MarketPlace
  ld    de,MarketPlaceCost
  ld    hl,TextMarketPlace
  jp    z,.SetWhichTextToPut
  cp    9                                     ;Castle
  jp    z,.Castle

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

CastleLevel5Cost:             ;Capitol
.Gold:    dw  10000
.Wood:    dw  020
.Ore:     dw  020
.Gems:    dw  000
.Rubies:  dw  000

TextMarketPlace:        
                          db  " Market Place",254
                          db  " ",254
                          db  "Allows trading of",254
                          db  "resources",254
                          db  " ",254
                          db  "Cost:",254
                          db  "500 Gold",254
                          db  "+5 Wood",255

MarketPlaceCost:
.Gold:    dw  500
.Wood:    dw  05
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextTavern:        
                          db  "    Tavern",254
                          db  " ",254
                          db  "Allows the ability",254
                          db  "to recruit",254
                          db  "visiting heroes",254
                          db  " ",254
                          db  "Cost:",254
                          db  "500 Gold",254
                          db  "+5 Wood",255

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
                          db  "Visiting heroes",254
                          db  "can learn these",254
                          db  "spells if the",254
                          db  "skill requirements",254
                          db  "are met",254
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

MineLevel3Cost:
.Gold:    dw  5000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksLevel1:        
                          db  "  Barracks 1",254
                          db  " ",254
                          db  "Allows production",254
                          db  "of level 1 units",254
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
                          db  "Allows production",254
                          db  "of level 2 units",254
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
                          db  "Allows production",254
                          db  "of level 3 units",254
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
                          db  "Allows production",254
                          db  "of level 4 units",254
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
                          db  "Allows production",254
                          db  "of level 5 units",254
                          db  " ",254
                          db  "Replenishes every",254
                          db  "week",254
                          db  " ",254
                          db  "Cost:",254
                          db  "5000 Gold",254
                          db  "+20 Wood",255

BarracksLevel5Cost:
.Gold:    dw  5000
.Wood:    dw  20
.Ore:     dw  00
.Gems:    dw  00
.Rubies:  dw  00

TextBarracksTower:        
                          db  " Barracks Tower",254
                          db  " ",254
                          db  "Allows production",254
                          db  "of level 6 units",254
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

BarracksTowerCost:
.Gold:    dw  20000
.Wood:    dw  00
.Ore:     dw  00
.Gems:    dw  20
.Rubies:  dw  20

TextCityWalls:        
                          db  "   City Walls",254
                          db  " ",254
                          db  "fortifies your",254
                          db  "city with a wall",254
                          db  " to defend",254
                          db  "against sieges",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "+15 Wood",254
                          db  "+15 Ore",254
                          db  " ",254
                          db  "Requirements:",254
                          db  "Capitol",255

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

  ld    a,(iy+CastleLevel)
  cp    1                               ;village hall (500 gold per day)
  ld    hl,500
  jr    z,.CastleLevelFound

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
  ld    b,196                           ;dx
  ld    c,009                           ;dy
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    b,219
  ld    c,009
  ld    hl,TextGoldPerDay
  call  SetText
  ret


CastleOverviewCode:                     ;in: iy-castle
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

  call  SetCastleOverviewGraphics       ;put gfx in page 1
  call  SwapAndSetPage                  ;swap to and set page 1
  call  SetIndividualBuildings          ;put buildings in page 0, then docopy them from page 0 to page 1 transparantly
  call  SwapAndSetPage                  ;swap to and set page 1  
  call  SetNameCastleAndDailyIncome

  ld    hl,CopyPage1To0
  call  docopy

  ld    a,179
  call  SetExitButtonHeight
  call  SetActiveCastleOverviewButtons
  
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy


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





  halt

  call  SetScreenOn
    
  jp  .engine


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









NameCreature000:  db  "Empty:",255
NameCreature001:  db  "Green Ghoul:",255
NameCreature002:  db  "Drollie:",255
NameCreature003:  db  "Wappie:",255
NameCreature004:  db  "Green Ghoul:",255
NameCreature005:  db  "Green Ghoul:",255
NameCreature006:  db  "Green Ghoul:",255
NameCreature007:  db  "Green Ghoul:",255
NameCreature008:  db  "Green Ghoul:",255
NameCreature009:  db  "Green Ghoul:",255
NameCreature010:  db  "Green Ghoul:",255
NameCreature011:  db  "Green Ghoul:",255
NameCreature012:  db  "Green Ghoul:",255
NameCreature013:  db  "Green Ghoul:",255
NameCreature014:  db  "Green Ghoul:",255
NameCreature015:  db  "Green Ghoul:",255
NameCreature016:  db  "Green Ghoul:",255
NameCreature017:  db  "Green Ghoul:",255
NameCreature018:  db  "Green Ghoul:",255
NameCreature019:  db  "Green Ghoul:",255
NameCreature020:  db  "Green Ghoul:",255
NameCreature021:  db  "Green Ghoul:",255
NameCreature022:  db  "Green Ghoul:",255
NameCreature023:  db  "Green Ghoul:",255
NameCreature024:  db  "Green Ghoul:",255
NameCreature025:  db  "Green Ghoul:",255
NameCreature026:  db  "Green Ghoul:",255
NameCreature027:  db  "Green Ghoul:",255
NameCreature028:  db  "Green Ghoul:",255
NameCreature029:  db  "Green Ghoul:",255
NameCreature030:  db  "Green Ghoul:",255
NameCreature031:  db  "Green Ghoul:",255
NameCreature032:  db  "Green Ghoul:",255
NameCreature033:  db  "Green Ghoul:",255
NameCreature034:  db  "Green Ghoul:",255
NameCreature035:  db  "Green Ghoul:",255
NameCreature036:  db  "Green Ghoul:",255
NameCreature037:  db  "Green Ghoul:",255
NameCreature038:  db  "Green Ghoul:",255
NameCreature039:  db  "Green Ghoul:",255
NameCreature040:  db  "Green Ghoul:",255
NameCreature041:  db  "Green Ghoul:",255
NameCreature042:  db  "Green Ghoul:",255
NameCreature043:  db  "Green Ghoul:",255
NameCreature044:  db  "Green Ghoul:",255
NameCreature045:  db  "Green Ghoul:",255
NameCreature046:  db  "Green Ghoul:",255
NameCreature047:  db  "Green Ghoul:",255
NameCreature048:  db  "Green Ghoul:",255
NameCreature049:  db  "Green Ghoul:",255
NameCreature050:  db  "Green Ghoul:",255
NameCreature051:  db  "Green Ghoul:",255
NameCreature052:  db  "Green Ghoul:",255
NameCreature053:  db  "Green Ghoul:",255
NameCreature054:  db  "Green Ghoul:",255
NameCreature055:  db  "Green Ghoul:",255
NameCreature056:  db  "Green Ghoul:",255
NameCreature057:  db  "Green Ghoul:",255
NameCreature058:  db  "Green Ghoul:",255
NameCreature059:  db  "Green Ghoul:",255
NameCreature060:  db  "Green Ghoul:",255
NameCreature061:  db  "Green Ghoul:",255
NameCreature062:  db  "Green Ghoul:",255
NameCreature063:  db  "Green Ghoul:",255


CostCreatureTable:  
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

GemsCostCreatureTable:  
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

RubiesCostCreatureTable:  
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

SpeedCreatureTable:  
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

DefenseCreatureTable:  
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

AttackCreatureTable:  
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015
  db  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015

CreatureNameTable:  
  dw NameCreature000,NameCreature001,NameCreature002,NameCreature003,NameCreature004,NameCreature005,NameCreature006,NameCreature007,NameCreature008,NameCreature009,NameCreature010,NameCreature011,NameCreature012,NameCreature013,NameCreature014,NameCreature015
  dw NameCreature016,NameCreature017,NameCreature018,NameCreature019,NameCreature020,NameCreature021,NameCreature022,NameCreature023,NameCreature024,NameCreature025,NameCreature026,NameCreature027,NameCreature028,NameCreature029,NameCreature030,NameCreature031
  dw NameCreature032,NameCreature033,NameCreature034,NameCreature035,NameCreature036,NameCreature037,NameCreature038,NameCreature039,NameCreature040,NameCreature041,NameCreature042,NameCreature043,NameCreature044,NameCreature045,NameCreature046,NameCreature047
  dw NameCreature048,NameCreature049,NameCreature050,NameCreature051,NameCreature052,NameCreature053,NameCreature054,NameCreature055,NameCreature056,NameCreature057,NameCreature058,NameCreature059,NameCreature060,NameCreature061,NameCreature062,NameCreature063




















