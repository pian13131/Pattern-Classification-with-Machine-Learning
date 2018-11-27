function [e1, e2, e3] = BDR(D_BG,D_FG,mu0_BG,mu0_FG,Sigma0) % receive 2 datasets, 2 mu0, Sigma0
% BDR calculate error for 3 kind of solutions with 9 different alpha values

load('Zig-Zag Pattern.txt');
correctImg = imread('cheetah_mask.bmp');
calculatedImg1 = zeros(255, 270);
calculatedImg2 = zeros(255, 270);
calculatedImg3 = zeros(255, 270);
A = imread("cheetah.bmp");
A = im2double(A);
Apad = padarray(A,[7 7],'symmetric','post'); % Pad the origin image
zigzag = Zig_Zag_Pattern + 1;

% get the prior of class, mu, Sigma, mu_n, Sigma_n, a, with sub functions
[py_BG, py_FG] = BDR_py(D_BG, D_FG); 
[mu_BG, Sigma_BG, mun_BG, SigmaN_BG] = BDR_ms(D_BG, mu0_BG, Sigma0);
[mu_FG, Sigma_FG, mun_FG, SigmaN_FG] = BDR_ms(D_FG, mu0_FG, Sigma0);
a_BG_BDR = BDR_a(Sigma_BG + SigmaN_BG, py_BG, 64);
a_FG_BDR = BDR_a(Sigma_FG + SigmaN_FG, py_FG, 64);
a_BG = BDR_a(Sigma_BG, py_BG, 64);
a_FG = BDR_a(Sigma_FG, py_FG, 64);

% traverse all pixels and use different dicision solutions
for i = 1 : 255
    for j = 1 : 260
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        x(zigzag) = window;
        % Bayes
        d_BG = BDR_d(x, Sigma_BG + SigmaN_BG, mun_BG);
        d_FG = BDR_d(x, Sigma_FG + SigmaN_FG, mun_FG);
        if (d_BG + a_BG_BDR > d_FG + a_FG_BDR)
            calculatedImg1(i, j) = 1;
        end
        % MAP
        d_BG = BDR_d(x, Sigma_BG, mun_BG);
        d_FG = BDR_d(x, Sigma_FG, mun_FG);
        if (d_BG + a_BG > d_FG + a_FG)
            calculatedImg2(i, j) = 1;
        end
        % ML
        d_BG = BDR_d(x, Sigma_BG, mu_BG);
        d_FG = BDR_d(x, Sigma_FG, mu_FG);
        if (d_BG + a_BG > d_FG + a_FG)
            calculatedImg3(i, j) = 1;
        end
    end
end

% Calculate the error for 3 kind of solution result
eB2F1 = 0;% the times that the back point was misclassified as front
eF2B1 = 0;
eB2F2 = 0;
eF2B2 = 0;
eB2F3 = 0;
eF2B3 = 0;
numB = 0;% the number of back points
numF = 0;

for i = 1 : 255
    for j = 1 : 270
        
        if correctImg(i, j) == 255
            numF = numF + 1;
        else
            numB = numB + 1;
        end
        
        if calculatedImg1(i, j)==0 && correctImg(i, j)==255
            eF2B1 = eF2B1 + 1;
        end
        if calculatedImg1(i, j)==1 && correctImg(i, j)==0
            eB2F1 = eB2F1 + 1;
        end
        
        if calculatedImg2(i, j)==0 && correctImg(i, j)==255
            eF2B2 = eF2B2 + 1;
        end
        if calculatedImg2(i, j)==1 && correctImg(i, j)==0
            eB2F2 = eB2F2 + 1;
        end
        
        if calculatedImg3(i, j)==0 && correctImg(i, j)==255
            eF2B3 = eF2B3 + 1;
        end
        if calculatedImg3(i, j)==1 && correctImg(i, j)==0
            eB2F3 = eB2F3 + 1;
        end
    end        
end

e1 = py_FG*eF2B1/numF + py_BG*eB2F1/numB;
e2 = py_FG*eF2B2/numF + py_BG*eB2F2/numB;
e3 = py_FG*eF2B3/numF + py_BG*eB2F3/numB;
end

function [a] = BDR_a(s,py,t)
%BDR_a calculate the a in the BDR

a = log((2*pi)^t*det(s)) - 2*log(py);
end

function [d] = BDR_d(x, s, mu)
%BDR_d calculate the d in the BDR

d = (x - mu)/s*(x - mu)';
end

function [py_BG,py_FG] = BDR_py(D_BG,D_FG)
%BDR_py calculate the prior for each class

sz = size(D_BG);
szBG = sz(1);
sz = size(D_FG);
szFG = sz(1);
py_BG = szBG/(szBG + szFG);
py_FG = 1 - py_BG;
end

function [mu, s,mun,sn] = BDR_ms(D, mu0, s0)
%BDR_ms calculate the Sigma, mu, Sigma_n, mu_n

s = cov(D);
mu = mean(D);
n = size(D);
n = n(1);
sn = s0/(s0 + s/n)*s/n;
mun = s0/(s0 + s/n)*mu' + (1/n)*s/(s0 + s/n)*mu0';
mun = mun';
end
