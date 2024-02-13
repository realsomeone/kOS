runOncePath("0:/PlaneAscent.ks").

if ship:status = "PRELAUNCH" {
  local debug is false.
  brakes on.
  if debug { core:doevent("Open Terminal"). }.
  clearScreen.
  sortEngs().
  flyToKerbinOrbit(120).
}

function sortEngs {
  global AB is list().
  global SE is list().
  local engs is 0.
  list engines in engs.
  for eng in engs {
    if eng:multimode { set eng:autoswitch to false. AB:add(eng). }
    else { SE:add(eng). }
  }
}

spacegui().