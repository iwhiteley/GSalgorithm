%%% Calling script

ImageSize = [768, 768];
raw = 1-(mean(imread('smiley.jpg'),3)./255);
% raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);
% load('spot96.mat');
% targetImage = complex(spot);

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.

TotalIterations = 5;
TotalLoops = 100;
Averages = 100;

MetaRMSE = zeros(TotalLoops,Averages);

for in= 1: Averages
    Performance = NaN(TotalIterations,TotalLoops);
    ElapsedTimeVector = zeros(1,TotalLoops);
    hologramStack = zeros([ImageSize,TotalLoops]);
    imageStack = zeros([ImageSize, TotalLoops]);
    iterTimings = zeros([TotalIterations, TotalLoops]);
    RMSEaverImage = zeros(1,TotalLoops);
    tic
    for index= 1: TotalLoops
        SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
        hologramInputIn = hologramInputSLM(SLM,InputField);
        
        %     [ApproxTargetI,RMSEtargetEst, hologram, elapsedIterTime] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize); %phase analysis
        [TargetEstimate,RMSEtargetEst, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize);
        Performance(:,index) = RMSEtargetEst;
        hologramStack(:,:,index) = DMDnum;
        imageStack(:,:,index) = TargetEstimate;
        %     hologramStack(:,:,index) = hologram; %for phase
        %     imageStack(:,:,index) = ApproxTargetI; %for phase
%         iterTimings(:,index) = elapsedIterTime;
        
        trim = size(TargetEstimate)/2;
        trimTargetImage = targetImage(1:trim,1:trim);
        TrimtargetImageNorm = (trimTargetImage - mean(trimTargetImage(:)))./std(trimTargetImage(:));
        averagedImage = mean(imageStack(:,:,1:index), 3);
        trimAverImage = averagedImage(1:trim,1:trim);
        trimAverImageNorm = (trimAverImage - mean(trimAverImage(:)))./std(trimAverImage(:));
        
        RMSEaverImage(index) = sqrt(mean(((trimAverImageNorm(:) - TrimtargetImageNorm(:)).^2)));
    end
    MetaRMSE(:,in) = RMSEaverImage;
    Time = toc;
    disp([num2str(in),' time ', num2str(Time)])
end
finalAveragedLogoRMSE = MetaRMSE(end, :);
meanFinalAveragedLogoRMSE = mean(finalAveragedLogoRMSE);
SEMfinalAveragedLogoRMSE = std(finalAveragedLogoRMSE)/sqrt(length(finalAveragedLogoRMSE));

XCoordinates = (1:TotalLoops)'*ones(1,Averages);
figure(1);
scatter(XCoordinates(:),MetaRMSE(:))
xlabel('Averages')
ylabel('RMSE')
title('')
save('100_100_5averagedSmiley.mat', 'MetaRMSE', 'finalAveragedLogoRMSE','meanFinalAveragedLogoRMSE', 'SEMfinalAveragedLogoRMSE', 'XCoordinates')

%% Plot results
% figure(1);
% XCoords = (1:TotalIterations)'*ones(1,TotalLoops);
% scatter(XCoords(:),Performance(:))
% xlabel('Iteration')
% ylabel('RMSE')
% title('RMSE of 100 loops of 100 iterations')

% figure(2);
% plot(ElapsedTimeVector);
% title('Time of each loop')
% xlabel('Loop')
% ylabel('time (s)')

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

%   save('5iter100loopSpot96.mat', 'XCoords', 'Performance', 'iterTimings',...
%       'TargetEstimate', 'hologramStack', 'imageStack', 'iterTimings', 'averagedImage', 'RMSEaverImage','meanIterTimings');

% save('100iter100loopLogoPhase.mat', 'XCoords', 'Performance', 'iterTimings',...
%        'ApproxTargetI', 'hologramStack', 'imageStack', 'iterTimings', 'averagedImage', 'RMSEaverImage','meanIterTimings');

%  save('Spot5iter100loopAveraged.mat', 'averagedImage', 'RMSEaverImage', 'XCoords', 'hologramStack', 'imageStack', 'Performance', 'iterTimings', 'meanIterTimings')