# macro_transpile
transpile a very limited subset of crystal to mkb language

## Todo
rewrite, the code is an awful mess right now, initially wrote after staying up 30 hours in an attempt to research the internals of crystal-lang

automatic float calculation. (using a transpiler standard library of sorts)

namespaces, namespaces for easy namespace naming for namespaces

automatic file outputs, right now files need to manually be named if emulated method.

classes, classes can be emulated by having inline methods. (emulated differently)
too tired to think of a full solution, this is very unprofessional.


## Usage
dependencies
  - Crystal 0.25.1
  
1. Clone the repository
2. Built command.cr with `crystal build src/command.cr` 
3. use the generated binary however you like

## Contributing

1. Fork it (<https://github.com/your-github-user/macro_transpile/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [brecert](https://github.com/brecert) Brecert - creator, maintainer


## Examples
```cr
# Automatic Assignment
# Automatic Typings
x = 0
n = "Hello World!"
a = ["Hello Array!"]

# Automatic calls (can act weird at times)
y = a[0]

# Easy array usage
z = [x, n, a, y]
z[x]

# Use traditional methods without a lot of syntax
log "Hello World!"

# Easy interpolation
text = "world"
log "Hello #{text}!"

# Method Emulation (not feature complete, buggy)
def say(name)
  "Hello my name is #{name}."
end

say "Bree"

# Globals
def stuff(more)
  @result = more
end

log @result

# Basic If and While conditionals.
working = true
i = 0
while working
  i += 1
  log "#{i}. mining.."
  if i > 10
    log "Phewf, glad that's done"
    working = false
  end
end
```
transpiles to
```
#x = 0;
&n = "Hello World!";
&a[] = ["Hello Array!"];
&y = %&a[0]%;
&z[] = [%#x%, %&n%, %&a[]%, %&y%];
%&z[%#x%]%
LOG("Hello World!");
&text = "world";
LOG("Hello %&text%!");

// @FILE say.txt
// @METHOD say(name)
&name = $$0
"Hello my name is %&name%."


// @CALL say
EXEC(say.txt,say,"Bree")


// @FILE stuff.txt
// @METHOD stuff(more)
&more = $$0
@&result = %&more%;

LOG(%@&result%);
working = true;
#i = 0;
WHILE(%working%);
  i += 1
  LOG("%#i%. mining..");
    IF("%#i% > 10");
      LOG("Phewf, glad that's done");
      working = false;
    ENDIF;
ENDIF;
```

If you're wondering why @CALL and other comments are in there, it's easy to get lost in the code without the crystal code for reference, this just makes it easier to tell where it is.

It also makes creating the correct files easier.
