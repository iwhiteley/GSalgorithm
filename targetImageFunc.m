function targetImage = targetImageFunc(ImageSize)

% targetImage = complex(zeros(ImageSize));
% targetImage(20:50, 20:50) = 1+1i;
% targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

targetImage = imread('smiley2.png');
targetImage = imresize(targetImage, ImageSize);
targetImage = imbinarize(targetImage);
end