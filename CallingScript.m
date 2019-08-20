%%% Calling script

ImageSize = [768, 768];
%raw = 1-(mean(imread('smiley.jpg'),3)./255);
%raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
%targetImage = targetImageFunc(ImageSize,raw);
 imageSizeX = 768;
 imageSizeY = 768;
 targetImage = circle(imageSizeX,imageSizeY);

% figure(1);
% subplot(2,2,1);
% imagesc(abs(targetImage));
% title('Target Image')
% xlabel('Pixel')
% ylabel('Pixel')

TotalIterations = 10;

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
%DMD = randi([0,1],ImageSize);  % DMD is now binary, 0 or pi
%DMD = ones(ImageSize)*pi;
%hologramInputIn = hologramInputDMD(DMD,InputField);

 
TotalLoops = 1;
Performance = NaN(TotalIterations,TotalLoops);
ElapsedTimeVector = zeros(1,TotalLoops);
hologramStack = zeros([ImageSize,TotalLoops]);
DMDnumArray = zeros(size(targetImage));
for index= 1:size(targetImage,3) %TotalLoops
    tic

    hologramInputIn = hologramInputSLM(SLM,InputField);
    
    [TargetEstimate,RMSEtargetEst, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage(:,:,index), ImageSize);
    %[TargetEstimate,RMSEtargetEst, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize);
    DMDnumArray(:,:,index) = DMDnum;
    %Performance(:,index) = RMSEtargetEst;
    %hologramStack(:,:,index) = DMDnum;
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

% figure(1)
% subplot(2,2,2);
% %imagesc(ApproxTargetI)
% imagesc(TargetEstimate)
% title('Approximate Target')
% xlabel('Pixel')
% ylabel('Pixel')
% 
% subplot(2,2,3)
% plot(RMSEtargetEst)
% title('Performance')
% xlabel('Iteration')
% ylabel('RMSE')
% 
% subplot(2,2,4);
% imagesc(DMDnum)
% title('Hologram')
% xlabel('Pixel')
% ylabel('Pixel')

for index = 1:size(DMDnumArray,3)
    figure(1)
    imagesc(DMDnumArray(:,:,index))
    axis image
    figure(2)
    hol = abs(fftshift(fft2(DMDnumArray(:,:, index))));
    hol(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;
    imagesc(hol)
    axis image
    drawnow
end
%% Save data

fileHandle = fopen('smallMovingDot.bin', 'w');
fwrite(fileHandle, uint8(DMDnumArray), 'uint8');
fclose(fileHandle);

%save('50iter100loopLogo.mat', 'XCoords', 'Performance', 'ElapsedTimeVector', 'TargetEstimate', 'hologramStack');