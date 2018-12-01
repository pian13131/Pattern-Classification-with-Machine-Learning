function [P] = calp(x,u,s,p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
P = 0;
for j = 1:8
    P = P + mvnpdf(x, u(j,:), squeeze(s(j,:,:)))*p(j);
end
end

