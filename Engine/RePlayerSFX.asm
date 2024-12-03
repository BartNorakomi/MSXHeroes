;
; Re-Play player for sound effects
;
RePlayerSFX_CHANNEL_COUNT: equ 1

RePlayerSFX_Initialize:
	ld de,4
	ld ix,RePlayerSFX_channels
	ld b,RePlayerSFX_CHANNEL_COUNT
RePlayerSFX_Initialize_Loop:
	ld (ix + 0),SFX_nop and 0FFH
	ld (ix + 1),SFX_nop >> 8
	ld (ix + 2),usas2sfx1repBlock
	ld (ix + 3),1
	add ix,de
	djnz RePlayerSFX_Initialize_Loop
	ret

; Play sound effect on stream channel 1.
; Recommended for sounds originating from player.
; For example: player attacks, player impacts, jump, land.
; bc = sfx
RePlayerSFX_PlayCh1:	
	ld iy,RePlayerSFX_channels
	di
	ld (iy + 0),c
	ld (iy + 1),b
	ld (iy + 2),usas2sfx1repBlock
	ei
	ld (iy + 3),1
	ret



RePlayerSFX_Tick:
	ld a,(RePlayer_currentBank)
	push af
	ld ix,RePlayerSFX_channels
	ld b,RePlayerSFX_CHANNEL_COUNT
RePlayerSFX_Tick_Loop:
	dec (ix + 3)
	jr nz,RePlayerSFX_Tick_Next
	push bc
	ld l,(ix + 0)
	ld h,(ix + 1)
	ld a,(ix + 2)
	ld (RePlayer_currentBank),a
;	RePlayerSFX_SetBank_M
	ld (7000H),a
	call RePlayer_Process
	ld (ix + 3),a
	ld a,(RePlayer_currentBank)
	ld (ix + 0),l
	ld (ix + 1),h
	ld (ix + 2),a
	pop bc
RePlayerSFX_Tick_Next:
	inc ix
	inc ix
	inc ix
	inc ix
	djnz RePlayerSFX_Tick_Loop
	pop af
	ld (RePlayer_currentBank),a
;	RePlayer_SetBank_M
	ld (7000H),a
	ret

RePlayerSFX_channels:
	ds RePlayerSFX_CHANNEL_COUNT * 4


NormalSfx:	equ 0
SofterSfx:	equ 31
SoftestSfx:	equ 62

; Sound effects list (base address + 4 * track nr)
SFX_nop: equ 8001H + 4 * 0
SFX_MouseClick: equ 8001H + 4 * (1 + SofterSfx)
SFX_MouseOver: equ 8001H + 4 * (2 + SoftestSfx)
SFX_HeroWalk: equ 8001H + 4 * 3
SFX_ChestFound: equ 8001H + 4 * 5 | SFX_LearningStone: equ 8001H + 4 * 5 | SFX_ScrollFound: equ 8001H + 4 * 5 | SFX_TradeMenu: equ 8001H + 4 * 5 | SFX_SpireOfWisdom: equ 8001H + 4 * 5
SFX_BuildingBeingBuilt: equ 8001H + 4 * 5

SFX_CollectItem: equ 8001H + 4 * 66

;SFX_StartOfTurn: equ 8001H + 4 * 5
;SFX_StartOfTurn: equ 8001H + 4 * 35
SFX_StartOfTurn: equ 8001H + 4 * 65

SFX_Levelup: equ 8001H + 4 * 65
SFX_GuardTowerReward: equ 8001H + 4 * 65
SFX_GuardTowerEncountered: equ 8001H + 4 * 65

;SFX_ShowEnemyStats: equ 8001H + 4 * 6
;SFX_ShowEnemyStats: equ 8001H + 4 * 36
SFX_ShowEnemyStats: equ 8001H + 4 * 66

;SFX_Purchase: equ 8001H + 4 * 6
;SFX_Purchase: equ 8001H + 4 * 36
SFX_Purchase: equ 8001H + 4 * 66

SFX_MonsterDied: equ 8001H + 4 * 7
SFX_Punch: equ 8001H + 4 * 8 | SFX_enemyhit: equ 8001H + 4 * 8 
SFX_Kick: equ 8001H + 4 * 9
SFX_Shoot: equ 8001H + 4 * 10
SFX_Cure: equ 8001H + 4 * 11
SFX_Haste: equ 8001H + 4 * 12
SFX_Earthshock: equ 8001H + 4 * 13
SFX_MagicArrow: equ 8001H + 4 * 14
SFX_Sunstrike: equ 8001H + 4 * 15
SFX_IceBolt: equ 8001H + 4 * 16
SFX_Implosion: equ 8001H + 4 * 17
SFX_Slow: equ 8001H + 4 * 18
SFX_FrostRing: equ 8001H + 4 * 19
SFX_Shieldbreaker: equ 8001H + 4 * 20
SFX_Curse: equ 8001H + 4 * 21
SFX_PlateArmor: equ 8001H + 4 * 22
SFX_InnerBeast: equ 8001H + 4 * 23
SFX_Teleport: equ 8001H + 4 * 24
SFX_Frenzy: equ 8001H + 4 * 25
SFX_Resurrect: equ 8001H + 4 * 26
SFX_SpellBubble: equ 8001H + 4 * 27
SFX_Hypnosis: equ 8001H + 4 * 28
SFX_ClawBack: equ 8001H + 4 * 29
SFX_BlindingFog: equ 8001H + 4 * 30
SFX_InsufficientFunds: equ 8001H + 4 * 31 | SFX_WaterWell: equ 8001H + 4 * 31 | SFX_ShowEnemyHeroStats: equ 8001H + 4 * 31 | SFX_HeroOverviewMenu: equ 8001H + 4 * 31