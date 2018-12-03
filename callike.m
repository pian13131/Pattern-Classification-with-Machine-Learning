function [P] = callike(pi, mu, Sigma, py)
global dct;
[~, d] = size(mu);
P = zeros(255,260);
for i = 1 : 255
    for j = 1 : 260
        x = reshape(dct(i,j,:),1,64);
        P(i,j) = py*calp(x(1:d), mu, Sigma, pi);
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