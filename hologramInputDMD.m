%DMD
function hologramInputIn = hologramInputDMD(DMD,InputField)


hologramInputIn = (InputField.*exp(1i*DMD));
end
