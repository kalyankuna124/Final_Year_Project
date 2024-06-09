clc;
clear all;
close all;
close all hidden;
warning off

%% Step 1: Load Image 
[filename, pathname] = uigetfile('*.*','Select the image'); % Open file selection dialog box
image = imread(fullfile(pathname, filename)); % Read image from graphics file
figure
imshow(image)
title('Input Image');

%% Step 2: Resize Image
Resize_image = imresize(image,[227 227]);
figure
imshow(Resize_image)
title('Resize Image');

%% Step 3: Morphological Operations
se = strel('square', 3); % Define the structuring element S (adjust size and shape as needed)

% Step 3a: Dilate Image
dilated_image = imdilate(Resize_image, se);
figure
imshow(dilated_image)
title('Dilated');

% Step 3b: Erode Image
eroded_image = imerode(dilated_image, se);
figure
imshow(eroded_image)
title('Eroded');

% Step 3c: Opening of Image
opened_image = imopen(eroded_image, se);
figure
imshow(opened_image)
title('After Opening');

%% Step 4: Gabor Features
wavelength = 5;
orientation = 90;
[mag,phase] = imgaborfilt(opened_image,wavelength,orientation);

tiledlayout(1,2)
nexttile
imshow(mag,[])
title('Gabor Magnitude')
nexttile
imshow(phase,[])
title('Gabor Phase')

%% Minutiae Extraction
minutiae_features = minutiae_extraction(opened_image);
figure;
imshow(minutiae_features);
title('Minutiae Features');

%% Step 5: Fusion of Features
mag_vector = mag(:);
phase_vector = phase(:);
fused_features = [minutiae_features(:); mag(:); phase(:)];
minutiae_features_reshaped = reshape(minutiae_features, [], 3);

%% Step 6: PCA for Dimensionality Reduction
% Compute the mean of each feature
meanFeatures = mean(opened_image);

% Center the data
centeredFeatures = opened_image - meanFeatures;

% Perform PCA
[coeff, score, ~, ~, explained] = pca(centeredFeatures);

% Decide on the number of components to keep
desiredVariance = 0.95;  % Adjust this value as needed
numComponents = find(cumsum(explained) >= desiredVariance*100, 1);
% Use the selected number of components
coeffReduced = coeff(:, 1:numComponents);
scoreReduced = score(:, 1:numComponents);

% Reconstruct the data
reconstructedFeatures = scoreReduced * coeffReduced' + meanFeatures;

% Use the reconstructed data for further processing
selected_features_pca = reconstructedFeatures';

%% Step 7: Build and Train Neural Network
Features = selected_features_pca;
Labels = randi([1, 5], size(selected_features_pca, 1), 1);

input_size = size(Features, 1);
hidden_layer_size = 300; 
output_size = max(Labels); 

net = newff(minmax(Features), [hidden_layer_size output_size], {'tansig' 'purelin'});
net.trainParam.show = 100;
net.trainParam.lr = 0.0001;
net.trainParam.epochs = 300;
net.trainParam.goal = 1e-5;

labels_one_hot = ind2vec(Labels);

%[net, tr] = train(net, Features, labels_one_hot');
load net
load tr
output = round(sim(net, Features)); % Rounding output for classification

[~, predicted_labels] = max(output);

% Display results
if any(predicted_labels == 1)
    msgbox('Arch')
elseif any(predicted_labels == 2)
    msgbox('Left Loop')
elseif any(predicted_labels == 3)
    msgbox('Right Loop')
elseif any(predicted_labels == 4)
    msgbox('Whorl')
else
    msgbox('Tented')     
end

% Calculate accuracy
BPNNaccuracy = accuracy_score(predicted_labels, Labels)*100;

% Display confusion matrix
C = confusionmat(Labels, predicted_labels);
figure;
confusionchart(C, {'Arch', 'Left Loop', 'Right Loop', 'Whorl', 'Tented'}, 'Title', 'Confusion Matrix');