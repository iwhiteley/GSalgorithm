%%% Calling script

ImageSize = [768, 768];
%raw = imread('smiley.jpg');
raw = 1-(mean(imread('smiley.jpg'),3)./255);
%raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);

x_axis_labels={'Pixel', 'Pixel','', 'Pixel'};
y_axis_labels = {'Pixel', 'Pixel', 'Iteration', 'Pixel'};

figure(1);
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


loopnum = 0;
finalLoop = 100;

% while (loopnum < finalLoop)
% [ApproxTargetI,RMSE, hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage);
% DMD = hologram>0; % HACK - logical TRUE = 1
% DMDnum = double(DMD);
%
% TargetEstimate = abs(fftshift(fft2(InputField.*DMDnum)));
% TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;
%
% loopnum = loopnum +1 ;
%
% trimTargetEstimate = TargetEstimate(1:trim,1:trim);
% trimTargetEstimateNorm = (trimTargetEstimate - mean(trimTargetEstimate(:)))./std(trimTargetEstimate(:));
%
% RMSEtargetEst(loopnum) = sqrt(mean(((trimTargetEstimateNorm(:) - TrimtargetImageNorm(:)).^2)));
% end

TotalLoops = 1;
Performance = NaN(TotalIterations,TotalLoops);
for index= 1:TotalLoops
    SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
    hologramInputIn = hologramInputSLM(SLM,InputField);
    
    
    [TargetEstimate,RMSEtargetEst, hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize);
    Performance(:,index) = RMSEtargetEst;
end

%% Plot results
figure(2);
XCoords = (1:TotalIterations)'*ones(1,TotalLoops);
scatter(XCoords(:),Performance(:))

figure(1)
subplot(2,2,2);
%imagesc(ApproxTargetI)
imagesc(TargetEstimate)
title('Approximate Target')
xlabel('Pixel')
ylabel('Pixel')

subplot(2,2,3)
plot(RMSEtargetEst)
title('Performance')
xlabel('Iteration')
ylabel('RMSE')

subplot(2,2,4);
imagesc(hologram)
title('Hologram')
xlabel('Pixel')
ylabel('Pixel')

% figure;
% plot(RMSEtargetEst)
% title('RMSE target vs Amplitude Hol')
% xlabel('Iteration')
% ylabel('RMSE')


% RMSEvector = [RMSE,RMSEtargetEst];
%
% figure;
% plot(RMSEvector)
% title('Performance quality of hologram')
% xlabel('Iteration')
% ylabel('RMSE')