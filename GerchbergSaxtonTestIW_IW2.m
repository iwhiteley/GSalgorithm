%%% Gerchberg saxton
ImageSize = [16, 16];

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = rand(ImageSize)*2*pi - pi; % Here's where the problem is - I defined the phase from 0-2pi, not -pi to pi

GSInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM


TargetPl = fftshift(fft2(GSInput));

ApproxTargetI = abs(TargetPl).^2;

FTTargetPhase = angle(TargetPl);

%create target shape
targetImage = complex(zeros(ImageSize));
targetImage(5:9, 5:9) = 1+1i;
targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

%Step 3
NewTarget = (targetImage .* exp(1i*FTTargetPhase));

%Step 4
ApproxSourceAmp = ifft2(fftshift(NewTarget));

hologram = angle(ApproxSourceAmp);
hologramI = abs(ApproxSourceAmp).^2;

figure(6)
imagesc(abs(targetImage))

%insert the above algorithm into this loop to go through multipleiterations

iteration = 0;

hologramInput = (InputField.*exp(1i*hologram));

TotalIterations = 1000;
Performance = zeros(1,TotalIterations);
while (iteration < TotalIterations) %|| (ApproxTargetI == targetImage)
   
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

figure(8)
imagesc(ApproxTargetI)

figure(1)
plot(Performance)

figure(2)
imagesc(abs(InputField))