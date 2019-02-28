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
    
    %hologram = round(angle(ApproxSourceAmp)*256/(2*pi))/(256/(2*pi)); %for SLM
    
    %meanApproxSourceAmp = mean(mean(ApproxSourceAmp)); %for DMD
    %hologram = ApproxSourceAmp()>meanApproxSourceAmp; %for DMD
    
    ApproxSourceAmpReal = real(ApproxSourceAmp);
    ApproxSourceAmpImag = imag(ApproxSourceAmp);
    hologram = imbinarize(ApproxSourceAmpReal); %doesn't work, needs to be real
    %hologram = complex(hologramReal,ApproxSourceAmpImag);
    
    hologramInput = (InputField.*exp(1i*hologram));
    
    iteration = iteration +1;
    
    ApproxTargetINorm = (ApproxTargetI - mean(ApproxTargetI(:)))./std(ApproxTargetI(:));
    Performance(iteration) = sum(sum(abs(ApproxTargetINorm(:) - targetImage(:))));
end
end

