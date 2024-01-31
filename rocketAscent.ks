runOncePath("0:/libs/lib.ks").

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
  local finish is apScreen:addbutton("Launch!").
  set finish:onclick to checkAP@.
  set launch to False.
  apScreen:show.
}

function checkAP {
  if apo:text:toscalar < 75 {
    set errortxt:text to "Unsafe Orbit. Please choose a higher value.".
  } else {
    set launch to true.
    set apTgt to apo:text:toscalar*1000.
  }
}

function begin {
  set roll to 270 - round(vang(ship:facing:topvector,heading(90,90,270):topvector)).
  sas off.
  lock steering to heading(90,90,roll).
  print "waiting...".
  set TWR to 1.2.
  wait until launch.
  apScreen:hide.
  stage.
  lock throttle to TWR * ship:mass * constant:g0 / max(ship:availablethrust,0.1).
  print "initial ascent...".
  wait until ship:airspeed >= 50.
  set TWR to 1.5.
}

function startAscent {
  when ship:altitude > 65000 then {
    lock pitch to 90 - vang(ship:up:vector,prograde:vector).
    panels on.
  }

  set pitch to 90.
  lock steering to heading(90, pitch, roll).
  until pitch = 80 { 
    set pitch to pitch-2.
    wait until vang(heading(90,pitch):vector, ship:srfPrograde:vector) < 1.
  }
  set TWR to 2.
  lock pitch to 90 - vang(ship:up:vector,srfPrograde:vector).
  // lock steering to heading(90, 90*(constant:e^(-0.00005*ship:altitude)),roll).
  print "tilt engaged.".
  wait until ship:apoapsis > 70000 and eta:apoapsis >= 60.
  lock throttle to 0.
  until apoapsis >= apTgt and ship:altitude > 70000 {
    if eta:apoapsis < 50 { 
      lock throttle to 1.
    } else if eta:apoapsis > 70 {
      lock throttle to 0.
    } else {
      lock throttle to 3.5 - 0.05 * eta:apoapsis. 
    }
  }
  lock steering to heading(vecToYaw(prograde:vector),90 - vang(ship:up:vector,prograde:vector),roll).
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