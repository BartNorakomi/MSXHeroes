HeroOverViewFirstWindowchoicesSX:   equ 000
HeroOverViewFirstWindowchoicesSY:   equ 000
HeroOverViewFirstWindowchoicesDX:   equ 058
HeroOverViewFirstWindowchoicesDY:   equ 037
HeroOverViewFirstWindowchoicesNX:   equ 088
HeroOverViewFirstWindowchoicesNY:   equ 122

HeroOverViewFirstWindowButtonNY:  equ 011
HeroOverViewFirstWindowButtonNX:  equ 072

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewSkillsWindowSX:   equ 088
HeroOverViewSkillsWindowSY:   equ 000
HeroOverViewSkillsWindowDX:   equ 030
HeroOverViewSkillsWindowDY:   equ 025
HeroOverViewSkillsWindowNX:   equ 150
HeroOverViewSkillsWindowNY:   equ 139

HeroOverViewSkillsWindowButtonNY:  equ 011
HeroOverViewSkillsWindowButtonNX:  equ 134

HeroOverviewSkillsWindowCode:
  call  SetHeroOverViewSkillsWindow     ;set skills Window in inactive page
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSkillsWindow     ;set skills Window in inactive page

  .engine:
  call  PopulateControls                ;read out keys
  call  SwapAndSetPage                  ;swap and set page  
  ld    ix,HeroOverviewSkillsButtonTable
  ld    iy,ButtonTableSkillsSYSX
  call  CheckButtonMouseInteraction
  call  CheckEndHeroOverviewSkills      ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewSkillsButtonTable
  ld    bc,$0000 + (HeroOverViewSkillsWindowButtonNY*256) + (HeroOverViewSkillsWindowButtonNX/2)
  call  SetButtonStatus                 ;copies button state from rom -> vram
 
  halt
  jp  .engine

HeroOverviewCode:
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page

  .engine:
  call  PopulateControls                ;read out keys
  call  SwapAndSetPage                  ;swap and set page  
  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    iy,ButtonTableSYSX
  call  CheckButtonMouseInteraction
  call  CheckEndHeroOverviewFirstWindow ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
  call  SetButtonStatus                 ;copies button state from rom -> vram
 
  halt
  jp  .engine

CheckEndHeroOverviewSkills:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewSkillsWindowDY
  jr    c,.NotOverHeroOverViewSkillsWindow
  cp    HeroOverViewSkillsWindowDY+HeroOverViewSkillsWindowNY
  jr    nc,.NotOverHeroOverViewSkillsWindow
  
  ld    a,(spat+1)                      ;x mouse
  cp    HeroOverViewSkillsWindowDX
  jr    c,.NotOverHeroOverViewSkillsWindow
  cp    HeroOverViewSkillsWindowDX+HeroOverViewSkillsWindowNX
  ret   c

  .NotOverHeroOverViewSkillsWindow:
  pop   af
  ret                                   ;return to game

CheckEndHeroOverviewFirstWindow:        ;if mouse is NOT over the overview window AND you press trig a, then return back to game
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewFirstWindowchoicesDY
  jr    c,.NotOverHeroOverViewFirstWindowChoices
  cp    HeroOverViewFirstWindowchoicesDY+HeroOverViewFirstWindowchoicesNY
  jr    nc,.NotOverHeroOverViewFirstWindowChoices
  
  ld    a,(spat+1)                      ;x mouse
  cp    HeroOverViewFirstWindowchoicesDX
  jr    c,.NotOverHeroOverViewFirstWindowChoices
  cp    HeroOverViewFirstWindowchoicesDX+HeroOverViewFirstWindowchoicesNX
  ret   c

  .NotOverHeroOverViewFirstWindowChoices:
  pop   af
  ret                                   ;return to game

CheckButtonMouseInteraction:
  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  ld    de,ButtonTableLenght

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+HeroOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+HeroOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonXright)
  jr    nc,.NotOverButton
  ;at this point mouse pointer is over button, so light the edge of the button. Check if mouse button is pressed, in that case light entire button  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ld    a,(Controls)
  bit   4,a                             ;check trigger a / space
  jr    nz,.MouseOverButtonAndSpacePressed
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,MenuOptionSelected           ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+HeroOverviewWindowButtonStatus),%0100 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  ret

  .NotOverButton:
  bit   5,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  jr    nz,.buttonIsStillLit
  bit   6,(ix+HeroOverviewWindowButtonStatus) ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  ret

MenuOptionSelected:
  pop   af
  pop   af                              ;pop the 2 calls to this routine
  jp    HeroOverviewSkillsWindowCode

SetButtonStatus:                        ;copies button state from rom -> vram. in IX->ix,HeroOverview*****ButtonTable, bc->$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
;  ld    ix,HeroOverviewSkillsButtonTable
;  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)

  ld    (BCStored),bc

  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
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
;  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
;  ld    bc,$0000 + (HeroOverViewSkillsWindowButtonNY*256) + (HeroOverViewSkillsWindowButtonNX/2)

  ld    bc,(BCStored)

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

SetHeroOverViewSkillsWindow:
  ld    hl,$4000 + (HeroOverViewSkillsWindowSY*128) + (HeroOverViewSkillsWindowSX/2) -128
  xor   a
  ld    de,$0000 + (HeroOverViewSkillsWindowDY*128) + (HeroOverViewSkillsWindowDX/2)
  ld    bc,$0000 + (HeroOverViewSkillsWindowNY*256) + (HeroOverViewSkillsWindowNX/2)
  call  CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret
