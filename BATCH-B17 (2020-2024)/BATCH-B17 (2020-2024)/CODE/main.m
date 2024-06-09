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

wavelength = 4;
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
minutiae_features = minutiae_extraction(image);
figure;
imshow(minutiae_features);
title('Minutiae Features');

%% Step 5: Fusion of Features
mag_vector = mag(:);
phase_vector = phase(:);

%fused_features = [mag_vector; phase_vector]; %% indivi ACCU
%fused_features = [minutiae_features(:)];%% indivi ACCU


fused_features = [minutiae_features(:); mag_vector; phase_vector];

%% Step 6: PCA
% Apply PCA to reduce dimensionality

[coeff,score] = pca(fused_features);
Xcentered = (score*coeff')';
k = kurtosis(Xcentered);
%%
% % load Features
% minutiae
%Features = [9.9313,11.1885,11.0938,7.6723,6.4085,8.4015,9.7888,10.9600,7.8834,9.5758,13.1032,25.6417,6.9274,13.2811,13.2811,5.3464,5.2132,1.0334,4.1440,3.6211,3.1955,3.6545,4.4837,5.0318,2.3498,4.5326,3.2743,3.2743,6.7034,6.7034,4.4325,4.4325,6.1383,6.1383,5.1633,5.1633,4.3477,4.3477,2.3736,2.3736,2.3583,2.3583,2.3583,3.6918,3.6918,2.8517,2.8517,2.8517,4.0807,4.0807,4.5326,4.9504,6.0709,4.0153,3.4786,3.4785,4.9772,3.9200,3.9200,4.9759,3.7646,4.7102,3.8538,5.5854,3.7021,3.1908,4.5033,4.3677,4.0139,4.3308,4.6940,3.1141,3.5095,2.9191,2.8901,3.5150,3.5150,3.5150,4.7162,4.8168,4.8168,4.8177,4.8177,5.9699,5.1154,5.1154,5.2759,5.2759,5.7589,5.3856,5.2802,3.0269,5.2564,6.0708,3.6562,4.0237,3.4322,2.7367,2.4750,2.5508,4.7653,3.09419,2.9999,3.5292,3.5087,7.0197,6.2713,4.0476,4.1192,3.6946,3.6098,2.8777,4.7226,2.2978,2.2271,3.6186,2.7538,5.6001,4.5219,4.2816,4.8304,6.4383,8.1797,3.29270855,3.518256211118708];

%Gabor
%Features = [17.5429,16.9904,12.1129,7.9341,10.6522,12.7108,11.0500,10.9619,11.2839,14.6675,7.0181,9.6581,12.2435,14.3846,14.3846,10.8222,13.4972,15.5363,20.1769,9.7330,8.3492,13.2633,15.3426,13.6216,7.0355,12.2506,11.9783,11.9783,13.8795,13.8795,14.0089,14.0089,23.6806,23.6806,13.6016,13.6016,17.4576,17.4576,17.2823,17.2823,20.2941,20.2941,20.2941,50.9975,50.9975,28.0796,28.0796,28.1677,28.1677,12.2506,35.7725,42.7026,25.2021,30.7180,30.7180,20.0166,17.9835,17.9835,11.7841,15.6509,7.8670,14.0835,8.9379,26.2646,33.2128,35.4763,15.5968,15.4270,12/3600,18.3076,2109895,16.8689,22.4043,25.6687,21.8226,20.6489,20.4838,24.5655,58.7613,17.4412,29.9491,28.1156,18.6304,20.9706,17.7104,18.5570,8.6086,6.3113,11.6513,10.2835,16.7560,19.6595,17.4461,20.5580,12.4216,11.0350,38.3350,20.4683,9.1353,8.9567,8.2760,8.2760,10.7878,10.7878,10.4024,10.4024,12.4960,12.4960,8.8714,9.1950,9.1950,16.1616,16.1616,9.8755,12.4441,10.9233,14.5366,8.3129,12.2595,15.4471,15.8462,18.3529,12.9018,10.0750,10.9892];

Features = [1.6451,1.6325,1.9798,2.0335,1.4253,1.6969,1.6969,1.3454,1.3331,1.17734,1.8255,1.6562,1.6625,1.5506,1.6641,1.8469,1.9428,1.3305,1.6975,1.5835,1.4745,1.5843,1.5888,1.6617,1.5063,1.9274,2.0282,2.0282,1.8177,1.8177,1.3158,1.3158,1.3274,1.3274,1.3274,1.7237,1.6181,1.7237,1.4916,1.4916,1.7280,1.7280,1.9274,1.6181,2.2652,2.2652,1.8822,1.8822,2.2087,2.2087,2.2574,1.8929,2.0011,1.9852,1.8048,2.0144,1.9493,2.5171,1.9798,1.9253,1.8474,2.0732,1.9634,2.3255,1.5428,1.6641,1.5329,1.4325,1.7913,1.5205,1.5205,2.0766,1.8115,1.8115,2.1115,3.5861,1.2128,1.2069,1.5739,2.1405,1.2923,1.2798,1.6674,1.4340,2.1641,1.9679,1.4948,1.9372,2.0409,2.5040,2.5776,1.5959,1.6365,1.4905,1.9439,1.7744,2.3547,2.4730,1.2635,1.2574,1.7235,2.1449,2.1449,2.0802,2.0802,2.1703,2.1136,2.0800,1.1661,2.1769,2.3283,1.7235,1.6197,1.6752,1.5669,1.5952,1.4054,1.3820,2.1537,2.1537,2.0259,2.0259,2.0455,2.0455,2.3918];

Labels = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4];

input_size = size(Features, 1);

hidden_layer_size = 300; 
output_size = max(Labels); 


net = newff(minmax(Features),[hidden_layer_size output_size],{'tansig' 'purelin'});
net.trainParam.show = 100;
net.trainParam.lr = 0.0001;
net.trainParam.epochs = 300;
net.trainParam.goal = 1e-5;

labels_one_hot = ind2vec(Labels);


% [net,tr] = train(net,Features,labels_one_hot);

load net

load tr

output = round(sim(net, k)); % Rounding output for classification

[~, predicted_labels] = max(output);

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

%%
BPNNaccuracy = accuracy_score(predicted_labels,Labels)*100 % Accuracy Score

%%

% Predict labels using the neural network
predicted_labels = round(sim(net, Features));
[~, predicted_labels] = max(predicted_labels);
 
% Calculate TP, TN, FP, FN
TP = sum(predicted_labels == 1 & Labels == 1);
TN = sum(predicted_labels ~= 1 & Labels ~= 1);
FP = sum(predicted_labels == 1 & Labels ~= 1);
FN = sum(predicted_labels ~= 1 & Labels == 1);
 
% Display TP, TN, FP, FN
disp(['True Positives (TP): ', num2str(TP)]);
disp(['True Negatives (TN): ', num2str(TN)]);
disp(['False Positives (FP): ', num2str(FP)]);
disp(['False Negatives (FN): ', num2str(FN)]);
 
% Confusion matrix
C = confusionmat(Labels, predicted_labels);
 
% Display confusion matrix as a chart
figure;
confusionchart(C, {'Arch', 'Left Loop', 'Right Loop', 'Whorl', 'Tented'}, 'Title', 'Confusion Matrix');
 
 
%%