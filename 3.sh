map=$(cat 3.input)
length=${count $map}
hlen=${length ${nth 0 $map}}

# v part 1
# steps=3,1
steps=(1,1 3,1 5,1 7,1 1,2)

all_trees=1
for step in $steps {
    xstep=0
    ystep=0
    match $step {
        *,* as (x y) { xstep=$x; ystep=$y }
        * { echo "invalid step: $step"; exit 1 }
    }
    x=0
    y=0
    trees=0
    echo "Trying $step"
    for $(seq 1 $length) {
        if test $y -lt $length {
            # FIXME: Need 'break'!
            row=${nth $y $map}
            #before=${substring 0 $x $row}
            #after=${substring $(expr $x + 1) $(expr ${length $row} - $x - 1) $row}
            #printf x=%04d,' 'y=%04d' '%s%sX%s%s\n $x $y $before "\x1b[31m" "\x1b[0m" $after
            match ${substring $x 1 $row} {
                "#" { trees=$(expr $trees + 1) }
                "." {}
            }
            y=$(expr $y + $ystep)
            x=$(expr \( $x + $xstep \) % $hlen)
        }
    }
    all_trees=$(expr $all_trees \* $trees)
}

echo $all_trees trees.
