%%% Calling script

ImageSize = [768, 768];
raw = 1-(mean(imread('Imperial_Logo.png'),3)./255);
targetImage = targetImageFunc(ImageSize,raw);

InputField = complex(ones(ImageSize)); % Set up a uniform electric field with a phase of zero hitting the DMD.

TotalIterations = 5;
TotalLoops = 100;

    for index= 1: TotalLoops
        SLM = round(rand(ImageSize)*255)*2*pi/255 - pi;
        hologramInputIn = hologramInputSLM(SLM,InputField);
        
        [TargetEstimate, DMDnum] = GSalgorithm(hologramInputIn,InputField, TotalIterations, targetImage, ImageSize);
        hologramStack(:,:,index) = DMDnum;
        imageStack(:,:,index) = TargetEstimate;     
    end