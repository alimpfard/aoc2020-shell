nums=$(sort -n 10.input)
max=$(expr $(printf %s\n $nums | tail -n-1) + 3)
nums=(0 $nums $max)
count=${count $nums}
count_minus_one=$(expr $count - 1)
count_minus_two=$(expr $count - 2)
count_minus_three=$(expr $count - 3)
seen=$(seq 1 $count | xargs -I '{}' printf 0\n)
count_res=0 # This is disgusting, fix passing arrays in and out of functions.

count(i p v) {
    # Should we just go the python way and require 'global seen' to access globals?
    if test $i -eq $count_minus_one {
        count_res=1
    } else if test ${nth $i $seen} -ne 0 {
        count_res=${nth $i $seen}
    } else {
        v=${nth $i $nums}
        count $(expr $i + 1) 0 0
        p=$count_res
        if test $i -lt $count_minus_two && \
           test ${nth $(expr $i + 2) $nums} -le $(expr $v + 3) {
               count $(expr $i + 2) 0 0
               p=$(expr $p + $count_res)
        }
        if test $i -lt $count_minus_three && \
           test ${nth $(expr $i + 3) $nums} -le $(expr $v + 3) {
               count $(expr $i + 3) 0 0
               p=$(expr $p + $count_res)
        }
        # Need ${set-nth $idx $value $coll} (or similar)
        seen=(${slice 0 $i $seen} $p ${slice $(expr $i + 1) $count $seen})
        count_res=$p
    }
}

count 0 0 0
echo $count_res
