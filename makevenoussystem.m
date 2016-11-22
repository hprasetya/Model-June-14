function makevenoussystem

global S

counterie = 1;
increaseradius = 1.50; %increase in radius of 50%
S.switchcoordinates = [5 5]; %switch of coordinates in x- and y-direction

%first copy whole network to create a venous system, without connecting it
%to arterial system
for i=1:S.nie
    if S.IE(i).type == 1 || S.IE(i).type == 2
        S.IE(counterie+S.nie).v = S.IE(i).u+S.switchcoordinates;
        S.IE(counterie+S.nie).u = S.IE(i).v+S.switchcoordinates;
        S.IE(counterie+S.nie).radius = S.IE(i).radius*increaseradius;
        S.IE(counterie+S.nie).nodes = S.IE(i).nodes+S.nin;
        S.IE(counterie+S.nie).length = S.IE(i).length;
        S.IE(counterie+S.nie).rc = S.IE(i).rc;
        S.IE(counterie+S.nie).b = S.IE(i).b;
        S.IE(counterie+S.nie).type = 4;
        counterie=counterie+1;        
    end
end

for i=1:S.nse
    S.SE(i+S.nse).v = S.SE(i).u+S.switchcoordinates;
    S.SE(i+S.nse).u = S.SE(i).v+S.switchcoordinates;
    S.SE(i+S.nse).radius = S.SE(i).radius*increaseradius;
    S.SE(i+S.nse).node = S.SE(i).node+S.nin;
    if S.SE(i).sourceP == 120
        S.SE(i+S.nse).sourceP = 0;
    end
    if S.SE(i).sourceP == 60
        S.SE(i+S.nse).sourceP = 60;
    end
    S.SE(i+S.nse).length = S.SE(i).length;
    S.SE(i+S.nse).rc = S.SE(i).rc;
    S.SE(i+S.nse).b = S.SE(i).b;
    S.SE(i+S.nse).type = 4;
end

S.nin = S.nin*2; %adjust number of internal nodes

end %end function
        
