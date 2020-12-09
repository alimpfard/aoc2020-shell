preamble_length=25
numbers=$(cat 9.input)
count=${count $numbers}
one_less_than_preamble_length=$(expr $preamble_length - 1)

no_previous_factors_for(num) {
    ok=true
    for n in $preamble {
        pair=$(expr $num - $n)
        if test ${count ${filterGlob $pair $preamble}} -ne 0 && \
           test $pair -ne $n {
            echo $num - $n = $pair
            ok=false
            break
        }
    }
    $ok
}

part_one() {
    preamble=${slice 0 $preamble_length $numbers}
    rest=${slice $preamble_length $count $numbers}
    value=''
    for $rest {
        if no_previous_factors_for $it {
            value=$it
            break
        }
        preamble=(${slice 1 $one_less_than_preamble_length $preamble} $it)
    }
    if test -z $value {
        exit 1
    }
}

preamble=${slice 0 $preamble_length $numbers}
rest=${slice $preamble_length $count $numbers}
forward=($rest)
sums=()
total=0
value=''
#part_one
one=22477624
i_start=0

for n in $rest {
    i_start=$(expr $i_start + 1)
    total=$n
    sums=$n
    i=$i_start
    for {
        if test $total -ge $one {
            break
        }
        sums=($sums ${nth $i $forward})
        total=$(expr $total + ${nth $i $forward})
        i=$(expr $i + 1)
    }
    echo $i_start -\> $i - $total - $one - ${nth $i $forward}

    if test $total -eq $one {
        numbers=$(printf %s\n $sums | sort -n)
        expr ${nth 0 $numbers} + ${nth $(expr ${count $numbers} - 1) $numbers}
        exit
    }
}
