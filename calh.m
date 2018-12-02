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

