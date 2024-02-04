HandleTitleScreenCode:
  ld    a,1
	ld		(activepage),a			
  call  SetScenarioSelectGraphics
  xor   a
	ld		(activepage),a			
  call  SetScenarioSelectGraphics

  ld    hl,InGamePalette
  call  SetPalette

  .kut: jp .kut

SetScenarioSelectGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

