set debug to false.
if debug { core:doevent("Open Terminal"). }
set terminal:width to 75.
set terminal:height to 35.
runoncepath("0:/boostBack.ks").
clearScreen.

if not (ship:parts:length < 70) {
 wait until stage:number = 3.
  wait until stage:deltav:current < 700.
  stage.
} 
boostBack().