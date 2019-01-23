%%% Gerchberg saxton
ImageSize = [128, 128];

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
%a= rand(ImageSize);
%SLM = a*2*pi - pi;
SLM = round(rand(ImageSize)*255)*2*pi/255 - pi; % Here's where the problem is - I defined the phase from 0-2pi, not -pi to pi
hologramInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM

%create target shape
targetImage = complex(zeros(ImageSize));
targetImage(5:9, 5:9) = 1+1i;
targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

figure(1)
imagesc(abs(targetImage))

iteration = 0;
TotalIterations = 100;
Performance = zeros(1,TotalIterations);
while (iteration < TotalIterations) 
   
    TargetPl = fftshift(fft2(hologramInput));   
    
    ApproxTargetI = abs(TargetPl).^2;
    
    FTTargetPhase = angle(TargetPl);
    
    NewTarget = (targetImage .* exp(1i*FTTargetPhase));
    
    ApproxSourceAmp = ifft2(fftshift(NewTarget));
    
    hologram = angle(ApproxSourceAmp);
    
    hologramInput = (InputField.*exp(1i*hologram));
    
    iteration = iteration +1;
    
    ApproxTargetINorm = (ApproxTargetI - mean(ApproxTargetI(:)))./std(ApproxTargetI(:));
    Performance(iteration) = sum(sum(abs(ApproxTargetINorm(:) - targetImage(:))));
end

figure(2)
imagesc(ApproxTargetI)

figure(3)
plot(Performance)

