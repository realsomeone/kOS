clearScreen.
print "waiting...".
wait until not ship:messages:empty.
set tgt to ship:messages:pop:sender.
stage.
ship:messages:clear.
print "recieved. Moving.".
if not ship:periapsis < 70000 {
  sas off.
  wait 0.
  lock steering to retrograde.
  print "waiting for angle...".
  wait until vang(ship:facing:forevector,retrograde:vector) < 2.
  print "waiting message...".
  wait until not ship:messages:empty.
  print "done. Goodbye!".
  list engines in eggs.
  for eng in eggs {
    if not eng:ignition and not eng:flameout {
      eng:activate.
    }
  }
  tgt:connection:sendmessage("yasta.").
} else {
  wait until not ship:messages:empty.
  tgt:connection:sendmessage("oops.").
}