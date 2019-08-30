%%% Calling script

ImageSize = [768, 768];
raw = 1-(mean(imread('smiley.jpg'),3)./255);
% raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);
% load('spot64.mat');
% targetImage = complex(spot);

%  imageSizeX = 768;
%  imageSizeY = 768;
%  targetImage = circle(imageSizeX,imageSizeY);

TotalIterations = 100;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

TotalLoops = 100;
Performance = NaN(TotalIterations,TotalLoops);
ElapsedTimeVector = zeros(1,TotalLoops);
hologramStack = zeros([ImageSize,TotalLoops]);
imageStack = zeros([ImageSize, TotalLoops]);
iterTimings = zeros([TotalIterations, TotalLoops]);
% DMDnumArray = zeros(size(targetImage));
for index= 1: TotalLoops %size(targetImage,3)
%     tic
    SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
    hologramInputIn = hologramInputSLM(SLM,InputField);
    
   %[TargetEstimate,RMSEtargetEst, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage(:,:,index), ImageSize);
    [ApproxTargetI,RMSEtargetEst, hologram, elapsedIterTime] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize); %phase analysis
     %DMDnumArray(:,:,index) = DMDnum;
    Performance(:,index) = RMSEtargetEst;
%     hologramStack(:,:,index) = DMDnum;
    hologramStack(:,:,index) = hologram;
%     imageStack(:,:,index) = TargetEstimate;
    imageStack(:,:,index) = ApproxTargetI;
    iterTimings(:,index) = elapsedIterTime;
    
%     elapsed_time = toc;
%     ElapsedTimeVector(index) = elapsed_time;
    disp([num2str(index)]) %,' Elapsed Time = ',num2str(elapsed_time)])
end
XCoords = (1:TotalIterations)'*ones(1,TotalLoops);
averagedImage = mean(imageStack, 3);
meanIterTimings = mean(iterTimings(5,:));

trim = [384,384];
trimTargetImage = targetImage(1:trim,1:trim);
TrimtargetImageNorm = (trimTargetImage - mean(trimTargetImage(:)))./std(trimTargetImage(:)); 

trimAverImage = averagedImage(1:trim,1:trim);
trimAverImageNorm = (trimAverImage - mean(trimAverImage(:)))./std(trimAverImage(:));

RMSEaverImage = sqrt(mean(((trimAverImageNorm(:) - TrimtargetImageNorm(:)).^2)));
%% Plot results
figure(1);
XCoords = (1:TotalIterations)'*ones(1,TotalLoops);
scatter(XCoords(:),Performance(:))
xlabel('Iteration')
ylabel('RMSE')
title('RMSE of 100 loops of 100 iterations')

figure(2);
plot(ElapsedTimeVector);
title('Time of each loop')
xlabel('Loop')
ylabel('time (s)')

% for index = 1:size(DMDnumArray,3)
%     figure(1)
%     imagesc(DMDnumArray(:,:,index))
%     axis image
%     figure(2)
%     hol = abs(fftshift(fft2(DMDnumArray(:,:, index))));
%     hol(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;
%     imagesc(hol)
%     axis image
%     drawnow
% end
%% Save data

% fileHandle = fopen('ExsmallSmileyStack.bin', 'w');
% fwrite(fileHandle, uint8(DMDnumArray), 'uint8');
% fclose(fileHandle);

%imwrite(DMDnumArray,'ExsmallSmiley.png')

%   save('5iter5loopspot64.mat', 'XCoords', 'Performance', 'iterTimings',...
%       'TargetEstimate', 'hologramStack', 'imageStack', 'iterTimings', 'averagedImage', 'RMSEaverImage','meanIterTimings');

% save('100iter100loopSmiley.mat', 'XCoords', 'Performance', 'iterTimings',...
%        'ApproxTargetI', 'hologramStack', 'imageStack', 'iterTimings', 'averagedImage', 'RMSEaverImage','meanIterTimings');

%  save('Spot5iter100loopAveraged.mat', 'averagedImage', 'RMSEaverImage', 'XCoords', 'hologramStack', 'imageStack', 'Performance', 'iterTimings', 'meanIterTimings')