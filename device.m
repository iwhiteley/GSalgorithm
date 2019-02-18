function hologramInput = device(hologramInputIn)

if hologramInputIn == hologramInputSLM(SLM,InputField)
    %call holograminputSLM function
    %deviceSelect = 
    hologramInput = hologramInputSLM(SLM,InputField);
    
elseif hologramInputIn == hologramInputDMD(DMD,InputField)
    %call holograminputDMD function
    hologramInput = hologramInputDMD(DMD,InputField);
end 

end

