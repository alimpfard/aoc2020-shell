lines=$(sort -n 1.input)
count=${count $lines}
l=0
r=$(expr $count - 1)
for $(seq 1 $count) {
    lth=${nth $l $lines}
    rth=${nth $r $lines}
    sum=$(expr $lth + $rth)
    if test $sum -eq 2020 {
        expr $lth \* $rth
        exit
    } else if test $sum -lt 2020 {
        l=$(expr $l + 1)
    } else {
        r=$(expr $r - 1)
    }
}

exit 1
