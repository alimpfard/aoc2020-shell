IFS="\n\n"
ans=$(cat 6.input)
IFS="\n"

l=0

for $ans {
    people=${count $(echo -n $it)}
    collected=$(echo -n $it | grep -o . | sort | tr -d "\n")
    valid=${regex_replace '[^X]' '' ${regex_replace "(.)\\1{$(expr $people - 1)}" "X" $collected}}
    l=$(expr $l + ${length $valid})
    echo $people $collected
}

echo $l
