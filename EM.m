function [P_BG, P_FG] = EM(d,c)
global py_BG py_FG D_BG D_FG dct;

[pi_BG, mu_BG, Sigma_BG] = calh(D_BG,d,c);
disp('------')
[pi_FG, mu_FG, Sigma_FG] = calh(D_FG,d,c);

P_BG = zeros(255,260);
P_FG = zeros(255,260);
for i = 1 : 255
    for j = 1 : 260
        x = reshape(dct(i,j,:),1,64);
        P_BG(i,j) = py_BG*calp(x(1:d), mu_BG, Sigma_BG, pi_BG);
        P_FG(i,j) = py_FG*calp(x(1:d), mu_FG, Sigma_FG, pi_FG);
    end
end
end

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
loop = 10;
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
    calp(D(100,1:d), mu, Sigma, pi)
    mu = mu_new;
    pi = pi_new;
    Sigma = Sigma_new;
end
end

function [P] = calp(x,u,s,p)

P = 0;
[sz, ~] = size(p);
for j = 1:sz
    P = P + mvnpdf(x, u(j,:), squeeze(s(j,:,:)))*p(j);
end
end