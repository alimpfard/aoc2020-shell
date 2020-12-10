ip=0
acc=0
insns=$(cat 8.input)
seen=()

swap_nj(nip nacc) {
    match ${nth $nip $insns} as insn {
        jmp* {
            echo swapping ip=$nip from jump to nop
            nip=$(expr $nip + 1)
            speculate $nip $nacc
        }
        "nop +*" | "nop *" as (offset) {
            echo swapping ip=$nip from nop to jump
            nip=$(expr $nip + $offset)
            speculate $nip $nacc
        }
        * { false }
    }
}

speculate(nip nacc) {
    nseen=($seen)
    loop {
        if test ${count ${filterGlob $nip $nseen}} -ne 0 {
            echo ===============================
            echo ===============================
            echo reached infinite loop at nip=$nip
            echo $nacc
            echo ===============================
            echo ===============================
            false
            break
        }
        if test $nip -ge ${count $insns} {
            echo ===============================
            echo ===============================
            echo reached end of instruction list
            echo $nacc
            echo ===============================
            echo ===============================
            true
            break
        }

        nseen=($nseen $nip)
        match ${nth $nip $insns} as insn {
            "acc +*" | "acc *" as (value) {
                nacc=$(expr $nacc + $value)
                nip=$(expr $nip + 1)
            }
            nop* { nip=$(expr $nip + 1) }
            "jmp +*" | "jmp *" as (offset) {
                nip=$(expr $nip + $offset)
            }
        }
    }
}


loop {
    if swap_nj $ip $acc {
        break
    }

    if test ${count ${filterGlob $ip $seen}} -ne 0 {
        echo ===============================
        echo reached infinite loop at ip=$ip
        echo $acc
        echo ===============================
        false
    }
    if test $ip -ge ${count $insns} {
        echo ===============================
        echo reached end of instruction list
        echo $acc
        echo ===============================
        true
    }

    seen=($seen $ip)
    insn=${nth $ip $insns}
    printf %03d\ %s\n $ip $insn
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
