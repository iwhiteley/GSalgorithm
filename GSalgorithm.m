%%% Gerchberg saxton
function [ApproxTargetI,Performance] = GSalgorithm(hologramInput,InputField, TotalIterations, targetImage)
iteration = 0;
Performance = zeros(1,TotalIterations);
%hologramInput = hologramInputIn;
while (iteration < TotalIterations) 
   
    TargetPl = fftshift(fft2(hologramInput));   
    
    ApproxTargetI = abs(TargetPl).^2;
    
    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(fftshift(NewTarget));
    
    %hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi)); 
    %for SLM, works well
    
    hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi));
    threshold = 0;
    hologrambin = hologram;
    hologrambin(hologrambin > threshold) = pi;
    hologrambin(hologrambin <= threshold) = 0;
    
%     if hologram() > 0
%         hologram = pi;
%     elseif hologram() <= 0
%         hologram = 0;
%     end
    
%       meanApproxSourceAmp = mean(mean(ApproxSourceAmp)); %for DMD
%       hologram = ApproxSourceAmp()>meanApproxSourceAmp; %for DMD
%       meanHologram = mean(mean(hologram));
%       meanApproxSourceAmp = meanHologram;
     
%       ApproxSourceAmpReal = real(ApproxSourceAmp);
%       ApproxSourceAmpImag = imag(ApproxSourceAmp);
%       binApproxSourceAmpReal = imbinarize(ApproxSourceAmpReal);
%       hologramReal = int(cell2mat(binApproxSourceAmpReal)); %doesn't work, needs to be real
%       hologram = complex(hologramReal,ApproxSourceAmpImag);
%     
%     ApproxSourceAmpReal = real(ApproxSourceAmp);
%     ApproxSourceAmpImag = imag(ApproxSourceAmp);
%     hologram = imbinarize(ApproxSourceAmpReal);
  
    %hologramInput = (InputField.*exp(1i*hologram)); %for slm
    
    hologramInput = (InputField.*exp(1i*hologrambin));
    
    iteration = iteration +1;
    
    ApproxTargetINorm = (ApproxTargetI - mean(ApproxTargetI(:)))./std(ApproxTargetI(:));
    Performance(iteration) = sum(sum(abs(ApproxTargetINorm(:) - targetImage(:))));
end
end

