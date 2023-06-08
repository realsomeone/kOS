function main {
  set tgt to mun.
  set target to tgt.
  set ap to 80000.
  ascent().
  circ().
  // transfer().
  // land().
}

function ascent {
  lock throttle to 1.
  sas off.
  set str to heading(90,90).
  lock steering to str.
  wait until rcs.
  rcs off.
  stage.
  until ship:airspeed >= 100 or alt:radar >= 100 {
    autoStage().
  }
  set str to heading(90,85).
  wait until vang(ship:facing:vector,heading(90,85):vector) <= 0.1.
  until vang(ship:facing:vector,srfPrograde:vector) < 0.1 {
    autoStage().
  }
  unlock steering.
  sas on.
  wait 0.
  wait 0.
  set sasMode to "PROGRADE".
  lock throttle to 1.75 * ship:mass * constant:g0 / ship:availablethrust.
  until apoapsis >= ap {
    autoStage().
  }
  set thr to 0.
  lock throttle to thr.
  when altitude >= 65000 then {
    toggle ag2.
  }
  until altitude >= 70000 {
    if apoapsis < ap {
      set thr to 0.5 * ship:mass * constant:g0 / ship:availablethrust.
    } else {
      set thr to 0.
    }
  }
}
function circ {
  set apVel to sqrt(body:mu*((2/(apoapsis+body:radius))-(1/ship:obt:semimajoraxis))).
  set circSMA to (apoapsis+body:radius).
  set circApVel to sqrt(body:mu*((2/(apoapsis+body:radius))-(1/circSMA))).
  set dv to circApVel - apVel.
  set mnv to node(time:seconds+ship:obt:eta:apoapsis,0,0,dv).
  sas off.
  perform(mnv).
}


function autoStage {
  list engines in eggs.
  for egg in eggs {
    if egg:flameout and stage:ready {
      stage.
    }
  }
}
function perform {
  parameter nde.
  lock steering to nde:deltav.
  wait until vang(ship:facing:vector,nde:deltav) <= 0.2.
  warpto(nde:time-addons:ke:nodeHalfBurnTime-5).
  wait until nde:eta-addons:ke:nodeHalfBurnTime <= 0.
  set thr to list(1,0.5,0.25,0.1).
  for per in thr {
    if thr = 0.25 and nde:deltav:mag < ship:stagedeltav(ship:stagenum) and stage:ready {stage.}
    lock throttle to per.
    until nde:deltav:mag < per {
      autoStage().
    }
  }
  remove nde.
}

main().