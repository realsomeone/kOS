runOncePath("0:/libs/lib.ks").
set apScreen to gui(200).
local title is apScreen:addlabel("Congrats! You're in space!").
set title:style:align to "CENTER".
set title:style:font to "dotty".
local buttn is apScreen:addbutton("Execute next manuever").
set buttn:onclick to doMnv@.
set apScreen:x to -400.
set apScreen:y to 1080 / 3.
apScreen:show.
wait until False.