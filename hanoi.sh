#!/bin/bash

# tower of hanoi -- recursive solution with ascii visualization
# writes all moves to hanoi_moves.txt
# usage: ./hanoi.sh [num_disks]   (default: 4)

N=${1:-4}
MOVES=0
OUT="hanoi_moves.txt"

# pegs as space-separated strings, bottom = first word, top = last
A="" B="" C=""

for (( i=N; i>=1; i-- )); do
    A="$A $i"
done
A="${A# }"

render_state() {
    local title="$1"
    echo "$title" >> "$OUT"

    read -ra DA <<< "$A"
    read -ra DB <<< "$B"
    read -ra DC <<< "$C"

    # print rows from top (row N) down to bottom (row 1)
    for (( row=N; row>=1; row-- )); do
        local line="  "
        for arr_name in DA DB DC; do
            eval "local sz=\${#${arr_name}[@]}"
            local idx=$(( row - 1 ))
            if (( idx < sz )); then
                eval "local d=\${${arr_name}[$idx]}"
                local pad=$(( N - d ))
                local left=""
                local right=""
                (( d > 1 )) && left=$(printf '%0.s#' $(seq 1 $(( d-1 )))) && right=$left
                line+="$(printf "%*s" $pad "")${left}|${right}$(printf "%*s" $pad "")"
            else
                line+="$(printf "%*s|%*s" $N "" $N "")"
            fi
            line+="   "
        done
        echo "$line" >> "$OUT"
    done

    local base_w=$(( N*2 + 1 ))
    local base=""
    for p in A B C; do
        base+="$(printf '%0.s=' $(seq 1 $base_w))   "
    done
    echo "  $base" >> "$OUT"

    local labels=""
    for p in A B C; do
        labels+="$(printf "%*s%s%*s   " $N "" $p $(( N-1 )) "")"
    done
    echo "  $labels" >> "$OUT"
    echo "" >> "$OUT"
}

move_disk() {
    local src=$1 dst=$2

    # pop top of src
    eval "local disk=\${$src##* }"
    eval "local rest=\${$src% *}"
    eval "[[ \"\$rest\" == \"\$disk\" ]] && $src='' || $src=\"\$rest\""

    # push onto dst
    eval "local cur=\$$dst"
    if [[ -z "$cur" ]]; then
        eval "$dst=$disk"
    else
        eval "$dst=\"\$cur $disk\""
    fi

    (( MOVES++ ))
    render_state "Move $MOVES: $src --> $dst  (disk $disk)"
}

# recursive solution:
# move n disks from src to dst using aux as scratch space
hanoi() {
    local n=$1 src=$2 dst=$3 aux=$4
    (( n == 0 )) && return
    hanoi $(( n-1 )) $src $aux $dst   # clear n-1 disks out of the way
    move_disk $src $dst                # move the largest disk
    hanoi $(( n-1 )) $aux $dst $src   # stack n-1 disks back on top
}

# clear output file and write header
echo "Tower of Hanoi -- $N disks" > "$OUT"
echo "$(printf '%0.s-' $(seq 1 40))" >> "$OUT"
echo "" >> "$OUT"

render_state "Initial state"
hanoi $N A C B

echo "Done! $MOVES moves total (optimal: $(( (1 << N) - 1 )))" >> "$OUT"
echo "Output written to $OUT"
cat "$OUT"