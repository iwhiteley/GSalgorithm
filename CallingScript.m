%%% Calling script

ImageSize = [128, 128];
targetImage = targetImageFunc(ImageSize);

figure;
%figure(1)
subplot(2,2,1);
imagesc(abs(targetImage));
title('targetImage')

TotalIterations = 100;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; 

% mybin = [0,pi];
% pos= randi([1,2]);%,ImageSize);%*2*pi - pi;
% DMD = mybin(pos);

DMD = randi([0,1],ImageSize)*2*pi-pi;

hologramInputIn = hologramInputDMD(DMD,InputField);
%hologramInputIn = hologramInputSLM(SLM,InputField);
%hologramInput= device(hologramInputIn);

[ApproxTargetI,Performance] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage);


%figure(2)
subplot(2,2,2);
imagesc(ApproxTargetI)
title('Approx Target')

%figure(3)
subplot(2,2,[3,4])
plot(Performance)
title('Performance')