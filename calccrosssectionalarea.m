function calccrosssectionalarea

global S

for i=1:S.nie
    if S.IE(i).type ~= 3
        S.IE(i).CSA = crosssectionalarea(S.IE(i).radius);
    end
end
for i=1:S.nse
    S.SE(i).CSA = crosssectionalarea(S.SE(i).radius);
end
end