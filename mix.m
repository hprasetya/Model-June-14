function [E,N] = mix(SE,IE,IN)
%MIX function that puts internal en source elements together to form
%elements (E) and nodes (N)
%   also this function adds an extra node for every source element

nse = length(SE); nie=length(IE); nin=length(IN);

for i=1:nse
        E(i).u = SE(i).u;
        E(i).v = SE(i).v;
        E(i).radius = SE(i).radius;
        E(i).nodes(1) = SE(i).node;
        E(i).nodes(2) = nin+i;
        E(i).type = SE(i).type;
        E(i).length = SE(i).length;
        E(i).rc = SE(i).rc;
        E(i).b = SE(i).b;
        E(i).G = SE(i).G;
        E(i).Q = -SE(i).Q;
        E(i).P = SE(i).P;
        E(i).V = SE(i).V;
        E(i).CSA = SE(i).CSA;
        E(i).speed = SE(i).speed;
        
        N(nin+i).P = SE(i).sourceP;
        N(nin+i).nconnect = 1;
        N(nin+i).cn = SE(i).node;
        N(nin+i).ce = i;       
end

for i=1:nie
    E(i+nse) = IE(i);
end

for i=1:nin
    counter=1;
    N(i).nconnect = IN(i).nconnect+length(IN(i).se);
    N(i).cn = IN(i).cn;
    N(i).P = IN(i).P;
    if isempty(IN(i).se) == 0
        for j=1:length(IN(i).se)
            N(i).ce(counter) = IN(i).se(j);
            N(i).cn(length(IN(i).cn)+counter) = E(IN(i).se(j)).nodes(2);
            counter=counter+1;
        end
    end
    for j=1:length(IN(i).ie)
        N(i).ce(counter) = IN(i).ie(j)+nse;
        counter=counter+1;
    end
end

end %end function


