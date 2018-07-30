```cr
# Make sure its known as bool first otherwise error.
@rapidsneak : Bool

if @rapidsneak
  log("Rapidsneak OFF")
  @rapidsneak = false
  stop
else
  log "Rapidsneak ON"
  @rapidsneak = true
  while @rapidsneak
    keydown("sneak")
    wait("1ms")
    keyup("sneak")
  end
end
```

```
IF("%@&rapidsneak%");
	LOG("Rapidsneak OFF");
	@rapidsneak = false;
	STOP();
ELSE;
	LOG("Rapidsneak ON");
	@rapidsneak = true;
	WHILE(%@rapidsneak%);
	  KEYDOWN("sneak");
	  WAIT("1ms");
	  KEYUP("sneak");
	ENDIF;
ENDIF;
```