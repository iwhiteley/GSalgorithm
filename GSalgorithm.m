%%% Gerchberg saxton
function [TargetEstimate,RMSEtargetEst,hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize)
iteration = 0;

RMSEtargetEst = zeros(1,TotalIterations);

while (iteration < TotalIterations) 
   
    TargetPl = fftshift(fft2(hologramInputIn));   
    
    ApproxTargetI = abs(TargetPl).^2;
    ApproxTargetI(ApproxTargetI > 10^10)=0;  %trying to mask centre pixels

    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(ifftshift(NewTarget));
    
    %SLM, works well
    hologram = angle(ApproxSourceAmp);
    
   
%     %DMD binary phase
%     hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi));
%     threshold = 0;
%     hologram(hologram > threshold) = pi;
%     hologram(hologram <= threshold) = 0;
    
    %DMD binary amplitude
    %hologram = ApproxSourceAmp*256/(2*pi)/(256/(2*pi)); %here hologram = approxsourceamp, makes no difference
    %hologram = angle(ApproxSourceAmp);
    %hologram = ApproxSourceAmp;
    %threshold = 0;
    %hologram(hologram > threshold) = pi;
    %hologram(hologram <= threshold) = 0;
    
    hologramInputIn = (InputField.*exp(1i*hologram)); % for SLM
    %hologramInputIn = complex((InputField.*(hologram./pi))); % for DMD
    
    DMD = hologram>0; % HACK - logical TRUE = 1
    DMDnum = double(DMD);
 
    TargetEstimate = abs(fftshift(fft2(InputField.*DMDnum)));
    TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0;
    
    iteration = iteration +1;
    
    trim = size(ApproxTargetI)/2;
    trimApproxTarget = ApproxTargetI(1:trim,1:trim);
    trimTargetImage = targetImage(1:trim,1:trim);
    TrimApproxTargetNorm = (trimApproxTarget - mean(trimApproxTarget(:)))./std(trimApproxTarget(:));
    TrimtargetImageNorm = (trimTargetImage - mean(trimTargetImage(:)))./std(trimTargetImage(:));
    
    trimTargetEstimate = TargetEstimate(1:trim,1:trim);
    trimTargetEstimateNorm = (trimTargetEstimate - mean(trimTargetEstimate(:)))./std(trimTargetEstimate(:));
 
    RMSEtargetEst(iteration) = sqrt(mean(((trimTargetEstimateNorm(:) - TrimtargetImageNorm(:)).^2)));

end
end
