function equation

global S

nse = length(S.SE);
nie = length(S.IE);

for i=1:nse
    S.SE(i).rc = (S.SE(i).v(2)-S.SE(i).u(2))/(S.SE(i).v(1)-S.SE(i).u(1));
    S.SE(i).b = S.SE(i).u(2) - S.SE(i).rc*S.SE(i).u(1);
end

for i=1:nie
    S.IE(i).rc = (S.IE(i).v(2)-S.IE(i).u(2))/(S.IE(i).v(1)-S.IE(i).u(1));
    S.IE(i).b = S.IE(i).u(2) - S.IE(i).rc*S.IE(i).u(1);
end

end