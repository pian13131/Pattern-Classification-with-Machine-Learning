function [P_BG, P_FG] = EM(d,c)
load('TrainingSamplesDCT_8_new.mat');
D_BG = TrainsampleDCT_BG;
D_FG = TrainsampleDCT_FG;

load('Zig-Zag Pattern.txt');
A = imread("cheetah.bmp");
A = im2double(A);
Apad = padarray(A,[7 7],'symmetric','post'); % Pad the origin image
zigzag = Zig_Zag_Pattern + 1;
[szBG, ~] = size(D_BG);
[szFG, ~] = size(D_FG);
py_BG = szBG/(szBG + szFG);
py_FG = 1 - py_BG;

[pi_BG, mu_BG, Sigma_BG] = calh(D_BG,d,c);
[pi_FG, mu_FG, Sigma_FG] = calh(D_FG,d,c);

P_BG = zeros(255,260);
P_FG = zeros(255,260);
for i = 1 : 255
    for j = 1 : 260
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        x(zigzag) = window;
        P_BG(i,j) = py_BG*calp(x(1:d), mu_BG, Sigma_BG, pi_BG);
        P_FG(i,j) = py_FG*calp(x(1:d), mu_FG, Sigma_FG, pi_FG);
    end
end
end

function [pi, mu, Sigma] = calh(D,d,c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[row, ~] = size(D);
H = zeros(c, row);
pi = rand(1,c);
pi = pi/(sum(pi));
mu = zeros(c, d);
sigma2 = cov(D);   % how to random sigma???;
sigma2 = diag(diag(sigma2));
Sigma = zeros(c,d,d);
for i = 1:c
   Sigma(i,:,:) = sigma2(1:d,1:d);
   mu(i,:) = random('Normal',mean(D(:,d)),0.001);
end
loop = 1;
for p = 1:loop
    for i = 1:row
       for j = 1:c
          H(j,i) = mvnpdf(D(i,1:d), mu(j,:), squeeze(Sigma(j,:,:)));
       end 
    end
    H = H.*pi';
    H = H./sum(H);

    mu_new = zeros(c, d);
    Sigma_new = zeros(c,d,d);
    pi_new = zeros(1,c);
    for j = 1:c
       mu_new(j,:) = sum(H(j,:)'.*D(:,1:d))/sum(H(j,:));
       pi_new(j) = mean(H(j,:));
       Sigma_new(j,:,:) = diag(sum(H(j,:)'.*(D(:,1:d) - mu(j,:)).^2)./sum(H(j,:)));
    end
    mu = mu_new;
    pi = pi_new;
    Sigma = Sigma_new;
    Sigma(Sigma==0) = 1e-10;
end
end

function [P] = calp(x,u,s,p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
P = 0;
[sz, ~] = size(p);
for j = 1:sz
    P = P + mvnpdf(x, u(j,:), squeeze(s(j,:,:)))*p(j);
end
end