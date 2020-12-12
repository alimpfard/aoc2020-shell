instrs=$(cat 12.input)
we=10
wn=1
se=0
sn=0

js(exp) {
    printf "console.log(%s)\n" $exp | js78 | head -n1
}

rotate(value) {
    xwe=$(js "($we*Math.cos($value*Math.PI/180))+($wn*Math.sin($value*Math.PI/180))")
    xwn=$(js "($wn*Math.cos($value*Math.PI/180))+($we*Math.sin($value*Math.PI/180))")
    we=$xwe
    wn=$xwn
}

incrf(count) {
se=$(js "$se+($we*$count)")
    sn=$(js "$sn+($wn*$count)")
}

for $instrs {
    match $it {
        F* as (value) { incrf $value }
        N* as (value) { wn=$(js "$wn + $value") }
        S* as (value) { wn=$(js "$wn - $value") }
        E* as (value) { we=$(js "$we + $value") }
        W* as (value) { we=$(js "$we - $value") }
        L* as (value) { rotate -$value }
        R* as (value) { rotate $value }
    }
}

echo $se, $sn
