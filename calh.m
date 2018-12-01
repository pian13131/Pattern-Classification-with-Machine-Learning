function [pi, mu, Sigma] = calh(D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[row, ~] = size(D);
H = zeros(8, row);
pi = rand(1,8);
pi = pi/(sum(pi));
mu = zeros(8, 64);
sigma2 = cov(D);   % how to random sigma???;
sigma2 = diag(diag(sigma2));
Sigma = zeros(8,64,64);
for i = 1:8
   Sigma(i,:,:) = sigma2;
   mu(i,:) = random('Normal',mean(D),0.001);
end
loop = 1;
for p = 1:loop
    for i = 1:row
       for j = 1:8
          H(j,i) = mvnpdf(D(i,:), mu(j,:), squeeze(Sigma(j,:,:)));
       end 
    end
    H = H.*pi';
    H = H./sum(H);

    mu_new = zeros(8, 64);
    Sigma_new = zeros(8,64,64);
    pi_new = zeros(1,8);
    for j = 1:8
       mu_new(j,:) = sum(H(j,:)'.*D)/sum(H(j,:));
       pi_new(j) = mean(H(j,:));
       Sigma_new(j,:,:) = diag(sum(H(j,:)'.*(D - mu(j,:)).^2)./sum(H(j,:)));
    end
    mu = mu_new;
    pi = pi_new;
    Sigma = Sigma_new;
end
end

