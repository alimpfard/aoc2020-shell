rules=$(cat 7.input)
has=()
for $rules {
    match $it {
        "* bags contain *." as (color ruleset) {
            IFS=', '
            for rule in $(echo -n $ruleset) {
                match $rule {
                    "? * bags" | "? * bag" as (count bag) {
                        has=($has "$color/$count/$bag")
                    }
                    "no other bags" { }
                    * { echo ERROR: $rule }
                }
            }
            IFS="\n"
        }
        * {
            echo ERROR: $it # This bug is annoying.
        }
    }
}

ans=0
check="shiny gold/1"

loop {
    count=${count $check}
    echo $count left, $ans ans, ${count $has} total rules
    if test ${count $check} -eq 0 {
        break
    }
    current=${nth 0 $check}
    check=${slice 1 ${count $check} $check}
    xcolor=''
    xcount=''
    match $current {
        */* as (c t) { xcolor=$c; xcount=$t }
    }
    for $has {
        match $it {
            "$xcolor/*/*" as (count bag) {
                v=$(expr $xcount \* $count)
                ans=$(expr $ans + $v)
                check=($check "$bag/$v")
            }
            * { }
        }
    }
}

echo $ans
