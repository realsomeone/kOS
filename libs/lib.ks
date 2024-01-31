function sma {
  parameter p1, p2.
  return (p1+p2)/2.
}

function doMnv {
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
  remove mnv.
}

function vecToYaw {
  parameter inVec.
  local eVec is vCrs(ship:up:vector,ship:north:vector).
  local eComp is vdot(eVec,inVec).
  local nComp is vdot(ship:north:vector,inVec).
  return arctan2(eComp,nComp).
}
