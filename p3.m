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

e = zeros(3,9);
for i = 1:9
   [e(1,i), e(2,i), e(3,i)] = BDR(D1_BG, D1_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
plot(alpha,e(1,:),alpha,e(2,:),alpha,e(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D1 with Strategy 1');

for i = 1:9
   [e(1,i), e(2,i), e(3,i)] = BDR(D2_BG, D2_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
plot(alpha,e(1,:),alpha,e(2,:),alpha,e(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D2 with Strategy 1');

for i = 1:9
   [e(1,i), e(2,i), e(3,i)] = BDR(D3_BG, D3_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
plot(alpha,e(1,:),alpha,e(2,:),alpha,e(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D3 with Strategy 1');

for i = 1:9
   [e(1,i), e(2,i), e(3,i)] = BDR(D4_BG, D4_FG, mu0_BG, mu0_FG, Sigma0*alpha(i));
end
plot(alpha,e(1,:),alpha,e(2,:),alpha,e(3,:));
set(gca, 'XScale', 'log');
legend('Bayes','MAP', 'ML')
xlabel('Alpha');
ylabel('Error');
hold on;
title('D4 with Strategy 1');


load('Prior_2.mat');

