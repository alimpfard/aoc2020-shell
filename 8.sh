ip=0
acc=0
insns=$(cat 8.input)
seen=()

loop {
    if test ${count ${filter_glob $ip $seen}} -ne 0 {
        echo reached infinite loop at ip=$ip
        echo $acc
        exit
    }
    if test $ip -ge ${count $insns} {
        echo reached end of instruction list
        echo $acc
        exit
    }

    seen=($seen $ip)
    match ${nth $ip $insns} as insn {
        "acc +*" | "acc *" as (value) {
            acc=$(expr $acc + $value)
            ip=$(expr $ip + 1)
        }
        nop* { ip=$(expr $ip + 1) }
        "jmp +*" | "jmp *" as (offset) {
            ip=$(expr $ip + $offset)
        }
    }
}
