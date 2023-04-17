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
HeroOverViewSkillsWindowNY:   equ 139-1

HeroOverViewSkillsWindowButtonNY:  equ 011
HeroOverViewSkillsWindowButtonNX:  equ 134

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewStatusWindowSX:   equ 000
HeroOverViewStatusWindowSY:   equ 000
HeroOverViewStatusWindowDX:   equ 028
HeroOverViewStatusWindowDY:   equ 040
HeroOverViewStatusWindowNX:   equ 150
HeroOverViewStatusWindowNY:   equ 116 ;-1

HeroOverviewStatusWindowCode:
  call  SetHeroOverViewStatusWindow     ;set skills Window in inactive page
  call  SetStatusTextAttack
  call  SwapAndSetPage                  ;swap and set page
;  call  SetHeroOverViewStatusWindow     ;set skills Window in inactive page
;  call  SetStatusTextAttack

  .engine:
  call  PopulateControls                ;read out keys
  call  CheckEndHeroOverviewStatus       ;check if mouse is clicked outside of window. If so, return to game
  halt
  jp  .engine

SetStatusTextAttack:
  ld    ix,(plxcurrentheroAddress)

  ld    a,(ix+HeroStatAttack)
  ld    b,HeroOverViewStatusWindowDX + 056
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber8Bit

  ld    a,(ix+HeroStatDefense)
  ld    b,HeroOverViewStatusWindowDX + 067
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber8Bit

  ld    a,(ix+HeroStatKnowledge)
  ld    b,HeroOverViewStatusWindowDX + 075
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber8Bit

  ld    a,(ix+HeroStatSpelldamage)
  ld    b,HeroOverViewStatusWindowDX + 084
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber8Bit

  ld    a,(ix+HeroLevel)
  ld    b,HeroOverViewStatusWindowDX + 091
  ld    c,HeroOverViewStatusWindowDY + 045
  call  SetNumber8Bit  

  ld    l,(ix+HeroXp)
  ld    h,(ix+HeroXp+1)
  ld    b,HeroOverViewStatusWindowDX + 058
  ld    c,HeroOverViewStatusWindowDY + 059
  call  SetNumber16Bit

  ld    hl,61358 ;xp next
  ld    b,HeroOverViewStatusWindowDX + 090
  ld    c,HeroOverViewStatusWindowDY + 059
  call  SetNumber16Bit

  ld    a,(ix+HeroMana)
  ld    b,HeroOverViewStatusWindowDX + 092
  ld    c,HeroOverViewStatusWindowDY + 073
  call  SetNumber8Bit  

  ld    a,(ix+HeroTotalMana)
  ld    b,HeroOverViewStatusWindowDX + 116
  ld    c,HeroOverViewStatusWindowDY + 073
  call  SetNumber8Bit  

  ld    a,(ix+HeroManarec)
  ld    b,HeroOverViewStatusWindowDX + 097
  ld    c,HeroOverViewStatusWindowDY + 087
  call  SetNumber8Bit  

  ld    a,(ix+HeroMove)
  ld    b,HeroOverViewStatusWindowDX + 105
  ld    c,HeroOverViewStatusWindowDY + 101
  call  SetNumber8Bit  

  ld    a,(ix+HeroTotalMove)
  ld    b,HeroOverViewStatusWindowDX + 124
  ld    c,HeroOverViewStatusWindowDY + 101
  call  SetNumber8Bit  
  ret

SetNumber16Bit:                         ;in hl=number (16bit)
  ld    a,b                             ;dx
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c                             ;dy
  ld    (PutLetter+dy),a                ;set dy of text

  call  ConvertToDecimal16bit

  ld    hl,TextNumber
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go
  ret

SetNumber8Bit:                          ;in a=number (8bit)
  call  ConvertToDecimal                ;converts 8 bit number to decimal and stores it in (TextNumber)

  ld    a,b                             ;dx
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c                             ;dy
  ld    (PutLetter+dy),a                ;set dy of text

  ld    hl,TextNumber
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go
  ret


ConvertToDecimal16bit:
  ld    iy,TextNumber




  .Check10000Folds:
  ld    d,$30                           ;10000folds in d ($30 = 0)

  .Loop10000Fold:
  or    a
  ld    bc,10000
  sbc   hl,bc                           ;check for 10000 folds
  jr    c,.Set10000Fold
  inc   d
  jr  .Loop10000Fold

  .Set10000Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet10000Fold  
  ld    (iy),d                          ;set 1000fold
  inc   iy
  .EndSet10000Fold:

  add   hl,bc




  .Check1000Folds:
  ld    d,$30                           ;1000folds in d ($30 = 0)

  .Loop1000Fold:
  or    a
  ld    bc,1000
  sbc   hl,bc                           ;check for 1000 folds
  jr    c,.Set1000Fold
  inc   d
  jr  .Loop1000Fold

  .Set1000Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet1000Fold  
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet1000Fold:

  add   hl,bc















  .Check100Folds:
  ld    d,$30                           ;100folds in d ($30 = 0)

  .Loop100Fold:
  or    a
  ld    bc,100
  sbc   hl,bc                           ;check for 100 folds
  jr    c,.Set100Fold
  inc   d
  jr  .Loop100Fold

  .Set100Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet100Fold  
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet100Fold:

  add   hl,bc
  .Check10Folds:
  ld    d,$30                           ;10folds in d ($30 = 0)

  .Loop10Fold:
  or    a
  ld    bc,10
  sbc   hl,bc                           ;check for 10 folds
  jr    c,.Set10Fold
  inc   d
  jr  .Loop10Fold

  .Set10Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet10Fold  
  ld    (iy),d                          ;set 10fold
  inc   iy
  .EndSet10Fold:

  .Check1Fold:
  ld    bc,10 + $30
  add   hl,bc
  
;  add   a,10 + $30
  ld    (iy),l                          ;set 1 fold
  ld    (iy+1),255                      ;end text
  ret


ConvertToDecimal:
  ld    iy,TextNumber
  .Check100Folds:
  ld    d,$30                           ;100folds in d ($30 = 0)

  .Loop100Fold:
  sub   100                             ;check for 100 folds
  jr    c,.Set100Fold
  inc   d
  jr  .Loop100Fold

  .Set100Fold:
  push  af
  ld    a,d
  cp    $30
  jr    z,.EndSet100Fold  
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet100Fold:
  pop   af

  add   a,100
  .Check10Folds:
  ld    d,$30                           ;10folds in d ($30 = 0)

  .Loop10Fold:
  sub   10                              ;check for 10 folds
  jr    c,.Set10Fold
  inc   d
  jr  .Loop10Fold

  .Set10Fold:
  push  af
  ld    a,d
  cp    $30
  jr    z,.EndSet10Fold  
  ld    (iy),d                          ;set 10fold
  inc   iy
  .EndSet10Fold:
  pop   af

  .Check1Fold:
  add   a,10 + $30
  ld    (iy),a                          ;set 1 fold
  ld    (iy+1),255                      ;end text
  ret
  





  ld    a,HeroOverViewStatusWindowDX + 090
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 59
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.xpnext
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go  

  ld    a,HeroOverViewStatusWindowDX + 092
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 73
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.spellpoints
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go  

  ld    a,HeroOverViewStatusWindowDX + 116
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 73
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.spellpointstot
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go  

  ld    a,HeroOverViewStatusWindowDX + 097
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 87
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.spellrecovery
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go  

  ld    a,HeroOverViewStatusWindowDX + 105
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 101
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.movementpoints
  ld    (TextAddresspointer),hl  
  call  SetTextInButton.go  

  ld    a,HeroOverViewStatusWindowDX + 124
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,HeroOverViewStatusWindowDY + 101
  ld    (PutLetter+dy),a                ;set dy of text
  ld    hl,StatusText.movementpointstot
  ld    (TextAddresspointer),hl  
  jp    SetTextInButton.go  

HeroOverviewSkillsWindowCode:
  call  SetHeroSkillsInTable

  ld    a, %1000 0011                   ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ld    (HeroOverviewSkillsButtonTable + 0*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewSkillsButtonTable + 1*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewSkillsButtonTable + 2*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewSkillsButtonTable + 3*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewSkillsButtonTable + 4*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewSkillsButtonTable + 5*ButtonTableLenght + HeroOverviewWindowButtonStatus),a

  call  SetHeroOverViewSkillsWindow     ;set skills Window in inactive page

  ld    ix,HeroOverviewSkillsButtonTable
  ld    iy,ButtonTableSkillsSYSX
  ld    bc,$0000 + (HeroOverViewSkillsWindowButtonNY*256) + (HeroOverViewSkillsWindowButtonNX/2)
  call  SetButtonStatusAndText          ;copies button state from rom -> vram
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSkillsWindow     ;set skills Window in inactive page

  .engine:
  call  PopulateControls                ;read out keys
  ld    ix,HeroOverviewSkillsButtonTable
  ld    iy,ButtonTableSkillsSYSX

  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.MenuOptionSelected

  call  SetSkillExplanation             ;when clicking on a skill, the explanation will appear
  call  CheckEndHeroOverviewSkills      ;check if mouse is clicked outside of window. If so, return to game
  ld    ix,HeroOverviewSkillsButtonTable
  ld    bc,$0000 + (HeroOverViewSkillsWindowButtonNY*256) + (HeroOverViewSkillsWindowButtonNX/2)
  call  SetButtonStatusAndText          ;copies button state from rom -> vram
  call  SwapAndSetPage                  ;swap and set page  
 
  halt
  jp  .engine

  .MenuOptionSelected:
  xor   a
  ld    (MenuOptionSelected?),a
  ld    (ActivatedSkillsButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  jp    HeroOverviewSkillsWindowCode
  
HeroOverviewCode:
  ld    a, %1000 0011                   ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ld    (HeroOverviewFirstWindowButtonTable + 0*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 1*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 2*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 3*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 4*ButtonTableLenght + HeroOverviewWindowButtonStatus),a

  call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page

  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    iy,ButtonTableSYSX
  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
  call  SetButtonStatusAndText          ;copies button state from rom -> vram

  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page

  .engine:
  call  PopulateControls                ;read out keys
  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    iy,ButtonTableSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jr    nz,.MenuOptionSelected

  call  CheckEndHeroOverviewFirstWindow ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
  call  SetButtonStatusAndText          ;copies button state from rom -> vram
  call  SwapAndSetPage                  ;swap and set page  

  halt
  jp  .engine

  .MenuOptionSelected:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.StatusSelected
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.SkillsSelected

  xor   a
  ld    (MenuOptionSelected?),a
  ret

  .StatusSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewStatusWindowCode
  
  .SkillsSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSkillsWindowCode

CheckEndHeroOverviewStatus:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewStatusWindowDY
  jr    c,.NotOverHeroOverViewStatusWindow
  cp    HeroOverViewStatusWindowDY+HeroOverViewStatusWindowNY
  jr    nc,.NotOverHeroOverViewStatusWindow
  
  ld    a,(spat+1)                      ;x mouse
  cp    HeroOverViewStatusWindowDX
  jr    c,.NotOverHeroOverViewStatusWindow
  cp    HeroOverViewStatusWindowDX+HeroOverViewStatusWindowNX
  ret   c

  .NotOverHeroOverViewStatusWindow:
  pop   af
  ret   

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

SetHeroSkillsInTable:
  ld    ix,(plxcurrentheroAddress)

  ld    a,(ix+HeroSkills+0)
  ld    de,TextSkillsWindowButton1
  call  .SetheroSkill

  ld    a,(ix+HeroSkills+1)
  ld    de,TextSkillsWindowButton2
  call  .SetheroSkill

  ld    a,(ix+HeroSkills+2)
  ld    de,TextSkillsWindowButton3
  call  .SetheroSkill

  ld    a,(ix+HeroSkills+3)
  ld    de,TextSkillsWindowButton4
  call  .SetheroSkill

  ld    a,(ix+HeroSkills+4)
  ld    de,TextSkillsWindowButton5
  call  .SetheroSkill

  ld    a,(ix+HeroSkills+5)
  ld    de,TextSkillsWindowButton6
  call  .SetheroSkill
  ret

  .SetheroSkill:
  ld    l,a
  ld    h,0
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  push  hl
  add   hl,hl                           ;*64
  pop   bc
  add   hl,bc                           ;*96
  ld    bc,SkillEmpty
  add   hl,bc
  ld    bc,LenghtSkillDescription
  ldir
  ret

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

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+HeroOverviewWindowButtonStatus),%0010 0011
  ret
  
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
  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
  ld    (MenuOptionSelected?),a
  pop   af                                    ;pop the call in the button check loop 
  ret

SetButtonStatusAndText:                        ;copies button state from rom -> vram. in IX->ix,HeroOverview*****ButtonTable, bc->$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
;  ld    ix,HeroOverviewSkillsButtonTable
;  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)

;  ld    iy,ButtonTableSkillsSYSX
;  ld    iy,ButtonTableSYSX


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
  
  ld    e,(ix+HeroOverviewWindowButton_de)
  ld    d,(ix+HeroOverviewWindowButton_de+1)
  ld    bc,(BCStored)

  ld    a,HeroOverviewGraphicsBlock     ;Map block
  call  CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
;  jp    SetTextInButton
 
SetTextInButton:
  ld    l,(ix+TextAddress)
  ld    h,(ix+TextAddress+1)            ;address of text to put
  ld    (TextAddresspointer),hl

  ld    a,(ix+HeroOverviewWindowButtonYtop)
  add   a,4
  ld    (PutLetter+dy),a                ;set dy of text
  ld    a,(ix+HeroOverviewWindowButtonXleft)
  add   a,3
  ld    (PutLetter+dx),a                ;set dx of text

  .go:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
  ld    (PutLetter+dPage),a             ;set page where to put text

  ld      a,-1
  ld    (TextPointer),a                 ;increase text pointer
  .NextLetter:
  ld    a,(TextPointer)
  inc   a
  ld    (TextPointer),a                 ;increase text pointer

  ld    hl,(TextAddresspointer)

  ld    d,0
  ld    e,a
  add   hl,de

  ld    a,(hl)                          ;letter
  cp    255                             ;end
  ret   z
  cp    254                             ;next line
  jr    z,.NextLine
  cp    TextSpace                       ;space
  jr    z,.Space
  cp    TextPercentageSymbol            ;%
  jr    z,.TextPercentageSymbol
  cp    TextNumber0+10
  jr    c,.Number

  sub   $61                             ;hex value of letter "a"
  add   a,a                             ;*2
  ld    d,0
  ld    e,a

  ld    hl,TextCoordinateTable
  add   hl,de
  
  .GoPutLetter:
  ld    a,(hl)                          ;sx
  ld    (PutLetter+sx),a                ;set sx of letter
  inc   hl
  ld    a,(hl)                          ;nx
  ld    (PutLetter+nx),a                ;set nx of letter

  ld    hl,PutLetter
  call  DoCopy

  ld    hl,PutLetter+nx                 ;nx of letter
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  add   a,(hl)                          ;add lenght
  inc   a                               ;+1
  ld    (PutLetter+dx),a                ;set dx of next letter
  
  jp    .NextLetter

.Number:
  sub   TextNumber0                     ;hex value of number "0"
  add   a,a                             ;*2
  ld    d,0
  ld    e,a  

  ld    hl,TextNumberSymbolsSXNX
  add   hl,de
  jr    .GoPutLetter
  
.TextPercentageSymbol:
  ld    hl,TextPercentageSymbolSXNX  
  jr    .GoPutLetter
  
.Space:
  ld    a,(PutLetter+dx)                ;set dx of next letter
  add   a,5
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter

.NextLine:
  ld    a,(PutLetter+dy)                ;set dy of next letter
  add   a,7
  ld    (PutLetter+dy),a                ;set dy of next letter
  ld    a,(TextDX)
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter

SetSkillExplanation:
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 
  
  ld    ix,(ActivatedSkillsButton)
  ld    a,037
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,138
  ld    (PutLetter+dy),a                ;set dy of text

  ld    l,(ix+TextAddress)
  ld    h,(ix+TextAddress+1)            ;address of text to put
  ld    de,LenghtTextSkillsDescription
  add   hl,de
  ld    (TextAddresspointer),hl  
  jp    SetTextInButton.go

TextPercentageSymbol:     equ $25
TextSpace:                equ $20
TextNumber0:              equ $30

TextNumberSymbolsSXNX: db 121,5,  126,2,  128,4,  132,3,  135,3,  138,4,  142,4,  146,4,  150,4,  154,4,  158,4  
TextPercentageSymbolSXNX: db  162,4 ;"%"
TextSlashSymbolSXNX: db  158,4  ;"/"

;                         a      b      c      d      e      f      g      h      i      j      k      l      m      n      o      p      q      r      s      t      u      v      w      x      y      z     
TextCoordinateTable:  db  000,5, 004,5, 009,5, 014,5, 019,5, 024,5, 029,5, 034,5, 039,5, 042,5, 047,4, 051,4, 055,5, 059,5, 063,5, 067,5, 072,5, 076,5, 081,5, 086,5, 091,5, 096,5, 101,5, 106,5, 111,5, 116,5
TextFirstWindowChoicesButton1:  db  "skills",255
TextFirstWindowChoicesButton2:  db  "inventory",255
TextFirstWindowChoicesButton3:  db  "army",255
TextFirstWindowChoicesButton4:  db  "spell book",255
TextFirstWindowChoicesButton5:  db  "status",255

LenghtSkillDescription: equ SkillArcheryAdvanced-SkillArcheryBasic
SkillEmpty:
                          db  "                       ",255   ;skillnr# 000
                          db  "                       ",254
                          db  "                       ",254
                          db  "                       ",255
SkillArcheryBasic:
                          db  "basic archery          ",255   ;skillnr# 001
                          db  "basic archery          ",254
                          db  "ranged attack damage   ",254
                          db  "is increased by 10%    ",255
SkillArcheryAdvanced:
                          db  "advanced archery       ",255
                          db  "advanced archery       ",254
                          db  "ranged attack damage   ",254
                          db  "is increased by 20%    ",255
SkillArcheryExpert:
                          db  "expert archery         ",255
                          db  "expert archery         ",254
                          db  "ranged attack damage   ",254
                          db  "is increased by 50%    ",255
SkillOffenceBasic:
                          db  "basic offense          ",255   ;skillnr# 004
                          db  "basic offense          ",254
                          db  "hand to hand damage is ",254
                          db  "increased by 10%       ",255
SkillOffenceAdvanced:
                          db  "advanced offense       ",255
                          db  "advanced offense       ",254
                          db  "hand to hand damage is ",254
                          db  "increased by 20%       ",255
SkillOffenceExpert:
                          db  "expert offense         ",255
                          db  "expert offense         ",254
                          db  "hand to hand damage is ",254
                          db  "increased by 30%       ",255
SkillArmourerBasic:
                          db  "basic armourer         ",255   ;skillnr# 007
                          db  "basic armourer         ",254
                          db  "damage inflicted on    ",254
                          db  "army is reduced by 5%  ",255
SkillArmourerAdvanced:
                          db  "advanced armourer      ",255
                          db  "advanced armourer      ",254
                          db  "damage inflicted on    ",254
                          db  "army is reduced by 10% ",255
SkillArmourerExpert:
                          db  "expert armourer        ",255
                          db  "expert armourer        ",254
                          db  "damage inflicted on    ",254
                          db  "army is reduced by 15% ",255
SkillresistanceBasic:
                          db  "basic resistance       ",255   ;skillnr# 010
                          db  "basic resistance       ",254
                          db  "your units have 5%     ",254
                          db  "chance to block spells ",255
SkillresistanceAdvanced:
                          db  "advanced resistance    ",255
                          db  "advanced resistance    ",254
                          db  "your units have 10%    ",254
                          db  "chance to block spells ",255
SkillresistanceExpert:
                          db  "expert resistance      ",255
                          db  "expert resistance      ",254
                          db  "your units have 15%    ",254
                          db  "chance to block spells ",255
SkillnecromancyBasic:
                          db  "basic necromancy       ",255   ;skillnr# 013
                          db  "basic necromancy       ",254
                          db  "10% of enemy creatures ",254
                          db  "killed are resurrected ",255
SkillnecromancyAdvanced:
                          db  "advanced necromancy    ",255
                          db  "advanced necromancy    ",254
                          db  "20% of enemy creatures ",254
                          db  "killed are resurrected ",255
SkillnecromancyExpert:
                          db  "expert necromancy      ",255
                          db  "expert necromancy      ",254
                          db  "30% of enemy creatures ",254
                          db  "killed are resurrected ",255
SkillestatesBasic:
                          db  "basic estates          ",255   ;skillnr# 016
                          db  "basic estates          ",254
                          db  "hero generates an extra",254
                          db  "125 gold per day       ",255
SkillestatesAdvanced:
                          db  "advanced estates       ",255
                          db  "advanced estates       ",254
                          db  "hero generates an extra",254
                          db  "250 gold per day       ",255
SkillestatesExpert:
                          db  "expert estates         ",255
                          db  "expert estates         ",254
                          db  "hero generates an extra",254
                          db  "500 gold per day       ",255
SkilllearningBasic:
                          db  "basic learning         ",255   ;skillnr# 019
                          db  "basic learning         ",254
                          db  "earned experience is   ",254
                          db  "increased by 5%        ",255
SkilllearningAdvanced:
                          db  "advanced learning      ",255
                          db  "advanced learning      ",254
                          db  "earned experience is   ",254
                          db  "increased by 10%       ",255
SkilllearningExpert:
                          db  "expert learning        ",255
                          db  "expert learning        ",254
                          db  "earned experience is   ",254
                          db  "increased by 15%       ",255
SkilllogisticsBasic:
                          db  "basic logistics        ",255   ;skillnr# 022
                          db  "basic logistics        ",254
                          db  "increases land movement",254
                          db  "range of hero by 10%   ",255
SkilllogisticsAdvanced:
                          db  "advanced logistics     ",255
                          db  "advanced logistics     ",254
                          db  "increases land movement",254
                          db  "range of hero by 20%   ",255
SkilllogisticsExpert:
                          db  "expert logistics       ",255
                          db  "expert logistics       ",254
                          db  "increases land movement",254
                          db  "range of hero by 30%   ",255
SkillintelligenceBasic:
                          db  "basic intelligence     ",255   ;skillnr# 025
                          db  "basic intelligence     ",254
                          db  "maximum spell points   ",254
                          db  "increased by 25%       ",255
SkillintelligenceAdvanced:
                          db  "advanced intelligence  ",255
                          db  "advanced intelligence  ",254
                          db  "maximum spell points   ",254
                          db  "increased by 50%       ",255
SkillintelligenceExpert:
                          db  "expert intelligence    ",255
                          db  "expert intelligence    ",254
                          db  "maximum spell points   ",254
                          db  "increased by 100%      ",255
SkillsorceryBasic:
                          db  "basic sorcery          ",255   ;skillnr# 028
                          db  "basic sorcery          ",254
                          db  "increases spell damage ",254
                          db  "by 5%                  ",255
SkillsorceryAdvanced:
                          db  "advanced sorcery       ",255
                          db  "advanced sorcery       ",254
                          db  "increases spell damage ",254
                          db  "by 10%                 ",255
SkillsorceryExpert:
                          db  "expert sorcery         ",255
                          db  "expert sorcery         ",254
                          db  "increases spell damage ",254
                          db  "by 15%                 ",255
SkillwisdomBasic:
                          db  "basic wisdom           ",255   ;skillnr# 031
                          db  "basic wisdom           ",254
                          db  "hero can learn spells  ",254
                          db  "level 3 and below      ",255
SkillwisdomAdvanced:
                          db  "advanced wisdom        ",255
                          db  "advanced wisdom        ",254
                          db  "hero can learn spells  ",254
                          db  "level 4 and below      ",255
SkillwisdomExpert:
                          db  "expert wisdom          ",255
                          db  "expert wisdom          ",254
                          db  "hero can learn all     ",254
                          db  "spells                 ",255


SwapAndSetPage:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	call	SetPageSpecial					        ;set page
  ret

SetHeroOverViewFontPage0Y212:           ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
;  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (005*256) + (256/2)
  ld    a,HeroOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
SetHeroOverViewFirstWindow:
  ld    hl,$4000 + (HeroOverViewFirstWindowchoicesSY*128) + (HeroOverViewFirstWindowchoicesSX/2) -128
  ld    de,$0000 + (HeroOverViewFirstWindowchoicesDY*128) + (HeroOverViewFirstWindowchoicesDX/2)
  ld    bc,$0000 + (HeroOverViewFirstWindowchoicesNY*256) + (HeroOverViewFirstWindowchoicesNX/2)
  ld    a,HeroOverviewGraphicsBlock     ;Map block
  jp    CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewSkillsWindow:
  ld    hl,$4000 + (HeroOverViewSkillsWindowSY*128) + (HeroOverViewSkillsWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewSkillsWindowDY*128) + (HeroOverViewSkillsWindowDX/2)
  ld    bc,$0000 + (HeroOverViewSkillsWindowNY*256) + (HeroOverViewSkillsWindowNX/2)
  ld    a,HeroOverviewGraphicsBlock     ;Map block
  jp    CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY



SetHeroOverViewStatusWindow:
  ld    hl,$4000 + (HeroOverViewStatusWindowSY*128) + (HeroOverViewStatusWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewStatusWindowDY*128) + (HeroOverViewStatusWindowDX/2)
  ld    bc,$0000 + (HeroOverViewStatusWindowNY*256) + (HeroOverViewStatusWindowNX/2)
  ld    a,HeroOverviewStatusGraphicsBlock;Map block
  jp    CopyRamToVramCorrected          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
