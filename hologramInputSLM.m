

function [hologramInput,targetImage] = hologramInputSLM(SLM,ImageSize)


targetImage = complex(zeros(ImageSize));
targetImage(20:50, 20:50) = 1+1i;
targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

figure(1)
imagesc(abs(targetImage))

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

hologramInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM



end
