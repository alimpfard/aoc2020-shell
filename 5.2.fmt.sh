js=serenity-js

read_one(input) {
    seat=${regex_replace 'F|L' 0 $input}
    seat=${regex_replace 'B|R' 1 $seat}
    seat=0b$seat
    value=${nth 0 $(echo console.log\($seat\) | $js)}
    echo $value
}

{ for $(cat 5.input) { read_one $it } } | sort -n | {
    previous=0
    for $(cat) {
        expected=$(expr $previous + 1)
        if test $it -ne $expected {
            echo $expected
        }
        previous=$it
    }
}
