loader:
  ret

CopyVramObjectsPage1and3:
  ;Copy level objects to page 1
  ld    a,(slot.page12rom)        ;all RAM except page 12
  out   ($a8),a          

;  ld    a,Graphicsblock5          ;block to copy from
;  call  block34
  
;	xor   a
;  ld    hl,$6C00+$8000            ;page 1 - screen 5 - bottom 40 pixels (scoreboard) start at y = 216
;	call	SetVdp_Write	
;	ld		hl,itemsKarniMata
;  ld    c,$98
;  ld    a,40/2                    ;copy 40 lines..
;  ld    b,0
;  call  copyGraphicsToScreen.loop1     

  ;copy Huge Blob graphics and primary and secundary weapons to page 3
  ld    a,(slot.page12rom)        ;all RAM except page 12
  out   ($a8),a          

;  ld    a,Graphicsblock4          ;block to copy from
;  call  block34

;	ld    a,1
;  ld    hl,$6C00+$8000            ;page 3 - screen 5 - bottom 40 pixels (scoreboard) start at y = 216
;	call	SetVdp_Write	

;	ld		hl,itemsKarniMataPage3
;  ld    c,$98
;  ld    a,40/2                    ;copy 40 lines..
;  ld    b,0
;  jp    copyGraphicsToScreen.loop1   
  
copyGraphicsToScreen2:
  ld    a,(slot.page12rom)            ;all RAM except page 12
  out   ($a8),a          

  ld    hl,$8000                      ;page 1 - screen 5
  ld    b,0

  ld    a,d                           ;Graphicsblock
  call  block34
  
	ld		a,b
	call	SetVdp_Write	
	ld		hl,$8000
  ld    c,$98
  ld    a,64                          ;first 128 line, copy 64*256 = $4000 bytes to Vram
  ld    b,0
      
  call  .loop1    

  ld    a,d                           ;Graphicsblock
;  add   a,2
  inc   a
  call  block34
  
	ld		hl,$8000
  ld    c,$98
  ld    a,64 ; 42                     ;second 84 line, copy 64*256 = $4000 bytes to Vram
  ld    b,0
      
  call  .loop1   

  ;this last part is to fill the screen with a repetition
;	ld		hl,$4000
;  ld    c,$98
;  ld    a,22                         ;second 84 line, copy 64*256 = $4000 bytes to Vram
;  ld    b,0
      
;  call  .loop1   
  ret

.loop1:
  otir
  dec   a
  jp    nz,.loop1
  ret
  