function targetImage = 

targetImage = complex(zeros(ImageSize));
targetImage(20:50, 20:50) = 1+1i;
targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));