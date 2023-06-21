; This code creates a level for the game Journey of the Prairie King.

; The level is 10x10 squares.

; The first byte of each row represents the type of tile at that location.
; 0 = empty space
; 1 = wall
; 2 = coin
; 3 = enemy

level:
  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  db 0, 1, 1, 1, 1, 1, 1, 1, 0, 0
  db 0, 1, 0, 0, 0, 0, 0, 1, 0, 0
  db 0, 1, 0, 2, 2, 2, 0, 1, 0, 0
  db 0, 1, 0, 0, 0, 0, 0, 1, 0, 0
  db 0, 1, 1, 1, 1, 1, 1, 1, 0, 0
  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; This code draws the level on the screen.

draw_level:
  ld hl, level
  ld de, $2000
  ld bc, 100
  ldir

; This code creates the enemies.

enemies:
  db 3, 1, 5
  db 3, 5, 10
  db 3, 9, 15

; This code starts the game.

start_game:
  jp main
