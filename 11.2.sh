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
            neighs=()
            for da in (-1 0 1) {
                for db in (-1 0 1) {
                    dx=$(expr $x + $da)
                    dy=$(expr $y + $db)
                    loop {
                        if test $dx -lt 0 -o $dy -lt 0 -o $dx -ge $rowcount -o $dy -ge $colcount {
                            break
                        }
                        cell $dx $dy
                        if test $cellres != '.' {
                            break
                        }
                        dx=$(expr $dx + $da)
                        dy=$(expr $dy + $db)
                    }
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
