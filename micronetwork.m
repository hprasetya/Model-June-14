function micronetwork

%The microcirculation - exchange of oxygen between blood and tissue - is
%connected to the terminal segments in the structure created.
%In this function the microcirculation is made with 'boxes' with a
%certain volume and resistance (conductance).

global S

conductancebox = conductance(0.01,2)*1000; %condunctance of microcirculatory box
S.volumebox = 100; %volume of microcirculatory box in mm^3
counterie=1;

for i=1:S.nie
    if S.IE(i).type == 2
        S.IE(S.nie+counterie).u = S.IE(i).v;
        S.IE(S.nie+counterie).v = S.IE(i).v;
        S.IE(S.nie+counterie).radius = nan;
        S.IE(S.nie+counterie).nodes = [S.IE(i).nodes(2) S.IE(i).nodes(2)+S.nin];
        S.IE(S.nie+counterie).length = nan;
        S.IE(S.nie+counterie).G = conductancebox;
        S.IE(S.nie+counterie).type = 3;
        counterie=counterie+1;
    end
end

end