if ship:status = "PRELAUNCH" {
  set debug to true.
  if debug { core:doevent("Open Terminal"). }
  set terminal:width to 75.
  runoncepath("0:/rocketAscent.ks").
  runOncePath("0:/libs/space.ks").
  clearScreen.
  local cores is ship:partstagged("booster").
  if cores:length > 0 {
    local nums is list().
    for c in cores {
      set c to c:getmodule("kOSProcessor"):connection.
      c:sendmessage("manda pls").
      wait until not ship:messages:empty.
      nums:add(ship:messages:pop():content).
    }
    if nums:length = 1 {
      cores[0]:getmodule("kOSProcessor"):connection:sendmessage("unico").
    }
  }
  ascendKerbin(80).
  if debug { core:doevent("Close Terminal"). }
}

spacegui().