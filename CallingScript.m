%%% Calling script

ImageSize = [768, 768];
raw = 1-(mean(imread('smiley.jpg'),3)./255);
%raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);

figure(1);
subplot(2,2,1);
imagesc(abs(targetImage));
title('Target Image')
xlabel('Pixel')
ylabel('Pixel')

TotalIterations = 100;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
%DMD = randi([0,1],ImageSize);  % DMD is now binary, 0 or pi
%DMD = ones(ImageSize)*pi;
%hologramInputIn = hologramInputDMD(DMD,InputField);

 
TotalLoops = 1;
Performance = NaN(TotalIterations,TotalLoops);
ElapsedTimeVector = zeros(1,TotalLoops);
for index= 1:TotalLoops
    tic

    hologramInputIn = hologramInputSLM(SLM,InputField);
    
    [TargetEstimate,RMSEtargetEst, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize);
    Performance(:,index) = RMSEtargetEst;
    elapsed_time = toc;
    ElapsedTimeVector(index) = elapsed_time;
    disp([num2str(index),' Elapsed Time = ',num2str(elapsed_time)])
end

%% Plot results
% figure(1);
% XCoords = (1:TotalIterations)'*ones(1,TotalLoops);
% scatter(XCoords(:),Performance(:))
% xlabel('Iteration')
% ylabel('RMSE')
% title('RMSE of 100 loops of 5 iterations')
% 
% figure(2);
% plot(ElapsedTimeVector);
% title('Time of each loop')
% xlabel('Loop')
% ylabel('time (s)')

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
imagesc(DMDnum)
title('Hologram')
xlabel('Pixel')
ylabel('Pixel')

%% Save data

fileHandle = fopen('smileyHologram64.bin', 'w');
fwrite(fileHandle, uint8(DMDnum), 'uint64');
fclose(fileHandle);