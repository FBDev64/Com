; 22/06/2023

globals [
  going?            ;if the game is running this is true
  time-left         ;duration left in the game until win
  fired?            ;used to implement firerate
  kills             ;used for powerup spawning
  killlocker        ;used to prevent a bug with poewrup spawning
  lives             ;amount of lives before death
  firerate          ;changed by firerate powerup
  fireratetime      ;duration of powerup
  deadorc           ;used to prevent a bug
  dead?             ;used to prevent a bug
  hardmode?         ;changes various values if true (to make game harder)
]

patches-own [spawnpoint?]

players-own [
  speed                ;changed by speed powerup
  speedtime            ;duration of powerup
  octashot             ;changed by octashot powerup
  octashottime         ;duration of powerup
  shotgun              ;changed by shotgun powerup
  shotguntime          ;duration of powerup
]

breed [players player]              ;player
breed [bullets bullet]              ;bullets
breed [orcs orc]                    ;enemy
breed [speedups speedup]            ;powerup
breed [octashotups octashotup]      ;powerup
breed [nukes nuke]                  ;powerup
breed [liveups liveup]              ;powerup
breed [shotgunups shotgunup]        ;powerup
breed [firerateups firerateup]      ;powerup


to setup
  ca
  import-pcolors "JOPK_Level_1_1.png"
  create-players 1
  set hardmode? false

  ask player 0 [
    set shape "idle"
    set size 25
    set speed 7
    set fired? 0
    set shotgun false]

ask patch 8 122 [set spawnpoint? true];north side      ;used to set spawnpoints on enemies...
ask patch -8 122 [set spawnpoint? true]
ask patch 24 122 [set spawnpoint? true]

ask patch 8 -122 [set spawnpoint? true];south side
ask patch -8 122 [set spawnpoint? true]
ask patch 24 -122 [set spawnpoint? true]

ask patch -122 8 [set spawnpoint? true];west side
ask patch -122 -8 [set spawnpoint? true]
ask patch -122 -24 [set spawnpoint? true]

ask patch 122 8 [set spawnpoint? true];east side
ask patch 122 -8 [set spawnpoint? true]
ask patch 122 -24 [set spawnpoint? true]

set time-left 60              ;60 seconds until game finishes
set fired? false
set killlocker true
set kills 0
set lives 2                   ;start with 2 lives
set firerate .5
reset-timer
end

to hardmode-setup
  ca
  import-pcolors "JOPK_Level_1_1.png"
  create-players 1
  set hardmode? true

  ask player 0 [
    set shape "idle"
    set size 25
    set speed 6
    set fired? 0
    set shotgun false ]

  ask patch 8 122 [set spawnpoint? true];north side
  ask patch -8 122 [set spawnpoint? true]
  ask patch 24 122 [set spawnpoint? true]

  ask patch 8 -122 [set spawnpoint? true];south side
  ask patch -8 122 [set spawnpoint? true]
  ask patch 24 -122 [set spawnpoint? true]

  ask patch -122 8 [set spawnpoint? true];west side
  ask patch -122 -8 [set spawnpoint? true]
  ask patch -122 -24 [set spawnpoint? true]

  ask patch 122 8 [set spawnpoint? true];east side
  ask patch 122 -8 [set spawnpoint? true]
  ask patch 122 -24 [set spawnpoint? true]

  set time-left 60
  set fired? false
  set killlocker true
  set kills 0
  set lives 1                   ;start with 1 life
  set firerate .6
reset-timer
end


to go
  if dead? != true [       ;if player is not dead...
    set going? true
    cycle

    every .1
    [
      bullet-travel
      die?
      spawn
      move
      speedtimer
      speeduppower
      powerupspawn
      octashotpower
      octashottimer
      nukepower
      fireratepower
      fireratetimer
      shotgunpower
      shotguntimer
      liveuppower]

    every 1 [
      set time-left (time-left - 1)       ;counts down timer until win
    ]

    if time-left = 0 [
      ask orcs [die]
      user-message "You have won!"      ;win message
      stop
      set going? false]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAYER DEATH
to die?
  ask orcs [
    ask players in-radius 15 [
      set lives lives - 1
      set going? false
      set deadorc true] ;deadorc used to prevent bug
    if deadorc = true [
      set deadorc false
      die]]
  if lives <= 0 [
    set lives 0
    user-message "Game Over"           ;death message
    set dead? true
    stop]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWERUP TIMERS
to speedtimer                         ;duration of powerup
  ifelse hardmode? = true [
    if count players > 0 [            ;if count players > 0 used to prevent death bug
    ask player 0 [
      if speed = 10 [
        every .1 [
          if count players != 0 [
            ask player 0 [set speedtime speedtime + .1]
            ask player 0 [if speedtime >= 5 [set speed 6]]
  ]]]]]]

  [
    if count players > 0 [             ;if count players > 0 used to prevent death bug
      ask player 0 [
        if speed = 13 [
          every .1 [
            if count players != 0 [
              ask player 0 [set speedtime speedtime + .1]
              ask player 0 [if speedtime >= 7 [set speed 7]]
  ]]]]]]
end

to octashottimer                    ;duration of powerup
  if count players > 0 [            ;if count players > 0 used to prevent death bug
    ask player 0 [
      if octashot = 1 [
        every .1 [
          if count players != 0 [
            ask player 0 [
              set octashottime octashottime + .1
              ifelse hardmode? = true [
                if octashottime >= 5 [set octashot 0 set octashottime 0]] [
                if octashottime >= 7 [set octashot 0 set octashottime 0]]
  ]]]]]]
end

to fireratetimer                   ;duration of powerup
  ifelse hardmode? = true [
    if firerate = .3 [
      every .1 [
        if count players != 0 [
          set fireratetime fireratetime + .1
          if fireratetime >= 5 [set firerate .6 set fireratetime 0]
  ]]]]
  [
    if firerate = .2 [
      every .1 [
        if count players != 0 [
          set fireratetime fireratetime + .1
          if fireratetime >= 7 [set firerate .5 set fireratetime 0]
  ]]]]
end

to shotguntimer                   ;duration of powerup
  if count players > 0 [          ;if count lpayers > 0 used to prevent death bug
    ask player 0 [
      if shotgun = true [
        every .1 [
          if count players != 0 [
            ask player 0 [
              set shotguntime shotguntime + .1
              ifelse hardmode? = true [
                if shotguntime >= 5 [set shotgun false set shotguntime 0]] [
                if shotguntime >= 7 [set shotgun false set shotguntime 0]]
  ]]]]]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWERUP EFFECTS
to speeduppower                       ;effect of powerup
  ifelse hardmode? = true [
    ask speedups [
    ask players in-radius 15 [
      set speedtime 0
      set speed 10]
    if count players in-radius 15 > 0 [
        die]]]

  [
    ask speedups [
      ask players in-radius 15 [
        set speedtime 0
        set speed 13]
      if count players in-radius 15 > 0 [
        die]]]
end

to octashotpower                   ;effect of powerup
  ask octashotups [
    ask players in-radius 15 [
      set octashot 1]
    if count players in-radius 15 > 0 [
      die]]
end

to nukepower                       ;effect of powerup
  ask nukes [
    if count players in-radius 15 != 0 [
      ask orcs [die]
      die]]
end

to fireratepower                  ;effect of powerup
  ifelse hardmode? = true [
    ask firerateups [
      if count players in-radius 15 != 0 [
        set firerate .3
        die]]]
  [
    ask firerateups [
      if count players in-radius 15 != 0 [
        set firerate .2
        die]]]
end

to shotgunpower                   ;effect of powerup
  ask shotgunups [
    if count players in-radius 15 != 0 [
      ask player 0 [
        set shotgun true]
      die]]
end

to liveuppower                   ;effect of powerup
  ask liveups [
    if count players in-radius 15 != 0 [
      set lives lives + 1
      die]]
  end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWERUP SPAWN
to powerupspawn
  ifelse hardmode? = true [

    if kills mod 14 = 1 [
      set killlocker false]

    if kills mod 14 = 0 and kills != 0 [
      if killlocker = false [
        let randomizer random 6                  ;so that uses same random value for each powerup
        if randomizer = 0 [
          create-speedups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "coffee"]]           ;custom turtles created for look
        if randomizer = 1 [
          create-octashotups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "wheel"]]
        if randomizer = 2 [
          create-nukes 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "nuke"]]
        if randomizer = 3 [
          create-firerateups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "machinegun"]]
        if randomizer = 4 [
          create-shotgunups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "shotgun"]]
        if randomizer = 5 [
          create-liveups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "extralife"]]
        set killlocker true]]]

  [
    if kills mod 10 = 1 [
      set killlocker false]

    if kills mod 10 = 0 and kills != 0 [
      if killlocker = false [
        let randomizer random 6
        if randomizer = 0 [
          create-speedups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "coffee"]]
        if randomizer = 1 [
          create-octashotups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "wheel"]]
        if randomizer = 2 [
          create-nukes 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "nuke"]]
        if randomizer = 3 [
          create-firerateups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "machinegun"]]
        if randomizer = 4 [
          create-shotgunups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "shotgun"]]
        if randomizer = 5 [
          create-liveups 1 [setxy random (96 - -96 + 1) + -96 random (96 - -96 + 1) + -96 set size 20 set shape "extralife"]]
        set killlocker true]]]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ORCS
to spawn
  ask patches with [spawnpoint? = true] [         ;spawns at spawnpoints
    if random 125 = 0 [
      sprout-orcs 1 [
        set shape "orcwalk_1"
        set size 25]
    ]
  ]
end

to move
  ifelse hardmode? = true [
    ask orcs [
      if going? = true [
        ifelse count bullets in-radius 15 > 0

        [
          set kills kills + 1
          ask bullets in-radius 15 [die]
          die]

        [
          set shape "orcwalk_1"
          if count players > 0 [         ;if count lpayers > 0 used to prevent death bug
            set heading towards player 0
            every 10 / 100 [
              fd 6]
            set shape "orcwalk_2"]]
  ]]]
  [
    ask orcs [
      if going? = true [
        ifelse count bullets in-radius 15 > 0

        [
          set kills kills + 1
          ask bullets in-radius 15 [die]
          die]

        [
          set shape "orcwalk_1"
          if count players > 0 [          ;if count lpayers > 0 used to prevent death bug
            set heading towards player 0
            every 10 / 100 [
              fd 5]
            set shape "orcwalk_2"]]
  ]]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLAYER MOVEMENT

to walk-right
  if going? = true [
    ask player 0 [

      set heading 90
      set shape "rightwalk_1"
      every 10 / 100 [
        fd speed]
      set shape "rightwalk_2"
    ]
  ]
end

to walk-left
  if going? = true [
    ask player 0 [
      set heading 270
      set shape "leftwalk_1"
      every 10 / 100 [
        fd speed]
      set shape "leftwalk_2"
    ]
  ]
end

to walk-up
  if going? = true [
    ask player 0 [
      set heading 360
      set shape "upwalk_1"
      every 10 / 100
      [fd speed]
      set shape "upwalk_2"
    ]
  ]
end

to walk-down
  if going? = true [
    ask player 0 [
      set heading 180
      set shape "walkdown_1"
      every 10 / 100
      [fd speed]
      set shape "walkdown_2"
    ]
  ]
end

                             ;if wanted for future implementation
;to walk-upright
;  if going? = true
;  [ask player 0
;   [set heading 45
;      set shape "upwalk_1"
;        fd 3
;       set shape "upwalk_2"]
;  ]
;end

;to walk-downright
;  if going? = true
;  [ask player 0
;   [set heading 135
;      set shape "walkdown_1"
;        fd 3
;        set shape "walkdown_2"]
;  ]
;end

;to walk-upleft
;  if going? = true
;  [ask player 0
;    [set heading 315
;     set shape "upwalk_1"
;        fd 3
;        set shape "upwalk_2"]
;  ]
;end

;to walk-downleft
;  if going? = true
;  [ask player 0
;    [set heading 225
;      set shape "walkdown_1"
;        fd 3
;        set shape "walkdown_2"]
;  ]
;end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SHOOTING

to cycle ;needed for firerate
  every firerate
  [if fired? = true
    [set fired? false]]
end

to bullet-travel ;bullet speed and causes them to die if they step outside the map
  ask turtles [
    if breed = bullets [
      ifelse abs xcor = 128 or abs ycor = 128 [
        die]
      [fd 8
      ]
  ]]
end


to shoot-up
  ask player 0 [
    if octashot = 1 [
      octashotyay
    ]
    if shotgun = true [
      shotgun-upwards
    ]
    if octashot = 0 and shotgun = false [
      if fired? = false [
        set shape "upwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 360
          fd 3]
        set fired? true]]]
end

to shoot-down
  ask player 0 [
    if octashot = 1 [
      octashotyay
    ]
    if shotgun = true [
      shotgun-downwards
    ]
    if octashot = 0 and shotgun = false [
      if fired? = false [
        set shape "walkdown_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 180
          fd 3]
        set fired? true]]]
end

to shoot-left
  ask player 0 [
    if octashot = 1 [
      octashotyay
    ]
    if shotgun = true [
      shotgun-leftwards
    ]
    if octashot = 0 and shotgun = false [
      if fired? = false [
        set shape "leftwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 270
          fd 3]
        set fired? true]]]
end

to shoot-right
  ask player 0 [
    if octashot = 1 [
      octashotyay
    ]
    if shotgun = true [
      shotgun-rightwards
    ]
    if octashot = 0 and shotgun = false [
      if fired? = false [
        set shape "rightwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 90
          fd 3]
        set fired? true]]]
end

to shoot-upright
  ask player 0 [
    ifelse octashot = 1 [
      octashotyay
    ]
    [
      if fired? = false [
        set shape "rightwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 45
          fd 3]
        set fired? true]]]
end

to shoot-downright
  ask player 0 [
    ifelse octashot = 1 [
      octashotyay
    ]
    [
      if fired? = false [
        set shape "rightwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 135
          fd 3]
        set fired? true]]]
end

to shoot-upleft
  ask player 0 [
    ifelse octashot = 1 [
      octashotyay
    ]
    [
      if fired? = false [
        set shape "rightwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 315
          fd 3]
        set fired? true]]]
end

to shoot-downleft
  ask player 0 [
    ifelse octashot = 1 [
      octashotyay
    ]
    [
      if fired? = false [
        set shape "rightwalk_1"
        hatch-bullets 1 [
          set shape "bullet"
          set heading 225
          fd 3]
        set fired? true]]]
end

to octashotyay ;is called on instead of shooting in a specific direction if the octashot powerup is active - shoots in 8 directions simultaneously
  ask player 0 [
    if fired? = false [
      hatch-bullets 1 [
        set shape "bullet"
        set heading 360
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 180
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 270
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 90
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 45
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 135
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 315
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 225
        fd 3]
      set fired? true]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Shotgun shots - replace regular shots if shotgun powerup is active
to shotgun-upwards
  ask player 0 [
    if fired? = false [
      hatch-bullets 1 [
        set shape "bullet"
        set heading 360
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 20
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 340
        fd 3]
      set fired? true]]
end

to shotgun-leftwards
  ask player 0 [
    if fired? = false [
      hatch-bullets 1 [
        set shape "bullet"
        set heading 270
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 290
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 250
        fd 3]
      set fired? true]]
end

to shotgun-rightwards
  ask player 0 [
    if fired? = false [
      hatch-bullets 1 [
        set shape "bullet"
        set heading 90
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 110
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 70
        fd 3]
      set fired? true]]
end

to shotgun-downwards
ask player 0 [
    if fired? = false [
      hatch-bullets 1 [
        set shape "bullet"
        set heading 180
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 200
        fd 3]
      hatch-bullets 1 [
        set shape "bullet"
        set heading 160
        fd 3]
      set fired? true]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MONITORS

to-report timeuntilWIN
  report time-left
end

to-report killcounter
  report kills
end

to-report lives-left
  report lives
end

@#$#@#$#@
GRAPHICS-WINDOW
348
10
870
533
-1
-1
2.0
1
10
1
1
1
0
0
0
1
-128
128
-128
128
0
0
1
ticks
30.0

BUTTON
24
19
87
52
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
98
19
161
52
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
84
167
144
200
NIL
walk-down
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
147
168
202
201
NIL
walk-right
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
86
128
143
161
NIL
walk-up
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
24
167
79
200
NIL
walk-left
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
72
228
153
261
NIL
shoot-up
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
153
264
214
297
NIL
shoot-right
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

BUTTON
13
263
68
296
NIL
shoot-left
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
77
264
146
297
NIL
shoot-down
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

MONITOR
216
18
341
87
NIL
timeuntilWIN
17
1
17

MONITOR
271
171
340
216
NIL
killcounter
17
1
11

MONITOR
254
94
340
163
NIL
lives-left
17
1
17

TEXTBOX
24
348
328
668
You start with 2 lives!\n\nUse the wasd keys to move, and the ijkl keys to shoot\n\nEvery 10 kills you get a powerup\n-There are 6 powerups, try obtain them all!\n\nIf you survive for 60 seconds... you WIN!\n\nHardmode starts you with 1 life, and some of your attributes are lowered\n- it takes 14 kills to get a powerup\n- powerups are less powerful and last less
16
0.0
1

BUTTON
24
60
147
93
NIL
hardmode-setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This model is based on the minigame from Stardew Valley called Journey of the Praire King. Journey of the Praire King is a top down shooter, you start with 2 lives and try to survive for 1 minute while enemies come at you from 4 sides.

## HOW IT WORKS

The map is imported from an image using import-pcolors

There are numerous globals and player attributes. 

	-Fired? Is used for firerate
	-Kills and killlocker are used for powerup spawning
	-Firerate, fireratetime, speed, speedtime, octashot, octashotime, shotgun, 
		shotguntime - all used for powerup effects
	-Spawnpoint is used to choose patches where enemies will spawn

All the non-map agents in this model are different breeds (bullets, powerups, orcs, players…)

The shoot-up/down/right/left buttons will do different things depending on if either octashot or shotgun (powerups) is active.

Hardmode lowers some player attributes, speeds up the orcs, decreases the effects of some powerups, and makes them last for less time

## HOW TO USE IT

- Use the setup button to setup/reset the game. 
- Use the hardmode-setup button to re-start the game, except harder
- Press go to start the timer and the game. 
- W is walking up. D is walking to the right. S is walking down. A is walking to the left.
- I is shooting up. L is shooting to the right. K is shooting down. J is shooting to the left.

## THINGS TO NOTICE

There is a monitor that will signify the time remaining until you win

## NETLOGO FEATURES

We used turtle shapes editor so that the player looks like it turns around when changing heading, e.x shooting down, walking right, etc... 
(this was also done for each direction an orc can face, and for each powerup)

## CREDITS AND REFERENCES

https://stardewvalleywiki.com/Journey_of_the_Prairie_King

@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

bullet
false
12
Rectangle -7500403 true false 135 135 165 165
Rectangle -1 true false 150 135 165 150
Rectangle -6459832 true false 135 120 165 135
Rectangle -6459832 true false 165 135 180 165
Rectangle -6459832 true false 135 165 165 180
Rectangle -6459832 true false 120 135 135 165

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

coffee
false
1
Rectangle -1 true false 195 120 225 180
Rectangle -1 true false 60 75 180 225
Rectangle -6459832 true false 75 60 165 75
Rectangle -6459832 true false 165 75 180 90
Rectangle -6459832 true false 60 75 75 90
Rectangle -6459832 true false 45 90 60 210
Rectangle -6459832 true false 180 90 195 210
Rectangle -6459832 true false 60 210 75 225
Rectangle -6459832 true false 165 210 180 225
Rectangle -6459832 true false 75 225 165 240
Rectangle -6459832 true false 75 90 165 135
Rectangle -6459832 true false 120 150 150 165
Rectangle -6459832 true false 105 165 120 195
Rectangle -6459832 true false 120 195 150 210
Rectangle -6459832 true false 195 105 225 120
Rectangle -6459832 true false 225 120 240 180
Rectangle -6459832 true false 195 180 225 195
Rectangle -6459832 true false 195 135 210 165
Rectangle -7500403 true false 60 135 75 210
Rectangle -7500403 true false 75 150 105 210
Rectangle -7500403 true false 105 150 120 165
Rectangle -7500403 true false 75 195 120 225
Rectangle -7500403 true false 120 210 135 225
Rectangle -7500403 true false 195 165 210 180
Rectangle -7500403 true false 165 135 180 150

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

extralife
false
10
Rectangle -1184463 true false 105 180 195 210
Rectangle -2674135 true false 105 165 195 180
Rectangle -6459832 true false 105 60 150 75
Rectangle -6459832 true false 150 75 165 90
Rectangle -6459832 true false 165 60 195 75
Rectangle -6459832 true false 195 75 210 120
Rectangle -6459832 true false 210 105 225 120
Rectangle -6459832 true false 225 90 240 105
Rectangle -6459832 true false 240 105 255 135
Rectangle -6459832 true false 225 135 240 150
Rectangle -2674135 true false 165 75 180 90
Rectangle -2674135 true false 135 75 150 90
Rectangle -2674135 true false 105 75 120 90
Rectangle -2674135 true false 105 90 135 105
Rectangle -2674135 true false 105 105 195 120
Rectangle -1184463 true false 135 90 195 105
Rectangle -1184463 true false 180 75 195 90
Rectangle -1184463 true false 120 75 135 90
Rectangle -6459832 true false 90 75 105 120
Rectangle -6459832 true false 75 105 90 120
Rectangle -6459832 true false 60 90 75 105
Rectangle -6459832 true false 45 105 60 135
Rectangle -6459832 true false 60 135 75 150
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 210 150 225 195
Rectangle -2674135 true false 225 105 240 135
Rectangle -1184463 true false 210 120 225 135
Rectangle -2674135 true false 210 135 225 150
Rectangle -2674135 true false 195 120 210 135
Rectangle -1184463 true false 90 135 210 150
Rectangle -6459832 true false 195 150 210 210
Rectangle -2674135 true false 60 105 75 135
Rectangle -1184463 true false 75 120 90 135
Rectangle -2674135 true false 90 120 105 135
Rectangle -2674135 true false 75 135 90 150
Rectangle -6459832 true false 75 150 90 195
Rectangle -6459832 true false 90 150 105 210
Rectangle -6459832 true false 105 150 195 165
Rectangle -6459832 true false 120 150 135 195
Rectangle -6459832 true false 165 150 180 195
Rectangle -2674135 true false 105 195 120 210
Rectangle -2674135 true false 180 195 195 210
Rectangle -6459832 true false 105 210 195 225
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

idle
false
10
Rectangle -8630108 true false 105 225 135 255
Rectangle -8630108 true false 165 225 195 255
Rectangle -2674135 true false 90 195 210 225
Rectangle -2674135 true false 195 165 240 195
Rectangle -2674135 true false 60 165 105 195
Rectangle -1184463 true false 45 195 75 225
Rectangle -1184463 true false 105 150 195 180
Rectangle -2674135 true false 105 135 195 150
Rectangle -6459832 true false 105 30 150 45
Rectangle -6459832 true false 150 45 165 60
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 165 45 180 60
Rectangle -2674135 true false 135 45 150 60
Rectangle -2674135 true false 105 45 120 60
Rectangle -2674135 true false 105 60 135 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 135 60 195 75
Rectangle -1184463 true false 180 45 195 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 210 120 225 165
Rectangle -2674135 true false 225 75 240 105
Rectangle -1184463 true false 210 90 225 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 90 105 210 120
Rectangle -6459832 true false 195 120 210 180
Rectangle -2674135 true false 60 75 75 105
Rectangle -1184463 true false 75 90 90 105
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 90 120 105 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 120 120 135 165
Rectangle -6459832 true false 165 120 180 165
Rectangle -2674135 true false 105 165 120 180
Rectangle -2674135 true false 180 165 195 180
Rectangle -2674135 true false 135 180 165 195
Rectangle -6459832 true false 120 180 135 195
Rectangle -6459832 true false 165 180 180 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -6459832 true false 60 165 75 180
Rectangle -6459832 true false 45 180 60 195
Rectangle -6459832 true false 30 195 45 225
Rectangle -6459832 true false 45 225 75 240
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 90 210 105 255
Rectangle -2674135 true false 60 210 75 225
Rectangle -6459832 true false 225 165 240 180
Rectangle -6459832 true false 240 180 255 195
Rectangle -6459832 true false 255 165 270 180
Rectangle -6459832 true false 75 255 90 270
Rectangle -1184463 true false 90 255 120 270
Rectangle -8630108 true false 120 195 180 210
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 195 210 210 255
Rectangle -6459832 true false 255 195 270 270
Rectangle -7500403 true false 255 180 270 195
Rectangle -1184463 true false 225 195 255 210
Rectangle -1 true false 240 210 255 240
Rectangle -7500403 true false 240 240 255 255
Rectangle -6459832 true false 240 255 255 270
Rectangle -6459832 true false 225 225 240 255
Rectangle -6459832 true false 210 255 225 270
Rectangle -2674135 true false 225 210 240 225
Rectangle -2674135 true false 165 240 180 270
Rectangle -2674135 true false 120 240 135 270
Rectangle -6459832 true false 135 225 165 270
Rectangle -1184463 true false 180 255 210 270

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

leftwalk_1
false
10
Rectangle -6459832 true false 120 210 150 240
Rectangle -8630108 true false 210 75 225 90
Rectangle -8630108 true false 105 225 135 240
Rectangle -2674135 true false 60 165 105 195
Rectangle -1184463 true false 45 195 75 225
Rectangle -1184463 true false 105 150 180 180
Rectangle -2674135 true false 90 135 180 150
Rectangle -6459832 true false 150 30 195 45
Rectangle -6459832 true false 135 45 150 60
Rectangle -6459832 true false 105 30 135 45
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 60 90 75
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -2674135 true false 120 45 135 60
Rectangle -2674135 true false 150 45 165 60
Rectangle -2674135 true false 180 45 195 60
Rectangle -2674135 true false 165 60 195 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 105 60 165 75
Rectangle -1184463 true false 105 45 120 60
Rectangle -1184463 true false 165 45 180 60
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 60 225 75
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 225 75 255 105
Rectangle -6459832 true false 210 105 225 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 75 120 90 165
Rectangle -1184463 true false 60 75 90 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -2674135 true false 90 90 105 105
Rectangle -1184463 true false 90 105 195 120
Rectangle -6459832 true false 90 120 105 180
Rectangle -2674135 true false 225 75 240 90
Rectangle -2674135 true false 195 105 210 120
Rectangle -6459832 true false 210 120 225 165
Rectangle -6459832 true false 180 120 210 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 150 120 165 165
Rectangle -6459832 true false 120 120 135 165
Rectangle -2674135 true false 180 165 195 180
Rectangle -6459832 true false 120 180 180 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -6459832 true false 210 180 225 210
Rectangle -1184463 true false 165 240 195 255
Rectangle -6459832 true false 210 225 225 195
Rectangle -6459832 true false 210 195 210 225
Rectangle -2674135 true false 195 180 210 210
Rectangle -6459832 true false 195 210 210 270
Rectangle -2674135 true false 60 210 75 225
Rectangle -6459832 true false 60 165 75 180
Rectangle -6459832 true false 45 180 60 195
Rectangle -6459832 true false 30 195 45 225
Rectangle -6459832 true false 105 240 135 255
Rectangle -1 true false 135 195 180 210
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 90 210 105 240
Rectangle -6459832 true false 105 195 120 210
Rectangle -6459832 true false 45 225 75 240
Rectangle -2674135 true false 75 75 90 90
Rectangle -2674135 true false 165 255 195 270
Rectangle -2674135 true false 195 90 225 105
Rectangle -7500403 true false 120 195 135 210
Rectangle -1184463 true false 180 195 195 210
Rectangle -2674135 true false 90 195 105 210
Rectangle -2674135 true false 105 210 120 225
Rectangle -2674135 true false 150 210 165 225
Rectangle -1184463 true false 165 210 180 225
Rectangle -2674135 true false 180 210 195 225
Rectangle -6459832 true false 150 225 165 270
Rectangle -7500403 true false 165 225 180 240
Rectangle -8630108 true false 180 225 195 240

leftwalk_2
false
10
Rectangle -8630108 true false 210 75 225 90
Rectangle -8630108 true false 105 225 135 240
Rectangle -2674135 true false 60 165 105 195
Rectangle -1184463 true false 45 195 75 225
Rectangle -1184463 true false 105 150 180 180
Rectangle -2674135 true false 90 135 180 150
Rectangle -6459832 true false 150 30 195 45
Rectangle -6459832 true false 135 45 150 60
Rectangle -6459832 true false 105 30 135 45
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 60 90 75
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -2674135 true false 120 45 135 60
Rectangle -2674135 true false 150 45 165 60
Rectangle -2674135 true false 180 45 195 60
Rectangle -2674135 true false 165 60 195 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 105 60 165 75
Rectangle -1184463 true false 105 45 120 60
Rectangle -1184463 true false 165 45 180 60
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 60 225 75
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 225 75 255 105
Rectangle -6459832 true false 210 105 225 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 75 120 90 165
Rectangle -1184463 true false 60 75 90 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -2674135 true false 90 90 105 105
Rectangle -1184463 true false 90 105 195 120
Rectangle -6459832 true false 90 120 105 180
Rectangle -2674135 true false 225 75 240 90
Rectangle -2674135 true false 195 105 210 120
Rectangle -6459832 true false 210 120 225 165
Rectangle -6459832 true false 180 120 210 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 150 120 165 165
Rectangle -6459832 true false 120 120 135 165
Rectangle -2674135 true false 180 165 195 180
Rectangle -6459832 true false 120 180 180 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -6459832 true false 210 180 225 210
Rectangle -6459832 true false 165 240 195 255
Rectangle -6459832 true false 210 225 225 195
Rectangle -6459832 true false 210 195 210 225
Rectangle -2674135 true false 195 180 210 210
Rectangle -6459832 true false 195 210 210 240
Rectangle -2674135 true false 60 210 75 225
Rectangle -6459832 true false 60 165 75 180
Rectangle -6459832 true false 45 180 60 195
Rectangle -6459832 true false 30 195 45 225
Rectangle -1184463 true false 105 240 135 255
Rectangle -1 true false 135 195 180 210
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 90 210 105 270
Rectangle -6459832 true false 105 195 120 210
Rectangle -6459832 true false 45 225 75 240
Rectangle -2674135 true false 75 75 90 90
Rectangle -2674135 true false 105 255 135 270
Rectangle -2674135 true false 195 90 225 105
Rectangle -6459832 true false 135 225 150 270
Rectangle -7500403 true false 120 195 135 210
Rectangle -1184463 true false 180 195 195 210
Rectangle -2674135 true false 90 195 105 210
Rectangle -2674135 true false 105 210 120 225
Rectangle -6459832 true false 120 210 150 225
Rectangle -2674135 true false 150 210 165 225
Rectangle -1184463 true false 165 210 180 225
Rectangle -2674135 true false 180 210 195 225
Rectangle -6459832 true false 150 225 165 240
Rectangle -7500403 true false 165 225 180 240
Rectangle -8630108 true false 180 225 195 240

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

machinegun
false
0
Rectangle -6459832 true false 120 15 210 30
Rectangle -6459832 true false 225 30 240 60
Rectangle -6459832 true false 105 30 120 45
Rectangle -6459832 true false 120 30 135 60
Rectangle -6459832 true false 120 60 210 75
Rectangle -6459832 true false 105 75 150 90
Rectangle -6459832 true false 135 90 150 105
Rectangle -6459832 true false 135 105 225 120
Rectangle -6459832 true false 90 45 105 75
Rectangle -6459832 true false 75 60 90 90
Rectangle -6459832 true false 90 90 105 105
Rectangle -6459832 true false 60 90 75 120
Rectangle -6459832 true false 75 105 135 120
Rectangle -6459832 true false 120 120 135 135
Rectangle -6459832 true false 135 120 150 150
Rectangle -6459832 true false 135 150 225 165
Rectangle -6459832 true false 135 165 150 195
Rectangle -6459832 true false 135 195 225 210
Rectangle -6459832 true false 135 210 150 240
Rectangle -6459832 true false 135 240 225 255
Rectangle -6459832 true false 240 210 255 240
Rectangle -6459832 true false 240 165 255 195
Rectangle -6459832 true false 240 120 255 150
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 120 150 120 165
Rectangle -6459832 true false 120 150 135 165
Rectangle -6459832 true false 75 120 90 135
Rectangle -6459832 true false 60 135 120 150
Rectangle -6459832 true false 45 120 60 180
Rectangle -6459832 true false 60 165 120 180
Rectangle -6459832 true false 75 150 90 165
Rectangle -6459832 true false 30 180 105 195
Rectangle -6459832 true false 90 195 105 210
Rectangle -6459832 true false 60 195 75 210
Rectangle -6459832 true false 15 195 30 210
Rectangle -6459832 true false 30 210 90 225
Rectangle -2674135 true false 105 45 120 75
Rectangle -2674135 true false 90 75 105 90
Rectangle -2674135 true false 105 90 135 105
Rectangle -2674135 true false 75 90 90 105
Rectangle -2674135 true false 60 120 75 135
Rectangle -2674135 true false 90 120 120 135
Rectangle -2674135 true false 90 150 120 165
Rectangle -2674135 true false 60 150 75 165
Rectangle -2674135 true false 75 195 90 210
Rectangle -2674135 true false 30 195 60 210
Rectangle -2674135 true false 135 30 150 45
Rectangle -2674135 true false 135 45 225 60
Rectangle -2674135 true false 210 30 225 45
Rectangle -2674135 true false 150 75 240 105
Rectangle -2674135 true false 150 120 240 150
Rectangle -2674135 true false 150 165 240 195
Rectangle -2674135 true false 150 210 240 240
Rectangle -1184463 true false 150 30 210 45
Rectangle -1184463 true false 165 75 225 90
Rectangle -1184463 true false 165 120 225 135
Rectangle -1184463 true false 165 165 225 180
Rectangle -1184463 true false 165 210 225 225

nuke
false
0
Rectangle -1184463 true false 195 90 225 135
Rectangle -1184463 true false 165 60 210 105
Rectangle -1184463 true false 60 90 90 135
Rectangle -1184463 true false 75 60 120 105
Rectangle -1184463 true false 105 30 180 75
Rectangle -1 true false 90 120 195 195
Rectangle -1 true false 105 90 180 135
Rectangle -2674135 true false 105 195 180 240
Rectangle -2674135 true false 210 210 240 240
Rectangle -2674135 true false 45 210 75 240
Rectangle -6459832 true false 120 15 165 30
Rectangle -6459832 true false 90 30 120 45
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 60
Rectangle -6459832 true false 210 60 225 90
Rectangle -6459832 true false 75 45 90 60
Rectangle -6459832 true false 60 60 75 90
Rectangle -6459832 true false 45 90 60 210
Rectangle -6459832 true false 225 90 240 210
Rectangle -6459832 true false 240 210 255 255
Rectangle -6459832 true false 30 210 45 255
Rectangle -6459832 true false 45 240 75 255
Rectangle -6459832 true false 210 240 240 255
Rectangle -6459832 true false 210 210 225 225
Rectangle -6459832 true false 180 225 210 240
Rectangle -6459832 true false 60 210 75 225
Rectangle -6459832 true false 75 225 105 240
Rectangle -6459832 true false 105 240 180 255
Rectangle -6459832 true false 120 75 165 90
Rectangle -6459832 true false 105 90 120 105
Rectangle -6459832 true false 165 90 180 105
Rectangle -6459832 true false 180 105 195 120
Rectangle -6459832 true false 90 105 105 120
Rectangle -6459832 true false 195 120 210 165
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 180 165 195 180
Rectangle -6459832 true false 90 165 105 180
Rectangle -6459832 true false 105 180 120 210
Rectangle -6459832 true false 120 195 135 210
Rectangle -6459832 true false 135 180 150 195
Rectangle -6459832 true false 150 195 180 210
Rectangle -6459832 true false 165 180 180 195
Rectangle -2674135 true false 90 45 105 60
Rectangle -2674135 true false 75 60 90 75
Rectangle -2674135 true false 180 45 195 60
Rectangle -2674135 true false 195 60 210 75
Rectangle -2674135 true false 210 90 225 105
Rectangle -2674135 true false 60 90 75 105
Rectangle -2674135 true false 60 135 75 150
Rectangle -2674135 true false 210 135 225 150
Rectangle -2674135 true false 60 165 90 180
Rectangle -2674135 true false 75 180 105 225
Rectangle -2674135 true false 60 195 75 210
Rectangle -2674135 true false 195 165 225 180
Rectangle -2674135 true false 180 180 210 225
Rectangle -2674135 true false 210 195 225 210
Rectangle -6459832 true false 165 120 180 135
Rectangle -6459832 true false 150 135 165 150
Rectangle -6459832 true false 105 120 120 135
Rectangle -6459832 true false 120 135 135 150
Rectangle -2674135 true false 105 135 120 150
Rectangle -2674135 true false 165 135 180 150
Rectangle -1184463 true false 60 180 75 195
Rectangle -1184463 true false 60 150 75 165
Rectangle -1184463 true false 210 150 225 165
Rectangle -1184463 true false 210 180 225 195

orcwalk_1
false
2
Rectangle -2674135 true false 60 150 105 180
Rectangle -2674135 true false 105 180 195 210
Rectangle -2674135 true false 195 165 255 195
Rectangle -1 true false 120 30 195 75
Rectangle -13840069 true false 105 135 210 165
Rectangle -13840069 true false 225 195 255 225
Rectangle -13840069 true false 60 180 90 210
Rectangle -6459832 true false 135 15 180 30
Rectangle -6459832 true false 180 30 210 45
Rectangle -6459832 true false 105 30 135 45
Rectangle -6459832 true false 90 45 105 60
Rectangle -6459832 true false 75 60 90 150
Rectangle -6459832 true false 210 45 225 60
Rectangle -6459832 true false 225 60 240 150
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 210 105 225 120
Rectangle -6459832 true false 90 75 105 90
Rectangle -6459832 true false 90 105 105 120
Rectangle -6459832 true false 105 90 210 105
Rectangle -6459832 true false 165 120 210 135
Rectangle -6459832 true false 105 120 150 135
Rectangle -6459832 true false 240 150 255 165
Rectangle -6459832 true false 210 150 225 165
Rectangle -6459832 true false 180 165 210 180
Rectangle -6459832 true false 90 150 105 165
Rectangle -6459832 true false 105 165 135 180
Rectangle -6459832 true false 135 180 180 195
Rectangle -6459832 true false 60 150 75 165
Rectangle -6459832 true false 45 165 60 210
Rectangle -6459832 true false 60 210 90 225
Rectangle -6459832 true false 75 225 90 255
Rectangle -6459832 true false 90 180 105 210
Rectangle -6459832 true false 255 165 270 225
Rectangle -6459832 true false 225 225 255 240
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 225 180 240 195
Rectangle -6459832 true false 165 225 210 240
Rectangle -6459832 true false 150 210 165 225
Rectangle -6459832 true false 135 225 150 255
Rectangle -10899396 true false 90 120 105 150
Rectangle -10899396 true false 105 150 120 165
Rectangle -10899396 true false 150 120 165 135
Rectangle -10899396 true false 135 135 150 150
Rectangle -10899396 true false 165 135 180 150
Rectangle -10899396 true false 210 120 225 150
Rectangle -10899396 true false 195 150 210 165
Rectangle -10899396 true false 135 165 180 180
Rectangle -10899396 true false 75 195 90 210
Rectangle -10899396 true false 90 240 105 255
Rectangle -10899396 true false 120 240 135 255
Rectangle -10899396 true false 225 210 240 225
Rectangle -2674135 true false 120 135 135 150
Rectangle -2674135 true false 180 135 195 150
Rectangle -1 true false 120 105 195 120
Rectangle -7500403 true false 105 105 120 120
Rectangle -7500403 true false 195 105 210 120
Rectangle -7500403 true false 210 90 225 105
Rectangle -7500403 true false 90 90 105 105
Rectangle -7500403 true false 105 45 120 60
Rectangle -7500403 true false 90 60 135 75
Rectangle -7500403 true false 105 75 210 90
Rectangle -7500403 true false 180 60 225 75
Rectangle -7500403 true false 195 45 210 60
Rectangle -7500403 true false 135 30 150 45
Rectangle -2674135 true false 225 150 240 165
Rectangle -8630108 true false 180 180 195 195
Rectangle -8630108 true false 195 195 210 210
Rectangle -8630108 true false 165 210 180 225
Rectangle -8630108 true false 135 210 150 225
Rectangle -8630108 true false 120 180 135 195
Rectangle -8630108 true false 105 195 120 210
Rectangle -7500403 true false 90 210 105 240
Rectangle -7500403 true false 105 210 135 225
Rectangle -7500403 true false 180 210 210 225
Rectangle -13840069 true false 105 240 120 255
Rectangle -1 true false 105 225 135 240

orcwalk_2
false
2
Rectangle -2674135 true false 195 150 240 180
Rectangle -2674135 true false 105 180 195 210
Rectangle -2674135 true false 45 165 105 195
Rectangle -1 true false 105 30 180 75
Rectangle -13840069 true false 90 135 195 165
Rectangle -13840069 true false 45 195 75 225
Rectangle -13840069 true false 210 180 240 210
Rectangle -6459832 true false 120 15 165 30
Rectangle -6459832 true false 90 30 120 45
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 60
Rectangle -6459832 true false 210 60 225 150
Rectangle -6459832 true false 75 45 90 60
Rectangle -6459832 true false 60 60 75 150
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 75 105 90 120
Rectangle -6459832 true false 195 75 210 90
Rectangle -6459832 true false 195 105 210 120
Rectangle -6459832 true false 90 90 195 105
Rectangle -6459832 true false 90 120 135 135
Rectangle -6459832 true false 150 120 195 135
Rectangle -6459832 true false 45 150 60 165
Rectangle -6459832 true false 75 150 90 165
Rectangle -6459832 true false 90 165 120 180
Rectangle -6459832 true false 195 150 210 165
Rectangle -6459832 true false 165 165 195 180
Rectangle -6459832 true false 120 180 165 195
Rectangle -6459832 true false 225 150 240 165
Rectangle -6459832 true false 240 165 255 210
Rectangle -6459832 true false 210 210 240 225
Rectangle -6459832 true false 210 225 225 255
Rectangle -6459832 true false 195 180 210 210
Rectangle -6459832 true false 30 165 45 225
Rectangle -6459832 true false 45 225 75 240
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 60 180 75 195
Rectangle -6459832 true false 90 225 135 240
Rectangle -6459832 true false 135 210 150 225
Rectangle -6459832 true false 150 225 165 255
Rectangle -10899396 true false 195 120 210 150
Rectangle -10899396 true false 180 150 195 165
Rectangle -10899396 true false 135 120 150 135
Rectangle -10899396 true false 150 135 165 150
Rectangle -10899396 true false 120 135 135 150
Rectangle -10899396 true false 75 120 90 150
Rectangle -10899396 true false 90 150 105 165
Rectangle -10899396 true false 120 165 165 180
Rectangle -10899396 true false 210 195 225 210
Rectangle -10899396 true false 195 240 210 255
Rectangle -10899396 true false 165 240 180 255
Rectangle -10899396 true false 60 210 75 225
Rectangle -2674135 true false 165 135 180 150
Rectangle -2674135 true false 105 135 120 150
Rectangle -1 true false 105 105 180 120
Rectangle -7500403 true false 180 105 195 120
Rectangle -7500403 true false 90 105 105 120
Rectangle -7500403 true false 75 90 90 105
Rectangle -7500403 true false 195 90 210 105
Rectangle -7500403 true false 180 45 195 60
Rectangle -7500403 true false 165 60 210 75
Rectangle -7500403 true false 90 75 195 90
Rectangle -7500403 true false 75 60 120 75
Rectangle -7500403 true false 90 45 105 60
Rectangle -7500403 true false 150 30 165 45
Rectangle -2674135 true false 60 150 75 165
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 90 195 105 210
Rectangle -8630108 true false 120 210 135 225
Rectangle -8630108 true false 150 210 165 225
Rectangle -8630108 true false 165 180 180 195
Rectangle -8630108 true false 180 195 195 210
Rectangle -7500403 true false 195 210 210 240
Rectangle -7500403 true false 165 210 195 225
Rectangle -7500403 true false 90 210 120 225
Rectangle -13840069 true false 180 240 195 255
Rectangle -1 true false 165 225 195 240

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rightwalk_1
false
10
Rectangle -8630108 true false 75 75 90 90
Rectangle -8630108 true false 165 225 195 240
Rectangle -2674135 true false 195 165 240 195
Rectangle -1184463 true false 225 195 255 225
Rectangle -1184463 true false 120 150 195 180
Rectangle -2674135 true false 120 135 210 150
Rectangle -6459832 true false 105 30 150 45
Rectangle -6459832 true false 150 45 165 60
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 60 225 75
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 165 45 180 60
Rectangle -2674135 true false 135 45 150 60
Rectangle -2674135 true false 105 45 120 60
Rectangle -2674135 true false 105 60 135 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 135 60 195 75
Rectangle -1184463 true false 180 45 195 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 60 90 75
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 75 105
Rectangle -6459832 true false 75 105 90 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 210 120 225 165
Rectangle -1184463 true false 210 75 240 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 105 105 210 120
Rectangle -6459832 true false 195 120 210 180
Rectangle -2674135 true false 60 75 75 90
Rectangle -2674135 true false 90 105 105 120
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 90 120 120 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 135 120 150 165
Rectangle -6459832 true false 165 120 180 165
Rectangle -2674135 true false 105 165 120 180
Rectangle -6459832 true false 120 180 180 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -6459832 true false 75 180 90 210
Rectangle -6459832 true false 105 240 135 255
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -2674135 true false 90 180 105 210
Rectangle -6459832 true false 90 210 105 240
Rectangle -2674135 true false 225 210 240 225
Rectangle -6459832 true false 225 165 240 180
Rectangle -6459832 true false 240 180 255 195
Rectangle -6459832 true false 255 195 270 225
Rectangle -1184463 true false 165 240 195 255
Rectangle -1 true false 120 195 165 210
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 195 210 210 270
Rectangle -6459832 true false 180 195 195 210
Rectangle -6459832 true false 225 225 255 240
Rectangle -2674135 true false 210 75 225 90
Rectangle -2674135 true false 165 255 195 270
Rectangle -2674135 true false 75 90 105 105
Rectangle -6459832 true false 150 225 165 270
Rectangle -7500403 true false 165 195 180 210
Rectangle -1184463 true false 105 195 120 210
Rectangle -2674135 true false 195 195 210 210
Rectangle -2674135 true false 180 210 195 225
Rectangle -6459832 true false 150 210 180 225
Rectangle -2674135 true false 135 210 150 225
Rectangle -1184463 true false 120 210 135 225
Rectangle -2674135 true false 105 210 120 225
Rectangle -6459832 true false 135 225 150 240
Rectangle -7500403 true false 120 225 135 240
Rectangle -8630108 true false 105 225 120 240

rightwalk_2
false
10
Rectangle -6459832 true false 150 210 180 240
Rectangle -8630108 true false 75 75 90 90
Rectangle -8630108 true false 165 225 195 240
Rectangle -2674135 true false 195 165 240 195
Rectangle -1184463 true false 225 195 255 225
Rectangle -1184463 true false 120 150 195 180
Rectangle -2674135 true false 120 135 210 150
Rectangle -6459832 true false 105 30 150 45
Rectangle -6459832 true false 150 45 165 60
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 60 225 75
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 165 45 180 60
Rectangle -2674135 true false 135 45 150 60
Rectangle -2674135 true false 105 45 120 60
Rectangle -2674135 true false 105 60 135 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 135 60 195 75
Rectangle -1184463 true false 180 45 195 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 60 90 75
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 75 105
Rectangle -6459832 true false 75 105 90 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 210 120 225 165
Rectangle -1184463 true false 210 75 240 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 105 105 210 120
Rectangle -6459832 true false 195 120 210 180
Rectangle -2674135 true false 60 75 75 90
Rectangle -2674135 true false 90 105 105 120
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 90 120 120 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 135 120 150 165
Rectangle -6459832 true false 165 120 180 165
Rectangle -2674135 true false 105 165 120 180
Rectangle -6459832 true false 120 180 180 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -6459832 true false 75 180 90 210
Rectangle -1184463 true false 105 240 135 255
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -2674135 true false 90 180 105 210
Rectangle -6459832 true false 90 210 105 270
Rectangle -2674135 true false 225 210 240 225
Rectangle -6459832 true false 225 165 240 180
Rectangle -6459832 true false 240 180 255 195
Rectangle -6459832 true false 255 195 270 225
Rectangle -6459832 true false 165 240 195 255
Rectangle -1 true false 120 195 165 210
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 195 210 210 240
Rectangle -6459832 true false 180 195 195 210
Rectangle -6459832 true false 225 225 255 240
Rectangle -2674135 true false 210 75 225 90
Rectangle -2674135 true false 105 255 135 270
Rectangle -2674135 true false 75 90 105 105
Rectangle -7500403 true false 165 195 180 210
Rectangle -1184463 true false 105 195 120 210
Rectangle -2674135 true false 195 195 210 210
Rectangle -2674135 true false 180 210 195 225
Rectangle -2674135 true false 135 210 150 225
Rectangle -1184463 true false 120 210 135 225
Rectangle -2674135 true false 105 210 120 225
Rectangle -6459832 true false 135 225 150 270
Rectangle -7500403 true false 120 225 135 240
Rectangle -8630108 true false 105 225 120 240

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

shotgun
false
6
Rectangle -7500403 true false 210 105 240 135
Rectangle -7500403 true false 60 105 90 135
Rectangle -7500403 true false 135 45 165 75
Rectangle -6459832 true false 135 30 165 45
Rectangle -6459832 true false 165 45 180 75
Rectangle -6459832 true false 120 45 135 75
Rectangle -6459832 true false 135 75 165 90
Rectangle -6459832 true false 210 90 240 105
Rectangle -6459832 true false 240 105 255 135
Rectangle -6459832 true false 210 135 240 150
Rectangle -6459832 true false 195 105 210 135
Rectangle -6459832 true false 90 105 105 135
Rectangle -6459832 true false 60 90 90 105
Rectangle -6459832 true false 45 105 60 135
Rectangle -6459832 true false 60 135 90 150
Rectangle -6459832 true false 75 180 270 195
Rectangle -6459832 true false 30 195 75 210
Rectangle -6459832 true false 30 210 45 255
Rectangle -6459832 true false 45 240 90 255
Rectangle -6459832 true false 75 225 225 240
Rectangle -6459832 true false 225 210 255 225
Rectangle -6459832 true false 255 195 270 210
Rectangle -6459832 true false 90 210 105 225
Rectangle -1 true false 120 195 240 210
Rectangle -1 true false 150 45 165 60
Rectangle -1 true false 75 105 90 120
Rectangle -1 true false 225 105 240 120
Rectangle -7500403 true false 240 195 255 210
Rectangle -7500403 true false 105 195 120 210
Rectangle -2674135 true false 135 210 210 225
Rectangle -2674135 true false 90 195 105 210
Rectangle -2674135 true false 75 210 90 225
Rectangle -2674135 true false 45 225 75 240
Rectangle -1184463 true false 75 195 90 210
Rectangle -1184463 true false 45 210 75 225
Rectangle -8630108 true false 105 210 135 225
Rectangle -8630108 true false 210 210 225 225

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

upwalk_1
false
10
Rectangle -2674135 true false 210 165 240 195
Rectangle -1184463 true false 225 195 255 225
Rectangle -8630108 true false 105 225 135 240
Rectangle -8630108 true false 165 225 195 240
Rectangle -2674135 true false 90 165 210 225
Rectangle -1184463 true false 225 165 240 180
Rectangle -6459832 true false 150 30 195 45
Rectangle -6459832 true false 135 45 150 60
Rectangle -6459832 true false 105 30 135 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 180 45 195 60
Rectangle -2674135 true false 150 45 165 60
Rectangle -2674135 true false 105 60 120 75
Rectangle -2674135 true false 165 60 195 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 120 60 165 75
Rectangle -1184463 true false 165 45 180 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -2674135 true false 225 75 240 105
Rectangle -1184463 true false 210 90 225 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 90 105 210 120
Rectangle -2674135 true false 60 75 75 105
Rectangle -1184463 true false 75 90 90 105
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -6459832 true false 75 120 225 135
Rectangle -6459832 true false 75 135 225 150
Rectangle -6459832 true false 45 165 60 195
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 60 195 90 210
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -6459832 true false 90 210 105 270
Rectangle -6459832 true false 60 150 240 165
Rectangle -6459832 true false 90 165 210 180
Rectangle -6459832 true false 135 240 150 270
Rectangle -1184463 true false 105 240 135 255
Rectangle -6459832 true false 225 225 255 240
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 240 165 255 195
Rectangle -6459832 true false 255 195 270 225
Rectangle -2674135 true false 225 210 240 225
Rectangle -2674135 true false 60 165 90 195
Rectangle -2674135 true false 105 255 135 270
Rectangle -6459832 true false 135 225 165 240
Rectangle -6459832 true false 165 240 195 255
Rectangle -1184463 true false 105 45 120 60
Rectangle -2674135 true false 120 45 135 60
Rectangle -1184463 true false 60 165 75 180
Rectangle -6459832 true false 195 210 210 240
Rectangle -6459832 true false 105 180 120 195
Rectangle -6459832 true false 135 180 165 195
Rectangle -6459832 true false 150 195 165 210
Rectangle -6459832 true false 180 180 195 195

upwalk_2
false
10
Rectangle -2674135 true false 210 165 240 195
Rectangle -1184463 true false 225 195 255 225
Rectangle -8630108 true false 105 225 135 240
Rectangle -8630108 true false 165 225 195 240
Rectangle -2674135 true false 90 165 210 225
Rectangle -1184463 true false 225 165 240 180
Rectangle -6459832 true false 150 30 195 45
Rectangle -6459832 true false 135 45 150 60
Rectangle -6459832 true false 105 30 135 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 180 45 195 60
Rectangle -2674135 true false 150 45 165 60
Rectangle -2674135 true false 105 60 120 75
Rectangle -2674135 true false 165 60 195 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 120 60 165 75
Rectangle -1184463 true false 165 45 180 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -2674135 true false 225 75 240 105
Rectangle -1184463 true false 210 90 225 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 90 105 210 120
Rectangle -2674135 true false 60 75 75 105
Rectangle -1184463 true false 75 90 90 105
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -6459832 true false 75 120 225 135
Rectangle -6459832 true false 75 135 225 150
Rectangle -6459832 true false 45 165 60 195
Rectangle -6459832 true false 75 195 90 225
Rectangle -6459832 true false 60 195 90 210
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -6459832 true false 90 210 105 240
Rectangle -6459832 true false 60 150 240 165
Rectangle -6459832 true false 90 165 210 180
Rectangle -6459832 true false 105 240 135 255
Rectangle -1184463 true false 165 240 195 255
Rectangle -6459832 true false 225 225 255 240
Rectangle -6459832 true false 210 195 225 225
Rectangle -6459832 true false 240 165 255 195
Rectangle -6459832 true false 255 195 270 225
Rectangle -2674135 true false 225 210 240 225
Rectangle -2674135 true false 60 165 90 195
Rectangle -2674135 true false 165 255 195 270
Rectangle -6459832 true false 135 225 165 240
Rectangle -6459832 true false 150 240 165 270
Rectangle -1184463 true false 105 45 120 60
Rectangle -2674135 true false 120 45 135 60
Rectangle -1184463 true false 60 165 75 180
Rectangle -6459832 true false 195 210 210 270
Rectangle -6459832 true false 105 180 120 195
Rectangle -6459832 true false 135 180 165 195
Rectangle -6459832 true false 150 195 165 210
Rectangle -6459832 true false 180 180 195 195

walkdown_1
false
10
Rectangle -8630108 true false 105 225 135 240
Rectangle -1184463 true false 180 240 195 255
Rectangle -2674135 true false 90 195 150 225
Rectangle -2674135 true false 60 165 105 195
Rectangle -1184463 true false 45 195 75 225
Rectangle -1184463 true false 105 150 195 180
Rectangle -2674135 true false 105 135 195 150
Rectangle -6459832 true false 105 30 150 45
Rectangle -6459832 true false 150 45 165 60
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 165 45 180 60
Rectangle -2674135 true false 135 45 150 60
Rectangle -2674135 true false 105 45 120 60
Rectangle -2674135 true false 105 60 135 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 135 60 195 75
Rectangle -1184463 true false 180 45 195 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 210 120 225 165
Rectangle -2674135 true false 225 75 240 105
Rectangle -1184463 true false 210 90 225 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 90 105 210 120
Rectangle -6459832 true false 195 120 210 180
Rectangle -2674135 true false 60 75 75 105
Rectangle -1184463 true false 75 90 90 105
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 90 120 105 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 120 120 135 165
Rectangle -6459832 true false 165 120 180 165
Rectangle -2674135 true false 105 165 120 180
Rectangle -2674135 true false 180 165 195 180
Rectangle -2674135 true false 135 180 165 195
Rectangle -6459832 true false 120 180 135 195
Rectangle -6459832 true false 165 180 180 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -6459832 true false 60 165 75 180
Rectangle -6459832 true false 45 180 60 195
Rectangle -6459832 true false 30 195 45 225
Rectangle -6459832 true false 45 225 75 240
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -6459832 true false 75 195 90 225
Rectangle -2674135 true false 60 210 75 225
Rectangle -6459832 true false 210 180 225 210
Rectangle -6459832 true false 90 210 105 240
Rectangle -8630108 true false 120 195 150 210
Rectangle -6459832 true false 195 210 210 270
Rectangle -6459832 true false 150 210 165 270
Rectangle -7500403 true false 150 195 165 210
Rectangle -1 true false 165 195 180 225
Rectangle -7500403 true false 165 225 180 240
Rectangle -6459832 true false 165 240 180 255
Rectangle -6459832 true false 180 210 195 240
Rectangle -6459832 true false 135 225 150 240
Rectangle -2674135 true false 195 180 210 210
Rectangle -2674135 true false 165 255 195 270
Rectangle -6459832 true false 105 240 135 255
Rectangle -1184463 true false 180 195 195 210

walkdown_2
false
10
Rectangle -8630108 true false 105 225 135 240
Rectangle -1184463 true false 105 240 135 255
Rectangle -2674135 true false 90 195 150 225
Rectangle -2674135 true false 60 165 105 195
Rectangle -1184463 true false 45 195 75 225
Rectangle -1184463 true false 105 150 195 180
Rectangle -2674135 true false 105 135 195 150
Rectangle -6459832 true false 105 30 150 45
Rectangle -6459832 true false 150 45 165 60
Rectangle -6459832 true false 165 30 195 45
Rectangle -6459832 true false 195 45 210 90
Rectangle -6459832 true false 210 75 225 90
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 105
Rectangle -6459832 true false 225 105 240 120
Rectangle -2674135 true false 165 45 180 60
Rectangle -2674135 true false 135 45 150 60
Rectangle -2674135 true false 105 45 120 60
Rectangle -2674135 true false 105 60 135 75
Rectangle -2674135 true false 105 75 195 90
Rectangle -1184463 true false 135 60 195 75
Rectangle -1184463 true false 180 45 195 60
Rectangle -1184463 true false 120 45 135 60
Rectangle -6459832 true false 90 45 105 90
Rectangle -6459832 true false 75 75 90 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 45 75 60 105
Rectangle -6459832 true false 60 105 75 120
Rectangle -6459832 true false 105 90 195 105
Rectangle -6459832 true false 210 120 225 165
Rectangle -2674135 true false 225 75 240 105
Rectangle -1184463 true false 210 90 225 105
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 90 210 105
Rectangle -1184463 true false 90 105 210 120
Rectangle -6459832 true false 195 120 210 180
Rectangle -2674135 true false 60 75 75 105
Rectangle -1184463 true false 75 90 90 105
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 75 105 90 120
Rectangle -6459832 true false 75 120 90 165
Rectangle -6459832 true false 90 120 105 180
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 120 120 135 165
Rectangle -6459832 true false 165 120 180 165
Rectangle -2674135 true false 105 165 120 180
Rectangle -2674135 true false 180 165 195 180
Rectangle -2674135 true false 135 180 165 195
Rectangle -6459832 true false 120 180 135 195
Rectangle -6459832 true false 165 180 180 195
Rectangle -8630108 true false 105 180 120 195
Rectangle -8630108 true false 180 180 195 195
Rectangle -6459832 true false 60 165 75 180
Rectangle -6459832 true false 45 180 60 195
Rectangle -6459832 true false 30 195 45 225
Rectangle -6459832 true false 45 225 75 240
Rectangle -6459832 true false 75 225 90 195
Rectangle -6459832 true false 90 195 90 225
Rectangle -6459832 true false 75 195 90 225
Rectangle -2674135 true false 60 210 75 225
Rectangle -6459832 true false 210 180 225 210
Rectangle -6459832 true false 90 210 105 270
Rectangle -8630108 true false 120 195 150 210
Rectangle -6459832 true false 150 210 165 240
Rectangle -7500403 true false 150 195 165 210
Rectangle -1 true false 165 195 180 225
Rectangle -7500403 true false 165 225 180 240
Rectangle -6459832 true false 165 240 195 255
Rectangle -6459832 true false 180 210 195 240
Rectangle -6459832 true false 135 225 150 270
Rectangle -2674135 true false 195 180 210 210
Rectangle -2674135 true false 105 255 135 270
Rectangle -1184463 true false 180 195 195 210
Rectangle -6459832 true false 195 210 210 240

wheel
false
0
Rectangle -2674135 true false 135 135 165 165
Rectangle -1184463 true false 150 135 165 150
Rectangle -6459832 true false 135 120 165 135
Rectangle -6459832 true false 165 135 180 165
Rectangle -6459832 true false 120 135 135 165
Rectangle -6459832 true false 135 165 165 180
Rectangle -8630108 true false 120 120 135 135
Rectangle -8630108 true false 165 120 180 135
Rectangle -8630108 true false 120 165 135 180
Rectangle -8630108 true false 165 165 180 180
Rectangle -8630108 true false 150 105 165 120
Rectangle -8630108 true false 105 135 120 150
Rectangle -8630108 true false 150 180 165 195
Rectangle -6459832 true false 135 75 150 120
Rectangle -6459832 true false 135 180 150 225
Rectangle -6459832 true false 105 225 195 240
Rectangle -6459832 true false 105 60 195 75
Rectangle -6459832 true false 120 105 135 120
Rectangle -6459832 true false 105 120 120 135
Rectangle -6459832 true false 105 90 120 105
Rectangle -6459832 true false 90 105 105 120
Rectangle -6459832 true false 165 105 180 120
Rectangle -6459832 true false 180 90 195 105
Rectangle -6459832 true false 180 120 195 135
Rectangle -6459832 true false 195 105 210 120
Rectangle -6459832 true false 210 90 225 105
Rectangle -6459832 true false 195 75 210 90
Rectangle -6459832 true false 225 105 240 195
Rectangle -6459832 true false 210 195 225 210
Rectangle -6459832 true false 195 210 210 225
Rectangle -6459832 true false 195 180 210 195
Rectangle -6459832 true false 180 195 195 210
Rectangle -6459832 true false 180 165 195 180
Rectangle -6459832 true false 165 180 180 195
Rectangle -6459832 true false 180 150 225 165
Rectangle -6459832 true false 90 75 105 90
Rectangle -6459832 true false 75 90 90 105
Rectangle -6459832 true false 60 105 75 195
Rectangle -6459832 true false 75 195 90 210
Rectangle -6459832 true false 90 210 105 225
Rectangle -6459832 true false 90 180 105 195
Rectangle -6459832 true false 105 195 120 210
Rectangle -6459832 true false 120 165 105 180
Rectangle -6459832 true false 105 165 120 180
Rectangle -6459832 true false 120 180 135 195
Rectangle -6459832 true false 90 30 210 45
Rectangle -6459832 true false 210 45 225 60
Rectangle -6459832 true false 225 60 240 75
Rectangle -6459832 true false 240 75 255 90
Rectangle -6459832 true false 255 90 270 210
Rectangle -6459832 true false 240 210 255 225
Rectangle -6459832 true false 225 225 240 240
Rectangle -6459832 true false 210 240 225 255
Rectangle -6459832 true false 90 255 210 270
Rectangle -6459832 true false 75 240 90 255
Rectangle -6459832 true false 60 225 75 240
Rectangle -6459832 true false 45 210 60 225
Rectangle -6459832 true false 30 90 45 210
Rectangle -6459832 true false 45 75 60 90
Rectangle -6459832 true false 60 60 75 75
Rectangle -6459832 true false 75 45 90 60
Rectangle -2674135 true false 105 45 195 60
Rectangle -2674135 true false 75 60 105 75
Rectangle -2674135 true false 195 60 225 75
Rectangle -2674135 true false 225 75 240 105
Rectangle -2674135 true false 60 75 75 105
Rectangle -2674135 true false 45 105 60 195
Rectangle -2674135 true false 90 90 105 105
Rectangle -2674135 true false 105 105 120 120
Rectangle -2674135 true false 150 90 165 105
Rectangle -2674135 true false 195 90 210 105
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 240 105 255 195
Rectangle -2674135 true false 105 240 195 255
Rectangle -2674135 true false 225 195 240 225
Rectangle -2674135 true false 195 225 225 240
Rectangle -2674135 true false 180 180 195 195
Rectangle -2674135 true false 195 195 210 210
Rectangle -2674135 true false 150 195 165 210
Rectangle -2674135 true false 105 180 120 195
Rectangle -2674135 true false 90 195 105 210
Rectangle -2674135 true false 75 225 105 240
Rectangle -2674135 true false 60 195 75 225
Rectangle -6459832 true false 75 150 120 165
Rectangle -2674135 true false 90 135 105 150
Rectangle -2674135 true false 195 135 210 150
Rectangle -8630108 true false 45 90 60 105
Rectangle -8630108 true false 45 195 60 210
Rectangle -8630108 true false 75 210 90 225
Rectangle -8630108 true false 90 240 105 255
Rectangle -8630108 true false 195 240 210 255
Rectangle -8630108 true false 240 195 255 210
Rectangle -8630108 true false 210 210 225 225
Rectangle -8630108 true false 240 90 255 105
Rectangle -8630108 true false 210 75 225 90
Rectangle -8630108 true false 195 45 210 60
Rectangle -8630108 true false 90 45 105 60
Rectangle -8630108 true false 180 135 195 150
Rectangle -8630108 true false 210 135 225 150
Rectangle -8630108 true false 150 75 165 90
Rectangle -8630108 true false 75 75 90 90
Rectangle -8630108 true false 75 135 90 150
Rectangle -8630108 true false 150 210 165 225

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
