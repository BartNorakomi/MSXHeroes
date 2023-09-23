CastleOverviewMarketPlaceCode:
  ld    iy,Castle1

  call  SetMarketPlaceButtons

  ld    hl,World1Palette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  call  SetMarketPlaceGraphics          ;put gfx in page 1

  ld    hl,CopyPage1To0
  call  docopy

  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;market place buttons
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/market place buttons

  halt
  jp  .engine

.CheckButtonClicked:                    ;in: carry=button clicked, b=button number
  ret   nc

  call  .SetIcanOfferYouWindow
  call  .SetWhichResourceWillYouTradeWindow

  ld    a,%1100 0011                    ;enable which resource will you trade buttons
  ld    (GenericButtonTable+5*GenericButtonTableLenghtPerButton),a ;wood
  ld    (GenericButtonTable+6*GenericButtonTableLenghtPerButton),a ;ore
  ld    (GenericButtonTable+7*GenericButtonTableLenghtPerButton),a ;gems
  ld    (GenericButtonTable+8*GenericButtonTableLenghtPerButton),a ;rubies
  ld    (GenericButtonTable+9*GenericButtonTableLenghtPerButton),a ;gold


;  push  bc                              ;store button number
;  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
;  pop   bc                              ;recall button number

;  push  bc                              ;store button number

  call  SwapAndSetPage                  ;swap and set page


;  pop   bc                              ;recall button number

  ret
  
  .SetIcanOfferYouWindow:
  ld    a,b                             ;only set the i can offer you window if you clicked on buttons in the 2nd or 3d window
  cp    9
  ret   nc

  ld    a,%1100 0011                    ;enable which resource will you trade buttons
  ld    (GenericButtonTable+10*GenericButtonTableLenghtPerButton),a ;+
  ld    (GenericButtonTable+11*GenericButtonTableLenghtPerButton),a ;buy
  ld    (GenericButtonTable+12*GenericButtonTableLenghtPerButton),a ;-
  
  ld    hl,$4000 + (109*128) + (000/2) - 128
  ld    de,$0000 + (123*128) + (000/2) - 128
  ld    bc,$0000 + (044*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SwapAndSetPage                  ;swap and set page

  ld    hl,$4000 + (109*128) + (000/2) - 128
  ld    de,$0000 + (123*128) + (000/2) - 128
  ld    bc,$0000 + (044*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
    
  .SetWhichResourceWillYouTradeWindow:
  ld    a,(GenericButtonTable+5*GenericButtonTableLenghtPerButton) ;check if this window is already active
  bit   7,a
  ret   nz
  
  ld    hl,$4000 + (066*128) + (000/2) - 128
  ld    de,$0000 + (080*128) + (000/2) - 128
  ld    bc,$0000 + (043*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SwapAndSetPage                  ;swap and set page

  ld    hl,$4000 + (066*128) + (000/2) - 128
  ld    de,$0000 + (080*128) + (000/2) - 128
  ld    bc,$0000 + (043*256) + (256/2)
  ld    a,ChamberOfCommerceButtonsBlock ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  


SetMarketPlaceButtons:
  ld    hl,MarketPlaceButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*13)
  ldir
  ret

MarketPlaceButton1Ytop:           equ 052
MarketPlaceButton1YBottom:        equ MarketPlaceButton1Ytop + 022
MarketPlaceButton1XLeft:          equ 030
MarketPlaceButton1XRight:         equ MarketPlaceButton1XLeft + 028

MarketPlaceButton2Ytop:           equ 052
MarketPlaceButton2YBottom:        equ MarketPlaceButton2Ytop + 022
MarketPlaceButton2XLeft:          equ 072
MarketPlaceButton2XRight:         equ MarketPlaceButton2XLeft + 028

MarketPlaceButton3Ytop:           equ 052
MarketPlaceButton3YBottom:        equ MarketPlaceButton3Ytop + 022
MarketPlaceButton3XLeft:          equ 114
MarketPlaceButton3XRight:         equ MarketPlaceButton3XLeft + 028

MarketPlaceButton4Ytop:           equ 052
MarketPlaceButton4YBottom:        equ MarketPlaceButton4Ytop + 022
MarketPlaceButton4XLeft:          equ 156
MarketPlaceButton4XRight:         equ MarketPlaceButton4XLeft + 028

MarketPlaceButton5Ytop:           equ 052
MarketPlaceButton5YBottom:        equ MarketPlaceButton5Ytop + 022
MarketPlaceButton5XLeft:          equ 198
MarketPlaceButton5XRight:         equ MarketPlaceButton5XLeft + 028

MarketPlaceButton6Ytop:           equ 095
MarketPlaceButton6YBottom:        equ MarketPlaceButton6Ytop + 022
MarketPlaceButton6XLeft:          equ 030
MarketPlaceButton6XRight:         equ MarketPlaceButton6XLeft + 028

MarketPlaceButton7Ytop:           equ 095
MarketPlaceButton7YBottom:        equ MarketPlaceButton7Ytop + 022
MarketPlaceButton7XLeft:          equ 072
MarketPlaceButton7XRight:         equ MarketPlaceButton7XLeft + 028

MarketPlaceButton8Ytop:           equ 095
MarketPlaceButton8YBottom:        equ MarketPlaceButton8Ytop + 022
MarketPlaceButton8XLeft:          equ 114
MarketPlaceButton8XRight:         equ MarketPlaceButton8XLeft + 028

MarketPlaceButton9Ytop:           equ 095
MarketPlaceButton9YBottom:        equ MarketPlaceButton9Ytop + 022
MarketPlaceButton9XLeft:          equ 156
MarketPlaceButton9XRight:         equ MarketPlaceButton9XLeft + 028

MarketPlaceButton10Ytop:           equ 095
MarketPlaceButton10YBottom:        equ MarketPlaceButton10Ytop + 022
MarketPlaceButton10XLeft:          equ 198
MarketPlaceButton10XRight:         equ MarketPlaceButton10XLeft + 028



MarketPlaceButton11Ytop:           equ 143
MarketPlaceButton11YBottom:        equ MarketPlaceButton11Ytop + 014
MarketPlaceButton11XLeft:          equ 092
MarketPlaceButton11XRight:         equ MarketPlaceButton11XLeft + 014

MarketPlaceButton12Ytop:           equ 141
MarketPlaceButton12YBottom:        equ MarketPlaceButton12Ytop + 018
MarketPlaceButton12XLeft:          equ 116
MarketPlaceButton12XRight:         equ MarketPlaceButton12XLeft + 026

MarketPlaceButton13Ytop:           equ 143
MarketPlaceButton13YBottom:        equ MarketPlaceButton13Ytop + 014
MarketPlaceButton13XLeft:          equ 152
MarketPlaceButton13XRight:         equ MarketPlaceButton13XLeft + 014

MarketPlaceButtonTableLenghtPerButton:  equ MarketPlaceButtonTable.endlenght-MarketPlaceButtonTable
MarketPlaceButtonTableGfxBlock:  db  ChamberOfCommerceButtonsBlock
MarketPlaceButtonTableAmountOfButtons:  db  13
MarketPlaceButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;which resource do you need window
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (044*128) + (000/2) - 128 | db MarketPlaceButton1Ytop,MarketPlaceButton1YBottom,MarketPlaceButton1XLeft,MarketPlaceButton1XRight | dw $0000 + (MarketPlaceButton1Ytop*128) + (MarketPlaceButton1XLeft/2) - 128 
  .endlenght:
  db  %1010 0011 | dw $4000 + (000*128) + (028/2) - 128 | dw $4000 + (022*128) + (028/2) - 128 | dw $4000 + (044*128) + (028/2) - 128 | db MarketPlaceButton2Ytop,MarketPlaceButton2YBottom,MarketPlaceButton2XLeft,MarketPlaceButton2XRight | dw $0000 + (MarketPlaceButton2Ytop*128) + (MarketPlaceButton2XLeft/2) - 128 
  db  %1001 0011 | dw $4000 + (000*128) + (056/2) - 128 | dw $4000 + (022*128) + (056/2) - 128 | dw $4000 + (044*128) + (056/2) - 128 | db MarketPlaceButton3Ytop,MarketPlaceButton3YBottom,MarketPlaceButton3XLeft,MarketPlaceButton3XRight | dw $0000 + (MarketPlaceButton3Ytop*128) + (MarketPlaceButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (084/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | dw $4000 + (044*128) + (084/2) - 128 | db MarketPlaceButton4Ytop,MarketPlaceButton4YBottom,MarketPlaceButton4XLeft,MarketPlaceButton4XRight | dw $0000 + (MarketPlaceButton4Ytop*128) + (MarketPlaceButton4XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (112/2) - 128 | dw $4000 + (022*128) + (112/2) - 128 | dw $4000 + (044*128) + (112/2) - 128 | db MarketPlaceButton5Ytop,MarketPlaceButton5YBottom,MarketPlaceButton5XLeft,MarketPlaceButton5XRight | dw $0000 + (MarketPlaceButton5Ytop*128) + (MarketPlaceButton5XLeft/2) - 128 
  ;which resource will you offer window
  db  %0100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (044*128) + (000/2) - 128 | db MarketPlaceButton6Ytop,MarketPlaceButton6YBottom,MarketPlaceButton6XLeft,MarketPlaceButton6XRight | dw $0000 + (MarketPlaceButton6Ytop*128) + (MarketPlaceButton6XLeft/2) - 128 
  db  %0010 0011 | dw $4000 + (000*128) + (028/2) - 128 | dw $4000 + (022*128) + (028/2) - 128 | dw $4000 + (044*128) + (028/2) - 128 | db MarketPlaceButton7Ytop,MarketPlaceButton7YBottom,MarketPlaceButton7XLeft,MarketPlaceButton7XRight | dw $0000 + (MarketPlaceButton7Ytop*128) + (MarketPlaceButton7XLeft/2) - 128 
  db  %0001 0011 | dw $4000 + (000*128) + (056/2) - 128 | dw $4000 + (022*128) + (056/2) - 128 | dw $4000 + (044*128) + (056/2) - 128 | db MarketPlaceButton8Ytop,MarketPlaceButton8YBottom,MarketPlaceButton8XLeft,MarketPlaceButton8XRight | dw $0000 + (MarketPlaceButton8Ytop*128) + (MarketPlaceButton8XLeft/2) - 128
  db  %0100 0011 | dw $4000 + (000*128) + (084/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | dw $4000 + (044*128) + (084/2) - 128 | db MarketPlaceButton9Ytop,MarketPlaceButton9YBottom,MarketPlaceButton9XLeft,MarketPlaceButton9XRight | dw $0000 + (MarketPlaceButton9Ytop*128) + (MarketPlaceButton9XLeft/2) - 128 
  db  %0100 0011 | dw $4000 + (000*128) + (112/2) - 128 | dw $4000 + (022*128) + (112/2) - 128 | dw $4000 + (044*128) + (112/2) - 128 | db MarketPlaceButton10Ytop,MarketPlaceButton10YBottom,MarketPlaceButton10XLeft,MarketPlaceButton10XRight | dw $0000 + (MarketPlaceButton10Ytop*128) + (MarketPlaceButton10XLeft/2) - 128 
  ;+ buy - window
  db  %0100 0011 | dw $4000 + (000*128) + (140/2) - 128 | dw $4000 + (014*128) + (140/2) - 128 | dw $4000 + (028*128) + (140/2) - 128 | db MarketPlaceButton11Ytop,MarketPlaceButton11YBottom,MarketPlaceButton11XLeft,MarketPlaceButton11XRight | dw $0000 + (MarketPlaceButton11Ytop*128) + (MarketPlaceButton11XLeft/2) - 128 
  db  %0010 0011 | dw $4000 + (042*128) + (140/2) - 128 | dw $4000 + (042*128) + (166/2) - 128 | dw $4000 + (042*128) + (192/2) - 128 | db MarketPlaceButton12Ytop,MarketPlaceButton12YBottom,MarketPlaceButton12XLeft,MarketPlaceButton12XRight | dw $0000 + (MarketPlaceButton12Ytop*128) + (MarketPlaceButton12XLeft/2) - 128 
  db  %0001 0011 | dw $4000 + (000*128) + (154/2) - 128 | dw $4000 + (014*128) + (154/2) - 128 | dw $4000 + (028*128) + (140/2) - 128 | db MarketPlaceButton13Ytop,MarketPlaceButton13YBottom,MarketPlaceButton13XLeft,MarketPlaceButton13XRight | dw $0000 + (MarketPlaceButton13Ytop*128) + (MarketPlaceButton13XLeft/2) - 128


CastleOverviewMagicGuildCode:
  ld    iy,Castle1

  call  SetMagicGuildButtons

  ld    hl,World1Palette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  call  SetMagicGuildGraphics           ;put gfx in page 1

  ld    hl,CopyPage1To0
  call  docopy

  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;magic skill icons in the magic guild
  ld    ix,GenericButtonTable 
  call  CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  SetGenericButtons               ;copies button state from rom -> vram
  ;/magic skill icons in the magic guild

  halt
  jp  .engine

.CheckButtonClicked:                    ;in: carry=button clicked, b=button number
  ret   nc

  push  bc                              ;store button number
  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0
  call  .ClearTextWindow
  call  .SetSpellIcon
  pop   bc                              ;recall button number
  push  bc                              ;store button number
  call  .SetText
  call  SwapAndSetPage                  ;swap and set page
  call  .ClearTextWindow
  call  .SetSpellIcon
  pop   bc                              ;recall button number
  call  .SetText
  ret

  .ClearTextWindow:
  ld    hl,$4000 + (154*128) + (006/2) - 128
  ld    de,$0000 + (154*128) + (006/2) - 128
  ld    bc,$0000 + (020*256) + (244/2)
  ld    a,MagicGuildBlock                 ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetSpellIcon:
  ld    hl,$4000 + (126*128) + (196/2) - 128
  ld    de,$0000 + (154*128) + (008/2) - 128
  ld    bc,$0000 + (020*256) + (020/2)
  ld    a,SpellBookGraphicsBlock        ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

.SetText:
  ld    a,b
  cp    8
  ld    de,(GenericButtonTable+1+0*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    7
  ld    de,(GenericButtonTable+1+1*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    6
  ld    de,(GenericButtonTable+1+2*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    5
  ld    de,(GenericButtonTable+1+3*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    4
  ld    de,(GenericButtonTable+1+4*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    3
  ld    de,(GenericButtonTable+1+5*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  cp    2
  ld    de,(GenericButtonTable+1+6*GenericButtonTableLenghtPerButton)
  jp    z,.ButtonFound
  ld    de,(GenericButtonTable+1+7*GenericButtonTableLenghtPerButton)
  .ButtonFound:
  ld    hl,EarthLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth1
  jp    z,.SpellFound
  ld    hl,EarthLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth2
  jp    z,.SpellFound
  ld    hl,EarthLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth3
  jp    z,.SpellFound
  ld    hl,EarthLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionEarth4
  jp    z,.SpellFound

  ld    hl,FireLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire1
  jp    z,.SpellFound
  ld    hl,FireLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire2
  jp    z,.SpellFound
  ld    hl,FireLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire3
  jp    z,.SpellFound
  ld    hl,FireLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionFire4
  jp    z,.SpellFound

  ld    hl,AirLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir1
  jp    z,.SpellFound
  ld    hl,AirLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir2
  jp    z,.SpellFound
  ld    hl,AirLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir3
  jp    z,.SpellFound
  ld    hl,AirLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionAir4
  jp    z,.SpellFound

  ld    hl,WaterLevel1Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater1
  jp    z,.SpellFound
  ld    hl,WaterLevel2Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater2
  jp    z,.SpellFound
  ld    hl,WaterLevel3Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater3
  jp    z,.SpellFound
  ld    hl,WaterLevel4Untouched
  call  CompareHLwithDE
  ld    hl,SpellDescriptionsMagicGuild.DescriptionWater4
  jp    z,.SpellFound
  
  .SpellFound:
  ld    a,031
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,154
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ex    de,hl
;  ld    hl,FireLevel1Untouched
  ld    de,$0000 + (156*128) + (010/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,SpellBookGraphicsBlock        ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret



SpellDescriptionsMagicGuild:
.DescriptionEarth1:        db  "earth meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth2:        db  "earth",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth3:        db  "earthstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionEarth4:        db  "earthbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.DescriptionFire1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire2:        db  "fire",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire3:        db  "firestorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.DescriptionFire4:        db  "firebullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.Descriptionair1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair2:        db  "air",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair3:        db  "airstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionair4:        db  "airbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255

.Descriptionwater1:        db  "meteor",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater2:        db  "water",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater3:        db  "waterstorm",254
                          db  "damages all units on the",254
                          db  "the battlefield",255

.Descriptionwater4:        db  "waterbullet",254
                          db  "damages all units on the",254
                          db  "the screen",255












SetGenericButtons:                      ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
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

  ld    a,(GenericButtonTableGfxBlock)                   ;buttons block

  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  halt
  ret





CheckButtonMouseInteractionGenericButtons:
  ld    b,(ix+GenericButtonAmountOfButtons)
  ld    de,GenericButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
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
;  ld    a,b
  ret

SetMagicGuildButtons:
  ld    hl,MagicGuildButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*8)
  ldir

  ld    a,(iy+CastleMageGuildLevel)
  cp    4
  ret   z
  xor   a
  ld    (GenericButtonTable+6*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+7*GenericButtonTableLenghtPerButton),a

  ld    a,(iy+CastleMageGuildLevel)
  cp    3
  ret   z
  xor   a
  ld    (GenericButtonTable+4*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+5*GenericButtonTableLenghtPerButton),a

  ld    a,(iy+CastleMageGuildLevel)
  cp    2
  ret   z
  xor   a
  ld    (GenericButtonTable+2*GenericButtonTableLenghtPerButton),a
  ld    (GenericButtonTable+3*GenericButtonTableLenghtPerButton),a
  ret

;DYDX of icons in the Magic Guild overview screen
MagicGuildEarthLevel1Y:    equ 046
MagicGuildEarthLevel1X:    equ 034
MagicGuildEarthLevel2Y:    equ 046
MagicGuildEarthLevel2X:    equ 072
MagicGuildEarthLevel3Y:    equ 069
MagicGuildEarthLevel3X:    equ 034
MagicGuildEarthLevel4Y:    equ 069
MagicGuildEarthLevel4X:    equ 072

MagicGuildFireLevel1Y:   equ 105
MagicGuildFireLevel1X:   equ 034
MagicGuildFireLevel2Y:   equ 105
MagicGuildFireLevel2X:   equ 072
MagicGuildFireLevel3Y:   equ 128
MagicGuildFireLevel3X:   equ 034
MagicGuildFireLevel4Y:   equ 128
MagicGuildFireLevel4X:   equ 072

MagicGuildAirLevel1Y:     equ 046
MagicGuildAirLevel1X:     equ 166
MagicGuildAirLevel2Y:     equ 046
MagicGuildAirLevel2X:     equ 204
MagicGuildAirLevel3Y:     equ 069
MagicGuildAirLevel3X:     equ 166
MagicGuildAirLevel4Y:     equ 069
MagicGuildAirLevel4X:     equ 204

MagicGuildWaterLevel1Y:   equ 105
MagicGuildWaterLevel1X:   equ 166
MagicGuildWaterLevel2Y:   equ 105
MagicGuildWaterLevel2X:   equ 204
MagicGuildWaterLevel3Y:   equ 128
MagicGuildWaterLevel3X:   equ 166
MagicGuildWaterLevel4Y:   equ 128
MagicGuildWaterLevel4X:   equ 204

;SYSX of the icons Touched and Untouched
EarthLevel1Untouched:    equ $4000 + (000*128) + (224/2) - 128
EarthLevel1Touched:      equ $4000 + (000*128) + (240/2) - 128
EarthLevel2Untouched:    equ $4000 + (016*128) + (224/2) - 128
EarthLevel2Touched:      equ $4000 + (016*128) + (240/2) - 128
EarthLevel3Untouched:    equ $4000 + (032*128) + (224/2) - 128
EarthLevel3Touched:      equ $4000 + (032*128) + (240/2) - 128
EarthLevel4Untouched:    equ $4000 + (048*128) + (224/2) - 128
EarthLevel4Touched:      equ $4000 + (048*128) + (240/2) - 128

FireLevel1Untouched:   equ $4000 + (064*128) + (224/2) - 128
FireLevel1Touched:     equ $4000 + (064*128) + (240/2) - 128
FireLevel2Untouched:   equ $4000 + (080*128) + (224/2) - 128
FireLevel2Touched:     equ $4000 + (080*128) + (240/2) - 128
FireLevel3Untouched:   equ $4000 + (096*128) + (224/2) - 128
FireLevel3Touched:     equ $4000 + (096*128) + (240/2) - 128
FireLevel4Untouched:   equ $4000 + (112*128) + (224/2) - 128
FireLevel4Touched:     equ $4000 + (112*128) + (240/2) - 128

AirLevel1Untouched:     equ $4000 + (128*128) + (224/2) - 128
AirLevel1Touched:       equ $4000 + (128*128) + (240/2) - 128
AirLevel2Untouched:     equ $4000 + (144*128) + (224/2) - 128
AirLevel2Touched:       equ $4000 + (144*128) + (240/2) - 128
AirLevel3Untouched:     equ $4000 + (160*128) + (224/2) - 128
AirLevel3Touched:       equ $4000 + (160*128) + (240/2) - 128
AirLevel4Untouched:     equ $4000 + (176*128) + (224/2) - 128
AirLevel4Touched:       equ $4000 + (176*128) + (240/2) - 128

WaterLevel1Untouched:   equ $4000 + (184*128) + (000/2) - 128
WaterLevel1Touched:     equ $4000 + (184*128) + (016/2) - 128
WaterLevel2Untouched:   equ $4000 + (184*128) + (032/2) - 128
WaterLevel2Touched:     equ $4000 + (184*128) + (048/2) - 128
WaterLevel3Untouched:   equ $4000 + (184*128) + (064/2) - 128
WaterLevel3Touched:     equ $4000 + (184*128) + (080/2) - 128
WaterLevel4Untouched:   equ $4000 + (184*128) + (096/2) - 128
WaterLevel4Touched:     equ $4000 + (184*128) + (112/2) - 128

MagicGuildButtonTableLenghtPerButton:  equ MagicGuildButtonTable.endlenght-MagicGuildButtonTable
MagicGuildButtonTableGfxBlock:  db  SpellBookGraphicsBlock
MagicGuildButtonTableAmountOfButtons:  db  8
MagicGuildButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
;level 1 spells
  db  %1100 0011 | dw FireLevel1Untouched   | dw FireLevel1Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel1Y ,MagicGuildFireLevel1Y+16 ,MagicGuildFireLevel1X ,MagicGuildFireLevel1X+16  | dw $0000 + (MagicGuildFireLevel1Y*128)  + (MagicGuildFireLevel1X/2)  - 128 |
  .endlenght:
  db  %1100 0011 | dw WaterLevel1Untouched  | dw WaterLevel1Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel1Y,MagicGuildWaterLevel1Y+16,MagicGuildWaterLevel1X,MagicGuildWaterLevel1X+16 | dw $0000 + (MagicGuildWaterLevel1Y*128) + (MagicGuildWaterLevel1X/2) - 128 | 
;level 2 spells
  db  %1100 0011 | dw WaterLevel2Untouched  | dw WaterLevel2Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildWaterLevel2Y,MagicGuildWaterLevel2Y+16,MagicGuildWaterLevel2X,MagicGuildWaterLevel2X+16 | dw $0000 + (MagicGuildWaterLevel2Y*128) + (MagicGuildWaterLevel2X/2) - 128 | 
  db  %1100 0011 | dw AirLevel2Untouched    | dw AirLevel2Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel2Y  ,MagicGuildAirLevel2Y+16  ,MagicGuildAirLevel2X  ,MagicGuildAirLevel2X+16   | dw $0000 + (MagicGuildAirLevel2Y*128)   + (MagicGuildAirLevel2X/2) - 128   | 
;level 3 spells
  db  %1100 0011 | dw FireLevel3Untouched   | dw FireLevel3Touched    | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildFireLevel3Y ,MagicGuildFireLevel3Y+16 ,MagicGuildFireLevel3X ,MagicGuildFireLevel3X+16  | dw $0000 + (MagicGuildFireLevel3Y*128)  + (MagicGuildFireLevel3X/2)  - 128 |
  db  %1100 0011 | dw EarthLevel3Untouched  | dw EarthLevel3Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel3Y,MagicGuildEarthLevel3Y+16,MagicGuildEarthLevel3X,MagicGuildEarthLevel3X+16 | dw $0000 + (MagicGuildEarthLevel3Y*128) + (MagicGuildEarthLevel3X/2) - 128 | 
;level 4 spells
  db  %1100 0011 | dw AirLevel4Untouched    | dw AirLevel4Touched     | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildAirLevel4Y  ,MagicGuildAirLevel4Y+16  ,MagicGuildAirLevel4X  ,MagicGuildAirLevel4X+16   | dw $0000 + (MagicGuildAirLevel4Y*128)   + (MagicGuildAirLevel4X/2) - 128   | 
  db  %1100 0011 | dw EarthLevel4Untouched  | dw EarthLevel4Touched   | dw $4000 + (150*128) + (192/2) - 128 | db MagicGuildEarthLevel4Y,MagicGuildEarthLevel4Y+16,MagicGuildEarthLevel4X,MagicGuildEarthLevel4X+16 | dw $0000 + (MagicGuildEarthLevel4Y*128) + (MagicGuildEarthLevel4X/2) - 128 | 



CastleOverviewRecruitCode:
  ld    iy,Castle1

  ld    hl,World1Palette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  xor   a
  ld    (RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton),a ;BUY button
  ld    (RecruitButtonMAXBUYTable+1*RecruitButtonMAXBUYTableLenghtPerButton),a ;MAX button

  ld    a,%1100 0011                    ;turn all recruit buttons on
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 

  call  SetRecruitGraphics              ;put gfx in page 1
  call  SetAvailableRecruitArmy         ;put army icons, amount and info in the 6 windows

;  ld    b,3                             ;which unit ?
;  call  ShowRecruitWindowForSelectedUnit

  ld    hl,CopyPage1To0
  call  docopy

  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;recruit button for level 1-6 creatures
  ld    ix,RecruitButtonTable 
  call  CheckButtonMouseInteractionRecruitButtons

  ld    ix,RecruitButtonTable
  call  SetRecruitButtons                ;copies button state from rom -> vram
  ;/recruit button for level 1-6 creatures

  ;recruit buttons MAX and BUY
  ld    ix,RecruitButtonMAXBUYTable 
;  call  CheckButtonMouseInteractionRecruitButtons
  call  CheckButtonMouseInteractionRecruitMAXBUYButtons

  ld    ix,RecruitButtonMAXBUYTable
;  call  SetRecruitButtons                ;copies button state from rom -> vram
  call  SetRecruitMAXBUYButtons                ;copies button state from rom -> vram
  ;/recruit buttons MAX and BUY

  call  CheckEndRecruitUnitWindow   ;check if mouse is clicked outside of recruit single unit window. If so, close this window

  halt
  jp  .engine

CheckEndRecruitUnitWindow:
  ld    a,(RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton) ;BUY button
  or    a
  ret   z

	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    032                             ;dy
  jr    c,.NotOverRecruitSingleUnitWindow
  cp    032+092                         ;dy+ny
  jr    nc,.NotOverRecruitSingleUnitWindow
  
  ld    a,(spat+1)                      ;x mouse
  cp    048                             ;dx
  jr    c,.NotOverRecruitSingleUnitWindow
  cp    048+162                         ;dx+nx
  ret   c

  .NotOverRecruitSingleUnitWindow:
  pop   af                                ;pop the call to this routine
  jp    CastleOverviewRecruitCode




SetRecruitMAXBUYButtons:                  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,(ix+AmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,RecruitButtonMAXBUYTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+RecruitButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+RecruitButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+RecruitButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+RecruitButtonStatus)
  res   1,(ix+RecruitButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+RecruitButton_SYSX_Ontouched)
  ld    h,(ix+RecruitButton_SYSX_Ontouched+1)
  bit   6,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_MovedOver)
  ld    h,(ix+RecruitButton_SYSX_MovedOver+1)
  bit   5,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_Clicked)
  ld    h,(ix+RecruitButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+RecruitButton_DYDX)
  ld    d,(ix+RecruitButton_DYDX+1)

  ld    bc,$0000 + (018*256) + (026/2)        ;ny,nx
  ld    a,ButtonsRecruitBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  halt
  ret










CheckButtonMouseInteractionRecruitMAXBUYButtons:
  ld    b,(ix+AmountOfButtons)
  ld    de,RecruitButtonMAXBUYTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+RecruitButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+RecruitButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+RecruitButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonXright)
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
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+RecruitButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+RecruitButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+RecruitButtonStatus),%1010 0011
  ld    a,b
  cp    2
  jr    z,.BuyButtonPressed
  cp    1
  jr    z,.MaxButtonPressed
  ret

  .MaxButtonPressed:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ;add amount available to recruit amount to select all units ready for recruitment
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  add   hl,de
  ld    (SelectedCastleRecruitLevelUnitRecruitAmount),hl
  ld    hl,0
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),hl

  call  .SetAvailableAmountRecruitAmountAndTotalCost
  call  SwapAndSetPage                  ;swap and set page
  call  .SetAvailableAmountRecruitAmountAndTotalCost
  ret

  .BuyButtonPressed:

  pop   af                                ;pop the call to this routine
  jp    CastleOverviewRecruitCode

.SetAvailableAmountRecruitAmountAndTotalCost:
  ;erase available number
  ld    hl,$4000 + (118*128) + (040/2) - 128
  ld    de,$0000 + (103*128) + (088/2) - 128
  ld    bc,$0000 + (005*256) + (018/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;erase total cost and recruit amount
  ld    hl,$4000 + (086*128) + (102/2) - 128
  ld    de,$0000 + (071*128) + (150/2) - 128
  ld    bc,$0000 + (037*256) + (042/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
  call  ShowRecruitWindowForSelectedUnit.amountavailable
  call  ShowRecruitWindowForSelectedUnit.recruitamount
  call  .SetTotalCost
  call  ShowRecruitWindowForSelectedUnit.totalcost
  call  ShowRecruitWindowForSelectedUnit.TotalGemscost
  call  ShowRecruitWindowForSelectedUnit.TotalRubiescost
  ret

  .SetTotalCost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,CostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
;  push  bc
  call  MultiplyHlWithDE
;  pop   bc

  ld    (SelectedCastleRecruitLevelUnitTotalGoldCost),hl
  ret

SetRecruitButtons:                        ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,6
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,RecruitButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+RecruitButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+RecruitButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+RecruitButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+RecruitButtonStatus)
  res   1,(ix+RecruitButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+RecruitButton_SYSX_Ontouched)
  ld    h,(ix+RecruitButton_SYSX_Ontouched+1)
  bit   6,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_MovedOver)
  ld    h,(ix+RecruitButton_SYSX_MovedOver+1)
  bit   5,(ix+RecruitButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+RecruitButton_SYSX_Clicked)
  ld    h,(ix+RecruitButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+RecruitButton_DYDX)
  ld    d,(ix+RecruitButton_DYDX+1)

  ld    bc,$0000 + (009*256) + (076/2)        ;ny,nx
  ld    a,ButtonsRecruitBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  halt
  ret












CheckButtonMouseInteractionRecruitButtons:
  ld    b,6
  ld    de,RecruitButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+RecruitButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+RecruitButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+RecruitButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+RecruitButtonXright)
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
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+RecruitButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+RecruitButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+RecruitButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+RecruitButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
;  ld    (ix+RecruitButtonStatus),%1010 0011
;  ld    a,b

  push  bc                              ;b=unit selected
  call  ShowRecruitWindowForSelectedUnit
  call  SwapAndSetPage                  ;swap and set page
  pop   bc
  call  ShowRecruitWindowForSelectedUnit
  ret

MultiplyHlWithDE:
  push  hl
  pop   bc
;
; Multiply 16-bit values (with 16-bit result)
; In: Multiply BC with DE
; Out: HL = result
;
Mult16:
    ld a,b
    ld b,16
Mult16_Loop:
    add hl,hl
    sla c
    rla
    jr nc,Mult16_NoAdd
    add hl,de
Mult16_NoAdd:
    djnz Mult16_Loop
    ret


ShowRecruitWindowForSelectedUnit:       ;in b=which level unit is selected ?
  xor   a                               ;turn all recruit buttons off
  ld    (RecruitButtonTable+0*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 
  ld    a,%1100 0011
  ld    (RecruitButtonMAXBUYTable+0*RecruitButtonMAXBUYTableLenghtPerButton),a ;BUY button
  ld    (RecruitButtonMAXBUYTable+1*RecruitButtonMAXBUYTableLenghtPerButton),a ;MAX button

  call  .SetUnit                        ;set selected unit in (SelectedCastleRecruitLevelUnit)

  ;show recruit window for selected unit
  ld    hl,$4000 + (047*128) + (000/2) - 128
  ld    de,$0000 + (032*128) + (048/2) - 128
  ld    bc,$0000 + (092*256) + (162/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetCastleOverViewFontPage0Y212  ;set font at (0,212) page 0

  call  .army
  call  .name
  call  .cost
  call  .Gemscost
  call  .Rubiescost

  call  .amountavailable
  call  .recruitamount
  ret

.TotalRubiescost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+101                       ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + ((052+97)/2) - 128  
  call  .SetTotalRubiescost
  ret

.TotalGemscost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063+101                       ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + ((052+97)/2) - 128  
  call  .SetTotalGemscost
  ret

  .SetTotalGemscost:
  push  de
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,GemsCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  push  bc
  call  MultiplyHlWithDE
  pop   bc

  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy
  
  ;set Gems Icon
  ld    hl,$4000 + (000*128) + (228/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .SetTotalRubiescost:
  push  de
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,RubiesCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  ld    de,(SelectedCastleRecruitLevelUnitRecruitAmount)
  push  bc
  call  MultiplyHlWithDE
  pop   bc

  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy
  
  ;set Ruby Icon
  ld    hl,$4000 + (000*128) + (242/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .Zero:                                ;skip putting number and icon if amount is 0
  pop   de
  ret

.totalcost:
  ld    hl,(SelectedCastleRecruitLevelUnitTotalGoldCost)
  ld    b,177
  ld    c,071 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.Rubiescost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  call  SetAvailableRecruitArmy.SetRubiescost

.Gemscost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,063                           ;dx
  ld    c,083                           ;dy
  ld    de,$0000 + (078*128) + (052/2) - 128  
  jp    SetAvailableRecruitArmy.SetGemscost

.cost:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,072                           ;dx
  ld    c,071                           ;dy
  jp    SetAvailableRecruitArmy.SetCost

.name:
  ld    a,(SelectedCastleRecruitLevelUnit)
  ld    b,125                           ;dx
  ld    c,038                           ;dy
  jp    SetAvailableRecruitArmy.SetName

.recruitamount:
  ld    hl,(SelectedCastleRecruitLevelUnitRecruitAmount)
  ld    b,177
  ld    c,103 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.amountavailable:
  ld    hl,(SelectedCastleRecruitLevelUnitAmountAvailable)
  ld    b,090
  ld    c,103 ;HeroOverViewArmyWindowDY + 056
  jp    SetNumber16BitCastle

.army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(SelectedCastleRecruitLevelUnit)
  call  SetAvailableRecruitArmy.SetSYSX ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,050*128 + (120/2) - 128      ;(dy*128 + dx/2) = (204,153)              
  jp    CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

.SetUnit:
  ld    hl,SelectedCastleRecruitLevelUnit
  ld    a,b
  cp    6
  ld    c,(iy+CastleLevel1Units+00)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+00)
  ld    d,(iy+CastleLevel1UnitsAvail+01)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    5
  ld    c,(iy+CastleLevel1Units+01)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+02)
  ld    d,(iy+CastleLevel1UnitsAvail+03)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    4
  ld    c,(iy+CastleLevel1Units+02)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+04)
  ld    d,(iy+CastleLevel1UnitsAvail+05)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    3
  ld    c,(iy+CastleLevel1Units+03)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+06)
  ld    d,(iy+CastleLevel1UnitsAvail+07)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
  cp    2
  ld    c,(iy+CastleLevel1Units+04)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+08)
  ld    d,(iy+CastleLevel1UnitsAvail+09)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
  ret   z
;  cp    1
  ld    c,(iy+CastleLevel1Units+05)
  ld    (hl),c
  ld    e,(iy+CastleLevel1UnitsAvail+10)
  ld    d,(iy+CastleLevel1UnitsAvail+11)
  ld    (SelectedCastleRecruitLevelUnitAmountAvailable),de
;  ret   z
  ret














NameCreature000:  db  "Empty:",255
NameCreature001:  db  "Green Ghoul:",255
NameCreature002:  db  "Drollie:",255
NameCreature003:  db  "Wappie:",255
NameCreature004:  db  "Green Ghoul:",255
NameCreature005:  db  "Green Ghoul:",255
NameCreature006:  db  "Green Ghoul:",255
NameCreature007:  db  "Green Ghoul:",255
NameCreature008:  db  "Green Ghoul:",255
NameCreature009:  db  "Green Ghoul:",255
NameCreature010:  db  "Green Ghoul:",255
NameCreature011:  db  "Green Ghoul:",255
NameCreature012:  db  "Green Ghoul:",255
NameCreature013:  db  "Green Ghoul:",255
NameCreature014:  db  "Green Ghoul:",255
NameCreature015:  db  "Green Ghoul:",255
NameCreature016:  db  "Green Ghoul:",255
NameCreature017:  db  "Green Ghoul:",255
NameCreature018:  db  "Green Ghoul:",255

CostCreatureTable:  
  dw  0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015,0016,0017

GemsCostCreatureTable:  
  dw  0000,0000,0000,0000,0000,0005,0006,0007,0008,0009,0010,0011,0012,0013,0014,0015,0016,0017

RubiesCostCreatureTable:  
  dw  0000,0001,0007,0000,0003,0000,0000,0007,0008,0009,0010,0011,0012,0013,0014,0015,0016,0017

SpeedCreatureTable:  
  db  000,012,002,003,009,005,006,007,008,009,010,011,012,013,014,015,016,017

DefenseCreatureTable:  
  db  000,001,002,003,006,005,006,007,008,009,010,011,012,013,014,015,016,017

AttackCreatureTable:  
  db  000,001,002,003,055,005,006,007,008,009,010,011,012,013,014,015,016,017

CreatureNameTable:  
  dw NameCreature000,NameCreature001,NameCreature002,NameCreature003,NameCreature004,NameCreature005,NameCreature006,NameCreature007,NameCreature008,NameCreature009,NameCreature010,NameCreature011,NameCreature012,NameCreature013,NameCreature014,NameCreature015,NameCreature016,NameCreature017

SetAvailableRecruitArmy:
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  .army
  call  .amount
  call  .names
  call  .cost
  call  .Gemscost
  call  .Rubiescost
  call  .speed
  call  .defense
  call  .attack
  call  .SetInactiveWindowIfUnavailable
  ret

.SetInactiveWindowIfUnavailable:
  ld    a,(iy+CastleBarracksLevel+00)
  cp    6
  ret   z
  cp    5
  jr    z,.Level6UnitsUnavailable
  cp    4
  jr    z,.Level5UnitsUnavailable
  cp    3
  jr    z,.Level4UnitsUnavailable
  cp    2
  jr    z,.Level3UnitsUnavailable

  .Level2UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((034-09)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+1*RecruitButtonTableLenghtPerButton),a 

  .Level3UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((034-09)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+2*RecruitButtonTableLenghtPerButton),a 

  .Level4UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((005+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+3*RecruitButtonTableLenghtPerButton),a 

  .Level5UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((089+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+4*RecruitButtonTableLenghtPerButton),a 

  .Level6UnitsUnavailable:
  ld    hl,$4000 + (000*128) + (076/2) - 128
  ld    de,$0000 + ((090-09)*128) + ((173+001)/2) - 128  
  ld    bc,$0000 + (047*256) + (076/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  xor   a                               ;turn button off
  ld    (RecruitButtonTable+5*RecruitButtonTableLenghtPerButton),a 
  ret



.Rubiescost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetRubiescost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((173+030)/2) - 128  
  call  .SetRubiescost
  ret

  .SetRubiescost:
  push  de
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,RubiesCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  call  SetNumber16BitCastle
  
  ;set Ruby Icon
  ld    hl,$4000 + (000*128) + (242/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

.Gemscost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+038                       ;dx
  ld    c,043                           ;dy
  ld    de,$0000 + ((034+05)*128) + ((173+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((005+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((089+030)/2) - 128  
  call  .SetGemscost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+038                       ;dx
  ld    c,099                           ;dy
  ld    de,$0000 + ((090+05)*128) + ((173+030)/2) - 128  
  call  .SetGemscost
  ret

  .SetGemscost:
  push  de
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,GemsCostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  ld    a,h
  or    l
  jr    z,.Zero                         ;skip putting number and icon if amount is 0

  call  SetNumber16BitCastle
  
  ;set Gems Icon
  ld    hl,$4000 + (000*128) + (228/2) - 128
;  ld    de,$0000 + ((029+10)*128) + ((010+025)/2) - 128
  pop   de
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ButtonsRecruitBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .Zero:                                ;skip putting number and icon if amount is 0
  pop   de
  ret


  .attack:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,054                           ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,054+56                        ;dy
  call  .SetAttack  
  ret

  .SetAttack:
  ld    h,0
  ld    l,a
  ld    de,AttackCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret
  
  .defense:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,047                           ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,047+56                        ;dy
  call  .SetDefense  
  ret

  .SetDefense:
  ld    h,0
  ld    l,a
  ld    de,DefenseCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret

  .speed:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,083-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,167-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,251-14                        ;dx
  ld    c,040                           ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,083-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,167-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,251-14                        ;dx
  ld    c,040+56                        ;dy
  call  .SetSpeed  
  ret

  .SetSpeed:
  ld    h,0
  ld    l,a
  ld    de,SpeedCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret





  .cost:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,005+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,089+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,173+020                       ;dx
  ld    c,055                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,005+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,089+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,173+020                       ;dx
  ld    c,111                           ;dy
  call  .SetCost
  ret

  .SetCost:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,CostCreatureTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl

  call  SetNumber16BitCastle
  ret
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret

  .names:
  ld    a,(iy+CastleLevel1Units+00)
  ld    b,007                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+01)
  ld    b,091                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+02)
  ld    b,175                           ;dx
  ld    c,027                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+03)
  ld    b,007                           ;dx
  ld    c,083                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+04)
  ld    b,091                           ;dx
  ld    c,083                           ;dy
  call  .SetName

  ld    a,(iy+CastleLevel1Units+05)
  ld    b,175                           ;dx
  ld    c,083                           ;dy
  call  .SetName
  ret

  .SetName:
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,CreatureNameTable
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ex    de,hl
  
  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret

  .amount:
  ld    l,(iy+CastleLevel1UnitsAvail+00)
  ld    h,(iy+CastleLevel1UnitsAvail+01)
  ld    b,081 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+02)
  ld    h,(iy+CastleLevel1UnitsAvail+03)
  ld    b,166 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+04)
  ld    h,(iy+CastleLevel1UnitsAvail+05)
  ld    b,251 - 25
  ld    c,027 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+06)
  ld    h,(iy+CastleLevel1UnitsAvail+07)
  ld    b,081 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+08)
  ld    h,(iy+CastleLevel1UnitsAvail+09)
  ld    b,166 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle

  ld    l,(iy+CastleLevel1UnitsAvail+10)
  ld    h,(iy+CastleLevel1UnitsAvail+11)
  ld    b,251 - 25
  ld    c,083 ;HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastle
  ret
  
.army:
  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    a,(iy+CastleLevel1Units)        ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit1Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel2Units)        ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit2Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel3Units)        ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit3Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel4Units)        ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit4Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel5Units)        ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit5Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(iy+CastleLevel6Units)        ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit6Window         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,.Unit14x14SYSXTable
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

.Unit14x14SYSXTable:  
                dw $8000+(00*128)+(00/2)-128, $8000+(00*128)+(14/2)-128, $8000+(00*128)+(28/2)-128, $8000+(00*128)+(42/2)-128, $8000+(00*128)+(56/2)-128, $8000+(00*128)+(70/2)-128, $8000+(00*128)+(84/2)-128, $8000+(00*128)+(98/2)-128, $8000+(00*128)+(112/2)-128, $8000+(00*128)+(126/2)-128, $8000+(00*128)+(140/2)-128, $8000+(00*128)+(154/2)-128, $8000+(00*128)+(168/2)-128, $8000+(00*128)+(182/2)-128, $8000+(00*128)+(196/2)-128, $8000+(00*128)+(210/2)-128, $8000+(00*128)+(224/2)-128, $8000+(00*128)+(238/2)-128
                dw $8000+(14*128)+(00/2)-128, $8000+(14*128)+(14/2)-128, $8000+(14*128)+(28/2)-128, $8000+(14*128)+(42/2)-128, $8000+(14*128)+(56/2)-128, $8000+(14*128)+(70/2)-128, $8000+(14*128)+(84/2)-128, $8000+(14*128)+(98/2)-128, $8000+(14*128)+(112/2)-128, $8000+(14*128)+(126/2)-128, $8000+(14*128)+(140/2)-128, $8000+(14*128)+(154/2)-128, $8000+(14*128)+(168/2)-128, $8000+(14*128)+(182/2)-128, $8000+(14*128)+(196/2)-128, $8000+(14*128)+(210/2)-128, $8000+(14*128)+(224/2)-128, $8000+(14*128)+(238/2)-128
                dw $8000+(28*128)+(00/2)-128, $8000+(28*128)+(14/2)-128, $8000+(28*128)+(28/2)-128, $8000+(28*128)+(42/2)-128, $8000+(28*128)+(56/2)-128, $8000+(28*128)+(70/2)-128, $8000+(28*128)+(84/2)-128, $8000+(28*128)+(98/2)-128, $8000+(28*128)+(112/2)-128, $8000+(28*128)+(126/2)-128, $8000+(28*128)+(140/2)-128, $8000+(28*128)+(154/2)-128, $8000+(28*128)+(168/2)-128, $8000+(28*128)+(182/2)-128, $8000+(28*128)+(196/2)-128, $8000+(28*128)+(210/2)-128, $8000+(28*128)+(224/2)-128, $8000+(28*128)+(238/2)-128
                dw $8000+(42*128)+(00/2)-128, $8000+(42*128)+(14/2)-128, $8000+(42*128)+(28/2)-128, $8000+(42*128)+(42/2)-128, $8000+(42*128)+(56/2)-128, $8000+(42*128)+(70/2)-128, $8000+(42*128)+(84/2)-128, $8000+(42*128)+(98/2)-128, $8000+(42*128)+(112/2)-128, $8000+(42*128)+(126/2)-128, $8000+(42*128)+(140/2)-128, $8000+(42*128)+(154/2)-128, $8000+(42*128)+(168/2)-128, $8000+(42*128)+(182/2)-128, $8000+(42*128)+(196/2)-128, $8000+(42*128)+(210/2)-128, $8000+(42*128)+(224/2)-128, $8000+(42*128)+(238/2)-128
                dw $8000+(56*128)+(00/2)-128, $8000+(56*128)+(14/2)-128, $8000+(56*128)+(28/2)-128, $8000+(56*128)+(42/2)-128, $8000+(56*128)+(56/2)-128, $8000+(56*128)+(70/2)-128, $8000+(56*128)+(84/2)-128, $8000+(56*128)+(98/2)-128, $8000+(56*128)+(112/2)-128, $8000+(56*128)+(126/2)-128, $8000+(56*128)+(140/2)-128, $8000+(56*128)+(154/2)-128, $8000+(56*128)+(168/2)-128, $8000+(56*128)+(182/2)-128, $8000+(56*128)+(196/2)-128, $8000+(56*128)+(210/2)-128, $8000+(56*128)+(224/2)-128, $8000+(56*128)+(238/2)-128
                dw $8000+(70*128)+(00/2)-128, $8000+(70*128)+(14/2)-128, $8000+(70*128)+(28/2)-128, $8000+(70*128)+(42/2)-128, $8000+(70*128)+(56/2)-128, $8000+(70*128)+(70/2)-128, $8000+(70*128)+(84/2)-128, $8000+(70*128)+(98/2)-128, $8000+(70*128)+(112/2)-128, $8000+(70*128)+(126/2)-128, $8000+(70*128)+(140/2)-128, $8000+(70*128)+(154/2)-128, $8000+(70*128)+(168/2)-128, $8000+(70*128)+(182/2)-128, $8000+(70*128)+(196/2)-128, $8000+(70*128)+(210/2)-128, $8000+(70*128)+(224/2)-128, $8000+(70*128)+(238/2)-128
                dw $8000+(84*128)+(00/2)-128, $8000+(84*128)+(14/2)-128, $8000+(84*128)+(28/2)-128, $8000+(84*128)+(42/2)-128, $8000+(84*128)+(56/2)-128, $8000+(84*128)+(70/2)-128, $8000+(84*128)+(84/2)-128, $8000+(84*128)+(98/2)-128, $8000+(84*128)+(112/2)-128, $8000+(84*128)+(126/2)-128, $8000+(84*128)+(140/2)-128, $8000+(84*128)+(154/2)-128, $8000+(84*128)+(168/2)-128, $8000+(84*128)+(182/2)-128, $8000+(84*128)+(196/2)-128, $8000+(84*128)+(210/2)-128, $8000+(84*128)+(224/2)-128, $8000+(84*128)+(238/2)-128

;NXAndNY14x14CharaterPortraits:      equ 014*256 + (014/2)            ;(ny*256 + nx/2) = (14x14)
DYDXUnit1Window:               equ 038*128 + (008/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit2Window:               equ 038*128 + (092/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit3Window:               equ 038*128 + (176/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit4Window:               equ 094*128 + (008/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit5Window:               equ 094*128 + (092/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit6Window:               equ 094*128 + (176/2) - 128      ;(dy*128 + dx/2) = (204,153)


SetNumber16BitCastle:                   ;in hl=number (16bit)
;  ld    a,"0"                           ;we can set number to 0, then do a zero check and jr z,.zero to put the number 0 at the furthest left side if needed
;  ld    (TextNumber),a
;  ld    a,255
;  ld    (TextNumber+1),a

  ld    a,b                             ;dx
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c                             ;dy
  ld    (PutLetter+dy),a                ;set dy of text

;  ld    a,h
;  cp    l
;  ret   z
;  jr    z,.Zero

  push  iy
  call  .ConvertToDecimal16bit
  pop   iy

;  .Zero:
  ld    hl,TextNumber
  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dy of text
  call  SetTextBuildingWhenClicked.SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set dy of text
  ret



  .ConvertToDecimal16bit:
  ld    iy,TextNumber
  ld    e,0                             ;e=has an xfold already been set prior ?

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
  ld    e,1                             ;e=has an xfold already been set prior ?
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
  bit   0,e
  jr    nz,.DoSet1000Fold    
  ld    a,d
  cp    $30
  jr    z,.EndSet1000Fold  
  ld    e,1                             ;e=has an xfold already been set prior ?
  .DoSet1000Fold:
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
  bit   0,e
  jr    nz,.DoSet100Fold  
  ld    a,d
  cp    $30
  jr    nz,.DoSet100Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,4
  ld    (PutLetter+dx),a                ;set dx of text


  jr    .EndSet100Fold  

  .DoSet100Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
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
  bit   0,e
  jr    nz,.DoSet10Fold
  ld    a,d
  cp    $30
  jr    nz,.DoSet10Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,3
  ld    (PutLetter+dx),a                ;set dx of text

  jr    .EndSet10Fold  

  .DoSet10Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
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
 
 
















CastleOverviewBuildCode:                ;in: iy-castle



  ld    iy,Castle1



  call  Set9BuildButtons                ;check which buttons should be blue, green and red

  ld    hl,CastleOverviewPalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  call  SetBuildGraphics                ;put gfx in page 1
  ld    hl,CopyPage1To0
  call  docopy

  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,%1100 0011
  ld    (BuildButtonTable+0*BuildButtonTableLenghtPerButton),a ;castle
  ld    (BuildButtonTable+1*BuildButtonTableLenghtPerButton),a ;market place
  ld    (BuildButtonTable+2*BuildButtonTableLenghtPerButton),a ;tavern
  ld    (BuildButtonTable+3*BuildButtonTableLenghtPerButton),a ;magic guild
  ld    (BuildButtonTable+4*BuildButtonTableLenghtPerButton),a ;sawmill
  ld    (BuildButtonTable+5*BuildButtonTableLenghtPerButton),a ;mine
  ld    (BuildButtonTable+6*BuildButtonTableLenghtPerButton),a ;barracks
  ld    (BuildButtonTable+7*BuildButtonTableLenghtPerButton),a ;barracks tower
  ld    (BuildButtonTable+8*BuildButtonTableLenghtPerButton),a ;city walls

  ld    hl,SetSingleBuildButtonColor.putgreen
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir

  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt


  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ;buttons in the bottom of screen
  ld    ix,CastleOverviewButtonTable 
  call  CheckButtonMouseInteractionCastle

  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram
  ;/buttons in the bottom of screen

  ;9 build buttons
  ld    ix,BuildButtonTable 
  call  CheckButtonMouseInteractionBuildButtons

  ld    ix,BuildButtonTable
  call  SetBuildButtons                 ;copies button state from rom -> vram
  call  SetTextBuildingWhenClicked      ;when a building is clicked display text on the right side
;  call  SetSingleBuildButtonColor      ;is integrated in the above code
  ;/9 build buttons

  ;single build button
  ld    ix,SingleBuildButtonTable 
  call  CheckButtonMouseInteractionSingleBuildButton

  ld    ix,SingleBuildButtonTable
  call  SetSingleBuildButton            ;copies button state from rom -> vram
  ;/single build button


  halt
  jp  .engine










CheckButtonMouseInteractionSingleBuildButton:  
  bit   7,(ix+BuildButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+BuildButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+BuildButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonXright)
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
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+BuildButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+BuildButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  ld    (ix+BuildButtonStatus),%1010 0011

  ;only build if single build button is blue
  ld    a,(SingleBuildButtonTable+1)
  ld    e,a
  ld    a,(SingleBuildButtonTable+2)
  ld    d,a
  ld    hl,$4000 + (148*128) + (144/2) - 128
  xor   a
  sbc   hl,de
  ret   nz
  

  ld    a,(WhichBuildingWasClicked?)
  cp    1                                     ;city walls
  jr    z,.CityWalls
  cp    2                                     ;barracks tower
  jr    z,.BarracksTower
  cp    3                                     ;barracks
  jr    z,.Barracks
  cp    4                                     ;mine
  jr    z,.Mine
  cp    5                                     ;sawmill
  jr    z,.Sawmill
  cp    6                                     ;magic guild
  jr    z,.MagicGuild
  cp    7                                     ;tavern
  jr    z,.Tavern
  cp    8                                     ;market place
  jr    z,.MarketPlace
  cp    9                                     ;castle
  jr    z,.Castle

  .CityWalls:  
  .Castle:
  inc   (iy+CastleLevel)
  pop   af
  jp    CastleOverviewBuildCode

  .MarketPlace:  
  ld    (iy+CastleMarket),1
  pop   af
  jp    CastleOverviewBuildCode

  .Tavern:
  ld    (iy+CastleTavern),1
  pop   af
  jp    CastleOverviewBuildCode

  .MagicGuild:
  inc   (iy+CastleMageGuildLevel)
  pop   af
  jp    CastleOverviewBuildCode

  .Sawmill:
  inc   (iy+CastleSawmillLevel)
  pop   af
  jp    CastleOverviewBuildCode

  .Mine:
  inc   (iy+CastleMineLevel)
  pop   af
  jp    CastleOverviewBuildCode

  .BarracksTower:
  .Barracks:
  inc   (iy+CastleBarracksLevel)
  pop   af
  jp    CastleOverviewBuildCode












SetSingleBuildButton:                   ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  bit   7,(ix+BuildButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+BuildButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+BuildButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+BuildButtonStatus)
  res   1,(ix+BuildButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+BuildButton_SYSX_Ontouched)
  ld    h,(ix+BuildButton_SYSX_Ontouched+1)
  bit   6,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_MovedOver)
  ld    h,(ix+BuildButton_SYSX_MovedOver+1)
  bit   5,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_Clicked)
  ld    h,(ix+BuildButton_SYSX_Clicked+1)
  .go:

  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$0000 + (168*128) + (180/2) - 128  ;dy,dx
  ld    bc,$0000 + (009*256) + (072/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  halt
  ret















Set9BuildButtons:                       ;check which buttons should be blue, green and red
  call  .Castle
  call  .MarketPlace
  call  .Tavern
  call  .MagicGuild
  call  .Sawmill
  call  .Mine
  call  .Barracks
  call  .BarracksTower
  call  .CityWalls
  ret

  .CityWalls:
  ld    de,BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleLevel)
  cp    6
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,CityWallsCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .BarracksTower:
  ld    de,BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleBarracksLevel)
  cp    6
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,BarracksTowerCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Barracks:
  ld    de,BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleBarracksLevel)
  cp    5
  jp    nc,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,BarracksLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet


  .Mine:
  ld    de,BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMineLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MineLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Sawmill:
  ld    de,BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleSawmillLevel)
  cp    3
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,SawmillLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .MagicGuild:
  ld    de,BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleMageGuildLevel)
  cp    4
  jp    z,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MagicGuildLevel1Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet

  .Tavern:
  ld    de,BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton)
  bit   0,(iy+CastleTavern)
  jp    nz,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,TavernCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet
  
  .MarketPlace:
  ld    de,BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton)
  bit   0,(iy+CastleMarket)
  jp    nz,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,MarketPlaceCost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet
    
  .Castle:
  ld    de,BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton)
  ld    a,(iy+CastleLevel)
  cp    5
  jp    nc,.Green
  bit   0,(iy+AlreadyBuiltThisTurn?)
  jp    nz,.Red
  ld    hl,CastleLevel2Cost
  ld    (CheckRequirementsWhichBuilding?),hl
  jp    .CheckRequirementsBuildingMet
  
  .Blue:
  ld    hl,.BlueButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret
  
  .Red:
  ld    hl,.RedButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret
  
  .Green:
  ld    hl,.GreenButton
  ld    bc,6                            ;6 bytes for the button in its 3 states
  ldir
  ret

.BlueButton:  dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128
.GreenButton: dw $4000 + (000*128) + (150/2) - 128 | dw $4000 + (000*128) + (200/2) - 128 | dw $4000 + (038*128) + (000/2) - 128
.RedButton:   dw $4000 + (038*128) + (050/2) - 128 | dw $4000 + (038*128) + (100/2) - 128 | dw $4000 + (038*128) + (150/2) - 128

.CheckRequirementsBuildingMet:
  ;check if gold requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;Gold
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+0)
  ld    b,(ix+1)                        ;Gold
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if wood requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+2)
  ld    h,(ix+3)                        ;Wood
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+2)
  ld    b,(ix+3)                        ;Wood
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if ore requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+4)
  ld    h,(ix+5)                        ;Ore
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+4)
  ld    b,(ix+5)                        ;Ore
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if gems requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+6)
  ld    h,(ix+7)                        ;Gems
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+6)
  ld    b,(ix+7)                        ;Gems
  xor   a
  sbc   hl,bc
  jp    c,.Red  

  ;check if rubies requirements for this building are met
  call  SetResourcesCurrentPlayerinIX
  ld    l,(ix+8)
  ld    h,(ix+9)                        ;Rubies
  ld    ix,(CheckRequirementsWhichBuilding?)
  ld    c,(ix+8)
  ld    b,(ix+9)                        ;Rubies
  xor   a
  sbc   hl,bc
  jp    c,.Red  
  jp    .Blue  

CastleLevel2Cost:
.Gold:    dw  2000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

MarketPlaceCost:
.Gold:    dw  2000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

TavernCost:
.Gold:    dw  2000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

MagicGuildLevel1Cost:
.Gold:    dw  2000
.Wood:    dw  301
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

SawmillLevel1Cost:
.Gold:    dw  2001
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

MineLevel1Cost:
.Gold:    dw  2000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

BarracksLevel1Cost:
.Gold:    dw  2000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

BarracksTowerCost:
.Gold:    dw  2000
.Wood:    dw  301
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

CityWallsCost:
.Gold:    dw  2000
.Wood:    dw  301
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

SetResourcesCurrentPlayerinIX:
	ld		a,(whichplayernowplaying?)
  ld    ix,ResourcesPlayer1
  cp    1
  ret   z
  ld    ix,ResourcesPlayer2
  cp    2
  ret   z
  ld    ix,ResourcesPlayer3
  cp    3
  ret   z
  ld    ix,ResourcesPlayer4
  cp    4
  ret   z
  ret

SetSingleBuildButtonColor:
  push  iy

  ld    a,(WhichBuildingWasClicked?)

  cp    1                                     ;city walls
  ld    iy,BuildButtonTable+1+(8*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    2                                     ;barracks tower
  ld    iy,BuildButtonTable+1+(7*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    3                                     ;barracks
  ld    iy,BuildButtonTable+1+(6*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    4                                     ;mine
  ld    iy,BuildButtonTable+1+(5*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    5                                     ;sawmill
  ld    iy,BuildButtonTable+1+(4*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    6                                     ;magic guild
  ld    iy,BuildButtonTable+1+(3*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    7                                     ;tavern
  ld    iy,BuildButtonTable+1+(2*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    8                                     ;market place
  ld    iy,BuildButtonTable+1+(1*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound
  cp    9                                     ;castle
  ld    iy,BuildButtonTable+1+(0*BuildButtonTableLenghtPerButton)
  jr    z,.BuildingFound


  .BuildingFound:
  ld    e,(iy)
  ld    d,(iy+1)                              ;Button_SYSX_Ontouched

  pop   iy

  ld    hl,$4000 + (000*128) + (000/2) - 128  ;blue button
  xor   a
  sbc   hl,de
  jr    z,.blue
  
  ld    hl,$4000 + (000*128) + (150/2) - 128  ;green button
  xor   a
  sbc   hl,de
  jr    z,.green

  ld    hl,$4000 + (038*128) + (050/2) - 128  ;red button
  xor   a
  sbc   hl,de
  jr    z,.red

  
  .red:
  ld    hl,.putred
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret
  
  .green:
  ld    hl,.putgreen
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret
  
  .blue:
  ld    hl,.putblue
  ld    de,SingleBuildButtonTable
  ld    bc,7
  ldir
  ret

.putred:    db  %1100 0011 | dw $4000 + (148*128) + (072/2) - 128 | dw $4000 + (148*128) + (072/2) - 128 | dw $4000 + (148*128) + (072/2) - 128
.putgreen:  db  %1100 0011 | dw $4000 + (148*128) + (000/2) - 128 | dw $4000 + (148*128) + (000/2) - 128 | dw $4000 + (148*128) + (000/2) - 128
.putblue:   db  %1100 0011 | dw $4000 + (148*128) + (144/2) - 128 | dw $4000 + (157*128) + (000/2) - 128 | dw $4000 + (157*128) + (072/2) - 128



SetTextBuildingWhenClicked:
  ld    a,(SetTextBuilding)
  dec   a
  ret   z
  ld    (SetTextBuilding),a
  
  call  ClearTextBuildWindow
  call  SetSingleBuildButtonColor
  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  ld    hl,(PutWhichBuildText)
  ld    a,182
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,047
  ld    (PutLetter+dy),a                ;set dy of text

  ld    (TextAddresspointer),hl  

  ld    a,6
  ld    (PutLetter+ny),a                ;set ny of text
  call  .SetText
  ld    a,5
  ld    (PutLetter+ny),a                ;set ny of text
  ret

  .SetText:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
  ld    (PutLetter+dPage),a             ;set page where to put text

  ld    a,-1
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
  cp    TextPlusSymbol                  ;+
  jr    z,.TextPlusSymbol
  cp    TextMinusSymbol                 ;-
  jr    z,.TextMinusSymbol
  cp    TextApostrofeSymbol             ;'
  jr    z,.TextApostrofeSymbol
  cp    TextColonSymbol                 ;/
  jr    z,.TextColonSymbol


  cp    TextNumber0+10
  jr    c,.Number


  sub   $41
  ld    hl,.TextCoordinateTable  
  add   a,a                             ;*2
  ld    d,0
  ld    e,a

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

  ld    hl,.TextNumberSymbolsSXNX
  add   hl,de
  jr    .GoPutLetter
  
  .TextPercentageSymbol:
  ld    hl,.TextPercentageSymbolSXNX  
  jr    .GoPutLetter

  .TextPlusSymbol:
  ld    hl,.TextPlusSymbolSXNX  
  jr    .GoPutLetter

  .TextMinusSymbol:
  ld    hl,.TextMinusSymbolSXNX  
  jr    .GoPutLetter

  .TextApostrofeSymbol:
  ld    hl,.TextApostrofeSymbolSXNX  
  jr    .GoPutLetter

  .TextColonSymbol:
  ld    hl,.TextColonSymbolSXNX  
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


;                          0       1       2       3       4       5       6       7       8       9
.TextNumberSymbolsSXNX: db 171,4,  175,2,  177,4,  181,3,  184,3,  187,4,  191,4,  195,4,  199,4,  203,4,  158,4  
.TextSlashSymbolSXNX: db  158+49,4  ;"/"
.TextPercentageSymbolSXNX: db  162+49,4 ;"%"
.TextPlusSymbolSXNX: db  166+49,5 ;"+"
.TextMinusSymbolSXNX: db  169+49,5 ;"-"
.TextApostrofeSymbolSXNX: db  195,1  ;"'"
.TextColonSymbolSXNX: db  008,1  ;":"

;                               A      B      C      D      E      F      G      H      I      J      K      L      M      N      O      P      Q      R      S      T      U      V      W      X      Y      Z
.TextCoordinateTable:       db  084,3, 087,3, 090,3, 093,3, 096,3, 099,3, 102,5, 107,3, 110,3, 113,3, 116,4, 120,3, 123,6, 129,4, 133,3, 136,3, 139,3, 142,3, 145,3, 148,3, 151,3, 154,3, 157,5, 162,3, 165,3, 168,3
;                               a      b      c      d      e      f      g      h      i      j      k      l      m      n      o      p      q      r      s      t      u      v      w      x      y      z     
ds 12
.TextCoordinateTableSmall:  db  000,4, 004,3, 007,3, 010,3, 013,3, 016,2, 018,4, 022,3, 025,1, 026,2, 028,4, 032,1, 033,5, 038,4, 042,4, 046,4, 050,4, 054,2, 056,4, 060,2, 062,3, 065,3, 068,5, 073,3, 076,4, 080,4






































CheckButtonMouseInteractionBuildButtons:
  ld    b,9
  ld    de,BuildButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+BuildButtonStatus)        ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+BuildButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+BuildButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+BuildButtonXright)
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
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+BuildButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+BuildButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+BuildButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+BuildButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  ld    (ix+BuildButtonStatus),%1010 0011

  ld    a,3
  ld    (SetTextBuilding),a

  ld    a,b
  cp    1                                     ;CityWalls
  ld    hl,TextCityWalls
  jp    z,.SetWhichTextToPut
  cp    2                                     ;BarracksTower
  ld    hl,TextBarracksTower
  jp    z,.SetWhichTextToPut
  cp    3                                     ;Barracks
  jp    z,.Barracks
  cp    4                                     ;Mine
  jp    z,.Mine
  cp    5                                     ;Sawmill
  jp    z,.Sawmill
  cp    6                                     ;MagicGuild
  jp    z,.MagicGuild
  cp    7                                     ;Tavern
  ld    hl,TextTavern
  jp    z,.SetWhichTextToPut
  cp    8                                     ;MarketPlace
  ld    hl,TextMarketPlace
  jp    z,.SetWhichTextToPut
  cp    9                                     ;Castle
  jp    z,.Castle

  .Barracks:
  ld    a,(iy+CastleBarracksLevel)
  cp    0
  ld    hl,TextBarracksLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    hl,TextBarracksLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    hl,TextBarracksLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    hl,TextBarracksLevel4
  jp    z,.SetWhichTextToPut
  cp    4
  ld    hl,TextBarracksLevel5
  jp    .SetWhichTextToPut

  .Mine:
  ld    a,(iy+CastleMineLevel)
  cp    0
  ld    hl,TextMineLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    hl,TextMineLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    hl,TextMineLevel3
  jp    .SetWhichTextToPut

  .Sawmill:
  ld    a,(iy+CastleSawmillLevel)
  cp    0
  ld    hl,TextSawmillLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    hl,TextSawmillLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    hl,TextSawmillLevel3
  jp    .SetWhichTextToPut

  .MagicGuild:
  ld    a,(iy+CastleMageGuildLevel)
  cp    0
  ld    hl,TextMagicGuildLevel1
  jp    z,.SetWhichTextToPut
  cp    1
  ld    hl,TextMagicGuildLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    hl,TextMagicGuildLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    hl,TextMagicGuildLevel4
  jp    .SetWhichTextToPut

  .Castle:
  ld    a,(iy+CastleLevel)
  cp    1
  ld    hl,TextCastleLevel2
  jp    z,.SetWhichTextToPut
  cp    2
  ld    hl,TextCastleLevel3
  jp    z,.SetWhichTextToPut
  cp    3
  ld    hl,TextCastleLevel4
  jp    z,.SetWhichTextToPut
  cp    4
  ld    hl,TextCastleLevel5
  jp    .SetWhichTextToPut


  .SetWhichTextToPut:
  ld    (PutWhichBuildText),hl
  ld    a,b
  ld    (WhichBuildingWasClicked?),a
  ret

TextCastleLevel2:        
                          db  " Castle level 2",254
                          db  " ",254
                          db  "Generates 1000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextCastleLevel3:        
                          db  " Castle level 3",254
                          db  " ",254
                          db  "Generates 1500",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextCastleLevel4:        
                          db  " Castle level 4",254
                          db  " ",254
                          db  "Generates 2000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextCastleLevel5:        
                          db  " Castle level 5",254
                          db  " ",254
                          db  "Generates 3000",254
                          db  "gold per day",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255


                          
TextMarketPlace:        
                          db  " Market Place",254
                          db  " ",254
                          db  "Allows trading of",254
                          db  "resources",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255

TextTavern:        
                          db  "    Tavern",254
                          db  " ",254
                          db  "Allows recruitment",254
                          db  "of visiting",254
                          db  "heroes",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255

TextMagicGuildLevel1:        
                          db  " Magic Guild 1",254
                          db  " ",254
                          db  "Teaches visiting",254
                          db  "heroes 2nd level",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "5 Stones",254
                          db  "1 Ruby",254
                          db  " ",254
                          db  "Requires:",254
                          db  "Magic Guild 1",255
TextMagicGuildLevel2:        
                          db  " Magic Guild 2",254
                          db  " ",254
                          db  "Teaches visiting",254
                          db  "heroes 2nd level",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "5 Stones",254
                          db  "1 Ruby",254
                          db  " ",254
                          db  "Requires:",254
                          db  "Magic Guild 1",255
TextMagicGuildLevel3:        
                          db  " Magic Guild 3",254
                          db  " ",254
                          db  "Teaches visiting",254
                          db  "heroes 2nd level",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "5 Stones",254
                          db  "1 Ruby",254
                          db  " ",254
                          db  "Requires:",254
                          db  "Magic Guild 1",255
TextMagicGuildLevel4:        
                          db  " Magic Guild 4",254
                          db  " ",254
                          db  "Teaches visiting",254
                          db  "heroes 2nd level",254
                          db  "spells",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",254
                          db  "5 Stones",254
                          db  "1 Ruby",254
                          db  " ",254
                          db  "Requires:",254
                          db  "Magic Guild 1",255

TextSawmillLevel1:        
                          db  "  Sawmill 1",254
                          db  " ",254
                          db  "produces 1 wood",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextSawmillLevel2:        
                          db  "  Sawmill 2",254
                          db  " ",254
                          db  "produces 1 wood",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextSawmillLevel3:        
                          db  "  Sawmill 3",254
                          db  " ",254
                          db  "produces 1 wood",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255

TextMineLevel1:        
                          db  "   Mine 1",254
                          db  " ",254
                          db  "produces 1 ore",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextMineLevel2:        
                          db  "   Mine 2",254
                          db  " ",254
                          db  "produces 1 ore",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextMineLevel3:        
                          db  "   Mine 3",254
                          db  " ",254
                          db  "produces 1 ore",254
                          db  "per turn",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255

TextBarracksLevel1:        
                          db  "  Barracks 1",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 1 units",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextBarracksLevel2:        
                          db  "  Barracks 2",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 1 units",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextBarracksLevel3:        
                          db  "  Barracks 3",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 1 units",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextBarracksLevel4:        
                          db  "  Barracks 4",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 1 units",254
                          db  "Cost:",254
                          db  "2000 Gold",255
TextBarracksLevel5:        
                          db  "  Barracks 5",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 1 units",254
                          db  "Cost:",254
                          db  "2000 Gold",255

TextBarracksTower:        
                          db  " Barracks Tower",254
                          db  " ",254
                          db  "allows production",254
                          db  "of level 6 units",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
                          
TextCityWalls:        
                          db  "   City Walls",254
                          db  " ",254
                          db  "fortifies your",254
                          db  "city with a wall",254
                          db  " to defend",254
                          db  "against sieges",254
                          db  " ",254
                          db  "Cost:",254
                          db  "2000 Gold",255
















SetBuildButtons:                        ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,9
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,BuildButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+BuildButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+BuildButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+BuildButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+BuildButtonStatus)
  res   1,(ix+BuildButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+BuildButton_SYSX_Ontouched)
  ld    h,(ix+BuildButton_SYSX_Ontouched+1)
  bit   6,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_MovedOver)
  ld    h,(ix+BuildButton_SYSX_MovedOver+1)
  bit   5,(ix+BuildButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+BuildButton_SYSX_Clicked)
  ld    h,(ix+BuildButton_SYSX_Clicked+1)
  .go:

  ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$0000 + (212*128) + (000/2) - 128  ;dy,dx
  ld    bc,$0000 + (038*256) + (050/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverviewOnlyCopyToPage1          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyBuildButton+dPage),a
	ld    (CopyBuildButtonImage+dPage),a

  ;set dx, dy button and button image
  ld    a,(ix+BuildButtonYtop)
  ld    (CopyBuildButton+dy),a
  ld    (CopyBuildButtonImage+dy),a
  ld    a,(ix+BuildButtonXleft)
  ld    (CopyBuildButton+dx),a
  ld    (CopyBuildButtonImage+dx),a

  ld    hl,CopyBuildButton
  call  docopy

  ;copy image on top of button
  ld    l,(ix+BuildButtonImage_SYSX)
  ld    h,(ix+BuildButtonImage_SYSX+1)
  ld    de,$0000 + (212*128) + (050/2) - 128  ;dy,dx
  ld    bc,$0000 + (033*256) + (050/2)        ;ny,nx
  ld    a,ButtonsBuildBlock                   ;buttons block
  call  CopyRamToVramCorrectedCastleOverviewOnlyCopyToPage1          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
  ld    hl,CopyBuildButtonImage
  call  docopy
  halt
  ret


























CastleOverviewCode:                     ;in: iy-castle






  ld    iy,Castle1






  ld    hl,CastleOverviewPalette
  call  SetPalette

  xor   a
	ld		(activepage),a                  ;start in page 0

  call  SetCastleOverviewGraphics       ;put gfx in page 1
  call  SwapAndSetPage                  ;swap to and set page 1
  call  SetIndividualBuildings          ;put buildings in page 0, then docopy them from page 0 to page 1 transparantly
  ld    hl,CopyPage1To0
  call  docopy
  call  SetActiveCastleOverviewButtons

  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt
  halt


  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz


  ld    ix,CastleOverviewButtonTable ;  ld    iy,ButtonTableArmyIconsSYSX (;deze shit mag erin verwerkt zijn)
  call  CheckButtonMouseInteractionCastle


  ld    ix,CastleOverviewButtonTable
  call  SetCastleButtons                ;copies button state from rom -> vram




  halt
  jp  .engine


SetActiveCastleOverviewButtons:
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+0*CastleOverviewButtonTableLenghtPerButton),a ;build
  ld    (CastleOverviewButtonTable+5*CastleOverviewButtonTableLenghtPerButton),a ;exit
  xor   a
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes

  ld    a,(iy+CastleBarracksLevel)
  or    a
  jr    z,.EndCheckBarracks
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+1*CastleOverviewButtonTableLenghtPerButton),a ;recruit
  .EndCheckBarracks:

  ld    a,(iy+CastleMageGuildLevel)
  or    a
  jr    z,.EndCheckMageGuild
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+2*CastleOverviewButtonTableLenghtPerButton),a ;magic guild
  .EndCheckMageGuild:

  ld    a,(iy+CastleMarket)
  or    a
  jr    z,.EndCheckMarket
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+3*CastleOverviewButtonTableLenghtPerButton),a ;trade
  .EndCheckMarket:

  ld    a,(iy+CastleTavern)
  or    a
  jr    z,.EndCheckTavern
  ld    a,%1100 0011
  ld    (CastleOverviewButtonTable+4*CastleOverviewButtonTableLenghtPerButton),a ;heroes
  .EndCheckTavern:
  ret

SetCastleButtons:                       ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    b,6
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,CastleOverviewButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+CastleOverviewWindowButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.bit0isSet
  bit   1,(ix+CastleOverviewWindowButtonStatus)
  ret   z
  
  .bit1isSet:
  res   1,(ix+CastleOverviewWindowButtonStatus)
  jr    .goCopyButton
  .bit0isSet:
  res   0,(ix+CastleOverviewWindowButtonStatus)  
  .goCopyButton:

  ld    l,(ix+CastleOverviewWindowButton_SYSX_Ontouched)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_Ontouched+1)
  bit   6,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+CastleOverviewWindowButton_SYSX_MovedOver)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_MovedOver+1)
  bit   5,(ix+CastleOverviewWindowButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+CastleOverviewWindowButton_SYSX_Clicked)
  ld    h,(ix+CastleOverviewWindowButton_SYSX_Clicked+1)
;  bit   4,(ix+CastleOverviewWindowButtonStatus)
;  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)  
  .go:

;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$0000 + (212*128) + (012/2) - 128  ;dy,dx
  ld    bc,$0000 + (031*256) + (040/2)        ;ny,nx
  ld    a,ButtonsBlock                  ;buttons block
  call  CopyRamToVramCorrectedCastleOverviewOnlyCopyToPage1          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton+dPage),a

  ld    a,(ix+CastleOverviewWindowButton_dx)
  ld    (CopyCastleButton+dx),a

  ld    hl,CopyCastleButton
  call  docopy
  halt
  ret

CheckButtonMouseInteractionCastle:
  ld    b,6
  ld    de,CastleOverviewButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+CastleOverviewWindowButtonStatus)
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+CastleOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse
  cp    (ix+CastleOverviewWindowButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+CastleOverviewWindowButtonXright)
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
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+CastleOverviewWindowButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+CastleOverviewWindowButtonStatus) ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+CastleOverviewWindowButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  ld    a,b
  cp    1                                     ;exit
  jr    nz,.EndCheckExit
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  ret
  .EndCheckExit:

  cp    2                                     ;tavern
  jr    nz,.EndCheckTavern
  ret
  .EndCheckTavern:

  cp    3                                     ;market
  jr    nz,.EndCheckMarket
  ;market place
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewMarketPlaceCode         ;jump to the market place code
  .EndCheckMarket:

  cp    4                                     ;magic guild
  jr    nz,.EndCheckMagicGuild
  ;magic guild
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewMagicGuildCode          ;jump to the magic guild code
  .EndCheckMagicGuild:

  cp    5                                     ;recruit
  jr    nz,.EndCheckRecruit
  ;build
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewRecruitCode             ;jump to the recruit code
  .EndCheckRecruit:

  ;build
  pop   af                                    ;pop the call in the button check loop 
  pop   af                                    ;pop the call to the CastleOverViewCode
  jp    CastleOverviewBuildCode               ;jump to the build code

SetIndividualBuildings:
;barracks
  ld    a,(iy+CastleBarracksLevel)
  or    a
  jr    z,.EndCheckBarracks
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (057*128) + (176/2) - 128  ;y,x
  ld    bc,$0000 + (101*256) + (080/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyBarracks
  call  docopy
  .EndCheckBarracks:

;barracks upgrade
  ld    a,(iy+CastleBarracksLevel)
  cp    6
  jr    nz,.EndCheckBarracksUpgrade
  ld    hl,$4000 + (100*128) + (160/2) - 128  ;y,x
  ld    de,$0000 + (006*128) + (202/2) - 128  ;y,x
  ld    bc,$0000 + (088*256) + (048/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyBarracksUpgrade
  call  docopy
  .EndCheckBarracksUpgrade:

;sawmill
  ld    a,(iy+CastleSawmillLevel)
  or    a
  jr    z,.EndCheckSawmill
  ld    hl,$4000 + (101*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (101*128) + (032/2) - 128  ;y,x
  ld    bc,$0000 + (035*256) + (060/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopySawmill
  call  docopy
  .EndCheckSawmill:

;mine
  ld    a,(iy+CastleMineLevel)
  or    a
  jr    z,.EndCheckMine
  ld    hl,$4000 + (136*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (150*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (052*256) + (126/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyMine
  call  docopy
  .EndCheckMine:

;mage guild
  ld    a,(iy+CastleMageGuildLevel)
  or    a
  jr    z,.EndCheckMageGuild
  ld    hl,$4000 + (000*128) + (208/2) - 128  ;y,x
  ld    de,$0000 + (019*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (168*256) + (048/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock      ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyMageGuild
  call  docopy
  .EndCheckMageGuild:

;tavern
  ld    a,(iy+CastleTavern)
  or    a
  jr    z,.EndCheckTavern
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (097*128) + (060/2) - 128  ;y,x
  ld    bc,$0000 + (115*256) + (158/2)        ;ny,nx
  ld    a,IndividualBuildingsPage2Block       ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyTavern
  call  docopy
  .EndCheckTavern:

;market
  ld    a,(iy+CastleMarket)
  or    a
  jr    z,.EndCheckMarket
  ld    hl,$4000 + (000*128) + (080/2) - 128  ;y,x
  ld    de,$0000 + (000*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (088*256) + (090/2)        ;ny,nx
  ld    a,IndividualBuildingsBlock            ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyChamberOfCommerce
  call  docopy
  .EndCheckMarket:

;city walls
  ld    a,(iy+CastleLevel)
  cp    6
  jr    nz,.EndCheckCityWalls
  ld    hl,$4000 + (115*128) + (000/2) - 128  ;y,x
  ld    de,$0000 + (185*128) + (000/2) - 128  ;y,x
  ld    bc,$0000 + (027*256) + (256/2)        ;ny,nx
  ld    a,IndividualBuildingsPage2Block       ;font graphics block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,CopyCityWalls
  call  docopy
  .EndCheckCityWalls:
  ret

SetCastleOverviewGraphics:              
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,CastleOverviewBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetBuildGraphics:              
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

ClearTextBuildWindow:
  ld    hl,$4000 + (046*128) + (180/2) - 128
  ld    de,$0000 + (046*128) + (180/2) - 128
  ld    bc,$0000 + (131*256) + (072/2)
  ld    a,BuildBlock                    ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetCastleOverViewFontPage0Y212:           ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
;  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
SetRecruitGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,RecruitCreaturesBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetMagicGuildGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,MagicGuildBlock                 ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetMarketPlaceGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,ChamberOfCommerceBlock          ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

CopyBarracks:
	db		176,0,057,0
	db		176,0,057,1
	db		080,0,101,0
	db		0,%0000 0000,$98

CopyBarracksUpgrade:
	db		202,0,006,0
	db		202,0,006,1
	db		048,0,088,0
	db		0,%0000 0000,$98

CopySawmill:
	db		032,0,101,0
	db		032,0,101,1
	db		060,0,035,0
	db		0,%0000 0000,$98

CopyMine:
	db		000,0,150,0
	db		050,0,126,1
	db		126,0,052,0
	db		0,%0000 0000,$98

CopyMageGuild:
	db		000,0,019,0
	db		000,0,019,1
	db		048,0,168,0
	db		0,%0000 0000,$98

CopyTavern:
	db		060,0,097,0
	db		060,0,097,1
	db		158,0,115,0
	db		0,%0000 0000,$98

CopyChamberOfCommerce:
	db		000,0,000,0
	db		166,0,106,1
	db		090,0,088,0
	db		0,%0000 0000,$98

CopyCityWalls:
	db		000,0,185,0
	db		000,0,185,1
	db		000,1,027,0
	db		0,%0000 0000,$98






































