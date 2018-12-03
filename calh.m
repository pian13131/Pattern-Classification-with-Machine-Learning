function [pi, mu, Sigma] = calh(D,d,c)
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
   mu(i,:) = random('Normal', mean(D(:,1:d)), 0);
end
loop = 200;
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
       xd = D(:,1:d);
       h = H(j,:);
       u = mu(j,:);
       mu_new(j,:) = sum(h'.*xd)/sum(h);
       pi_new(j) = mean(h);
       dg = sum(h'.*(xd - u).^2)./sum(h);
       Sigma_new(j,:,:) = diag(dg);
    end
%     calp(D(100,1:d), mu, Sigma, pi)
    mu = mu_new;
    pi = pi_new;
    Sigma = Sigma_new;
end
end
