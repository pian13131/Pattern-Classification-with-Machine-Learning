function [] = init()
load('Zig-Zag Pattern.txt');
A = imread('cheetah.bmp');
A = im2double(A);
global Apad zigzag correctImg D_BG D_FG py_BG py_FG dct;
Apad = padarray(A,[7 7],'symmetric','post');
zigzag = Zig_Zag_Pattern + 1;
correctImg = imread('cheetah_mask.bmp');
load('TrainingSamplesDCT_8_new.mat');
D_BG = TrainsampleDCT_BG;
D_FG = TrainsampleDCT_FG;
[szBG, ~] = size(D_BG);
[szFG, ~] = size(D_FG);
py_BG = szBG/(szBG + szFG);
py_FG = 1 - py_BG;

dct = zeros(255,260,64);
for i = 1 : 255
    for j = 1 : 260
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        x(zigzag) = window;
        dct(i,j,:) = x;
    end
end 
end

