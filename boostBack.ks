runoncepath("0:/libs/lib.ks").
function boostBack {
  lock throttle to 0.
  rcs on.
  brakes off.
  sas off.
  lock steering to heading(vecToYaw(srfRetrograde:vector),0).
  wait 3.
  lock throttle to 1.
  wait 2.
  lock throttle to 0.
  wait until vang(heading(vecToYaw(srfRetrograde:vector),5):vector,ship:facing:vector) < 5.
  lock throttle to 1.
  unlock steering.
  sas on.
  wait until vang(srfPrograde:vector, ship:facing:vector) < 90.
  lock throttle to 0.75.
  wait 0.55. 
  unlock throttle.
  set ship:control:pilotmainthrottle to 0.
  sas off.
  lock steering to srfRetrograde.
  lock throttle to 1. 
  wait 0.5.
  lock throttle to 0.
  brakes on. 
  wait until vang(ship:facing:vector, srfRetrograde:vector) < 3.
  rcs off.
  wait until addons:ke:suicideBurnCountdown < 0 and altitude < 1000.
  set TWR to 999.
  lock throttle to TWR * ship:mass * constant:g0 / max(ship:availablethrust,0.1).
  wait until ship:airspeed < 35.
  gear on.
  lock steering to up.
  set TWR to 0.9.
  wait until alt:radar < 50.
  wait until airspeed > 11.
  set TWR to 3.
  wait until airspeed < 5.
  set TWR to 1.
  wait until ship:status = "LANDED".
  unlock throttle.
  unlock steering.
}