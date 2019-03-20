function targetImage = targetImageFunc(ImageSize)

% targetImage = complex(zeros(ImageSize));
% targetImage(20:50, 20:50) = 1+1i;
% targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

% targetImage = imread('smiley2.png');
% targetImage = imresize(targetImage, ImageSize);
% targetImage = imbinarize(targetImage);

targetImage = complex(zeros(ImageSize));
rawImage = imread('smiley2.png');
Image = imresize(rawImage, (ImageSize/2));
Imcomplex = uint8(zeros(size(Image)));
complexIm= complex(Image,Imcomplex);
targetImage(1:384,1:384) = complexIm;
targetImage = imbinarize(targetImage);
end