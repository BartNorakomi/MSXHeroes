HandleTitleScreenCode:
  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    a,1
	ld		(activepage),a
;	ld    a,1
	ld		(ScenarioPage),a			
  call  SetScenarioSelectGraphics
  xor   a
	ld		(activepage),a			
  call  SetScenarioSelectGraphics
  ld    hl,InGamePalette
  call  SetPalette
  call  SetSpatInCastle
  call  SetInterruptHandler             ;set Vblank
  call  SetScenarioSelectButtons
  call  SetFontPage0Y212                ;set font at (0,212) page 0


  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jr    nz,.EndTitleScreenEngine

  ;scenario select buttons
  ld    ix,GenericButtonTable
  call  .CheckButtonMouseInteractionGenericButtons
  call  .CheckScenarioSelectButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  .SetGenericButtons              ;copies button state from rom -> vram
  ;/scenario select buttons

  call  SetNamesInScenarioButtons

  jp    .engine

  .EndTitleScreenEngine:
  call  SetTempisr                      ;end the current interrupt handler used in the engine
  call  SetSpatInGame
  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen 
  ret



.CheckScenarioSelectButtonClicked:      ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b
  cp    19
  jr    nc,.ScenarioPressed
  cp    16
  jr    nc,.Page123Pressed
  cp    14
  jr    nc,.BeginBackPressed
  cp    10
  jr    nc,.HumanOrCPUPressed
  cp    06
  jp    nc,.StartingTownPressed

  .DifficultyPressed:
  ret

  .StartingTownPressed:
  ret

  .HumanOrCPUPressed:
  ret

  .BeginBackPressed:
  ret

  .Page123Pressed:
  ld    b,3
  jr    z,.ScenarioPageFound
  cp    17
  ld    b,2
  jr    z,.ScenarioPageFound
  ld    b,1
  .ScenarioPageFound:
  ld    a,b
	ld		(ScenarioPage),a
  jp    SetAmountOfScenarioButtons

  .ScenarioPressed:
  ret






.SetGenericButtons:                      ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    a,(ix+GenericButtonGfxBlock)
  ld    (ButtonGfxBlockCopy),a

  ld    b,(ix+GenericButtonAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,GenericButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+GenericButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+GenericButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+GenericButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+GenericButtonStatus)
  res   1,(ix+GenericButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+GenericButton_SYSX_Ontouched)
  ld    h,(ix+GenericButton_SYSX_Ontouched+1)
  bit   6,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_MovedOver)
  ld    h,(ix+GenericButton_SYSX_MovedOver+1)
  bit   5,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_Clicked)
  ld    h,(ix+GenericButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+GenericButton_DYDX)
  ld    d,(ix+GenericButton_DYDX+1)

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    b,a                             ;ny
  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  srl   a                               ;/2
  ld    c,a                             ;nx / 2
;  ld    bc,$0000 + (016*256) + (016/2)        ;ny,nx

  ld    a,(ButtonGfxBlockCopy)

;.CopyTransparantButtons:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$8000 + ((212+16)*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+dx),a
  ld    a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+dy),a

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+ny),a

  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+nx),a

  ld    a,212+16
  ld    (CopyCastleButton2+sy),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    a,212
  ld    (CopyCastleButton2+sy),a

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret





.CheckButtonMouseInteractionGenericButtons:
  ld    b,(ix+GenericButtonAmountOfButtons)
  ld    de,GenericButtonTableLenghtPerButton

  .loop2:
  call  .check
  add   ix,de
  djnz  .loop2
  ret
  
  .check:
  bit   7,(ix+GenericButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+GenericButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06
  
  cp    (ix+GenericButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonXright)
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
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+GenericButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+GenericButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+GenericButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+GenericButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+GenericButtonStatus),%1010 0011
  scf                                     ;button has been clicked

  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
  ld    (MenuOptionSelected?),a
  ret

SetNamesInScenarioButtons:
  ld    b,020                           ;dx
  ld    c,046                           ;dy

  ld    a,(ScenarioPage)
  dec   a
  ld    hl,TextScenario001
  jr    z,.PageFound
  dec   a
  ld    hl,TextScenario011
  jr    z,.PageFound
  ld    hl,TextScenario021
  .PageFound:

  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.loop
  ld    a,10

  .loop:
  push  af
  push  hl
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  push  bc
  ld    b,38
  inc   hl
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  push  bc
  ld    b,53
  inc   hl
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  pop   hl
  ld    a,c
  add   a,13
  ld    c,a
  ld    de,LengthScenarioDescription
  add   hl,de
  pop   af
  dec   a
  jr    nz,.loop
  ret

LengthScenarioDescription:  equ TextScenario002-TextScenario001
TextScenario001: db "2",255,"S",255,"scenario description 1",255
TextScenario002: db "3",255,"S",255,"scenario description 2",255
TextScenario003: db "4",255,"S",255,"scenario description 3",255
TextScenario004: db "4",255,"M",255,"scenario description 4",255
TextScenario005: db "3",255,"M",255,"scenario description 5",255
TextScenario006: db "4",255,"S",255,"scenario description 6",255
TextScenario007: db "2",255,"M",255,"scenario description 7",255
TextScenario008: db "2",255,"M",255,"scenario description 8",255
TextScenario009: db "3",255,"S",255,"scenario description 9",255
TextScenario010: db "4",255,"S",255,"scenario description10",255

TextScenario011: db "2",255,"M",255,"scenario description11",255
TextScenario012: db "2",255,"M",255,"scenario description12",255
TextScenario013: db "3",255,"M",255,"scenario description13",255
TextScenario014: db "4",255,"M",255,"scenario description14",255
TextScenario015: db "2",255,"S",255,"scenario description15",255
TextScenario016: db "3",255,"M",255,"scenario description16",255
TextScenario017: db "4",255,"M",255,"scenario description17",255
TextScenario018: db "2",255,"M",255,"scenario description18",255
TextScenario019: db "2",255,"L",255,"scenario description19",255
TextScenario020: db "3",255,"M",255,"scenario description20",255

TextScenario021: db "3",255,"L",255,"scenario description21",255
TextScenario022: db "4",255,"M",255,"scenario description22",255
TextScenario023: db "2",255,"L",255,"scenario description23",255
TextScenario024: db "3",255,"L",255,"scenario description24",255
TextScenario025: db "4",255,"M",255,"scenario description25",255
TextScenario026: db "4",255,"L",255,"scenario description26",255
TextScenario027: db "4",255,"L",255,"scenario description27",255
TextScenario028: db "2",255,"L",255,"scenario description28",255
TextScenario029: db "3",255,"L",255,"scenario description29",255
TextScenario030: db "3",255,"L",255,"scenario description30",255

SetScenarioSelectButtons:
  ld    hl,ScenarioSelectButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*28)
  ldir

  call  SetAmountOfScenarioButtons
  call  SetAmountOfScenarioPageButtons
  ret

SetAmountOfScenarioPageButtons:
  ld    a,(AmountOfMapsUnlocked)
  cp    21
  ret   nc                            ;all 3 pages are unlocked when >20 maps are unlocked
  cp    11
  jr    nc,.LockPage3                 ;only lock page 3 when >10 maps <21 are unlocked
  
  .LockPage12And3:                    ;lock all pages when <11 maps are unlocked
  xor   a                             ;lock page 1 and 2
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*10),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*11),a
  .LockPage3:
  xor   a                             ;lock page 3
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*12),a
  ret

SetAmountOfScenarioButtons:
  call  ClearScenarioButtonGraphics
  call  SwapAndSetPage                  ;swap and set page
  call  ClearScenarioButtonGraphics
  
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*0),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*1),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*2),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*3),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*4),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*5),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*6),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*7),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*8),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*9),a

  ld    a,(ScenarioPage)
  dec   a
  ld    b,0
  jr    z,.PageFound
  dec   a
  ld    b,10
  jr    z,.PageFound
  ld    b,20
  .PageFound:
  ld    a,(AmountOfMapsUnlocked)
  sub   b
  ld    (AmountOfMapsVisibleInCurrentPage),a
  dec   a
  jr    z,.UpToScenario1Unlocked
  dec   a
  jr    z,.UpToScenario2Unlocked
  dec   a
  jr    z,.UpToScenario3Unlocked
  dec   a
  jr    z,.UpToScenario4Unlocked
  dec   a
  jr    z,.UpToScenario5Unlocked
  dec   a
  jr    z,.UpToScenario6Unlocked
  dec   a
  jr    z,.UpToScenario7Unlocked
  dec   a
  jr    z,.UpToScenario8Unlocked
  dec   a
  jr    z,.UpToScenario9Unlocked
  ret

  .UpToScenario1Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*1),a
  .UpToScenario2Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*2),a
  .UpToScenario3Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*3),a
  .UpToScenario4Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*4),a
  .UpToScenario5Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*5),a
  .UpToScenario6Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*6),a
  .UpToScenario7Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*7),a
  .UpToScenario8Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*8),a
  .UpToScenario9Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*9),a
  ret

  ;10 visible scenarios (per page)
ScenarioSelectButton1Ytop:           equ 043 + (0*13)
ScenarioSelectButton1YBottom:        equ ScenarioSelectButton1Ytop + 011
ScenarioSelectButton1XLeft:          equ 050
ScenarioSelectButton1XRight:         equ ScenarioSelectButton1XLeft + 096

ScenarioSelectButton2Ytop:           equ 043 + (1*13)
ScenarioSelectButton2YBottom:        equ ScenarioSelectButton2Ytop + 011
ScenarioSelectButton2XLeft:          equ 050
ScenarioSelectButton2XRight:         equ ScenarioSelectButton2XLeft + 096

ScenarioSelectButton3Ytop:           equ 043 + (2*13)
ScenarioSelectButton3YBottom:        equ ScenarioSelectButton3Ytop + 011
ScenarioSelectButton3XLeft:          equ 050
ScenarioSelectButton3XRight:         equ ScenarioSelectButton3XLeft + 096

ScenarioSelectButton4Ytop:           equ 043 + (3*13)
ScenarioSelectButton4YBottom:        equ ScenarioSelectButton4Ytop + 011
ScenarioSelectButton4XLeft:          equ 050
ScenarioSelectButton4XRight:         equ ScenarioSelectButton4XLeft + 096

ScenarioSelectButton5Ytop:           equ 043 + (4*13)
ScenarioSelectButton5YBottom:        equ ScenarioSelectButton5Ytop + 011
ScenarioSelectButton5XLeft:          equ 050
ScenarioSelectButton5XRight:         equ ScenarioSelectButton5XLeft + 096

ScenarioSelectButton6Ytop:           equ 043 + (5*13)
ScenarioSelectButton6YBottom:        equ ScenarioSelectButton6Ytop + 011
ScenarioSelectButton6XLeft:          equ 050
ScenarioSelectButton6XRight:         equ ScenarioSelectButton6XLeft + 096

ScenarioSelectButton7Ytop:           equ 043 + (6*13)
ScenarioSelectButton7YBottom:        equ ScenarioSelectButton7Ytop + 011
ScenarioSelectButton7XLeft:          equ 050
ScenarioSelectButton7XRight:         equ ScenarioSelectButton7XLeft + 096

ScenarioSelectButton8Ytop:           equ 043 + (7*13)
ScenarioSelectButton8YBottom:        equ ScenarioSelectButton8Ytop + 011
ScenarioSelectButton8XLeft:          equ 050
ScenarioSelectButton8XRight:         equ ScenarioSelectButton8XLeft + 096

ScenarioSelectButton9Ytop:           equ 043 + (8*13)
ScenarioSelectButton9YBottom:        equ ScenarioSelectButton9Ytop + 011
ScenarioSelectButton9XLeft:          equ 050
ScenarioSelectButton9XRight:         equ ScenarioSelectButton9XLeft + 096

ScenarioSelectButton10Ytop:           equ 043 + (9*13)
ScenarioSelectButton10YBottom:        equ ScenarioSelectButton10Ytop + 011
ScenarioSelectButton10XLeft:          equ 050
ScenarioSelectButton10XRight:         equ ScenarioSelectButton10XLeft + 096
  ;page 1,2,3
ScenarioSelectButton11Ytop:           equ 173
ScenarioSelectButton11YBottom:        equ ScenarioSelectButton11Ytop + 011
ScenarioSelectButton11XLeft:          equ 032
ScenarioSelectButton11XRight:         equ ScenarioSelectButton11XLeft + 032

ScenarioSelectButton12Ytop:           equ 173
ScenarioSelectButton12YBottom:        equ ScenarioSelectButton12Ytop + 011
ScenarioSelectButton12XLeft:          equ 066
ScenarioSelectButton12XRight:         equ ScenarioSelectButton12XLeft + 032

ScenarioSelectButton13Ytop:           equ 173
ScenarioSelectButton13YBottom:        equ ScenarioSelectButton13Ytop + 011
ScenarioSelectButton13XLeft:          equ 100
ScenarioSelectButton13XRight:         equ ScenarioSelectButton13XLeft + 032
  ;begin / back buttons
ScenarioSelectButton14Ytop:           equ 191
ScenarioSelectButton14YBottom:        equ ScenarioSelectButton14Ytop + 015
ScenarioSelectButton14XLeft:          equ 106
ScenarioSelectButton14XRight:         equ ScenarioSelectButton14XLeft + 020

ScenarioSelectButton15Ytop:           equ 191
ScenarioSelectButton15YBottom:        equ ScenarioSelectButton15Ytop + 015
ScenarioSelectButton15XLeft:          equ 132
ScenarioSelectButton15XRight:         equ ScenarioSelectButton15XLeft + 018
  ;human or cpu buttons
ScenarioSelectButton16Ytop:           equ 103 + (0*12)
ScenarioSelectButton16YBottom:        equ ScenarioSelectButton16Ytop + 011
ScenarioSelectButton16XLeft:          equ 158
ScenarioSelectButton16XRight:         equ ScenarioSelectButton16XLeft + 028

ScenarioSelectButton17Ytop:           equ 103 + (1*12)
ScenarioSelectButton17YBottom:        equ ScenarioSelectButton17Ytop + 011
ScenarioSelectButton17XLeft:          equ 158
ScenarioSelectButton17XRight:         equ ScenarioSelectButton17XLeft + 028

ScenarioSelectButton18Ytop:           equ 103 + (2*12)
ScenarioSelectButton18YBottom:        equ ScenarioSelectButton18Ytop + 011
ScenarioSelectButton18XLeft:          equ 158
ScenarioSelectButton18XRight:         equ ScenarioSelectButton18XLeft + 028

ScenarioSelectButton19Ytop:           equ 103 + (3*12)
ScenarioSelectButton19YBottom:        equ ScenarioSelectButton19Ytop + 011
ScenarioSelectButton19XLeft:          equ 158
ScenarioSelectButton19XRight:         equ ScenarioSelectButton19XLeft + 028
  ;starting town buttons
ScenarioSelectButton20Ytop:           equ 103 + (0*12)
ScenarioSelectButton20YBottom:        equ ScenarioSelectButton20Ytop + 011
ScenarioSelectButton20XLeft:          equ 186
ScenarioSelectButton20XRight:         equ ScenarioSelectButton20XLeft + 056

ScenarioSelectButton21Ytop:           equ 103 + (1*12)
ScenarioSelectButton21YBottom:        equ ScenarioSelectButton21Ytop + 011
ScenarioSelectButton21XLeft:          equ 186
ScenarioSelectButton21XRight:         equ ScenarioSelectButton21XLeft + 056

ScenarioSelectButton22Ytop:           equ 103 + (2*12)
ScenarioSelectButton22YBottom:        equ ScenarioSelectButton22Ytop + 011
ScenarioSelectButton22XLeft:          equ 186
ScenarioSelectButton22XRight:         equ ScenarioSelectButton22XLeft + 056

ScenarioSelectButton23Ytop:           equ 103 + (3*12)
ScenarioSelectButton23YBottom:        equ ScenarioSelectButton23Ytop + 011
ScenarioSelectButton23XLeft:          equ 186
ScenarioSelectButton23XRight:         equ ScenarioSelectButton23XLeft + 056
  ;difficulty buttons
ScenarioSelectButton24Ytop:           equ 160
ScenarioSelectButton24YBottom:        equ ScenarioSelectButton24Ytop + 018
ScenarioSelectButton24XLeft:          equ 158
ScenarioSelectButton24XRight:         equ ScenarioSelectButton24XLeft + 016

ScenarioSelectButton25Ytop:           equ 160
ScenarioSelectButton25YBottom:        equ ScenarioSelectButton25Ytop + 018
ScenarioSelectButton25XLeft:          equ 174
ScenarioSelectButton25XRight:         equ ScenarioSelectButton25XLeft + 018

ScenarioSelectButton26Ytop:           equ 160
ScenarioSelectButton26YBottom:        equ ScenarioSelectButton26Ytop + 018
ScenarioSelectButton26XLeft:          equ 192
ScenarioSelectButton26XRight:         equ ScenarioSelectButton26XLeft + 016

ScenarioSelectButton27Ytop:           equ 160
ScenarioSelectButton27YBottom:        equ ScenarioSelectButton27Ytop + 018
ScenarioSelectButton27XLeft:          equ 208
ScenarioSelectButton27XRight:         equ ScenarioSelectButton27XLeft + 018

ScenarioSelectButton28Ytop:           equ 160
ScenarioSelectButton28YBottom:        equ ScenarioSelectButton28Ytop + 018
ScenarioSelectButton28XLeft:          equ 226
ScenarioSelectButton28XRight:         equ ScenarioSelectButton28XLeft + 016

ScenarioSelectButtonTableGfxBlock:  db  ScenarioSelectButtonsBlock
ScenarioSelectButtonTableAmountOfButtons:  db  28
ScenarioSelectButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;10 visible scenarios (per page)
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton1Ytop,ScenarioSelectButton1YBottom,ScenarioSelectButton1XLeft,ScenarioSelectButton1XRight | dw $0000 + (ScenarioSelectButton1Ytop*128) + (ScenarioSelectButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton2Ytop,ScenarioSelectButton2YBottom,ScenarioSelectButton2XLeft,ScenarioSelectButton2XRight | dw $0000 + (ScenarioSelectButton2Ytop*128) + (ScenarioSelectButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton3Ytop,ScenarioSelectButton3YBottom,ScenarioSelectButton3XLeft,ScenarioSelectButton3XRight | dw $0000 + (ScenarioSelectButton3Ytop*128) + (ScenarioSelectButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton4Ytop,ScenarioSelectButton4YBottom,ScenarioSelectButton4XLeft,ScenarioSelectButton4XRight | dw $0000 + (ScenarioSelectButton4Ytop*128) + (ScenarioSelectButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton5Ytop,ScenarioSelectButton5YBottom,ScenarioSelectButton5XLeft,ScenarioSelectButton5XRight | dw $0000 + (ScenarioSelectButton5Ytop*128) + (ScenarioSelectButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton6Ytop,ScenarioSelectButton6YBottom,ScenarioSelectButton6XLeft,ScenarioSelectButton6XRight | dw $0000 + (ScenarioSelectButton6Ytop*128) + (ScenarioSelectButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton7Ytop,ScenarioSelectButton7YBottom,ScenarioSelectButton7XLeft,ScenarioSelectButton7XRight | dw $0000 + (ScenarioSelectButton7Ytop*128) + (ScenarioSelectButton7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton8Ytop,ScenarioSelectButton8YBottom,ScenarioSelectButton8XLeft,ScenarioSelectButton8XRight | dw $0000 + (ScenarioSelectButton8Ytop*128) + (ScenarioSelectButton8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton9Ytop,ScenarioSelectButton9YBottom,ScenarioSelectButton9XLeft,ScenarioSelectButton9XRight | dw $0000 + (ScenarioSelectButton9Ytop*128) + (ScenarioSelectButton9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton10Ytop,ScenarioSelectButton10YBottom,ScenarioSelectButton10XLeft,ScenarioSelectButton10XRight | dw $0000 + (ScenarioSelectButton10Ytop*128) + (ScenarioSelectButton10XLeft/2) - 128
  ;page 1,2,3
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton11Ytop,ScenarioSelectButton11YBottom,ScenarioSelectButton11XLeft,ScenarioSelectButton11XRight | dw $0000 + (ScenarioSelectButton11Ytop*128) + (ScenarioSelectButton11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton12Ytop,ScenarioSelectButton12YBottom,ScenarioSelectButton12XLeft,ScenarioSelectButton12XRight | dw $0000 + (ScenarioSelectButton12Ytop*128) + (ScenarioSelectButton12XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton13Ytop,ScenarioSelectButton13YBottom,ScenarioSelectButton13XLeft,ScenarioSelectButton13XRight | dw $0000 + (ScenarioSelectButton13Ytop*128) + (ScenarioSelectButton13XLeft/2) - 128
  ;begin / back buttons
  db  %1100 0011 | dw $4000 + (040*128) + (000/2) - 128 | dw $4000 + (040*128) + (020/2) - 128 | dw $4000 + (040*128) + (040/2) - 128 | db ScenarioSelectButton14Ytop,ScenarioSelectButton14YBottom,ScenarioSelectButton14XLeft,ScenarioSelectButton14XRight | dw $0000 + (ScenarioSelectButton14Ytop*128) + (ScenarioSelectButton14XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (060/2) - 128 | dw $4000 + (040*128) + (078/2) - 128 | dw $4000 + (040*128) + (096/2) - 128 | db ScenarioSelectButton15Ytop,ScenarioSelectButton15YBottom,ScenarioSelectButton15XLeft,ScenarioSelectButton15XRight | dw $0000 + (ScenarioSelectButton15Ytop*128) + (ScenarioSelectButton15XLeft/2) - 128
  ;human or cpu buttons
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton16Ytop,ScenarioSelectButton16YBottom,ScenarioSelectButton16XLeft,ScenarioSelectButton16XRight | dw $0000 + (ScenarioSelectButton16Ytop*128) + (ScenarioSelectButton16XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton17Ytop,ScenarioSelectButton17YBottom,ScenarioSelectButton17XLeft,ScenarioSelectButton17XRight | dw $0000 + (ScenarioSelectButton17Ytop*128) + (ScenarioSelectButton17XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton18Ytop,ScenarioSelectButton18YBottom,ScenarioSelectButton18XLeft,ScenarioSelectButton18XRight | dw $0000 + (ScenarioSelectButton18Ytop*128) + (ScenarioSelectButton18XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton19Ytop,ScenarioSelectButton19YBottom,ScenarioSelectButton19XLeft,ScenarioSelectButton19XRight | dw $0000 + (ScenarioSelectButton19Ytop*128) + (ScenarioSelectButton19XLeft/2) - 128
  ;starting town buttons
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton20Ytop,ScenarioSelectButton20YBottom,ScenarioSelectButton20XLeft,ScenarioSelectButton20XRight | dw $0000 + (ScenarioSelectButton20Ytop*128) + (ScenarioSelectButton20XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton21Ytop,ScenarioSelectButton21YBottom,ScenarioSelectButton21XLeft,ScenarioSelectButton21XRight | dw $0000 + (ScenarioSelectButton21Ytop*128) + (ScenarioSelectButton21XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton22Ytop,ScenarioSelectButton22YBottom,ScenarioSelectButton22XLeft,ScenarioSelectButton22XRight | dw $0000 + (ScenarioSelectButton22Ytop*128) + (ScenarioSelectButton22XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton23Ytop,ScenarioSelectButton23YBottom,ScenarioSelectButton23XLeft,ScenarioSelectButton23XRight | dw $0000 + (ScenarioSelectButton23Ytop*128) + (ScenarioSelectButton23XLeft/2) - 128
  ;difficulty buttons
  db  %1100 0011 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (022*128) + (016/2) - 128 | dw $4000 + (022*128) + (032/2) - 128 | db ScenarioSelectButton24Ytop,ScenarioSelectButton24YBottom,ScenarioSelectButton24XLeft,ScenarioSelectButton24XRight | dw $0000 + (ScenarioSelectButton24Ytop*128) + (ScenarioSelectButton24XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (048/2) - 128 | dw $4000 + (022*128) + (066/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | db ScenarioSelectButton25Ytop,ScenarioSelectButton25YBottom,ScenarioSelectButton25XLeft,ScenarioSelectButton25XRight | dw $0000 + (ScenarioSelectButton25Ytop*128) + (ScenarioSelectButton25XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (102/2) - 128 | dw $4000 + (022*128) + (118/2) - 128 | dw $4000 + (022*128) + (134/2) - 128 | db ScenarioSelectButton26Ytop,ScenarioSelectButton26YBottom,ScenarioSelectButton26XLeft,ScenarioSelectButton26XRight | dw $0000 + (ScenarioSelectButton26Ytop*128) + (ScenarioSelectButton26XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (150/2) - 128 | dw $4000 + (022*128) + (168/2) - 128 | dw $4000 + (022*128) + (186/2) - 128 | db ScenarioSelectButton27Ytop,ScenarioSelectButton27YBottom,ScenarioSelectButton27XLeft,ScenarioSelectButton27XRight | dw $0000 + (ScenarioSelectButton27Ytop*128) + (ScenarioSelectButton27XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (204/2) - 128 | dw $4000 + (022*128) + (220/2) - 128 | dw $4000 + (022*128) + (236/2) - 128 | db ScenarioSelectButton28Ytop,ScenarioSelectButton28YBottom,ScenarioSelectButton28XLeft,ScenarioSelectButton28XRight | dw $0000 + (ScenarioSelectButton28Ytop*128) + (ScenarioSelectButton28XLeft/2) - 128

ClearScenarioButtonGraphics:
  ld    hl,$4000 + (043*128) + (020/2) - 128
  ld    de,$0000 + (043*128) + (020/2) - 128
  ld    bc,$0000 + (128*256) + (126/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetScenarioSelectGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetFontPage0Y212:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

