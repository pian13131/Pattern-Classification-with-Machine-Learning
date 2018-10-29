clc;
clear;

load('TrainingSamplesDCT_8_new.mat');

sz = size(TrainsampleDCT_BG);
szBG = sz(1);
sz = size(TrainsampleDCT_FG);
szFG = sz(1);

PYiBG = szBG/(szBG + szFG);
PYiFG = 1 - PYiBG;

% Calculate the mean and covariance of trainning sample
meanBG64 = mean(TrainsampleDCT_BG);
meanFG64 = mean(TrainsampleDCT_FG);
covBG64 = cov(TrainsampleDCT_BG);
covFG64 = cov(TrainsampleDCT_FG);
sigmaBG64 = sqrt(covBG64);
sigmaFG64 = sqrt(covFG64);

%  Draw the 64 figures of Gaussian Distribution for Cheetah and Grass
x = 0;
y = 0;
for j = 0:3
    figure(j+1);
    for i = 1+16*j:16+16*j
        subplot(4,4,i-16*j);
        x = meanBG64(i)-sigmaBG64(i,i)*3:sigmaBG64(i,i)/100:meanBG64(i)+sigmaBG64(i,i)*3;
        y=normpdf(x,meanBG64(i), sigmaBG64(i,i));
        plot(x, y, 'r');
        hold on;
        x = meanFG64(i)-sigmaFG64(i,i)*3:sigmaFG64(i,i)/100:meanFG64(i)+sigmaFG64(i,i)*3;
        y=normpdf(x,meanFG64(i),sigmaFG64(i,i));
        plot(x, y, 'b');
        legend('BG', 'FG');
        s = num2str(i);
        title(s);
    end
end

% Pick the best 8 figures and draw them
pickID = [1 12 15 18 19 20 27 32];

t = 0;
figure(5);
for i = 1:8
    t = pickID(i);
    subplot(2,4,i);
    x = meanBG64(t)-sigmaBG64(t,t)*3:sigmaBG64(t,t)/100:meanBG64(t)+sigmaBG64(t,t)*3;
    y=normpdf(x,meanBG64(t), sigmaBG64(t,t));
    plot(x, y, 'r');
    hold on;
    x = meanFG64(t)-sigmaFG64(t,t)*3:sigmaFG64(t,t)/100:meanFG64(t)+sigmaFG64(t,t)*3;
    y=normpdf(x,meanFG64(t),sigmaFG64(t,t));
    plot(x, y, 'b');
    legend('BG', 'FG');
    s = num2str(t);
    title(s);
end

% Pick the worst 8 figures and draw them
pickWorst = [3 4 5 59 60 62 63 64];
figure(6);
for i = 1:8
    t = pickWorst(i);
    subplot(2,4,i);
    x = meanBG64(t)-sigmaBG64(t,t)*3:sigmaBG64(t,t)/100:meanBG64(t)+sigmaBG64(t,t)*3;
    y=normpdf(x,meanBG64(t), sigmaBG64(t,t));
    plot(x, y, 'r');
    hold on;
    x = meanFG64(t)-sigmaFG64(t,t)*3:sigmaFG64(t,t)/100:meanFG64(t)+sigmaFG64(t,t)*3;
    y=normpdf(x,meanFG64(t),sigmaFG64(t,t));
    plot(x, y, 'b');
    legend('BG', 'FG');
    s = num2str(t);
    title(s);
end

% Extract the value of 8 best features and calculate their mean and
% covariance
pickBG = zeros(szBG, 8);
pickFG = zeros(szFG, 8);
for i = 1 : 8
    pickBG(:, i) = TrainsampleDCT_BG(:, pickID(i));
    pickFG(:, i) = TrainsampleDCT_FG(:, pickID(i));
end
meanBG8 = mean(pickBG);
meanFG8 = mean(pickFG);
covBG8 = cov(pickBG);
covFG8 = cov(pickFG);

% calculate the 64 dimensional features for every point in origin image,
% for the 8 dimensional feature just pick out them from 64 dimensional
% feature vectors with the pickID
A = imread("cheetah.bmp");
A = im2double(A);
Apad = padarray(A,[7 7],'symmetric','post'); % Pad the origin image
load('Zig-Zag Pattern.txt');
zigzag = Zig_Zag_Pattern + 1;

correctImg = imread('cheetah_mask.bmp');
calculatedImg64 = zeros(255, 270);
calculatedImg8 = zeros(255, 270);

aBG64 = log((2*pi)^64*det(covBG64)) - 2*log(PYiBG); % Calculate the alpha value in BDR function
aFG64 = log((2*pi)^64*det(covFG64)) - 2*log(PYiFG);
aBG8 = log((2*pi)^8*det(covBG8)) - 2*log(PYiBG);
aFG8 = log((2*pi)^8*det(covFG8)) - 2*log(PYiFG);
feature64 = zeros(1, 64);
feature8 = zeros(1, 8);

for i = 1 : 255
    for j = 1 : 270
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        feature64(zigzag) = window;
        dBG64 = (feature64 - meanBG64)/(covBG64)*(feature64 - meanBG64)'; % Calculate the d value in the BDR function
        dFG64 = (feature64 - meanFG64)/(covFG64)*(feature64 - meanFG64)';
        if (dBG64 + aBG64 > dFG64 + aFG64)
            calculatedImg64(i, j) = 1;
        end
        
        for k = 1:8
           feature8(k) = feature64(pickID(k));
        end
        dBG8 = (feature8 - meanBG8)/(covBG8)*(feature8 - meanBG8)';
        dFG8 = (feature8 - meanFG8)/(covFG8)*(feature8 - meanFG8)';
        if (dBG8 + aBG8 > dFG8 + aFG8)
            calculatedImg8(i, j) = 1;
        end
    end
end

% Draw the calculated image for 64 dimensional version and 8 dimensional
% version
figure(7);
subplot(1,2,1);
imagesc(calculatedImg64);
colormap(gray(255));
title('Calculated64 Image');
subplot(1,2,2);
imagesc(calculatedImg8);
colormap(gray(255));
title('Calculated8 Image');

% Draw the correct image
figure(8);
imagesc(correctImg);
colormap(gray(255));
title('Correct Image');

% Calculate the error for 64 dimension version and 8 dimension version
eB2F64 = 0;% the times that the back point was misclassified as front
eF2B64 = 0;
eB2F8 = 0;% the times that the back point was misclassified as front
eF2B8 = 0;
numB = 0;% the number of back points
numF = 0;

for i = 1 : 255
    for j = 1 : 270
        
        if correctImg(i, j) == 255
            numF = numF + 1;
        else
            numB = numB + 1;
        end
        
        if calculatedImg64(i, j)==0 && correctImg(i, j)==255
            eF2B64 = eF2B64 + 1;
        end
        
        if calculatedImg64(i, j)==1 && correctImg(i, j)==0
            eB2F64 = eB2F64 + 1;
        end
        
        if calculatedImg8(i, j)==0 && correctImg(i, j)==255
            eF2B8 = eF2B8 + 1;
        end
        
        if calculatedImg8(i, j)==1 && correctImg(i, j)==0
            eB2F8 = eB2F8 + 1;
        end
    end        
end

e64 = PYiFG*eF2B64/numF + PYiBG*eB2F64/numB; % 0.1152
e8 = PYiFG*eF2B8/numF + PYiBG*eB2F8/numB; % 0.0745


