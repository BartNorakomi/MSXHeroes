LevelEngine:
  call  PopulateControls                ;read out keys
	call	PopulateKeyMatrix               ;only used to read out CTRL and SHIFT
	call	scrollscreen                    ;scroll screen if cursor is on the edges or if you press the minimap
	call	buildupscreen                   ;build up the visible map in page 0/1


	call	movehero
	call	checktriggermapscreen

;	call	setherosinwindows               ;erase hero and life status windows, then put the heroes in the windows and set the life and movement status of the heroes
	call	putbottomcastles
	call	putbottomheroes	
;	call	putbottomcreatures
;	call	putitems
	call	puttopheroes	
;	call	puttopcreatures
	call	puttopcastles
	call	putmovementstars

;	call	checkbuttonnolongerover         ;check if mousepointer is no longer on a button
;	call	checkbuttonover                 ;check if mousepointer moves over a button (a button can be, the map, the castle, system settings, end turn, left arrow, right arrow)
;	call	checkwindowsclick               ;check if any of the buttons in the hud are pressed
;	call	checkmovementlifeheroline
;	call	docomputerplayerturn
;	call	textwindow
;	call	checktriggerBmap
;	call	textwindowhero
;	call	checktriggeronhero

  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a

;  xor   a
;  ld    hl,vblankintflag
;  .checkflag:
;  cp    (hl)
;  jr    z,.checkflag
;  ld    (hl),a  

  halt
  jp    LevelEngine

vblank:
  push  bc
  push  de
  push  hl
  exx
  push  af
  push  bc
  push  de
  push  hl

	call	MovePointer	                    ;readout keyboard and mouse matrix/movement and move (mouse) pointer (set mouse coordinates in spat)
	call	setspritecharacter
	call	putsprite

  ld    a,1                             ;vblank flag gets set
  ld    (vblankintflag),a  

  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  exx
  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  ei
  ret

vblankintflag:  db  0
lineintflag:  db  0
InterruptHandler:
  push  af

  xor   a                               ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)                         ;check and acknowledge vblank interrupt
  rlca
  jp    c,vblank                        ;vblank detected, so jp to that routine
 
  pop   af 
  ei
  ret











colorlightgrey: equ 8
colormiddlebrown: equ 13

checkbuttonnolongerover:	;check if mousepointer is no longer on a button
	ld		hl,buttons+0*lenghtbuttontable+4
	call	.check
	ld		hl,buttons+1*lenghtbuttontable+4
	ld		b,1
	call	.checkherobutton
	ld		hl,buttons+2*lenghtbuttontable+4
	ld		b,2
	call	.checkherobutton
	ld		hl,buttons+3*lenghtbuttontable+4
	ld		b,3
	call	.checkherobutton	
	ld		hl,buttons+4*lenghtbuttontable+4
	call	.check
	ld		hl,buttons+5*lenghtbuttontable+4
	call	.check
	ld		hl,buttons+6*lenghtbuttontable+4
	call	.check
	ld		hl,buttons+7*lenghtbuttontable+4
	call	.check	
	ld		hl,buttons+8*lenghtbuttontable+4
	call	.check
	ret
;check if mouse move away from a hero button that is supposed to stay lit
.checkherobutton:
	ld		a,(currentherowindowclicked)
	cp		b
	jp		nz,.check

.check2:
	ld		a,(hl)			;lit ?
	or		a
	ret		z
;.thisoneislit:
	dec		(hl)			;leave this one lit
	ld		a,colorwhite+16*colorwhite
	jp		lightupbutton	
;/check if mouse move away from a hero button that is supposed to stay lit

.check:
	ld		a,(hl)
	or		a
	ret		z
	
.thisoneislit:
	dec		(hl)

	ld		a,colormiddlebrown+16*colormiddlebrown
	jp		lightupbutton
;	ret

checkbuttonover:	;check if mousepointer moves over a button (a button can be, the map, the castle, system settings, end turn, left arrow, right arrow)
	ld		a,(spritecharacter) ;0=d,1=u,2=ur,3=ul,4=r,5=l,6=dr,7=dl,8=shoe,9=shoeaction,10=fight,11=hand,12=piece of window
	cp		11
	ret		nz

	ld		a,(spat)		;y mouse pointer
	ld		b,a
	ld		a,(spat+1)		;x mouse pointer
	ld		c,a

	ld		hl,buttons+0*lenghtbuttontable
	call	.check
	ld		hl,buttons+1*lenghtbuttontable
	call	.check
	ld		hl,buttons+2*lenghtbuttontable
	call	.check
	ld		hl,buttons+3*lenghtbuttontable
	call	.check
	ld		hl,buttons+4*lenghtbuttontable
	call	.check
	ld		hl,buttons+5*lenghtbuttontable
	call	.check
	ld		hl,buttons+6*lenghtbuttontable
	call	.check
	ld		hl,buttons+7*lenghtbuttontable
	call	.check
	ld		hl,buttons+8*lenghtbuttontable
	call	.check
	ret

.check:
	ld		a,(hl)			;sy button window
	cp		b				;y mouse pointer
	ret		nc
	
	inc		hl				;ny button window
	add		a,(hl)
	cp		b
	ret		c

	inc		hl				;sx button window
	ld		a,(hl)
	cp		c				;x mouse pointer
	ret		nc

	inc		hl				;nx button window
	add		a,(hl)
	cp		c
	ret		c

;mouse is over a button, light up this button
	inc		hl				;lit ?
	ld		(hl),2				;keep button lit for 2 screenbuilduptimes

	ld		a,colorwhite+16*colorwhite
	call	lightupbutton
	pop		af				;dont check any other buttons
	ret

lightupbutton:
	ld		(putline+clr),a

	dec		hl				;nx-2

;top line
	push	hl
	ld		a,(hl)			;nx-2
	add		a,2
	ld		(putline+nx),a
	dec		hl				;sx-7
	ld		a,(hl)
	add		a,7
	ld		(putline+dx),a
	dec		hl				;ny-2
;	ld		a,(hl)
;	add		a,2
	ld		a,1
	ld		(putline+ny),a
	dec		hl				;sy-2
	ld		a,(hl)
	add		a,2
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
	pop		hl
;/top line

;bottom line
	push	hl
	dec		hl				;sx-7
	dec		hl				;ny-2
	ld		b,(hl)
	dec		hl				;sy-2
	ld		a,(hl)
	add		a,2 + 1
	add		a,b
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
	pop		hl
;/bottom line

;left line
	push	hl
	ld		a,1
	ld		(putline+nx),a
	dec		hl				;sx-7
	dec		hl				;ny-2
	ld		a,(hl)
	add		a,2
	ld		(putline+ny),a
	dec		hl				;sy-2
	ld		a,(hl)
	add		a,2
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
	pop		hl
;/left line

;right line
	ld		b,(hl)
	dec		hl				;sx-7
	ld		a,(hl)
	add		a,7 + 1
	add		a,b	
	ld		(putline+dx),a
	ld		hl,putline
	jp		docopy
;/right line
;	ret
;/mouse is over a button, light up this button













checkwindowsclick:
	ld		a,(spritecharacter) ;0=d,1=u,2=ur,3=ul,4=r,5=l,6=dr,7=dl,8=shoe,9=shoeaction,10=fight,11=hand,12=piece of window
	cp		11
	ret		nz

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
	bit		4,a						                  ;space pressed ?
	ret		z


;arrow left		1st hero window	 2nd hero window  3rd hero wind		arrow right		map					castle			system			end turn
;sywindow1: equ 176 | sywindow2: equ 168 | sywindow3: equ 168 | sywindow4: equ 168 | sywindow5: equ 176 | sywindow6: equ 172 | sywindow7: equ 172 | sywindow8: equ 172 | sywindow9: equ 172
;sxwindow1: equ 009 | sxwindow2: equ 018 | sxwindow3: equ 036 | sxwindow4: equ 054 | sxwindow5: equ 072 | sxwindow6: equ 130 | sxwindow7: equ 159 | sxwindow8: equ 188 | sxwindow9: equ 217

			;	sy(-2),			ny(-2),	sx-7,			nx-2,	lit?
;buttons:	
;      db	sywindow1-2,	15-2,	sxwindow1-7,	8-2,	0	;arrow left
;			db	sywindow2-2,	32-2,	sxwindow2-7,	17-2,	0	;1st hero window
;			db	sywindow3-2,	32-2,	sxwindow3-7,	17-2,	0	;2nd hero window
;			db	sywindow4-2,	32-2,	sxwindow4-7,	17-2,	0	;3rd hero window	
;			db	sywindow5-2,	15-2,	sxwindow5-7,	8-2,	0	;arrow right

;			db	sywindow6-2,	28-2,	sxwindow6-7,	28-2,	0	;map
;			db	sywindow7-2,	28-2,	sxwindow7-7,	28-2,	0	;castle
;			db	sywindow8-2,	28-2,	sxwindow8-7,	28-2,	0	;system
;			db	sywindow9-2,	28-2,	sxwindow9-7,	28-2,	0	;end turn

	ld		a,(buttons+0*lenghtbuttontable+4)		;arrow left clicked
	or		a
	jp		nz,checkarrowleft
	ld		a,(buttons+1*lenghtbuttontable+4)		;1st hero window clicked
	or		a
	jp		nz,firstherowindow
	ld		a,(buttons+2*lenghtbuttontable+4)		;2nd hero window clicked
	or		a
	jp		nz,secondherowindow
	ld		a,(buttons+3*lenghtbuttontable+4)		;3rd hero window clicked
	or		a
	jp		nz,thirdherowindow
	ld		a,(buttons+4*lenghtbuttontable+4)		;arrow right clicked
	or		a
	jp		nz,checkarrowright
	ld		a,(buttons+8*lenghtbuttontable+4)		;end turn clicked
	or		a
	jp		nz,endturn
	ret

endturn:
	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero1manarec
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero1manarec
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero1manarec
	jr		z,.playerset
	ld		hl,pl4hero1manarec
.playerset:

	ld		a,1
	ld		(changemovementlife?),a
;reset all heroes mana/ life and movement
;	ld		hl,pl1hero1manarec	;at end turn hero get an amount of mana back
	ld		b,amountofheroesperplayer
	ld		de,lenghtherotable+6

.loop:
	ld		a,(hl)				;mana recovery
	dec		hl					;total mana
	ld		c,(hl)				
	dec		hl					;current player1hero?mana
	add		a,(hl)
	cp		c
	jp		nc,.nooverflowmana
	ld		a,c
.nooverflowmana:
	ld		(hl),a
	
	dec		hl					;total move
	ld		a,(hl)
	dec		hl					;current move
	ld		(hl),a
	
	dec		hl					;total life
	ld		a,(hl)
	dec		hl					;current life
	ld		(hl),a
	add		hl,de				;next hero mana recovery
	djnz	.loop

	ld		a,(amountofplayers)
	ld		b,a
	ld		a,(whichplayernowplaying?)
	cp		b
	jp		nz,.endchecklastplayer
	xor		a
.endchecklastplayer:	
	inc		a
	ld		(whichplayernowplaying?),a

	ld		a,3					;put new heros in windows (page 0 and page 1) 
	ld		(setherosinwindows?),a	

	xor		a
	ld		(herowindowpointer),a

	call	firstherowindow
	ret
;/reset all heroes mana/ life and movement

thirdherowindow:
	ld		a,(whichplayernowplaying?)
	dec		a
;	ld		hl,pl1hero1type
	ld		hl,pl1amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl2hero1type
	ld		hl,pl2amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl3hero1type
	ld		hl,pl3amountherosonmap
	jr		z,.playertypeset
;	ld		hl,pl4hero1type
	ld		hl,pl4amountherosonmap
.playertypeset:

	ld		c,(hl)			;plxamountherosonmap
	inc		hl
	inc		hl
	inc		hl				;plxheroxtype	

	ld		a,(herowindowpointer)
	or		a
;	ld		hl,pl1hero1type
	jr		z,.herotypefound2

	ld		de,lenghtherotable
	ld		b,a
.loop1:
	add		hl,de
	djnz	.loop1
.herotypefound2:

	ld		b,a				;herowindowpointer
	ld		a,c				;plxamountherosonmap
	sub		a,b		
	ret		c
	cp		3
	ret		c

	ld		a,(hl)
	cp		255
	ret		z						;there is no hero in this window

	ld		a,3
	ld		(currentherowindowclicked),a;hero window 3 should be lit constantly
	ld		a,2							;reset all lit hero windows
	ld		(buttons+1*lenghtbuttontable+4),a
	ld		(buttons+2*lenghtbuttontable+4),a
	ld		(buttons+3*lenghtbuttontable+4),a

	ld		de,lenghtherotable

	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero3y
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero3y
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero3y
	jr		z,.playerset
	ld		hl,pl4hero3y
.playerset:

	ld		a,(herowindowpointer)
;	ld		hl,pl1hero3y
	ld		b,2*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	or		a
	jp		z,centrescreenforthishero
	ret

secondherowindow:
	ld		a,(whichplayernowplaying?)
	dec		a
;	ld		hl,pl1hero1type
	ld		hl,pl1amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl2hero1type
	ld		hl,pl2amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl3hero1type
	ld		hl,pl3amountherosonmap
	jr		z,.playertypeset
;	ld		hl,pl4hero1type
	ld		hl,pl4amountherosonmap
.playertypeset:

	ld		c,(hl)			;plxamountherosonmap
	inc		hl
	inc		hl
	inc		hl				;plxheroxtype	

	ld		a,(herowindowpointer)
	or		a
;	ld		hl,pl1hero1type
	jr		z,.herotypefound2

	ld		de,lenghtherotable
	ld		b,a
.loop1:
	add		hl,de
	djnz	.loop1
.herotypefound2:

	ld		b,a				;herowindowpointer
	ld		a,c				;plxamountherosonmap
	sub		a,b		
	ret		c
	cp		2
	ret		c

	ld		a,(hl)
	cp		255
	ret		z						;there is no hero in this window

	ld		a,2
	ld		(currentherowindowclicked),a;hero window 2 should be lit constantly
	ld		a,2							;reset all lit hero windows
	ld		(buttons+1*lenghtbuttontable+4),a
	ld		(buttons+2*lenghtbuttontable+4),a
	ld		(buttons+3*lenghtbuttontable+4),a

	ld		de,lenghtherotable

	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero2y
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero2y
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero2y
	jr		z,.playerset
	ld		hl,pl4hero2y
.playerset:

	ld		a,(herowindowpointer)
;	ld		hl,pl1hero2y
	ld		b,1*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	or		a
	jp		z,centrescreenforthishero
	add		hl,de					;	ld		hl,pl1hero3y
	ld		b,2*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	dec		a
	jp		z,centrescreenforthishero
	ret

firstherowindow:
	ld		a,(whichplayernowplaying?)
	dec		a
;	ld		hl,pl1hero1type
	ld		hl,pl1amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl2hero1type
	ld		hl,pl2amountherosonmap
	jr		z,.playertypeset
	dec		a
;	ld		hl,pl3hero1type
	ld		hl,pl3amountherosonmap
	jr		z,.playertypeset
;	ld		hl,pl4hero1type
	ld		hl,pl4amountherosonmap
.playertypeset:

	ld		c,(hl)			;plxamountherosonmap
	inc		hl
	inc		hl
	inc		hl				;plxheroxtype	

	ld		a,(herowindowpointer)
	or		a
;	ld		hl,pl1hero1type
	jr		z,.herotypefound2

	ld		de,lenghtherotable
	ld		b,a
.loop1:
	add		hl,de
	djnz	.loop1
.herotypefound2:

	ld		b,a				;herowindowpointer
	ld		a,c				;plxamountherosonmap
	sub		a,b		
	ret		c
	cp		1
	ret		c

	ld		a,(hl)
	cp		255
	ret		z						;there is no hero in this window

	ld		a,1
	ld		(currentherowindowclicked),a;hero window 1 should be lit constantly
	ld		a,2							;reset all lit hero windows
	ld		(buttons+1*lenghtbuttontable+4),a
	ld		(buttons+2*lenghtbuttontable+4),a
	ld		(buttons+3*lenghtbuttontable+4),a

	ld		de,lenghtherotable

	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero1y
	jr		z,.playerset
	ld		hl,pl4hero1y
.playerset:

	ld		a,(herowindowpointer)
;	ld		hl,pl1hero1y
	ld		b,0*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	or		a
	jp		z,centrescreenforthishero
	add		hl,de					;	ld		hl,pl1hero2y
	ld		b,1*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	dec		a
	jp		z,centrescreenforthishero
	add		hl,de					;	ld		hl,pl1hero3y
	ld		b,2*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	dec		a
	jp		z,centrescreenforthishero
	ret
	
centrescreenforthishero:
;a new player is clicked, set new player as current player, and reset movement stars
	ld		a,b
	ld		(plxcurrenthero),a
	
	xor		a
	ld		(putmovementstars?),a
	ld		(movementpathpointer),a
	ld		(movehero?),a
;/a new player is clicked, set new player as current player, and reset movement stars	
	ld		a,TilesPerColumn
	ld		b,a
	ld		a,(mapheight)
	sub		a,b
	ld		b,a

	ld		a,TilesPerRow
	ld		c,a
	ld		a,(maplenght)
	sub		a,c
	ld		c,a
	
	ld		a,(hl)			;pl1hero1y
	sub		a,TilesPerColumn/2
	jp		nc,.notoutofscreentop
	xor		a
.notoutofscreentop:	
	ld		(mappointery),a

	cp		b
	jp		c,.notoutofscreenbottom
	ld		a,b
	ld		(mappointery),a
.notoutofscreenbottom:	
	
	inc		hl				;pl1hero1x
	ld		a,(hl)
	sub		a,TilesPerRow/2
	jp		nc,.notoutofscreenleft
	xor		a
.notoutofscreenleft:	
	ld		(mappointerx),a

	cp		c
	jp		c,.notoutofscreenright
	ld		a,c
	ld		(mappointerx),a
.notoutofscreenright:	
	ret

checkarrowleft:
	ld		a,(herowindowpointer)
	sub		a,1
	ret		c
	ld		(herowindowpointer),a

	ld		a,3
	ld		(setherosinwindows?),a	

	ld		a,2							;reset all lit hero windows
	ld		(buttons+1*lenghtbuttontable+4),a
	ld		(buttons+2*lenghtbuttontable+4),a
	ld		(buttons+3*lenghtbuttontable+4),a

	ld		a,(currentherowindowclicked)
	inc		a
	ld		(currentherowindowclicked),a
	ret

checkarrowright:
	ld		a,(herowindowpointer)
	add		a,1
	cp		8
	ret		nc
	ld		(herowindowpointer),a

	ld		a,3
	ld		(setherosinwindows?),a	

	ld		a,2							;reset all lit hero windows
	ld		(buttons+1*lenghtbuttontable+4),a
	ld		(buttons+2*lenghtbuttontable+4),a
	ld		(buttons+3*lenghtbuttontable+4),a

	ld		a,(currentherowindowclicked)
	dec		a
	ld		(currentherowindowclicked),a
	ret


















movehero:
	ld		a,(movehero?)
	or		a
	ret		z

	ld		a,(framecounter)
  rrca
	ret		c                               ;move every other frame
	
	ld		a,(movementpathpointer)
	add		a,2
	ld		(movementpathpointer),a
	
	ld		e,a
	ld		d,0
	ld		hl,movementpath
	add		hl,de
	
	ld		b,(hl)		                      ;dy
	inc		hl
	ld		c,(hl)		                      ;dx
	ld		a,b
	or		c
	jp		nz,.domovehero
	
.endmovement:	
	xor		a
	ld		(movehero?),a
	ret
	
.domovehero:	
	ld		a,(plxcurrenthero)
	ld		e,a
	ld		d,0

	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero1y
	jr		z,.playerset
	ld		hl,pl4hero1y
.playerset:

	add		hl,de			;pl?hero?y
;amountofheroes:	equ	10
;plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
;lenghtherotable:	equ	9
;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0		;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
;pl1hero1life:	db	10,20
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20

	call	checkheronearobject	            ;check if hero takes an artifact, or goes in the castle, or meets another hero or creature

	inc		hl
	inc		hl
	inc		hl
	inc		hl
	inc		hl				                      ;pl1hero?move
	ld		a,(hl)
	sub		a,1                             ;we reduce the total amount of movement steps hero has this turn, when it reaches 0, end movement
	jr		c,.endmovement
	ld		(hl),a
	ld		a,1
	ld		(changemovementlife?),a
	dec		hl
	dec		hl
	dec		hl
	dec		hl
	dec		hl

	ld		a,(hl)			                    ;pl1hero?y
	add		a,b
	ld		(hl),a		
	inc		hl				                      ;pl1hero?x
	ld		a,(hl)		
	add		a,c
	ld		(hl),a		
	inc		hl				                      ;pl1hero?type

;set new character hero. does hero move left, right, up, down ?
	ld		a,(hl)			                    ;0=adol, 8=goemon, 16=pixie
	and		%0000 0111		                  ;0,1=right, 2,3=left, 4,5=down, 6,7=up
	ld		d,a
	cp		2
	jr		c,.herowasmovingright
	cp		4
	jr		c,.herowasmovingleft
	cp		6
	jr		c,.herowasmovingdown

.herowasmovingup:
	ld		a,b
	cp		-1
	jp		.cont
.herowasmovingdown:
	ld		a,b
	cp		1
	jp		.cont
.herowasmovingleft:
	ld		a,c
	cp		-1
	jp		.cont
.herowasmovingright:
	ld		a,c
	cp		1
;	jp		.cont

.cont:
	jr		nz,.newdirection

	ld		a,d
	and		1
	ld		e,1
	jp		z,.setherotype
	ld		e,-1
.setherotype:
	ld		a,d
	add		a,e
	ld		d,a

	ld		a,(hl)			                    ;pl1hero?type
	and		%1111 1000
	or		d
	ld		(hl),a			                    ;pl1hero?type
	ret

.newdirection:
	ld		a,c
	cp		1
	ld		d,0
	jr		z,.setdirection
	cp		-1
	ld		d,2
	jr		z,.setdirection
	ld		a,b
	cp		1
	ld		d,4
	jr		z,.setdirection
	cp		-1
	ld		d,6
	jr		z,.setdirection

.setdirection:
	ld		a,(hl)
	and		%1111 1000
	or		d
	ld		(hl),a
	ret
;set new character hero. does hero move left, right, up, down ?

checkheronearobject:	                  ;check if hero takes an artifact, or goes in the castle, or meets another hero or creature
	push	hl			                        ;in hl-> pl?hero?y
	push	bc
	call	.docheck
	pop		bc
	pop		hl
	ret

.docheck:
;set relative hero  position
	ld		a,(hl)			                    ;hero y
	add		a,b
	ld		d,a

	inc		hl				                      ;hero x
	ld		a,(hl)
	add		a,c
	ld		e,a
;/set relative hero position

;check take item
.checkherotakesitem:
	ld		hl,item1y
	ld		bc,lenghtitemtable-1

.docheckherotakesitem:
	exx
	ld		b,amountofitems
.loopitemcheck:
	exx
	;pointer on enemy hero?
	ld		a,d
	cp		(hl)			                      ;cp y
	inc		hl
	jp		nz,.endcheckthisitem
	ld		a,e
	cp		(hl)			                      ;cp	x
	jp		z,.herotakesitem
	;pointer on enemy hero?
.endcheckthisitem:
	add		hl,bc
	exx
	djnz	.loopitemcheck
	exx
	ret

.herotakesitem:
	inc		hl				                      ;item type
	ld		a,(hl)

	exx
	
	ld		c,a
	pop		af
	pop		af
	pop		hl				                      ;hl -> pl?hero?y
	pop		af

	ld		de,10
	add		hl,de			                      ;pl?hero?items
	ld		a,255

amountofitemsperhero:	equ	5
	
	ld		b,amountofitemsperhero
.loop:
	cp		(hl)
	jr		z,.emptyspace
	inc		hl
	djnz	.loop
	ret
	
.emptyspace:
	ld		(hl),c

	exx

	dec		hl
	ld		(hl),255		                    ;item x
	dec		hl			
	ld		(hl),255		                    ;item y
	xor		a
	ld		(movehero?),a
	ret

changemovementlife?:	db		0
checkmovementlifeheroline:
	ld		a,(changemovementlife?)
	or		a
	ret		z
	call	eraselifemovewindows
	call	setlife_moveinwindows
	ret































putmovementstars:
	ld		a,(putmovementstars?)
	or		a
	ret		z

	ld		a,(movementpath+0)	;y hero
	inc		a
	ld		(ystar),a
	ld		a,(movementpath+1)	;x hero
	ld		(xstar),a

	ld		hl,movementpath+2
.loop:
	ld		b,(hl)				;dy
	ld		a,(ystar)
	add		a,b
	ld		(ystar),a
	inc		hl
	ld		c,(hl)				;dy
	ld		a,(xstar)
	add		a,c
	ld		(xstar),a

	ld		a,c
	or		b
	ret		z
	push	hl
	call	doputstar
	pop		hl
	inc		hl
	jp		.loop
	
doputstar:
	ld		a,(activepage)	;check mirror page to mark background star position as 'dirty'
	or		a
	ld		hl,mappage1
	jp		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:

	ld		a,(mappointerx)
	ld		b,a
	ld		a,(xstar)		;xstar
	sub		a,b
	ret		c				;dont put star if x is out of screen
	cp		TilesPerRow
	ret		nc				;dont put star if x is out of screen

	ld		d,0
	ld		e,a				;store relative x star
	
	add		a,a				;*2
	add		a,a				;*4
	add		a,a				;*8
	add		a,a				;*16
;	add		a,3				;centre star

  add   a,buildupscreenXoffset+3        ;map in screen starts at (6,5) due to the frame around the map  
		
	ld		(putstar+dx),a

	ld		a,(mappointery)
	ld		b,a
	ld		a,(ystar)		;y star
	sub		a,b
	ret		c				;dont put star if y is out of screen
	cp		TilesPerColumn
	ret		nc				;dont put star if y is out of screen
	ld		b,a				;store relative y star
	add		a,a				;*2
	add		a,a				;*4
	add		a,a				;*8
	add		a,a				;*16
;	add		a,4				;centre star

  add   a,buildupscreenYoffset+4        ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putstar+dy),a

;mark background star position as 'dirty'
	;setmappointer
		;setxpointer
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		de,TilesPerRow

	ld		a,b
	or		a
	jp		z,.endsetmappointer

.setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
		;/setypointer
.endsetmappointer:
	;/setmappointer
	ld		a,(hl)
	ld		(hl),255
;/mark background star position as 'dirty'

;check if star is behind a tree	
	cp		amountoftransparantpieces
	jp		c,.behindtree
	cp		255
	jp		z,.behindheroorcastle

	ld		hl,putstar
	jp		docopy
.behindtree:
.behindheroorcastle:	
	ld		a,(putstar+dx)
	ld		(putstarbehindobject+dx),a
	ld		a,(putstar+dy)
	ld		(putstarbehindobject+dy),a
	ld		hl,putstarbehindobject
	jp		docopy	
;	ret
;/check if star is behind a tree	






;mouseposy:		ds	1
;mouseposx:		ds	1
;mouseclicky:	ds	1
;mouseclickx:	ds	1
;addxtomouse:	equ	8
;subyfrommouse:	equ	4
checktriggermapscreen:
	ld		a,(spat)				;y cursor
	cp		TilesPerColumn*16-12
	ret		nc						                  ;dont check trigger if cursor is in bottom half of screen
		
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
	bit		4,a						                  ;space pressed ?
	ret		z

;dont react to space / mouse click if current player is a computer
	ld		a,(whichplayernowplaying?)
	ld		hl,player1human?
	ld		b,4
  .loop:
	dec		a
	jp		z,.playerfound
	inc		hl
	djnz	.loop
.playerfound:
	or		(hl)			                      ;is this a human player ?
	ret		z				                        ;no
;player1human?:			db	1
;player2human?:			db	1
;player3human?:			db	0
;player4human?:			db	0
;whichplayernowplaying?:	db	1
;/dont react to space / mouse click if current player is a computer

	ld		a,(movehero?)
	or		a
	jp		nz,.stopheromovement	          ;hero was moving, mouse clicked-> stop hero

	ld		a,(putmovementstars?)
	or		a
	jp		z,.initputstars			            ;mouse clicked. put stars in screen

;mouse clicked, stars are already in screen
	ld		a,(movehero?)
	or		a
	jp		z,.movehero

;mouse clicked, hero is already moving, stop hero
.stopheromovement:
	xor		a
	ld		(movehero?),a
	ret
			
.movehero:
;mouse clicked, should hero move over path ?
	ld		a,(spat+1)		                  ;x	(mouse)pointer
	add		a,addxtomouse	                  ;centre mouse in grid

  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  	
	
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a
	ld		a,(mappointerx)
	add		a,c
	ld		c,a
	ld		a,(mouseclickx)
	cp		c
	jp		nz,.cancel

	ld		a,(spat)		                    ;y	(mouse)pointer
	sub		a,subyfrommouse	                ;centre mouse in grid

  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  	

	jp		nc,.notcarry
	xor		a
.notcarry:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		d,a
	ld		a,(mappointery)
	add		a,d
	ld		d,a
	ld		a,(mouseclicky)
	cp		d
	jp		nz,.cancel

	xor		a
	ld		(putmovementstars?),a
	ld		(movementpathpointer),a
	ld		a,1
	ld		(movehero?),a
	ret

.cancel:					                      ;dont move hero, mouse click was not accurately on path
;mouse clicked, set star path
.initputstars:
	ld		a,1
	ld		(putmovementstars?),a

	ld		a,(plxcurrenthero)
;amountofheroes:	equ	10
;plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
;lenghtherotable:	equ	10
;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0		;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
;pl1hero1life:	db	10,20
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20
;pl1hero1manarec:db	5		;recover x mana every turn

;turnbased?:				db	1
;amountofplayers:		db	2
;player1human?:			db	1
;player2human?:			db	1
;player3human?:			db	0
;player4human?:			db	0
;whichplayernowplaying?:	db	1
	ld		e,a
	ld		d,0

	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl2hero1y
	jr		z,.playerset
	dec		a
	ld		hl,pl3hero1y
	jr		z,.playerset
	ld		hl,pl4hero1y
.playerset:
;	ld		hl,pl1hero1y
	add		hl,de			                      ;pl1hero?y

	ld		a,(hl)			                    ;pl1hero?y
	ld		(.setpl1hero?y),a
	ld		(heroymirror),a
	inc		hl				                      ;pl1hero?x
	ld		a,(hl)
	ld		(.setpl1hero?x),a
	ld		(heroxmirror),a
	ld		hl,movementpath+2

;movementpath:		ds	64	;1stbyte:y star,	2ndbyte:x star (the movement path consists of stars, they have each their y and x coordinates. The hero will move to these coordinates when moving)

.initloop:
	call	.init			                      ;out c=dx, d=dy
	ld		a,c
	or		d
	ret		z

	ld		a,(heroxmirror)
	add		a,c
	ld		(heroxmirror),a
	ld		a,(heroymirror)
	add		a,d
	ld		(heroymirror),a
	jp		.initloop
	ret

.init:
	ld		a,(spat+1)		                  ;x (mouse)pointer
	add		a,addxtomouse	                  ;centre mouse in grid

  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  	
	
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a
	ld		a,(mappointerx)
	add		a,c
	ld		c,a
	ld		(mouseclickx),a

	ld		a,(spat)		                    ;y (mouse)pointer
	sub		a,subyfrommouse	                ;centre mouse in grid

  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  	

	jp		nc,.notcarry2
	xor		a
.notcarry2:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		d,a
	ld		a,(mappointery)
	add		a,d
	ld		d,a
	ld		(mouseclicky),a

;check if there is an obstacle. Can star be put here ?
	push	hl
	push	de

	;setmappointer
		;setxpointer
	ld		hl,mapdata
	ld		a,(heroxmirror)
	ld		e,a
	ld		d,0
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		a,(heroymirror)
	inc		a
	or		a
	jp		z,.endsetmappointer
	ld		b,a

	ld		de,(maplenght)
.setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
		;/setypointer
.endsetmappointer:
	;/setmappointer
	ld		a,(hl)

	pop		de
	pop		hl

	cp		16
	jr		c,.noobstacle
	cp		24
	jr		c,.obstacle
	cp		149
	jr		c,.noobstacle
.obstacle:
	dec		hl
	dec		hl
	ld		c,0
	ld		d,0
	jp		.dosetstarpath

.noobstacle:
;/check if there is an obstacle. Can star be put here ?
	
	ld		a,(heroxmirror)
	cp		c
	ld		c,0				                      ;dont move horizontally
	jp		z,.checkvertical
	ld		c,1
	jp		c,.checkvertical
	ld		c,-1	
.checkvertical:

	ld		a,(heroymirror)
	cp		d
	ld		d,0				                      ;dont move horizontally
	jp		z,.dosetstarpath
	ld		d,1
	jp		c,.dosetstarpath
	ld		d,-1	
.dosetstarpath:

.setpl1hero?y:	equ	$+1
	ld		a,255
	ld		(movementpath+0),a
.setpl1hero?x:	equ	$+1
	ld		a,255
	ld		(movementpath+1),a

	ld		a,d				                      ;dy
	ld		(hl),a
	inc		hl
	ld		a,c				                      ;dx
	ld		(hl),a
	inc		hl
	ret















;castlepl1y:	db	04 | castlepl1x:	db	01
;castlepl2y:	db	14 | castlepl2x:	db	19
;castlepl3y:	db	06 | castlepl3x:	db	18
;castlepl4y:	db	15 | castlepl4x:	db	03
;castley:	ds	1
;castlex:	ds	1

puttopcastles:
	ld		hl,castlepl1y
	call	.doputcastletop
	ld		hl,castlepl2y
	call	.doputcastletop
	ld		hl,castlepl3y
	call	.doputcastletop
	ld		hl,castlepl4y
;	call	.doputcastletop

.doputcastletop:
	xor   a
	ld		(putcastle+sx),a
	ld		a,(hl)			                    ;castle y
	or    a
	ret   z                               ;if y=0 there is no castle
	sub		a,3
	ld		(castley),a
	inc		hl
	ld		a,(hl)			                    ;castle x
	inc		a
	ld		(castlex),a
	call	putbottomcastles.puttwopieces
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(castley)
	inc		a
	ld		(castley),a
	ld		a,(castlex)
	sub		a,2
	ld		(castlex),a
	call	putbottomcastles.putthreepieces
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(castley)
	inc		a
	ld		(castley),a
	ld		a,(castlex)
	sub		a,2
	ld		(castlex),a
	call	putbottomcastles.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(castlex)
	add		a,2
	ld		(castlex),a
	call	putbottomcastles.doputthispiece
	ret

putbottomcastles:
	ld		hl,castlepl1y
	call	.doputcastle
	ld		hl,castlepl2y
	call	.doputcastle
	ld		hl,castlepl3y
	call	.doputcastle
	ld		hl,castlepl4y
;	call	.doputcastle

.doputcastle:
	ld		a,112
	ld		(putcastle+sx),a
	ld		a,(hl)			                    ;castle y
	or    a
	ret   z                               ;if y=0 there is no castle
	ld		(castley),a
	inc		hl
	ld		a,(hl)			                    ;castle x
	ld		(castlex),a

.putthreepieces:
	call	.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(castlex)
	inc		a
	ld		(castlex),a
.puttwopieces:
	call	.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(castlex)
	inc		a
	ld		(castlex),a
	jp		.doputthispiece
;	ret

.doputthispiece:
	ld		a,(activepage)	                ;check mirror page to mark background hero position as 'dirty'
	or		a
	ld		hl,mappage1
	jp		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:

	ld		a,(mappointerx)
	ld		b,a
	ld		a,(castlex)
	sub		a,b
	ret		c
	cp		TilesPerRow
	ret		nc

	ld		d,0
	ld		e,a				                      ;store relative x castle
	
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16

  add   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putcastle+dx),a

	ld		a,(mappointery)
	ld		b,a
	ld		a,(castley)		                  ;y star
	sub		a,b
	ret		c				                        ;dont put castle if y is out of screen
	cp		TilesPerColumn
	ret		nc				                      ;dont put castle if y is out of screen

	ld		b,a				                      ;store relative y castle
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16

  add   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putcastle+dy),a

;mark background castle position as 'dirty'
	;setmappointer
		;setxpointer
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		de,TilesPerRow
	ld		a,b
	or		a
	jp		z,.endsetmappointer2

  .setypointerloop2:	
	add		hl,de
	djnz	.setypointerloop2
		;/setypointer
  .endsetmappointer2:
	;/setmappointer
	ld		(hl),255
;/mark background hero position as 'dirty'

	ld		hl,putcastle
  jp    docopy











putbottomheroes:
	ld		a,(activepage)	                ;check mirror page to mark background hero position as 'dirty'
	or		a
	ld		hl,mappage1
	jr		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:
	ld		(doputheros.SelfModifyingCodeSetPointerInMapToHero),hl

	ld		a,16
	ld		(doputheros.SelfModifyingCodeAddYToSYHero),a
	ld		a,1
	ld		(doputheros.SelfModifyingCodeAddYToHero),a
	jp		doputheros

puttopheroes:
	xor		a
	ld		(doputheros.SelfModifyingCodeAddYToSYHero),a
	ld		(doputheros.SelfModifyingCodeAddYToHero),a

doputheros:
  ld    hl,pl1hero1y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl1hero2y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl1hero3y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl1hero4y | ld a,(hl) | inc a | call nz,.doputhero

  ld    hl,pl2hero1y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl2hero2y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl2hero3y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl2hero4y | ld a,(hl) | inc a | call nz,.doputhero

  ld    hl,pl3hero1y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl3hero2y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl3hero3y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl3hero4y | ld a,(hl) | inc a | call nz,.doputhero

  ld    hl,pl4hero1y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl4hero2y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl4hero3y | ld a,(hl) | inc a | call nz,.doputhero
  ld    hl,pl4hero4y | ld a,(hl) | inc a | call nz,.doputhero
  ret

;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0		;hero type	;0=adol, 8=goemon, 32=pixie...... 255=no more hero
;pl1hero1life:	db	10,20
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20
;pl1hero1manarec:db	5		;recover x mana every turn
;pl1hero1items:	db	255,255,255,255,255


.doputhero:
	ld		a,(mappointery)                 ;check if hero y is within screen range
	ld		b,a
	ld		a,(hl)			                    ;y hero
  .SelfModifyingCodeAddYToHero:	equ	$+1
	add		a,000
	sub		a,b
	ret		c                               ;check hero within screen y range top
	cp		TilesPerColumn
	ret		nc                              ;check hero within screen y range bottom
	ld		c,a				                      ;store relative y hero in c

	inc		hl
	ld		a,(mappointerx)                 ;check if hero x is within screen range
	ld		b,a
	ld		a,(hl)			                    ;x hero
	sub		a,b
	ret		c                               ;check hero within screen x range left
	cp		TilesPerRow
	ret		nc                              ;check hero within screen x range right

	ld		d,0
	ld		e,a                             ;store relative x hero (in tiles)
	
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
  add   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  
	ld		(putherotopbottom+dx),a         ;set hero dx

	ld		a,c				                      ;relative y hero (in tiles)
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
  add   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  
	ld		(putherotopbottom+dy),a         ;set hero dy

	inc		hl                              ;hero type (0=adol, 8=goemon, 32=pixie...... 255=no more hero)

	ld		a,(hl)			                    ;hero type (0=adol, 8=goemon, 32=pixie...... 255=no more hero)
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16

	ld		(putherotopbottom+sx),a	        ;hero sx

	ld		a,(hl)			                    ;hero type (0=adol, 8=goemon, 32=pixie...... 255=no more hero)
	and		%1111 0000
  .SelfModifyingCodeAddYToSYHero:	equ	$+1
	add		a,000
	ld		(putherotopbottom+sy),a         ;hero sy
	
  .SelfModifyingCodeSetPointerInMapToHero:	equ	$+1
	ld		hl,0000
	add		hl,de                           ;this points to x of tile in map where we put our hero piece. Let's mark this tile as 'dirty' so it will be overwritten when hero moves
	
	ld		de,TilesPerRow
	ld		a,c				                      ;relative y hero (in tiles)
	or		a
	jr		z,.endsetmappointer1
	ld		b,a
  .setypointerloop1:	
	add		hl,de
	djnz	.setypointerloop1
  .endsetmappointer1:                   ;hl now points to the tile in the map where this hero piece will be put

	ld    a,(hl)                          ;tile at mappointer at position of hero
	cp		254				                      ;is there a hero already here, AND is this hero behind an object ??
	call	z,.behindheroandtree	
	ld		(hl),255                        ;this tile is now 'dirty'

	cp    amountoftransparantpieces       ;(64 tiles hero can stand behind) check if hero is behind a tree	
	jp		nc,.notbehindtree		
	ld		(hl),254                        ;254 when hero is behind an object (mark background position)
	cp		non_see_throughpieces           ;(16) background pieces a hero can stand behind, but they are not see through
	ret		c				                        ;hero is completely invisible behind the tree
  ;at this point hero is standing behind an object. So first put the hero, and then put the object on top of the hero.
	ld		d,a				                      ;tile where hero is standing on
	ld		hl,putherotopbottom
	call	docopy			                    ;first put hero

;mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
;  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
;  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112
  
	ld		a,d				                      ;mappointer at position of hero	
	add   a,a                             ;*2
	ld    e,a
	ld    d,0
	ld    hl,mirrortransparentpieces
	add   hl,de                           ;sy mirror piece
	ld    a,(hl)
	ld    (putbackgroundoverhero+sy),a
	inc   hl                              ;sx mirror piece
	ld    a,(hl)
	ld    (putbackgroundoverhero+sx),a
	
	ld    a,(putherotopbottom+dy)
	ld    (putbackgroundoverhero+dy),a
	ld    a,(putherotopbottom+dx)
	ld    (putbackgroundoverhero+dx),a
	ld    hl,putbackgroundoverhero
	jp		docopy			                    ;put background (tree) over hero

  .notbehindtree:
	ld		hl,putherotopbottom
	jp		docopy			                    ;hero is not behind a tree

  .behindheroandtree:			              ;at this point the hero is in front of/behind another hero and behind a tree
;retrace the partnumber
	push	hl
	ld		a,(putherotopbottom+dx)

  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  

	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		b,a				                      ;relative x hero
;	add		a,a				                      ;*2
;	add		a,a				                      ;*4
;	add		a,a				                      ;*8
;	add		a,a				                      ;*16

	ld		a,(putherotopbottom+dy)

  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  

	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a				                      ;relative y hero

;setmappointer
	;setxpointer
	ld		hl,mapdata
	ld		de,(mappointerx)
	ld		a,e
	add		a,b
	ld		e,a
	add		hl,de
	;/setxpointer
	
	;setypointer	
	ld		a,(mappointery)
	add		a,c
	jp		z,.endsetmappointer2
	ld		b,a

	ld		de,(maplenght)
.setypointerloop2:	
	add		hl,de
	djnz	.setypointerloop2
	;/setypointer
.endsetmappointer2:
;/setmappointer
	ld    	a,(hl)			                  ;partnumber 'mappointer at position of hero'
;/retrace the partnumber
	pop		hl
	ret




















colorlightgreen: equ 12
colorpink:  equ 11
colorlightbrown: equ 6
herowindowpointer:	db	0
setherosinwindows?:	db	3
setherosinwindows:
	ld		a,(setherosinwindows?)
	dec		a
	ret		z
	ld		(setherosinwindows?),a

	call	eraseherowindows		            ;first erase hero windows, before putting new heros
	call	eraselifemovewindows	          ;first erase life status and movement status
	call	dosetherosinwindows             ;put the heroes in the windows
	call	setlife_moveinwindows           ;set the life and movement status of the heroes
	ret

setlife_moveinwindows:
	ld		a,colorlightbrown+16*colorlightbrown
	ld		(lifemovewindow_line+clr),a
	ld		a,herowindow1y
	add		a,herowindowny+2
	ld		(lifemovewindow_line+dy),a
	ld		a,herowindow1x-1
	ld		(lifemovewindow_line+dx),a

;search life hero in first window
	ld		a,(whichplayernowplaying?)
	dec		a
;	ld		hl,pl1hero1life
	ld		hl,pl1amountherosonmap
	jr		z,.playerset
	dec		a
;	ld		hl,pl2hero1life
	ld		hl,pl2amountherosonmap
	jr		z,.playerset
	dec		a
;	ld		hl,pl3hero1life
	ld		hl,pl3amountherosonmap
	jr		z,.playerset
;	ld		hl,pl4hero1life
	ld		hl,pl4amountherosonmap
.playerset:

	ld		c,(hl)			                    ;plxamountherosonmap
	inc		hl
	inc		hl
	inc		hl
	inc		hl				                      ;plxheroxlife

	ld		a,(herowindowpointer)
	or		a
;	ld		hl,pl1hero1life
	jr		z,.herotypefound

	ld		de,lenghtherotable
	ld		b,a
.loop:
	add		hl,de
	djnz	.loop
.herotypefound:
;/search life hero in first window

;plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
;lenghtherotable:	equ	6
;pl1amountherosonmap:	db	2
;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0		;hero type	;0=adol, 8=goemon, 32=pixie...... 255=no more hero
;pl1hero1life:	db	10,20
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20
;pl1hero1manarec:db	5		;recover x mana every turn
;pl1hero1items:	db	255,255,255,255,255
;pl1hero1status:	db	1		;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

	ld		b,a				                      ;herowindowpointer
	ld		a,c				                      ;plxamountherosonmap

	sub		a,b
	dec		a				                        ;cp		1
	jp		z,.putonehero
	dec		a				                        ;	cp		2
	jp		z,.puttwoheros
	dec		a				                        ;	cp		3
	ret		nz
;	jp		.putthreeheros

.putthreeheros:
	call	.putbothlines
	ld		a,herowindow2x-1
	ld		(lifemovewindow_line+dx),a	
	call	.putbothlines
	ld		a,herowindow3x-1
	ld		(lifemovewindow_line+dx),a	
	jp		.putbothlines
;	ret

.puttwoheros:
	call	.putbothlines
	ld		a,herowindow2x-1
	ld		(lifemovewindow_line+dx),a	
.putonehero:
	jp		.putbothlines
;	ret



.putbothlines:
	ld		a,colorpink+16*colorpink
	call	putsingleline			              ;put hero1 life
	ld		a,colorlightgreen+16*colorlightgreen
	call	putsingleline			              ;put hero1 movement

	ld		de,lenghtherotable-4
	add		hl,de
	ld		a,(lifemovewindow_line+dy)
	sub		a,4
	ld		(lifemovewindow_line+dy),a
	ret

putsingleline:
	ld		(lifemovewindow_line+clr),a
	ld		a,(hl)					                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
	cp		255
	ret		z

	ld		a,(hl)
	cp		16
	jp		c,.nooverflownx
	ld		a,15
.nooverflownx:
	ld		(lifemovewindow_line+nx),a
	or		a

	push	hl						                  ;pl1hero1life
	ld		hl,lifemovewindow_line
	call	nz,docopy				                ;dont put line if life/move = 0
	ld		a,(lifemovewindow_line+dy)
	add		a,2
	ld		(lifemovewindow_line+dy),a
	pop		hl						                  ;pl1hero1life
	inc		hl						                  ;pl1hero1life total
	inc		hl						                  ;pl1hero1move
	ret

dosetherosinwindows:
;plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
;lenghtherotable:	equ	6
;pl1amountherosonmap:	db	2
;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0		;hero type	;0=adol, 8=goemon, 32=pixie...... 255=no more hero
;pl1hero1life:	db	10,20
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20
;pl1hero1manarec:db	5		;recover x mana every turn
;pl1hero1items:	db	255,255,255,255,255
;pl1hero1status:	db	1		;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

	ld		a,(whichplayernowplaying?)
	dec		a
;	ld		hl,pl1hero1type
	ld		hl,pl1amountherosonmap
	jr		z,.playerset
	dec		a
;	ld		hl,pl2hero1type
	ld		hl,pl2amountherosonmap
	jr		z,.playerset
	dec		a
;	ld		hl,pl3hero1type
	ld		hl,pl3amountherosonmap
	jr		z,.playerset
;	ld		hl,pl4hero1type
	ld		hl,pl4amountherosonmap
.playerset:

	ld		c,(hl)
	inc		hl
	inc		hl
	inc		hl				                      ;plxheroxtype

	ld		a,(herowindowpointer)
	or		a
;	ld		hl,pl1hero1type
	jr		z,.herotypefound

	ld		de,lenghtherotable
	ld		b,a
.loop:
	add		hl,de
	djnz	.loop
.herotypefound:

	ld		b,a				                      ;herowindowpointer
	ld		a,c				                      ;plxamountherosonmap

;arrow left		1st hero window	 2nd hero window  3rd hero wind		arrow right		map					castle			system			end turn
;sywindow1: equ 176 | sywindow2: equ 168 | sywindow3: equ 168 | sywindow4: equ 168 | sywindow5: equ 176 | sywindow6: equ 172 | sywindow7: equ 172 | sywindow8: equ 172 | sywindow9: equ 172
;sxwindow1: equ 009 | sxwindow2: equ 018 | sxwindow3: equ 036 | sxwindow4: equ 054 | sxwindow5: equ 072 | sxwindow6: equ 130 | sxwindow7: equ 159 | sxwindow8: equ 188 | sxwindow9: equ 217


	sub		a,b
	dec		a				                        ;cp		1
	jp		z,.putonehero
	dec		a				                        ;	cp		2
	jp		z,.puttwoheros
	dec		a				                        ;	cp		3
	ret		nz
;	jp		.putthreeheros

.putthreeheros:
	ld		a,herowindow1y
	ld		(puthero+dy),a
	ld		a,herowindow1x
	ld		(puthero+dx),a
	call	.setherowindow
	ld		a,herowindow2x
	ld		(puthero+dx),a
	call	.setherowindow
	ld		a,herowindow3x
	ld		(puthero+dx),a
	jp		.setherowindow
;	ret	

.puttwoheros:
	ld		a,herowindow1y
	ld		(puthero+dy),a
	ld		a,herowindow1x
	ld		(puthero+dx),a
	call	.setherowindow
	ld		a,herowindow2x
	ld		(puthero+dx),a
	jp		.setherowindow
;	ret	

.putonehero:
	ld		a,herowindow1y
	ld		(puthero+dy),a
	ld		a,herowindow1x
	ld		(puthero+dx),a
	jp		.setherowindow
;	ret	

.setherowindow:
	ld		a,(hl)					                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
	cp		255
	ret		z

	push	hl
	and		%1111 1000
	add		a,4						                  ;hero facing forward
;set sx, sy, dx, dy, nx, ny
	ld		d,a
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
	ld		c,a
	ld		a,d
	and		%1111 0000
;	add		a,a
	ld		b,a

.setherotype:
	ld		a,b
	ld		(puthero+sy),a
	ld		a,c
	inc		a
	ld		(puthero+sx),a

	ld		a,herowindownx
	ld		(puthero+nx),a
	ld		a,herowindowny
	ld		(puthero+ny),a
	ld		hl,puthero
	call	docopy
	ld		a,16
	ld		(puthero+nx),a
	ld		a,32
	ld		(puthero+ny),a
	pop		hl
	ld		de,lenghtherotable
	add		hl,de
;/set sx, sy, dx, dy, nx, ny
	ret

eraseherowindows:
	ld		a,herowindow1y
	ld		(eraseherowindow+dy),a
	ld		a,herowindow1x
	ld		(eraseherowindow+dx),a
	ld		hl,eraseherowindow
	call	docopy
	ld		a,herowindow2x
	ld		(eraseherowindow+dx),a
	ld		hl,eraseherowindow
	call	docopy
	ld		a,herowindow3x
	ld		(eraseherowindow+dx),a
	ld		hl,eraseherowindow
	call	docopy
	ret

eraselifemovewindows:
	ld		a,colordarkbrown+16*colordarkbrown
	ld		(lifemovewindow_line+clr),a
	ld		a,herowindownx+1
	ld		(lifemovewindow_line+nx),a

	ld		a,herowindow1y
	add		a,herowindowny+2
	ld		(lifemovewindow_line+dy),a
	ld		a,herowindow1x-1
	ld		(lifemovewindow_line+dx),a
	call	.putdoubleline
	ld		a,herowindow2x-1
	ld		(lifemovewindow_line+dx),a
	call	.putdoubleline
	ld		a,herowindow3x-1
	ld		(lifemovewindow_line+dx),a
	jp		.putdoubleline
;	ret

.putdoubleline:
	ld		hl,lifemovewindow_line
	call	docopy
	ld		a,(lifemovewindow_line+dy)
	add		a,2
	ld		(lifemovewindow_line+dy),a
	ld		hl,lifemovewindow_line
	call	docopy
	ld		a,(lifemovewindow_line+dy)
	sub		a,2
	ld		(lifemovewindow_line+dy),a
	ret






















checkcurrentplayerhuman:	              ;out zero flag, current player is computer
;dont react to space / mouse click if current player is a computer
	ld		a,(whichplayernowplaying?)
	ld		hl,player1human?
	ld		b,4
.loop:
	dec		a
	jp		z,.playerfound
	inc		hl
	djnz	.loop
.playerfound:
	or		(hl)			;is this a human player ?
;player1human?:			db	1
;player2human?:			db	1
;player3human?:			db	0
;player4human?:			db	0
;whichplayernowplaying?:	db	1
	ret
;/dont react to space / mouse click if current player is a computer

ycoorspritebottom:	equ	193
xcoorspriteright:	equ	240 ;-11
mousey:	ds	1
mousex:	ds	1
MovePointer:					                  ;move mouse pointer (set mouse coordinates in spat)
	call	checkcurrentplayerhuman	        ;out zero flag, current player is computer
	ret		z

	call	ReadOutKeyboardAndMovePointer
	call	ReadOutMouseMovementAndMovePointer
  ret
	
	ReadOutMouseMovementAndMovePointer:
  ret
	ld    	a,12                          ;read mouse port 1
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call  	$1c
	 
	ld    	a,13                          ;read mouse X offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call  	$1c
	cp		1
	jp		nz,.mouseactive

	ld    	a,14                          ;read mouse Y offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call 	$1c
	cp		1
	ret		z
	call	movecursory
	ld		a,1
	call	movecursorx
	jp		.setmousespat

  .mouseactive:
	call	movecursorx

	ld    	a,14                          ;read mouse Y offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call 	$1c

	call	movecursory
  .setmousespat:
	ld		a,(spat+0)
	ld		(spat+4),a
	ld		a,(spat+1)
	ld		(spat+5),a
	ret

movecursory:
	ld    hl,spat+0 	                    ;cursory
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.up
  .down:
	add   a,(hl)
	jp		c,.outofscreenbottom
	cp		ycoorspritebottom
	jp		c,.sety
  .outofscreenbottom:
	ld		a,ycoorspritebottom
	jp		.sety
  .up:
	add		a,(hl)
	jp		c,.sety
	xor		a
  .sety:
	ld    (hl),a
	ret

movecursorx:		
	ld    hl,spat+1                       ;cursorx
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.left
  .right:
	add		a,(hl)
	jp		c,.outofscreenright
	cp		xcoorspriteright
	jp		c,.setx
  .outofscreenright:
	ld		a,xcoorspriteright
	jp		.setx
  .left:
	add		a,(hl)
	jp		c,.setx
	xor		a
  .setx:
	ld		(hl),a
	ret

PopulateKeyMatrix:
		in a,($aa)
		and %11110000
		ld d,a
		ld c,$a9
		ld b,11
		ld hl,keys + 11
.Loop:	ld a,d
		or b
		out ($aa),a
		ind
		jp nz,.Loop
		ld a,d
		out ($aa),a
		ind
		ret
		
;row 6		F3		F2		F1		CODE	CAPS	GRAPH	CTRL 	SHIFT 
;row 8 		R		D		U		L		DEL		INS		HOME	SPACE 
keys:	equ	$fbe5
ReadOutKeyboardAndMovePointer:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
	ld		bc,0                            ;b=scroll map left(-1)/right(+1),  c=scroll map up(-1)/down(+1)

;	ld		a,(keys+8)
.right:
	bit		3,a			                        ;arrow right
	jp		z,.down
	inc		b
.down:
	bit		1,a			                        ;arrow down
	jp		z,.up
	inc		c
.up:
	bit		0,a			                        ;arrow up
	jp		z,.left
	dec		c
.left:
	bit		2,a			                        ;arrow left
	jp		z,.end
	dec		b
.end:

	ld		a,(keys+6)
	bit		0,a			                        ;shift (holding down shift moves the cursor twice as fast)
	jp		nz,.endcheckshift
	ld		a,b
	add		a,a
	ld		b,a
	ld		a,c
	add		a,a
	ld		c,a
.endcheckshift:

	ld		a,b
	add		a,a
	call	movecursorx
	ld		a,c
	add		a,a
	call	movecursory

	ld		a,(spat+0)
	ld		(spat+4),a
	ld		a,(spat+1)
	ld		(spat+5),a
	ret













storeHL:	ds	2
spritechar:
	include "../sprites/sprites.tgs.gen"
spritecolor:
	include "../sprites/sprites.tcs.gen"


spritecharacter:	db	255	              ;0=d,1=u,2=ur,3=ul,4=r,5=l,6=dr,7=dl,8=shoe,9=shoeaction,10=swords,11=hand,12=change arrows
setspritecharacter:
	ld		a,(spat+1)			                ;x cursor
	or		a
	jp		z,.leftofscreen
	cp		xcoorspriteright
	jp		z,.rightofscreen
	ld		a,(spat)			                  ;y cursor
	or		a
	jp		z,.topofscreen
	cp		ycoorspritebottom	
	jp		z,.bottomofscreen
	cp		TilesPerColumn*16-12
	jp		nc,.bottomhalfofscreen

;set relative mouse position
	ld		a,(spat+1)		                  ;x	(mouse)pointer
	add		a,addxtomouse	                  ;centre mouse in grid
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		e,a
	ld		a,(mappointerx)
	add		a,e
	ld		e,a
	ld		(mouseposx),a

	ld		a,(spat)		                    ;y	(mouse)pointer
	sub		a,subyfrommouse	                ;centre mouse in grid
	jp		nc,.notcarry2
	xor		a
.notcarry2:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		d,a
	ld		a,(mappointery)
	add		a,d
	ld		d,a
	ld		(mouseposy),a
;/set relative mouse position

;check pointer on hero
	ld		bc,lenghtherotable-1
	ld		a,(whichplayernowplaying?) | cp 1 | ld hl,pl1hero1y | call .checkpointeronhero
	ld		a,(whichplayernowplaying?) | cp 2 | ld hl,pl2hero1y | call .checkpointeronhero
	ld		a,(whichplayernowplaying?) | cp 3 | ld hl,pl3hero1y | call .checkpointeronhero
	ld		a,(whichplayernowplaying?) | cp 4 | ld hl,pl4hero1y | call .checkpointeronhero
;/check pointer on hero

	call	.checkpointeroncreature
	call	.checkpointeritem
	jp		.shoe					                  ;pointer on no hero at all
;	ret



;amountofitems:		equ	4
;lenghtitemtable:	equ	10
;item1y:				db	6
;item1x:				db	7
;item1type:			db	240 - 16

;item2y:				db	6
;item2x:				db	8
;item2type:			db	255 - 16 

;item3y:				db	6
;item3x:				db	9
;item3type:			db	241 - 16

;item4y:				db	6
;item4x:				db	10
;item5type:			db	247 - 16


;check pointer on item
.checkpointeritem:
	ld		hl,item1y
	ld		bc,lenghtitemtable-1

.checkpointeronitem:
	exx
	ld		b,amountofitems
.loopitemcheck:
	exx
	;pointer on enemy hero?
	ld		a,d
	cp		(hl)			;cp y
	inc		hl
	jp		nz,.endcheckthisitem
	ld		a,e
	cp		(hl)			;cp	x
	jp		z,.pointeronitem
	;pointer on enemy hero?
.endcheckthisitem:
	add		hl,bc
	exx
	djnz	.loopitemcheck
	exx
	ret

.pointeronitem:
	pop		af				;pop call
	ld		a,09			;shoe action
	jp		.setcharacter

;/check pointer on item


;check pointer on creature
.checkpointeroncreature:
	ld		hl,creature1y
	ld		bc,lenghtcreaturetable-1

.checkpointercreature:
	exx
	ld		b,amountofcreatures
.loopcreaturecheck:
	exx
	;pointer on enemy hero?
	ld		a,d
	cp		(hl)			;cp y
	inc		hl
	jp		nz,.endcheckthiscreature
	ld		a,e
	cp		(hl)			;cp	x
	jp		z,.pointeroncreature
	;pointer on enemy hero?
.endcheckthiscreature:
	add		hl,bc
	exx
	djnz	.loopcreaturecheck
	exx
	ret
;/check pointer on creature

.checkpointeronhero:
	jp		z,.checkpointerfriend
	jp		.checkpointerenemy

;check if pointer is on enemy hero
.checkpointerenemy:
	exx
	ld		b,amountofheroesperplayer
.checkpointerenemyloop:
	exx
;pointer on enemy hero?
	ld		a,d
	cp		(hl)
	inc		hl
	jp		nz,.endcheck1
	ld		a,e
	cp		(hl)
	jp		z,.pointeronenemyhero
;pointer on enemy hero?
.endcheck1:
	add		hl,bc
	exx
	djnz	.checkpointerenemyloop
	exx
	ret

.pointeroncreature:
.pointeronenemyhero:
	pop		af				;pop call
	ld		a,10			;swords
	jp		.setcharacter
;/check if pointer is on enemy hero


;check if pointer is on friendly hero
.checkpointerfriend:
	ld		a,(plxcurrenthero)
	or		a
	exx
	ld		b,amountofheroesperplayer

.checkpointerfriendloop:
	exx
	call	.pointeronhero?			;zero flag ? pointer is on hero
	sub		lenghtherotable			;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	exx
	djnz	.checkpointerfriendloop
	exx
	ret

.pointeronhero?:
	push	af
	ld		a,d
	cp		(hl)
	inc		hl
	jp		nz,.endcheck
	ld		a,e
	cp		(hl)
	jp		z,.pointeronhero ;hand
.endcheck:
	add		hl,bc
	pop		af
	ret

.pointeronhero:
	pop		af
	jp		z,.hand
	jp		.changearrows

.hand:
	pop		af				;pop call
	pop		af				;pop call
	ld		a,11
	jp		.setcharacter

.changearrows:
	pop		af				;pop call
	pop		af				;pop call
	ld		a,12
	jp		.setcharacter
;/check if pointer is on friendly hero

.bottomhalfofscreen:			;mouse pointer is in the bottom half of screen
	ld		a,11				
	jp		.setcharacter
.shoe:
	ld		a,8
	jp		.setcharacter
.bottomofscreen:
	ld		a,0
	jp		.setcharacter
.topofscreen:
	ld		a,1
	jp		.setcharacter
.rightofscreen:
	ld		a,(spat)			;y cursor
	or		a
	jr		z,.righttop
	cp		ycoorspritebottom	
	jr		z,.rightbottom
.right:
	ld		a,4
	jp		.setcharacter
.righttop:
	ld		a,2
	jp		.setcharacter
.rightbottom:
	ld		a,6
	jp		.setcharacter
.leftofscreen:
	ld		a,(spat)			;y cursor
	or		a
	jr		z,.lefttop
	cp		ycoorspritebottom	
	jr		z,.leftbottom
.left:
	ld		a,5
	jp		.setcharacter
.lefttop:
	ld		a,3
	jp		.setcharacter
.leftbottom:
	ld		a,7
	jp		.setcharacter
.setcharacter:
	ld		hl,spritecharacter
	cp		(hl)
	ret		z
	ld		(hl),a

	ld		h,0
	ld		l,a
	add		hl,hl			;*2
	add		hl,hl			;*4
	add		hl,hl			;*8
	add		hl,hl			;*16
	add		hl,hl			;*32
	add		hl,hl			;*32
	ld		de,spritechar
	add		hl,de
	exx

;character
;	ld		a,1				;page 2/3
	xor		a				;page 0/1
	ld		hl,sprcharaddr	;sprite 0 character table in VRAM
	call	SetVdp_Write
	exx
	ld		c,$98
	call	outix64			;write sprite character of pointer and hand to vram

;color
;	ld		a,1				;page 2/3
	xor		a				;page 0/1
	ld		hl,sprcoladdr	;sprite 0 color table in VRAM
	call	SetVdp_Write
	ld		c,$98

	ld		hl,spritecolor
	call	outix32			;write sprite color of pointer and hand to vram
	ret















putsprite:
;	ld		a,1				;page 2/3
	xor		a				;page 0/1
	ld		hl,sprattaddr	;sprite attribute table in VRAM ($17600)
	call	SetVdp_Write
	ld		hl,spat			;sprite attribute table
	ld		c,$98
	call	outix128		;32 sprites
	ret

spat:						;sprite attribute table
	db		100,100,00,0	,100,100,04,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0

;	db		100,100,00,0	,100,100,04,0	,255,000,08,0	,255,000,12,0
;	db		015,000,08,0	,015,000,12,0	,031,000,08,0	,031,000,12,0
;	db		047,000,08,0	,047,000,12,0	,063,000,08,0	,063,000,12,0
;	db		079,000,08,0	,079,000,12,0	,095,000,08,0	,095,000,12,0
;	db		111,000,08,0	,111,000,12,0	,127,000,08,0	,127,000,12,0
;	db		143,000,08,0	,143,000,12,0	,230,230,00,0	,230,230,00,0
;	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
;	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0









scrollscreen:                           ;you can either scroll the scroll by moving with the mouse pointer to the edges of the screen, or by holding CTRL and let/right/up/down
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  ld    d,a                             ;controls in d
	ld		bc,0                            ;b=scroll map left(-1)/right(+1),  c=scroll map up(-1)/down(+1)

;
;row 6		F3		F2		F1		CODE	CAPS	GRAPH	CTRL 	SHIFT 
;row 8 		R		D		U		L		DEL		INS		HOME	SPACE 	
;
	ld		a,(keys+6)
	bit		1,a			                        ;check ontrols to see if CTRL is pressed
	jp		nz,.EndCheckCTRL

  ld    a,(Controls)
  and   %1111 0000
  ld    (Controls),a

  bit   2,d                             ;check ontrols to see if left is pressed
  jr    z,.EndCheckCTRLAndLeft
	dec		b
  .EndCheckCTRLAndLeft:

  bit   3,d                             ;check ontrols to see if right is pressed
  jr    z,.EndCheckCTRLAndRight
	inc		b
  .EndCheckCTRLAndRight:

  bit   0,d                             ;check ontrols to see if up is pressed
  jr    z,.EndCheckCTRLAndUp
	dec		c
  .EndCheckCTRLAndUp:

  bit   1,d                             ;check ontrols to see if down is pressed
  jr    z,.endcheck
	inc		c
  jp    .endcheck
  .EndCheckCTRL:

  .left:                                ;check if cursor is at the left side of the screen and left is pressed
	ld		a,(spat+1)			                ;x cursor
	or		a
	jr		nz,.right
  bit   2,d                             ;check ontrols to see if left is pressed
  jr    z,.right
	dec		b

  .right:                               ;check if cursor is at the right side of the screen and right is pressed
	cp		xcoorspriteright
	jr		nz,.up
  bit   3,d                             ;check ontrols to see if right is pressed
  jr    z,.up
	inc		b

  .up:                                  ;check if cursor is at the top side of the screen and up is pressed
	ld		a,(spat)			                  ;x cursor
	or		a
	jr		nz,.down
  bit   0,d                             ;check ontrols to see if up is pressed
  jr    z,.down
	dec		c

  .down:        
	cp		ycoorspritebottom
	jr		nz,.endcheck
  bit   1,d                             ;check ontrols to see if down is pressed
  jr    z,.endcheck
	inc		c
  .endcheck:

	ld		a,(maplenght)                   ;total lenght of map
	sub		a,TilesPerRow-1                 ;total lenght of map - total lenght of visible map in screen
	ld		d,a
	ld		a,(mapheight)
	sub		a,TilesPerColumn-1
	ld		e,a

	ld		a,(mappointerx)
	add		a,b                             ;set new map pointer x
	cp		d                               ;check if camera is still within the total map
	jp		nc,.endmovex
	ld		(mappointerx),a
  .endmovex:

	ld		a,(mappointery)
	add		a,c                             ;set new map pointer y
	cp		e                               ;check if camera is still within the total map
  ret   nc
	ld		(mappointery),a	
	ret	

SetPageSpecial:                         
  ld    a,0*32+31
  jr    z,.setpage
  ld    a,1*32+31
  .setpage:                             ;in a->x*32+31 (x=page)
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  ret

buildupscreenYoffset:	equ	5
buildupscreenXoffset:	equ	6
TilesPerColumn:				equ	12
;halfnumberrows:			  equ	TilesPerColumn/2
TilesPerRow:				  equ	12
;halflenghtrow:			  equ	TilesPerRow/2
mapdata:  equ $8000

maplenght:			dw	128
mapheight:			db	128

buildupscreen:
	ld		hl,mapdata                      ;set map pointer x
	ld		de,(mappointerx)
	add		hl,de	
	ld		a,(mappointery)                 ;set map pointer y
	or		a
	jp		z,.endsetmappointer
	ld		b,a
	ld		de,(maplenght)
  .setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
  .endsetmappointer:                    ;hl points to mapdata (x,y)

	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	ld		(Copy16x16Tile+dpage),a		      ;copy new blocks to inactive page
	ld		(puthero+dpage),a
	ld		(putherotopbottom+dpage),a
	ld		(putcastle+dpage),a
	ld		(putbackgroundoverhero+dpage),a
	ld		(putstar+dpage),a
	ld		(putstarbehindobject+dpage),a
	ld		(putline+dpage),a
	ld		(eraseherowindow+dpage),a
	ld		(lifemovewindow_line+dpage),a
	ld		(blackrectangle+dpage),a
	ld		(putlettre+dpage),a

	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	ld		de,mappage1                     ;start writing to mappage1 if our current active page = 0
	jr		z,.mirrorpageset
	ld		de,mappage0                     ;start writing to mappage0 if our current active page = 1
  .mirrorpageset:
	call	SetPageSpecial					        ;set page

  ex    de,hl                           ;hl->points to tile in inactive page, de->pointer to tile in total map 

  ld		a,buildupscreenYoffset          ;Y start of visible map (Is probably always gonna be 0)
;  xor   a
	ld		(Copy16x16Tile+dy),a

	ld		bc,TilesPerColumn*256 + 16      ;b=TilesPerColumn, c=16
  .loop:
	push	bc
  ld		a,buildupscreenXoffset          ;X start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dx),a            ;first tile on each row starts at x=0
	call	putrow				                  ;put all the pieces (defined in 'TilesPerRow') in this row

	ld		a,(Copy16x16Tile+dy)            ;next row will be 16 pixels lower. the value 16 is still in c at this point
	add		a,c
	ld		(Copy16x16Tile+dy),a	

;  .SelfmodifyingMaplenghtMinusTilesPerRow:  Equ $+1
  ld    bc,128 - 12                      ;maplenght - tiles per row
  ex    de,hl
	add		hl,bc                           ;jump to first tile of next row in screen display
  ex    de,hl

	pop		bc
	djnz	.loop
	ret

putrow:                                 ;hl->points to tile in inactive page, de->pointer to tile in total map 
	ld		b,TilesPerRow                   ;number of tiles per row
.loop:
	call	PutTile                         ;copy 16x16 tile into the inactive page
	inc		hl
	inc		de

	ld		a,(Copy16x16Tile+dx)
	add		a,c
	ld		(Copy16x16Tile+dx),a

	djnz	.loop
	ret

PutTile:                                ;copy 16x16 tile into the inactive page
	ld		a,(de)                          ;hl->points to tile in inactive page, de->pointer to tile in total map 
	cp		(hl)	
  ret   z                               ;don't put tile if this tile is already present
	ld		(hl),a

	exx                                   ;set sx of tile. in: a=tilenr
	ld		e,a                             ;store tilenr
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
	ld		(Copy16x16Tile+sx),a
	;/set sx

	;set sy
	ld		a,e
	ld		d,-1
.setsy:
	sub		a,16
	inc		d
	jp		nc,.setsy
	ld		a,d
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
	ld		(Copy16x16Tile+sy),a
	;/set sy

	ld		hl,Copy16x16Tile
	call	docopy
	exx
	ret

ymapstart:	equ	0
;put items / artifacts / heroes on map

Copy16x16Tile:
	db		255,000,255,003
	db		255,000,255,000
	db		016,000,016,000
	db		000,000,$d0	

mappage0:
	ds		TilesPerColumn*TilesPerRow,255
mappage1:
	ds		TilesPerColumn*TilesPerRow,255
















BackdropRandom:
  ld    a,r
  jp    SetBackDrop

BackdropOrange:
  ld    a,13
  jp    SetBackDrop

BackdropGreen:
  ld    a,10
  jp    SetBackDrop

BackdropRed:
  ld    a,14
  jp    SetBackDrop

BackdropBlack:
  ld    a,15
  jp    SetBackDrop

BackdropBlue:
  xor   a
  SetBackDrop:
ret
  di
  out   ($99),a
  ld    a,7+128
  ei
  out   ($99),a	
  ret

FreeToUseFastCopy1:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

FreeToUseFastCopy2:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

FreeToUseFastCopy3:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

ScreenOff:
  ld    a,(VDP_0+1)                     ;screen off
  and   %1011 1111
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

ScreenOn:
  ld    a,(VDP_0+1)                     ;screen on
  or    %0100 0000
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

PutSpatToVram:
;	ld		hl,(invisspratttableaddress)		;sprite attribute table in VRAM ($17600)
;	ld		a,1
;	call	SetVdp_Write	

  ;SetVdp_Write address for Spat
	di
;  ld    a,$05
;	out   ($99),a       ;set bits 15-17
;	ld    a,14+128
;	out   ($99),a       ;/first set register 14 (actually this only needs to be done once)
  xor   a
;  nop
	out   ($99),a       ;set bits 0-7
  SelfmodifyingCodeSpatAddress: equ $+1
	ld    a,$6e         ;$6e /$76 
;  nop
	ld		hl,spat			;sprite attribute table, and replace the nop required wait time
	out   ($99),a       ;set bits 8-14 + write access

  ld    c,$98
;	call	outix128

;outi = 16 (4 cycles) (4,5,3,4)
;nop = 4 (1 cycle)
;in a,($98) = 11 (3 cycles)
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi;|nop|in a,($98)|nop|in a,($98)|
	ei
  ret

activepage:		db	0
mappointerx:	dw  0
mappointery:	db	0
heroymirror:	ds	1
heroxmirror:	ds	1

amountofheroesperplayer:	equ	10
plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
lenghtherotable:	equ	16

pl1amountherosonmap:	db	2
pl1hero1y:		db	4
pl1hero1x:		db	2
pl1hero1type:	db	0		                  ;hero type	;0=adol, 8=goemon, 32=pixie...... 255=no more hero
pl1hero1life:	db	10,20
pl1hero1move:	db	12,20
pl1hero1mana:	db	10,20
pl1hero1manarec:db	5		                ;recover x mana every turn
pl1hero1items:	db	255,255,255,255,255
pl1hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

pl1hero2y:		db	4
pl1hero2x:		db	3
pl1hero2type:	db	8		                  ;0=adol, 8=goemon, 32=pixie
pl1hero2life:	db	05,20
pl1hero2move:	db	10,20
pl1hero2mana:	db	10,20
pl1hero2manarec:db	5		                ;recover x mana every turn
pl1hero2items:	db	255,255,255,255,255
pl1hero2status:	db	2		                ;255=inactive, 2=hero is active on map, 11=in castle, 12=in fight, 3=part of hero 3's team

pl1hero3y:		db	255		                ;255=hero is part of another heros team
pl1hero3x:		db	255		
pl1hero3type:	db	32		                ;0=adol, 8=goemon, 32=pixie
pl1hero3life:	db	03,20
pl1hero3move:	db	30,20
pl1hero3mana:	db	10,20
pl1hero3manarec:db	5		                ;recover x mana every turn
pl1hero3items:	db	255,255,255,255,255
pl1hero3status:	db	1		                ;255=inactive, 3=hero is active on map, 11=in castle, 12=in fight, 1=part of hero 1's team

pl1hero4y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero5y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero6y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero7y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero8y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero9y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
pl1hero10y:		db	255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

;					y,	x,	type,life,lifemax,move,movemax,mana,manamax,manarec

pl2amountherosonmap:	db	2
pl2hero1y:		db	4
pl2hero1x:		db	100
pl2hero1type:	db	40		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl2hero1life:	db	10,20
pl2hero1move:	db	10,20
pl2hero1mana:	db	10,20
pl2hero1manarec:db	2		                ;recover x mana every turn
pl2hero1items:	db	255,255,255,255,255
pl2hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

;pl2hero1y:		db	014,020,032, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255
pl2hero2y:		db	004,101,064, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
pl2hero3y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero4y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero5y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero6y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero7y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero8y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero9y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero10y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255

pl3amountherosonmap:	db	2
pl3hero1y:		db	100
pl3hero1x:		db	02
pl3hero1type:	db	96		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl3hero1life:	db	10,20
pl3hero1move:	db	10,20
pl3hero1mana:	db	10,20
pl3hero1manarec:db	2		                ;recover x mana every turn
pl3hero1items:	db	255,255,255,255,255
pl3hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

pl3hero2y:		db	100,003,104, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
pl3hero3y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero4y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero5y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero6y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero7y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero8y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero9y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero10y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255

pl4amountherosonmap:	db	2
pl4hero1y:		db	100
pl4hero1x:		db	100
pl4hero1type:	db	136		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl4hero1life:	db	10,20
pl4hero1move:	db	10,20
pl4hero1mana:	db	10,20
pl4hero1manarec:db	2		                ;recover x mana every turn
pl4hero1items:	db	255,255,255,255,255
pl4hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

pl4hero2y:		db	100,101,160, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
pl4hero3y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero4y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero5y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero6y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero7y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero8y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero9y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl4hero10y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255

amountofitems:		equ	4
lenghtitemtable:	equ	3
item1y:				db	6
item1x:				db	7
item1type:			db	240 - 16

item2y:				db	6
item2x:				db	8
item2type:			db	255 - 16 

item3y:				db	6
item3x:				db	9
item3type:			db	241 - 16

item4y:				db	6
item4x:				db	10
item5type:			db	247 - 16

non_see_throughpieces:  equ 16
amountoftransparantpieces:  equ 64
;/check if hero is behind a tree

mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112
  
unpassablepieces:
	db	0,1,2,3,4,5,48,49,50,51,52,53,54,55,56,57,58,59,60,61,64,65,66,67,68,69,107,108,109

putbackgroundoverhero:
	db		16,0,64,3
	db		255,0,255,0
	db		16,0,16,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

putherotopbottom:
	db		224,0,0,2
	db		96,0,96,0
	db		16,0,16,0
	db		0,%0000 0000,$98	

puthero:
	db		224,0,0,2
	db		96,0,96,0
	db		16,0,32,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

castlepl1y:	db	004 | castlepl1x:	db	001
castlepl2y:	db	004 | castlepl2x:	db	100
castlepl3y:	db	100 | castlepl3x:	db	001
castlepl4y:	db	100 | castlepl4x:	db	100
castley:	ds	1
castlex:	ds	1

putcastle:
	db		255,0,208,3
	db		255,0,255,0
	db		16,0,16,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

putstar:
	db		208,0,192,3
	db		255,0,255,0
	db		10,0,8,0
	db		0,%0000 0000,$98	

putstarbehindobject:
	db		208,0,200,3
	db		255,0,255,0
	db		10,0,8,0
	db		0,%0000 0000,$98	

colorwhite: equ 1
  putline:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    0,0,0,0
	DB    colorwhite+16*colorwhite,1,$80

colordarkbrown: equ 13
lifemovewindow_line:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    herowindownx+1,0,1,0
	DB    colordarkbrown+16*colordarkbrown,1,$80

;herowindownx:	equ	14
;herowindowny:	equ	29

eraseherowindow:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    herowindownx,0,herowindowny,0
	DB    colordarkbrown+16*colordarkbrown,1,$80

lenghtbuttontable:	equ	5
amountofbuttons:	equ	5

;arrow left		1st hero window	 2nd hero window  3rd hero wind		arrow right		map					castle			system			end turn
sywindow1: equ 176 | sywindow2: equ 168 | sywindow3: equ 168 | sywindow4: equ 168 | sywindow5: equ 176 | sywindow6: equ 172 | sywindow7: equ 172 | sywindow8: equ 172 | sywindow9: equ 172
sxwindow1: equ 009 | sxwindow2: equ 018 | sxwindow3: equ 036 | sxwindow4: equ 054 | sxwindow5: equ 072 | sxwindow6: equ 130 | sxwindow7: equ 159 | sxwindow8: equ 188 | sxwindow9: equ 217

			;	sy(-2),			ny(-2),	sx-7,			nx-2,	lit?
buttons:	
      db	sywindow1-2,	15-2,	sxwindow1-7,	8-2,	0	;arrow left
			db	sywindow2-2,	32-2,	sxwindow2-7,	17-2,	0	;1st hero window
			db	sywindow3-2,	32-2,	sxwindow3-7,	17-2,	0	;2nd hero window
			db	sywindow4-2,	32-2,	sxwindow4-7,	17-2,	0	;3rd hero window	
			db	sywindow5-2,	15-2,	sxwindow5-7,	8-2,	0	;arrow right

			db	sywindow6-2,	28-2,	sxwindow6-7,	28-2,	0	;map
			db	sywindow7-2,	28-2,	sxwindow7-7,	28-2,	0	;castle
			db	sywindow8-2,	28-2,	sxwindow8-7,	28-2,	0	;system
			db	sywindow9-2,	28-2,	sxwindow9-7,	28-2,	0	;end turn

herowindow1y:	equ	sywindow2+2
herowindow1x:	equ	sxwindow2+2
herowindow2x:	equ	sxwindow3+2
herowindow3x:	equ	sxwindow4+2
herowindownx:	equ	14
herowindowny:	equ	29

				;	a,b,c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,  r,  s,  t,  u,  v,  w,  x,  y,  z
lettreoffset:	db	0,7,14,21,28,33,38,45,52,54,60,67,73,79,86,93,100,107,114,121,126,134,141,148,155,162
				;	0   1   2   3   4   5   6   7   8   9	space	dot
				db	168,174,177,182,187,192,198,203,208,213,218,223,69,71

putlettre:
	db		0,0,212,1
	db		40,0,40,0
	db		16,0,5,0
	db		0,%0000 0000,$98	

colorblack: equ 0
blackrectangle:
	db	0,0,0,0
	db	255,0,255,0
	db	255,0,255,0
	db	colorblack+colorblack*16,1,$c0

mouseposy:		ds	1
mouseposx:		ds	1
mouseclicky:	ds	1
mouseclickx:	ds	1
addxtomouse:	equ	8
subyfrommouse:	equ	4

turnbased?:				db	1
amountofplayers:		db	4
player1human?:			db	1
player2human?:			db	1
player3human?:			db	1
player4human?:			db	1
whichplayernowplaying?:	db	1


amountofcreatures:	equ	4
lenghtcreaturetable:equ	10
creature1y:			db	8
creature1x:			db	10
creature1type:		db	224 		;201=last small creature | 202=1st big creature | 224=left bottom | 228=1st huge creature
creature1a_amount:	db	10
creature1b_type:	db	177			;other creatures in this pack
creature1b_amount:	db	10
creature1c_type:	db	177			;other creatures in this pack
creature1c_amount:	db	10
creature1d_type:	db	177			;other creatures in this pack
creature1d_amount:	db	10

creature2y:			db	8
creature2x:			db	11
creature2type:		db	202 		;202= first big creature
creature2a_amount:	db	10
creature2b_type:	db	177			;other creatures in this pack
creature2b_amount:	db	10
creature2c_type:	db	177			;other creatures in this pack
creature2c_amount:	db	10
creature2d_type:	db	177			;other creatures in this pack
creature2d_amount:	db	10

creature3y:			db	8
creature3x:			db	12
creature3type:		db	182 		;202= first big creature
creature3a_amount:	db	10
creature3b_type:	db	177			;other creatures in this pack
creature3b_amount:	db	10
creature3c_type:	db	177			;other creatures in this pack
creature3c_amount:	db	10
creature3d_type:	db	177			;other creatures in this pack
creature3d_amount:	db	10

creature4y:			db	08
creature4x:			db	13
creature4type:		db	193  		;202= first big creature
creature4a_amount:	db	10
creature4b_type:	db	177			;other creatures in this pack
creature4b_amount:	db	10
creature4c_type:	db	177			;other creatures in this pack
creature4c_amount:	db	10
creature4d_type:	db	177			;other creatures in this pack
creature4d_amount:	db	10

movementpathpointer:	ds	1	
movehero?:				ds	1
movementspeed:			ds	1

putmovementstars?:	db	0
movementpath:		ds	64	;1stbyte:yhero,	2ndbyte:xhero
ystar:				ds	1
xstar:				ds	1

currentherowindowclicked:	db	0