IFS="\n\n"
ans=$(cat 6.input)
IFS="\n"

l=0

for $ans {
    collected=$(echo -n $it | grep -o . | sort | uniq | tr -d "\n")
    nl=${length $collected}
    l=$(expr $l + $nl)
}

echo $l
