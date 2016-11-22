function [IE, SE] = testconfigurationmmgiusto

%% ==== CONFIGURATION OF THE VASCULAR NETWORK ====
%length and radius in mm
%pressures in mmHg

global S

SE(1).u = [50 500];
SE(1).v = [50 360];
SE(1).radius = 1.65;
SE(1).node = 1;
SE(1).sourceP = 120;
SE(1).type = 1;

IE(1).u = [50 360];
IE(1).v = [35 80];
IE(1).radius = 1.58;
IE(1).nodes = [1 4];
IE(1).type = 1;

IE(2).u = [50 360];
IE(2).v = [50 330];
IE(2).radius = 1.65;
IE(2).nodes = [1 2];
IE(2).type = 1;

IE(3).u = [50 330];
IE(3).v = [70 80];
IE(3).radius = 1.75;
IE(3).nodes = [2 5];
IE(3).type = 1;

IE(4).u = [50 330];
IE(4).v = [50 100];
IE(4).radius = 1.52;
IE(4).nodes = [2 3];
IE(4).type = 1;

IE(5).u = [50 100];
IE(5).v = [35 80];
IE(5).radius = 0.64;
IE(5).nodes = [3 4];
IE(5).type = 1;

IE(6).u = [50 100];
IE(6).v = [70 80];
IE(6).radius = 0.54;
IE(6).nodes = [3 5];
IE(6).type = 1;

IE(7).u = [35 80];
IE(7).v = [35 20];
IE(7).radius = 1.58;
IE(7).nodes = [4 6];
IE(7).type = 1;

IE(8).u = [50 100];
IE(8).v = [50 20];
IE(8).radius = 1.52;
IE(8).nodes = [3 7];
IE(8).type = 1;


IE(9).u = [70 80];
IE(9).v = [70 20];
IE(9).radius = 1.75;
IE(9).nodes = [5 8];
IE(9).type = 1;

IE(10).u = [50 20];
IE(10).v = [35 20];
IE(10).radius = 1.7;
IE(10).nodes = [7 6];
IE(10).type = 1;

IE(11).u = [50 20];
IE(11).v = [70 20];
IE(11).radius = 1.7;
IE(11).nodes = [7 8];
IE(11).type = 1;

SE(2).u = [35 20];
SE(2).v = [35 10];
SE(2).radius = 1.6;
SE(2).node = 6;
SE(2).sourceP = 60;
SE(2).type = 1;

SE(3).u = [70 20];
SE(3).v = [70 10];
SE(3).radius = 1.6;
SE(3).node = 8;
SE(3).sourceP = 60;
SE(3).type = 1;

S.nin = max([IE.nodes]); %number of internal nodes

for i=1:length(SE)
    SE(i).length = lengte(SE(i).u,SE(i).v);
end

for i=1:length(IE)
    IE(i).length = lengte(IE(i).u,IE(i).v);
end


end



    
