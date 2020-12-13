dtimes=$(tail -n-1 13.input | tr ',' "\n")
i=0
# a.n+b
ea=0
eb=0

modpow(x y m) {
  echo 'console.log('$x'n ** '$y'n % '$m'n)' \
    | serenity-js \
    | head -n1 \
    | tr -d 'n'
}

for t in $dtimes {
  match $t {
    x {
      i=$(expr $i + 1)
    }
    * {
      p=$t
      a=$p
      b=-$i
      if test $ea -ne 0 {
        q=$(expr \( \( $b - $eb \) \* $(modpow $ea $(expr $p - 2) $p) \) % $p)
        a=$(expr $ea \* $p)
        b=$(expr $ea \* $q + $eb)
      }
      ea=$a
      eb=$(expr $b % $ea)
      i=$(expr $i + 1)
    }
  }
}

expr $eb
