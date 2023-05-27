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
