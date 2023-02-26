LevelEngine:



;Routines starting at lineint:
;  xor   a                         ;wait for lineint flag to be set. It's better (for now) to put the VRAM objects directly after the lineint
;  ld    hl,lineintflag
;;  ld    (hl),a
;.checkflag1:
;  cp    (hl)
;  jr    z,.checkflag1


  call  PopulateControls
;  call  FadeOutScreenEdges        ;routine that fades out the screen the closer you are to the edges

  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a

  xor   a
  ld    hl,vblankintflag
.checkflag:
  cp    (hl)
  jr    z,.checkflag
  ld    (hl),a  
;  ld    (lineintflag),a
  jp    LevelEngine


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

FreeToUseFastCopy:                    ;freely usable anywhere
  db    000,000,000,000   ;sx,--,sy,spage
  db    000,000,074,000   ;dx,--,dy,dpage
  db    004,000,004,000   ;nx,--,ny,--
  db    000,%0000 0000,$D0       ;fast copy -> Copy from right to left     

FreeToUseFastCopy2:                   ;freely usable anywhere
  db    000,000,000,000   ;sx,--,sy,spage
  db    000,000,000,000   ;dx,--,dy,dpage
  db    000,000,000,000   ;nx,--,ny,--
  db    000,%0000 0000,$D0       ;fast copy -> Copy from right to left     

FreeToUseFastCopy3:                   ;freely usable anywhere
  db    000,000,000,000   ;sx,--,sy,spage
  db    000,000,000,000   ;dx,--,dy,dpage
  db    000,000,000,000   ;nx,--,ny,--
  db    000,%0000 0000,$D0       ;fast copy -> Copy from right to left     







DisableLineint:
  di
  
; set temp ISR
;	ld		hl,tempisr2
;	ld		de,$38
;	ld		bc,6
;	ldir

;  ld    hl,InterruptHandlerLoader
;  ld    ($38+1),hl          ;set new normal interrupt
;  ld    a,$c3               ;jump command
;  ld    ($38),a


  xor   a                 ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  
  ld    a,(vdp_0)           ;set ei1
  and   %1110 1111          ;ei1 checks for lineint and vblankint
  ld    (vdp_0),a           ;ei0 (which is default at boot) only checks vblankint
;  di
  out   ($99),a
  ld    a,128
;  ei
  out   ($99),a

  xor   a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a

  xor   a
  out   ($99),a
  ld    a,23+128            ;set r#23 height
  out   ($99),a
  ei
  ret

tempisr2:	
	push	af
	in		a,($99)             ;check and acknowledge vblank int (ei0 is set)

	pop		af
	ei	
	ret  
























vblankintflag:  db  0
lineintflag:  db  0
InterruptHandler:
  push  af
  
  ld    a,1               ;set s#1
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)           ;check and acknowledge line interrupt
  rrca
  jp    c,lineint         ;ScoreboardSplit/BorderMaskingSplit
  
  xor   a                 ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)           ;check and acknowledge vblank interrupt
  rlca
  jp    c,vblank          ;vblank detected, so jp to that routine
 
  pop   af 
  ei
  ret

;we set horizontal and vertical screen adjust
;we set status register 0
vblank:



;  xor   a                  ;set s#15 to 0 / Warning. Interrupts should end in Status Register 15=0 (normally)
;  out   ($99),a            ;we don't do this to save time, but it's not a good practise
;  ld    a,15+128           ;we do set to s#15 to 0 when mapExit is found and a new map is loaded
;  out   ($99),a
       
;  ld    a,1                   ;vblank flag gets set
  ld    (vblankintflag),a  

  pop   af 
  ei
  ret


  
LineInt:



  xor   a                 ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a

  ld    (lineintflag),a   ;lineine flag gets set

  pop   af 
  ei
  ret  



ScreenOff:
  ld    a,(VDP_0+1)       ;screen off
  and   %1011 1111
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

ScreenOn:
  ld    a,(VDP_0+1)       ;screen on
  or    %0100 0000
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

spat:						;sprite attribute table (y,x 32 sprites)
	ds    32*2,0

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