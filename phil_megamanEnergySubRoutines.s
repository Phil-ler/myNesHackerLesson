.export Main
.segment "CODE"

.proc Main
  ; Initialize Megaman healtBar and weaponBar to #100
  lda #100
  sta $0300     ; healtBar
  sta $0301     ; weaponBar

  ; Initize standard values healt, energy and damange
  lda #15
  sta $20       ; minHealt

  lda #40
  sta $21       ; midHealt

  lda #15       
  sta $22       ; use of energy by use a weapon

  lda #20
  sta $23       ; generic damage taken by an enemy

 


  ; I store the params in this ways...
  ; $00 selected bar
  ; $01 energy to increment / decrement

  ;-------------------------------------------------------------------
  ; Way to go, Megaman use gemini ray for 3 times, 
  ; every time is used, it costs 15 units of weaponBar
  
  clc
  ldx #2  ; loop 3 times we use geminy ray

:     
  jsr useSpecialWeapon
  dex
  bpl :-  ; come back to previous unnamed label



  ;-------------------------------------------------------------------
  ;Watch out! Megaman is hit 4 times, every single damage is 20 HP low
  clc
  ldx #3  ; loop 4 times, once for hit
 
:  
  jsr takeDamage
  dex
  bpl :-  ; come back to previous unnamed label

  ;---------------------------------------------------------------
  ;Megaman collect a minHealt
  jsr collectMinHealt

  ;---------------------------------------------------------------
  ;Megaman collect a midHealt
  jsr collectMidHealt


  ;---------------------------------------------------------------
  ;Megaman collect a minWeapon
  jsr collectMinWeapon

  ;---------------------------------------------------------------
  ;Megaman collect a midWeapon
  jsr collectMidWeapon
 
  ;store final values in registers for simple final debug
  ;I know fceux have the panel 
  ldx $0300
  ldy $0301
  rts

.endproc

useSpecialWeapon:

  lda $0301
  sta $00

  lda $22
  sta $01
  jsr reduceBar
  lda $00
  sta $0301

  rts

takeDamage:
   
  lda $0300
  sta $00

  lda $23
  sta $01
  jsr reduceBar
  lda $00
  sta $0300
  rts

collectMidWeapon:
 
  lda $0301
  sta $00

  lda $21
  sta $01
  jsr incrementBar
  lda $00
  sta $0301
  rts

collectMinWeapon:
 
  lda $0301
  sta $00

  lda $20
  sta $01
  jsr incrementBar
  lda $00
  sta $0301
  rts

collectMidHealt:
 
  lda $0300
  sta $00

  lda $21
  sta $01
  jsr incrementBar
  lda $00
  sta $0300
  rts

collectMinHealt:
 
  lda $0300
  sta $00

  lda $20
  sta $01
  jsr incrementBar
  lda $00
  sta $0300
  rts

reduceBar:

  lda $00
  sec 
  sbc $01
  cmp #0
  bpl :+
  lda #0
: sta $00
  rts

incrementBar:
  lda $00
  clc
  adc $01
  cmp #100
  bcc :+
  lda #100
: sta $00  
  rts
