function [IE, SE] = configuration

%% ==== CONFIGURATION OF THE VASCULAR NETWORK ====
%length and radius in mm
%pressures in mmHg

global S


SE(1).u = [70 0];
SE(1).v = [70 -40];
SE(1).radius = 6;
SE(1).node = 1;
SE(1).sourceP = 60;

SE(2).u = [130 0];
SE(2).v = [130 -30];
SE(2).radius = 4;
SE(2).node = 10;
SE(2).sourceP = 100;

SE(3).u = [40 -110];
SE(3).v = [40 -130];
SE(3).radius = 5;
SE(3).node = 5;
SE(3).sourceP = 0;

SE(4).u = [80 -120];
SE(4).v = [80 -130];
SE(4).radius = 5;
SE(4).node = 7;
SE(4).sourceP = 0;

SE(5).u = [150 -80];
SE(5).v = [120 -110];
SE(5).radius = 2.5;
SE(5).node = 12;
SE(5).sourceP = 0;

SE(6).u = [150 -80];
SE(6).v = [150 -130];
SE(6).radius = 3;
SE(6).node = 12;
SE(6).sourceP = 0;

IE(1).u = [70 -40];
IE(1).v = [30 -70];
IE(1).radius = 5;
IE(1).nodes = [1 2];

IE(2).u = [30 -70];
IE(2).v = [10 -90];
IE(2).radius = 4.5;
IE(2).nodes = [2 3];

IE(3).u = [30 -70];
IE(3).v = [50 -80];
IE(3).radius = 3.2;
IE(3).nodes = [2 4];

IE(4).u = [10 -90];
IE(4).v = [40 -110];
IE(4).radius = 4.5;
IE(4).nodes = [3 5];

IE(5).u = [50 -80];
IE(5).v = [40 -110];
IE(5).radius = 3;
IE(5).nodes = [4 5];

IE(6).u = [50 -80];
IE(6).v = [70 -90];
IE(6).radius = 1;
IE(6).nodes = [4 6];

IE(7).u = [70 -90];
IE(7).v = [80 -120];
IE(7).radius = 2;
IE(7).nodes = [6 7];

IE(8).u = [70 -40];
IE(8).v = [100 -60];
IE(8).radius = 4.5;
IE(8).nodes = [1 8];

IE(9).u = [100 -60];
IE(9).v = [100 -100];
IE(9).radius = 4.5;
IE(9).nodes = [8 9];

IE(10).u = [100 -100];
IE(10).v = [80 -120];
IE(10).radius = 4;
IE(10).nodes = [9 7];

IE(11).u = [130 -30];
IE(11).v = [100 -60];
IE(11).radius = 2.75;
IE(11).nodes = [10 8];

IE(12).u = [130 -30];
IE(12).v = [150 -60];
IE(12).radius = 3.5;
IE(12).nodes = [10 11];

IE(13).u = [150 -60];
IE(13).v = [150 -80];
IE(13).radius = 3.5;
IE(13).nodes = [11 12];

IE(14).u = [100 -60];
IE(14).v = [70 -90];
IE(14).radius = 2;
IE(14).nodes = [8 6];

S.nin = max([IE.nodes]);

for i=1:length(SE)
    SE(i).length = lengte(SE(i).u,SE(i).v);
end

for i=1:length(IE)
    IE(i).length = lengte(IE(i).u,IE(i).v);
end






