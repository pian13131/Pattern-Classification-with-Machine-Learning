clc;
clear;

load('TrainingSamplesDCT_subsets_8.mat');
load('Alpha.mat');
load('Prior_1.mat');


asz = size(alpha);
asz = asz(2);

Sigma0 = zeros(64, 64);
for i = 1:64
    Sigma0(i, i) = W0(i);
end

e11 = zeros(3,9);
for i = 1:9
   [e11(1,i), e11(2,i), e11(3,i)] = BDR(D1_BG, D1_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(1);
plot(alpha,e11(1,:),alpha,e11(2,:),alpha,e11(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D1 with Strategy 1');

e21 = zeros(3,9);
for i = 1:9
   [e21(1,i), e21(2,i), e21(3,i)] = BDR(D2_BG, D2_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(2);
plot(alpha,e21(1,:),alpha,e21(2,:),alpha,e21(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D2 with Strategy 1');

e31 = zeros(3,9);
for i = 1:9
   [e31(1,i), e31(2,i), e31(3,i)] = BDR(D3_BG, D3_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(3);
plot(alpha,e31(1,:),alpha,e31(2,:),alpha,e31(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D3 with Strategy 1');

e41 = zeros(3,9);
for i = 1:9
   [e41(1,i), e41(2,i), e41(3,i)] = BDR(D4_BG, D4_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(4);
plot(alpha,e41(1,:),alpha,e41(2,:),alpha,e41(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D4 with Strategy 1');


load('Prior_2.mat');

e12 = zeros(3,9);
for i = 1:9
   [e12(1,i), e12(2,i), e12(3,i)] = BDR(D1_BG, D1_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(5);
plot(alpha,e12(1,:),alpha,e12(2,:),alpha,e12(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D1 with Strategy 2');

e22 = zeros(3,9);
for i = 1:9
   [e22(1,i), e22(2,i), e22(3,i)] = BDR(D2_BG, D2_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(6);
plot(alpha,e22(1,:),alpha,e22(2,:),alpha,e22(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D2 with Strategy 2');

e32 = zeros(3,9);
for i = 1:9
   [e32(1,i), e32(2,i), e32(3,i)] = BDR(D3_BG, D3_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(7);
plot(alpha,e32(1,:),alpha,e32(2,:),alpha,e32(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D3 with Strategy 2');

e42 = zeros(3,9);
for i = 1:9
   [e42(1,i), e42(2,i), e42(3,i)] = BDR(D4_BG, D4_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
figure(8);
plot(alpha,e42(1,:),alpha,e42(2,:),alpha,e42(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D4 with Strategy 2');