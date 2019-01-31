%SLM
function hologramInput = hologramInputSLM(SLM,InputField)

hologramInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM

end
