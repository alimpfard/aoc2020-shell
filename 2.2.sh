valid=0
for $(cat 2.input) {
  match $it {
    "*-* ?: *" as (min max letter passw) {
      replaced=$(echo -n "${substring $(expr $min - 1) 1 $passw}${substring $(expr $max - 1) 1 $passw}" \
        | sed -e "s/[^$letter]//g")
      if test ${length $replaced} -eq 1 {
        valid=$(expr $valid + 1)
      }
    }
    * {
      echo "Invalid row $it"
    }
  }
}

echo Valid: $valid

