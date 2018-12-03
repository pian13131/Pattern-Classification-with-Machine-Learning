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

function [e] = cale(P_BG,P_FG)
global py_BG py_FG correctImg;
calculatedImg = zeros(255, 270);

for i = 1 : 255
    for j = 1 : 260
        if (P_BG(i,j) < P_FG(i,j))
            calculatedImg(i, j) = 1;
        end
    end
end


% Calculate the error for 3 kind of solution result
eB2F = 0;% the times that the back point was misclassified as front
eF2B = 0;
numB = 0;% the number of back points
numF = 0;

for i = 1 : 255
    for j = 1 : 270
        
        if correctImg(i, j) == 255
            numF = numF + 1;
        else
            numB = numB + 1;
        end
        
        if calculatedImg(i, j)==0 && correctImg(i, j)==255
            eF2B = eF2B + 1;
        end
        if calculatedImg(i, j)==1 && correctImg(i, j)==0
            eB2F = eB2F + 1;
        end
    end        
end
e = py_FG*eF2B/numF + py_BG*eB2F/numB;
end