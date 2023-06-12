# APCS Final Project

## Group Info
Created by Group **Megaclip**: Lingjie "Jack" Fang and Andrew Li.

## Overview
This is a 2D 8 ball pool game where two players take turns manipulating the
movement of billiard balls. The game simulates collisions and potting balls.
It also includes animations and sound. Standard 8-ball pool rules are implemented.

## Instructions
Past the starting screen, the game is played with typical 8 ball pool rules. A
description of these rules is given at the end of these instructions.

To aim a shot, the cue stick's direction follows the mouse, and there is a
guideline that marks the trajectory of the cue ball. In order to make a shot,
click to aim the cue stick. A power bar will appear on the left, and the
direction will remain stationary. Clicking outside of the power bar will reset
the direction and allow the player to aim again. Clicking inside of the power
bar will release the cue stick at a power based on the color of where the player
clicks: yellow represents low power, and red represents high power.

Turn order is determined first by **fouls**, and then by balls potted. If a
player commits a foul, turn passes to the next player and they may move the cue
ball. In order to move the cue ball, click on it and drag it to a desired
position on the table. It cannot, however, be placed outside a specific border,
which will light up.

If no fouls are committed and a player pots a ball legally, they may go again.

To win the game, a player must pot all of their balls and then the 8 ball legally.
A player may also win if their opponent incurs an **automatic loss**.

### Rules
The first shot of the game is called the *break*. For a break to be legal,
a colored ball must be potted, or at least four balls must strike a rail.
Otherwise, a foul is committed.

Most colored balls, with the exception of the 8 ball, are separated into two
*groups*: solids (numbered 1 through 7) and stripes (numbered 9 through 15).
This is also visually evident from the design of the balls.
The first shot after the break that pots a ball and does not commit a foul
decides the groups for the players. The player making this shot receives the
group of the first ball they pot.

Once groups are decided, the goal of the game is to be the first to pot
one's group's balls and pot the 8 ball afterwards.

A foul is committed if any one of these occur during/after a shot:
- The cue ball is potted
- No balls strike a rail
- No colored balls are struck
- If groups are determined, the cue ball's first contact is NOT of the same
group as the shooting player

Players may also lose at any point in the game. These are called automatic
losses. They occur if any of these occur during a shot:
- The shooting player pots the 8 ball without having finished potting all balls
of their group, or before groups have been decided
- The shooting player pots the 8 ball and the cue ball in the same shot
- The shooting player commits a foul and pots the 8 ball in the same shot

## Updated Prototype
### Updated UML

### Updated Description
There is gameplay and rules for two players. As part of this, the game will
track the solids and stripes for the players. Physics involving inelastic collisions
are implemented. Players are greeted with a title/start screen,
and sounds for the cue stick, ball, and edge collisions as well as potting balls.

## Dev Log
### Working Features

### Broken features/bugs

### Resources

### Possible Improvements
