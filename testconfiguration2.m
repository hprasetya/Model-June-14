function [IE, SE] = testconfiguration2

%% ==== CONFIGURATION OF THE VASCULAR NETWORK ====
%length and radius in mm
%pressures in mmHg

global S

SE(1).u = [20 60];
SE(1).v = [20 40];
SE(1).radius = 6;
SE(1).node = 1;
SE(1).sourceP = 60;

SE(2).u = [20 20];
SE(2).v = [20 0];
SE(2).radius = 4;
SE(2).node = 2;
SE(2).sourceP = 50;

IE(1).u = [20 40];
IE(1).v = [20 20];
IE(1).radius = 5;
IE(1).nodes = [1 2];


S.nin = 2; %number of internal nodes

for i=1:length(SE)
    SE(i).length = lengte(SE(i).u,SE(i).v);
end

for i=1:length(IE)
    IE(i).length = lengte(IE(i).u,IE(i).v);
end