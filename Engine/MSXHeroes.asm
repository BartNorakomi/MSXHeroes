		fname	"MSXHeroes.rom"
	org		$4000
MSXHeroes:
;
; MSXHeroes - ROM version
;
	dw		"AB",init,0,0,0,0,0,0
;
; this is one-time only... can be overwritten with game stuff after it's done
;
memInit:	
	phase	$c000
;
initMem:	
	call	whereAmI	; Slot of this ROM
	ld		(romSlot),a
	ld		hl,$0000
	call	findRam		; Slot of RAM in page 0
	ld		(page0ram),a
	ld		hl,$4000
	call	findRam		; Slot of RAM in page 1
	ld		(page1ram),a
	ld		hl,$8000
	call	findRam		; Slot of RAM in page 2
	ld		(page2ram),a
	
	;ld	a,(page2ram)
	and		$03
	add		a,a
	add		a,a
	ld		b,a
	ld		a,(page1ram)
	and		$03
	or		b
	add		a,a
	add		a,a
	ld		b,a
	ld		a,(page0ram)
	and		$03
	or		b
	ld		b,a
	call	$138
	and		$c0
	or		b
	ld		b,a
	ld		(slot.ram),a
	
	and		$f3
	ld		c,a
	ld		a,(romSlot)
	and		$03
	add		a,a
	add		a,a
	or		c
	ld		(slot.page1rom),a
	
	ld		a,b
	and		$cf
	ld		c,a
	ld		a,(romSlot)
	and		$03
	add		a,a
	add		a,a
	add		a,a
	add		a,a
	or		c
	ld		(slot.page2rom),a
	
	ld		a,b
	and		$c3
	ld		c,a
	ld		a,(romSlot)
	and		$03
	ld		b,a
	add		a,a
	add		a,a
	or		b
	add		a,a
	add		a,a
	or		c
	ld		(slot.page12rom),a
	
	ld		a,(romSlot)
	ld		h,$80
	call	$24
	
	ld		a,(page1ram)
	ld		h,$40
	call	$24
	
	ld		a,(romSlot)
	ld		h,$40
	call	$24
	
	ld		b,3
	ld		de,.enaRam
	ld		hl,$3ffd
	push	hl
.ramOn:		
	push	bc
	push	de
	push	hl
	ld		a,(de)
	ld		e,a
	ld		a,(page0ram)
	call	$14
	pop		hl
	pop		de
	pop		bc
	inc		de
	inc		hl
	djnz	.ramOn
	ld		a,(page0ram)
	push	af
	pop		iy
	pop		ix
	ld		(tempStack),sp
	jp		$1c

.done:		
	ld		sp,(tempStack)
	ret

.enaRam:	
	jp		.done

searchSlot:		db	0
searchAddress:	dw	0
tempStack:		dw	0
page0ram:		db	0
page1ram:		db	0
page2ram:		db	0
romSlot:		db	0
;
; Out: A = slot of this ROM (E000SSPP)
;
whereAmI:	
	call	$138
	rrca
	rrca
	and		$03
	ld		c,a
	ld		b,0
	ld		hl,$fcc1
	add		hl,bc
	or		(hl)
	ld		c,a
	inc		hl
	inc		hl
	inc		hl
	inc		hl
	ld		a,(hl)
	and		$0c
	or		c
	ret
;
; In: HL = Address in page to search RAM
; Out: A = RAM slot of the page
;
findRam:	
	ld		bc,4 *256+ 0
	ld		(searchAddress),hl
	ld		hl,$fcc1
.primary.loop:	
	push	bc
	push	hl
	ld		a,(hl)
	bit		7,a
	jr		nz,.secondary
	ld		a,c
	call	.check
.primary.next:	
	pop		hl
	pop		bc
	ld		a,(searchSlot)
	ret		c
	inc		hl
	inc		c
	djnz	.primary.loop
	ld		a,-1			; should normally never occur
	ld		(searchSlot),a
	ret

.secondary:	
	and		$80
	or		c
	ld		b,4
.sec.loop:	
	push	bc
	call	.check
	pop		bc
	jr		c,.primary.next
	add		a,4
	djnz	.sec.loop
	jr		.primary.next

.check:		
	ld		(searchSlot),a
	call	.read
	ld		b,a
	cpl
	ld		c,a
	call	.write
	call	.read
	cp		c
	jr		nz,.noram
	cpl
	call	.write
	call	.read
	cp		b
	jr		nz,.noram
	ld		a,(searchSlot)
	scf
	ret
.noram:		
	ld		a,(searchSlot)
	or		a
	ret

.read:		
	push	bc
	push	hl
	ld		a,(searchSlot)
	ld		hl,(searchAddress)
	call	$0c
	pop		hl
	pop		bc
	ret

.write:		
	push	bc
	push	hl
	ld		e,a
	ld		a,(searchSlot)
	ld		hl,(searchAddress)
	call	$14
	pop		hl
	pop		bc
	ret

initMem.length:	equ	$-initMem
		dephase
;
; end of one-time only code...
;

;
init:		
  ld    a,13        ;is zwart in onze huidige pallet
	ld		($f3e9),a	  ;foreground color 
	ld		($f3ea),a	  ;background color 
	ld		($f3eb),a	  ;border color

  ld    a,13        ;start write to this palette color (15)
  di
	out		($99),a
	ld		a,16+128
	out		($99),a
	xor		a
	out		($9a),a
  ei
	out		($9a),a

	ld 		a,5			    ;switch to screen 5
	call 	$5f

	ld		a,(VDP_8+1)	
	and		%1111 1101	;set 60 hertz
	or		%1000 0000	;screen height 212
	ld		(VDP_8+1),a
	di
	out		($99),a
	ld		a,9+128
	ei
	out		($99),a

;screenmode transparancy (i think this is about usage of color 0 in sprites)
	ld		a,(vdp_8)
	or		32				  ;transparant mode off
;	and		223				  ;tranparant mode on
	ld		(vdp_8),a
	di
	out		($99),a
	ld		a,8+128
	ei
	out		($99),a

  xor   a
	ld		(vdp_8+15),a
	di
	out		($99),a
	ld		a,23+128
	ei
	out		($99),a

	di
	im		1
	ld		bc,initMem.length
	ld		de,initMem
	ld		hl,memInit
	ldir
	call	initMem

  xor   a     ;init blocks ascii16
	ld		(memblocks.1),a
	ld		($6000),a
	inc		a
	ld		(memblocks.2),a
	ld		($7000),a

; load BIOS / engine , load startup
	ld		hl,tempisr
	ld		de,$38
	ld		bc,6
	ldir

;SpriteInitialize:
	ld		a,(vdp_0+1)
	or		2			;sprites 16*16
	ld		(vdp_0+1),a
	di
	out		($99),a
	ld		a,1+128
	ei
	out		($99),a
;/SpriteInitialize:

	ld		hl,engine
	ld		de,engaddr
	ld		bc,enlength	        ;load engine
	ldir

	ld		hl,enginepage3
	ld		de,enginepage3addr
	ld		bc,enginepage3length	    ;load enginepage3
	ldir

  jp    InitiateGame

		; set temp ISR
tempisr:	
	push	af
	in		a,($99)             ;check and acknowledge vblank int (ei0 is set)
	pop		af
	ei	
	ret

; 
; block 00
;	
enginepage3:
	include	"enginepage3.asm"	

; 
; block 00 - 01 engine 
;	
engine:
phase	engaddr
	include	"engine.asm"	
endengine:
dephase
enlength:	Equ	$-engine
;
; fill remainder of blocks 00-01
;
	ds		$c000-$,$ff		

;
; block $02
;
Loaderblock:  equ $02
phase	$4000
StartLoaderRoutine:
	include	"loader.asm"	
endLoaderRoutine:
LoaderRoutinelength:	Equ	$-StartLoaderRoutine
	ds		$8000-$,$ff		
dephase

;
; block $03 - 04
;
World1TilesBlock:  equ   $03
phase	$4000
  incbin "..\grapx\tilesheets\world1tiles.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\world1tilesBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $05
;
World1MapBlock:  equ   $05
World1ObjectLayerMapBlock:  equ   $05
phase	$4000
World1Map:
  incbin "..\maps\world1.map.pck"
World1ObjectLayerMap:
  incbin "..\maps\world1ObjectLayer.map.pck"
	ds		$8000-$,$ff
dephase









AdolSpriteBlock:              equ HeroesSpritesBlock1
Goemon1SpriteBlock:           equ HeroesSpritesBlock1
PixySpriteBlock:              equ HeroesSpritesBlock1
Drasle1SpriteBlock:           equ HeroesSpritesBlock1
LatokSpriteBlock:             equ HeroesSpritesBlock1
Drasle2SpriteBlock:           equ HeroesSpritesBlock1
Snake1SpriteBlock:            equ HeroesSpritesBlock1
Drasle3SpriteBlock:           equ HeroesSpritesBlock1

Snake2SpriteBlock:            equ HeroesSpritesBlock2
Drasle4SpriteBlock:           equ HeroesSpritesBlock2
AshguineSpriteBlock:          equ HeroesSpritesBlock2
Undeadline1SpriteBlock:       equ HeroesSpritesBlock2
PsychoWorldSpriteBlock:       equ HeroesSpritesBlock2
Undeadline2SpriteBlock:       equ HeroesSpritesBlock2
Goemon2SpriteBlock:           equ HeroesSpritesBlock2
Undeadline3SpriteBlock:       equ HeroesSpritesBlock2

FraySpriteBlock:              equ HeroesSpritesBlock3
BlackColorSpriteBlock:        equ HeroesSpritesBlock3
WitSpriteBlock:               equ HeroesSpritesBlock3
MitchellSpriteBlock:          equ HeroesSpritesBlock3
JanJackGibsonSpriteBlock:     equ HeroesSpritesBlock3
GillianSeedSpriteBlock:       equ HeroesSpritesBlock3
SnatcherSpriteBlock:          equ HeroesSpritesBlock3
GolvelliusSpriteBlock:        equ HeroesSpritesBlock3

BillRizerSpriteBlock:         equ HeroesSpritesBlock4
PochiSpriteBlock:             equ HeroesSpritesBlock4
GreyFoxSpriteBlock:           equ HeroesSpritesBlock4
TrevorBelmontSpriteBlock:     equ HeroesSpritesBlock4
BigBossSpriteBlock:           equ HeroesSpritesBlock4
SimonBelmontSpriteBlock:      equ HeroesSpritesBlock4
DrPettrovichSpriteBlock:      equ HeroesSpritesBlock4
RichterBelmontSpriteBlock:    equ HeroesSpritesBlock4

;
; block $06 - 07
;
HeroesSpritesBlock1:  equ   $06
HeroesSpritesBlock2:  equ   HeroesSpritesBlock1 + 1
phase	$4000
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet1.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet1Bottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $08 - 09
;
HeroesSpritesBlock3:  equ   HeroesSpritesBlock1 + 2
HeroesSpritesBlock4:  equ   HeroesSpritesBlock1 + 3
phase	$4000
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet2.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet2Bottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $0a - 0b
;
HudNewBlock:  equ   $0a
phase	$4000
  incbin "..\grapx\hud\HudNew.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $0c - 0d
;
CastleOverviewBlock:  equ   $0c
phase	$4000
  incbin "..\grapx\CastleOverview\CastleOverview.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\CastleOverview\chamberofcommerce4.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\CastleOverview\tavernoriginal.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\CastleOverview\magicguild.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\CastleOverview\chamberofcommerce.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\CastleOverview\image7.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase


;
; block $0e - 0f
;
BattleFieldSnowBlock:  equ   $0e
phase	$4000
  incbin "..\grapx\BattleField\BattleFieldSnow.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $10 - 11
;
Enemy14x14PortraitsBlock:  equ   $10
phase	$4000
  incbin "..\grapx\MonsterSprites\14x14Portraits.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $12 - 13
;
Hero10x18PortraitsBlock:  equ   $12
phase	$4000
  incbin "..\grapx\HeroesSprites\10x18Portraits.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $14 - 15
;
Hero14x9PortraitsBlock:  equ   $14
phase	$4000
  incbin "..\grapx\HeroesSprites\14x9Portraits.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $16 - 17
;
HudBlock:  equ   $16
phase	$4000
  incbin "..\grapx\hud\hud.SC5",7,208 * 128      ;208 lines
;  incbin "..\grapx\hud\hudBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $18 - 19
;
World1ObjectsBlock:  equ   $18
phase	$4000
  incbin "..\grapx\tilesheets\world1Objects.SC5",7+(64*128),144 * 128      ;144 lines
  incbin "..\grapx\tilesheets\world1ObjectsBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $1a - 1b
;
HeroOverviewGraphicsBlock:  equ   $1a
phase	$4000
  incbin "..\grapx\HeroOverview\HeroOverviewGraphics.SC5",7,212 * 128      ;212 lines
;  incbin "..\grapx\HeroOverview\HeroOverviewGraphicsBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $1c
;
HeroOverviewCodeBlock:  equ   $1c
HeroOverviewFontBlock:  equ   $1c
phase	$4000
  incbin "..\grapx\HeroOverview\font.SC5",7,7 * 128      ;5 lines
  include "HeroOverviewCode.asm"
	ds		$8000-$,$ff
dephase

;
; block $1d - 1e
;
HeroOverviewStatusGraphicsBlock:  equ   $1d
phase	$4000
  incbin "..\grapx\HeroOverview\StatusWindow.SC5",7,116 * 128      ;116 lines
	ds		$c000-$,$ff
dephase

;
; block $1f - 20
;
SpellBookGraphicsBlock:  equ   $1f
phase	$4000
  incbin "..\grapx\HeroOverview\SpellBook.SC5",7,200 * 128      ;184 lines
	ds		$c000-$,$ff
dephase

;
; block $21 - 22
;
InventoryGraphicsBlock:  equ   $21
phase	$4000
  incbin "..\grapx\HeroOverview\Inventory.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroOverview\InventoryBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $23 - 24
;
ArmyGraphicsBlock:  equ   $23
phase	$4000
  incbin "..\grapx\HeroOverview\Army.SC5",7,130 * 128      ;130 lines
	ds		$c000-$,$ff
dephase

;
; block $25 - 26
;
HeroArmyTransferGraphicsBlock:  equ   $25
phase	$4000
  incbin "..\grapx\HeroOverview\HeroArmyTransfer.SC5",7,137 * 128      ;137 lines
	ds		$c000-$,$ff
dephase

;
; block $27 - 28
;
Hero16x30PortraitsBlock:  equ   $27
phase	$4000
  incbin "..\grapx\HeroesSprites\16x30Portraits.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $29 - 2a
;
Enemy14x24PortraitsBlock:  equ   $29
phase	$4000
  incbin "..\grapx\MonsterSprites\14x24Portraits.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $2b
;
CastleOverviewCodeBlock:  equ   $2b
CastleOverviewFontBlock:  equ   $2b
phase	$4000
  incbin "..\grapx\CastleOverview\font.SC5",7,7 * 128      ;5 lines
  include "CastleOverviewCode.asm"
	ds		$8000-$,$ff
dephase

;
; block $2c - 2d
;
IndividualBuildingsBlock:  equ   $2c
phase	$4000
  incbin "..\grapx\CastleOverview\IndividualBuildings.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $2e - 2f
;
IndividualBuildingsPage2Block:  equ   $2e
phase	$4000
  incbin "..\grapx\CastleOverview\IndividualBuildingsPage2.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $30 - 31
;
ButtonsBlock:  equ   $30
phase	$4000
  incbin "..\grapx\CastleOverview\Buttons.SC5",7,093 * 128      ;093 lines
	ds		$c000-$,$ff
dephase

;
; block $32 - 33
;
BuildBlock:  equ   $32
phase	$4000
  incbin "..\grapx\CastleOverview\build.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $34 - 35
;
ButtonsBuildBlock:  equ   $34
phase	$4000
  incbin "..\grapx\CastleOverview\ButtonsBuild.SC5",7,166 * 128      ;166 lines
	ds		$c000-$,$ff
dephase

;
; block $36 - 37
;
RecruitCreaturesBlock:  equ   $36
phase	$4000
  incbin "..\grapx\CastleOverview\RecruitCreatures.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $38 - 39
;
ButtonsRecruitBlock:  equ   $38
phase	$4000
  incbin "..\grapx\CastleOverview\ButtonsRecruitCreatures.SC5",7,139 * 128      ;139 lines
	ds		$c000-$,$ff
dephase

;
; block $3a - 3b
;
MagicGuildBlock:  equ   $3a
phase	$4000
  incbin "..\grapx\CastleOverview\MagicGuild.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $3c - 3d
;
ChamberOfCommerceBlock:  equ   $3c
phase	$4000
  incbin "..\grapx\CastleOverview\ChamberOfCommerce.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $3e - 3f
;
ChamberOfCommerceButtonsBlock:  equ   $3e
phase	$4000
  incbin "..\grapx\CastleOverview\ButtonsChamberOfCommerce.SC5",7,152 * 128      ;152 lines
	ds		$c000-$,$ff
dephase

;
; block $40 - 41
;
TavernBlock:  equ   $40
phase	$4000
  incbin "..\grapx\CastleOverview\Tavern.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

totallenght:	Equ	$-MSXHeroes
	ds		(8*$80000)-totallenght
