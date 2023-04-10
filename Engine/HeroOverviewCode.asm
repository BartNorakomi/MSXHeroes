HeroOverViewFirstWindowchoicesSX:   equ 000
HeroOverViewFirstWindowchoicesSY:   equ 000
HeroOverViewFirstWindowchoicesDX:   equ 058
HeroOverViewFirstWindowchoicesDY:   equ 037
HeroOverViewFirstWindowchoicesNX:   equ 088
HeroOverViewFirstWindowchoicesNY:   equ 122

HeroOverViewFirstWindowHightlightOption1SX:   equ 008
HeroOverViewFirstWindowHightlightOption1SY:   equ 133
HeroOverViewFirstWindowHightlightOption1DX:   equ HeroOverViewFirstWindowchoicesDX + 008
HeroOverViewFirstWindowHightlightOption1DY:   equ HeroOverViewFirstWindowchoicesDY + 047
HeroOverViewFirstWindowHightlightOption1NX:   equ 072
HeroOverViewFirstWindowHightlightOption1NY:   equ 011

HeroOverviewCode:
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page

  .engine:
  call  SwapAndSetPage                  ;swap and set page  
  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    iy,ButtonTableSYSX
  call  CheckStatusButtons_FirstWindow

  halt
  jp  .engine

;HeroOverviewWindowButtonY:      equ 0
;HeroOverviewWindowButtonX:      equ 1
;HeroOverviewWindowButtonStatus: equ 2
;HeroOverviewFirstWindowButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
;  db  HeroOverViewFirstWindowchoicesDY + 047, HeroOverViewFirstWindowchoicesDX + 008, %1000 0000
;  db  HeroOverViewFirstWindowchoicesDY + 061, HeroOverViewFirstWindowchoicesDX + 008, %0100 0011
;  db  HeroOverViewFirstWindowchoicesDY + 075, HeroOverViewFirstWindowchoicesDX + 008, %0010 0011
;  db  HeroOverViewFirstWindowchoicesDY + 089, HeroOverViewFirstWindowchoicesDX + 008, %0100 0011
;  db  HeroOverViewFirstWindowchoicesDY + 103, HeroOverViewFirstWindowchoicesDX + 008, %1000 0011

CheckStatusButtons_FirstWindow:
  ld    b,5                             ;amount of buttons

  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,ButtonTableLenght
  add   ix,de
  djnz  .loop
  ret

  .Setbutton:
  bit   0,(ix+HeroOverviewWindowButtonStatus)
  jr    nz,.bit0isSet
  bit   1,(ix+HeroOverviewWindowButtonStatus)
  ret   z
  
  .bit1isSet:
  res   1,(ix+HeroOverviewWindowButtonStatus)
  jr    .goCopyButton
  .bit0isSet:
  res   0,(ix+HeroOverviewWindowButtonStatus)  
  .goCopyButton:

  bit   7,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonOff)
  ld    h,(iy+ButtonOff+1)
  jr    nz,.go                          ;(bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  bit   6,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonMouseOver)
  ld    h,(iy+ButtonMouseOver+1)
  jr    nz,.go                          ;(bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
;  bit   5,(ix+HeroOverviewWindowButtonStatus)
  ld    l,(iy+ButtonOMouseClicked)
  ld    h,(iy+ButtonOMouseClicked+1)
  .go:
  
  xor   a
  ld    e,(ix+HeroOverviewWindowButton_de)
  ld    d,(ix+HeroOverviewWindowButton_de+1)
  ld    bc,$0000 + (HeroOverViewFirstWindowHightlightOption1NY*256) + (HeroOverViewFirstWindowHightlightOption1NX/2)
  call  CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret  

SwapAndSetPage:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	call	SetPageSpecial					        ;set page
  ret
  
SetHeroOverViewFirstWindow:
  ld    hl,$4000 + (HeroOverViewFirstWindowchoicesSY*128) + (HeroOverViewFirstWindowchoicesSX/2) -128
  xor   a
  ld    de,$0000 + (HeroOverViewFirstWindowchoicesDY*128) + (HeroOverViewFirstWindowchoicesDX/2)
  ld    bc,$0000 + (HeroOverViewFirstWindowchoicesNY*256) + (HeroOverViewFirstWindowchoicesNX/2)
  call  CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret

