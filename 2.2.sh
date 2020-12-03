valid=0
for $(cat 2.input) {
  match $it {
    "*-* ?: *" as (min max letter passw) {
      replaced=${regexReplace "[^$letter]" '' "${substring $(expr $min - 1) 1 $passw}${substring $(expr $max - 1) 1 $passw}"}
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

