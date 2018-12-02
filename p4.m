clc;
clear;
D = [1 2 4 8 16 24 32 40 48 56 64];
% C = [1 2 4 8 16 32];
e1 = zeros(25,11);
for i=1:11
   e1(:,1) = cale25(D(i),8);
end
plot(D,e1);
xlabel('Dimension')  %x?????
ylabel('Error')











