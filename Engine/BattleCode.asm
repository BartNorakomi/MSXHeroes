InitiateBattle:
call screenon
  xor   a
	ld		(activepage),a			
  call  SetBattleFieldSnowGraphics
  ld    hl,.CopyPage1To2
  call  DoCopy
  call  SwapAndSetPage                  ;swap and set page
  call  SetBattleFieldSnowGraphics


  .engine:
;  ld    a,(activepage)
;  call  Backdrop.in
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys
  call  HandleMonsters
  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  ld    a,03                ;we can store the previous vblankintflag time and cp the current with that value
  ld    hl,vblankintflag    ;this way we speed up the engine when not scrolling
  .checkflag:
  cp    (hl)
  jr    nc,.checkflag
  ld    (hl),0
;  halt
  jp  .engine

.CopyPage1To2:
	db		0,0,0,1
	db		0,0,0,2
	db		0,1,212,0
	db		0,0,$d0	

HandleMonsters:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
  bit   4,a
  jr    z,.EndCheckSpace

  ld    a,(CurrentActiveMonster)
  xor   1
  ld    (CurrentActiveMonster),a
  .EndCheckSpace:


  ld    a,(CurrentActiveMonster)
  or    a
  ld    ix,Monster0
  jp    z,HandleMonster
  dec   a
  ld    ix,Monster1
  jp    z,HandleMonster
  ret

HandleMonster:
  ld    l,(ix+MonsterSYXY+0)            ;SY SX in rom
  ld    h,(ix+MonsterSYXY+1)

  ld    a,(framecounter)
  and   7
  cp    4
  jr    c,.EndAnimation
  ld    de,28
  add   hl,de
  .EndAnimation:
  

  ld    c,(ix+MonsterNYNY+0)            ;NY NX
  ld    b,(ix+MonsterNYNY+1)
  ld    a,(ix+MonsterBlock+0)           ;Romblock of sprite

  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (BlockToReadFrom),a

  call  EraseMonsterPreviousFrame
  call  MoveMonster
  call  PutMonster
  ret
  
MoveMonster:
  ld    a,(ix+MonsterY)
  ld    (ix+MonsterYPrevious),a
  ld    a,(ix+MonsterX)
  ld    (ix+MonsterXPrevious),a

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(controls)
  bit   0,a
  jr    nz,.up
  bit   1,a
  jr    nz,.down
  bit   2,a
  jr    nz,.left
  bit   3,a
  jr    nz,.right
  ret

  .up:
  ld    a,(ix+MonsterY)
  sub   a,9
  ld    (ix+MonsterY),a
  ret

  .down:
  ld    a,(ix+MonsterY)
  add   a,9
  ld    (ix+MonsterY),a
  ret

  .left:
  ld    a,(ix+MonsterX)
  sub   a,9
  ld    (ix+MonsterX),a
  ret

  .right:
  ld    a,(ix+MonsterX)
  add   a,9
  ld    (ix+MonsterX),a
  ret

EraseMonsterPreviousFrame:
	ld		a,(activepage)
  xor   1
	ld    (EraseMonster+dPage),a

  ld    a,(ix+MonsterYPrevious)
  ld    (EraseMonster+sy),a             ;since we copy from the bottom upwards, sy has to be -1
  ld    (EraseMonster+dy),a

  ld    a,(ix+MonsterXPrevious)
  ld    (EraseMonster+dx),a
  ld    (EraseMonster+sx),a

  ld    bc,(NXAndNY)
  ld    a,c
  inc   a  
  add   a,a
  ld    (EraseMonster+nx),a
  ld    a,b
  ld    (EraseMonster+ny),a

  ld    hl,EraseMonster
  call  docopy
  ret

PutMonster:
	ld		a,(activepage)
  xor   1
	ld    (TransparantImageBattle+dPage),a

  ld    a,(ix+MonsterY)
  ld    (TransparantImageBattle+dy),a  
  ld    a,(ix+MonsterX)
  ld    (TransparantImageBattle+dx),a

  ld    bc,(NXAndNY)
  ld    a,c
  add   a,a
  ld    (TransparantImageBattle+nx),a
  ld    a,b
  ld    (TransparantImageBattle+ny),a
  dec   a
  ld    (TransparantImageBattle+sy),a   ;since we copy from the bottom upwards, sy has to be -1

  ld    a,(TransparantImageBattle+sx)
  add   a,64                            ;address to read from in page 3. every next copy will have it's dx+sx increased by 64
  ld    (TransparantImageBattle+sx),a
  ld    de,$8000 + (000*128) + (000/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (000*128) + (064/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (000*128) + (128/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (000*128) + (192/2) - 128  ;dy,dx
  .DestinationAddressInPage3Set:
  ld    (AddressToWriteTo),de           ;address to write to in page 3

  call  CopyRamToVramPag3          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,TransparantImageBattle
  call  docopy
  ret


  
;Battle Screen Map (25x8)
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.

SetBattleFieldSnowGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,BattleFieldSnowBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY








  ;at the end of combat we have 4 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled
;  ld    ix,(plxcurrentheroAddress)      ;hero that initiated attack
  ld    ix,(HeroThatGetsAttacked)       ;hero that was attacked
;  call  DeactivateHero                  ;sets Status to 255 and moves all heros below this one, one position up 
  call  HeroFled                        ;sets Status to 254, x+y to 255 and put hero in tavern table, so player can buy back



HeroFled:
  ld    (ix+HeroStatus),254             ;254 = hero fled
  ld    (ix+Heroy),255
  ld    (ix+Herox),255

  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoNumber
  add   hl,de
  ld    b,(hl)                          ;hero number

  ;now start looking at end of table, keep moving left until we found a hero. Then set the stored hero 1 slot right of that hero
  ld    a,(PlayerThatGetsAttacked)
  cp    1
  ld    hl,TavernHeroesPlayer1+TavernHeroTableLenght-2
  jr    z,.loop
  cp    2
  ld    hl,TavernHeroesPlayer2+TavernHeroTableLenght-2
  jr    z,.loop
  cp    3
  ld    hl,TavernHeroesPlayer3+TavernHeroTableLenght-2
  jr    z,.loop
  ld    hl,TavernHeroesPlayer4+TavernHeroTableLenght-2
  .loop:
  ld    a,(hl)
  or    a
  jr    nz,.HeroFound
  dec   hl
  jr    .loop

  .HeroFound:
  inc   hl
  ld    (hl),b
  ret
  
DeactivateHero:                         ;sets Status to 255 and moves all heros below this one, one position up 
  ld    (ix+HeroStatus),255             ;255 = inactive

  push  ix
  pop   hl
	ld		de,lenghtherotable
  add   hl,de                           ;set hero below Deactivated in hl

  push  ix
  pop   de                              ;set deactivated hero in de
  
  ld    bc,(AmountHeroesTimesLenghtHerotableBelowHero) ;amount of heroes we need to move * lenghtherotable

  ld    a,b
  or    c
  ret   z                               ;no heroes below this hero (so this hero is hero 8)

  ldir

  ld    iy,(LastHeroForPlayerThatGetsAttacked)
  ld    (iy+HeroStatus),255             ;255 = inactive
  ret







