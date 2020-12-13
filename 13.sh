target=$(head -n1 13.input)
dtimes=$(tail -n-1 13.input | tr ',' "\n")
maxdiff=$target
id=''

for t in $dtimes {
    match $t {
        x {}
        * {
            diff=$(expr $t - \( $target % $t \))
            if test $diff -le $maxdiff {
                id=$t
                maxdiff=$diff
            }
        }
    }
}

expr $maxdiff \* $id
