lines=$(sort -n 1.input)
count=${count $lines}
c2=$(expr $count - 2)
for i in $(seq 0 $c2) {
    l=$(expr $i + 1)
    r=$(expr $count - 1)
    for $(seq 1 $count) {
        ith=${nth $i $lines}
        lth=${nth $l $lines}
        rth=${nth $r $lines}
        sum=$(expr $lth + $rth + $ith)
        if test $sum -eq 2020 {
            expr $lth \* $rth \* $ith
            exit
        } else if test $sum -lt 2020 {
            l=$(expr $l + 1)
        } else {
            r=$(expr $r - 1)
        }
    }
}

exit 1
