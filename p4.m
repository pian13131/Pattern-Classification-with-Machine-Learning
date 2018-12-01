clc;
clear;
load('TrainingSamplesDCT_8_new.mat');
D_BG = TrainsampleDCT_BG;
D_FG = TrainsampleDCT_FG;
sz = size(D_BG);
szBG = sz(1);
sz = size(D_FG);
szFG = sz(1);
py_BG = szBG/(szBG + szFG);
py_FG = 1 - py_BG;


[pi_BG, mu_BG, Sigma_BG] = calh(D_BG);
[pi_FG, mu_FG, Sigma_FG] = calh(D_FG);

load('Zig-Zag Pattern.txt');
correctImg = imread('cheetah_mask.bmp');
calculatedImg = zeros(255, 270);
A = imread("cheetah.bmp");
A = im2double(A);
Apad = padarray(A,[7 7],'symmetric','post'); % Pad the origin image
zigzag = Zig_Zag_Pattern + 1;
for i = 1 : 255
    for j = 1 : 260
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        x(zigzag) = window;
        if py_FG*calp(x, mu_FG, Sigma_FG, pi_FG) > py_BG*calp(x, mu_BG, Sigma_BG, pi_BG)
            calculatedImg(i, j) = 1;
        end
    end
end

% Calculate the error for 3 kind of solution result
eB2F = 0;% the times that the back point was misclassified as front
eF2B = 0;
numB = 0;% the number of back points
numF = 0;

for i = 1 : 255
    for j = 1 : 270
        
        if correctImg(i, j) == 255
            numF = numF + 1;
        else
            numB = numB + 1;
        end
        
        if calculatedImg(i, j)==0 && correctImg(i, j)==255
            eF2B = eF2B + 1;
        end
        if calculatedImg(i, j)==1 && correctImg(i, j)==0
            eB2F = eB2F + 1;
        end
    end        
end

e = py_FG*eF2B/numF + py_BG*eB2F/numB;
