set debris to processor("tank"):part.
stage.
sas off.
lock steering to prograde:vector.
print "toggling...".
set debris to debris:ship.
debris:connection:sendmessage("mmb go away").
print "send 1...".
wait until debris:distance > 25.
debris:connection:sendmessage("mmb go away. pls.").
print "send 2. Done.".
print "waiting for gtg...".
wait until not ship:messages:empty.
print "done. Continue with mission.".