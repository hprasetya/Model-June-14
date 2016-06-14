function [IE, SE] = testconfiguration

%% ==== CONFIGURATION OF THE VASCULAR NETWORK ====
%length and radius in mm
%pressures in mmHg

global S

SE(1).u = [50 300];
SE(1).v = [50 270];
SE(1).radius = 3;
SE(1).node = 1;
SE(1).sourceP = 60;
SE(1).type = 1;

IE(1).u = [50 270];
IE(1).v = [50 210];
IE(1).radius = 2.7;
IE(1).nodes = [1 2];
IE(1).type = 1;

IE(2).u = [50 210];
IE(2).v = [50 180];
IE(2).radius = 2.4;
IE(2).nodes = [2 3];
IE(2).type = 1;

IE(3).u = [50 180];
IE(3).v = [40 150];
IE(3).radius = 1.9;
IE(3).nodes = [3 4];
IE(3).type = 1;

IE(4).u = [50 180];
IE(4).v = [60 150];
IE(4).radius = 1.9;
IE(4).nodes = [3 5];
IE(4).type = 1;

IE(5).u = [40 150];
IE(5).v = [50 120];
IE(5).radius = 1.7;
IE(5).nodes = [4 6];
IE(5).type = 1;

IE(6).u = [60 150];
IE(6).v = [50 120];
IE(6).radius = 1.7;
IE(6).nodes = [5 6];
IE(6).type = 1;

IE(7).u = [50 120];
IE(7).v = [50 80];
IE(7).radius = 2;
IE(7).nodes = [6 7];
IE(7).type = 1;

IE(8).u = [50 80];
IE(8).v = [50 40];
IE(8).radius = 1.8;
IE(8).nodes = [7 8];
IE(8).type = 1;

SE(2).u = [50 40];
SE(2).v = [50 10];
SE(2).radius = 1.6;
SE(2).node = 8;
SE(2).sourceP = 40;
SE(2).type = 1;

S.nin = max([IE.nodes]); %number of internal nodes

for i=1:length(SE)
    SE(i).length = lengte(SE(i).u,SE(i).v);
end

for i=1:length(IE)
    IE(i).length = lengte(IE(i).u,IE(i).v);
end

