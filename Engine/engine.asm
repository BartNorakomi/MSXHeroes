LevelEngine:
  call  PopulateControls                ;read out keys
	call	scrollscreen                    ;scroll screen if cursor is on the edges or if you press the minimap
	call	buildupscreen                   ;build up the visible map in page 0/1
	call	setherosinwindows               ;erase hero and life status windows, then put the heroes in the windows and set the life and movement status of the heroes

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
	call	PopulateKeyMatrix
	ld		bc,0
	
	ld		a,(keys+8)
.right:
	bit		7,a			                        ;arrow right
	jp		nz,.down
	inc		b
.down:
	bit		6,a			                        ;arrow down
	jp		nz,.up
	inc		c
.up:
	bit		5,a			                        ;arrow up
	jp		nz,.left
	dec		c
.left:
	bit		4,a			                        ;arrow left
	jp		nz,.end
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









scrollscreen:
	ld		bc,0

.left:
	ld		a,(spat+1)			                ;x cursor
	or		a
	jp		nz,.right
	dec		b
.right:
	cp		xcoorspriteright
	jp		nz,.up
	inc		b
.up:
	ld		a,(spat)			                  ;x cursor
	or		a
	jp		nz,.down
	dec		c
.down:
	cp		ycoorspritebottom
	jp		nz,.endcheck
	inc		c
.endcheck:

	ld		a,b
	or		c
	ret		z

	ld		a,(maplenght)
	sub		a,TilesPerRow-1
	ld		d,a
	ld		a,(mapheight)
	sub		a,TilesPerColumn-1
	ld		e,a

	ld		a,(mappointerx)
	add		a,b
	cp		d
	jp		nc,.endmovex
	ld		(mappointerx),a
.endmovex:
	ld		a,(mappointery)
	add		a,c
	cp		e
	jp		nc,.endmovey
	ld		(mappointery),a	
.endmovey:
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

;buildupscreenYoffset:	equ	0
TilesPerColumn:				equ	10
;halfnumberrows:			  equ	TilesPerColumn/2
TilesPerRow:				  equ	16
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

;  ld		a,buildupscreenYoffset          ;Y start of visible map (Is probably always gonna be 0)
  xor   a
	ld		(Copy16x16Tile+dy),a

	ld		bc,TilesPerColumn*256 + 16      ;b=TilesPerColumn, c=16
  .loop:
	push	bc
	xor		a
	ld		(Copy16x16Tile+dx),a            ;first tile on each row starts at x=0
	call	putrow				                  ;put all the pieces (defined in 'TilesPerRow') in this row

	ld		a,(Copy16x16Tile+dy)            ;next row will be 16 pixels lower. the value 16 is still in c at this point
	add		a,c
	ld		(Copy16x16Tile+dy),a	

;  .SelfmodifyingMaplenghtMinusTilesPerRow:  Equ $+1
  ld    bc,128 - 16                      ;maplenght - tiles per row
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
pl2hero1y:		db	14
pl2hero1x:		db	20
pl2hero1type:	db	40		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl2hero1life:	db	10,20
pl2hero1move:	db	10,20
pl2hero1mana:	db	10,20
pl2hero1manarec:db	2		                ;recover x mana every turn
pl2hero1items:	db	255,255,255,255,255
pl2hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

;pl2hero1y:		db	014,020,032, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255
pl2hero2y:		db	014,019,064, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
pl2hero3y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero4y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero5y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero6y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero7y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero8y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero9y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl2hero10y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255

pl3amountherosonmap:	db	2
pl3hero1y:		db	06
pl3hero1x:		db	18
pl3hero1type:	db	96		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl3hero1life:	db	10,20
pl3hero1move:	db	10,20
pl3hero1mana:	db	10,20
pl3hero1manarec:db	2		                ;recover x mana every turn
pl3hero1items:	db	255,255,255,255,255
pl3hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

pl3hero2y:		db	006,019,104, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
pl3hero3y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero4y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero5y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero6y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero7y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero8y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero9y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255
pl3hero10y:		db	255,255,255, 255, 255,	  255, 255,	   255, 255,    255 ,255,255,255,255,255,255

pl4amountherosonmap:	db	2
pl4hero1y:		db	15
pl4hero1x:		db	03
pl4hero1type:	db	136		                ;hero type	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl4hero1life:	db	10,20
pl4hero1move:	db	10,20
pl4hero1mana:	db	10,20
pl4hero1manarec:db	2		                ;recover x mana every turn
pl4hero1items:	db	255,255,255,255,255
pl4hero1status:	db	1		                ;255=inactive, 1=hero is active on map, 11=in castle, 12=in fight, 2=part of hero 2's team

pl4hero2y:		db	015,004,160, 010, 020,	  010, 020,	   010, 020,    002 ,255,255,255,255,255,2
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
  ds	16*2 	
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 000,224, 000,240, 000,000, 000,000
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 016,224, 016,240, 048,224, 048,240
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

castlepl1y:	db	04 | castlepl1x:	db	01
castlepl2y:	db	14 | castlepl2x:	db	19
castlepl3y:	db	06 | castlepl3x:	db	18
castlepl4y:	db	15 | castlepl4x:	db	03
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
buttons:	db	sywindow1-2,	15-2,	sxwindow1-7,	8-2,	0	;arrow left
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
amountofplayers:		db	2
player1human?:			db	1
player2human?:			db	1
player3human?:			db	0
player4human?:			db	0
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
