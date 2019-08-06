%%% Gerchberg saxton
function [ApproxTargetI,Performance,hologram] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage)
iteration = 0;
Performance = zeros(1,TotalIterations);
%hologramInput = hologramInputIn;
while (iteration < TotalIterations) 
   
    TargetPl = fftshift(fft2(hologramInputIn));   
    
    ApproxTargetI = abs(TargetPl).^2;
    ApproxTargetI(ApproxTargetI > 10^10)=0;  %trying to mask centre pixels

    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(fftshift(NewTarget));
    
    %SLM, works well
    % hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi)); 
    
   
%     %DMD binary phase
%     hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi));
%     threshold = 0;
%     hologram(hologram > threshold) = pi;
%     hologram(hologram <= threshold) = 0;
    
    %DMD binary amplitude
    hologram = ApproxSourceAmp*256/(2*pi)/(256/(2*pi)); %here hologram = approxsourceamp, makes no difference
    threshold = 0;
    hologram(hologram > threshold) = pi;
    hologram(hologram <= threshold) = 0;
    
%     hologramInput = (InputField.*exp(1i*hologram)); % for SLM
    hologramInputIn = (InputField.*(hologram./pi)); % for DMD
    
    iteration = iteration +1;
    
    ApproxTargetINorm = (ApproxTargetI - mean(ApproxTargetI(:)))./std(ApproxTargetI(:));
    Performance(iteration) = 1- (sum(sum(abs(ApproxTargetINorm(:) - targetImage(:))))./length(ApproxTargetI)./length(ApproxTargetI));
end
end

