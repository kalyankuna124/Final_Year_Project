clear; close all; clc;
srcFiles = dir('C:\Users\laksh\OneDrive\Desktop\ECODE\Resized Images\*.tif');
Features = zeros(length(srcFiles),1);
for z = 1 : length(srcFiles)
    filename = strcat('C:\Users\laksh\OneDrive\Desktop\ECODE\Resized Images\', srcFiles(z).name);
   image = imread(filename);
    Resize_image = imresize(image,[227 227]);
    
     se = strel('square', 3); % Define the structuring element S (adjust size and shape as needed)

     dilated_image = imdilate(Resize_image, se);
     eroded_image = imerode(dilated_image, se);

     opened_image = imopen(eroded_image, se);

     wavelength = 4;
     orientation = 90;
    [mag,phase] = imgaborfilt(opened_image,wavelength,orientation);

     minutiae_features = minutiae_extraction(image);
     figure;
     imshow(minutiae_features);
     title('Minutiae Features');

     mag_vector = mag(:);
     phase_vector = phase(:);

    fused_features = [minutiae_features(:); mag_vector; phase_vector];


    [coeff,score] = pca(fused_features);
    Xcentered = (score*coeff')';
    k = kurtosis(Xcentered);

    Features(z, :) = k;
    srcFiles(z).name
    
end

save('Features.mat', 'Features');

