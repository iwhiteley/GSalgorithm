%%% Calling script

ImageSize = [768, 768];
%raw = imread('smiley.jpg');
raw = 1-(mean(imread('smiley.jpg'),3)./255);
%raw = imread('neurons_in_dish_grayscale_no_background.png');
targetImage = targetImageFunc(ImageSize,raw);

x_axis_labels={'Pixel', 'Pixel','', 'Pixel'};
y_axis_labels = {'Pixel', 'Pixel', 'Iteration', 'Pixel'};

figure;
subplot(2,2,1);
imagesc(abs(targetImage));
title('Target Image')
xlabel('Pixel')
ylabel('Pixel')

TotalIterations = 10;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; 

%DMD = randi([0,1],ImageSize);  % DMD is now binary, 0 or pi
%DMD = ones(ImageSize)*pi;
%hologramInputIn = hologramInputDMD(DMD,InputField);
hologramInputIn = hologramInputSLM(SLM,InputField);

[ApproxTargetI,RMSE, hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage);
DMD = hologram>0; % HACK - logical TRUE = 1
TargetEstimate = abs(fftshift(fft2(InputField.*DMD)));
TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;

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
%ylim([0.2,1])

subplot(2,2,4);
%imagesc(ApproxTargetI(400:600,1:100))
imagesc(DMD)
title('Hologram')
xlabel('Pixel')
ylabel('Pixel')

