function C = contrastin(X,N,t)
%this function calculates the concentration of contrast that flows in an
%element at position 1. Handles the situation for bi- and trifurcations.

global S

n = length(X); %how many elements are connected to the main element
if X == 0
    C = 0;
end

if n == 1 && X ~= 0 && S.E(X).type ~= 3
    C = S.E(X).C(t-1,S.nplaces);
elseif n == 1 && X ~= 0 && S.E(X).type == 3
    C = S.E(X).C(t-1);
    
elseif n == 2
    if S.E(X(1)).nodes(2) == N
        a = [1 0];
    else
        a = [0 1];
    end
    if S.E(X(1)).Q > 0
        b = [1;0];
    else
        b = [0;1];
    end
    if S.E(X(2)).nodes(2) == N
        aa = [1 0];
    else
        aa = [0 1];
    end
    if S.E(X(2)).Q > 0
        bb = [1;0];
    else
        bb = [0;1];
    end
    C = (S.E(X(1)).C(t-1,S.nplaces)*abs(S.E(X(1)).Q)*(a*b) + ...
        S.E(X(2)).C(t-1,S.nplaces)*abs(S.E(X(2)).Q)*(aa*bb))/...
        (abs(S.E(X(1)).Q)*(a*b)+abs(S.E(X(2)).Q)*(aa*bb));

elseif n == 3
    if S.E(X(1)).nodes(2) == N
        a = [1 0];
    else
        a = [0 1];
    end
    if S.E(X(1)).Q > 0
        b = [1;0];
    else
        b = [0;1];
    end
    if S.E(X(2)).nodes(2) == N
        aa = [1 0];
    else
        aa = [0 1];
    end
    if S.E(X(2)).Q > 0
        bb = [1;0];
    else
        bb = [0;1];
    end    
    if S.E(X(3)).nodes(2) == N
        aaa = [1 0];
    else
        aaa = [0 1];
    end
    if S.E(X(3)).Q > 0
        bbb = [1;0];
    else
        bbb = [0;1];
    end   
    C = (S.E(X(1)).C(t-1,S.nplaces)*abs(S.E(X(1)).Q)*(a*b) + ...
        S.E(X(2)).C(t-1,S.nplaces)*abs(S.E(X(2)).Q)*(aa*bb)+...
        S.E(X(3)).C(t-1,S.nplaces)*abs(S.E(X(3)).Q)*(aaa*bbb))/...
        (abs(S.E(X(1)).Q)*(a*b)+abs(S.E(X(2)).Q)*(aa*bb)+abs(S.E(X(3)).Q)*(aaa*bbb));
    
elseif n == 4
    if S.E(X(1)).nodes(2) == N
        a = [1 0];
    else
        a = [0 1];
    end
    if S.E(X(1)).Q > 0
        b = [1;0];
    else
        b = [0;1];
    end
    if S.E(X(2)).nodes(2) == N
        aa = [1 0];
    else
        aa = [0 1];
    end
    if S.E(X(2)).Q > 0
        bb = [1;0];
    else
        bb = [0;1];
    end    
    if S.E(X(3)).nodes(2) == N
        aaa = [1 0];
    else
        aaa = [0 1];
    end
    if S.E(X(3)).Q > 0
        bbb = [1;0];
    else
        bbb = [0;1];        
    end   
    if S.E(X(4)).nodes(2) == N
        aaaa = [1 0];
    else
        aaaa = [0 1];
    end
    if S.E(X(4)).Q > 0
        bbbb = [1;0];
    else
        bbbb = [0;1];
    end
    C = (S.E(X(1)).C(t-1,S.nplaces)*abs(S.E(X(1)).Q)*(a*b) + ...
        S.E(X(2)).C(t-1,S.nplaces)*abs(S.E(X(2)).Q)*(aa*bb)+ ...
        S.E(X(3)).C(t-1,S.nplaces)*abs(S.E(X(3)).Q)*(aaa*bbb)+ ...
        S.E(X(4)).C(t-1,S.nplaces)*abs(S.E(X(4)).Q)*(aaaa*bbbb))/...
        (abs(S.E(X(1)).Q)*(a*b)+abs(S.E(X(2)).Q)*(aa*bb)+...
        abs(S.E(X(3)).Q)*(aaa*bbb)+abs(S.E(X(4)).Q)*(aaaa*bbbb));
    
end

end %end function