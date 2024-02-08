sas off.
rcs off.
runoncepath("0:/rocketAscent.ks").
if ship:status = "PRELAUNCH" { 
  local debug is False.
  if debug { core:doevent("Open Terminal"). }
  clearScreen.
  ascendKerbin(80).
  getTo(mun).
}

land().