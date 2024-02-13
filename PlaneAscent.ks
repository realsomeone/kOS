runOncePath("0:/rocketAscent.ks").

function flyToKerbinOrbit {
  parameter ap.
  precheck(ap).
  runwayAccel().
  ascend().
  finishOrbit().
}

function runwayAccel {
  set roll to ship:up:vector.
  sas off.
  lock throttle to 1.
  set pit to heading(90,0).
  lock steering to lookDirUp(pit:vector,roll).
  wait until launch.
  brakes off.
  togg(AB).
  wait until airspeed > 100.
  set pit to heading(90,20).
  wait until altitude - ship:geoposition:terrainheight > 20.
  gear off.
  set pitch to heading(90,20).
}

function ascend {
  wait until altitude > 15000 and AB[0]:thrust < 100.
  swit(AB).
  togg(SE).
  when altitude > 65000 then { panels on. }
  wait until apoapsis > apTgt * 0.75.
  togg(AB).
  swit(AB).
  wait until apoapsis > apTgt.
  lock throttle to 0.
}

function finishOrbit {
  circPrep().
  doMnv().
}


function togg {
  parameter engs.
  for eng in engs {
    if eng:ignition { eng:shutdown. }
    else { eng:activate. }
  }
}

function swit {
  parameter engs.
  for eng in engs { eng:togglemode(). }
}