%% INVERT
% Import and crop Reference Pattern
ref=imread('nofx.png');
refCrop = ref(39:517,208:846,:);
% 208,39 , size 640,480

% Import and crop Simulation Pattern
A=imread('invert.png');
ACrop = A(39:517,208:846,:);

% calculate ideal result from Reference Pattern
invert = 255-refCrop;

% Calculate MSE
err = immse(ACrop, invert);
fprintf('\n The mean-squared error is %0.4f\n', err);

% Calculate Difference Image
diffIM = 10*(invert-ACrop);

% Create Display

figure 

subplot 231;
imshow(refCrop);
title('Reference')

subplot 232;
imshow(invert);
title('Ideal')

subplot 233;
imshow(ACrop);
title('Simulation')
xlabel("MSE = " + err)

subplot 234;
imshow(diffIM);
title('Difference * 10')

subplot 235;
imshow(invert(1:100,1:100,:));
title('Ideal Magnified')

subplot 236;
imshow(ACrop(1:100,1:100,:));
title('Simulation Magnified')

%% Channel Swap
% Import and crop Reference Pattern
ref=imread('nofx.png');
refCrop = ref(39:517,208:846,:);
% 208,39 , size 640,480

% Import and crop Simulation Pattern
A=imread('rgbswap.png');
ACrop = A(39:517,208:846,:);

% calculate ideal result from Reference Pattern
calculatedImage(:,:,1) = refCrop(:,:,2);
calculatedImage(:,:,2) = refCrop(:,:,1);
calculatedImage(:,:,3) = refCrop(:,:,3);

% Calculate MSE
err = immse(ACrop, calculatedImage);
fprintf('\n The mean-squared error is %0.4f\n', err);

% Calculate Difference Image
diffIM = 10*(calculatedImage-ACrop);

% Create Display

figure 

subplot 231;
imshow(refCrop);
title('Reference')

subplot 232;
imshow(calculatedImage);
title('Ideal')

subplot 233;
imshow(ACrop);
title('Simulation')
xlabel("MSE = " + err)

subplot 234;
imshow(diffIM);
title('Difference * 10')

subplot 235;
imshow(calculatedImage(1:100,1:100,:));
title('Ideal Magnified')

subplot 236;
imshow(ACrop(1:100,1:100,:));
title('Simulation Magnified')

%% RGB to Luma
% Import and crop Reference Pattern
ref=imread('nofx.png');
refCrop = ref(39:517,208:846,:);
% 208,39 , size 640,480

% Import and crop Simulation Pattern
A=imread('rgb_2_luma.png');
ACrop = A(39:517,208:846,:);

% calculate ideal result from Reference Pattern
refCropA = double(refCrop);
calculatedImage(:,:,1) = ((refCropA(:,:,1) + refCropA(:,:,2) + refCropA(:,:,3)) /3);
calculatedImage(:,:,2) = calculatedImage(:,:,1);
calculatedImage(:,:,3) = calculatedImage(:,:,1);

% Calculate MSE
err = immse(ACrop, calculatedImage);
fprintf('\n The mean-squared error is %0.4f\n', err);

% Calculate Difference Image
diffIM = 10*(calculatedImage-ACrop);

% Create Display

figure 

subplot 231;
imshow(refCrop);
title('Reference')

subplot 232;
imshow(calculatedImage);
title('Ideal')

subplot 233;
imshow(ACrop);
title('Simulation')
xlabel("MSE = " + err)

subplot 234;
imshow(diffIM);
title('Difference * 10')

subplot 235;
imshow(calculatedImage(1:100,1:100,:));
title('Ideal Magnified')

subplot 236;
imshow(ACrop(1:100,1:100,:));
title('Simulation Magnified')

%% Colourise
% Import and crop Reference Pattern
ref=imread('nofx.png');
refCrop = ref(39:517,208:846,:);
% 208,39 , size 640,480

% Import and crop Simulation Pattern
A=imread('colourise.png');
ACrop = A(39:517,208:846,:);

% calculate ideal result from Reference Pattern
refCropA = double(refCrop);
calculatedImage(:,:,1) = ((refCropA(:,:,1) + refCropA(:,:,2) + refCropA(:,:,3)) /3);
calculatedImage(:,:,2) = calculatedImage(:,:,1);
calculatedImage(:,:,3) = calculatedImage(:,:,1);

col1 =(calculatedImage <= 50);
colourised1(:,:,1) = col1(:,:,1) * 252;
colourised1(:,:,2) = col1(:,:,1) * 3;
colourised1(:,:,3) = col1(:,:,1) * 3;

col1 =((51 <= calculatedImage) &(calculatedImage <= 100));
colourised2(:,:,1) = col1(:,:,1) * 252;
colourised2(:,:,2) = col1(:,:,1) * 240;
colourised2(:,:,3) = col1(:,:,1) * 3;

col1 =(101 <= calculatedImage) &(calculatedImage <= 150);
colourised3(:,:,1) = col1(:,:,1) * 2;
colourised3(:,:,2) = col1(:,:,1) * 252;
colourised3(:,:,3) = col1(:,:,1) * 107;

col1 =(151 <= calculatedImage) &(calculatedImage <= 200);
colourised4(:,:,1) = col1(:,:,1) * 3;
colourised4(:,:,2) = col1(:,:,1) * 198;
colourised4(:,:,3) = col1(:,:,1) * 252;

col1 =(calculatedImage >= 201);
colourised5(:,:,1) = col1(:,:,1) * 219;
colourised5(:,:,2) = col1(:,:,1) * 3;
colourised5(:,:,3) = col1(:,:,1) * 252;

finalImage = uint8(colourised1 + colourised2 + colourised3 + colourised4 + colourised5);

% Calculate MSE
err = immse(ACrop, finalImage);
fprintf('\n The mean-squared error is %0.4f\n', err);

% Calculate Difference Image
diffIM = 10*(finalImage-ACrop);

% Create Display

figure 

subplot 231;
imshow(refCrop);
title('Reference')

subplot 232;
imshow(finalImage);
title('Ideal')

subplot 233;
imshow(ACrop);
title('Simulation')
xlabel("MSE = " + err)

subplot 234;
imshow(diffIM);
title('Difference * 10')

subplot 235;
imshow(finalImage(1:100,1:100,:));
title('Ideal Magnified')

subplot 236;
imshow(ACrop(1:100,1:100,:));
title('Simulation Magnified')

%% Posterise
% Import and crop Reference Pattern
ref=imread('nofx.png');
refCrop = ref(39:517,208:846,:);
% 208,39 , size 640,480

% Import and crop Simulation Pattern
A=imread('posterise lv2.png');
ACrop = A(39:517,208:846,:);

% calculate ideal result from Reference Pattern

calculatedImage = (bitor(refCrop , 61));

% Calculate MSE
err = immse(ACrop, calculatedImage);
fprintf('\n The mean-squared error is %0.4f\n', err);

% Calculate Difference Image
diffIM = 10*(calculatedImage-ACrop);

% Create Display

figure 

subplot 231;
imshow(refCrop);
title('Reference')

subplot 232;
imshow(calculatedImage);
title('Ideal')

subplot 233;
imshow(ACrop);
title('Simulation')
xlabel("MSE = " + err)

subplot 234;
imshow(diffIM);
title('Difference * 10')

subplot 235;
imshow(calculatedImage(1:100,1:100,:));
title('Ideal Magnified')

subplot 236;
imshow(ACrop(1:100,1:100,:));
title('Simulation Magnified')
