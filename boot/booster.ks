set debug to true.
if debug { core:doevent("Open Terminal"). }
set terminal:width to 75.
set terminal:height to 35.
runoncepath("0:/boostBack.ks").
clearScreen.
if ship:parts:length < 70 {
  boostBack().
} else {
  wait until stage:number = 3.
  wait until stage:deltav:current < 750.
  stage.
}
