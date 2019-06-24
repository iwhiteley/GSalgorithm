%%% Calling script

ImageSize = [768, 768];
raw = imread('smiley2.png');
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

TotalIterations = 100;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; 

DMD = randi([0,1],ImageSize)*pi;  % DMD is now binary, 0 or pi
%DMD = ones(ImageSize)*pi;
hologramInputIn = hologramInputDMD(DMD,InputField);
%hologramInputIn = hologramInputSLM(SLM,InputField);

[ApproxTargetI,Performance, hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage);


subplot(2,2,2);
imagesc(ApproxTargetI)
title('Approximate Target')
xlabel('Pixel')
ylabel('Pixel')

subplot(2,2,3)
plot(Performance)
title('Performance')
xlabel('')
ylabel('Iteration')

subplot(2,2,4);
%imagesc(ApproxTargetI(400:600,1:100))
imagesc(hologram)
title('Hologram')
xlabel('Pixel')
ylabel('Pixel')