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


check="shiny gold"
seen=()

for {
    count=${count $check}
    echo $count left, ${count $seen} seen, ${count $has} total rules
    if test ${count $check} -eq 0 {
        break
    }
    current=${nth 0 $check}
    check=${slice 1 ${count $check} $check}
    seen=$(printf %s\n $seen $current | sort | uniq)
    for $has {
        match $it {
            */*/* as (color count bag) {
                if test ${count ${filterGlob $color $seen}} -eq 0 {
                    if test $current = $bag {
                        check=($check $color)
                    }
                }
            }
        }
    }
    check=$(printf %s\n $check | sort | uniq)
}

printf %s\n $seen

echo $(expr ${count $seen} - 1)
