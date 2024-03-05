properly handle amount of players after a player is defeated
  call  SetNextPlayersTurn
  ;set next player's turn
SetNextPlayersTurn:
	ld		a,(amountofplayers)       ;set next player to have their turn
	ld		b,a
	ld		a,(whichplayernowplaying?)
	cp		b
	jp		nz,.endchecklastplayer
	xor		a
  .endchecklastplayer:	
	inc		a
	ld		(whichplayernowplaying?),a
  ret


set random spells in castles at start of game.. shuffle castles' spells

battle:
options menu: 
1 view walkable grid/movement shadow
2 animation speed (normal/fast)
3 load game
4 main menu
5 return to combat
battle field stones/objects
MONSTER AUTO DROP SPELLSCROLL CURE, WHICH HERO AUTOPICKS UP
hardware sprite monster ranged weapons

toen axe man aan de rechterrand van het scherm displace and width=32 werd, verscheen ook het monster naast 'm (die zombie uit usas)
Axe  man kijkt naar links, staat helemaal rechts. Hij krijgt dus geen width=16 aan het eind.
mogelijk stond het monster waar ie op schoot naast 'm, waardoor het projectiel al verdwenen was voordat de routines db 128+16,WaitImpactProjectile gebeurd waren... ???

low prio
autocombat moet een sprite worden
footman meervoud wordt footmans in battle ipv footmen. naam wijzigen
als je de stats kijkt van een monster, net voordat een nieuwe ronde start (of net voordat er text in het textvak geplaatst wordt), dan wordt de text niet goed geplaatst in beide pages. oplossing: je kunt niet de stats kijken als puttext? of hoe dat dan ook heet actief is.

worldmap:
AI
options/settings/save menu:
Show day/week/month
1 save game
2 load game
3 main menu

low prio:
shift click unit moet nog gemaakt worden om units te splitsen
units splitsen op hud
units in hud nog een beetje finetunen
als je scrollt wordt de page niet geswapped op vblank, daardoor je soms de helft van het scherm opgebouwd ziet, en de andere helft is nog van de mirror page (w/e?)
als je xp >20000 dan zie je het / teken niet in het status scherm

castle:

low prio:
als je een gebouw upgrade, misschien een coin pickup animatie, of een + symbool (samen met het sfx)


title screen:

;still to do, WIP:
;campaign 1-9: unlocks ALL heroes (and their castles) that HAVE a castle (1st campain unlocks 2 castles)
;campaign 10-24: each unlocks 1 random hero without castle. 14 heroes in total. A hero without castle that is still locked will have nr 255 in the HeroesWithoutCastle list 
;campaign 25-30: each unlocks 1 castle: YieArKungFu, BubbleBobbleGroupA, BubbleBobbleGroupB, AkanbeDragonGroupA, AkanbeDragonGroupB and ContraGroupB
;then (from map 10 and upwards) player can unlock remaining heroes without castle in normal game by finding/collecting their cards
;neutral monsters should be unlocked gradually (automatically) after each campaign

general:
muziek
sfx


titel scherm:
- Single Scenario (locked)
- Campaign
- Load Game
- Game Options
- Collection




