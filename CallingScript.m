%%% Calling script

ImageSize = [128, 128];
targetImage = complex(zeros(ImageSize));
targetImage(20:50, 20:50) = 1+1i;
targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

figure(1)
imagesc(abs(targetImage))

% iteration = 0;
TotalIterations = 100;
% Performance = zeros(1,TotalIterations);

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; 
DMD= randi([0,1],ImageSize)*2*pi - pi;

% hologramInputIn = hologramInputSLM(SLM, InputField);
% hologramInputIn = hologramInputDMD(DMD,InputField);
hologramInputIn = hologramInputSLM(SLM,InputField);
hologramInput= device(hologramInputIn);

[ApproxTargetI,Performance] = GSalgorithm(hologramInput,InputField, TotalIterations, targetImage);


figure(2)
imagesc(ApproxTargetI)

figure(3)
plot(Performance)