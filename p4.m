clc;
clear;
init();
global D_BG D_FG py_BG py_FG;
%-------- Part 1 --------%
D = [1 2 4 8 16 24 32 40 48 56 64];

e1 = zeros(5,5,11);
P_BG55 = zeros(5, 11, 255, 260);
P_FG55 = zeros(5, 11, 255, 260);
for j=1:5
    [pi_BG, mu_BG, Sigma_BG] = calh(D_BG,64,8);
    [pi_FG, mu_FG, Sigma_FG] = calh(D_FG,64,8);
    for i=1:11
        d = D(i);
        P_BG55(j,i,:,:) = py_BG * callike(pi_BG, mu_BG(:,1:d), Sigma_BG(:,1:d,1:d));
        P_FG55(j,i,:,:) = py_FG * callike(pi_FG, mu_FG(:,1:d), Sigma_FG(:,1:d,1:d));
    end
end
for i=1:5
   for j=1:5
      for k=1:11
         P_BG = squeeze(P_BG55(i,k,:,:));
         P_FG = squeeze(P_FG55(j,k,:,:));
         e1(i,j,k) = cale(P_BG,P_FG);
      end
   end
end
for i = 1:5
    figure;
    plot(D,squeeze(e1(i,:,:)));
    xlabel('Dimension')
    ylabel('Error')
    title(['Error vs Dimension BG',mat2str(i)]);
end

%-------- Part 2 --------%
% C = [1 2 4 8 16 32];
% e2 = zeros(6,11);
% for j = 1:6
% c = C(j);
% [pi_BG, mu_BG, Sigma_BG] = calh(D_BG,64,c);
% [pi_FG, mu_FG, Sigma_FG] = calh(D_FG,64,c);
% 
% for i=1:11
%     d = D(i);
%     P_BG = py_BG * callike(pi_BG, mu_BG(:,1:d), Sigma_BG(:,1:d,1:d));
%     P_FG = py_FG * callike(pi_FG, mu_FG(:,1:d), Sigma_FG(:,1:d,1:d));
%     e2(j,i) = cale(P_BG,P_FG);
% end
% 
% end
% figure;
% plot(D,e2);
% xlabel('Dimension')
% ylabel('Error')
% title('Error vs Dimension');

