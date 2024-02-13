runOncePath("0:/libs/lib.ks").
runOncePath("0:/libs/space.ks").
function ascendKerbin {
  parameter ap.
  precheck(ap).
  begin().
  startAscent().
  circPrep().
  doMnv().
  print("Done.").
}

function precheck {
  parameter ideal.
  set apScreen to gui(200).
  local title is apScreen:addlabel("Set AP").
  set title:style:align to "CENTER".
  local mid is apScreen:addhlayout().
  set apo to mid:addtextfield(""+ideal).
  local xtra is mid:addlabel("kms").
  set mid:style:align to "CENTER".
  set mid:style:hstretch to true.
  set errortxt to apScreen:addlabel("").
  set errortxt:style:align to "CENTER".
  local finish is apScreen:addbutton("Launch!").
  set finish:onclick to checkAP@.
  set launch to False.
  set apScreen:x to -400.
  set apScreen:y to 1080 / 3.
  apScreen:show.
  wait until launch.
  apScreen:hide.
}

function checkAP {
  if apo:text:toscalar(0) < 75 {
    set errortxt:text to "Unsafe Orbit. Please choose a higher value.".
  } else {
    set launch to true.
    set apTgt to apo:text:toscalar*1000.
  }
}

function begin {
  set roll to ship:facing:upvector.
  sas off.
  lock steering to lookDirUp(heading(90,90):vector,roll).
  print "waiting...".
  if defined CoT {
    lock throttle to 1.
  } else {
    set TWR to 1.5.
    lock throttle to TWR * ship:mass * constant:g0 / max(ship:availablethrust,0.1).
  }
  stage.
  print "initial ascent...".
}

function startAscent {
  when ship:altitude > 65000 then {
    lock pitch to 90 - vang(ship:up:vector,prograde:vector).
    panels on.
  }
  lock pitch to 90 - (ship:altitude/750).
  lock steering to lookdirup(heading(90, pitch):vector,roll).
  set TWR to 2.
  // lock steering to heading(90, 90*(constant:e^(-0.00005*ship:altitude)),roll).
  print "tilt engaged.".
  wait until ship:apoapsis > 75000 and eta:apoapsis >= 60.
  lock throttle to 0.
  lock steering to lookDirUp(prograde:vector,roll).
  until apoapsis >= apTgt or ship:altitude > 70000 {
    if eta:apoapsis < 50 { 
      lock throttle to 1.
    } else if eta:apoapsis > 70 {
      lock throttle to 0.
    } else {
      lock throttle to 3.5 - 0.05 * eta:apoapsis. 
    }
  }
  until ship:altitude > 70000 {
    if ship:apoapsis < apTgt {
      lock throttle to 0.2.
      wait until ship:apoapsis >= apTgt.
    }
  }
  wait until vang(prograde:vector,ship:facing:vector) < 2.
  until ship:apoapsis > apTgt {
    lock throttle to 1.
    wait until ship:apoapsis > apTgt.
  }
  lock throttle to 0.
}

function circPrep {
  print "setting up circ...".
  local ap is obt:apoapsis + kerbin:radius.
  local pe is obt:periapsis + kerbin:radius.
  local v1 is sqrt(kerbin:mu*(2/ap - 1/sma(ap,pe))).
  local v2 is sqrt(kerbin:mu*(2/ap - 1/sma(ap,ap))).
  local deltav is v2-v1.
  local burn is node(time:seconds+eta:apoapsis,0,0,deltav).
  add burn.
}