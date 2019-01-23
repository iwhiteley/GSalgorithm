%%% Gerchberg saxton
ImageSize = [16, 16];

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the SLM.
SLM = rand(ImageSize)*2*pi - pi; % Here's where the problem is - I defined the phase from 0-2pi, not -pi to pi

GSInput = (InputField.*exp(1i*SLM)); % Add the phase to the SLM 

%figure(1) % The comparisons are now almost identical, to within machine precision
%imagesc(angle(GSInput))

%figure(2)
%imagesc(SLM)  %shows phase


% freqDomSource = fft2(InputField); %  Is the the imput field or SLM is the source? Do I need to Fourier transform input field/SLM or the GS input

%need to extract amplitude and phase of source intensity
%GSInputPhase = atan2(imag(GSInput),real(GSInput)); % angle(GSInput)
%GSInputAmplitude = sqrt(real(GSInput).^2 + imag(GSInput).^2); % abs(GSInput)

TargetPl = fftshift(fft2(GSInput));   

ApproxTargetI = abs(TargetPl).^2;

FTTargetPhase = angle(TargetPl);

%create target shape
targetImage = complex(zeros(ImageSize));
targetImage(5:9, 5:9) = 1;
%targetImage = complex(targetBase); 
%targetImage = targetBase
disp(targetImage);

%Step 3
NewTarget = (targetImage .* exp(1i*FTTargetPhase));

%Step 4
ApproxSourceAmp = ifft2(fftshift(NewTarget));

%Hologram = phase of ApproxSourceAmp
%hologram = atan(imag(ApproxSourceAmp) ./ real(ApproxSourceAmp));
hologram = angle(ApproxSourceAmp);
hologramI = abs(ApproxSourceAmp).^2;
%hologramIntensity = (hologram .* GSInput);

%figure(3)
%plot(exp(1i*SLM)) % figures 3 and 4 are the same (just like the above figures) because InputField is currently a phase of 0

%figure(4)
%plot(GSInput)   

%figure(5)
%plot(SLM)   % I don't understand what exp(1i* __) is doing, in the figures it goes from line to circle (does it limit the shape?)

figure(6)
imagesc(targetImage)

figure(7)
imagesc(hologram)

%insert the above algorithm into this loop to go through multipleiterations

%while hologram ~= targetImage
    %loop above
   % if hologram == targetImage
  %      break;
 %   end
%    end        
iteration = 0;
hologramInput = (hologram.*SLM);

while hologram ~= targetImage
   % new = (hologram.*exp(1i*SLM)) % gives intensity to hologram
   
   TargetPl = fftshift(fft2(hologramInput));   %need to add intensity to hologram? or is it just hologram? either way, it isnt working...ws

   ApproxTargetI = abs(TargetPl).^2;

   FTTargetPhase = angle(TargetPl);
    
   NewTarget = (targetImage .* exp(1i*FTTargetPhase));

   ApproxSourceAmp = ifft2(fftshift(NewTarget));

   hologram = angle(ApproxSourceAmp);
   
   hologramInput = (hologram.*SLM);
    
   iteration = iteration +1;
    
   if iteration == 10
        
       %| hologram == targetImage
       break
   end
end

figure(8)
imagesc(hologram)

       