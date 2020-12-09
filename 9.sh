preamble_length=25
numbers=$(cat 9.input)
count=${count $numbers}

preamble=${slice 0 $preamble_length $numbers}
rest=${slice $preamble_length $count $numbers}
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

for $rest {
    echo $preamble
    if no_previous_factors_for $it {
        echo $it
        exit
    }
    preamble=(${slice 1 $one_less_than_preamble_length $preamble} $it)
}

exit 1
