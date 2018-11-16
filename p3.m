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

Sigma0 = zeros(64, 64);
for i = 1:64
   for j = 1:asz
       Sigma0(i, i, j) = alpha(j)*W0(i);
   end
end