if ship:status = "PRELAUNCH" {
  set debug to False.
  if debug { core:doevent("Open Terminal"). }
  set terminal:width to 75.
  runoncepath("0:/rocketAscent.ks").
  runOncePath("0:/libs/space.ks").
  clearScreen.
  ascendKerbin(80).
  if debug { core:doevent("Close Terminal"). }
}

spacegui().