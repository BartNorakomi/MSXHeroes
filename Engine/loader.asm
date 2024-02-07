World1:  db  World1MapBlock |  dw World1Map |  db World1ObjectLayerMapBlock |  dw World1ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World2:  db  World2MapBlock |  dw World2Map |  db World2ObjectLayerMapBlock |  dw World2ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World3:  db  World3MapBlock |  dw World3Map |  db World3ObjectLayerMapBlock |  dw World3ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World4:  db  World4MapBlock |  dw World4Map |  db World4ObjectLayerMapBlock |  dw World4ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World5:  db  World5MapBlock |  dw World5Map |  db World5ObjectLayerMapBlock |  dw World5ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World6:  db  World6MapBlock |  dw World6Map |  db World6ObjectLayerMapBlock |  dw World6ObjectLayerMap |  db World1TilesBlock         |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World7:  db  World7MapBlock |  dw World7Map |  db World7ObjectLayerMapBlock |  dw World7ObjectLayerMap |  db TilesSdSnatcherBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World8:  db  World8MapBlock |  dw World8Map |  db World8ObjectLayerMapBlock |  dw World8ObjectLayerMap |  db TilesSolidSnakeBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4
World9:  db  World9MapBlock |  dw World9Map |  db World9ObjectLayerMapBlock |  dw World9ObjectLayerMap |  db TilesGentleBlock         |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4
World10: db  World10MapBlock | dw World10Map | db World10ObjectLayerMapBlock | dw World10ObjectLayerMap | db TilesGentleDesertBlock   |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4
World11: db  World11MapBlock | dw World11Map | db World11ObjectLayerMapBlock | dw World11ObjectLayerMap | db TilesGentleAutumnBlock   |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4
World12: db  World12MapBlock | dw World12Map | db World12ObjectLayerMapBlock | dw World12ObjectLayerMap | db TilesGentleWinterBlock   |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4
World13: db  World13MapBlock | dw World13Map | db World13ObjectLayerMapBlock | dw World13ObjectLayerMap | db TilesGentleJungleBlock   |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4
World14: db  World14MapBlock | dw World14Map | db World14ObjectLayerMapBlock | dw World14ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4

LenghtMapData:  equ GentleAutumnMap02-GentleAutumnMap01
GentleAutumnMap01: db  GentleAutumnMap01MapBlock | dw GentleAutumnMap01Map | db GentleAutumnMap01ObjectLayerMapBlock | dw GentleAutumnMap01ObjectLayerMap | db TilesGentleAutumnBlock     |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4 | db BattleFieldAutumnBlock | db GentleAutumnMiniMapsBlock | dw $4000 + (000*128) + (000/2) - 128 | db "3",255,"M",255,"scenario description 1",255
GentleAutumnMap02: db  GentleAutumnMap02MapBlock | dw GentleAutumnMap02Map | db GentleAutumnMap02ObjectLayerMapBlock | dw GentleAutumnMap02ObjectLayerMap | db TilesGentleAutumnBlock     |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4 | db BattleFieldAutumnBlock | db GentleAutumnMiniMapsBlock | dw $4000 + (000*128) + (050/2) - 128 | db "2",255,"M",255,"scenario description 2",255
GentleAutumnMap03: db  GentleAutumnMap03MapBlock | dw GentleAutumnMap03Map | db GentleAutumnMap03ObjectLayerMapBlock | dw GentleAutumnMap03ObjectLayerMap | db TilesGentleAutumnBlock     |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4 | db BattleFieldAutumnBlock | db GentleAutumnMiniMapsBlock | dw $4000 + (000*128) + (100/2) - 128 | db "3",255,"L",255,"scenario description 3",255
GentleAutumnMap04: db  GentleAutumnMap04MapBlock | dw GentleAutumnMap04Map | db GentleAutumnMap04ObjectLayerMapBlock | dw GentleAutumnMap04ObjectLayerMap | db TilesGentleAutumnBlock     |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4 | db BattleFieldAutumnBlock | db GentleAutumnMiniMapsBlock | dw $4000 + (000*128) + (150/2) - 128 | db "2",255,"S",255,"scenario description 4",255
GentleAutumnMap05: db  GentleAutumnMap05MapBlock | dw GentleAutumnMap05Map | db GentleAutumnMap05ObjectLayerMapBlock | dw GentleAutumnMap05ObjectLayerMap | db TilesGentleAutumnBlock     |   incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl",0,4 | db BattleFieldAutumnBlock | db GentleAutumnMiniMapsBlock | dw $4000 + (000*128) + (200/2) - 128 | db "4",255,"M",255,"scenario description 5",255

GentleCaveMap01: db  GentleCaveMap01MapBlock | dw GentleCaveMap01Map | db GentleCaveMap01ObjectLayerMapBlock | dw GentleCaveMap01ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4 | db BattleFieldCaveBlock | db GentleCaveMiniMapsBlock | dw $4000 + (048*128) + (000/2) - 128                   | db "2",255,"M",255,"scenario description 6",255
GentleCaveMap02: db  GentleCaveMap02MapBlock | dw GentleCaveMap02Map | db GentleCaveMap02ObjectLayerMapBlock | dw GentleCaveMap02ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4 | db BattleFieldCaveBlock | db GentleCaveMiniMapsBlock | dw $4000 + (048*128) + (050/2) - 128                   | db "4",255,"L",255,"scenario description 7",255
GentleCaveMap03: db  GentleCaveMap03MapBlock | dw GentleCaveMap03Map | db GentleCaveMap03ObjectLayerMapBlock | dw GentleCaveMap03ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4 | db BattleFieldCaveBlock | db GentleCaveMiniMapsBlock | dw $4000 + (048*128) + (100/2) - 128                   | db "2",255,"M",255,"scenario description 8",255
GentleCaveMap04: db  GentleCaveMap04MapBlock | dw GentleCaveMap04Map | db GentleCaveMap04ObjectLayerMapBlock | dw GentleCaveMap04ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4 | db BattleFieldCaveBlock | db GentleCaveMiniMapsBlock | dw $4000 + (048*128) + (150/2) - 128                   | db "3",255,"M",255,"scenario description 9",255
GentleCaveMap05: db  GentleCaveMap05MapBlock | dw GentleCaveMap05Map | db GentleCaveMap05ObjectLayerMapBlock | dw GentleCaveMap05ObjectLayerMap | db TilesGentleCaveBlock     |   incbin"..\grapx\tilesheets\PaletteGentleCave.pl",0,4 | db BattleFieldCaveBlock | db GentleCaveMiniMapsBlock | dw $4000 + (048*128) + (200/2) - 128                   | db "2",255,"M",255,"scenario description10",255

GentleDesertMap01: db  GentleDesertMap01MapBlock | dw GentleDesertMap01Map | db GentleDesertMap01ObjectLayerMapBlock | dw GentleDesertMap01ObjectLayerMap | db TilesGentleDesertBlock     |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4 | db BattleFieldDesertBlock | db GentleDesertMiniMapsBlock | dw $4000 + (096*128) + (000/2) - 128 | db "3",255,"L",255,"scenario description11",255
GentleDesertMap02: db  GentleDesertMap02MapBlock | dw GentleDesertMap02Map | db GentleDesertMap02ObjectLayerMapBlock | dw GentleDesertMap02ObjectLayerMap | db TilesGentleDesertBlock     |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4 | db BattleFieldDesertBlock | db GentleDesertMiniMapsBlock | dw $4000 + (096*128) + (050/2) - 128 | db "4",255,"L",255,"scenario description12",255
GentleDesertMap03: db  GentleDesertMap03MapBlock | dw GentleDesertMap03Map | db GentleDesertMap03ObjectLayerMapBlock | dw GentleDesertMap03ObjectLayerMap | db TilesGentleDesertBlock     |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4 | db BattleFieldDesertBlock | db GentleDesertMiniMapsBlock | dw $4000 + (096*128) + (100/2) - 128 | db "2",255,"M",255,"scenario description13",255
GentleDesertMap04: db  GentleDesertMap04MapBlock | dw GentleDesertMap04Map | db GentleDesertMap04ObjectLayerMapBlock | dw GentleDesertMap04ObjectLayerMap | db TilesGentleDesertBlock     |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4 | db BattleFieldDesertBlock | db GentleDesertMiniMapsBlock | dw $4000 + (096*128) + (150/2) - 128 | db "2",255,"S",255,"scenario description14",255
GentleDesertMap05: db  GentleDesertMap05MapBlock | dw GentleDesertMap05Map | db GentleDesertMap05ObjectLayerMapBlock | dw GentleDesertMap05ObjectLayerMap | db TilesGentleDesertBlock     |   incbin"..\grapx\tilesheets\PaletteGentleDesert.pl",0,4 | db BattleFieldDesertBlock | db GentleDesertMiniMapsBlock | dw $4000 + (096*128) + (200/2) - 128 | db "2",255,"S",255,"scenario description15",255

GentleJungleMap01: db  GentleJungleMap01MapBlock | dw GentleJungleMap01Map | db GentleJungleMap01ObjectLayerMapBlock | dw GentleJungleMap01ObjectLayerMap | db TilesGentleJungleBlock     |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4 | db BattleFieldJungleBlock | db GentleJungleMiniMapsBlock | dw $4000 + (144*128) + (000/2) - 128 | db "4",255,"L",255,"scenario description16",255
GentleJungleMap02: db  GentleJungleMap02MapBlock | dw GentleJungleMap02Map | db GentleJungleMap02ObjectLayerMapBlock | dw GentleJungleMap02ObjectLayerMap | db TilesGentleJungleBlock     |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4 | db BattleFieldJungleBlock | db GentleJungleMiniMapsBlock | dw $4000 + (144*128) + (050/2) - 128 | db "2",255,"M",255,"scenario description17",255
GentleJungleMap03: db  GentleJungleMap03MapBlock | dw GentleJungleMap03Map | db GentleJungleMap03ObjectLayerMapBlock | dw GentleJungleMap03ObjectLayerMap | db TilesGentleJungleBlock     |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4 | db BattleFieldJungleBlock | db GentleJungleMiniMapsBlock | dw $4000 + (144*128) + (100/2) - 128 | db "3",255,"M",255,"scenario description18",255
GentleJungleMap04: db  GentleJungleMap04MapBlock | dw GentleJungleMap04Map | db GentleJungleMap04ObjectLayerMapBlock | dw GentleJungleMap04ObjectLayerMap | db TilesGentleJungleBlock     |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4 | db BattleFieldJungleBlock | db GentleJungleMiniMapsBlock | dw $4000 + (144*128) + (150/2) - 128 | db "4",255,"L",255,"scenario description19",255
GentleJungleMap05: db  GentleJungleMap05MapBlock | dw GentleJungleMap05Map | db GentleJungleMap05ObjectLayerMapBlock | dw GentleJungleMap05ObjectLayerMap | db TilesGentleJungleBlock     |   incbin"..\grapx\tilesheets\PaletteGentleJungle.pl",0,4 | db BattleFieldJungleBlock | db GentleJungleMiniMapsBlock | dw $4000 + (144*128) + (200/2) - 128 | db "3",255,"M",255,"scenario description20",255

GentleMap01: db  GentleMap01MapBlock | dw GentleMap01Map | db GentleMap01ObjectLayerMapBlock | dw GentleMap01ObjectLayerMap | db TilesGentleBlock     |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4 | db BattleFieldGentleBlock | db GentleMiniMapsBlock | dw $4000 + (192*128) + (000/2) - 128                                                 | db "3",255,"L",255,"scenario description21",255
GentleMap02: db  GentleMap02MapBlock | dw GentleMap02Map | db GentleMap02ObjectLayerMapBlock | dw GentleMap02ObjectLayerMap | db TilesGentleBlock     |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4 | db BattleFieldGentleBlock | db GentleMiniMapsBlock | dw $4000 + (192*128) + (050/2) - 128                                                 | db "3",255,"M",255,"scenario description22",255
GentleMap03: db  GentleMap03MapBlock | dw GentleMap03Map | db GentleMap03ObjectLayerMapBlock | dw GentleMap03ObjectLayerMap | db TilesGentleBlock     |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4 | db BattleFieldGentleBlock | db GentleMiniMapsBlock | dw $4000 + (192*128) + (100/2) - 128                                                 | db "3",255,"S",255,"scenario description23",255
GentleMap04: db  GentleMap04MapBlock | dw GentleMap04Map | db GentleMap04ObjectLayerMapBlock | dw GentleMap04ObjectLayerMap | db TilesGentleBlock     |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4 | db BattleFieldGentleBlock | db GentleMiniMapsBlock | dw $4000 + (192*128) + (150/2) - 128                                                 | db "2",255,"S",255,"scenario description24",255
GentleMap05: db  GentleMap05MapBlock | dw GentleMap05Map | db GentleMap05ObjectLayerMapBlock | dw GentleMap05ObjectLayerMap | db TilesGentleBlock     |   incbin"..\grapx\tilesheets\PaletteGentle.pl",0,4 | db BattleFieldGentleBlock | db GentleMiniMapsBlock | dw $4000 + (192*128) + (200/2) - 128                                                 | db "4",255,"L",255,"scenario description25",255

GentleWinterMap01: db  GentleWinterMap01MapBlock | dw GentleWinterMap01Map | db GentleWinterMap01ObjectLayerMapBlock | dw GentleWinterMap01ObjectLayerMap | db TilesGentleWinterBlock     |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4 | db BattleFieldWinterBlock | db GentleWinterMiniMapsBlock | dw $4000 + (207*128) + (000/2) - 128 | db "2",255,"M",255,"scenario description26",255
GentleWinterMap02: db  GentleWinterMap02MapBlock | dw GentleWinterMap02Map | db GentleWinterMap02ObjectLayerMapBlock | dw GentleWinterMap02ObjectLayerMap | db TilesGentleWinterBlock     |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4 | db BattleFieldWinterBlock | db GentleWinterMiniMapsBlock | dw $4000 + (207*128) + (050/2) - 128 | db "2",255,"M",255,"scenario description27",255
GentleWinterMap03: db  GentleWinterMap03MapBlock | dw GentleWinterMap03Map | db GentleWinterMap03ObjectLayerMapBlock | dw GentleWinterMap03ObjectLayerMap | db TilesGentleWinterBlock     |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4 | db BattleFieldWinterBlock | db GentleWinterMiniMapsBlock | dw $4000 + (207*128) + (100/2) - 128 | db "4",255,"S",255,"scenario description28",255
GentleWinterMap04: db  GentleWinterMap04MapBlock | dw GentleWinterMap04Map | db GentleWinterMap04ObjectLayerMapBlock | dw GentleWinterMap04ObjectLayerMap | db TilesGentleWinterBlock     |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4 | db BattleFieldWinterBlock | db GentleWinterMiniMapsBlock | dw $4000 + (207*128) + (150/2) - 128 | db "4",255,"M",255,"scenario description29",255
GentleWinterMap05: db  GentleWinterMap05MapBlock | dw GentleWinterMap05Map | db GentleWinterMap05ObjectLayerMapBlock | dw GentleWinterMap05ObjectLayerMap | db TilesGentleWinterBlock     |   incbin"..\grapx\tilesheets\PaletteGentleWinter.pl",0,4 | db BattleFieldWinterBlock | db GentleWinterMiniMapsBlock | dw $4000 + (207*128) + (200/2) - 128 | db "4",255,"S",255,"scenario description30",255



;tiles:
;000-015 no obstacle, but hero walks behind it, but they are not see through
;016-023 obstacle
;024-148 walkable terrain pieces (no obstacle)

;non_see_throughpieces:      equ 16    ;tiles 0-15: background pieces a hero can stand behind, but they are not see through
;amountoftransparantpieces:  equ 64    ;tiles 16-63: see-through background pieces hero can stand behind
;UnwalkableTerrainPieces:    equ 149   ;tiles 149 and up are unwalkable terrain

;mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
;  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
;  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112, 000,000, 000,000, 000,000, 000,000, 080,192, 080,208, 000,000, 000,000
  
  
  
MiniMapBlock: equ 12  
MiniMapAddress: equ 13
  
;hud is placed in page 0 and will be copied to page 1 after this. So load minimap in page 0
XMiniMap: equ 203
YMiniMap: equ 005
LoadMiniMap:
  ld    ix,(WorldPointer)
  ld    l,(ix+MiniMapAddress)                                 ;block to copy graphics from  
  ld    h,(ix+MiniMapAddress+1)                                 ;block to copy graphics from  
  ld    de,$0000 + (YMiniMap*128) + (XMiniMap/2) - 128
  ld    bc,$0000 + (048*256) + (050/2)
  ld    a,(ix+MiniMapBlock)                                 ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

XMiniMapScenarioSelectScreen: equ 174
YMiniMapScenarioSelectScreen: equ 033
PutMiniMapScenarioSelectScreen:
  ld    ix,(WorldPointer)
  ld    l,(ix+MiniMapAddress)                                 ;block to copy graphics from  
  ld    h,(ix+MiniMapAddress+1)                                 ;block to copy graphics from  
  ld    de,$0000 + (YMiniMapScenarioSelectScreen*128) + (XMiniMapScenarioSelectScreen/2) - 128
  ld    bc,$0000 + (048*256) + (050/2)
  ld    a,(ix+MiniMapBlock)                                 ;block to copy graphics from  
  call  CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  halt
  ld    ix,(WorldPointer)
  call  SetMapPalette
  jp    SwapAndSetPage                  ;swap and set page

SetCastlesInMiniMap:
  ld    ix,Castle1
  call  .SetCastle
  ld    ix,Castle2
  call  .SetCastle
  ld    ix,Castle3
  call  .SetCastle
  ld    ix,Castle4
  call  .SetCastle
  ret

  .SetCastle:
;minimap is 48x48. Worldmap is 128x128
;48:128 = 3:8.. so read tile/pixel 1, 4, 7  
  ld    a,(ix+CastleX)
  cp    255
  ret   z
  ld    h,0
  ld    l,a
  ld    de,3                            ;first multiply by 3
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   bc
  ld    de,8                            ;then divide by 8
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc
  
  ld    l,(ix+CastleY)
  ld    h,0
  ld    de,3                            ;first multiply by 3
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   bc
  ld    de,8                            ;then divide by 8
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  pop   de
  ld    a,c
  add   YMiniMap-2
  ld    d,a

  ld    a,e
  add   XMiniMap-1
  ld    e,a
  
  ld    hl,$4000 + (071*128) + (212/2) - 128
;  ld    de,256*025 + 220                ;(dy*256 + dx)
  ld    bc,$0000 + (004*256) + (004/2)
  ld    a,HudNewBlock                   ;block to copy graphics from  
  exx
  ex    af,af'
  ld    hl,CopyTransparantImageEXX
  jp    EnterSpecificRoutineInCastleOverviewCode

ConvertMonstersObjectLayer:
 ; ld    a,(slot.page1rom)             ;all RAM except page 1
 ; out   ($a8),a      

 ; ld		a,2                           ;set worldmap object layer in bank 2 at $8000
 ; out   ($fe),a          	            ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 
  
  ld    hl,$8000-1

  .loopAndXorA:
  xor   a
  .loop:
  inc   hl
  bit   6,h                           ;check if hl=$c000 (end of object layer in ram)
  ret   nz

  or    (hl)
  jp    z,.loop
  
  .Check:
  cp    7
  jr    nc,.loopAndXorA

  dec   a
  jp    z,.Level1Monster
  dec   a
  jr    z,.Level2Monster
  dec   a
  jr    z,.Level3Monster
  dec   a
  jr    z,.Level4Monster
  dec   a
  jr    z,.Level5Monster

  .Level6Monster:
  ld    de,(MonsterLevel6Pointer)
  ld    a,(de)
  cp    255
  jr    z,.Level5Monster
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel6Pointer
  ld    de,ListOfUnlockedMonstersLevel6
  .SetMonsterLevel6Pointer:
  ld    (MonsterLevel6Pointer),de
  jp    .loopAndXorA

  .Level5Monster:
  ld    de,(MonsterLevel5Pointer)
  ld    a,(de)
  cp    255
  jr    z,.Level4Monster
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel5Pointer
  ld    de,ListOfUnlockedMonstersLevel5
  .SetMonsterLevel5Pointer:
  ld    (MonsterLevel5Pointer),de
  jp    .loopAndXorA

  .Level4Monster:
  ld    de,(MonsterLevel4Pointer)
  ld    a,(de)
  cp    255
  jr    z,.Level3Monster
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel4Pointer
  ld    de,ListOfUnlockedMonstersLevel4
  .SetMonsterLevel4Pointer:
  ld    (MonsterLevel4Pointer),de
  jp    .loopAndXorA

  .Level3Monster:
  ld    de,(MonsterLevel3Pointer)
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel3Pointer
  ld    de,ListOfUnlockedMonstersLevel3
  .SetMonsterLevel3Pointer:
  ld    (MonsterLevel3Pointer),de
  jp    .loopAndXorA

  .Level2Monster:
  ld    de,(MonsterLevel2Pointer)
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel2Pointer
  ld    de,ListOfUnlockedMonstersLevel2
  .SetMonsterLevel2Pointer:
  ld    (MonsterLevel2Pointer),de
  jp    .loopAndXorA
  
  .Level1Monster:
  ld    de,(MonsterLevel1Pointer)
  call  .ConvertLevelToMonster
  jr    nz,.SetMonsterLevel1Pointer
  ld    de,ListOfUnlockedMonstersLevel1
  .SetMonsterLevel1Pointer:
  ld    (MonsterLevel1Pointer),de
  jp    .loopAndXorA

  .ConvertLevelToMonster:
  ld    a,(de)
  ld    (hl),a
  cp    160                           ;monster nr 160 and above are 1 tile in size
  jr    nc,.EndCheck1Or2TilesInSize
  ld    bc,-128
  add   hl,bc
  add   a,64+6                        ;top part of monster is 64+6 tiles higher (the +6 are the 6 numbers)
  ld    (hl),a
  sbc   hl,bc
    
  .EndCheck1Or2TilesInSize:
  inc   de
  ld    a,(de)
  or    a
  ret

CastleTileNr: equ 254
Number1Tile:  equ 192
FindAndSetCastles:                      ;castles on the map have to be assigned to their players, and coordinates have to be set
 ; ld    a,(slot.page1rom)             ;all RAM except page 1
 ; out   ($a8),a      

 ; ld		a,2                           ;set worldmap object layer in bank 2 at $8000
 ; out   ($fe),a          	            ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 
  
  ld    hl,$8000-1
  .SetCastleTileNrAndGoloop:
  ld    a,CastleTileNr
  .loop:
  inc   hl
  bit   6,h                             ;hl=$c000 ? (this happens when bit 6 of h=1)
  ret   nz
  cp    (hl)
  jr    nz,.loop

  ld    a,l                             ;x value castle
  and   127
  dec   a
  ld    e,a                             ;x value castle

  push  hl
  push  hl
  pop   bc

  inc   hl                              ;player that owns this castle
  ld    a,(hl)
  sub   a,Number1Tile-1
  
  cp    1
  ld    ix,Castle1
  jr    z,.CastleNrFound
  cp    2
  ld    ix,Castle2  
  jr    z,.CastleNrFound
  cp    3
  ld    ix,Castle3
  jr    z,.CastleNrFound
  ld    ix,Castle4
  .CastleNrFound:
  
  ld    (ix+CastlePlayer),a
  ld    (ix+CastleX),e
  ld    (hl),0                          ;remove number from object map

  ld    de,128
  call  DivideBCbyDE                    ;In: BC/DE. mOut: BC = result, HL = rest
 
  ld    a,c                             ;y value castle
  inc   a
  ld    (ix+CastleY),a  

  pop   hl
  jp    .SetCastleTileNrAndGoloop

PlaceHeroesInCastles:                   ;Place hero nr#1 in their castle
  ld    ix,Castle1
  call  .PlaceHero
  ld    ix,Castle2
  call  .PlaceHero
  ld    ix,Castle3
  call  .PlaceHero
  ld    ix,Castle4
  call  .PlaceHero
  ret

  .PlaceHero:
  ld    a,(ix+CastlePlayer)
  ld    iy,pl1hero1y
  cp    1
  jr    z,.SetHeroInCastle
  ld    iy,pl2hero1y
  cp    2
  jr    z,.SetHeroInCastle
  ld    iy,pl3hero1y
  cp    3
  jr    z,.SetHeroInCastle
  ld    iy,pl4hero1y
  cp    4
  jr    z,.SetHeroInCastle
  .SetHeroInCastle:
  ld    a,(ix+CastleY)
  dec   a
  ld    (iy+HeroY),a
  ld    a,(ix+CastleX)
  add   a,2
  ld    (iy+HeroX),a
  ld    (iy+HeroStatus),2               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  ret

; Check/Init Mouse
CHMOUS:	
  CALL	.MOUSIN
	LD	A,$10	; first port 1
	LD	(MSEPRT),A
	CALL	.CHMS.0
	JP	NC,.MOUSIN
	LD	A,$60	; port 2
	LD	(MSEPRT),A
	CALL	.CHMS.0
	JP	NC,.MOUSIN
	
	XOR	A	; not found
	LD	(MOUSID),A
;	LD	(MSEPRT),A
;	SCF	
	RET	
	
  ; Install Mouse
.MOUSIN:	LD	A,255
	LD	(MOUSID),A
	LD	HL,DLY_M2	; delay routs
;	LD	A,(ComputerID)              ;3=turbo r, 2=msx2+, 1=msx2, 0=msx1
;	CP	3
;	JP	C,.MSIN.0
;	CALL	$0183
;	AND	A
;	JP	Z,.MSIN.0
;	LD	HL,DLY_TR
;.MSIN.0:	
;  LD	(DLYCAL+1),HL
;	AND	A
	EI	
	RET	
	
.CHMS.0:	LD	B,40	; check 40 times
.CHMS.1:	PUSH	BC
	CALL	.RDPADL
	LD	A,H	; Y-off
	CP	1	; Y-off
	JP	NZ,.CHMS.2
	LD	A,L	; X-off
	CP	1
	JP	NZ,.CHMS.2
	POP	BC
	DJNZ	.CHMS.1
	SCF		; Cy:1 (not found)
	RET	
.CHMS.2:	POP	BC	; found
	AND	A	; Cy:0
	RET	


; Read padle
; Out: (MSEOFS), mouse offsets (Y,X)
;       HL, mouse offsets (XXYY)
.RDPADL:	PUSH	BC
	PUSH	DE
	
	LD	DE,(MSEPRT)
	LD	A,15	; Read PSG r15 port B
	CALL	RD_PSG
	AND	%10001111	; interface 1
	OR	E	; mouse NR
	LD	E,A
	
; X offset
	LD	B,40	; delay Z80
	LD	C,20	; delay R800
	CALL	.RPDL.2
	CALL	.RPDL.0
	LD	H,A
	
; Y offset
	CALL	.RPDL.1
	CALL	.RPDL.0
	LD	L,A
	
	EI	
	POP	DE
	POP	BC
	RET	
	
.RPDL.0:	RLCA	
	RLCA	
	RLCA	
	RLCA	
	LD	D,A
	CALL	.RPDL.1
	OR	D
	NEG	
	RET	
	
.RPDL.1:	LD	B,7
	LD	C,6
.RPDL.2:	LD	A,15
	CALL	WR_PSG
	LD	A,(MSEPRT)
	AND	$30
	XOR	E
	LD	E,A
.DLYCAL:	CALL	DLY_M2
	LD	A,14
	CALL	RD_PSG
	AND	$0F
	RET	