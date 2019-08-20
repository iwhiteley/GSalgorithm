function targetImage = targetImageFunc(ImageSize,raw)

% targetImage = complex(zeros(ImageSize));
% targetImage(20:50, 20:50) = 1+1i;
% targetImage = (targetImage - mean(targetImage(:)))./std(targetImage(:));

% targetImage = imread('smiley2.png');
% targetImage = imresize(targetImage, ImageSize);
% targetImage = imbinarize(targetImage);

targetImage = complex(zeros(ImageSize));
rawImage = fftshift(raw);

if strcmp(class(rawImage),'uint8')
    Image = mean(imresize(rawImage, (ImageSize/2)),3)./255;

else
    Image = mean(imresize(rawImage, (ImageSize/2)),3);
end

Imcomplex = zeros(size(Image),'like',Image);
complexIm= complex(Image,Imcomplex);
ImOffset = 0;
targetImage((1:size(complexIm,1))+ImOffset,(1:size(complexIm,2))+ImOffset) = complexIm;
%targetImage = imbinarize(targetImage);
end