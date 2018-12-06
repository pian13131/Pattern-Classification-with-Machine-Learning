function [pi, mu, Sigma] = calh(D,d,c)
%   EM, return the trained parameters
[row, ~] = size(D);
H = zeros(c, row);
pi = rand(1,c);
pi = pi/sum(pi);
mu = zeros(c, d);
sigma2 = cov(D);
sigma2 = diag(diag(sigma2));
Sigma = zeros(c,d,d);
for i = 1:c
   Sigma(i,:,:) = sigma2(1:d,1:d);
   u = mean(D(:,1:d));
   mu(i,:) = random('Normal', u, abs(u)*0.1);
end

% EM loop
loop = 300;
for p = 1:loop
    for i = 1:row
       for j = 1:c
          H(j,i) = mvnpdf(D(i,1:d), mu(j,:), squeeze(Sigma(j,:,:)));
       end 
    end
    H = H.*pi';
    H = H./sum(H,1);

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
       dg(dg<1e-10) = 1e-10;
       Sigma_new(j,:,:) = diag(dg);
    end
    % set the point of break out
    t = norm(mu_new - mu)/norm(mu)+norm(pi_new - pi)/norm(pi);
    if t < 1e-4
       break; 
    end
    mu = mu_new;
    pi = pi_new;
    Sigma = Sigma_new;
end
p
end
