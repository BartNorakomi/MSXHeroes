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

  ld    a,($180)    ;$c3 = turbo on
  ld    (TurboOn?),a

;  ld    a,%1000 0001
;  ld		ix,$180     ;CHGCPU: A = LED 0 0 0 0 0 x x | ;%000 0000 = Z80 (ROM) mode, %0000 0001 = R800 ROM  mode, %0000 0010 = R800 DRAM mode
;  call	$15F

;  ld		ix,$183     ;GETCPU: Returns current CPU mode, Output   : A = 0 0 0 0 0 0 x x                           
;  call	$15F
;  ld		(CPUMode),a ;%000 0000 = Z80 (ROM) mode, %0000 0001 = R800 ROM  mode, %0000 0010 = R800 DRAM mode

  ld		a,($2d)			;3=turbo r, 2=msx2+, 1=msx2, 0=msx1
  ld		(ComputerID),a

;let's copy the copies of the vdp registers to our addresses of choice
  ld    hl,$F3DF
  ld    de,VDP_0
  ld    bc,8
  ldir

  ld    hl,$FFE7
  ld    de,VDP_8
  ld    bc,30
  ldir
;/let's copy the copies of the vdp registers to our addresses of choice
  ld    sp,$fd00
;/then we can set our stack pointer a bit higher, reserving more free space in page 3

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
	include	"loader.asm"	
endLoader:
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
World2MapBlock:  equ   $05
World2ObjectLayerMapBlock:  equ   $05
World3MapBlock:  equ   $05
World3ObjectLayerMapBlock:  equ   $05
World4MapBlock:  equ   $05
World4ObjectLayerMapBlock:  equ   $05
World5MapBlock:  equ   $05
World5ObjectLayerMapBlock:  equ   $05
World6MapBlock:  equ   $05
World6ObjectLayerMapBlock:  equ   $05
World7MapBlock:  equ   $05
World7ObjectLayerMapBlock:  equ   $05
World8MapBlock:  equ   $05
World8ObjectLayerMapBlock:  equ   $05

phase	$4000
World1Map:
  incbin "..\maps\world1.map.pck"
World1ObjectLayerMap:
  incbin "..\maps\world1objects.map.pck"
World2Map:
  incbin "..\maps\world2.map.pck"
World2ObjectLayerMap:
  incbin "..\maps\world2objects.map.pck"
World3Map:
  incbin "..\maps\world3.map.pck"
World3ObjectLayerMap:
  incbin "..\maps\world3objects.map.pck"
World4Map:
  incbin "..\maps\world4.map.pck"
World4ObjectLayerMap:
  incbin "..\maps\world4objects.map.pck"
World5Map:
  incbin "..\maps\world5.map.pck"
World5ObjectLayerMap:
  incbin "..\maps\world5objects.map.pck"
World6Map:
  incbin "..\maps\world6.map.pck"
World6ObjectLayerMap:
  incbin "..\maps\world6objects.map.pck"
World7Map:
  incbin "..\maps\world7.map.pck"
World7ObjectLayerMap:
  incbin "..\maps\world7objects.map.pck"
World8Map:
  incbin "..\maps\world8.map.pck"
World8ObjectLayerMap:
  incbin "..\maps\world8objects.map.pck"
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

UltraBoxSpriteBlock:          equ HeroesSpritesBlock5
LoganSeriosSpriteBlock:       equ HeroesSpritesBlock5
HollyWhiteSpriteBlock:        equ HeroesSpritesBlock5
MerciesSpriteBlock:           equ HeroesSpritesBlock5
NatashaRomanenkoSpriteBlock:  equ HeroesSpritesBlock5
RuthSpriteBlock:              equ HeroesSpritesBlock5
GeeraSpriteBlock:             equ HeroesSpritesBlock5
YoungNobleSpriteBlock:        equ HeroesSpritesBlock5

DawelSpriteBlock:             equ HeroesSpritesBlock6
PockySpriteBlock:             equ HeroesSpritesBlock6
KelesisTheCookSpriteBlock:    equ HeroesSpritesBlock6
LoloSpriteBlock:              equ HeroesSpritesBlock6
PippolsSpriteBlock:           equ HeroesSpritesBlock6
RandarSpriteBlock:            equ HeroesSpritesBlock6
ClesSpriteBlock:              equ HeroesSpritesBlock6
LuiceSpriteBlock:              equ HeroesSpritesBlock6

DickSpriteBlock:              equ HeroesSpritesBlock7
AphroditeSpriteBlock:         equ HeroesSpritesBlock7
TienRenSpriteBlock:           equ HeroesSpritesBlock7
PopolonSpriteBlock:           equ HeroesSpritesBlock7
HoMeiSpriteBlock:             equ HeroesSpritesBlock7
PriestessKiSpriteBlock:       equ HeroesSpritesBlock7
MeiHongSpriteBlock:           equ HeroesSpritesBlock7
PrinceGilgameshSpriteBlock:   equ HeroesSpritesBlock7

RandomHajileSpriteBlock:      equ HeroesSpritesBlock8
BensonCunninghamSpriteBlock:  equ HeroesSpritesBlock8
JamieSeedSpriteBlock:         equ HeroesSpritesBlock8
ArmoredSnatcherSpriteBlock:   equ HeroesSpritesBlock8
DruidSpriteBlock:             equ HeroesSpritesBlock8



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
HeroesSpritesBlock5:  equ   HeroesSpritesBlock1 + 4
HeroesSpritesBlock6:  equ   HeroesSpritesBlock1 + 5
phase	$4000
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet3.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet3Bottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $0c - 0d
;
HeroesSpritesBlock7:  equ   HeroesSpritesBlock1 + 6
HeroesSpritesBlock8:  equ   HeroesSpritesBlock1 + 7
phase	$4000
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet4.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroesSprites\HeroesSpritesSheet4Bottom48Lines.SC5",7,48 * 128 ;48 lines
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
Hero20x11PortraitsBlock:  equ   $14
phase	$4000
  incbin "..\grapx\HeroesSprites\20x11Portraits.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\HeroesSprites\20x11PortraitsBottom48lines.SC5",7,048 * 128      ;048 lines
	ds		$c000-$,$ff
dephase

;
; block $16 - 17
;
;HudBlock:  equ   $16
phase	$4000
;  incbin "..\grapx\hud\hud.SC5",7,208 * 128      ;208 lines
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
  incbin "..\grapx\HeroOverview\Army.SC5",7,133 * 128      ;133 lines
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
  incbin "..\grapx\MonsterSprites\14x24Portraits.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\14x24PortraitsBottom48lines.SC5",7,048 * 128      ;048 lines
	ds		$c000-$,$ff
dephase

;
; block $2b
;
	ds		$4000

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
  incbin "..\grapx\CastleOverview\MagicGuildCastlePalette.SC5",7,25 * 128      ;212 lines
  incbin "..\grapx\CastleOverview\MagicGuild.SC5",25 * 128 + 7,154 * 128      ;212 lines
  incbin "..\grapx\CastleOverview\MagicGuildCastlePalette.SC5",179 * 128 + 7,33 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $3c - 3d
;
ChamberOfCommerceBlock:  equ   $3c
phase	$4000
  incbin "..\grapx\CastleOverview\ChamberOfCommerce.SC5",7,80 * 128      ;212 lines
  incbin "..\grapx\CastleOverview\ChamberOfCommerceCastlePalette.SC5",80 * 128 + 7,132 * 128      ;212 lines
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
  incbin "..\grapx\CastleOverview\Tavern.SC5",7,131 * 128      ;212 lines
  incbin "..\grapx\CastleOverview\TavernCastlePalette.SC5",131 * 128 + 7,32 * 128      ;212 lines
  incbin "..\grapx\CastleOverview\Tavern.SC5",163 * 128 + 7,049 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $42 - 43
;
CastleOverviewCodeBlock:  equ   $42
CastleOverviewFontBlock:  equ   $42
phase	$4000
  incbin "..\grapx\CastleOverview\font.SC5",7,6 * 128      ;6 lines
  include "CastleOverviewCode.asm"
	ds		$c000-$,$ff
dephase

;
; block $44 - 45
;
PlayerStartTurnBlock:  equ   $44
phase	$4000
  incbin "..\grapx\HeroOverview\PlayerStartTurnWindow.SC5",7,95 * 128      ;95 lines
	ds		$c000-$,$ff
dephase

;
; block $46 - 47
;
ScrollBlock:  equ   $46
phase	$4000
  incbin "..\grapx\ObjectsOnMap\Scroll.SC5",7,162 * 128      ;162 lines
	ds		$c000-$,$ff
dephase

;
; block $48 - 49
;
ChestBlock:  equ   $48
phase	$4000
  incbin "..\grapx\ObjectsOnMap\Chest.SC5",7,174 * 128      ;174 lines
	ds		$c000-$,$ff
dephase

;
; block $4a - 4b
;
LevelUpBlock:  equ   $4a
phase	$4000
  incbin "..\grapx\HeroOverview\LevelUp.SC5",7,173 * 128      ;148 lines
	ds		$c000-$,$ff
dephase

;
; block $4c - 4d
;
HudNewBlock:  equ   $4c
phase	$4000
  incbin "..\grapx\hud\HudNew.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $4e - 4f
;
SecondarySkillsButtonsBlock:  equ   $4e
phase	$4000
  incbin "..\grapx\HeroOverview\SecondarySkillsButtons.SC5",7,165 * 128      ;165 lines
	ds		$c000-$,$ff
dephase

; block $50
BattleCodeBlock:  equ   $50
phase	$4000
  include "BattleCode.asm"
	ds		$8000-$,$ff
dephase

; block $51
BattleCodePage2Block:  equ   $51
phase	$8000
  include "BattleCodePage2.asm"
	ds		$c000-$,$ff
dephase

;
; block $52 - 53
;
BattleFieldObjectsBlock:  equ   $52
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleFieldObjects.SC5",7,212 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $54
;
MonsterAddressesForBattle1Block:  equ   $54
phase	$8000
	include	"MonsterAddressesForBattle1.asm"	
	ds		$c000-$,$ff
dephase

;
; block $55 - 56
;
BattleMonsterSpriteSheet1Block:  equ   $55
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet1.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet1Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $57 - 58
;
BattleMonsterSpriteSheet2Block:  equ   $57
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet2.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet2Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $59 - 5a
;
BattleMonsterSpriteSheet3Block:  equ   $59
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet3.SC5",7,208 * 128      ;212 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet3Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $5b - 5c
;
BattleMonsterSpriteSheet4Block:  equ   $5b
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet4.SC5",7,208 * 128      ;212 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet4Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $5d - 5e
;
BattleMonsterSpriteSheet5Block:  equ   $5d
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet5.SC5",7,208 * 128      ;212 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet5Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $5f - 60
;
BattleMonsterSpriteSheet6Block:  equ   $5f
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet6.SC5",7,208 * 128      ;212 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet6Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $61 - 62
;
BattleMonsterSpriteSheet7Block:  equ   $61
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet7.SC5",7,208 * 128      ;212 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet7Bottom48Lines.SC5",7,048 * 128 
	ds		$c000-$,$ff
dephase

;
; block $63 - 64
;
BattleMonsterSpriteSheet8Block:  equ   $63
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $65 - 66
;
phase	$4000
	ds		$c000-$,$ff
dephase

;
; block $67 - 68
;
VictoryBlock:  equ   $67
phase	$4000
  incbin "..\grapx\Battlefield\Victory.SC5",7,207 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $69 - 6a
;
DefeatBlock:  equ   $69
phase	$4000
  incbin "..\grapx\Battlefield\Defeat.SC5",7,207 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $6b - 6c
;
RetreatBlock:  equ   $6b
phase	$4000
  incbin "..\grapx\Battlefield\Retreat.SC5",7,117 * 128      ;212 lines
	ds		$c000-$,$ff
dephase

;
; block $6d - 6e
;
BattleMonsterSpriteSheet9Block:  equ   $6d
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet9.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet9Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $6f - 70
;
BattleMonsterSpriteSheet10Block:  equ   $6f
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet10.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet10Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $71 - 72
;
BattleMonsterSpriteSheet11Block:  equ   $71
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet11.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet11Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $73 - 74
;
BattleMonsterSpriteSheet12Block:  equ   $73
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet12.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet12Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $75 - 76
;
BattleMonsterSpriteSheet13Block:  equ   $75
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet13.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet13Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $77 - 78
;
BattleMonsterSpriteSheet14Block:  equ   $77
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet14.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet14Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $79 - 7a
;
BattleMonsterSpriteSheet15Block:  equ   $79
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet15.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet15Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $7b - 7c
;
BattleMonsterSpriteSheet16Block:  equ   $7b
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $7d - 7e
;
BattleMonsterSpriteSheet17Block:  equ   $7d
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $7f - 80
;
BattleMonsterSpriteSheet18Block:  equ   $7f
phase	$4000
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\MonsterSprites\BattleMonstersSpriteSheet8Bottom48Lines.SC5",7,048 * 128      ;208 lines
	ds		$c000-$,$ff
dephase

;
; block $81 - 82
;
CastleOverviewBlock:  equ   $81
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
; block $83 - 84
;
RecruitCreatures4MonstersBlock:  equ   $83
phase	$4000
  incbin "..\grapx\CastleOverview\RecruitCreaturesMonster1.SC5",7,30 * 128      ;30 lines
  incbin "..\grapx\CastleOverview\RecruitCreaturesMonster2.SC5",7,30 * 128      ;30 lines
  incbin "..\grapx\CastleOverview\RecruitCreaturesMonster3.SC5",7,30 * 128      ;30 lines
  incbin "..\grapx\CastleOverview\RecruitCreaturesMonster4.SC5",7,30 * 128      ;30 lines
	ds		$c000-$,$ff
dephase

;
; block $85 - 86
;
TilesSdSnatcherBlock:  equ   $85
phase	$4000
  incbin "..\grapx\tilesheets\TilesSDSnatcher.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesSDSnatcherBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $87 - 88
;
TilesSolidSnakeBlock:  equ   $87
phase	$4000
  incbin "..\grapx\tilesheets\TilesSolidSnake.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesSolidSnakeBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $89
;
World9MapBlock:  equ   $89
World9ObjectLayerMapBlock:  equ   $89
World10MapBlock:  equ   $89
World10ObjectLayerMapBlock:  equ   $89
World11MapBlock:  equ   $89
World11ObjectLayerMapBlock:  equ   $89
World12MapBlock:  equ   $89
World12ObjectLayerMapBlock:  equ   $89
World13MapBlock:  equ   $89
World13ObjectLayerMapBlock:  equ   $89
World14MapBlock:  equ   $89
World14ObjectLayerMapBlock:  equ   $89
GentleMap01MapBlock:  equ   $89
GentleMap01ObjectLayerMapBlock:  equ   $89
phase	$4000
World9Map:
  incbin "..\maps\world9.map.pck"
World9ObjectLayerMap:
  incbin "..\maps\world9objects.map.pck"
World10Map:
  incbin "..\maps\world10.map.pck"
World10ObjectLayerMap:
  incbin "..\maps\world10objects.map.pck"
World11Map:
  incbin "..\maps\world11.map.pck"
World11ObjectLayerMap:
  incbin "..\maps\world11objects.map.pck"
World12Map:
  incbin "..\maps\world12.map.pck"
World12ObjectLayerMap:
  incbin "..\maps\world12objects.map.pck"
World13Map:
  incbin "..\maps\world13.map.pck"
World13ObjectLayerMap:
  incbin "..\maps\world13objects.map.pck"
World14Map:
  incbin "..\maps\world14.map.pck"
World14ObjectLayerMap:
  incbin "..\maps\world14objects.map.pck"
  
GentleMap01Map:
  incbin "..\maps\GentleMap01.map.pck"
GentleMap01ObjectLayerMap:
  incbin "..\maps\GentleMap01objects.map.pck"
	ds		$8000-$,$ff
dephase

;
; block $8a - 8b
;
TilesGentleBlock:  equ   $8a
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentle.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $8c - 8d
;
TilesGentleDesertBlock:  equ   $8c
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentleDesert.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleDesertBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $8e - 8f
;
TilesGentleAutumnBlock:  equ   $8e
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentleAutumn.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleAutumnBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $90 - 91
;
TilesGentleWinterBlock:  equ   $90
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentleWinter.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleWinterBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $92 - 93
;
TilesGentleJungleBlock:  equ   $92
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentleJungle.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleJungleBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase

;
; block $94 - 95
;
TilesGentleCaveBlock:  equ   $94
phase	$4000
  incbin "..\grapx\tilesheets\TilesGentleCave.SC5",7,208 * 128      ;208 lines
  incbin "..\grapx\tilesheets\TilesGentleCaveBottom48Lines.SC5",7,48 * 128 ;48 lines
	ds		$c000-$,$ff
dephase



;
; block $96
;
GentleDesertMap01MapBlock:  equ   $96
GentleDesertMap01ObjectLayerMapBlock:  equ   $96
GentleDesertMap02MapBlock:  equ   $96
GentleDesertMap02ObjectLayerMapBlock:  equ   $96
GentleDesertMap03MapBlock:  equ   $96
GentleDesertMap03ObjectLayerMapBlock:  equ   $96
GentleDesertMap04MapBlock:  equ   $96
GentleDesertMap04ObjectLayerMapBlock:  equ   $96
GentleDesertMap05MapBlock:  equ   $96
GentleDesertMap05ObjectLayerMapBlock:  equ   $96

phase	$4000
GentleDesertMap01Map:
  incbin "..\maps\GentleDesertMap01.map.pck"
GentleDesertMap01ObjectLayerMap:
  incbin "..\maps\GentleDesertMap01objects.map.pck"
GentleDesertMap02Map:
  incbin "..\maps\GentleDesertMap02.map.pck"
GentleDesertMap02ObjectLayerMap:
  incbin "..\maps\GentleDesertMap02objects.map.pck"
GentleDesertMap03Map:
  incbin "..\maps\GentleDesertMap03.map.pck"
GentleDesertMap03ObjectLayerMap:
  incbin "..\maps\GentleDesertMap03objects.map.pck"
GentleDesertMap04Map:
  incbin "..\maps\GentleDesertMap04.map.pck"
GentleDesertMap04ObjectLayerMap:
  incbin "..\maps\GentleDesertMap04objects.map.pck"
GentleDesertMap05Map:
  incbin "..\maps\GentleDesertMap05.map.pck"
GentleDesertMap05ObjectLayerMap:
  incbin "..\maps\GentleDesertMap05objects.map.pck"
	ds		$8000-$,$ff
dephase



;
; block $97
;
GentleWinterMap01MapBlock:  equ   $97
GentleWinterMap01ObjectLayerMapBlock:  equ   $97
GentleWinterMap02MapBlock:  equ   $97
GentleWinterMap02ObjectLayerMapBlock:  equ   $97
GentleWinterMap03MapBlock:  equ   $97
GentleWinterMap03ObjectLayerMapBlock:  equ   $97
GentleWinterMap04MapBlock:  equ   $97
GentleWinterMap04ObjectLayerMapBlock:  equ   $97

phase	$4000
GentleWinterMap01Map:
  incbin "..\maps\GentleWinterMap01.map.pck"
GentleWinterMap01ObjectLayerMap:
  incbin "..\maps\GentleWinterMap01objects.map.pck"
GentleWinterMap02Map:
  incbin "..\maps\GentleWinterMap02.map.pck"
GentleWinterMap02ObjectLayerMap:
  incbin "..\maps\GentleWinterMap02objects.map.pck"
GentleWinterMap03Map:
  incbin "..\maps\GentleWinterMap03.map.pck"
GentleWinterMap03ObjectLayerMap:
  incbin "..\maps\GentleWinterMap03objects.map.pck"
GentleWinterMap04Map:
  incbin "..\maps\GentleWinterMap04.map.pck"
GentleWinterMap04ObjectLayerMap:
  incbin "..\maps\GentleWinterMap04objects.map.pck"
	ds		$8000-$,$ff
dephase

;
; block $98
;
GentleWinterMap05MapBlock:  equ   $98
GentleWinterMap05ObjectLayerMapBlock:  equ   $98

phase	$4000
GentleWinterMap05Map:
  incbin "..\maps\GentleWinterMap05.map.pck"
GentleWinterMap05ObjectLayerMap:
  incbin "..\maps\GentleWinterMap05objects.map.pck"
	ds		$8000-$,$ff
dephase

;
; block $99
;
GentleJungleMap01MapBlock:  equ   $99
GentleJungleMap01ObjectLayerMapBlock:  equ   $99
GentleJungleMap02MapBlock:  equ   $99
GentleJungleMap02ObjectLayerMapBlock:  equ   $99
GentleJungleMap03MapBlock:  equ   $99
GentleJungleMap03ObjectLayerMapBlock:  equ   $99

phase	$4000
GentleJungleMap01Map:
  incbin "..\maps\GentleJungleMap01.map.pck"
GentleJungleMap01ObjectLayerMap:
  incbin "..\maps\GentleJungleMap01objects.map.pck"
GentleJungleMap02Map:
  incbin "..\maps\GentleJungleMap02.map.pck"
GentleJungleMap02ObjectLayerMap:
  incbin "..\maps\GentleJungleMap02objects.map.pck"
GentleJungleMap03Map:
  incbin "..\maps\GentleJungleMap03.map.pck"
GentleJungleMap03ObjectLayerMap:
  incbin "..\maps\GentleJungleMap03objects.map.pck"
	ds		$8000-$,$ff
dephase

;
; block $9a
;
GentleJungleMap04MapBlock:  equ   $9a
GentleJungleMap04ObjectLayerMapBlock:  equ   $9a
GentleJungleMap05MapBlock:  equ   $9a
GentleJungleMap05ObjectLayerMapBlock:  equ   $9a

phase	$4000
GentleJungleMap04Map:
  incbin "..\maps\GentleJungleMap04.map.pck"
GentleJungleMap04ObjectLayerMap:
  incbin "..\maps\GentleJungleMap04objects.map.pck"
GentleJungleMap05Map:
  incbin "..\maps\GentleJungleMap05.map.pck"
GentleJungleMap05ObjectLayerMap:
  incbin "..\maps\GentleJungleMap05objects.map.pck"
	ds		$8000-$,$ff
dephase

;
; block $9b
;
GentleAutumnMap01MapBlock:  equ   $9b
GentleAutumnMap01ObjectLayerMapBlock:  equ   $9b
GentleAutumnMap02MapBlock:  equ   $9b
GentleAutumnMap02ObjectLayerMapBlock:  equ   $9b
GentleAutumnMap03MapBlock:  equ   $9b
GentleAutumnMap03ObjectLayerMapBlock:  equ   $9b
GentleAutumnMap04MapBlock:  equ   $9b
GentleAutumnMap04ObjectLayerMapBlock:  equ   $9b

phase	$4000
GentleAutumnMap01Map:
  incbin "..\maps\GentleAutumnMap01.map.pck"
GentleAutumnMap01ObjectLayerMap:
  incbin "..\maps\GentleAutumnMap01objects.map.pck"
GentleAutumnMap02Map:
  incbin "..\maps\GentleAutumnMap02.map.pck"
GentleAutumnMap02ObjectLayerMap:
  incbin "..\maps\GentleAutumnMap02objects.map.pck"
GentleAutumnMap03Map:
  incbin "..\maps\GentleAutumnMap03.map.pck"
GentleAutumnMap03ObjectLayerMap:
  incbin "..\maps\GentleAutumnMap03objects.map.pck"
GentleAutumnMap04Map:
  incbin "..\maps\GentleAutumnMap04.map.pck"
GentleAutumnMap04ObjectLayerMap:
  incbin "..\maps\GentleAutumnMap04objects.map.pck"
	ds		$8000-$,$ff
dephase


;
; block $9c
;
GentleAutumnMap05MapBlock:  equ   $9c
GentleAutumnMap05ObjectLayerMapBlock:  equ   $9c

phase	$4000
GentleAutumnMap05Map:
  incbin "..\maps\GentleAutumnMap05.map.pck"
GentleAutumnMap05ObjectLayerMap:
  incbin "..\maps\GentleAutumnMap05objects.map.pck"
	ds		$8000-$,$ff
dephase



;
; block $9d
;
GentleCaveMap01MapBlock:  equ   $9d
GentleCaveMap01ObjectLayerMapBlock:  equ   $9d
GentleCaveMap02MapBlock:  equ   $9d
GentleCaveMap02ObjectLayerMapBlock:  equ   $9d
GentleCaveMap03MapBlock:  equ   $9d
GentleCaveMap03ObjectLayerMapBlock:  equ   $9d
GentleCaveMap04MapBlock:  equ   $9d
GentleCaveMap04ObjectLayerMapBlock:  equ   $9d

phase	$4000
GentleCaveMap01Map:
  incbin "..\maps\GentleCaveMap01.map.pck"
GentleCaveMap01ObjectLayerMap:
  incbin "..\maps\GentleCaveMap01objects.map.pck"
GentleCaveMap02Map:
  incbin "..\maps\GentleCaveMap02.map.pck"
GentleCaveMap02ObjectLayerMap:
  incbin "..\maps\GentleCaveMap02objects.map.pck"
GentleCaveMap03Map:
  incbin "..\maps\GentleCaveMap03.map.pck"
GentleCaveMap03ObjectLayerMap:
  incbin "..\maps\GentleCaveMap03objects.map.pck"
GentleCaveMap04Map:
  incbin "..\maps\GentleCaveMap04.map.pck"
GentleCaveMap04ObjectLayerMap:
  incbin "..\maps\GentleCaveMap04objects.map.pck"
kut:
	ds		$8000-$,$ff
dephase


totallenght:	Equ	$-MSXHeroes
	ds		(8*$80000)-totallenght
