rows=$(cat 11.input)
rowcount=${count $rows}
colcount=${length ${nth 0 $rows}}
previous=''
row_idxs=$(seq 0 $(expr $rowcount - 1))
col_idxs=$(seq 0 $(expr $colcount - 1))

print_board() {
    i=0
    printf '   '
    printf %s $(seq 0 $colcount)
    echo
    for $rows {
        printf '%02d ' $i
        printf %s $it
        echo
        i=$(expr $i + 1)
    }
    echo
}

setcell(x y v) {
    xrow=${nth $x $rows}
    row="${substring 0 $y $xrow}"$v"${substring $(expr $y + 1) $colcount $xrow}"
    rows=(${slice 0 $x $rows} $row ${slice $(expr $x + 1) $rowcount $rows})
}

cellres=''

cell(x y) {
    if test $x -lt 0 -o $y -lt 0 {
        cellres='x'
    } else {
        cellres=${substring $y 1 ${nth $x $previous}}
    }
}

loop {
    if test "$rows" = "$previous" {
        break
    }
    previous=($rows)
    print_board
    echo x y v
    for x in $row_idxs {
        for y in $col_idxs {
            cell $x $y
            this=$cellres
            if test "$this" = '.' {
                continue
            }
            xm1=$(expr $x - 1)
            xp1=$(expr $x + 1)
            ym1=$(expr $y - 1)
            yp1=$(expr $y + 1)
            neighs=()
            for dx in ($xm1 $x $xp1) {
                for dy in ($ym1 $y $yp1) {
                    if test $dx -eq $x -a $dy -eq $y {
                        continue
                    }
                    cell $dx $dy
                    neighs=($neighs $cellres)
                }
            }
            echo $x $y $this $neighs
            match "$this${count ${filter_glob '#' $neighs}}" {
                'L0' { setcell $x $y '#' }
                '#4'|'#5'|'#6'|'#7'|'#8' { setcell $x $y 'L' }
                * { }
            }
        }
    }
}

print_board
c=0
for $rows {
    c=$(expr $c + ${length ${regex_replace '[^#]' '' $it}})
}
echo $c
