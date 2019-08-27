function targetImage = targetImageFunc(ImageSize,raw)

targetImage = complex(zeros(ImageSize));
% rawImage = fftshift(raw);
rawImage = raw;

if strcmp(class(rawImage),'uint8')
    Image = mean(imresize(rawImage, (ImageSize/2git add)),3)./255;

else
    Image = mean(imresize(rawImage, (ImageSize/2)),3);
end

Imcomplex = zeros(size(Image),'like',Image);
complexIm= complex(Image,Imcomplex);
ImOffset = 0;
targetImage((1:size(complexIm,1))+ImOffset,(1:size(complexIm,2))+ImOffset) = complexIm;

end