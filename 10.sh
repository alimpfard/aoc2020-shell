nums=$(sort -n 10.input)
max=$(expr $(printf %s\n $nums | tail -n-1) + 3)
nums=(0 $nums $max)

ones=0
threes=0

for i in $(seq 1 $(expr ${count $nums} - 1)) {
    x=${nth $i $nums}
    xp=${nth $(expr $i - 1) $nums}
    if test $x -eq $(expr $xp + 1) {
        ones=$(expr $ones + 1)
    }
    if test $x -eq $(expr $xp + 3) {
        threes=$(expr $threes + 1)
    }
}

echo $(expr $ones \* $threes)
