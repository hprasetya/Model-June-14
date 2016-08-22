clear all;close all;
global S
S=[];
S.fluidviscosity = 0.00001;
[S.IE, S.SE] = testconfigurationmmgiusto;
S.matrix = distancematrix(0,100,0,500);
structurerandom(0,100,0,500);
for i=1:length(S.SE)
plot([S.SE(i).u(1),S.SE(i).v(1)],[S.SE(i).u(2),S.SE(i).v(2)],'r-',...
    'LineWidth',S.SE(i).radius)
hold on
end
for i=1:length(S.IE)
plot([S.IE(i).u(1),S.IE(i).v(1)],[S.IE(i).u(2),S.IE(i).v(2)],'r-',...
    'LineWidth',S.IE(i).radius)
hold on
end
axis equal