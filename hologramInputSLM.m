%SLM
function hologramInputIn = hologramInputSLM(SLM,InputField)

hologramInputIn = (InputField.*exp(1i*SLM)); % Add the phase to the SLM

end
