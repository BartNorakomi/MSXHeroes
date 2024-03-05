;  call  HeroOverviewCode
;  call  HeroOverviewSkillsWindowCode
;  call  HeroOverviewSpellBookWindowCode_Earth
;  call  HeroOverviewSpellBookWindowCode_Fire
;  call  HeroOverviewSpellBookWindowCode_Water
;  call  HeroOverviewSpellBookWindowCode_Air
;  call  HeroOverviewInventoryWindowCode
;  call  HeroOverviewArmyWindowCode
;  call  HeroOverviewStatusWindowCode

HeroOverViewFirstWindowchoicesSX:   equ 000
HeroOverViewFirstWindowchoicesSY:   equ 000
HeroOverViewFirstWindowchoicesDX:   equ 058 - 05
HeroOverViewFirstWindowchoicesDY:   equ 037
HeroOverViewFirstWindowchoicesNX:   equ 106
HeroOverViewFirstWindowchoicesNY:   equ 122

HeroOverViewFirstWindowButtonNY:  equ 011
HeroOverViewFirstWindowButtonNX:  equ 090

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewSkillsWindowSX:   equ 106
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
HeroOverViewStatusWindowNY:   equ 116

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewSpellBookWindowSX:   equ 000
HeroOverViewSpellBookWindowSY:   equ 000
HeroOverViewSpellBookWindowDX:   equ 006
HeroOverViewSpellBookWindowDY:   equ 009
HeroOverViewSpellBookWindowNX:   equ 192
HeroOverViewSpellBookWindowNY:   equ 184

HeroOverViewSpellBookWindowButton1NY:  equ 035 - 1
HeroOverViewSpellBookWindowButton1NX:  equ 010
HeroOverViewSpellBookWindowButton2NY:  equ 029 - 1
HeroOverViewSpellBookWindowButton2NX:  equ 010
HeroOverViewSpellBookWindowButton3NY:  equ 023 - 1
HeroOverViewSpellBookWindowButton3NX:  equ 010
HeroOverViewSpellBookWindowButton4NY:  equ 035
HeroOverViewSpellBookWindowButton4NX:  equ 010

HeroOverViewSpellIconWindowButtonNY:  equ 016
HeroOverViewSpellIconWindowButtonNX:  equ 016

HeroOverViewInventoryIconWindowButtonNY:  equ 020
HeroOverViewInventoryIconWindowButtonNX:  equ 020


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewSpellBackdropSX:   equ 192
HeroOverViewSpellBackdropSY:   equ 122
HeroOverViewSpell1backdropDY:  equ HeroOverViewSpellBookWindowDY + 044
HeroOverViewSpell1backdropDX:  equ HeroOverViewSpellBookWindowDX + 034
HeroOverViewSpellbackdropNX:   equ 028
HeroOverViewSpellbackdropNY:   equ 028

HeroOverViewSpell2backdropDY:  equ HeroOverViewSpellBookWindowDY + 048
HeroOverViewSpell2backdropDX:  equ HeroOverViewSpellBookWindowDX + 064
HeroOverViewSpell3backdropDY:  equ HeroOverViewSpellBookWindowDY + 089
HeroOverViewSpell3backdropDX:  equ HeroOverViewSpellBookWindowDX + 032
HeroOverViewSpell4backdropDY:  equ HeroOverViewSpellBookWindowDY + 093
HeroOverViewSpell4backdropDX:  equ HeroOverViewSpellBookWindowDX + 062
HeroOverViewSpell5backdropDY:  equ HeroOverViewSpellBookWindowDY + 048
HeroOverViewSpell5backdropDX:  equ HeroOverViewSpellBookWindowDX + 102
HeroOverViewSpell6backdropDY:  equ HeroOverViewSpellBookWindowDY + 044
HeroOverViewSpell6backdropDX:  equ HeroOverViewSpellBookWindowDX + 132
HeroOverViewSpell7backdropDY:  equ HeroOverViewSpellBookWindowDY + 093
HeroOverViewSpell7backdropDX:  equ HeroOverViewSpellBookWindowDX + 104
HeroOverViewSpell8backdropDY:  equ HeroOverViewSpellBookWindowDY + 089
HeroOverViewSpell8backdropDX:  equ HeroOverViewSpellBookWindowDX + 134

;earth
Spell01IconSX:   equ 224
Spell01IconSY:   equ 000
Spell02IconSX:   equ 224
Spell02IconSY:   equ 016
Spell03IconSX:   equ 224
Spell03IconSY:   equ 032
Spell04IconSX:   equ 224
Spell04IconSY:   equ 048
;fire
Spell05IconSX:   equ 224
Spell05IconSY:   equ 064
Spell06IconSX:   equ 224
Spell06IconSY:   equ 080
Spell07IconSX:   equ 224
Spell07IconSY:   equ 096
Spell08IconSX:   equ 224
Spell08IconSY:   equ 112
;air
Spell09IconSX:   equ 224
Spell09IconSY:   equ 128
Spell10IconSX:   equ 224
Spell10IconSY:   equ 144
Spell11IconSX:   equ 224
Spell11IconSY:   equ 160
Spell12IconSX:   equ 224
Spell12IconSY:   equ 176
;water
Spell13IconSX:   equ 000
Spell13IconSY:   equ 184
Spell14IconSX:   equ 032
Spell14IconSY:   equ 184
Spell15IconSX:   equ 064
Spell15IconSY:   equ 184
Spell16IconSX:   equ 096
Spell16IconSY:   equ 184
;all spellschools
Spell17IconSX:   equ 128
Spell17IconSY:   equ 184
Spell18IconSX:   equ 160
Spell18IconSY:   equ 184
Spell19IconSX:   equ 192
Spell19IconSY:   equ 184
Spell20IconSX:   equ 192
Spell20IconSY:   equ 168


Spell1DY:  equ HeroOverViewSpellBookWindowDY + 050
Spell1DX:  equ HeroOverViewSpellBookWindowDX + 040
Spell2DY:  equ HeroOverViewSpellBookWindowDY + 054
Spell2DX:  equ HeroOverViewSpellBookWindowDX + 070
Spell3DY:  equ HeroOverViewSpellBookWindowDY + 095
Spell3DX:  equ HeroOverViewSpellBookWindowDX + 038
Spell4DY:  equ HeroOverViewSpellBookWindowDY + 099
Spell4DX:  equ HeroOverViewSpellBookWindowDX + 068
Spell5DY:  equ HeroOverViewSpellBookWindowDY + 054
Spell5DX:  equ HeroOverViewSpellBookWindowDX + 108
Spell6DY:  equ HeroOverViewSpellBookWindowDY + 050
Spell6DX:  equ HeroOverViewSpellBookWindowDX + 138
Spell7DY:  equ HeroOverViewSpellBookWindowDY + 099
Spell7DX:  equ HeroOverViewSpellBookWindowDX + 110
Spell8DY:  equ HeroOverViewSpellBookWindowDY + 095
Spell8DX:  equ HeroOverViewSpellBookWindowDX + 140

SpellIconNX:   equ 016
SpellIconNY:   equ 016

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewInventoryWindowSX:   equ 000
HeroOverViewInventoryWindowSY:   equ 000
HeroOverViewInventoryWindowDX:   equ 030
HeroOverViewInventoryWindowDY:   equ 024
HeroOverViewInventoryWindowNX:   equ 146
HeroOverViewInventoryWindowNY:   equ 156

InventoryItemNY:        equ 020
InventoryItemNx:        equ 020
;9 inventory slots
InventoryItem01DY:      equ HeroOverViewInventoryWindowDY + 028
InventoryItem01Dx:      equ HeroOverViewInventoryWindowDX + 020
InventoryItem02DY:      equ HeroOverViewInventoryWindowDY + 028
InventoryItem02Dx:      equ HeroOverViewInventoryWindowDX + 064
InventoryItem03DY:      equ HeroOverViewInventoryWindowDY + 028
InventoryItem03Dx:      equ HeroOverViewInventoryWindowDX + 108

InventoryItem04DY:      equ HeroOverViewInventoryWindowDY + 053
InventoryItem04Dx:      equ HeroOverViewInventoryWindowDX + 020
InventoryItem05DY:      equ HeroOverViewInventoryWindowDY + 053
InventoryItem05Dx:      equ HeroOverViewInventoryWindowDX + 064
InventoryItem06DY:      equ HeroOverViewInventoryWindowDY + 053
InventoryItem06Dx:      equ HeroOverViewInventoryWindowDX + 108

InventoryItem07DY:      equ HeroOverViewInventoryWindowDY + 078
InventoryItem07Dx:      equ HeroOverViewInventoryWindowDX + 020
InventoryItem08DY:      equ HeroOverViewInventoryWindowDY + 078
InventoryItem08Dx:      equ HeroOverViewInventoryWindowDX + 064
InventoryItem09DY:      equ HeroOverViewInventoryWindowDY + 078
InventoryItem09Dx:      equ HeroOverViewInventoryWindowDX + 108
;6 open slots
InventoryItem10DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem10Dx:      equ HeroOverViewInventoryWindowDX + 008
InventoryItem11DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem11Dx:      equ HeroOverViewInventoryWindowDX + 030
InventoryItem12DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem12Dx:      equ HeroOverViewInventoryWindowDX + 052
InventoryItem13DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem13Dx:      equ HeroOverViewInventoryWindowDX + 074
InventoryItem14DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem14Dx:      equ HeroOverViewInventoryWindowDX + 096
InventoryItem15DY:      equ HeroOverViewInventoryWindowDY + 101
InventoryItem15Dx:      equ HeroOverViewInventoryWindowDX + 118

ScrollIconNR: equ 46
InventoryIconTableSYSX: 
                    dw $4000 + (InventoryItem00ButtonOffSY*128) + (InventoryItem00ButtonOffSX/2) - 128  ;sword 1
                    dw $4000 + (InventoryItem00MouseOverSY*128) + (InventoryItem00MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem01ButtonOffSY*128) + (InventoryItem01ButtonOffSX/2) - 128  ;sword 2
                    dw $4000 + (InventoryItem01MouseOverSY*128) + (InventoryItem01MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem02ButtonOffSY*128) + (InventoryItem02ButtonOffSX/2) - 128  ;sword 3
                    dw $4000 + (InventoryItem02MouseOverSY*128) + (InventoryItem02MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem03ButtonOffSY*128) + (InventoryItem03ButtonOffSX/2) - 128  ;sword 4
                    dw $4000 + (InventoryItem03MouseOverSY*128) + (InventoryItem03MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem04ButtonOffSY*128) + (InventoryItem04ButtonOffSX/2) - 128  ;sword 5
                    dw $4000 + (InventoryItem04MouseOverSY*128) + (InventoryItem04MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem05ButtonOffSY*128) + (InventoryItem05ButtonOffSX/2) - 128  ;armor 1
                    dw $4000 + (InventoryItem05MouseOverSY*128) + (InventoryItem05MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem06ButtonOffSY*128) + (InventoryItem06ButtonOffSX/2) - 128  ;armor 2
                    dw $4000 + (InventoryItem06MouseOverSY*128) + (InventoryItem06MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem07ButtonOffSY*128) + (InventoryItem07ButtonOffSX/2) - 128  ;armor 3
                    dw $4000 + (InventoryItem07MouseOverSY*128) + (InventoryItem07MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem08ButtonOffSY*128) + (InventoryItem08ButtonOffSX/2) - 128  ;armor 4
                    dw $4000 + (InventoryItem08MouseOverSY*128) + (InventoryItem08MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem09ButtonOffSY*128) + (InventoryItem09ButtonOffSX/2) - 128  ;armor 5
                    dw $4000 + (InventoryItem09MouseOverSY*128) + (InventoryItem09MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem10ButtonOffSY*128) + (InventoryItem10ButtonOffSX/2) - 128  ;shield 1
                    dw $4000 + (InventoryItem10MouseOverSY*128) + (InventoryItem10MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem11ButtonOffSY*128) + (InventoryItem11ButtonOffSX/2) - 128  ;shield 2
                    dw $4000 + (InventoryItem11MouseOverSY*128) + (InventoryItem11MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem12ButtonOffSY*128) + (InventoryItem12ButtonOffSX/2) - 128  ;shield 3
                    dw $4000 + (InventoryItem12MouseOverSY*128) + (InventoryItem12MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem13ButtonOffSY*128) + (InventoryItem13ButtonOffSX/2) - 128  ;shield 4
                    dw $4000 + (InventoryItem13MouseOverSY*128) + (InventoryItem13MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem14ButtonOffSY*128) + (InventoryItem14ButtonOffSX/2) - 128  ;shield 5
                    dw $4000 + (InventoryItem14MouseOverSY*128) + (InventoryItem14MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem15ButtonOffSY*128) + (InventoryItem15ButtonOffSX/2) - 128  ;helmet 1
                    dw $4000 + (InventoryItem15MouseOverSY*128) + (InventoryItem15MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem16ButtonOffSY*128) + (InventoryItem16ButtonOffSX/2) - 128  ;helmet 2
                    dw $4000 + (InventoryItem16MouseOverSY*128) + (InventoryItem16MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem17ButtonOffSY*128) + (InventoryItem17ButtonOffSX/2) - 128  ;helmet 3
                    dw $4000 + (InventoryItem17MouseOverSY*128) + (InventoryItem17MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem18ButtonOffSY*128) + (InventoryItem18ButtonOffSX/2) - 128  ;helmet 4
                    dw $4000 + (InventoryItem18MouseOverSY*128) + (InventoryItem18MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem19ButtonOffSY*128) + (InventoryItem19ButtonOffSX/2) - 128  ;helmet 5
                    dw $4000 + (InventoryItem19MouseOverSY*128) + (InventoryItem19MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem20ButtonOffSY*128) + (InventoryItem20ButtonOffSX/2) - 128  ;boots 1
                    dw $4000 + (InventoryItem20MouseOverSY*128) + (InventoryItem20MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem21ButtonOffSY*128) + (InventoryItem21ButtonOffSX/2) - 128  ;boots 2
                    dw $4000 + (InventoryItem21MouseOverSY*128) + (InventoryItem21MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem22ButtonOffSY*128) + (InventoryItem22ButtonOffSX/2) - 128  ;boots 3
                    dw $4000 + (InventoryItem22MouseOverSY*128) + (InventoryItem22MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem23ButtonOffSY*128) + (InventoryItem23ButtonOffSX/2) - 128  ;boots 4
                    dw $4000 + (InventoryItem23MouseOverSY*128) + (InventoryItem23MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem24ButtonOffSY*128) + (InventoryItem24ButtonOffSX/2) - 128  ;boots 5
                    dw $4000 + (InventoryItem24MouseOverSY*128) + (InventoryItem24MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem25ButtonOffSY*128) + (InventoryItem25ButtonOffSX/2) - 128  ;gloves 1
                    dw $4000 + (InventoryItem25MouseOverSY*128) + (InventoryItem25MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem26ButtonOffSY*128) + (InventoryItem26ButtonOffSX/2) - 128  ;gloves 2
                    dw $4000 + (InventoryItem26MouseOverSY*128) + (InventoryItem26MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem27ButtonOffSY*128) + (InventoryItem27ButtonOffSX/2) - 128  ;gloves 3
                    dw $4000 + (InventoryItem27MouseOverSY*128) + (InventoryItem27MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem28ButtonOffSY*128) + (InventoryItem28ButtonOffSX/2) - 128  ;gloves 4
                    dw $4000 + (InventoryItem28MouseOverSY*128) + (InventoryItem28MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem29ButtonOffSY*128) + (InventoryItem29ButtonOffSX/2) - 128  ;gloves 5
                    dw $4000 + (InventoryItem29MouseOverSY*128) + (InventoryItem29MouseOverSX/2) - 128



                    dw $4000 + (InventoryItem30ButtonOffSY*128) + (InventoryItem30ButtonOffSX/2) - 128  ;ring 1
                    dw $4000 + (InventoryItem30MouseOverSY*128) + (InventoryItem30MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem31ButtonOffSY*128) + (InventoryItem31ButtonOffSX/2) - 128  ;ring 2
                    dw $4000 + (InventoryItem31MouseOverSY*128) + (InventoryItem31MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem32ButtonOffSY*128) + (InventoryItem32ButtonOffSX/2) - 128  ;ring 3
                    dw $4000 + (InventoryItem32MouseOverSY*128) + (InventoryItem32MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem33ButtonOffSY*128) + (InventoryItem33ButtonOffSX/2) - 128  ;ring 4
                    dw $4000 + (InventoryItem33MouseOverSY*128) + (InventoryItem33MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem34ButtonOffSY*128) + (InventoryItem34ButtonOffSX/2) - 128  ;ring 5
                    dw $4000 + (InventoryItem34MouseOverSY*128) + (InventoryItem34MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem35ButtonOffSY*128) + (InventoryItem35ButtonOffSX/2) - 128  ;Necklace 1
                    dw $4000 + (InventoryItem35MouseOverSY*128) + (InventoryItem35MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem36ButtonOffSY*128) + (InventoryItem36ButtonOffSX/2) - 128  ;Necklace 2
                    dw $4000 + (InventoryItem36MouseOverSY*128) + (InventoryItem36MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem37ButtonOffSY*128) + (InventoryItem37ButtonOffSX/2) - 128  ;Necklace 3
                    dw $4000 + (InventoryItem37MouseOverSY*128) + (InventoryItem37MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem38ButtonOffSY*128) + (InventoryItem38ButtonOffSX/2) - 128  ;Necklace 4
                    dw $4000 + (InventoryItem38MouseOverSY*128) + (InventoryItem38MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem39ButtonOffSY*128) + (InventoryItem39ButtonOffSX/2) - 128  ;Necklace 5
                    dw $4000 + (InventoryItem39MouseOverSY*128) + (InventoryItem39MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem40ButtonOffSY*128) + (InventoryItem40ButtonOffSX/2) - 128  ;robe 1
                    dw $4000 + (InventoryItem40MouseOverSY*128) + (InventoryItem40MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem41ButtonOffSY*128) + (InventoryItem41ButtonOffSX/2) - 128  ;robe 2
                    dw $4000 + (InventoryItem41MouseOverSY*128) + (InventoryItem41MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem42ButtonOffSY*128) + (InventoryItem42ButtonOffSX/2) - 128  ;robe 3
                    dw $4000 + (InventoryItem42MouseOverSY*128) + (InventoryItem42MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem43ButtonOffSY*128) + (InventoryItem43ButtonOffSX/2) - 128  ;robe 4
                    dw $4000 + (InventoryItem43MouseOverSY*128) + (InventoryItem43MouseOverSX/2) - 128
                    dw $4000 + (InventoryItem44ButtonOffSY*128) + (InventoryItem44ButtonOffSX/2) - 128  ;robe 5
                    dw $4000 + (InventoryItem44MouseOverSY*128) + (InventoryItem44MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem45ButtonOffSY*128) + (InventoryItem45ButtonOffSX/2) - 128  ;empty slot
                    dw $4000 + (InventoryItem45MouseOverSY*128) + (InventoryItem45MouseOverSX/2) - 128

                    dw $4000 + (InventoryItem46ButtonOffSY*128) + (InventoryItem46ButtonOffSX/2) - 128  ;scroll
                    dw $4000 + (InventoryItem46MouseOverSY*128) + (InventoryItem46MouseOverSX/2) - 128

InventoryItem00ButtonOffSY:   equ 000 ;sword 1
InventoryItem00ButtonOffSX:   equ 146
InventoryItem00MouseOverSY:   equ 020
InventoryItem00MouseOverSX:   equ 146
InventoryItem01ButtonOffSY:   equ 000 ;sword 2
InventoryItem01ButtonOffSX:   equ 166
InventoryItem01MouseOverSY:   equ 020
InventoryItem01MouseOverSX:   equ 166
InventoryItem02ButtonOffSY:   equ 000 ;sword 3
InventoryItem02ButtonOffSX:   equ 186
InventoryItem02MouseOverSY:   equ 020
InventoryItem02MouseOverSX:   equ 186
InventoryItem03ButtonOffSY:   equ 000 ;sword 4
InventoryItem03ButtonOffSX:   equ 206
InventoryItem03MouseOverSY:   equ 020
InventoryItem03MouseOverSX:   equ 206
InventoryItem04ButtonOffSY:   equ 000 ;sword 5
InventoryItem04ButtonOffSX:   equ 226
InventoryItem04MouseOverSY:   equ 020
InventoryItem04MouseOverSX:   equ 226

InventoryItem05ButtonOffSY:   equ 040 ;armor 1
InventoryItem05ButtonOffSX:   equ 146
InventoryItem05MouseOverSY:   equ 060
InventoryItem05MouseOverSX:   equ 146
InventoryItem06ButtonOffSY:   equ 040 ;armor 2
InventoryItem06ButtonOffSX:   equ 166
InventoryItem06MouseOverSY:   equ 060
InventoryItem06MouseOverSX:   equ 166
InventoryItem07ButtonOffSY:   equ 040 ;armor 3
InventoryItem07ButtonOffSX:   equ 186
InventoryItem07MouseOverSY:   equ 060
InventoryItem07MouseOverSX:   equ 186
InventoryItem08ButtonOffSY:   equ 040 ;armor 4
InventoryItem08ButtonOffSX:   equ 206
InventoryItem08MouseOverSY:   equ 060
InventoryItem08MouseOverSX:   equ 206
InventoryItem09ButtonOffSY:   equ 040 ;armor 5
InventoryItem09ButtonOffSX:   equ 226
InventoryItem09MouseOverSY:   equ 060
InventoryItem09MouseOverSX:   equ 226

InventoryItem10ButtonOffSY:   equ 080 ;shield 1
InventoryItem10ButtonOffSX:   equ 146
InventoryItem10MouseOverSY:   equ 100
InventoryItem10MouseOverSX:   equ 146
InventoryItem11ButtonOffSY:   equ 080 ;shield 2
InventoryItem11ButtonOffSX:   equ 166
InventoryItem11MouseOverSY:   equ 100
InventoryItem11MouseOverSX:   equ 166
InventoryItem12ButtonOffSY:   equ 080 ;shield 3
InventoryItem12ButtonOffSX:   equ 186
InventoryItem12MouseOverSY:   equ 100
InventoryItem12MouseOverSX:   equ 186
InventoryItem13ButtonOffSY:   equ 080 ;shield 4
InventoryItem13ButtonOffSX:   equ 206
InventoryItem13MouseOverSY:   equ 100
InventoryItem13MouseOverSX:   equ 206
InventoryItem14ButtonOffSY:   equ 080 ;shield 5
InventoryItem14ButtonOffSX:   equ 226
InventoryItem14MouseOverSY:   equ 100
InventoryItem14MouseOverSX:   equ 226

InventoryItem15ButtonOffSY:   equ 156 ;helmet 1
InventoryItem15ButtonOffSX:   equ 000
InventoryItem15MouseOverSY:   equ 176
InventoryItem15MouseOverSX:   equ 000
InventoryItem16ButtonOffSY:   equ 156 ;helmet 2
InventoryItem16ButtonOffSX:   equ 020
InventoryItem16MouseOverSY:   equ 176
InventoryItem16MouseOverSX:   equ 020
InventoryItem17ButtonOffSY:   equ 156 ;helmet 3
InventoryItem17ButtonOffSX:   equ 040
InventoryItem17MouseOverSY:   equ 176
InventoryItem17MouseOverSX:   equ 040
InventoryItem18ButtonOffSY:   equ 156 ;helmet 4
InventoryItem18ButtonOffSX:   equ 060
InventoryItem18MouseOverSY:   equ 176
InventoryItem18MouseOverSX:   equ 060
InventoryItem19ButtonOffSY:   equ 156 ;helmet 5
InventoryItem19ButtonOffSX:   equ 080
InventoryItem19MouseOverSY:   equ 176
InventoryItem19MouseOverSX:   equ 080

InventoryItem20ButtonOffSY:   equ 156 ;boots 1
InventoryItem20ButtonOffSX:   equ 100
InventoryItem20MouseOverSY:   equ 176
InventoryItem20MouseOverSX:   equ 100
InventoryItem21ButtonOffSY:   equ 156 ;boots 2
InventoryItem21ButtonOffSX:   equ 120
InventoryItem21MouseOverSY:   equ 176
InventoryItem21MouseOverSX:   equ 120
InventoryItem22ButtonOffSY:   equ 156 ;boots 3
InventoryItem22ButtonOffSX:   equ 140
InventoryItem22MouseOverSY:   equ 176
InventoryItem22MouseOverSX:   equ 140
InventoryItem23ButtonOffSY:   equ 156 ;boots 4
InventoryItem23ButtonOffSX:   equ 160
InventoryItem23MouseOverSY:   equ 176
InventoryItem23MouseOverSX:   equ 160
InventoryItem24ButtonOffSY:   equ 156 ;boots 5
InventoryItem24ButtonOffSX:   equ 180
InventoryItem24MouseOverSY:   equ 176
InventoryItem24MouseOverSX:   equ 180

InventoryItem25ButtonOffSY:   equ 156 ;gloves 1
InventoryItem25ButtonOffSX:   equ 200
InventoryItem25MouseOverSY:   equ 176
InventoryItem25MouseOverSX:   equ 200
InventoryItem26ButtonOffSY:   equ 156 ;gloves 2
InventoryItem26ButtonOffSX:   equ 220
InventoryItem26MouseOverSY:   equ 176
InventoryItem26MouseOverSX:   equ 220
InventoryItem27ButtonOffSY:   equ 196 ;gloves 3
InventoryItem27ButtonOffSX:   equ 000
InventoryItem27MouseOverSY:   equ 216
InventoryItem27MouseOverSX:   equ 000
InventoryItem28ButtonOffSY:   equ 196 ;gloves 4
InventoryItem28ButtonOffSX:   equ 020
InventoryItem28MouseOverSY:   equ 216
InventoryItem28MouseOverSX:   equ 020
InventoryItem29ButtonOffSY:   equ 196 ;gloves 5
InventoryItem29ButtonOffSX:   equ 040
InventoryItem29MouseOverSY:   equ 216
InventoryItem29MouseOverSX:   equ 040

InventoryItem30ButtonOffSY:   equ 196 ;ring 1
InventoryItem30ButtonOffSX:   equ 060
InventoryItem30MouseOverSY:   equ 216
InventoryItem30MouseOverSX:   equ 060
InventoryItem31ButtonOffSY:   equ 196 ;ring 2
InventoryItem31ButtonOffSX:   equ 080
InventoryItem31MouseOverSY:   equ 216
InventoryItem31MouseOverSX:   equ 080
InventoryItem32ButtonOffSY:   equ 196 ;ring 3
InventoryItem32ButtonOffSX:   equ 100
InventoryItem32MouseOverSY:   equ 216
InventoryItem32MouseOverSX:   equ 100
InventoryItem33ButtonOffSY:   equ 196 ;ring 4
InventoryItem33ButtonOffSX:   equ 120
InventoryItem33MouseOverSY:   equ 216
InventoryItem33MouseOverSX:   equ 120
InventoryItem34ButtonOffSY:   equ 196 ;ring 5
InventoryItem34ButtonOffSX:   equ 140
InventoryItem34MouseOverSY:   equ 216
InventoryItem34MouseOverSX:   equ 140

InventoryItem35ButtonOffSY:   equ 196 ;Necklace 1
InventoryItem35ButtonOffSX:   equ 160
InventoryItem35MouseOverSY:   equ 216
InventoryItem35MouseOverSX:   equ 160
InventoryItem36ButtonOffSY:   equ 196 ;Necklace 2
InventoryItem36ButtonOffSX:   equ 180
InventoryItem36MouseOverSY:   equ 216
InventoryItem36MouseOverSX:   equ 180
InventoryItem37ButtonOffSY:   equ 196 ;Necklace 3
InventoryItem37ButtonOffSX:   equ 200
InventoryItem37MouseOverSY:   equ 216
InventoryItem37MouseOverSX:   equ 200
InventoryItem38ButtonOffSY:   equ 196 ;Necklace 4
InventoryItem38ButtonOffSX:   equ 220
InventoryItem38MouseOverSY:   equ 216
InventoryItem38MouseOverSX:   equ 220
InventoryItem39ButtonOffSY:   equ 236 ;Necklace 5
InventoryItem39ButtonOffSX:   equ 000
InventoryItem39MouseOverSY:   equ 236
InventoryItem39MouseOverSX:   equ 020

InventoryItem40ButtonOffSY:   equ 236 ;robe 1
InventoryItem40ButtonOffSX:   equ 040
InventoryItem40MouseOverSY:   equ 120
InventoryItem40MouseOverSX:   equ 146
InventoryItem41ButtonOffSY:   equ 236 ;robe 2
InventoryItem41ButtonOffSX:   equ 060
InventoryItem41MouseOverSY:   equ 120
InventoryItem41MouseOverSX:   equ 166
InventoryItem42ButtonOffSY:   equ 236 ;robe 3
InventoryItem42ButtonOffSX:   equ 080
InventoryItem42MouseOverSY:   equ 120
InventoryItem42MouseOverSX:   equ 186
InventoryItem43ButtonOffSY:   equ 236 ;robe 4
InventoryItem43ButtonOffSX:   equ 100
InventoryItem43MouseOverSY:   equ 120
InventoryItem43MouseOverSX:   equ 206
InventoryItem44ButtonOffSY:   equ 236 ;robe 5
InventoryItem44ButtonOffSX:   equ 120
InventoryItem44MouseOverSY:   equ 120
InventoryItem44MouseOverSX:   equ 226

InventoryItem45ButtonOffSY:   equ 236 ;empty slot
InventoryItem45ButtonOffSX:   equ 200
InventoryItem45MouseOverSY:   equ 236
InventoryItem45MouseOverSX:   equ 180

InventoryItem46ButtonOffSY:   equ 236 ;scroll
InventoryItem46ButtonOffSX:   equ 140
InventoryItem46MouseOverSY:   equ 236
InventoryItem46MouseOverSX:   equ 160

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewArmyWindowSX:   equ 000
HeroOverViewArmyWindowSY:   equ 000
HeroOverViewArmyWindowDX:   equ 024
HeroOverViewArmyWindowDY:   equ 040
HeroOverViewArmyWindowNX:   equ 156
HeroOverViewArmyWindowNY:   equ 067 ;130

HeroOverViewArmyIconWindowButtonNY:  equ 030
HeroOverViewArmyIconWindowButtonNX:  equ 018



DisplayEnemyHeroStatsWindowCode:
  call  .SetHeroOverViewArmyWindow       ;set overview of hero army
  call  .Set16x30HeroIcon                ;sets hero icon in the Army Window
  ld    ix,(EnemyHeroThatPointerIsOn)
  call  SetArmyIconsAndAmount.army      ;sets hero's army in the Army Window

  call  SwapAndSetPage                  ;swap and set page
  call  .SetHeroOverViewArmyWindow       ;set overview of hero army
  call  .Set16x30HeroIcon                ;sets hero icon in the Army Window
  ld    ix,(EnemyHeroThatPointerIsOn)
  call  SetArmyIconsAndAmount.army      ;sets hero's army in the Army Window
  
  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

  call  CheckEndHeroOverviewArmy        ;check if mouse is clicked outside of window. If so, return to game
  halt
  jp  .engine

.Set16x30HeroIcon:
  ;SetHeroPortrait16x30:
  ld    a,Hero16x30PortraitsBlock       ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    ix,(EnemyHeroThatPointerIsOn)

;  ld    c,(ix+HeroPortrait16x30SYSX+0)   ;example: equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;  ld    b,(ix+HeroPortrait16x30SYSX+1)
  call  SetAddressHeroPortrait16x30SYSXinBC

  ld    hl,DYDX16x30HeroIconArmyWindow  ;(dy*128 + dx/2) = (208,089)
  ld    de,NXAndNY16x30HeroIcon     ;(ny*256 + nx/2) = (10x18)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
	ret

.SetHeroOverViewArmyWindow:
  ld    hl,$4000 + (066*128) + (HeroOverViewArmyWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewArmyWindowDY*128) + (HeroOverViewArmyWindowDX/2)
  ld    bc,$0000 + (HeroOverViewArmyWindowNY*256) + (HeroOverViewArmyWindowNX/2)
  ld    a,ArmyGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


HeroOverviewArmyWindowCode:
	ld		a,3					                    ;put new heros in windows (page 0 and page 1) 
	ld		(SetHeroArmyAndStatusInHud?),a

;################################ CAN REMOVE LATER ################################
;  call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0
;################################ CAN REMOVE LATER ################################

  call  SetHeroOverViewArmyWindow       ;set overview of hero army
  call  Set16x30HeroIcon                ;sets hero icon in the Army Window
  call  SetArmyIconsAndAmount           ;sets hero's army in the Army Window
  call  UpdateHUd
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle  
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewArmyWindow       ;set overview of hero army
  call  Set16x30HeroIcon                ;sets hero icon in the Army Window
  call  SetArmyIconsAndAmount           ;sets hero's army in the Army Window
  call  UpdateHUd
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle  
  
  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

  ld    ix,HeroOverviewArmyIconButtonTable
  ld    iy,ButtonTableArmyIconsSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.ButtonPressed
;  call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0
;  call  SetTextInventoryItem            ;when clicking on an item, the explanation will appear
  call  MarkLastPressedButtonArmy        ;mark the button that was pressed as 'mouse hover over'


  ld    ix,HeroOverviewArmyIconButtonTable
  call  SetButtonStatusAndText4         ;copies button state from rom -> vram
  call  SetArmyIconsAndAmount           ;sets hero's army in the Army Window


  call  SwapAndSetPage                  ;swap and set page  
  call  CheckEndHeroOverviewArmy        ;check if mouse is clicked outside of window. If so, return to game
  halt
  jp  .engine

  .ButtonPressed:
  ld    (MenuOptionSelected?Backup),a

  xor   a
  ld    (MenuOptionSelected?),a
;  ld    a,3
;  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
;  jp    .engine
  jp    HeroOverviewArmyWindowCode

MarkLastPressedButtonArmy:                  ;mark the button that was pressed as 'mouse hover over'
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    255                             ;no button pressed (yet)
  ret   z
  ld    a,(MenuOptionSelected?BackupLastFrame)
  cp    255
  jr    z,.Set

  ld    b,a
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    b
  jr    nz,.DifferentButtonPressed

  ld    b,a
  ld    a,6
  sub   a,b

  ld    ix,HeroOverviewArmyIconButtonTable
  ld    de,HeroOverviewArmyIconButtonTableLenghtPerIcon
  .loop:
  jr    z,.Found
  add   ix,de
  dec   a
  jr    .loop
  .Found:                               ;the button that was pressed will now be marked as 'mouse hover over'

;check empty slot
  push  ix
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  cp    (ix+HeroUnits+2)                ;unit amount (16 bit)
  pop   ix
  jp    z,.end
;/check empty slot

  ld    (ix+2),%0100 0011               ; (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  .Set:
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    (MenuOptionSelected?BackupLastFrame),a
  ret

  .DifferentButtonPressed:
;1. second slot clicked is empty, move (and split if possible) 1 unit
;2. second slot clicked  has the same unit type, combine them 
;3. both slots have different units, swap them

;check 1. second slot clicked is empty, move (and split if possible) 1 unit
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jp    nz,.EndCheck1
  ;second slot is empty, move (and split if possible) 1 unit

  ;reduce amount of unit we want to split
  ld    a,(MenuOptionSelected?BackupLastFrame)   
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  
  ld    l,(ix+HeroUnits+1)              ;unit amount second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit amount second button pressed
  dec   hl
  ld    (ix+HeroUnits+1),l              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),h              ;unit amount second button pressed
  ld    c,(ix+HeroUnits+0)              ;unit type

  ld    a,(ix+HeroUnits+1)              ;unit amount (16 bit)
  or    (ix+HeroUnits+2)                ;unit amount (16 bit)
  jr    nz,.EndCheckZero
  ld    (ix+HeroUnits+0),0              ;unit type (remove when amount is zero)
  .EndCheckZero:
  ;/reduce amount of unit we want to split

  ;put one unit in the second slot/botton pressed
  ld    a,(MenuOptionSelected?Backup)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a 
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    (ix+HeroUnits+0),c              ;unit type
  ld    (ix+HeroUnits+1),1              ;unit amount second button pressed
  ld    (ix+HeroUnits+2),0              ;unit amount second button pressed
  jp    .end
  ;/put one unit in the second slot/botton pressed
  .EndCheck1:

;check 2. second slot clicked  has the same unit type, combine them 
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    c,(ix+HeroUnits+0)              ;unit type first button pressed

  ld    a,(MenuOptionSelected?BackupLastFrame)   
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(ix+HeroUnits+0)              ;unit type second button pressed

  cp    c
  jp    nz,.EndCheck2

  ;combine units into one slot
  ld    (ix+HeroUnits+0),0              ;unit type second button pressed
  ld    l,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    h,(ix+HeroUnits+2)              ;unit type second button pressed

  ld    (ix+HeroUnits+1),0              ;unit type second button pressed
  ld    (ix+HeroUnits+2),0              ;unit type second button pressed

  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de
  ld    e,(ix+HeroUnits+1)              ;unit type second button pressed
  ld    d,(ix+HeroUnits+2)              ;unit type second button pressed
  add   hl,de

  ld    (ix+HeroUnits+1),l              ;unit type second button pressed
  ld    (ix+HeroUnits+2),h              ;unit type second button pressed
  jp    .end
  .EndCheck2:


;check 3. both slots have different units, swap them

;SwapInventoryItemsArmy:                     ;swaps the last 2 inventory items that have been selected
  push  iy

  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,6
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  add   ix,de  
  add   ix,de  

  ld    a,(MenuOptionSelected?BackupLastFrame)
  ld    b,a
  ld    a,6
  sub   a,b
  ld    iy,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   iy,de
  add   iy,de
  add   iy,de

  ld    a,(ix+HeroUnits+0)              ;unit type
  ld    b,(ix+HeroUnits+1)              ;unit amount (16 bit)
  ld    c,(ix+HeroUnits+2)              ;unit amount (16 bit)

  ld    d,(iy+HeroUnits+0)              ;unit type
  ld    e,(iy+HeroUnits+1)              ;unit amount (16 bit)
  ld    h,(iy+HeroUnits+2)              ;unit amount (16 bit)

  ld    (ix+HeroUnits+0),d              ;unit type
  ld    (ix+HeroUnits+1),e              ;unit amount (16 bit)
  ld    (ix+HeroUnits+2),h              ;unit amount (16 bit)

  ld    (iy+HeroUnits+0),a              ;unit type
  ld    (iy+HeroUnits+1),b              ;unit amount (16 bit)
  ld    (iy+HeroUnits+2),c              ;unit amount (16 bit)

  pop   iy

  .end:
  xor   a
  ld    (MenuOptionSelected?),a
  ld    a,255
  ld    (MenuOptionSelected?Backup),a  
  ld    (MenuOptionSelected?BackupLastFrame),a
  pop   af                              ;pop the call to this routine
  jp    HeroOverviewArmyWindowCode      ;restart code, item has been swapped



















NXAndNY16x30HeroIcon:   equ 030*256 + (016/2)            ;(ny*256 + nx/2) = (14x09)
DYDX16x30HeroIconArmyWindow:       equ (HeroOverViewArmyWindowDY+28)*128 + ((HeroOverViewArmyWindowDX+10)/2) - 128      ;(dy*128 + dx/2) = (208,089)

Set16x30HeroIcon:
  ;SetHeroPortrait16x30:
  ld    a,Hero16x30PortraitsBlock       ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    ix,(plxcurrentheroAddress)

;  ld    c,(ix+HeroPortrait16x30SYSX+0)   ;example: equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;  ld    b,(ix+HeroPortrait16x30SYSX+1)
  call  SetAddressHeroPortrait16x30SYSXinBC

  ld    hl,DYDX16x30HeroIconArmyWindow  ;(dy*128 + dx/2) = (208,089)
  ld    de,NXAndNY16x30HeroIcon     ;(ny*256 + nx/2) = (10x18)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
	ret

SetAddressHeroPortrait16x30SYSXinBC:
  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix

  ld    c,(ix+HeroInfoPortrait16x30SYSX+0)  ;find hero portrait 16x30 address
  ld    b,(ix+HeroInfoPortrait16x30SYSX+1)  
;  ld    bc,$4000
;  xor   a
;  sbc   hl,bc
  ret

SetArmyIconsAndAmount:
  ld    ix,(plxcurrentheroAddress)

  call  .army
;  call  .amount
;  ret

  .amount:
  ld    l,(ix+HeroUnits+01)
  ld    h,(ix+HeroUnits+02)
  ld    b,HeroOverViewArmyWindowDX + 031 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+04)
  ld    h,(ix+HeroUnits+05)
  ld    b,HeroOverViewArmyWindowDX + 051 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+07)
  ld    h,(ix+HeroUnits+08)
  ld    b,HeroOverViewArmyWindowDX + 071 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+10)
  ld    h,(ix+HeroUnits+11)
  ld    b,HeroOverViewArmyWindowDX + 091 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+13)
  ld    h,(ix+HeroUnits+14)
  ld    b,HeroOverViewArmyWindowDX + 111 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0

  ld    l,(ix+HeroUnits+16)
  ld    h,(ix+HeroUnits+17)
  ld    b,HeroOverViewArmyWindowDX + 131 + 2
  ld    c,HeroOverViewArmyWindowDY + 056
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ret

  .army:
  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit1WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit2WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit3WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit4WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit5WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX
  ld    de,DYDXUnit6WindowInHud14x24    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  cp    180
  jr    c,.EndCheckOverFlow
  sub   180
  ld    l,a
  ld    a,Enemy14x24PortraitsBlockPart2      ;Map block
  jr    .EntryPart2

  .EndCheckOverFlow:
  ld    l,a
  ld    a,Enemy14x24PortraitsBlock      ;Map block
  .EntryPart2:
  ld    h,0
  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  push  bc
  pop   hl

  ld    bc,NXAndNY14x24CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ret

DisplayTownAllignmentAssociatedCreatures:
  ld    a,(StartingTownLevel1Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit1TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   

  ld    a,(StartingTownLevel2Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit2TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   

  ld    a,(StartingTownLevel3Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit3TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   

  ld    a,(StartingTownLevel4Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit4TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   

  ld    a,(StartingTownLevel5Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit5TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   

  ld    a,(StartingTownLevel6Unit)
  call  SetArmyIconsAndAmount.SetSYSX
  ld    de,DYDXUnit6TownAllignment    ;(dy*128 + dx/2) = (204,153)
  call  CopyTransparantImageHeroOverviewCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY   
  ret

NXAndNY14x24CharaterPortraits:      equ 024*256 + (014/2)            ;(ny*256 + nx/2) = (14x14)
DYDXUnit1WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+32)
DYDXUnit2WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+52)
DYDXUnit3WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+72)
DYDXUnit4WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+92)
DYDXUnit5WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+112)
DYDXUnit6WindowInHud14x24:          equ 256*(HeroOverViewArmyWindowDY+30) + (HeroOverViewArmyWindowDX+132)

DYDXUnit1TownAllignment:          equ 256*(056) + (051)
DYDXUnit2TownAllignment:          equ 256*(056) + (103)
DYDXUnit3TownAllignment:          equ 256*(056) + (155)
DYDXUnit4TownAllignment:          equ 256*(100) + (051)
DYDXUnit5TownAllignment:          equ 256*(100) + (103)
DYDXUnit6TownAllignment:          equ 256*(100) + (155)


                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128
UnitSYSXTable14x24Portraits:  
                dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(24*128)+(00/2)-128, $4000+(24*128)+(14/2)-128, $4000+(24*128)+(28/2)-128, $4000+(24*128)+(42/2)-128, $4000+(24*128)+(56/2)-128, $4000+(24*128)+(70/2)-128, $4000+(24*128)+(84/2)-128, $4000+(24*128)+(98/2)-128, $4000+(24*128)+(112/2)-128, $4000+(24*128)+(126/2)-128, $4000+(24*128)+(140/2)-128, $4000+(24*128)+(154/2)-128, $4000+(24*128)+(168/2)-128, $4000+(24*128)+(182/2)-128, $4000+(24*128)+(196/2)-128, $4000+(24*128)+(210/2)-128, $4000+(24*128)+(224/2)-128, $4000+(24*128)+(238/2)-128
                dw $4000+(48*128)+(00/2)-128, $4000+(48*128)+(14/2)-128, $4000+(48*128)+(28/2)-128, $4000+(48*128)+(42/2)-128, $4000+(48*128)+(56/2)-128, $4000+(48*128)+(70/2)-128, $4000+(48*128)+(84/2)-128, $4000+(48*128)+(98/2)-128, $4000+(48*128)+(112/2)-128, $4000+(48*128)+(126/2)-128, $4000+(48*128)+(140/2)-128, $4000+(48*128)+(154/2)-128, $4000+(48*128)+(168/2)-128, $4000+(48*128)+(182/2)-128, $4000+(48*128)+(196/2)-128, $4000+(48*128)+(210/2)-128, $4000+(48*128)+(224/2)-128, $4000+(48*128)+(238/2)-128
                dw $4000+(72*128)+(00/2)-128, $4000+(72*128)+(14/2)-128, $4000+(72*128)+(28/2)-128, $4000+(72*128)+(42/2)-128, $4000+(72*128)+(56/2)-128, $4000+(72*128)+(70/2)-128, $4000+(72*128)+(84/2)-128, $4000+(72*128)+(98/2)-128, $4000+(72*128)+(112/2)-128, $4000+(72*128)+(126/2)-128, $4000+(72*128)+(140/2)-128, $4000+(72*128)+(154/2)-128, $4000+(72*128)+(168/2)-128, $4000+(72*128)+(182/2)-128, $4000+(72*128)+(196/2)-128, $4000+(72*128)+(210/2)-128, $4000+(72*128)+(224/2)-128, $4000+(72*128)+(238/2)-128
                dw $4000+(96*128)+(00/2)-128, $4000+(96*128)+(14/2)-128, $4000+(96*128)+(28/2)-128, $4000+(96*128)+(42/2)-128, $4000+(96*128)+(56/2)-128, $4000+(96*128)+(70/2)-128, $4000+(96*128)+(84/2)-128, $4000+(96*128)+(98/2)-128, $4000+(96*128)+(112/2)-128, $4000+(96*128)+(126/2)-128, $4000+(96*128)+(140/2)-128, $4000+(96*128)+(154/2)-128, $4000+(96*128)+(168/2)-128, $4000+(96*128)+(182/2)-128, $4000+(96*128)+(196/2)-128, $4000+(96*128)+(210/2)-128, $4000+(96*128)+(224/2)-128, $4000+(96*128)+(238/2)-128
                dw $4000+(120*128)+(00/2)-128, $4000+(120*128)+(14/2)-128, $4000+(120*128)+(28/2)-128, $4000+(120*128)+(42/2)-128, $4000+(120*128)+(56/2)-128, $4000+(120*128)+(70/2)-128, $4000+(120*128)+(84/2)-128, $4000+(120*128)+(98/2)-128, $4000+(120*128)+(112/2)-128, $4000+(120*128)+(126/2)-128, $4000+(120*128)+(140/2)-128, $4000+(120*128)+(154/2)-128, $4000+(120*128)+(168/2)-128, $4000+(120*128)+(182/2)-128, $4000+(120*128)+(196/2)-128, $4000+(120*128)+(210/2)-128, $4000+(120*128)+(224/2)-128, $4000+(120*128)+(238/2)-128
                dw $4000+(144*128)+(00/2)-128, $4000+(144*128)+(14/2)-128, $4000+(144*128)+(28/2)-128, $4000+(144*128)+(42/2)-128, $4000+(144*128)+(56/2)-128, $4000+(144*128)+(70/2)-128, $4000+(144*128)+(84/2)-128, $4000+(144*128)+(98/2)-128, $4000+(144*128)+(112/2)-128, $4000+(144*128)+(126/2)-128, $4000+(144*128)+(140/2)-128, $4000+(144*128)+(154/2)-128, $4000+(144*128)+(168/2)-128, $4000+(144*128)+(182/2)-128, $4000+(144*128)+(196/2)-128, $4000+(144*128)+(210/2)-128, $4000+(144*128)+(224/2)-128, $4000+(144*128)+(238/2)-128

                dw $4000+(168*128)+(00/2)-128, $4000+(168*128)+(14/2)-128, $4000+(168*128)+(28/2)-128, $4000+(168*128)+(42/2)-128, $4000+(168*128)+(56/2)-128, $4000+(168*128)+(70/2)-128, $4000+(168*128)+(84/2)-128, $4000+(168*128)+(98/2)-128, $4000+(168*128)+(112/2)-128, $4000+(168*128)+(126/2)-128, $4000+(168*128)+(140/2)-128, $4000+(168*128)+(154/2)-128, $4000+(168*128)+(168/2)-128, $4000+(168*128)+(182/2)-128, $4000+(168*128)+(196/2)-128, $4000+(168*128)+(210/2)-128, $4000+(168*128)+(224/2)-128, $4000+(168*128)+(238/2)-128
                dw $4000+(192*128)+(00/2)-128, $4000+(192*128)+(14/2)-128, $4000+(192*128)+(28/2)-128, $4000+(192*128)+(42/2)-128, $4000+(192*128)+(56/2)-128, $4000+(192*128)+(70/2)-128, $4000+(192*128)+(84/2)-128, $4000+(192*128)+(98/2)-128, $4000+(192*128)+(112/2)-128, $4000+(192*128)+(126/2)-128, $4000+(192*128)+(140/2)-128, $4000+(192*128)+(154/2)-128, $4000+(192*128)+(168/2)-128, $4000+(192*128)+(182/2)-128, $4000+(192*128)+(196/2)-128, $4000+(192*128)+(210/2)-128, $4000+(192*128)+(224/2)-128, $4000+(192*128)+(238/2)-128
                dw $4000+(216*128)+(00/2)-128, $4000+(216*128)+(14/2)-128, $4000+(216*128)+(28/2)-128, $4000+(216*128)+(42/2)-128, $4000+(216*128)+(56/2)-128, $4000+(216*128)+(70/2)-128, $4000+(216*128)+(84/2)-128, $4000+(216*128)+(98/2)-128, $4000+(216*128)+(112/2)-128, $4000+(216*128)+(126/2)-128, $4000+(216*128)+(140/2)-128, $4000+(216*128)+(154/2)-128, $4000+(216*128)+(168/2)-128, $4000+(216*128)+(182/2)-128, $4000+(216*128)+(196/2)-128, $4000+(216*128)+(210/2)-128, $4000+(216*128)+(224/2)-128, $4000+(216*128)+(238/2)-128
                dw $4000+(230*128)+(00/2)-128, $4000+(230*128)+(14/2)-128, $4000+(230*128)+(28/2)-128, $4000+(230*128)+(42/2)-128, $4000+(230*128)+(56/2)-128, $4000+(230*128)+(70/2)-128, $4000+(230*128)+(84/2)-128, $4000+(230*128)+(98/2)-128, $4000+(230*128)+(112/2)-128, $4000+(230*128)+(126/2)-128, $4000+(230*128)+(140/2)-128, $4000+(230*128)+(154/2)-128, $4000+(230*128)+(168/2)-128, $4000+(230*128)+(182/2)-128, $4000+(230*128)+(196/2)-128, $4000+(230*128)+(210/2)-128, $4000+(230*128)+(224/2)-128, $4000+(230*128)+(238/2)-128


CopyTransparantImageHeroOverviewCode:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  push  af
  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a
  pop   af

  push  de
  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  pop   de

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  jp    docopy


;inventory has:
;sword - Attack
;armor - units hp
;shield - Defense
;helmet - protection
;boots - movement
;gloves - archery +x%
;ring - Spell power
;necklace - spell point recovery / income + 500 when equiped / 
;robe - Intelligence (total mana)
HeroOverviewInventoryWindowCode:
  call  SetHeroOverViewInventoryWindow  ;set skills Window in inactive page
  call  SetInventoryIcons               ;sets all available items in inactive page
  call  UpdateHUd
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle  
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewInventoryWindow  ;set skills Window in inactive page
  call  SetInventoryIcons               ;sets all available items in inactive page
  call  CreateInventoryListForCurrHero  ;writes icon coordinates to list:ButtonTableInventoryIconsSYSX
  call  UpdateHUd
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle  

  .engine:
  call  PopulateControls                ;read out keys
  call  SetTotalManaHero

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

  ld    ix,HeroOverviewInventoryIconButtonTable
  ld    iy,ButtonTableInventoryIconsSYSX
  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.InventoryIconPressed

;  call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0
  call  SetTextInventoryItem            ;when clicking on an item, the explanation will appear

  call  MarkLastPressedButton           ;mark the button that was pressed as 'mouse hover over'
  ld    ix,HeroOverviewInventoryIconButtonTable
  call  SetButtonStatusAndText3         ;copies button state from rom -> vram



  call  SwapAndSetPage                  ;swap and set page  
  call  CheckEndHeroOverviewInventory   ;check if mouse is clicked outside of window. If so, return to game
  halt
  jp  .engine

  .InventoryIconPressed:
  ld    (MenuOptionSelected?Backup),a

  xor   a
  ld    (MenuOptionSelected?),a
;  ld    (ActivatedSpellIconButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  jp    HeroOverviewInventoryWindowCode





MarkLastPressedButton:                  ;mark the button that was pressed as 'mouse hover over'
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    255                             ;no button pressed (yet)
  ret   z
  ld    a,(MenuOptionSelected?BackupLastFrame)
  cp    255
  jr    z,.Set

  ld    b,a
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    b
  jr    nz,.DifferentButtonPressed

  ld    b,a
  ld    a,15
  sub   a,b
  
;check empty slot 'inventory item nr#45'
  push  af
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15

  cp    045
  jr    nz,.NotEmpty
  ld    a,255
  ld    (MenuOptionSelected?Backup),a   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    (MenuOptionSelected?BackupLastFrame),a
  pop   af
  ret
  .NotEmpty:
  pop   af



  ld    ix,HeroOverviewInventoryIconButtonTable
  ld    de,HeroOverviewInventoryIconButtonTableLenghtPerIcon
  .loop:
  jr    z,.Found
  add   ix,de
  dec   a
  jr    .loop

  .Found:                               ;the button that was pressed will now be marked as 'mouse hover over'
  ld    (ix+2),%0100 0011               ; (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)

  .Set:
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    (MenuOptionSelected?BackupLastFrame),a
  ret

  .DifferentButtonPressed:
;1. both items are in slot 1-9 and therefor can never be swapped
;2. both items are in slot 10-15 and therefor can be swapped
;3. the item that goes to slot 1-9 is not a match, therefor don't swap
;4. the 2 items can be swapped  

;check 1. both items are in slot 1-9 and therefor can never be swapped
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    7
  jr    c,.EndCheck1
  ld    a,(MenuOptionSelected?BackupLastFrame)
  cp    7
  jr    nc,.UnableToSwapItems
  .EndCheck1:

;2. both items are in slot 10-15 and therefor must be swapped
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  cp    7
  jr    nc,.MenuOptionSelected?BackupLastFrame_GoesToSlot1to9
  ld    a,(MenuOptionSelected?BackupLastFrame)
  cp    15 - 9
  jp    c,SwapInventoryItems            ;swaps the last 2 inventory items that have been selected

;check 3. the item that goes to slot 1-9 is not a match, therefor don't swap
  .MenuOptionSelected?Backup_GoesToSlot1to9:
  ld    a,(MenuOptionSelected?BackupLastFrame)
  ld    c,a
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  jr    .go

  .MenuOptionSelected?BackupLastFrame_GoesToSlot1to9:
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    c,a
  ld    a,(MenuOptionSelected?BackupLastFrame)
;  jr    .go

  .go:
  ld    b,a
  ld    a,15
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  ld    a,(ix+HeroInventory)            ;this is the unequipped item we are going to move to slot 1-9
  cp    046                             ;scrolls
  jp    nc,.UnableToSwapItems           ;scrolls can not be swapped to slot 1-9
  
  sub   5
  ld    b,15
  jr    c,.InventorySlotFound           ;Sword
  sub   5
  ld    b,14
  jr    c,.InventorySlotFound           ;Armor
  sub   5
  ld    b,13
  jr    c,.InventorySlotFound           ;Shield
  sub   5
  ld    b,12
  jr    c,.InventorySlotFound           ;Helmet
  sub   5
  ld    b,11
  jr    c,.InventorySlotFound           ;Boots
  sub   5
  ld    b,10
  jr    c,.InventorySlotFound           ;Gloves
  sub   5
  ld    b,09
  jr    c,.InventorySlotFound           ;Ring
  sub   5
  ld    b,08
  jr    c,.InventorySlotFound           ;Neclace
  sub   5
  ld    b,07
  jr    c,.InventorySlotFound           ;Robe
;4. the 2 items can be swapped  
  jp    SwapInventoryItems              ;if no item is found, the slot is empty, swap is possible

  .InventorySlotFound:  
  ld    a,c
  cp    b
  jp    nz,.UnableToSwapItems
;4. the 2 items can be swapped  
  jp    SwapInventoryItems              ;swaps the last 2 inventory items that have been selected

  .UnableToSwapItems:
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,15
  sub   a,b
  
;  ld    ix,(plxcurrentheroAddress)
;  ld    d,0
;  ld    e,a
;  add   ix,de  
;  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15

  ld    ix,HeroOverviewInventoryIconButtonTable
  ld    de,HeroOverviewInventoryIconButtonTableLenghtPerIcon
  .loop2:
  jr    z,.Found2
  add   ix,de
  dec   a
  jr    .loop2

  .Found2:                               ;the button that was pressed will now be marked as 'mouse hover over'
  ld    (ix+2),%1000 0011               ; (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    (MenuOptionSelected?BackupLastFrame),a
  ret

SwapInventoryItems:                     ;swaps the last 2 inventory items that have been selected
  push  iy

  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,15
  sub   a,b  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  

  ld    a,(MenuOptionSelected?BackupLastFrame)
  ld    b,a
  ld    a,15
  sub   a,b
  ld    iy,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   iy,de  

  ld    b,(iy+HeroInventory)            ;body slot 1-9 and open slots 10-15 - previous frame
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15 - this frame
  ld    (iy+HeroInventory),a            ;body slot 1-9 and open slots 10-15 - previous frame
  ld    (ix+HeroInventory),b            ;body slot 1-9 and open slots 10-15 - this frame

  pop   iy

  xor   a
  ld    (MenuOptionSelected?),a
  ld    a,255
  ld    (MenuOptionSelected?Backup),a  
  ld    (MenuOptionSelected?BackupLastFrame),a

  pop   af                              ;pop the call to this routine
  ld    a,1
  ld    (SetSkillsDescription?),a       ;clear description window
  jp    HeroOverviewInventoryWindowCode ;restart code, item has been swapped

SetTextInventoryItem:                   ;when clicking on an item, the explanation will appear
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 

  ld    a,(MenuOptionSelected?Backup)   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    b,a
  ld    a,15
  sub   a,b
  
  ld    ix,(plxcurrentheroAddress)
  ld    d,0
  ld    e,a
  add   ix,de  
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15
  
  ld    ix,InventoryDescriptionList
  add   a,a                             ;*2
  ld    e,a
  add   ix,de
  ld    l,(ix)
  ld    h,(ix+1)
  .SetText:

  ld    b,HeroOverViewSpellBookWindowDX + 030 + 1
  ld    c,HeroOverViewSpellBookWindowDY + 159 - 16
  jp    SetText

InventoryDescriptionList:
  dw    DescriptionSword1, DescriptionSword2, DescriptionSword3, DescriptionSword4, DescriptionSword5
  dw    DescriptionArmor1, DescriptionArmor2, DescriptionArmor3, DescriptionArmor4, DescriptionArmor5
  dw    DescriptionShield1, DescriptionShield2, DescriptionShield3, DescriptionShield4, DescriptionShield5
  dw    DescriptionHelmet1, DescriptionHelmet2, DescriptionHelmet3, DescriptionHelmet4, DescriptionHelmet5
  dw    DescriptionBoots1, DescriptionBoots2, DescriptionBoots3, DescriptionBoots4, DescriptionBoots5
  dw    DescriptionGloves1, DescriptionGloves2, DescriptionGloves3, DescriptionGloves4, DescriptionGloves5
  dw    DescriptionRing1, DescriptionRing2, DescriptionRing3, DescriptionRing4, DescriptionRing5
  dw    DescriptionNecklace1, DescriptionNecklace2, DescriptionNecklace3, DescriptionNecklace4, DescriptionNecklace5
  dw    DescriptionRobe1, DescriptionRobe2, DescriptionRobe3, DescriptionRobe4, DescriptionRobe5
  dw    DescriptionEmpty
  dw    DescriptionScrollEarth1, DescriptionScrollEarth2, DescriptionScrollEarth3, DescriptionScrollEarth4
  dw    DescriptionScrollFire1, DescriptionScrollFire2, DescriptionScrollFire3, DescriptionScrollFire4
  dw    DescriptionScrollAir1, DescriptionScrollAir2, DescriptionScrollAir3, DescriptionScrollAir4
  dw    DescriptionScrollWater1, DescriptionScrollWater2, DescriptionScrollWater3, DescriptionScrollWater4
  dw    DescriptionScrollUniversal1, DescriptionScrollUniversal2, DescriptionScrollUniversal3, DescriptionScrollUniversal4

                          ;item 000
DescriptionSword1:        db  "Dagger Time",254 | DaggerTimeAttack: equ 1               
                          db  "Attack +",DaggerTimeAttack+$30,255

                          ;item 001
DescriptionSword2:        db  "Sword of Bahrain",254 | SwordOfBahrainAttack: equ 2
                          db  "Attack +2",255

                          ;item 002
DescriptionSword3:        db  "Hell Slayer",254 | HellSlayerAttack: equ 6 | HellSlayerDefence: equ -2
                          db  "Attack +6",254
                          db  "Defense -2",255

                          ;item 003
DescriptionSword4:        db  "The Butterfly",254 | ButterflyAttack: equ 1 | ButterflyDefence: equ 1 | ButterflyIntelligence: equ 1 | ButterflySpellDamage: equ 1
                          db  "All primary attributes",254
                          db  "+1",255

                          ;item 004
DescriptionSword5:        db  "swiftblade",254 | SwiftbladeAttack: equ 5 | SwiftbladeUnitSpeed: equ 1
                          db  "Attack + 5",254
                          db  "Unit movement speed +1",255

                          ;item 005
DescriptionArmor1:        db  "Regalia Di Pleb",254 | RegaliaDiPlebDefence: equ 1 | RegaliaDiPlebUnitSpeed: equ 1
                          db  "Defense +1",254
                          db  "Unit movement speed +1",255

                          ;item 006
DescriptionArmor2:        db  "Young Blood's Armor",254 | YoungBloodsArmorDefence: equ 2
                          db  "Defense +2",255

                          ;item 007
DescriptionArmor3:        db  "The Juggernaut",254 | TheJuggernautDefence: equ 4 | TheJuggernautUnitSpeed: equ -1
                          db  "Defense +4",254
                          db  "Unit movement speed - 1",255

                          ;item 008
DescriptionArmor4:        db  "Yojimbo the Ronin",254 | YojumboTheRoninDefence: equ 4
                          db  "Defense +4",254
                          db  "-25% damage from fire",255

                          ;item 009
DescriptionArmor5:        db  "Caesar's Chestplate",254 | CeasarsChestplateDefence: equ 5 | CaesarsChestplateUnitHp: equ 2
                          db  "Defense +5",254
                          db  "Max hp units +2",255

                          ;item 010
DescriptionShield1:        db  "Greenleaf Shield",254
                          db  "50% less damage from",254
                          db  "ranged units",255

                          ;item 011
DescriptionShield2:        db  "Wooden shield",254 | WoodenShieldDefence: equ 2
                          db  "Defense +2",255

                          ;item 012
                          db  "Defense +3",254
DescriptionShield3:        db  "The bram stoker",254 | TheBramStokerDefence: equ 3
                          db  "-25% damage from earth",255

                          ;item 013
DescriptionShield4:        db  "Impenetrable shield",254
                          db  "+10% chance to block any",254
                          db  "enemy spell cast",255

                          ;item 014
DescriptionShield5:        db  "Training shield",254 | TrainingShieldDefence: equ 5
                          db  "Defense +5",255

                          ;item 015
DescriptionHelmet1:        db  "Yatta Shi-ne",254 | YattaShiNeDefence: equ 1 | YattaShiNeSpellDamage: equ 1
                          db  "Spell power +1",254
                          db  "Defense +1",255

                          ;item 016
DescriptionHelmet2:        db  "Fire hood",254
                          db  "Spell power +2",254 | FireHoodSpellDamage: equ 2
                          db  "+10% fire spell damage",255

                          ;item 017
DescriptionHelmet3:        db  "Cerebro",254
                          db  "Intelligence +3",255 | CerebroIntelligence: equ 3

                          ;item 018
DescriptionHelmet4:        db  "The Viridescent",254 | TheViridescentDefence: equ 3 | TheViridescentUnitHp: equ 3
                          db  "Defense +3",254
                          db  "Max hp units +3",255

                          ;item 019
DescriptionHelmet5:        db  "Pikemen's Helmet",254 | PikemensHelmetDefence: equ 5 | PikemensHelmetUnitSpeed: equ 1
                          db  "Defense +5",254
                          db  "Unit movement speed +1",255


                          ;item 020
DescriptionBoots1:        db  "Shadow Tramper",254 | ShadowTramperUnitSpeed: equ 1
                          db  "Unit movement speed +1",255

                          ;item 021
DescriptionBoots2:        db  "Dusk Rover",254
                          db  "No terrain penalty",254
                          db  "for hero on worldmap",255

                          ;item 022
DescriptionBoots3:        db  "Planeswalkers",254
                          db  "+3 max movement points",254
                          db  "for hero on worldmap",255

                          ;item 023
DescriptionBoots4:        db  "Knight's Night Slippers",254
                          db  "-25% damage from water",255

                          ;item 024
DescriptionBoots5:        db  "Sturdy Boots",254 | SturdyBootsUnitSpeed: equ 3
                          db  "Unit movement speed +3",255

                          ;item 025
DescriptionGloves1:        db  "Gripfast",254
                          db  "+2 max movement points",254
                          db  "for hero on worldmap",255

                          ;item 026
DescriptionGloves2:        db  "Iron Hand",254 | IronHandUnitSpeed: equ -1
                          db  "-30% damage from air",254
                          db  "Unit movement speed -1",255

                          ;item 027
DescriptionGloves3:        db  "Elk Skin Gloves",254 | ElkSkinGlovesUnitHp: equ 2 | ElkSkinGlovesAttack: equ 2
                          db  "Attack +2",254
                          db  "Max hp units +2",255

                          ;item 028
DescriptionGloves4:        db  "Venomous gauntlet",254
                          db  "Melee Attacks deal",254
                          db  "poison damage '20 dpt'",255

                          ;item 029
DescriptionGloves5:        db  "Emerald Gloves",254 | EmeraldGlovesIntelligence: equ 5
                          db  "Intelligence +5",255

                          ;item 030
DescriptionRing1:        db  "Small Ring",254 | SmallRingSpellDamage: equ 1
                          db  "Spell power +1",255

                          ;item 031
DescriptionRing2:        db  "Cyclops",254 | CyclopsIntelligence: equ 2
                          db  "Intelligence +2",255

                          ;item 032
DescriptionRing3:        db  "Scarlet Ring",254 | ScarletRingAttack: equ 1 | ScarletRingDefence: equ 1 | ScarletRingIntelligence: equ 1 | ScarletRingSpellPower: equ 1    
                          db  "All primary attributes",254
                          db  "+1",255

                          ;item 033
DescriptionRing4:        db  "Bronze Ring",254
                          db  "+20% earth spell damage",255

                          ;item 034
DescriptionRing5:        db  "Hypnotising Ring",254
                          db  "+25% water spell damage",255

                          ;item 035
DescriptionNecklace1:        db  "The Blue Topaz",254
                          db  "-25% damage from water",255

                          ;item 036
DescriptionNecklace2:        db  "Good Luck Charm",254
                          db  "+5% chance to block any",254
                          db  "enemy spell cast",255

                          ;item 037
DescriptionNecklace3:        db  "Negligee of Teeth",254 | NegligeeOfTeethIntelligence: equ 1 | NegligeeOfTeethSpellPower: equ 2
                          db  "Intelligence +1",254
                          db  "Spell power +2",255

                          ;item 038
DescriptionNecklace4:        db  "Skull of the Unborn",254
                          db  "Increases Necromancy",254
                          db  "skill by 10%",255

                          ;item 039
DescriptionNecklace5:        db  "The Choker",254 | TheChokerSpellPower: equ 6
                          db  "Spell power +6",255

                          ;item 040
DescriptionRobe1:        db  "The King's Garment",254
                          db  "Increases wealth by",254
                          db  "125 gold per day",255

                          ;item 041
DescriptionRobe2:        db  "Priest's Cope",254 | PriestsCopeIntelligence: equ 2  
                          db  "+10% air spell damage",254
                          db  "Intelligence +2",255

                          ;item 042
DescriptionRobe3:        db  "Enchanted Robe",254 | EnchantedRobeSpellPower: equ 3
                          db  "Spell power +3",255

                          ;item 043
DescriptionRobe4:        db  "Rural Vest",254 | RuralVestUnitHp: equ 4
                          db  "Max hp units +4",255

                          ;item 044
DescriptionRobe5:        db  "Labcoat",254 | LabCoatSpellPower: equ 7 | LabcoatUnitHp: equ -2
                          db  "Spell power +7",254
                          db  "Max hp units -2",255

                          ;item 045
DescriptionEmpty:        db  255

                          ;item 046
DescriptionScrollEarth1:        db  "SpellScroll: Earthbound",255
DescriptionScrollEarth2:        db  "SpellScroll: Plate Armor",255
DescriptionScrollEarth3:        db  "SpellScroll: Resurrection",255
DescriptionScrollEarth4:        db  "SpellScroll: Earthshock",255

DescriptionScrollFire1:        db  "SpellScroll: Curse",255
DescriptionScrollFire2:        db  "SpellScroll: Blinding Fog",255
DescriptionScrollFire3:        db  "SpellScroll: Implosion",255
DescriptionScrollFire4:        db  "SpellScroll: Sunstrike",255

DescriptionScrollAir1:        db  "SpellScroll: Haste",255
DescriptionScrollAir2:        db  "SpellScroll: ShieldBreaker",255
DescriptionScrollAir3:        db  "SpellScroll: Claw Back",255
DescriptionScrollAir4:        db  "SpellScroll: Spell Bubble",255

DescriptionScrollWater1:        db  "SpellScroll: Cure",255
DescriptionScrollWater2:        db  "SpellScroll: Ice Peak",255
DescriptionScrollWater3:        db  "SpellScroll: Hypnosis",255
DescriptionScrollWater4:        db  "SpellScroll: Frost Ring",255

DescriptionScrollUniversal1:        db  "SpellScroll: Magic Arrows",255
DescriptionScrollUniversal2:        db  "SpellScroll: Frenzy",255
DescriptionScrollUniversal3:        db  "SpellScroll: Teleport",255
DescriptionScrollUniversal4:        db  "SpellScroll: Primal Instinct",255

CreateInventoryListForCurrHero:         ;writes icon coordinates to list:ButtonTableInventoryIconsSYSX
  ld    ix,(plxcurrentheroAddress)
  ld    iy,ButtonTableInventoryIconsSYSX

  ld    b,9+6                           ;9+6 inventory slots

  .loop:
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15
  call  CheckScrollIcon                 ;scroll icons have nr 46-65 (but all use the same icon)
  add   a,a                             ;*2
  add   a,a                             ;*4
  ld    d,0
  ld    e,a
  ld    hl,InventoryIconTableSYSX
  add   hl,de
  ld    a,(hl)
  ld    (iy+0),a                        ;sy
  inc   hl
  ld    a,(hl)
  ld    (iy+1),a                        ;sy
  inc   hl
  ld    a,(hl)
  ld    (iy+2),a                        ;sx
  inc   hl
  ld    a,(hl)
  ld    (iy+3),a                        ;sx
  ld    de,6
  add   iy,de                           ;next button in ButtonTableInventoryIconsSYSX
  inc   ix                              ;next hero-inventory item
  djnz  .loop
  ret

CheckScrollIcon:
  cp    ScrollIconNR
  ret   c
  ld    a,ScrollIconNR
  ret

SetInventoryIcons:
  ld    ix,(plxcurrentheroAddress)

  call  .SetIconHLBCandA
  ld    de,$0000 + (InventoryItem01DY*128) + (InventoryItem01DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem02DY*128) + (InventoryItem02DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem03DY*128) + (InventoryItem03DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem04DY*128) + (InventoryItem04DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem05DY*128) + (InventoryItem05DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem06DY*128) + (InventoryItem06DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem07DY*128) + (InventoryItem07DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem08DY*128) + (InventoryItem08DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem09DY*128) + (InventoryItem09DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;6 open slots
  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem10DY*128) + (InventoryItem10DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem11DY*128) + (InventoryItem11DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem12DY*128) + (InventoryItem12DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem13DY*128) + (InventoryItem13DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem14DY*128) + (InventoryItem14DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  .SetIconHLBCandA  
  ld    de,$0000 + (InventoryItem15DY*128) + (InventoryItem15DX/2)
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret

  .SetIconHLBCandA:
  ld    a,(ix+HeroInventory)            ;body slot 1-9 and open slots 10-15
  call  CheckScrollIcon                 ;scroll icons have nr 46-65 (but all use the same icon)
  add   a,a                             ;*2
  add   a,a                             ;*2
  ld    iy,InventoryIconTableSYSX
  ld    d,0
  ld    e,a
  add   iy,de
  ld    l,(iy)
  ld    h,(iy+1)
  inc   ix
  ld    bc,$0000 + (InventoryItemNY*256) + (InventoryItemNX/2)
  ld    a,InventoryGraphicsBlock;Map block  
  ret


PlaceWaterSpellsInSpellBook:
  ld    ix,(plxcurrentheroAddress)

  ;water spells
  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Water + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a    
  ld    a,58                          ;spell scroll water level 1
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceWaterSpellLevel1
  bit   0,(ix+HeroWaterSpells)
  jr    z,.EndPlaceWaterSpell1
  .PlaceWaterSpellLevel1:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Water + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell1backdropDY*128) + (HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell13IconSY*128) + (Spell13IconSX/2) -128
  ld    de,$0000 + (Spell1DY*128) + (Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell1:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Water + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a    
  ld    a,59                          ;spell scroll water level 2
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceWaterSpellLevel2
  bit   1,(ix+HeroWaterSpells)
  jr    z,.EndPlaceWaterSpell2
  .PlaceWaterSpellLevel2:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Water + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell2backdropDY*128) + (HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell14IconSY*128) + (Spell14IconSX/2) -128
  ld    de,$0000 + (Spell2DY*128) + (Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell2:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Water + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a    
  ld    a,60                          ;spell scroll water level 3
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceWaterSpellLevel3
  bit   2,(ix+HeroWaterSpells)
  jr    z,.EndPlaceWaterSpell3
  .PlaceWaterSpellLevel3:  
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Water + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell3backdropDY*128) + (HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell15IconSY*128) + (Spell15IconSX/2) -128
  ld    de,$0000 + (Spell3DY*128) + (Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell3:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Water + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a    
  ld    a,61                          ;spell scroll water level 4
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceWaterSpellLevel4
  bit   3,(ix+HeroWaterSpells)
  jr    z,.EndPlaceWaterSpell4
  .PlaceWaterSpellLevel4:  
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Water + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell4backdropDY*128) + (HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell16IconSY*128) + (Spell16IconSX/2) -128
  ld    de,$0000 + (Spell4DY*128) + (Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceWaterSpell4:
  jp    PlaceAllSpellSchoolSpellsInSpellBook

PlaceAirSpellsInSpellBook:
  ld    ix,(plxcurrentheroAddress)

  ;air spells
  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Air + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,54                          ;spell scroll air level 1
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceAirSpellLevel1
  bit   0,(ix+HeroAirSpells)
  jr    z,.EndPlaceAirSpell1
  .PlaceAirSpellLevel1:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Air + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell1backdropDY*128) + (HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell09IconSY*128) + (Spell09IconSX/2) -128
  ld    de,$0000 + (Spell1DY*128) + (Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell1:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Air + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,55                          ;spell scroll air level 2
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceAirSpellLevel2
  bit   1,(ix+HeroAirSpells)
  jr    z,.EndPlaceAirSpell2
  .PlaceAirSpellLevel2:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Air + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell2backdropDY*128) + (HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell10IconSY*128) + (Spell10IconSX/2) -128
  ld    de,$0000 + (Spell2DY*128) + (Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell2:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Air + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,56                          ;spell scroll air level 3
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceAirSpellLevel3
  bit   2,(ix+HeroAirSpells)
  jr    z,.EndPlaceAirSpell3
  .PlaceAirSpellLevel3:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Air + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell3backdropDY*128) + (HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell11IconSY*128) + (Spell11IconSX/2) -128
  ld    de,$0000 + (Spell3DY*128) + (Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell3:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Air + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a  
  ld    a,57                          ;spell scroll air level 4
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceAirSpellLevel4
  bit   3,(ix+HeroAirSpells)
  jr    z,.EndPlaceAirSpell4
  .PlaceAirSpellLevel4:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Air + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell4backdropDY*128) + (HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell12IconSY*128) + (Spell12IconSX/2) -128
  ld    de,$0000 + (Spell4DY*128) + (Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAirSpell4:
  jp    PlaceAllSpellSchoolSpellsInSpellBook
  
PlaceFireSpellsInSpellBook:
  ld    ix,(plxcurrentheroAddress)

  ;fire spells
  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Fire + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,50                          ;spell scroll fire level 1
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceFireSpellLevel1
  bit   0,(ix+HeroFireSpells)
  jr    z,.EndPlaceFireSpell1
  .PlaceFireSpellLevel1:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Fire + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell1backdropDY*128) + (HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell05IconSY*128) + (Spell05IconSX/2) -128
  ld    de,$0000 + (Spell1DY*128) + (Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell1:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Fire + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,51                          ;spell scroll fire level 2
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceFireSpellLevel2
  bit   1,(ix+HeroFireSpells)
  jr    z,.EndPlaceFireSpell2
  .PlaceFireSpellLevel2:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Fire + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
    
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell2backdropDY*128) + (HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell06IconSY*128) + (Spell06IconSX/2) -128
  ld    de,$0000 + (Spell2DY*128) + (Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell2:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Fire + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,52                          ;spell scroll fire level 3
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceFireSpellLevel3
  bit   2,(ix+HeroFireSpells)
  jr    z,.EndPlaceFireSpell3
  .PlaceFireSpellLevel3:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Fire + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell3backdropDY*128) + (HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell07IconSY*128) + (Spell07IconSX/2) -128
  ld    de,$0000 + (Spell3DY*128) + (Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell3:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Fire + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,53                          ;spell scroll fire level 4
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceFireSpellLevel4
  bit   3,(ix+HeroFireSpells)
  jr    z,.EndPlaceFireSpell4
  .PlaceFireSpellLevel4:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Fire + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell4backdropDY*128) + (HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell08IconSY*128) + (Spell08IconSX/2) -128
  ld    de,$0000 + (Spell4DY*128) + (Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceFireSpell4:
  jp    PlaceAllSpellSchoolSpellsInSpellBook


CheckSpellScrollAvailable: ;out: z=scroll found
  cp    (ix+HeroInventory+9)
  ret   z
  cp    (ix+HeroInventory+10)
  ret   z
  cp    (ix+HeroInventory+11)
  ret   z
  cp    (ix+HeroInventory+12)
  ret   z
  cp    (ix+HeroInventory+13)
  ret   z
  cp    (ix+HeroInventory+14)
  ret
  
PlaceEarthSpellsInSpellBook:
  ld    ix,(plxcurrentheroAddress)

  ;earth spells
  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,46                          ;spell scroll earth level 1
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceEarthSpellLevel1
  bit   0,(ix+HeroEarthSpells)
  jr    z,.EndPlaceEarthSpell1
  .PlaceEarthSpellLevel1:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (0 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell1backdropDY*128) + (HeroOverViewSpell1backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set backdrop
  ld    hl,$4000 + (Spell01IconSY*128) + (Spell01IconSX/2) -128
  ld    de,$0000 + (Spell1DY*128) + (Spell1DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell1:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,47                          ;spell scroll earth level 2
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceEarthSpellLevel2
  bit   1,(ix+HeroEarthSpells)
  jr    z,.EndPlaceEarthSpell2
  .PlaceEarthSpellLevel2:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (1 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell2backdropDY*128) + (HeroOverViewSpell2backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell02IconSY*128) + (Spell02IconSX/2) -128
  ld    de,$0000 + (Spell2DY*128) + (Spell2DX/2)
  ld    bc,$0000 + (SpellIconNY*   256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell2:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,48                          ;spell scroll earth level 3
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceEarthSpellLevel3
  bit   2,(ix+HeroEarthSpells)
  jr    z,.EndPlaceEarthSpell3
  .PlaceEarthSpellLevel3:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (2 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell3backdropDY*128) + (HeroOverViewSpell3backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell03IconSY*128) + (Spell03IconSX/2) -128
  ld    de,$0000 + (Spell3DY*128) + (Spell3DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell3:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    a,49                          ;spell scroll earth level 4
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceEarthSpellLevel4
  bit   3,(ix+HeroEarthSpells)
  jr    z,.EndPlaceEarthSpell4
  .PlaceEarthSpellLevel4:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (3 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell4backdropDY*128) + (HeroOverViewSpell4backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell04IconSY*128) + (Spell04IconSX/2) -128
  ld    de,$0000 + (Spell4DY*128) + (Spell4DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceEarthSpell4:
  jp    PlaceAllSpellSchoolSpellsInSpellBook

PlaceAllSpellSchoolSpellsInSpellBook:
  ld    ix,(plxcurrentheroAddress)
  ;all spellschools
  
  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    a,62                          ;spell scroll universal level 1
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceUniversalSpellLevel1
  bit   0,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell1  
  .PlaceUniversalSpellLevel1:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (4 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
 
  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell5backdropDY*128) + (HeroOverViewSpell5backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  ld    de,$0000 + (Spell5DY*128) + (Spell5DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell1:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    a,63                          ;spell scroll universal level 2
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceUniversalSpellLevel2
  bit   1,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell2  
  .PlaceUniversalSpellLevel2:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (5 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell6backdropDY*128) + (HeroOverViewSpell6backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  ld    de,$0000 + (Spell6DY*128) + (Spell6DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell2:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    a,64                          ;spell scroll universal level 3
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceUniversalSpellLevel3
  bit   2,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell3  
  .PlaceUniversalSpellLevel3:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (6 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell7backdropDY*128) + (HeroOverViewSpell7backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  ld    de,$0000 + (Spell7DY*128) + (Spell7DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell3:

  xor   a
  ld    (HeroOverviewSpellIconButtonTable_Earth + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    a,65                          ;spell scroll universal level 4
  call  CheckSpellScrollAvailable  ;out: z=scroll found
  jr    z,.PlaceUniversalSpellLevel3
  bit   3,(ix+HeroAllSchoolsSpells)
  jr    z,.EndPlaceAllSchoolsSpell4
  .PlaceUniversalSpellLevel4:
  ld    a,%1000 0011
  ld    (HeroOverviewSpellIconButtonTable_Earth + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Fire+ (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Air + (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 
  ld    (HeroOverviewSpellIconButtonTable_Water+ (7 * ButtonTableLenght) + HeroOverviewWindowButtonStatus),a 

  ld    hl,$4000 + (HeroOverViewSpellBackdropSY*128) + (HeroOverViewSpellBackdropSX/2) -128
  ld    de,$0000 + (HeroOverViewSpell8backdropDY*128) + (HeroOverViewSpell8backdropDX/2)
  ld    bc,$0000 + (HeroOverViewSpellbackdropNY*256) + (HeroOverViewSpellbackdropNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  ld    de,$0000 + (Spell8DY*128) + (Spell8DX/2)
  ld    bc,$0000 + (SpellIconNY*256) + (SpellIconNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY | Set spell
  .EndPlaceAllSchoolsSpell4:
  ret


HeroOverviewSpellBookWindowCode_Water:
;  call  ResetStatusSpellBookButtons
  call  SetHeroOverViewSpellBookWindow  ;set skills Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Water
  call  PlaceWaterSpellsInSpellBook
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSpellBookWindow  ;set SpellBook Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Water
  call  PlaceWaterSpellsInSpellBook

  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz
  
  ld    ix,HeroOverviewSpellBookButtonTable_Water
  ld    iy,ButtonTableSpellBookSYSX_Water
  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.ElementalButtonPressed

  call  CheckEndHeroOverviewSpellBook   ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewSpellBookButtonTable_Water
  call  SetButtonStatusAndText2          ;copies button state from rom -> vram




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ld    ix,HeroOverviewSpellIconButtonTable_Water
  ld    iy,ButtonTableSpellIconsWaterSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.SpellIconPressed

;call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetSpellExplanation_Water        ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear

  ld    ix,HeroOverviewSpellIconButtonTable_Water
  call  SetButtonStatusAndText2         ;copies button state from rom -> vram

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  
  call  SwapAndSetPage                  ;swap and set page  

  halt
  jp  .engine

  .ElementalButtonPressed:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,AirSelected
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,FireSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,EarthSelected
  ret



  .SpellIconPressed:
  ld    (MenuOptionSelected?Backup),a
  xor   a
  ld    (MenuOptionSelected?),a
;  ld    (ActivatedSpellIconButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  jp    HeroOverviewSpellBookWindowCode_Water





















HeroOverviewSpellBookWindowCode_Air:
;  call  ResetStatusSpellBookButtons
  call  SetHeroOverViewSpellBookWindow  ;set skills Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Air
  call  PlaceAirSpellsInSpellBook
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSpellBookWindow  ;set SpellBook Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Air
  call  PlaceAirSpellsInSpellBook

  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz
  
  ld    ix,HeroOverviewSpellBookButtonTable_Air
  ld    iy,ButtonTableSpellBookSYSX_Air
  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.ElementalButtonPressed

  call  CheckEndHeroOverviewSpellBook   ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewSpellBookButtonTable_Air
  call  SetButtonStatusAndText2          ;copies button state from rom -> vram



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ld    ix,HeroOverviewSpellIconButtonTable_Air
  ld    iy,ButtonTableSpellIconsAirSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.SpellIconPressed

;call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetSpellExplanation_Air        ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear

  ld    ix,HeroOverviewSpellIconButtonTable_Air
  call  SetButtonStatusAndText2         ;copies button state from rom -> vram

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  call  SwapAndSetPage                  ;swap and set page  

  halt
  jp  .engine

  .ElementalButtonPressed:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,WaterSelected
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,FireSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,EarthSelected
  ret
  



  .SpellIconPressed:
  ld    (MenuOptionSelected?Backup),a
  xor   a
  ld    (MenuOptionSelected?),a
;  ld    (ActivatedSpellIconButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  jp    HeroOverviewSpellBookWindowCode_Air


    
  
  
  
  
  
  
HeroOverviewSpellBookWindowCode_Fire:
;  call  ResetStatusSpellBookButtons
  call  SetHeroOverViewSpellBookWindow  ;set skills Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Fire
  call  PlaceFireSpellsInSpellBook
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSpellBookWindow  ;set SpellBook Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Fire
  call  PlaceFireSpellsInSpellBook

  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz
  
  ld    ix,HeroOverviewSpellBookButtonTable_Fire
  ld    iy,ButtonTableSpellBookSYSX_Fire
  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.ElementalButtonPressed

  call  CheckEndHeroOverviewSpellBook   ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewSpellBookButtonTable_Fire
  call  SetButtonStatusAndText2          ;copies button state from rom -> vram





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ld    ix,HeroOverviewSpellIconButtonTable_Fire
  ld    iy,ButtonTableSpellIconsFireSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.SpellIconPressed

;call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetSpellExplanation_Fire        ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear

  ld    ix,HeroOverviewSpellIconButtonTable_Fire
  call  SetButtonStatusAndText2         ;copies button state from rom -> vram

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




  call  SwapAndSetPage                  ;swap and set page  

  halt
  jp  .engine

  .ElementalButtonPressed:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,WaterSelected
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,AirSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,EarthSelected
  ret








  .SpellIconPressed:
  ld    (MenuOptionSelected?Backup),a
  xor   a
  ld    (MenuOptionSelected?),a
;  ld    (ActivatedSpellIconButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  jp    HeroOverviewSpellBookWindowCode_Fire

















HeroOverviewSpellBookWindowCode_Earth:


;  call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0


;  call  ResetStatusSpellBookButtons
  call  SetHeroOverViewSpellBookWindow  ;set skills Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Earth            ;activate the elemental button on the left side
  call  PlaceEarthSpellsInSpellBook     ;check which earth spells player has available, and set those in the spell book
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewSpellBookWindow  ;set SpellBook Window in inactive page
  call  ClearWhiteWindow
  call  ActivateButton_Earth
  call  PlaceEarthSpellsInSpellBook     ;check which earth spells player has available, and set those in the spell book

  .engine:
  call  PopulateControls                ;read out keys

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

  ld    ix,HeroOverviewSpellBookButtonTable_Earth
  ld    iy,ButtonTableSpellBookSYSX_Earth
  call  CheckButtonMouseInteraction
  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.ElementalButtonPressed

  call  CheckEndHeroOverviewSpellBook   ;check if mouse is clicked outside of window. If so, return to game

  ld    ix,HeroOverviewSpellBookButtonTable_Earth
  call  SetButtonStatusAndText2          ;copies button state from rom -> vram


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ld    ix,HeroOverviewSpellIconButtonTable_Earth
  ld    iy,ButtonTableSpellIconsEarthSYSX
  call  CheckButtonMouseInteraction

  ld    a,(MenuOptionSelected?)
  or    a
  jp    nz,.SpellIconPressed

;call  SetHeroOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetSpellExplanation_Earth             ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear

  ld    ix,HeroOverviewSpellIconButtonTable_Earth
  call  SetButtonStatusAndText2         ;copies button state from rom -> vram

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;  ld    ix,HeroOverviewSpellIconButtonTable_AllSpellSchools
;  ld    iy,ButtonTableSpellIconsSYSX
;  call  CheckButtonMouseInteraction

;  ld    a,(MenuOptionSelected?)
;  or    a
;  jp    nz,.SpellIconPressed

;  call  SetSpellExplanation_Earth             ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear

;  ld    ix,HeroOverviewSpellIconButtonTable_AllSpellSchools
;  call  SetButtonStatusAndText2         ;copies button state from rom -> vram











  call  SwapAndSetPage                  ;swap and set page  

  halt
  jp  .engine





  .SpellIconPressed:
  ld    (MenuOptionSelected?Backup),a
  xor   a
  ld    (MenuOptionSelected?),a
;  ld    (ActivatedSpellIconButton),ix
  ld    a,3
  ld    (SetSkillsDescription?),a  
  ld    (ix+HeroOverviewWindowButtonStatus),%1000 0011
  jp    HeroOverviewSpellBookWindowCode_Earth

  .ElementalButtonPressed:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,WaterSelected
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,AirSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jp    z,FireSelected
  ret

ClearWhiteWindow:
  ld    hl,$4000 + ((HeroOverViewSpellBookWindowSY+159)*128) + ((HeroOverViewSpellBookWindowSX+28)/2) -128
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY+159)*128) + ((HeroOverViewSpellBookWindowDX+008)/2)
  ld    bc,$0000 + (18*256) + (20/2)
  ld    a,SpellBookGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY  

SetWhiteWindow:
  ld    hl,$4000 + ((HeroOverViewSpellBookWindowSY+159)*128) + ((HeroOverViewSpellBookWindowSX+008)/2) -128
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY+159)*128) + ((HeroOverViewSpellBookWindowDX+008)/2)
  ld    bc,$0000 + (18*256) + (20/2)
  ld    a,SpellBookGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY  

SpellDescriptions:

.DescriptionEarth4:       db  "Earthbound",254
                          db  "Reduces the speed of the selected",254
                          db  "enemy unit by 50%",255

.DescriptionEarth3:       db  "Plate Armor",254
                          db  "Increases the defense of the selected",254
                          db  "friendly unit by 5.",255

.DescriptionEarth2:       db  "Resurrection",254
                          db  "Reanimates     HP of killed living",254
                          db  "friendly creatures.",255

.DescriptionEarth1:       db  "Earthshock",254
                          db  "Deals damage to all creatures in target",254
                          db  "and adjacent hexes.",255


.DescriptionFire4:        db  "Curse",254
                          db  "Causes the selected enemy unit to deal",254
                          db  "-3 damage when attacking.",255

.DescriptionFire3:        db  "Blinding Fog",254
                          db  "Target ranged unit deals 50% less",254
                          db  "damage.",255

.DescriptionFire2:        db  "Implosion",254
                          db  "Deals damage to enemy unit and",254
                          db  "adjecent units.",255

.DescriptionFire1:        db  "Sunstrike",254
                          db  "Calls down a solar beam to incinerate",254
                          db  "a single enemy unit.",255

.Descriptionair4:         db  "Haste",254
                          db  "Increases the speed of the selected",254
                          db  "friendly unit by 3.",255

.Descriptionair3:         db  "Shieldbreaker",254
                          db  "Reduces the defense of the selected ",254
                          db  "enemy unit by 4.",255

.Descriptionair2:         db  "Claw Back",254
                          db  "Target allied unit has unlimited",254
                          db  "retaliations each round.",255

.Descriptionair1:         db  "Spell Bubble",254
                          db  "Target friendly unit has a 75% chance",254
                          db  "to deflect a single enemy spell.",255


.Descriptionwater4:       db  "Cure",254
                          db  "Removes all negative spell effects",254
                          db  "and heals for     HP.",255

.Descriptionwater3:       db  "Ice Peak",254
                          db  "Conjures an ice shard from the ground,",254
                          db  "impaling a single enemy.",255

.Descriptionwater2:       db  "Hypnosis",254
                          db  "Enemy unit cant attack until attacked,",254
                          db  "dispelled or effect wears off.",255


.Descriptionwater1:       db  "Frost Ring",254
                          db  "Causes damage to all units adjacent to",254
                          db  "the central hex.",255


.DescriptionAllSpellSchools4:  db  "magic arrows",254
                              db  "Unleashes a relentless volley of arrows",254
                              db  "at a single enemy unit.",255

.DescriptionAllSpellSchools3:  db  "Frenzy",254
                              db  "Friendly unit's damage increases by 5",254
                              db  "while its defense decreases by 5.",255

.DescriptionAllSpellSchools2:  db  "Teleport",254
                              db  "Instantaneously displaces an allied",254
                              db  "troop to an an unoccupied space.",255

.DescriptionAllSpellSchools1:  db  "Primal Instinct",254
                              db  "Friendly unit receives +3 damage,",254
                              db  "+3 defense and +3 speed.",255


SetSpellExplanation_Water:
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 

  call  .GoSetText
  call  .SetSpellIcon
  call  .SetCost
  call  .SetDamage
  ret

  .SetDamage:
  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools1
  jp    z,DamageAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools2
  jp    z,DamageAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools3
  jp    z,DamageAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools4
  jp    z,DamageAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageWaterSpell1
  jp    z,DamageAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageWaterSpell2
  jp    z,DamageAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageWaterSpell3
  jp    z,DamageAmountFound
  ld    b,DamageWaterSpell4
  jp    DamageAmountFound

  .SetCost:
  ld    a,(MenuOptionSelected?Backup) 
  cp    1                               ;a = (ix+H eroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools1
  jp    z,CostAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools2
  jp    z,CostAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools3
  jp    z,CostAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools4
  jp    z,CostAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostWaterSpell1
  jp    z,CostAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostWaterSpell2
  jp    z,CostAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostWaterSpell3
  jp    z,CostAmountFound
  ld    b,CostWaterSpell4
  jp    CostAmountFound

  .SetSpellIcon:
  call  SetWhiteWindow

  ld    a,(MenuOptionSelected?Backup)

  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  jp    z,.SetIcon
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  jp    z,.SetIcon
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  jp    z,.SetIcon
  cp    4
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  jp    z,.SetIcon  
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell16IconSY*128) + (Spell16IconSX/2) -128
  jp    z,.SetIcon
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell15IconSY*128) + (Spell15IconSX/2) -128
  jp    z,.SetIcon
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell14IconSY*128) + (Spell14IconSX/2) -128
  jp    z,.SetIcon
  ld    hl,$4000 + (Spell13IconSY*128) + (Spell13IconSX/2) -128
  .SetIcon:
  
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY + 160) *128) + ((HeroOverViewSpellBookWindowDx+10)/2)
  ld    bc,$0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .GoSetText:
  ld    a,(MenuOptionSelected?Backup)

  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools1
  jp    z,.SetText
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools2
  jp    z,.SetText
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools3
  jp    z,.SetText
  cp    4
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools4
  jp    z,.SetText


  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.Descriptionwater1
  jp    z,.SetText
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.Descriptionwater2
  jp    z,.SetText
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.Descriptionwater3
  jp    z,.SetText
  ld    hl,SpellDescriptions.Descriptionwater4
  .SetText:

  ld    b,HeroOverViewSpellBookWindowDX + 030
  ld    c,HeroOverViewSpellBookWindowDY + 159
  jp    SetText








SetSpellExplanation_Air:
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 

  call  .GoSetText
  call  .SetSpellIcon
  call  .SetCost
  call  .SetDamage
  ret

  .SetDamage:
  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools1
  jp    z,DamageAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools2
  jp    z,DamageAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools3
  jp    z,DamageAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools4
  jp    z,DamageAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAirSpell1
  jp    z,DamageAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAirSpell2
  jp    z,DamageAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAirSpell3
  jp    z,DamageAmountFound
  ld    b,DamageAirSpell4
  jp    DamageAmountFound

  .SetCost:
  ld    a,(MenuOptionSelected?Backup) 
  cp    1                               ;a = (ix+H eroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools1
  jp    z,CostAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools2
  jp    z,CostAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools3
  jp    z,CostAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools4
  jp    z,CostAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAirSpell1
  jp    z,CostAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAirSpell2
  jp    z,CostAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAirSpell3
  jp    z,CostAmountFound
  ld    b,CostAirSpell4
  jp    CostAmountFound

  .SetSpellIcon:
  call  SetWhiteWindow

  ld    a,(MenuOptionSelected?Backup)

  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  jp    z,.SetIcon
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  jp    z,.SetIcon
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  jp    z,.SetIcon
  cp    4
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  jp    z,.SetIcon
  
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell12IconSY*128) + (Spell12IconSX/2) -128
  jp    z,.SetIcon
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell11IconSY*128) + (Spell11IconSX/2) -128
  jp    z,.SetIcon
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell10IconSY*128) + (Spell10IconSX/2) -128
  jp    z,.SetIcon
  ld    hl,$4000 + (Spell09IconSY*128) + (Spell09IconSX/2) -128
  .SetIcon:
  
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY + 160) *128) + ((HeroOverViewSpellBookWindowDx+10)/2)
  ld    bc,$0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .GoSetText:
  ld    a,(MenuOptionSelected?Backup)

  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools1
  jp    z,.SetText
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools2
  jp    z,.SetText
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools3
  jp    z,.SetText
  cp    4
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools4
  jp    z,.SetText

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAir1
  jp    z,.SetText
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAir2
  jp    z,.SetText
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAir3
  jp    z,.SetText
  ld    hl,SpellDescriptions.DescriptionAir4
  .SetText:

  ld    b,HeroOverViewSpellBookWindowDX + 030
  ld    c,HeroOverViewSpellBookWindowDY + 159
  jp    SetText


























SetSpellExplanation_Fire:
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 

  call  .GoSetText
  call  .SetSpellIcon
  call  .SetCost
  call  .SetDamage
  ret

  .SetDamage:
  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools1
  jp    z,DamageAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools2
  jp    z,DamageAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools3
  jp    z,DamageAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools4
  jp    z,DamageAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageFireSpell1
  jp    z,DamageAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageFireSpell2
  jp    z,DamageAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageFireSpell3
  jp    z,DamageAmountFound
  ld    b,DamageFireSpell4
  jp    DamageAmountFound

  .SetCost:
  ld    a,(MenuOptionSelected?Backup) 
  cp    1                               ;a = (ix+H eroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools1
  jp    z,CostAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools2
  jp    z,CostAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools3
  jp    z,CostAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools4
  jp    z,CostAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostFireSpell1
  jp    z,CostAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostFireSpell2
  jp    z,CostAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostFireSpell3
  jp    z,CostAmountFound
  ld    b,CostFireSpell4
  jp    CostAmountFound

  .SetSpellIcon:
  call  SetWhiteWindow

  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  jp    z,.SetIcon
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  jp    z,.SetIcon
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  jp    z,.SetIcon
  cp    4
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  jp    z,.SetIcon
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell08IconSY*128) + (Spell08IconSX/2) -128
  jp    z,.SetIcon
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell07IconSY*128) + (Spell07IconSX/2) -128
  jp    z,.SetIcon
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell06IconSY*128) + (Spell06IconSX/2) -128
  jp    z,.SetIcon
  ld    hl,$4000 + (Spell05IconSY*128) + (Spell05IconSX/2) -128
  .SetIcon:
  
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY + 160) *128) + ((HeroOverViewSpellBookWindowDx+10)/2)
  ld    bc,$0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .GoSetText:
  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools1
  jp    z,.SetText
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools2
  jp    z,.SetText
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools3
  jp    z,.SetText
  cp    4
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools4
  jp    z,.SetText

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionFire1
  jp    z,.SetText
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionFire2
  jp    z,.SetText
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionFire3
  jp    z,.SetText
  cp    8
  ld    hl,SpellDescriptions.DescriptionFire4
  jp    z,.SetText
  .SetText:

  ld    b,HeroOverViewSpellBookWindowDX + 030
  ld    c,HeroOverViewSpellBookWindowDY + 159
  jp    SetText

















DamageAmountFound:
  ld    a,b
  or    a
  ret   z
  ld    b,HeroOverViewSpellBookWindowDX + 168
  ld    c,HeroOverViewSpellBookWindowDY + 173
  push  iy
  ld    l,a
  ld    h,0
  call  SetNumber16BitCastle
  pop   iy

  ld    b,HeroOverViewSpellBookWindowDX + 132
  ld    c,HeroOverViewSpellBookWindowDY + 173
  ld    hl,.TextDamage
  jp    SetText
  .TextDamage: db  "Damage:",255

CostAmountFound:
  ld    a,b
  or    a
  ret   z
  ld    b,HeroOverViewSpellBookWindowDX + 174
  ld    c,HeroOverViewSpellBookWindowDY + 159
  push  iy
  ld    l,a
  ld    h,0
  call  SetNumber16BitCastle
  pop   iy

  ld    b,HeroOverViewSpellBookWindowDX + 148
  ld    c,HeroOverViewSpellBookWindowDY + 159
  ld    hl,.TextCost
  jp    SetText
  .TextCost: db  "Cost:",255

SetSpellExplanation_Earth:              ;when clicking on a skill, the explanation will appear, the icon will appear and the damage and cost will appear
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 

  call  .GoSetText
  call  .SetSpellIcon
  call  .SetCost
  call  .SetDamage
  ret

  .SetDamage:
  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools1
  jp    z,DamageAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools2
  jp    z,DamageAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools3
  jp    z,DamageAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageAllSpellSchools4
  jp    z,DamageAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageEarthSpell1
  jp    z,DamageAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageEarthSpell2
  jp    z,DamageAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,DamageEarthSpell3
  jp    z,DamageAmountFound
  ld    b,DamageEarthSpell4
  jp    DamageAmountFound

  .SetCost:
  ld    a,(MenuOptionSelected?Backup) 
  cp    1                               ;a = (ix+H eroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools1
  jp    z,CostAmountFound
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools2
  jp    z,CostAmountFound
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools3
  jp    z,CostAmountFound
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostAllSpellSchools4
  jp    z,CostAmountFound

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostEarthSpell1
  jp    z,CostAmountFound
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostEarthSpell2
  jp    z,CostAmountFound
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    b,CostEarthSpell3
  jp    z,CostAmountFound
  ld    b,CostEarthSpell4
  jp    CostAmountFound


  .SetSpellIcon:
  call  SetWhiteWindow

  ld    a,(MenuOptionSelected?Backup)
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell20IconSY*128) + (Spell20IconSX/2) -128
  jp    z,.SetIcon
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell19IconSY*128) + (Spell19IconSX/2) -128
  jp    z,.SetIcon
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell18IconSY*128) + (Spell18IconSX/2) -128
  jp    z,.SetIcon
  cp    4
  ld    hl,$4000 + (Spell17IconSY*128) + (Spell17IconSX/2) -128
  jp    z,.SetIcon
  
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell04IconSY*128) + (Spell04IconSX/2) -128
  jp    z,.SetIcon
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell03IconSY*128) + (Spell03IconSX/2) -128
  jp    z,.SetIcon
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,$4000 + (Spell02IconSY*128) + (Spell02IconSX/2) -128
  jp    z,.SetIcon
  ld    hl,$4000 + (Spell01IconSY*128) + (Spell01IconSX/2) -128
  .SetIcon:
  
  ld    de,$0000 + ((HeroOverViewSpellBookWindowDY + 160) *128) + ((HeroOverViewSpellBookWindowDx+10)/2)
  ld    bc,$0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  ld    a,SpellBookGraphicsBlock        ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  .GoSetText:
  ld    a,(MenuOptionSelected?Backup)

  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools1
  jp    z,.SetText
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools2
  jp    z,.SetText
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools3
  jp    z,.SetText
  cp    4
  ld    hl,SpellDescriptions.DescriptionAllSpellSchools4
  jp    z,.SetText

  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionEarth1
  jp    z,.SetText
  cp    6                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionEarth2
  jp    z,.SetText
  cp    7                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  ld    hl,SpellDescriptions.DescriptionEarth3
  jp    z,.SetText
  ld    hl,SpellDescriptions.DescriptionEarth4
  .SetText:

  ld    b,HeroOverViewSpellBookWindowDX + 030
  ld    c,HeroOverViewSpellBookWindowDY + 159
  jp    SetText

DamageAllSpellSchools4: equ 10
DamageAllSpellSchools3: equ 0
DamageAllSpellSchools2: equ 0
DamageAllSpellSchools1: equ 0

DamageEarthSpell4: equ 0
DamageEarthSpell3: equ 0
DamageEarthSpell2: equ 0
DamageEarthSpell1: equ 50

DamageFireSpell4: equ 0
DamageFireSpell3: equ 0
DamageFireSpell2: equ 15
DamageFireSpell1: equ 20

DamageAirSpell4: equ 0
DamageAirSpell3: equ 0
DamageAirSpell2: equ 0
DamageAirSpell1: equ 0

DamageWaterSpell4: equ 0
DamageWaterSpell3: equ 30
DamageWaterSpell2: equ 0
DamageWaterSpell1: equ 30

EarthSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSpellBookWindowCode_Earth

FireSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSpellBookWindowCode_Fire

AirSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSpellBookWindowCode_Air
  
WaterSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSpellBookWindowCode_Water



ResetStatusSpellBookButtons:  
;  ld    a, %1000 0011                   ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
;  ld    (HeroOverviewSkillsButtonTable + 0*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
;  ld    (HeroOverviewSkillsButtonTable + 1*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
;  ld    (HeroOverviewSkillsButtonTable + 2*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
;  ld    (HeroOverviewSkillsButtonTable + 3*ButtonTableLenght + HeroOverviewWindowButtonStatus),a


  ret

ActivateButton_Earth:
  ld    ix,HeroOverviewSpellBookButtonTable_Earth_Activated
  ld    iy,ButtonTableSpellBookSYSX_Earth_Activated
  jr    SetElementalButton

ActivateButton_Fire:
  ld    ix,HeroOverviewSpellBookButtonTable_Fire_Activated
  ld    iy,ButtonTableSpellBookSYSX_Fire_Activated
  jr    SetElementalButton

ActivateButton_Air:
  ld    ix,HeroOverviewSpellBookButtonTable_Air_Activated
  ld    iy,ButtonTableSpellBookSYSX_Air_Activated
  jr    SetElementalButton

ActivateButton_Water:
  ld    ix,HeroOverviewSpellBookButtonTable_Water_Activated
  ld    iy,ButtonTableSpellBookSYSX_Water_Activated
  jr    SetElementalButton

SetElementalButton:
  ld    l,(iy+ButtonOMouseClicked)
  ld    h,(iy+ButtonOMouseClicked+1)
  
  ld    e,(ix+HeroOverviewWindowButton_de)
  ld    d,(ix+HeroOverviewWindowButton_de+1)

  ld    c,(ix+Buttonnynx)
  ld    b,(ix+Buttonnynx+1)

  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret


HeroOverviewStatusWindowCode:
  call  SetHeroOverViewStatusWindow     ;set skills Window in inactive page
  call  SetStatusTextAttack
  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewStatusWindow     ;set skills Window in inactive page
  call  SetStatusTextAttack

  .engine:
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

  call  CheckEndHeroOverviewStatus      ;check if mouse is clicked outside of window. If so, return to game
  halt
  jp  .engine

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

  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

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

TextLevel:
                db "Level",255
SetTextNameHeroAndLevel:
  ld    ix,(plxcurrentheroAddress)
  ld    b,HeroOverViewFirstWindowchoicesDx + 030 - 001
  ld    c,HeroOverViewFirstWindowchoicesDY + 008
  ld    l,(ix+HeroSpecificInfo+0)       ;hero name
  ld    h,(ix+HeroSpecificInfo+1)
  call  SetText

  ld    b,HeroOverViewFirstWindowchoicesDx + 030 - 001
  ld    c,HeroOverViewFirstWindowchoicesDY + 032
  ld    hl,TextLevel
  call  SetText                         ;text "level"

  ld    b,HeroOverViewFirstWindowchoicesDx + 050 - 001
  ld    c,HeroOverViewFirstWindowchoicesDY + 032
  ld    a,(ix+HeroLevel)                ;hero level
  ld    l,a
  ld    h,0
  call  SetNumber16BitCastle            ;in hl=number, b=dx, c=dy  

  ld    l,(ix+HeroSpecificInfo+0)
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoClass
  add   hl,de                           ;hero class
  ld    b,HeroOverViewFirstWindowchoicesDx + 030 - 001
  ld    c,HeroOverViewFirstWindowchoicesDY + 016
  jp    SetText  

DYDX16x30HeroIconAtHeroOverview:       equ (HeroOverViewFirstWindowchoicesDY+10)*128 + ((HeroOverViewFirstWindowchoicesDX+10)/2) - 128      ;(dy*128 + dx/2) = (208,089)
Set16x30HeroIconAtHeroOverviewCode:
  ;SetHeroPortrait16x30:
  ld    a,Hero16x30PortraitsBlock       ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    ix,(plxcurrentheroAddress)

;  ld    c,(ix+HeroPortrait16x30SYSX+0)   ;example: equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;  ld    b,(ix+HeroPortrait16x30SYSX+1)
  call  SetAddressHeroPortrait16x30SYSXinBC

  ld    hl,DYDX16x30HeroIconAtHeroOverview  ;(dy*128 + dx/2) = (208,089)
  ld    de,NXAndNY16x30HeroIcon     ;(ny*256 + nx/2) = (10x18)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
	ret

HeroOverviewCode:
call screenon

  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a

  ld    a, %1000 0011                   ;status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer)
  ld    (HeroOverviewFirstWindowButtonTable + 0*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 1*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 2*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 3*ButtonTableLenght + HeroOverviewWindowButtonStatus),a
  ld    (HeroOverviewFirstWindowButtonTable + 4*ButtonTableLenght + HeroOverviewWindowButtonStatus),a



;EEEEEEEEEEHHHHHHHHHHH HOW IS THIS POSSIBLE ?
;  call  SetCastleOverViewFontPage0Y212    ;set font at (0,212) page 0

  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page
  call  Set16x30HeroIconAtHeroOverviewCode
  call  SetTextNameHeroAndLevel         ;sets hero name in hero window

  ld    ix,HeroOverviewFirstWindowButtonTable
  ld    iy,ButtonTableSYSX
  ld    bc,$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
  call  SetButtonStatusAndText          ;copies button state from rom -> vram

  call  SwapAndSetPage                  ;swap and set page
  call  SetHeroOverViewFirstWindow      ;set First Window in inactive page
  call  Set16x30HeroIconAtHeroOverviewCode
  call  SetTextNameHeroAndLevel         ;sets hero name in hero window

; 
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,%0001 0000
	ld		(Controls),a                  ;reset trigger a

  .engine:  
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (to exit overview)
  ret   nz

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

;  halt
  jp  .engine

  .MenuOptionSelected:
  cp    1                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.StatusSelected
  cp    2                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.SpellBookSelected
  cp    3                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.ArmySelected
  cp    4                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.InventorySelected
  cp    5                               ;a = (ix+HeroOverviewWindowAmountOfButtons)
  jr    z,.SkillsSelected

  xor   a
  ld    (MenuOptionSelected?),a
  ret

  .InventorySelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewInventoryWindowCode

  .StatusSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewStatusWindowCode

  .ArmySelected:
  xor   a
  ld    (MenuOptionSelected?),a
  jp    HeroOverviewArmyWindowCode

  .SpellBookSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSpellBookWindowCode_Earth
  
  .SkillsSelected:
  xor   a
  ld    (MenuOptionSelected?),a  
  jp    HeroOverviewSkillsWindowCode


SetStatusTextAttack:
  ld    ix,(plxcurrentheroAddress)

  ld    de,ItemAttackPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL  
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  ld    e,(ix+HeroStatAttack)           ;attack
  ld    d,0
  add   hl,de
  ld    b,HeroOverViewStatusWindowDX + 056 + 004-3
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber16BitCastle

  ld    de,ItemDefencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL  
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  ld    e,(ix+HeroStatDefense)
  ld    d,0
  add   hl,de

  bit   7,h                             ;defense is the only stat that can drop below 0 (with hell slayer), if so, set def=0
  jr    z,.SetDefense
  ld    hl,0
  .SetDefense:

  ld    b,HeroOverViewStatusWindowDX + 067 + 004 -2
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber16BitCastle

  ld    de,ItemIntelligencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL  
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  ld    e,(ix+HeroStatKnowledge)
  ld    d,0
  add   hl,de                           ;total knowledge
  ld    b,HeroOverViewStatusWindowDX + 075 + 004 +2
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber16BitCastle

  ld    de,ItemSpellDamagePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL  
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  ld    e,(ix+HeroStatSpelldamage)
  ld    d,0
  add   hl,de
  ld    b,HeroOverViewStatusWindowDX + 084 + 004 +5
  ld    c,HeroOverViewStatusWindowDY + 034
  call  SetNumber16BitCastle

  ld    a,(ix+HeroLevel)
  ld    b,HeroOverViewStatusWindowDX + 091
  ld    c,HeroOverViewStatusWindowDY + 045
  ld    h,0
  ld    l,a
  call  SetNumber16BitCastle

  ld    a,(ix+HeroLevel)                ;current level
  cp    18
  ld    hl,57533                        ;max xp at level 18
  jr    z,.XpSet
  
  ld    l,(ix+HeroXp)
  ld    h,(ix+HeroXp+1)
  .XpSet:
  ld    b,HeroOverViewStatusWindowDX + 063
  ld    c,HeroOverViewStatusWindowDY + 059
  call  SetNumber16BitCastle

  ld    a,(ix+HeroLevel)                ;current level
  cp    18
  ld    hl,57533                        ;max xp at level 18
  jr    z,.XpMaxSet
  
  ld    a,(ix+HeroLevel)                ;current level
  add   a,a
  ld    d,0
  ld    e,a
  ld    hl,HeroXPTable-2
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;amount of xp needed for next level 
  ex    de,hl
  .XpMaxSet:
  ld    b,HeroOverViewStatusWindowDX + 090
  ld    c,HeroOverViewStatusWindowDY + 059
  call  SetNumber16BitCastle

  ld    a,(ix+HeroMove)
  ld    b,HeroOverViewStatusWindowDX + 104
  ld    c,HeroOverViewStatusWindowDY + 073
  ld    h,0
  ld    l,a
  call  SetNumber16BitCastle

  ld    a,(ix+HeroTotalMove)
  ld    b,HeroOverViewStatusWindowDX + 124
  ld    c,HeroOverViewStatusWindowDY + 073
  ld    h,0
  ld    l,a
  call  SetNumber16BitCastle

  ld    b,HeroOverViewStatusWindowDX + 093
  ld    c,HeroOverViewStatusWindowDY + 087
  ld    l,(ix+HeroMana+0)
  ld    h,(ix+HeroMana+1)
  call  SetNumber16BitCastle

  call  SetTotalManaHero

  ld    b,HeroOverViewStatusWindowDX + 116
  ld    c,HeroOverViewStatusWindowDY + 087
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  call  SetNumber16BitCastle

  ld    a,(ix+HeroManarec)
  ld    b,HeroOverViewStatusWindowDX + 098
  ld    c,HeroOverViewStatusWindowDY + 101
  ld    h,0
  ld    l,a
  call  SetNumber16BitCastle
  ret





CheckEndHeroOverviewArmy:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewArmyWindowDY
  jr    c,.NotOverHeroOverViewArmyWindow
  cp    HeroOverViewArmyWindowDY+HeroOverViewArmyWindowNY
  jr    nc,.NotOverHeroOverViewArmyWindow
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    HeroOverViewArmyWindowDX
  jr    c,.NotOverHeroOverViewArmyWindow
  cp    HeroOverViewArmyWindowDX+HeroOverViewArmyWindowNX
  ret   c

  .NotOverHeroOverViewArmyWindow:
  pop   af
  ret   

CheckEndHeroOverviewInventory:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewInventoryWindowDY
  jr    c,.NotOverHeroOverViewInventoryWindow
  cp    HeroOverViewInventoryWindowDY+HeroOverViewInventoryWindowNY
  jr    nc,.NotOverHeroOverViewInventoryWindow
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    HeroOverViewInventoryWindowDX
  jr    c,.NotOverHeroOverViewInventoryWindow
  cp    HeroOverViewInventoryWindowDX+HeroOverViewInventoryWindowNX
  ret   c

  .NotOverHeroOverViewInventoryWindow:
  pop   af
  ret   

CheckEndHeroOverviewSpellBook:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    HeroOverViewSpellBookWindowDY
  jr    c,.NotOverHeroOverViewSpellBookWindow
  cp    HeroOverViewSpellBookWindowDY+HeroOverViewSpellBookWindowNY
  jr    nc,.NotOverHeroOverViewSpellBookWindow
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    HeroOverViewSpellBookWindowDX
  jr    c,.NotOverHeroOverViewSpellBookWindow
  cp    HeroOverViewSpellBookWindowDX+HeroOverViewSpellBookWindowNX
  ret   c

  .NotOverHeroOverViewSpellBookWindow:
  pop   af
  ret   

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

  add   a,06

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

  add   a,06

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

  add   a,06

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
  push  hl
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  add   hl,hl                           ;*64
  add   hl,hl                           ;*128
  pop   bc
  add   hl,bc                           ;*136

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
  ld    a,(ix+HeroOverviewWindowButtonStatus)
  or    a
  ret   z
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+HeroOverviewWindowButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+HeroOverviewWindowButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06

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

SetButtonStatusAndText4:
;  ld    ix,HeroOverviewSpellBookButtonTable
;  ld    iy,ButtonTableSpellBookSYSX
;  ld    bc,$0000 + (HeroOverViewSpellBookWindowButtonNY*256) + (HeroOverViewSpellBookWindowButtonNX/2)

  ld    (BCStored),bc

  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,ButtonTableLenght
  add   ix,de


  ld    de,6                            ;lenght of button data
  add   iy,de


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

  ld    c,(ix+Buttonnynx)
  ld    b,(ix+Buttonnynx+1)

  ld    a,ArmyGraphicsBlock             ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret

SetButtonStatusAndText3:
;  ld    ix,HeroOverviewSpellBookButtonTable
;  ld    iy,ButtonTableSpellBookSYSX
;  ld    bc,$0000 + (HeroOverViewSpellBookWindowButtonNY*256) + (HeroOverViewSpellBookWindowButtonNX/2)

  ld    (BCStored),bc

  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,ButtonTableLenght
  add   ix,de


  ld    de,6                            ;lenght of button data
  add   iy,de


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

  ld    c,(ix+Buttonnynx)
  ld    b,(ix+Buttonnynx+1)

  ld    a,InventoryGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ret

SetButtonStatusAndText2:                       ;copies button state from rom -> vram. in IX->ix,HeroOverview*****ButtonTable, bc->$0000 + (HeroOverViewFirstWindowButtonNY*256) + (HeroOverViewFirstWindowButtonNX/2)
;  ld    ix,HeroOverviewSpellBookButtonTable
;  ld    iy,ButtonTableSpellBookSYSX
;  ld    bc,$0000 + (HeroOverViewSpellBookWindowButtonNY*256) + (HeroOverViewSpellBookWindowButtonNX/2)

  ld    (BCStored),bc

  ld    b,(ix+HeroOverviewWindowAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,ButtonTableLenght
  add   ix,de


  ld    de,6                            ;lenght of button data
  add   iy,de


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

  ld    c,(ix+Buttonnynx)
  ld    b,(ix+Buttonnynx+1)

  ld    a,SpellBookGraphicsBlock        ;Map block
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
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
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
;  jp    SetTextInButton
 
SetTextInButton:
  ld    l,(ix+TextAddress)
  ld    h,(ix+TextAddress+1)            ;address of text to put
;  ld    (TextAddresspointer),hl

  ld    a,(ix+HeroOverviewWindowButtonYtop)
  add   a,4
;  ld    (PutLetter+dy),a                ;set dy of text
  ld    c,a
  ld    a,(ix+HeroOverviewWindowButtonXleft)
  add   a,3
;  ld    (PutLetter+dx),a                ;set dx of text
  ld    b,a
  jp    SetText

SetSkillExplanation:
  ld    a,(SetSkillsDescription?)
  dec   a
  ret   z
  ld    (SetSkillsDescription?),a 
  
  ld    ix,(ActivatedSkillsButton)
  ld    b,037
  ld    c,138
  ld    l,(ix+TextAddress)
  ld    h,(ix+TextAddress+1)            ;address of text to put
  ld    de,LenghtTextSkillsDescription
  add   hl,de
  jp    SetText

TextPlusSymbol:               equ $2b
TextMinusSymbol:              equ $2d
TextPercentageSymbol:         equ $25
TextSpace:                    equ $20
TextNumber0:                  equ $30
TextApostrofeSymbol:          equ $27
TextColonSymbol:              equ $3a
TextSlashSymbol:              equ $2f
TextQuestionMarkSymbol:       equ $3f
TextCommaSymbol:              equ $2c
TextDotSymbol:                equ $2e
TextOpeningParenthesisSymbol: equ $28
TextClosingParenthesisSymbol: equ $29

TextFirstWindowChoicesButton1:  db  "Skills",255
TextFirstWindowChoicesButton2:  db  "Inventory",255
TextFirstWindowChoicesButton3:  db  "Army",255
TextFirstWindowChoicesButton4:  db  "Spell Book",255
TextFirstWindowChoicesButton5:  db  "Status",255

LenghtSkillDescription: equ SkillArcheryAdvanced-SkillArcheryBasic
SkillEmpty:
                          db  "                                 ",255   ;skillnr# 000
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
SkillArcheryBasic:
                          db  "Basic Archery                    ",255   ;skillnr# 001
                          db  "Basic Archery                    ",254
                          db  "The ranged Attack damage of your ",254
                          db  "units is increased by 10%        ",255
SkillArcheryAdvanced:
                          db  "Advanced Archery                 ",255
                          db  "Advanced Archery                 ",254
                          db  "The ranged Attack damage of your ",254
                          db  "units is increased by 20%        ",255
SkillArcheryExpert:
                          db  "Expert Archery                   ",255
                          db  "Expert Archery                   ",254
                          db  "The ranged Attack damage of your ",254
                          db  "units is increased by 50%        ",255
SkillOffenceBasic:
                          db  "Basic Offence                    ",255   ;skillnr# 004
                          db  "Basic Offence                    ",254
                          db  "The hand to hand damage of your  ",254
                          db  "units is increased by 10%        ",255
SkillOffenceAdvanced:
                          db  "Advanced Offence                 ",255
                          db  "Advanced Offence                 ",254
                          db  "The hand to hand damage of your  ",254
                          db  "units is increased by 20%        ",255
SkillOffenceExpert:
                          db  "Expert Offence                   ",255
                          db  "Expert Offence                   ",254
                          db  "The hand to hand damage of your  ",254
                          db  "units is increased by 30%        ",255
;Armorer is a secondary skill, that reduces the physical damage done to hero's creatures. Physical damage means damage done by enemy creatures engaged in melee or ranged combat. Armorer secondary skill does not reduce damage from spells cast by enemy heroes or creatures.
SkillArmourerBasic:
                          db  "Basic Armorer                    ",255   ;skillnr# 007
                          db  "Basic Armorer                    ",254
                          db  "Damage inflicted on your army is ",254
                          db  "reduced by 5%                    ",255
SkillArmourerAdvanced:
                          db  "Advanced Armorer                 ",255
                          db  "Advanced Armorer                 ",254
                          db  "Damage inflicted on your army is ",254
                          db  "reduced by 10%                   ",255
SkillArmourerExpert:
                          db  "Expert Armorer                   ",255
                          db  "Expert Armorer                   ",254
                          db  "Damage inflicted on your army is ",254
                          db  "reduced by 15%                   ",255
SkillResistanceBasic:
                          db  "Basic Resistance                 ",255   ;skillnr# 010
                          db  "Basic Resistance                 ",254
                          db  "Your units have a 5% chance to   ",254
                          db  "deflect incoming spells.         ",255
SkillResistanceAdvanced:
                          db  "Advanced Resistance              ",255
                          db  "Advanced Resistance              ",254
                          db  "Your units have a 10% chance to  ",254
                          db  "deflect incoming spells.         ",255
SkillResistanceExpert:
                          db  "Expert Resistance                ",255
                          db  "Expert Resistance                ",254
                          db  "Your units have a 15% chance to  ",254
                          db  "deflect incoming spells.         ",255











SkillEstatesBasic:
                          db  "Basic Estates                    ",255   ;skillnr# 013
                          db  "Basic Estates                    ",254
                          db  "Your hero generates an extra 125 ",254
                          db  "Gold per day.                    ",255
SkillEstatesAdvanced:
                          db  "Advanced Estates                 ",255
                          db  "Advanced Estates                 ",254
                          db  "Your hero generates an extra 250 ",254
                          db  "Gold per day.                    ",255
SkillEstatesExpert:
                          db  "Expert Estates                   ",255
                          db  "Expert Estates                   ",254
                          db  "Your hero generates an extra 500 ",254
                          db  "Gold per day.                    ",255
SkillLearningBasic:
                          db  "Basic Learning                   ",255   ;skillnr# 016
                          db  "Basic Learning                   ",254
                          db  "Your hero's accumulated          ",254
                          db  "experience is amplified by 10%   ",255
SkillLearningAdvanced:
                          db  "Advanced Learning                ",255
                          db  "Advanced Learning                ",254
                          db  "Your hero's accumulated          ",254
                          db  "experience is amplified by 20%   ",255
SkillLearningExpert:
                          db  "Expert Learning                  ",255
                          db  "Expert Learning                  ",254
                          db  "Your hero's accumulated          ",254
                          db  "experience is amplified by 30%   ",255
SkillLogisticsBasic:
                          db  "Basic Logistics                  ",255   ;skillnr# 019
                          db  "Basic Logistics                  ",254
                          db  "An additional 10% is added to    ",254
                          db  "your hero's land movement range. ",255
SkillLogisticsAdvanced:
                          db  "Advanced Logistics               ",255
                          db  "Advanced Logistics               ",254
                          db  "An additional 20% is added to    ",254
                          db  "your hero's land movement range. ",255
SkillLogisticsExpert:
                          db  "Expert Logistics                 ",255
                          db  "Expert Logistics                 ",254
                          db  "An additional 30% is added to    ",254
                          db  "your hero's land movement range. ",255




SkillIntelligenceBasic:
                          db  "Basic Intelligence               ",255   ;skillnr# 022
                          db  "Basic Intelligence               ",254
                          db  "Boosts your hero's maximum spell ",254
                          db  "points by 25%                    ",255
SkillIntelligenceAdvanced:
                          db  "Advanced Intelligence            ",255
                          db  "Advanced Intelligence            ",254
                          db  "Boosts your hero's maximum spell ",254
                          db  "points by 50%                    ",255
SkillIntelligenceExpert:
                          db  "Expert Intelligence              ",255
                          db  "Expert Intelligence              ",254
                          db  "Boosts your hero's maximum spell ",254
                          db  "points by 100%                   ",255
SkillSorceryBasic:
                          db  "Basic Sorcery                    ",255   ;skillnr# 025
                          db  "Basic Sorcery                    ",254
                          db  "An additional 5% is added to     ",254
                          db  "your hero's spell damage.        ",255
SkillSorceryAdvanced:
                          db  "Advanced Sorcery                 ",255
                          db  "Advanced Sorcery                 ",254
                          db  "An additional 10% is added to    ",254
                          db  "your hero's spell damage.        ",255
SkillSorceryExpert:
                          db  "Expert Sorcery                   ",255
                          db  "Expert Sorcery                   ",254
                          db  "An additional 15% is added to    ",254
                          db  "your hero's spell damage.        ",255
SkillWisdomBasic:
                          db  "Basic Wisdom                     ",255   ;skillnr# 028
                          db  "Basic Wisdom                     ",254
                          db  "Your hero is capable of learning ",254
                          db  "spells of level 2 and lower.     ",255
SkillWisdomAdvanced:
                          db  "Advanced Wisdom                  ",255
                          db  "Advanced Wisdom                  ",254
                          db  "Your hero is capable of learning ",254
                          db  "spells of level 3 and lower.     ",255
SkillWisdomExpert:
                          db  "Expert Wisdom                    ",255
                          db  "Expert Wisdom                    ",254
                          db  "Your hero is capable of learning ",254
                          db  "all spells.                      ",255

SkillNecromancyBasic:
                          db  "Basic Necromancy                 ",255   ;skillnr# 031
                          db  "Basic Necromancy                 ",254
                          db  "Revives 10% of enemy creatures   ",254
                          db  "that have fallen in battle.      ",255
SkillNecromancyAdvanced:
                          db  "Advanced Necromancy              ",255
                          db  "Advanced Necromancy              ",254
                          db  "Revives 20% of enemy creatures   ",254
                          db  "that have fallen in battle.      ",255
SkillNecromancyExpert:
                          db  "Expert Necromancy                ",255
                          db  "Expert Necromancy                ",254
                          db  "Revives 1/3 of enemy creatures   ",254
                          db  "that have fallen in battle.      ",255


;SetHeroOverViewFontPage0Y212:           ;set font at (0,212) page 0
;  ld    hl,$4000 + (000*128) + (000/2) - 128
;  ld    de,$0000 + (212*128) + (000/2) - 128
;  ld    de,$0000 + (000*128) + (000/2) - 128
;  ld    bc,$0000 + (005*256) + (256/2)
;  ld    a,HeroOverviewFontBlock         ;font graphics block
;  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  
SetHeroOverViewFirstWindow:
  ld    hl,$4000 + (HeroOverViewFirstWindowchoicesSY*128) + (HeroOverViewFirstWindowchoicesSX/2) -128
  ld    de,$0000 + (HeroOverViewFirstWindowchoicesDY*128) + (HeroOverViewFirstWindowchoicesDX/2)
  ld    bc,$0000 + (HeroOverViewFirstWindowchoicesNY*256) + (HeroOverViewFirstWindowchoicesNX/2)
  ld    a,HeroOverviewGraphicsBlock     ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewSkillsWindow:
  ld    hl,$4000 + (HeroOverViewSkillsWindowSY*128) + (HeroOverViewSkillsWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewSkillsWindowDY*128) + (HeroOverViewSkillsWindowDX/2)
  ld    bc,$0000 + (HeroOverViewSkillsWindowNY*256) + (HeroOverViewSkillsWindowNX/2)
  ld    a,HeroOverviewGraphicsBlock     ;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewStatusWindow:
  ld    hl,$4000 + (HeroOverViewStatusWindowSY*128) + (HeroOverViewStatusWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewStatusWindowDY*128) + (HeroOverViewStatusWindowDX/2)
  ld    bc,$0000 + (HeroOverViewStatusWindowNY*256) + (HeroOverViewStatusWindowNX/2)
  ld    a,HeroOverviewStatusGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewSpellBookWindow:
  ld    hl,$4000 + (HeroOverViewSpellBookWindowSY*128) + (HeroOverViewSpellBookWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewSpellBookWindowDY*128) + (HeroOverViewSpellBookWindowDX/2)
  ld    bc,$0000 + (HeroOverViewSpellBookWindowNY*256) + (HeroOverViewSpellBookWindowNX/2)
  ld    a,SpellBookGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewInventoryWindow:
  ld    hl,$4000 + (HeroOverViewInventoryWindowSY*128) + (HeroOverViewInventoryWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewInventoryWindowDY*128) + (HeroOverViewInventoryWindowDX/2)
  ld    bc,$0000 + (HeroOverViewInventoryWindowNY*256) + (HeroOverViewInventoryWindowNX/2)
  ld    a,InventoryGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetHeroOverViewArmyWindow:
  ld    hl,$4000 + (HeroOverViewArmyWindowSY*128) + (HeroOverViewArmyWindowSX/2) -128
  ld    de,$0000 + (HeroOverViewArmyWindowDY*128) + (HeroOverViewArmyWindowDX/2)
  ld    bc,$0000 + (HeroOverViewArmyWindowNY*256) + (HeroOverViewArmyWindowNX/2)
  ld    a,ArmyGraphicsBlock;Map block
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY



