function drawfigure
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global S

scalewidth = 10; % (-)  thickness of the lines
rmax=max([S.E.radius]); %maximal radius to set linewidth
for i=1:length([S.E])
    if S.E(i).type == 1 || S.E(i).type == 2
        f = [S.E(i).u(1) S.E(i).v(1)];
        g = [S.E(i).u(2) S.E(i).v(2)];
        lw=scalewidth*min(max(S.E(i).radius/rmax),1);
        b=line(f,g);
        set(b,'LineWidth',lw);
    end
end

end

