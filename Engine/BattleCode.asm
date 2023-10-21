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

  halt
  jp  .engine

.CopyPage1To2:
	db		0,0,0,1
	db		0,0,0,2
	db		0,1,212,0
	db		0,0,$d0	
  
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







  ;load battle field graphics to inactive page
  ld    d,BattleFieldSnowBlock
  ld    a,0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

	ld		a,(activepage)                  ;switch page so that battle field graphics will become visible
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	call	SetPageSpecial					        ;set page




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







