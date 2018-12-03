function [e25] = cale25(d,c)

P_BG = zeros(5, 255, 260);
P_FG = zeros(5, 255, 260);
for i = 1:5
    [P_BG(i,:,:), P_FG(i,:,:)] = EM(d,c);
end
e25 = zeros(5,5);
for i = 1:5
   for j = 1:5
      e25(i,j) = cale(squeeze(P_BG(i,:,:)), squeeze(P_FG(j,:,:)));
   end
end
end