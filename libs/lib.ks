function sma {
  parameter p1, p2.
  return (p1+p2)/2.
}

function TTWR {
  parameter TWR.
  return TWR * ship:mass * (body:mu / body:position:sqrmagnitude) / max(ship:availablethrust,0.01).
}
function doMnv {
  sas off.
  local mnv is nextNode.
  local ogVec is mnv:deltav:vec.
  lock steering to mnv:burnvector.
  wait until vang(ship:facing:vector,mnv:burnvector) < 2.
  local stTime is mnv:time - addons:ke:nodeHalfBurnTime.
  warpto(stTime - 5).
  wait until time:seconds > stTime.
  lock throttle to 1.
  wait until mnv:deltav:mag < 0.5.
  unlock steering.
  sas on.
  wait until vang(mnv:deltav,ogVec) > 5.
  unlock throttle.
  remove mnv.
}

function vecToYaw {
  parameter inVec.
  local eVec is vCrs(ship:up:vector,ship:north:vector).
  local eComp is vdot(eVec,inVec).
  local nComp is vdot(ship:north:vector,inVec).
  return arctan2(eComp,nComp).
}

function getTo {
  parameter place.
  addons:astrogator:create(place).
  doMnv().
  doMnv().
  lock steering to prograde.
  until ship:body = place {
    wait ship:obt:nextpatcheta + 1.
  }
  set warp to 0.
  addons:astrogator:create(place).
  doMnv().
}

function land {
  lock steering to srfRetrograde.
  lock sbCount to addons:ke:suicideBurnCountdown.
  wait until sbCount < 0.
  lock throttle to (-(sbCount/2)+1).
  wait until ship:airspeed < 30.
  gear on.
  set TWR to 1.
  lock throttle to TTWR(TWR).
  wait until alt:radar < 50.
  set TWR to 3.
  wait until ship:airspeed < 3.
  lock steering to up.
  set TWR to 1.
  wait until verticalSpeed < 1.
  set TWR to 0.9.
  lock steering to surface_normal(ship:geoposition).
  wait until ship:status = "LANDED".
  unlock steering.
  set ship:control:pilotmainthrottle to 0.
  unlock throttle.
}

FUNCTION slope_calculation {//returns the slope of p1 in degrees
	PARAMETER p1.
	LOCAL upVec IS (p1:POSITION - p1:BODY:POSITION):NORMALIZED.
	RETURN VANG(upVec,surface_normal(p1)).
}

FUNCTION surface_normal {
	PARAMETER p1.
	LOCAL localBody IS p1:BODY.
	LOCAL basePos IS p1:POSITION.

	LOCAL upVec IS (basePos - localBody:POSITION):NORMALIZED.
	LOCAL northVec IS VXCL(upVec,LATLNG(90,0):POSITION - basePos):NORMALIZED * 3.
	LOCAL sideVec IS VCRS(upVec,northVec):NORMALIZED * 3.//is east

	LOCAL aPos IS localBody:GEOPOSITIONOF(basePos - northVec + sideVec):POSITION - basePos.
	LOCAL bPos IS localBody:GEOPOSITIONOF(basePos - northVec - sideVec):POSITION - basePos.
	LOCAL cPos IS localBody:GEOPOSITIONOF(basePos + northVec):POSITION - basePos.
	RETURN VCRS((aPos - cPos),(bPos - cPos)):NORMALIZED.
}