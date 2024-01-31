copyPath("0:/detachTank.ks","").
copypath("0:/rocketAscent.ks","").
run rocketAscent.
set initPitch to 80.
clearScreen.
precheck(100).
begin().
startAscent().
verifyAP().
circPrep().
if not (stage:deltav:current >= burn:deltav:mag) {
  run detachTank.
  set tankoff to true.
} else {
  toggle ag1.
  set tankoff to false.
}
if tankoff {
  mnvAlt().
} else {
  doMnv().
}
if not tankoff {
  toggle ag2.
  lock steering to prograde:vector.
  wait until vang(facing:vector,prograde:vector) < 1.
  run detachTank.
}
unlock steering.
unlock throttle.