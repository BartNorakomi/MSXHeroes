CampaignInfoLenght:	equ	Campaign02-Campaign01
CampaignTextLenght: equ 34

;Pochi is lost: start with royas, tavern filled with worzen family, except pochi, enemy town empty
Campaign01:
.StartingTowns:                       db  001,002,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  006,008,010,039,041,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  4*30
.CampaignText:						  db "Find Pochi in the nothern castle ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesDrasle1
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db SDSnatcherUnitLevel1Number | dw SDSnatcherUnitLevel1Growth |      db SDSnatcherUnitLevel2Number | dw SDSnatcherUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesSnatcher
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesTrevorBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSnake2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Crossroads of Courage: start without hero, tavern filled with worzen family, enemy towns have both 1 hero (snatcher and a belmont) and several units
Campaign02:
.StartingTowns:                       db  001,003,002,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  039,041,004,026,006,008,010,000,000,000
.Players:                             db  3,1,0,0,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  4*30
.CampaignText:						  db "Reclaim the captured fortresses  ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesSnake2
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db SDSnatcherUnitLevel1Number | dw SDSnatcherUnitLevel1Growth |      db SDSnatcherUnitLevel2Number | dw SDSnatcherUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesSnatcher
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesTrevorBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSnake2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Whispers in the Sand: start without heroes. tavern filled with cles and wit. enemy town has trevor belmont and several units. loss condition: lose both with and cles.
Campaign03:                               ;c1, c2
.StartingTowns:                       db  004,002,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  047,019,000,000,000,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  4*30
.CampaignText:						  db "  Break Trevor Belmont's curse   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesSnake2
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesTrevorBelmont
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesTrevorBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSnake2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;An Arctic Alliance: start without heroes. start with 2 castles, goemon and castlevania. tavern filled with heroes of those castles. enemy towns are dragon slayer 4 and junkery hq. loss condition: lose all heroes.
Campaign04:                               ;c1, c3, c4, c2
.StartingTowns:                       db  005,001,003,002   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  002,028,015,030,032,000,000,000,000,000
.Players:                             db  3,1,0,0,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  1
.DaysToCompleteCampaign:              db  4*30
.CampaignText:						  db "  Overthrow the dark alliance    ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesSnake2
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db DragonSlayerUnitLevel3Number | dw DragonSlayerUnitLevel3Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesPochi
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db SdSnatcherUnitLevel1Number | dw SdSnatcherUnitLevel1Growth*2 |      db SdSnatcherUnitLevel2Number | dw SdSnatcherUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesGillianSeed
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSnake2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Felghana's Champion: start with Adol at level 5. start with 1 castle. tavern is empty. enemy towns are junkery hq, castlevania & goemon. win condition: conquer all 3 castles. loss condition: lose adol.
Campaign05:                               ;c1, c3, c4, c2
.StartingTowns:                       db  006,003,002,005   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  4*30
.CampaignText:						  db "   Restore peace to Felghana     ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 4600
.P1hero1move:	db	20,20
.P1hero1mana:	dw	20,20
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db Ys3UnitLevel1Number | dw Ys3UnitLevel1Growth |      db Ys3UnitLevel2Number | dw Ys3UnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 3
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 2  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 2  ;amount of spell damage
.P1HeroSkills:  db  1,5,8,0,0,0
.P1HeroLevel: db  5
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesAdol
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db SDSnatcherUnitLevel1Number | dw 005 |      db SDSnatcherUnitLevel1Number | dw 006 |      db SDSnatcherUnitLevel1Number | dw 004 |      db SDSnatcherUnitLevel1Number | dw 002 |      db SDSnatcherUnitLevel1Number | dw 005 |      db SDSnatcherUnitLevel1Number | dw 008 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesRandomHajile
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db GoemonUnitLevel1Number | dw GoemonUnitLevel1Growth |      db GoemonUnitLevel2Number | dw GoemonUnitLevel2Growth |      db GoemonUnitLevel1Number | dw 004 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesGoemon2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2







;Mildew and Moonlight: start with Lucia at level 5. start with 1 castle. tavern is empty. enemy town is Adol town. win condition: conquer adols castle. loss condition: lose lucia.
Campaign06:                               ;c1, c3, c4, c2
.StartingTowns:                       db  007,006,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  100
.CampaignText:						  db "Find the castle guarded by Adol  ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 4600
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+1 |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+2 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 4
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 2  ;amount of spell damage
.P1HeroSkills:  db  1,5,8,0,0,0
.P1HeroLevel: db  5
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0001
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesPsychoWorld
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db Ys3UnitLevel1Number | dw Ys3UnitLevel1Growth |      db Ys3UnitLevel2Number | dw Ys3UnitLevel2Growth |      db Ys3UnitLevel3Number | dw Ys3UnitLevel3Growth |      db Ys3UnitLevel4Number | dw 1 |      db Ys3UnitLevel4Number | dw 001 |      db Ys3UnitLevel4Number | dw 002 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesAdol
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db GoemonUnitLevel1Number | dw GoemonUnitLevel1Growth |      db GoemonUnitLevel2Number | dw GoemonUnitLevel2Growth |      db GoemonUnitLevel1Number | dw 004 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesGoemon2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;A Jungle Expedition: Start with Mitchell at level 1. start with 1 castle. king kong. tavern is empty. 1 enemy town is with lucia, psycho world. 1 enemy town is empty and the other is Usas castle and has with and cles in tavern. win condition. conquer lucia castle. loss condition: lose adol without having usas castle. Or lose adol, wit and cles.
Campaign07:                               ;c1, c3, c4, c2
.StartingTowns:                       db  008,007,004,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,019,047
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  80
.CampaignText:						  db "  Confront Lucia at her castle   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db KingKongUnitLevel6Number | dw 1 |      db 0 | dw 0 |      db 0 | dw 0 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesMitchell
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db PsychoWorldUnitLevel6Number | dw 1 |      db PsychoWorldUnitLevel5Number | dw 1 |      db 000 | dw 000 |      db 000 | dw 000 |      db PsychoWorldUnitLevel1Number | dw 0040 |      db PsychoWorldUnitLevel1Number | dw 003 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  01,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesPsychoWorld
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db GoemonUnitLevel1Number | dw GoemonUnitLevel1Growth |      db GoemonUnitLevel2Number | dw GoemonUnitLevel2Growth |      db GoemonUnitLevel1Number | dw 004 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesGoemon2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2









;The Valley of Doom: Start with Kelesis. start with 1 castle. kelesis the cook in tavern. 1 enemy castle with mitchel and a strong army (incl. king kong). win condition: conquest the castle. loss condition: lose both heroes or reach day 60.
Campaign08:                               ;c1, c3, c4, c2
.StartingTowns:                       db  009,008,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  043,000,000,000,000,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  60
.CampaignText:						  db "Prevent the artifact activation  ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db GolvelliusUnitLevel1Number | dw 10 |      db GolvelliusUnitLevel2Number | dw 6 |      db GolvelliusUnitLevel5Number | dw 2 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesGolvellius
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db KingKongUnitLevel6Number | dw 1 |      db 0 | dw 0 |      db KingKongUnitLevel3Number | dw 010 |      db KingKongUnitLevel3Number | dw 010 |      db 000 | dw 000 |      db KingKongUnitLevel5Number | dw 003 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesMitchell
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db GoemonUnitLevel1Number | dw GoemonUnitLevel1Growth |      db GoemonUnitLevel2Number | dw GoemonUnitLevel2Growth |      db GoemonUnitLevel1Number | dw 004 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesGoemon2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2






;A Jungle Retreat: Start with bill rizer. start with 1 castle. no heroes in tavern. Enemy castle is empty, but pochi stands at the exit of the cave. win condition: reach the town in the south, loss condition: lose bill rizer.
Campaign09:                               ;c1, c3, c4, c2
.StartingTowns:                       db  010,001,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  20000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  75
.CampaignText:						  db "Find a safe trail to Drasle's Den",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db ContraGroupAUnitLevel1Number | dw ContraGroupAUnitLevel1Growth |      db ContraGroupAUnitLevel2Number | dw ContraGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesBillRizer
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	10,10
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db DragonSlayerUnitLevel3Number | dw DragonSlayerUnitLevel3Growth |      db DragonSlayerUnitLevel4Number | dw DragonSlayerUnitLevel4Growth |      db DragonSlayerUnitLevel5Number | dw DragonSlayerUnitLevel5Growth |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 1
.P2Hero1StatDefense:  db 2
.P2Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  1
.P2EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 0000
.P2AirSpells:         db  %0000 0000
.P2WaterSpells:       db  %0000 0000
.P2AllSchoolsSpells:  db  %0000 0000
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesPochi
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  16,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db GoemonUnitLevel1Number | dw GoemonUnitLevel1Growth |      db GoemonUnitLevel2Number | dw GoemonUnitLevel2Growth |      db GoemonUnitLevel1Number | dw 004 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  10,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesGoemon2
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Rally Against Rizer: start without heroes. start with 3 castles, castlevania, goemon and usas. win condition: defeat bill rizer (level 15, with HUGE army). lose condition: lose all heroes.
Campaign10:                               ;c1, c3, c4, c2
.StartingTowns:                       db  002,011,005,004   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  002,019,030,032,047,015,028,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  02500
.Wood:                                dw  10
.Ore:                                 dw  10
.Gems:                                dw  05
.Rubies:                              dw  05
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  1
.Castle4Player:                       db  1
.DaysToCompleteCampaign:              db  55
.CampaignText:						  db "Recruit a team to stop Bill Rizer",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db ContraGroupAUnitLevel1Number | dw ContraGroupAUnitLevel1Growth |      db ContraGroupAUnitLevel2Number | dw ContraGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesBillRizer
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db ContraGroupBUnitLevel1Number | dw ContraGroupBUnitLevel1Growth |      db ContraGroupBUnitLevel2Number | dw ContraGroupBUnitLevel2Growth |      db ContraGroupBUnitLevel3Number | dw 002 |      db ContraGroupBUnitLevel4Number | dw 002 |      db ContraGroupBUnitLevel5Number | dw 002 |      db ContraGroupBUnitLevel6Number | dw 003 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesBillRizer
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db DragonSlayerUnitLevel3Number | dw DragonSlayerUnitLevel3Growth |      db DragonSlayerUnitLevel4Number | dw DragonSlayerUnitLevel4Growth |      db DragonSlayerUnitLevel5Number | dw DragonSlayerUnitLevel5Growth |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesPochi
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2




;Into the Fray: start with fray, start with 1 castle. no heroes in tavern. win condition: defeat 2 castles. lose condition: lose fray
Campaign11:                               ;c1, c3, c4, c2
.StartingTowns:                       db  004,005,009,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  3,1,0,0,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  6500
.Wood:                                dw  20
.Ore:                                 dw  15
.Gems:                                dw  10
.Rubies:                              dw  08
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  90
.CampaignText:						  db "Capture the two vital strongholds",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db UsasUnitLevel1Number | dw UsasUnitLevel1Growth |      db UsasUnitLevel2Number | dw UsasUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesFray
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db GoemonUnitLevel1Number | dw 001 |      db GoemonUnitLevel2Number | dw 001 |      db GoemonUnitLevel3Number | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesLatok
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db GolvelliusUnitLevel1Number | dw 001 |      db GolvelliusUnitLevel2Number | dw 001 |      db GolvelliusUnitLevel5Number | dw 01 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesUndeadline1
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db CastleVaniaUnitLevel1Number | dw CastleVaniaUnitLevel1Growth |      db CastleVaniaUnitLevel2Number | dw CastleVaniaUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesSimonBelmont
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;The Soldier's Path: start with solid snake, start with 1 castle. no heroes in tavern. northwest castle is contra 2 castle with Bill Rizer in tavern. win condition: conquer 2 castles in the south. loss condition: lose snake without having conquered the castle in the northwest, or lose both snake and bill rizer. (castles in the south have no heroes in tavern)
Campaign12:                               ;c1, c3, c4, c2
.StartingTowns:                       db  010,008,011,009   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,025
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  110
.CampaignText:						  db "    Defeat the southern foes     ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db ContraGroupAUnitLevel1Number | dw ContraGroupAUnitLevel1Growth |      db ContraGroupAUnitLevel2Number | dw ContraGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesSnake1
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db GolvelliusUnitLevel1Number | dw 018 |      db GolvelliusUnitLevel2Number | dw 024 |      db GolvelliusUnitLevel5Number | dw 09 |      db 000 | dw 000 |      db GolvelliusUnitLevel4Number | dw 020 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesBigBoss
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db GolvelliusUnitLevel1Number | dw 001 |      db GolvelliusUnitLevel2Number | dw 001 |      db GolvelliusUnitLevel5Number | dw 01 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesUndeadline1
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db KingKongUnitLevel6Number | dw 006 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db KingKongUnitLevel5Number | dw 007 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesUltraBox
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

;Where East Meets West: start with contra castle no heroes, snake and solid snake in tavern. Dino in enemy castle. Win condition: kill dino. lose condition: lose both heroes
Campaign13:                               ;c1, c3, c4, c2
.StartingTowns:                       db  010,003,000,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,009,007,000,000,000,000,000,000,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  255
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  110
.CampaignText:						  db "    Crush the sorcerer Dino      ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db ContraGroupAUnitLevel1Number | dw ContraGroupAUnitLevel1Growth |      db ContraGroupAUnitLevel2Number | dw ContraGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesSnake1
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db SDSnatcherUnitLevel1Number | dw 018 |      db SDSnatcherUnitLevel2Number | dw 014 |      db SDSnatcherUnitLevel5Number | dw 09 |      db 000 | dw 000 |      db SDSnatcherUnitLevel4Number | dw 010 |      db SDSnatcherUnitLevel6Number | dw 010 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesUndeadline3
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db GolvelliusUnitLevel1Number | dw 001 |      db GolvelliusUnitLevel2Number | dw 001 |      db GolvelliusUnitLevel5Number | dw 01 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesUndeadline1
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db KingKongUnitLevel6Number | dw 006 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db KingKongUnitLevel5Number | dw 007 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesUltraBox
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Three Reigns Fallen: start with ashguine in 1 castle. no heroes in tavern. 3 enemy castle, no heroes in taverns. win condition: conquer all castles. lose condition: lose ashguine
Campaign14:                               ;c1, c3, c4, c2
.StartingTowns:                       db  012,011,010,009   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  80
.CampaignText:						  db "Triumph over the three kingdoms  ",255

;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db AkanbeDragonGroupAUnitLevel1Number | dw AkanbeDragonGroupAUnitLevel1Growth |      db AkanbeDragonGroupAUnitLevel2Number | dw AkanbeDragonGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesAshguine
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db ContraGroupBUnitLevel1Number | dw ContraGroupBUnitLevel1Growth |      db ContraGroupBUnitLevel2Number | dw ContraGroupBUnitLevel2Growth |      db ContraGroupBUnitLevel3Number | dw ContraGroupBUnitLevel3Growth |      db ContraGroupBUnitLevel4Number | dw 020 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesRuth
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db ContraGroupAUnitLevel1Number | dw ContraGroupAUnitLevel1Growth |      db ContraGroupAUnitLevel6Number | dw 08 |      db 000 | dw 000 |      db 000 | dw 000 |      db ContraGroupAUnitLevel5Number | dw 005 |      db ContraGroupAUnitLevel6Number | dw 002 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesYoungNoble
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db KingKongUnitLevel4Number | dw 006 |      db GolvelliusUnitLevel5Number | dw 013 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db KingKongUnitLevel3Number | dw 007 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesPocky
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Prince Logan's Odyssey: start with logan in 1 castle. no heroes in tavern. 2 enemy castles, ashguine in enemy castle 1 with 3 members of worzen family in tavern. Kelesis the cook in castle 2 with 3 members of worzen family in tavern. win condition: defeat both castles, loss condition: lose all heroes in play and in tavern.
Campaign15:                               ;c1, c3, c4, c2
.StartingTowns:                       db  012,011,010,009   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  80
.CampaignText:						  db "Liberate three kingdoms from evil",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db AkanbeDragonGroupAUnitLevel1Number | dw AkanbeDragonGroupAUnitLevel1Growth |      db AkanbeDragonGroupAUnitLevel2Number | dw AkanbeDragonGroupAUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesLoganSerios
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 162 | dw 28 |      db 163 | dw 32 |      db 000 | dw 000 |      db 000 | dw 000 |      db 163 | dw 030 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesAshguine
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 161 | dw 11 |      db 161 | dw 10 |      db 161 | dw 040 |      db 160 | dw 010 |      db 160 | dw 015 |      db 160 | dw 022 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesKelesisTheCook
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 164 | dw 016 |      db 000 | dw 000 |      db 000 | dw 000 |      db 164 | dw 002 |      db 164 | dw 020 |      db 164 | dw 003 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesLolo
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2




;Chronicles of Herzog: start with 1 castle, 0 heroes. ruth and mercies in tavern. 3 castles, each castle has no heroes in tavern. defending heroes in those castles: Lucia, Adol, Prince Logan.
Campaign16:                               ;c1, c3, c4, c2
.StartingTowns:                       db  012,007,012,002   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  036,000,038,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  80
.CampaignText:						  db "  Partner to claim three forts   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db 166 | dw 10 |      db 000 | dw 000 |      db 166 | dw 015 |      db 000 | dw 000 |      db 166 | dw 020 |      db 166 | dw 030 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesKelesisTheCook
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	1
.P2hero1x:		db	1
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+1 |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+2 |      db 000 | dw 000 |      db 000 | dw 000 |      db PsychoWorldUnitLevel6Number | dw 010 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesPsychoWorld
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db Ys3UnitLevel1Number | dw Ys3UnitLevel1Growth |      db Ys3UnitLevel2Number | dw Ys3UnitLevel2Growth |      db Ys3UnitLevel3Number | dw 010 |      db Ys3UnitLevel4Number | dw 09 |      db Ys3UnitLevel5Number | dw 11 |      db Ys3UnitLevel6Number | dw 6 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesAdol
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 169 | dw 016 |      db 169 | dw 027 |      db 169 | dw 030 |      db 000 | dw 000 |      db 169 | dw 020 |      db 169 | dw 003 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesLoganSerios
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;Reign of the Druid: start without castle. start with hero: young noble in the middle bottom part of the map. 4 empty castles. taverns empty. In the middle of the map is druid, level 18 with a huge army who needs to be defeated. win condition: defeat druid, loss condition: lose young noble
Campaign17:                               ;c1, c3, c4, c2
.StartingTowns:                       db  013,012,011,010   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  75
.CampaignText:						  db " Crush the three wicked druids   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db AkanbeDragonGroupBUnitLevel1Number | dw 10 |      db AkanbeDragonGroupBUnitLevel2Number | dw 006 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesYoungNoble
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 166 | dw 10 |      db 000 | dw 000 |      db 166 | dw 015 |      db 000 | dw 000 |      db 166 | dw 020 |      db 166 | dw 020 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesDruid
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 167 | dw 21 |      db 168 | dw 40 |      db 161 | dw 030 |      db 168 | dw 010 |      db 160 | dw 015 |      db 180 | dw 022 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesDruid
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 170 | dw 006 |      db 170 | dw 017 |      db 170 | dw 001 |      db 170 | dw 001 |      db 170 | dw 010 |      db 170 | dw 003 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesDruid
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2




;Pocky's Castle Crusade: start with 1 castle. start with pocky. tavern empty. Young Noble in enemy castle. win condition: defeat young noble. lose condition: lose pocky 
Campaign18:                               ;c1, c3, c4, c2
.StartingTowns:                       db  008,001,002,000   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  3,1,0,0,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  00500
.Wood:                                dw  05
.Ore:                                 dw  05
.Gems:                                dw  02
.Rubies:                              dw  02
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  255
.DaysToCompleteCampaign:              db  80
.CampaignText:						  db "  Capture the two strongholds    ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 4600
.P1hero1move:	db	20,20
.P1hero1mana:	dw	20,20
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db KingKongUnitLevel5Number | dw 03 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 3
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 2  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 2  ;amount of spell damage
.P1HeroSkills:  db  1,5,8,0,0,0
.P1HeroLevel: db  5
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesPocky
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 171 | dw 10 |      db 171 | dw 010 |      db 172 | dw 025 |      db 171 | dw 200 |      db 171 | dw 020 |      db 171 | dw 020 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesYoungNoble
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 173 | dw 060 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesPippols
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 170 | dw 006 |      db 170 | dw 017 |      db 170 | dw 001 |      db 170 | dw 001 |      db 170 | dw 010 |      db 170 | dw 003 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesDruid
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;Lololand: start with 1 castle, start with lolo, tavern empty. enemy castle 1: pocky, enemy castle 2: fray. both taverns filled with random heroes. win condition: defeat both castles. lose condition: lose all heroes in play and in taverns
Campaign19:                               ;c1, c3, c4, c2
.StartingTowns:                       db  007,006,005,004   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  011,022,034,045,016,070,069,071,072,073
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  10000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  100
.CampaignText:						  db " Consolidate the four kingdoms   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+1 |      db PsychoWorldUnitLevel1Number | dw PsychoWorldUnitLevel1Growth+2 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesLolo
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 174 | dw 10 |      db 174 | dw 010 |      db 174 | dw 005 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesHeiwaAndButako
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 175 | dw 060 |      db 000 | dw 000 |      db 000 | dw 000 |      db 173 | dw 020 |      db 000 | dw 000 |      db 175 | dw 060 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesLuka
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 176 | dw 016 |      db 176 | dw 027 |      db 176 | dw 021 |      db 176 | dw 031 |      db 176 | dw 040 |      db 176 | dw 053 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesArmoredSnatcher
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



;Comical Cavern Clash: start with 1 castle. start with pippols. tavern empty. enemy castle has lolo. win condition: defeat lolo, lose condition: lose pippols
Campaign20:                               ;c1, c3, c4, c2
.StartingTowns:                       db  001,002,012,013   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  000,000,000,000,000,000,000,000,000,000
.Players:                             db  4,1,0,0,0             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  15000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  3
.Castle4Player:                       db  4
.DaysToCompleteCampaign:              db  100
.CampaignText:						  db "  Go head-to-head with Lolo      ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db DragonSlayerUnitLevel1Number | dw DragonSlayerUnitLevel1Growth |      db DragonSlayerUnitLevel2Number | dw DragonSlayerUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesPippols
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 177 | dw 40 |      db 178 | dw 030 |      db 000 | dw 000 |      db 179 | dw 020 |      db 000 | dw 000 |      db 178 | dw 060 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesLolo
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 175 | dw 060 |      db 000 | dw 000 |      db 000 | dw 000 |      db 173 | dw 020 |      db 000 | dw 000 |      db 175 | dw 060 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesAce
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 176 | dw 016 |      db 176 | dw 027 |      db 176 | dw 021 |      db 176 | dw 031 |      db 176 | dw 040 |      db 176 | dw 053 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesRandomHajile
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;Randar's Last Stand: start with 3 castles, no heroes. all taverns are filled with random heroes. enemy castle has randar with a huge army. win condition: defeat randar. lose condition, run out of time (4 months)
Campaign21:                               ;c1, c3, c4, c2
.StartingTowns:                       db  014,013,012,011   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  057,048,039,060,000,061,062,063,064,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  15000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  1
.Castle4Player:                       db  1
.DaysToCompleteCampaign:              db  75
.CampaignText:						  db " Storm Randar's unaware castle   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db YieArKungFuUnitLevel1Number | dw YieArKungFuUnitLevel1Growth |      db YieArKungFuUnitLevel2Number | dw YieArKungFuUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesPippols
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 011 | dw 70 |      db 018 | dw 030 |      db 000 | dw 000 |      db 027 | dw 013 |      db 000 | dw 000 |      db 027 | dw 050 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesRandar
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 175 | dw 060 |      db 000 | dw 000 |      db 000 | dw 000 |      db 173 | dw 020 |      db 000 | dw 000 |      db 175 | dw 060 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesAce
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 176 | dw 016 |      db 176 | dw 027 |      db 176 | dw 021 |      db 176 | dw 031 |      db 176 | dw 040 |      db 176 | dw 053 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesRandomHajile
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;A Desert Blood Moon: start with 1 castle. castle of YS. no heroes. tavern filled with lucia and dick. enemy castles are castlevania, usas and golvellius, but are defended by the 3 belmonts. taverns are empty. win condition: defeat all castles. lose condition: lose all heroes.
Campaign22:                               ;c1, c3, c4, c2
.StartingTowns:                       db  014,013,012,011   ;0=random, 1=DS4, 2=CastleVania, 3=sdsnatcher, 4=usas, 5=goemon, 6=ys3, 7=psycho world, 8=king kong, 9=golvellius, 10=contra1, 11=contra2, 12=akanbe 1, 13=akanbe 2, 14=yiearekungfu, 15=bubble 1, 16=bubbl 2, 17=cloud palace
.TavernHeroes:                        db  057,048,039,060,000,061,062,063,064,000
.Players:                             db  2,1,0,2,2             ;amount of players, player 1-4 (0=CPU, 1=Human, 2=OFF)
.StartingResources:
.Gold:                                dw  15000
.Wood:                                dw  20
.Ore:                                 dw  20
.Gems:                                dw  10
.Rubies:                              dw  10
.Castle1Player:                       db  1
.Castle2Player:                       db  2
.Castle3Player:                       db  1
.Castle4Player:                       db  1
.DaysToCompleteCampaign:              db  75
.CampaignText:						  db " Storm Randar's unaware castle   ",255
;starting Heroes
.P1hero1y:		db	1
.P1hero1x:		db	1
.P1hero1xp: dw 0 ;65000 ;3000 ;999
.P1hero1move:	db	20,20
.P1hero1mana:	dw	10,10
.P1hero1manarec:db	5		                ;recover x mana every turn
.P1hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P1Hero1Units:  db YieArKungFuUnitLevel1Number | dw YieArKungFuUnitLevel1Growth |      db YieArKungFuUnitLevel2Number | dw YieArKungFuUnitLevel2Growth |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.P1Hero1StatAttack:  db 1
.P1Hero1StatDefense:  db 2
.P1Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P1Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P1HeroSkills:  db  10,0,0,0,0,0
.P1HeroLevel: db  1
.P1EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P1FireSpells:        db  %0000 0000
.P1AirSpells:         db  %0000 0000
.P1WaterSpells:       db  %0000 0000
.P1AllSchoolsSpells:  db  %0000 0000
.P1Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P1HeroSpecificInfo: dw HeroAddressesPippols
.P1HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P2hero1y:		db	50
.P2hero1x:		db	50
.P2hero1xp: dw 0 ;65000 ;3000 ;999
.P2hero1move:	db	20,20
.P2hero1mana:	dw	80,80
.P2hero1manarec:db	5		                ;recover x mana every turn
.P2hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P2Hero1Units:  db 011 | dw 70 |      db 018 | dw 030 |      db 000 | dw 000 |      db 027 | dw 013 |      db 000 | dw 000 |      db 027 | dw 050 ;unit,amount
.P2Hero1StatAttack:  db 6
.P2Hero1StatDefense:  db 7
.P2Hero1StatKnowledge:  db 8  ;decides total mana (*10)
.P2Hero1StatSpellDamage:  db 11  ;amount of spell damage
.P2HeroSkills:  db  10,0,0,0,0,0
.P2HeroLevel: db  15
.P2EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.P2FireSpells:        db  %0000 1111
.P2AirSpells:         db  %0000 1111
.P2WaterSpells:       db  %0000 1111
.P2AllSchoolsSpells:  db  %0000 1111
.P2Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P2HeroSpecificInfo: dw HeroAddressesRandar
.P2HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P3hero1y:		db	1
.P3hero1x:		db	1
.P3hero1xp: dw 0 ;65000 ;3000 ;999
.P3hero1move:	db	20,20
.P3hero1mana:	dw	10,10
.P3hero1manarec:db	5		                ;recover x mana every turn
.P3hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P3Hero1Units:  db 175 | dw 060 |      db 000 | dw 000 |      db 000 | dw 000 |      db 173 | dw 020 |      db 000 | dw 000 |      db 175 | dw 060 ;unit,amount
.P3Hero1StatAttack:  db 1
.P3Hero1StatDefense:  db 2
.P3Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P3Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P3HeroSkills:  db  10,0,0,0,0,0
.P3HeroLevel: db  1
.P3EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P3FireSpells:        db  %0000 0000
.P3AirSpells:         db  %0000 0000
.P3WaterSpells:       db  %0000 0000
.P3AllSchoolsSpells:  db  %0000 0000
.P3Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P3HeroSpecificInfo: dw HeroAddressesAce
.P3HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

.P4hero1y:		db	1
.P4hero1x:		db	1
.P4hero1xp: dw 0 ;65000 ;3000 ;999
.P4hero1move:	db	20,20
.P4hero1mana:	dw	10,10
.P4hero1manarec:db	5		                ;recover x mana every turn
.P4hero1status:	db	255 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.P4Hero1Units:  db 176 | dw 016 |      db 176 | dw 027 |      db 176 | dw 021 |      db 176 | dw 031 |      db 176 | dw 040 |      db 176 | dw 053 ;unit,amount
.P4Hero1StatAttack:  db 1
.P4Hero1StatDefense:  db 2
.P4Hero1StatKnowledge:  db 1  ;decides total mana (*10)
.P4Hero1StatSpellDamage:  db 1  ;amount of spell damage
.P4HeroSkills:  db  16,0,0,0,0,0
.P4HeroLevel: db  1
.P4EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.P4FireSpells:        db  %0000 0000
.P4AirSpells:         db  %0000 0000
.P4WaterSpells:       db  %0000 0000
.P4AllSchoolsSpells:  db  %0000 0000
.P4Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.P4HeroSpecificInfo: dw HeroAddressesRandomHajile
.P4HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2




;A Beloved Journey: start with 1 castle. start with popolon and aphrodite (both level 3) in front of the castle. tavern empty. castle is psycho world. 2nd castle is empty. castle is junker hq. tavern filled with random heroes. Ruika is in a corner of the map in front of emerald gloves. win condition: capture emerald gloves. lose condition: lose either popolon or aphrodite.
;Amber Skies, Rogue AI: start with 1 castle. no heroes. Tien Ren, Ho Mei, and Mei Hong in tavern. Junker HQ is castle. enemy castle has Snatcher defending it with a huge snatcher army. win condition: defeat snatcher. lose condition: lose all heroes.
;last 6 campaigns unlock these castles: akanbe 1, akanbe 2, contra 2, yiearekungfu, bubble bobble 1, bubble bobble 2
;Dragons' Deliverance: start without heroes. start with goemon castle. tavern filled with random heroes. win condition: defeat hank mitchell within 60 days. lose condition: otherwise
;Hunting Dr. Mitchell: start without heroes. start with castlevania castle. tavern filled with 3 belmots. 2nd castle is empty and this is golvellius castle. both kelesis in tavern. win condition: defeat hank mitchell. lose condition: lose all belmonts if you own 1 castle. lose all heroes if you own 2 castles.
;Heart of the Jungle: start with bill rizer level 5. start with contra 1 castle. tavern filled with random heroes. enemy castle 1 has big boss and contra level 2 castle and units and random heroes in tavern. castle 2 the same, but with grey fox.
;Dawn of the Ninja: start with ruika level 7, yiearkungfu castle. tavern filled with random heroes. enemy castle 1: akanbe dragon 1 units with dr. mitchell. tavern with random heroes. enemy castle 2: lolo with akanbe draong 2 units. tavern with random heroes. win condition: defeat lolo and mitchell. lose condition: lose ruika.
;Pixy's Bubble Symphony: start with pixy level 5, bubble bobble 1 castle. tavern empty. enemy castle: dr pettrovich with a snatcher army. win condition: defeat dr pettrovich. lose condition: lose pixy.
;A Worzen Family Epic: start with bubble bobble 2 castle castle. no heroes. tavern filled with worzen family. 3 enemy castles with random heroes and randomly filled taverns. win condition: defeat all castles, lose condition: lose all heroes and castles.




endCampaignInfo: