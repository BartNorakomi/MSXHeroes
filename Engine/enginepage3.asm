phase	$c000

StartGame:
  call  LoadWorldTiles                  ;set all world map tiles in page 3
  call  LoadHeroesSprites               ;set all heroes sprites in page 2
  call  LoadHud                         ;load the hud (all the windows and frames and buttons etc) in page 0 and copy it to page 1
  call  LoadWorldMap                    ;unpack the worldmap to $8000 in ram
  call  SpriteInitialize                ;set color, attr and char addresses
  call  SetInterruptHandler             ;set Vblank
  jp    LevelEngine

copyfont:
	db		0,0,155,0
	db		0,0,212,0
	db		0,1,5,0
	db		0,0,$90	
CopyPage0To1:
	db		0,0,0,0
	db		0,0,0,1
	db		0,1,0,1
	db		0,0,$d0	

LoadHud:
  ld    d,HudBlock
  ld    a,0
  ld    hl,$0000                        ;write to page 0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

	ld		hl,copyfont	                    ;put font at (0,212)
	call	docopy
  ld    hl,CopyPage0To1
	call	docopy
  ret

LoadHeroesSprites:
  ld    d,HeroesSpritesBlock
  ld    a,1
  ld    hl,$0000                        ;write to page 2
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram
  ret

LoadWorldTiles:
  ld    d,World1TilesBlock
  ld    a,1
  ld    hl,$8000                        ;write to page 3
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

  ld    hl,World1Palette
  call  SetPalette
  ret

LoadWorldMap:
;unpack map data
  ld    a,(slot.page1rom)             ;all RAM except page 1
  out   ($a8),a      

  ld    a,World1MapBlock              ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    hl,$4000
  ld    de,$8000
  call  Depack
  ret
  
World1Palette:
  incbin"..\grapx\tilesheets\world1tiles.pl"

SetInterruptHandler:
  di
  ld    hl,InterruptHandler 
  ld    ($38+1),hl                      ;set new normal interrupt
  ld    a,$c3                           ;jump command
  ei
  ld    ($38),a
  ret

sprcoladdr:		equ	$7400
sprattaddr:		equ	$7600
sprcharaddr:	equ	$7800
SpriteInitialize:
	ld		a,(vdp_0+1)
	or		2			;sprites 16*16
	di
	out		($99),a
	ld		a,1+128
	ei
	out		($99),a

	ld		a,%1110 1111
	ld		(vdp_0+5),a
	di
;	out		($99),a		                      ;spr att table to $17600
	out		($99),a		                      ;spr att table to $7600
	ld		a,5+128
	out		($99),a
;	ld		a,%0000 0010                    ;spr att table to $17600
	ld		a,%0000 0000                    ;spr att table to $7600
	ld		(vdp_8+3),a
	out		($99),a
	ld		a,11+128
	out		($99),a
	
;	ld		a,%0010 1111
	ld		a,%0000 1111
	ld		(vdp_0+6),a
;	out		($99),a		                      ;spr chr table to $17800
	out		($99),a		                      ;spr chr table to $7800
	ld		a,6+128
	ei
	out		($99),a
	ret

SetPage:                                ;in a->x*32+31 (x=page)
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  ret

block12:	
  di
	ld		(memblocks.1),a
	ld		($6000),a
	ei
	ret

block34:	
  di
	ld		(memblocks.2),a
	ld		($7000),a
	ei
	ret

block1234:	 
  di
	ld		(memblocks.1),a
	ld		($6000),a
	inc   a
	ld		(memblocks.2),a
	ld		($7000),a
	ei
	ret

DoCopy:
  ld    a,32
  di
  out   ($99),a
  ld    a,17+128
  ei
  out   ($99),a
  ld    c,$9b
.vdpready:
  ld    a,2
  di
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)
  rra
  ld    a,0
  out   ($99),a
  ld    a,15+128
  ei
  out   ($99),a
  jr    c,.vdpready

;ld b,15
;otir
;ret

	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed
  ret

copyGraphicsToScreen256:                ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram
	call	SetVdp_Write                    ;start writing to address bhl

  ld    a,d
  call  block1234

	ld		hl,$4000
  ld    c,$98
  ld    a,128                           ;256 lines, copy 128*256 = $4000 bytes to Vram      

  .loop1:
  call  outix256
  dec   a
  jp    nz,.loop1
  ret

copyGraphicsToScreen212:                ;in d=block, ahl=address to write to. This routine writes a set amount of bytes to vram. In this case 212 lines (212 lines * 128 bytes = $6a00 bytes)
	call	SetVdp_Write                    ;start writing to address bhl

  ld    a,d
  call  block12

	ld		hl,$4000
  ld    c,$98
  ld    a,64                            ;first 128 line, copy 64*256 = $4000 bytes to Vram      
  call  .loop1    

  ld    a,d                             ;Graphicsblock
  inc   a
  call  block12
  
	ld		hl,$4000
  ld    a,42                            ;second 84 line, copy 64*256 = $4000 bytes to Vram      
;  call  .loop1   
;  ret

  .loop1:
  call  outix256
  dec   a
  jp    nz,.loop1
  ret

currentpage:                ds  1
sprcoltableaddress:         ds  2
spratttableaddress:         ds  2
sprchatableaddress:         ds  2
invissprcoltableaddress:    ds  2
invisspratttableaddress:    ds  2
invissprchatableaddress:    ds  2

SetPalette:
	xor		a
	di
	out		($99),a
	ld		a,16+128
	out		($99),a
	ld		bc,$209A
	otir
	ei
	ret

;
;Set VDP port #98 to start reading at address AHL (17-bit)
;
SetVdp_Read:  rlc     h
              rla
              rlc     h
              rla
              srl     h
              srl     h
              di
              out     ($99),a           ;set bits 15-17
              ld      a,14+128
              out     ($99),a
              ld      a,l               ;set bits 0-7
;              nop
              out     ($99),a
              ld      a,h               ;set bits 8-14
              ei                        ; + read access
              out     ($99),a
              ret
              
;
;Set VDP port #98 to start writing at address AHL (17-bit)
;
SetVdp_Write: 
;first set register 14 (actually this only needs to be done once
	rlc     h
	rla
	rlc     h
	rla
	srl     h
	srl     h
	di
	out     ($99),a                       ;set bits 15-17
	ld      a,14+128
	out     ($99),a
;/first set register 14 (actually this only needs to be done once

	ld      a,l                           ;set bits 0-7
;	nop
	out     ($99),a
	ld      a,h                           ;set bits 8-14
	or      64                            ; + write access
	ei
	out     ($99),a       
	ret

Depack:                                 ;In: HL: source, DE: destination
	inc	hl		                            ;skip original file length
	inc	hl		                            ;which is stored in 4 bytes
	inc	hl
	inc	hl

	ld	a,128
	
	exx
	ld	de,1
	exx
	
.depack_loop:
	call .getbits
	jr	c,.output_compressed	            ;if set, we got lz77 compression
	ldi				                            ;copy byte from compressed data to destination (literal byte)

	jr	.depack_loop
	
;handle compressed data
.output_compressed:
	ld	c,(hl)		                        ;get lowest 7 bits of offset, plus offset extension bit
	inc	hl		                            ;to next byte in compressed data

.output_match:
	ld	b,0
	bit	7,c
	jr	z,.output_match1	                ;no need to get extra bits if carry not set

	call .getbits
	call .rlbgetbits
	call .rlbgetbits
	call .rlbgetbits

	jr	c,.output_match1	                ;since extension mark already makes bit 7 set 
	res	7,c		                            ;only clear it if the bit should be cleared
.output_match1:
	inc	bc
	
;return a gamma-encoded value
;length returned in HL
	exx			                              ;to second register set!
	ld	h,d
	ld	l,e                               ;initial length to 1
	ld	b,e		                            ;bitcount to 1

;determine number of bits used to encode value
.get_gamma_value_size:
	exx
	call .getbits
	exx
	jr	nc,.get_gamma_value_size_end	    ;if bit not set, bitlength of remaining is known
	inc	b				                          ;increase bitcount
	jr	.get_gamma_value_size		          ;repeat...

.get_gamma_value_bits:
	exx
	call .getbits
	exx
	
	adc	hl,hl				                      ;insert new bit in HL
.get_gamma_value_size_end:
	djnz	.get_gamma_value_bits		        ;repeat if more bits to go

.get_gamma_value_end:
	inc	hl		                            ;length was stored as length-2 so correct this
	exx			                              ;back to normal register set
	
	ret	c
;HL' = length

	push	hl		                          ;address compressed data on stack

	exx
	push	hl		                          ;match length on stack
	exx

	ld	h,d
	ld	l,e		                            ;destination address in HL...
	sbc	hl,bc		                          ;calculate source address

	pop	bc		                            ;match length from stack

	ldir			                            ;transfer data

	pop	hl		                            ;address compressed data back from stack

	jr	.depack_loop

.rlbgetbits:
	rl b
.getbits:
	add	a,a
	ret	nz
	ld	a,(hl)
	inc	hl
	rla
	ret    

;DoubleTapCounter:         db  1
freezecontrols?:          db  0
;
; bit	7	  6	  5		    4		    3		    2		  1		  0
;		  0	  0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  F5	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
PopulateControls:	
  ld    a,(freezecontrols?)
  or    a
  jp    nz,.freezecontrols

;	ld		a,(NewPrContr)
;	ld		(NewPrContrOld),a
	
	ld		a,15		                        ; select joystick port 1
	di
	out		($a0),a
	ld		a,$8f
	out		($a1),a
	ld		a,14		                        ; read joystick data
	out		($a0),a
	ei
	in		a,($a2)
	cpl
	and		$3f			                        ; 00BARLDU
	ld		c,a

	ld		de,$04F0
	
	in		a,($aa)
	and		e
	or		6
	out		($aa),a
	in		a,($a9)
	cpl
	and		$20			                        ; 'F1' key
	rlca				                          ; 01000000
	or		c
	ld		c,a			                        ; 01BARLDU
	
	in		a,($aa)	                        ; M = B-trigger
	and		e
	or		d
	out		($aa),a
	in		a,($a9)
	cpl
	and		d			                          ; xxxxxBxx
	ld		b,a
	in		a,($aa)
	and		e
	or		8
	out		($aa),a
	in		a,($a9)
	cpl					                          ; RDULxxxA
	and		$F1		                          ; RDUL000A
	rlca				                          ; DUL000AR
	or		b			                          ; DUL00BAR
	rla					                          ; UL00BAR0
	rla					                          ; L00BAR0D
	rla					                          ; 00BAR0DU
	ld		b,a
	rla					                          ; 0BAR0DUL
	rla					                          ; BAR0DUL0
	rla					                          ; AR0DUL00
	and		d			                          ; 00000L00
	or		b			                          ; 00BARLDU
	or		c			                          ; 51BARLDU
	
	ld		b,a
	ld		hl,Controls
	ld		a,(hl)
	xor		b
	and		b
	ld		(NewPrContr),a
	ld		(hl),b

;  ld    a,(DoubleTapCounter)
;  dec   a
;  ret   z	
;  ld    (DoubleTapCounter),a
	ret

.freezecontrols:
  xor   a
	ld		(Controls),a
	ld		(NewPrContr),a
  ret

outix384:
  call  outix256
  jp    outix128
outix352:
  call  outix256
  jp    outix96
outix320:
  call  outix256
  jp    outix64
outix288:
  call  outix256
  jp    outix32
outix256:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix250:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix224:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix208:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix192:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi
outix176:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix160:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix144:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix128:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix112:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix96:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix80:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi
outix64:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix48:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix32:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix16:	
	outi	outi	outi	outi	outi	outi	outi	outi
outix8:	
	outi	outi	outi	outi	outi	outi	outi	outi	
	ret	

endenginepage3:
dephase
enginepage3length:	Equ	$-enginepage3

variables: org $c000+enginepage3length
slot:						
.ram:		                    equ	  $e000
.page1rom:	                equ	  slot.ram+1
.page2rom:	                equ	  slot.ram+2
.page12rom:	                equ	  slot.ram+3
memblocks:
.1:			                    equ	  slot.ram+4
.2:			                    equ	  slot.ram+5
.3:			                    equ	  slot.ram+6
.4:			                    equ	  slot.ram+7	
VDP_0:		                  equ   $F3DF
VDP_8:		                  equ   $FFE7
engaddr:	                  equ	  $03e
loader.address:             equ   $8000
enginepage3addr:            equ   $c000

sx:                         equ   0
sy:                         equ   2
spage:                      equ   3
dx:                         equ   4
dy:                         equ   6
dpage:                      equ   7 
nx:                         equ   8
ny:                         equ   10
clr:                        equ   12
copydirection:              equ   13
copytype:                   equ   14

framecounter:               rb    1

Controls:	                  rb		1
NewPrContr:	                rb		1
oldControls: 				        rb    1

endenginepage3variables:  equ $+enginepage3length
org variables

