%%% Calling script

ImageSize = [768, 768];
%raw = imread('smiley.jpg');
raw = 1-(mean(imread('smiley.jpg'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);

x_axis_labels={'Pixel', 'Pixel','', 'Pixel'};
y_axis_labels = {'Pixel', 'Pixel', 'Iteration', 'Pixel'};

figure;
subplot(2,2,1);
imagesc(abs(targetImage));
title('Target Image')
xlabel('Pixel')
ylabel('Pixel')

TotalIterations = 5;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; 

%DMD = randi([0,1],ImageSize);  % DMD is now binary, 0 or pi
%DMD = ones(ImageSize)*pi;
%hologramInputIn = hologramInputDMD(DMD,InputField);
hologramInputIn = hologramInputSLM(SLM,InputField);

loopnum = 0;
finalLoop = 10;

while (loopnum < finalLoop)
[ApproxTargetI,RMSE, hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage);
DMD = hologram>0; % HACK - logical TRUE = 1
DMDnum = double(DMD);

TargetEstimate = abs(fftshift(fft2(InputField.*DMDnum)));
TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;

trimTargetEstimate = TargetEstimate(1:trim,1:trim);
trimTargetEstimateNorm = (trimTargetEstimate - mean(trimTargetEstimate(:)))./std(trimTargetEstimate(:));

RMSEtargetEst(loopnum) = sqrt(mean(((trimTargetEstimateNorm(:) - TrimtargetImageNorm(:)).^2)));
end

subplot(2,2,2);
%imagesc(ApproxTargetI)
imagesc(TargetEstimate)
title('Approximate Target')
xlabel('Pixel')
ylabel('Pixel')

subplot(2,2,3)
plot(RMSE)
title('Performance')
xlabel('Iteration')
ylabel('RMSE')

subplot(2,2,4);
imagesc(DMD)
title('Hologram')
xlabel('Pixel')
ylabel('Pixel')

figure(2)
plot(RMSEtargetEst)