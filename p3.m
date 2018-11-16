clc;
clear;

load('TrainingSamplesDCT_subsets_8.mat');
load('Prior_1.mat');
load('Prior_2.mat');
load('Alpha.mat');
asz = size(alpha);
asz = asz(2);

cov_D1_BG = cov(D1_BG);
cov_D1_FG = cov(D1_FG);

mu0_s1_BG = zeros(1, 64);
mu0_s1_BG(1) = 3;
mu0_s1_FG = zeros(1, 64);
mu0_s1_FG(1) = 1;

sz = size(D1_BG);
szBG_D1 = sz(1);
sz = size(D1_FG);
szFG_D1 = sz(1);
PYiBG_D1 = szBG_D1/(szBG_D1 + szFG_D1);
PYiFG_D2 = 1 - PYiBG_D1;

Sigma0 = zeros(64, 64, asz);
for i = 1:64
   for j = 1:asz
       Sigma0(i, i, j) = alpha(j)*W0(i);
   end
end


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

fun=inline('normpdf(x, mu, Sigma0(1)(1)(1))','x');
Isim=quad(fun,0,1) 

for i = 1 : 255
    for j = 1 : 270
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        feature64(zigzag) = window;
        dBG64 = (feature64 - meanBG64)/(covBG64)*(feature64 - meanBG64)'; % Calculate the d value in the BDR function
        dFG64 = (feature64 - meanFG64)/(covFG64)*(feature64 - meanFG64)';
        if (dBG64 + aBG64 > dFG64 + aFG64)
            calculatedImg64(i, j) = 1;
        end
    end
end