%DMD
function [hologramInput] = hologramInputDMD(ImageSize,InputField)

DMD= randi([0,1],ImageSize)*2*pi - pi;
hologramInput = (InputField.*exp(1i*DMD));
end
