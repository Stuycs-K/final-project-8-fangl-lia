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
