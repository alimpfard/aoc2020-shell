instrs=$(cat 12.input)
facing=90
e=0
n=0

normalise() {
    if test $facing -lt 0 -o $facing -gt 360 {
        facing=$(expr $(expr $(expr $facing % 360) + 360) % 360)
    }
}

js(exp) {
    printf "console.log(%s)" $exp | serenity-js | head -n1
}

incrf(value) {
    e=$(js "$e+Math.cos($facing*Math.PI/180)*$value")
    n=$(js "$n+Math.sin($facing*Math.PI/180)*$value")
}

for $instrs {
    match $it {
        F* as (value) { incrf $value }
        N* as (value) { n=$(js "$n + $value") }
        S* as (value) { n=$(js "$n - $value") }
        E* as (value) { e=$(js "$e + $value") }
        W* as (value) { e=$(js "$e - $value") }
        L* as (value) { facing=$(js "$facing - $value") }
        R* as (value) { facing=$(js "$facing + $value") }
    }
    normalise
}

echo $e, $n
