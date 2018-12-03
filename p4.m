clc;
clear;

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

D = [1 2 4 8 16 24 32 40 48 56 64];

% e1 = zeros(25,11);
% for i=1:11
%    e1(:,i) = reshape(cale25(D(i),8),25,1);
% end
% for i = 1:5
%     figure;
%     plot(D,e1((i-1)*5+1:i*5,:));
%     xlabel('Dimension')
%     ylabel('Error')
%     title(['Error vs Dimension FG',mat2str(i)]);
% end


C = [1 2 4 8 16 32];
% e2 = zeros(6,11);
e = zeros(1,11);
for i=1:6
    for j=1:11
        [P_BG, P_FG] = EM(D(j),4);
        e(j) = cale(P_BG,P_FG);
    end
end
figure;
plot(D,e);
xlabel('Dimension')
ylabel('Error')
title('Error vs Dimension');


% [P_BG, P_FG] = EM(64,4);
% e = cale(P_BG,P_FG);



