%-----------Training Part-------------------------
load('TrainingSamplesDCT_8.mat');

% Sort the absolute value and store those index
[~, BG_pos] = sort(abs(TrainsampleDCT_BG), 2, 'descend');
[~, FG_pos] = sort(abs(TrainsampleDCT_FG), 2, 'descend');
BG_pos = BG_pos(:, 2);
FG_pos = FG_pos(:, 2);

figure(1);
subplot(1,2,1);
histogram(BG_pos);
title('Histogram of Back Ground');
subplot(1,2,2);
histogram(FG_pos);
title('Histogram of Front Ground');
% Store the appearing times of every index which is from 1 to 64
BG_map = zeros(1, 64);
FG_map = zeros(1, 64);

for i = 1:1053
    BG_map(BG_pos(i)) = BG_map(BG_pos(i)) + 1;
end
for i = 1:250
    FG_map(FG_pos(i)) = FG_map(FG_pos(i)) + 1;
end

% Calculate the probility of every index
BG_map = BG_map/1053;
FG_map = FG_map/250;

% Calculate the prior probility
PYiBG = 1053/(1053+250);
PYiFG = 250/(1053+250);

% Calculate the best choice for every index, front equal 1, back equal 0
list = zeros(1, 64);
for i = 1:64
    if FG_map(i)*PYiFG > BG_map(i)*PYiBG
        list(i) = 1;
    end
end

%----------------Calculation Part------------------------------
A = imread("cheetah.bmp");
A = im2double(A);
load('Zig-Zag Pattern.txt');
zigzag = Zig_Zag_Pattern + 1;
res = zeros(255, 270);

% Traverse all point and store their "Index", which is from 1 to 64
for i = 1 : 255
    for j = 1 : 270
        window = dct2(A(i:min(i+7, 255), j:min(j+7, 270)), 8,8);
        tmp = zeros(1, 64);
        tmp(zigzag) = window;
        [~, tmp_pos] = sort(abs(tmp), 'descend');
        res(i, j) = tmp_pos(2);
    end
end

% According with the "Best choice rule", set the value for every point
res_img = zeros(255, 270);
for i = 1 : 255
    for j = 1 : 270
        res_img(i, j) = list(res(i, j));
    end
end

% Calculate the error
eB2F = 0;% the times that the back point was misclassified as front
eF2B = 0;
numB = 0;% the number of back points
numF = 0;
O = imread('cheetah_mask.bmp');

figure(2);
subplot(1,2,1);
imagesc(res_img);
colormap(gray(255));
title('Calculated Image');
subplot(1,2,2);
imagesc(O);
colormap(gray(255));
title('Correct Image');

for i = 1 : 255
    for j = 1 : 270
        
        if O(i, j) == 255
            numF = numF + 1;
        else
            numB = numB + 1;
        end
        
        if res_img(i, j)==0 && O(i, j)==255
            eF2B = eF2B + 1;
        end
        
        if res_img(i, j)==1 && O(i, j)==0
            eB2F = eB2F + 1;
        end
    end        
end

e = PYiFG*eF2B/numF + PYiBG*eB2F/numB;
% e = 0.1726