valid=0
for $(cat foo) {
    match $it {
        "6-15 n*" { valid=$(expr $valid + 1) }
        "*-* ?: *" as (min max letter passw) {
            replaced=$(echo -n $passw | sed -e "s/[^$letter]//g")
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
