function calcaveragespeed

global S

for i=1:S.nie
    if S.IE(i).type ~= 3
        S.IE(i).speed = averagespeed(S.IE(i).CSA,S.IE(i).Q);
    end
end
for i=1:S.nse
    S.SE(i).speed = averagespeed(S.SE(i).CSA,S.SE(i).Q);
end
end