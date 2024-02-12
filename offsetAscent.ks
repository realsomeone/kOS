runOncePath("0:/rocketAscent.ks").
runOncePath("0:/libs/util.ks").

function CenterOfThrust {
  local engs is getActivEngs().
  local tthrust is 0.
  local CoT is 0.
  local tVec is 0.
  for eng in engs {
    set tthrust to tthrust + eng:thrust.
  }
  if tthrust = 0 { return list(v(0,0,0),v(0,0,0)). }.
  for eng in engs {
    set CoT to CoT + (eng:position + (eng:thrust/tthrust)).
    local eDir is -eng:facing:vector.
    set eDir:mag to eng:thrust.
    set tVec to tVec + eDir.
  }
  return list(CoT,tVec).

}