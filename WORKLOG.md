# Work Log

## Lingjie Fang

### 05-22

Worked on initial setup of rectangular pool table and dimensions

### 05-24

Added colors to the base pool table.
Added middle pockets to the pool table.

### 05-25

Tested out edge detection for collisions and bouncing off the edges of the pool table.
Tested checking for the ball stopping if velocity reverses direction after acceleration is applied.

### 05-27
Worked on debugging collisions and new physics

### 05-28
Mostly completed the logic for collisions for the 12 corner walls. A minor issue is that wall glitches when the ball hits the wall at certain locations at certain angles, which I tried to deal with using a line segment threshold extension. This was unsuccessful.

### 05-29
Started bounce method. Added position offsets, removed threshold, met with Andrew to made collide() smoother.

### 05-30

Reworked position offsets using linear algebra (rotation matrices) to check conditions. Implemented new position offsets for 6 of the 12 corner walls.

### 05-31
Finished the new position offsets for the rest of the 12 corner walls. Added restitution constants and merged collide() method with main.

### 06-04
Added rack to collect the balls in. Made potted balls slide into this rack instead of remaining in pot.

### 06-06
Tested rack branch. Merged rack branch with main.

### 06-07
Added main menu screen with clickable button. Started implementing turns.

### 06-08
Made giant outline of rules in Google Docs. Introduced arrays to store the number of potted balls of each type. Added processing skeleton, as well as hitRail skeleton for colored balls. Added new booleans for white ball to help with rules.

### 06-09
Finished helper methods for turns and fouls. Added all turn and foul rules in Turns branch. Added win screen and win text.

## 06-11
Added glowing avatars to represent players. Added announcement text to announce which player has stripes and solids. Added display of stripes and solids for each player using 'mini racks' next to each player.

## Andrew Li

### 05-22

Started on the Ball class; set up all fields and currently
working on constructor. Colors, type, and number are finalized.

### 05-23

Finished Ball constructor and show() method based on number, type,
and color. The only inaccuracy is that the number is colored white
and there is no white circle in the middle of the ball. This is
so the number is more readable.

Future status of rotating visuals is unclear.

### 05-24

Made significant progress on Ball physics, specifically movement and
friction on the table. Currently only implemented sliding friction, meaning
that the movement stops abruptly rather than lightly. Will implement
rolling friction soon.

### 05-25

Implemented rolling friction with a time delay, which is not technically correct
but it achieves approximately the correct realistic behavior of a rolling ball.
Currently, the thresholds for stopping and switching frictions are constant,
but they should not be; will fix that soon. Most realistic simulation is probably
achievable with non-constant rolling friction coefficient, which may also be
implemented.

### 05-26
Fixed movement/friction physics, which ended up being way too overcomplicated.
- Removed force variable (field), resetting acceleration after the first frame.
- Friction coefficient varies between initial slidingMu (large) and final
rollingMu (small) proportionally with time. Setting rollingMu to a value 10x
smaller than in real life produces anaccurate yet non-ideal (realistic) simulation.

As a result, collide() and bounce() should now be easier to code/understand.

### 05-27
Started WhiteBall skeleton class. Will override pot() soon.
Modified how pockets are drawn; stored their x-coordinates in two arrays
in order to make things easier.
Wrote a preliminary pot() method. It is not complete, because the ball does not
disappear and slide onto the rack, and the WhiteBall does not have special
pot() rules.

### 05-28
Started the CueStick class today. Appearance and rotation about the WhiteBall
was achieved, as were disappearance with movement. This has to be updated later, however,
with the custom WhiteBall pot rule and more balls. Will add a gamestate variable
later to synchronize the game.

### 05-29
Finished the preliminary draft of how the CueStick will be used to effect force
on the white ball. Discussed ways to improve collide() with Jack.

### 05-30
Finished CueStick implementation and how the white ball behaves. Started
polishing the game state, and will work on bounce().

### 05-31
Tried to start implementing bounce(), no luck. I'm probably doing physics
wrong.

### 06-01
I was indeed doing physics wrong. The trick is to blindly plug in the equations
without understanding anything! Maybe next year.
Completed bounce() with dampened elastic collisions. Also patched
a bug that arose from dividing by 0 in calculating friction.
Cleaned up the WhiteBall's movement abilities. Specifically, introduced a
specific bound (a white box that shows itself if you try to go out of bounds),
as well as a bug fix that prevented the ball from phasing through other balls.
Finally, the simulation is now fully* playable (achieved MVP).

### 06-02
N/A

### 06-03
N/A

### 06-04
Implemented a few bug fixes when moving the WhiteBall, including being able to
move it in a smaller box when breaking. Then, I started on including the white
guidelines into the CueStick class. Currently, the case where it collides with
another ball is complete. Debating whether or not to implement the case to detect
wall collision.

### 06-05
N/A

### 06-06
Merged the CueStick guideline, decided not to implement wall detection.
Attempted to make collisions more accurate in the fixPhysics branch with
math, but it ended up breaking the whole thing; reverted changes. Considering
upping the refresh rate from 60 to try and make collisions more accurate...

### 06-07
Looked at a few more ways to fix physics, decided it would be too complex.
The article helps, but I had already tried implementing most of the ideas,
and it would instead require changing the entire structure of our code.

### 06-08
Discussed implementing rules with Jack, helped create a template for it.
Correctly randomized racking of the balls, with the 8-ball in the middle
and corners with at least one of each type.

### 06-09
Started adding sound to ball-to-ball collision and pottings. Fixed a small visual bug.

### 06-10
Completed first two aspects of README. Again considered fixing physics,
but doing so involves recursion and combining most of the main code we have,
which there is not enough time for.

### 06-11
Last day!!
Added two more sounds and implemented logic to change the guideline
symbol based on which ball, which player, and which group is assigned.

# Dev Log

## Working Features
- Balls collide with the edges of the table, including diagonal ones\*
- Balls collide with each other\*\*
- The mouse controls aim of the cue stick, with adjustable power
- Balls are potted into a rack
- Guidelines coming out of the cue stick describe the trajectory\*\* of
the contact ball and whether or not hitting a ball results in a foul
- Ball-in-hand fouls are handled, with players being able to move the cue
ball around the table\*\*\* before breaking or after a foul
- Rules of 8 ball pool account for winning, losing, fouling, and
determining groups.
- Player icons glow, and respective racks are outlined based on whose turn it is.
- Racks near player icons fill and empty based on the determined groups and
what balls have been potted already
- Sounds indicate the start of a game, ball collisions, potting balls,
and the end of each turn.

## Broken Features and Bugs

### Disruptive Bugs
- \*Collisions with the edges of the table are not perfect collisions; they are
offset per frame, meaning that a ball moving at a high speed may bounce off of
a wall with a slight inaccuracy.
- \*\*Collisions between balls are also calculated per frame, meaning that a ball
moving at a high speed may not accurately reflect off of another ball.
- \*\*\*When the cue ball is in hand, a border should prevent the ball from being
moved too close to the edge of the table, or outside the pool table. However,
the cue ball also may not be moved inside a colored ball. Since this second
criteria overrides the first, if a colored ball is sufficiently close to the
edge of the border, it may push the white ball slightly outside of the border.

Additionally, if two colored balls are sufficiently close to one another, trying
to move the cue ball around one will cause it to phase through the other. However,
upon shooting the cue ball, it is offset away from the colored ball, preventing
long-term damage to the game.

### Visual Bugs
- The cue stick glows. Honestly this could be a feature.
- If multiple colored balls are potted in a short period of time, they may
appear to overlap when sliding down the rack on the right side. However, upon
reaching the bottom, they reset positions to stack correctly on top of one another.
- If the cue ball is potted, it will stay inside the pocket until it is taken
out for a foul, instead of rolling down the rack like the rest of the balls.

## Resources
We found the following articles about collisions to be helpful:
- https://www.gamedeveloper.com/programming/pool-hall-lessons-fast-accurate-collision-detection-between-circles-or-spheres
- https://processing.org/examples/circlecollision.html
- https://happycoding.io/tutorials/processing/collision-detection
We found the following articles about billiard balls to be helpful:
- https://billiards.colostate.edu/faq/physics/physical-properties/
- https://billiards.colostate.edu/physics/
