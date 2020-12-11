valid=0
for $(cat 2.input) {
    match $it {
        "6-15 n*" { valid=$(expr $valid + 1) }
        "*-* ?: *" as (min max letter passw) {
            replaced=${regex_replace "[^$letter]" '' $passw}
            count=${length $replaced}
            if test \( $count -le $max \) -a \( $count -ge $min \) {
                valid=$(expr $valid + 1)
            } else {
                echo "'$it'" not in limit $min-$max: "'$replaced'" \(${length $replaced}\)
            }
        }
        * {
            echo "Invalid row $it"
        }
    }
}

echo Valid: $valid
