function gabormag = applyGaborFilter(opened_image)
    imageSize = size(opened_image);
    numRows = imageSize(1);
    numCols = imageSize(2);

    wavelengthMin = 4/sqrt(2);
    wavelengthMax = hypot(numRows,numCols);
    n = floor(log2(wavelengthMax/wavelengthMin));
    wavelength = 2.^(0:(n-2)) * wavelengthMin;

    deltaTheta = 45;
    orientation = 0:deltaTheta:(180-deltaTheta);

    g = gabor(wavelength,orientation);

    gabormag = imgaborfilt(opened_image, g);

    for i = 1:length(g)
        sigma = 0.5 * g(i).Wavelength;
        K = 3;
        gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i), K*sigma); 
    end
end