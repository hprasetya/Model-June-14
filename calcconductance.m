function calcconductance

% The conductance is calculated as a function of the radius and the
% length of the Source Elements (SE's)

global S

for i=1:S.nse
    S.SE(i).G=conductance(S.SE(i).radius,S.SE(i).length);
end
for i=1:S.nie
    if S.IE(i).type ~= 3
        S.IE(i).G=conductance(S.IE(i).radius,S.IE(i).length);
    end
end