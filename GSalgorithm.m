%%% Gerchberg saxton
function [TargetEstimate,RMSEtargetEst, DMDnum, elapsedIterTime] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize)
iteration = 0;

RMSEtargetEst = zeros(1,TotalIterations);
for index = 1: TotalIterations
 
   tic
    TargetPl = fftshift(fft2(hologramInputIn));   
    
    ApproxTargetI = abs(TargetPl).^2;
    ApproxTargetI(ApproxTargetI > 10^10)=0;  %trying to mask centre pixels

    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(ifftshift(NewTarget));
    
    %SLM, works well
    hologram = angle(ApproxSourceAmp);
    
    hologramInputIn = (InputField.*exp(1i*hologram)); % for SLM --- phase hologram
    
    DMD = hologram>0; % HACK - logical TRUE = 1
    DMDnum = double(DMD);
 
    TargetEstimate = abs(fftshift(fft2(InputField.*DMDnum)));
    TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0; %last loop for amplitude hologram
%    iterTime = toc;
%    elapsedIterTime(index) = iterTime;
    iteration = iteration +1;
    
%     trim = size(ApproxTargetI)/2;
%     trimApproxTarget = ApproxTargetI(1:trim,1:trim); %phase hologram image
%     trimTargetImage = targetImage(1:trim,1:trim); %target image
%     TrimApproxTargetNorm = (trimApproxTarget - mean(trimApproxTarget(:)))./std(trimApproxTarget(:));
%     TrimtargetImageNorm = (trimTargetImage - mean(trimTargetImage(:)))./std(trimTargetImage(:));
    
%     trimTargetEstimate = TargetEstimate(1:trim,1:trim); % amplitude hologram image
%     trimTargetEstimateNorm = (trimTargetEstimate - mean(trimTargetEstimate(:)))./std(trimTargetEstimate(:)); %amplitude hologram image normalised
 
%    RMSEtargetEst(iteration) = sqrt(mean(((trimTargetEstimateNorm(:) - TrimtargetImageNorm(:)).^2))); %RMSE of amplitude hologram image vs target image
%     RMSEtargetEst(iteration) = sqrt(mean(((TrimApproxTargetNorm(:) - TrimtargetImageNorm(:)).^2))); % RMSE of phase hologram
end
end
