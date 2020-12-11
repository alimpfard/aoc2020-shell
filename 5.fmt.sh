js=serenity-js
max=0

read_one(input) {
    seat=${regex_replace 'F|L' 0 $input}
    seat=${regex_replace 'B|R' 1 $seat}
    seat=0b$seat
    value=${nth 0 $(echo console.log\($seat\) | $js)}
    if test $max -le $value {
        max=$value
    }
}

for $(cat 5.input) { read_one $it }
echo $max
