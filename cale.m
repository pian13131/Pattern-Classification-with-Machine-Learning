function [e] = cale(P_BG,P_FG)

load('Zig-Zag Pattern.txt');
A = imread("cheetah.bmp");
A = im2double(A);
Apad = padarray(A,[7 7],'symmetric','post'); % Pad the origin image
zigzag = Zig_Zag_Pattern + 1;
correctImg = imread('cheetah_mask.bmp');
calculatedImg = zeros(255, 270);

for i = 1 : 255
    for j = 1 : 260
        window = dct2(Apad(i:i+7, j:j+7), 8, 8);
        x(zigzag) = window;
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
py_BG = 0.80808081;
py_FG = 0.19191919;
e = py_FG*eF2B/numF + py_BG*eB2F/numB;
end

