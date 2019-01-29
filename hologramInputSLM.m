

function hologramInput = hologramInputSLM(SLM, ImageSize, InputField);

ImageSize = [128, 128];

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; % Here's where the problem is - I defined the phase from 0-2pi, not -pi to pi
hologramInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM

% targetImage = complex(zeros(ImageSize));
% targetImage(20:50, 20:50) = 1+1i;
% targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));
end
