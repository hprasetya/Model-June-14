% contrast simulation 60 seconds
ne = length(S.E);
S.diffusivity = 2.5e-4; % mm^2/s
S.ntimes = 15000; %number of timestep
S.nplaces = 10; %each vessel is divided into 10 axial segments
S.deltat = 0.004; %dt
elementin = 1; %number of vessel in which contrast is passing through at the time
for i=1:ne
    if S.E(i).type ~= 3
        S.E(i).deltax = S.E(i).length/S.nplaces; %length placestep in every element (dx)
        S.E(i).C = zeros(S.ntimes,S.nplaces);
        S.E(i).x0=zeros(1,S.nplaces); %initial concentration
    elseif S.E(i).type == 3 % pre-allocated array for concentration in microcirculation
        S.E(i).C(S.ntimes,S.nplaces) = 0;
    end
end

S.C0 = 100; %bolus concentration
Vbolus = 9000; %volume bolus in mm^3 (=9cc)
for tt=2:S.ntimes
    for j=1:ne
        counter = 1;
        connectto = 0;
        if S.E(j).Q > 0 %determing the direction of the element: from which 'node' is blood received
            node = S.E(j).nodes(1);
        elseif S.E(j).Q < 0
            node = S.E(j).nodes(2);
        end
        for i=1:length(S.N(node).ce)
            if S.N(node).ce(i) ~= j
                connectto(counter) = S.N(node).ce(i); %elements connected to the receiving node
                counter=counter+1;
            end
        end
        connectto=unique(connectto); %trim off duplicate elements
        if j == elementin %initial injection
            x = inject(elementin,j,Vbolus,tt,S.deltat); %initial concentration, x = S.C0
        else
            % concentration after initial injection
            x = contrastin(connectto,node,tt); %concentration contrast flowing in the element
        end
        if S.E(j).type ~= 3
            S.E(j).x0=[x S.E(j).x0 0]; %insert ghost values, boundaries for backward & forward differences
            Cx = S.E(j).speed*S.deltat/S.E(j).deltax; %Courant number
            Rx = S.diffusivity*(S.deltat/(S.E(j).deltax*S.E(j).deltax)); %constant for diffusion term
            for xp=2:S.nplaces+1
                S.E(j).C(tt,xp-1) = S.E(j).x0(xp)-Cx*(S.E(j).x0(xp)-S.E(j).x0(xp-1))+...
                    Rx*(S.E(j).x0(xp+1)-2*S.E(j).x0(xp)+S.E(j).x0(xp-1));
            end
        elseif S.E(j).type == 3
            deltaC = abs(S.E(j).Q)*S.deltat*(x-S.E(j).C(tt-1))/(S.volumebox);
            S.E(j).C(tt) = S.E(j).C(tt-1)+deltaC;
        end
    end
end