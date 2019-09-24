%%% Gerchberg Saxton algorithm
function [TargetEstimate, DMDnum] = GScode(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize)
iteration = 0;
for index = 1: TotalIterations
   tic
    TargetPl = fftshift(fft2(hologramInputIn));   
    
    ApproxTargetI = abs(TargetPl).^2;
    ApproxTargetI(ApproxTargetI > 10^10)=0;  % centre pixels mask

    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(ifftshift(NewTarget));
    
    hologram = angle(ApproxSourceAmp);
    
    hologramInputIn = (InputField.*exp(1i*hologram)); % for SLM --- phase hologram
    
    DMD = hologram>0;  %conversion for DMD use
    DMDnum = double(DMD);
 
    TargetEstimate = abs(fftshift(fft2(InputField.*DMDnum)));
    TargetEstimate(floor(ImageSize(1)./2)+1, floor(ImageSize(2)./2)+1) = 0; %last loop for amplitude hologram
   iterTime = toc;
   elapsedIterTime(index) = iterTime;
    iteration = iteration +1; 
end
end