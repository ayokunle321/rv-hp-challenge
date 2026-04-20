# rv-hp-challenge

Tower of Hanoi implementation in bash for the RV-Sparse LFX mentorship coding challenge.

## How it works

Recursive solution. The `hanoi` function calls itself twice per move (once to clear n-1 disks
out of the way, once to stack them back) with the largest disk moving directly to the target
in between. That gives the optimal 2^n - 1 moves for n disks.

All states are written to hanoi_moves.txt so you can step through every move at your own pace.

## Run

    bash hanoi.sh        # 4 disks by default
    bash hanoi.sh 5      # or pass a number