function [P_BG, P_FG] = EM(d,c)
global py_BG py_FG dct pi_BG mu_BG Sigma_BG pi_FG mu_FG Sigma_FG;

P_BG = zeros(255,260);
P_FG = zeros(255,260);
for i = 1 : 255
    for j = 1 : 260
        x = reshape(dct(i,j,:),1,64);
        P_BG(i,j) = py_BG*calp(x(1:d), mu_BG(1:d), Sigma_BG(), pi_BG);
        P_FG(i,j) = py_FG*calp(x(1:d), mu_FG(1:d), Sigma_FG, pi_FG);
    end
end
end

function [P] = calp(x,u,s,p)

P = 0;
[sz, ~] = size(p);
for j = 1:sz
    P = P + mvnpdf(x, u(j,:), squeeze(s(j,:,:)))*p(j);
end
end