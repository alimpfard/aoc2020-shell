byr=''
iyr=''
eyr=''
hgt=''
hcl=''
ecl=''
pid=''
cid=''
valid=0
x=0

test_byr() {
    match $byr {
        ???? { test $byr -ge 1920 -a $byr -le 2002 }
        * { false }
    }
}
test_iyr() {
    match $iyr {
        ???? { test $iyr -ge 2010 -a $iyr -le 2020 }
        * { false }
    }
}
test_eyr() {
    match $eyr {
        ???? { test $eyr -ge 2020 -a $eyr -le 2030 }
        * { false }
    }
}
test_hgt() {
    match $hgt {
        *cm as (num) { test $num -ge 150 -a $num -le 193 }
        *in as (num) { test $num -ge 59 -a $num -le 76 }
        * { false }
    }
}
test_hcl() {
    match ($hcl ${regex_replace '^#[0-9a-f]{6}' '' $hcl}) {
        ('' '') { false }
        (* '') { true }
        (* *) { false }
    }
    # ' vim is confused
}
test_ecl() {
    match $ecl {
        amb | blu | brn | gry | grn | hzl | oth { true }
        * { false }
    }
}
test_pid() {
    match ($pid ${regex_replace '^\d{9}' '' $pid}) {
        ('' '') { false }
        (* '') { true }
        (* *) { false }
    }
    # ' vim is confused
}

flush() {
    if test_byr && test_iyr && test_eyr && test_hgt && test_hcl && test_ecl && test_pid {
        valid=$(expr $valid + 1)
        echo "valid: byr=$byr, iyr=$iyr, eyr=$eyr, hgt=$hgt, hcl=$hcl, ecl=$ecl, pid=$pid, cid=$cid"
    }
    byr=''
    iyr=''
    eyr=''
    hgt=''
    hcl=''
    ecl=''
    pid=''
    cid=''
}

IFS="\n\n"
lines=$(cat 4.input) # FIXME: line splitting produces odd results at times?
IFS="\n"
for line in $lines {
    x=$(expr $x + 1)
    for segment in $(echo -n $line | tr ' ' "\n") { # FIXME: truncated line-split?
        echo Segment: $segment
        match $segment {
            *:* as (field value) {
                # Hash maps would be nice
                match $field {
                    byr { byr=$value }
                    iyr { iyr=$value }
                    eyr { eyr=$value }
                    hgt { hgt=$value }
                    hcl { hcl=$value }
                    ecl { ecl=$value }
                    pid { pid=$value }
                    cid { cid=$value }
                    * { echo Invalid field "'$field'" }
                }
                # echo have $field
            }
            * { echo invalid segment "'$segment'" in line "'$line'"; echo -n $line | xxd }
        }
    }
    # echo done: $line

    flush
}

echo $valid / $x
