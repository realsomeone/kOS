if ship:status = "PRELAUNCH" {
  set debug to true.
  if debug { core:doevent("Open Terminal"). }
  set terminal:width to 75.
  set terminal:height to 35.
  runoncepath("0:/boostBack.ks").
  clearScreen.
  wait until not core:messages:empty.
  core:messages:clear.
  core:part:ship:connection:sendmessage(core:part:decoupledin).
  wait until not core:messages:empty.
  print("ya mi gente").
}

local ends is list().
local engs is 0.
local childs is core:part:children.
list engines in engs.

findEnds(childs,ends).
for eng in engs {
  if not childs:find(eng) = -1 {
    childengs:add(eng).
  }
}

if not (ship:parts:length < 70) {
  wait until childengs[0]:ignition.
  wait until stage:deltav:current < 700.
  stage.
} 
print stage:resourceslex["LIQUIDFUEL"].
boostBack().

function findEnds {
  parameter part, plist.
  for child in childs{ 
    // check is tiene, si no, [add to ends]
    print "hmmm".
  }
}