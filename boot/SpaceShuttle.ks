if ship:status = "PRELAUNCH" {
  set brain to ship:partstagged("controlpoint")[0].
  set hinge to ship:partstagged("hinge")[0]:getmodulebyindex(0).
  brain:controlfrom.
  local debug is false.
  if debug { core:doevent("Open Terminal"). }.
  clearScreen.
}

runOncePath("0:/offsetAscent.ks").

// when defined roll then {
//   set roll to ship:body:position.
// }

lock CoT to CenterOfThrust().
lock look to ship:facing:vector.
lock vec1 to nVec(v(0,0,0),-CoT[0]:normalized * 20,blue).
lock vec2 to nVec(v(0,0,0),ship:facing:vector:normalized * 20,red).

when not ship:status = "PRELAUNCH" then {
  until False {
    local angle is vang(look,CoT[0]).
    local dir is vcrs(look,CoT[0]).
    if vang(ship:facing:starvector,dir) > 90 {
      set angle to -angle.
    }
    local currHinge is hinge:getfield("Target Angle").
    hinge:setfield("Target Angle",currHinge + angle).
  }
}

if ship:status = "PRELAUNCH" {
  ascendKerbin(120).
}

spacegui().