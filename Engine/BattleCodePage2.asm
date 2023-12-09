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
  ld    a,BattleFieldSnowBlock         ;font graphics block
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

  






















