```cr
def add(number_one, number_two)
	number_one + number_two
end

add(2, 3)
```

```
// add.txt
// def add (one, two)
  &add_args[] = [];
	&one = %&add_args[0]%;
	&two = %&add_args[1]%;
  %&one% + %&two%
// end


// add (2, 4)
  add_args = [2,4]
  $$<add.txt>
```