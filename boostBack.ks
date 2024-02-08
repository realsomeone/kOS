runoncepath("0:/libs/lib.ks").
lock spot to Kerbin:GEOPOSITIONLATLNG(-0.0972240138604864,-74.5576754725165):position.
function boostBack {
  if not (kuniverse:activevessel = ship) { wait until False. }.
  wait until addons:tr:hasimpact.
  lock landPos to addons:tr:impactpos:position.
  lock landErr to landPos - spot.
  local eVec is vCrs(ship:up:vector,ship:north:vector).
    // set totErr to vecDraw().
    // set totErr:color to red. 
    // set totErr:vecupdater to { return landErr. }.
    // set totErr:startupdater to { return spot. }.
    // set totErr:show to true.
  lock throttle to 0.
  rcs on.
  brakes off.
  sas on.  
  wait until ship:verticalspeed < 200.
  sas off.
  lock steering to heading(vecToYaw(srfRetrograde:vector),0).
  wait until vang(heading(vecToYaw(srfRetrograde:vector),0):vector,ship:facing:vector) < 5.
  wait 3.
  lock throttle to 1.
  unlock steering.
  sas on.
  wait until vang(srfPrograde:vector, ship:facing:vector) < 90.
  lock vErr to vdot(landErr,eVec).
  wait until vErr < 250.
  unlock vErr.
  unlock throttle.
  set ship:control:pilotmainthrottle to 0.
  wait until ship:verticalSpeed < -150.
  sas off.
  lock steering to srfRetrograde.
  brakes on. 
  wait until vang(ship:facing:vector,srfRetrograde:vector) < 5 and ship:angularvel:mag < 0.1.
  rcs off.
  land().
}