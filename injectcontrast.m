function injectcontrast

%function creates a matrix 'C' with dimensions MxN
%M the amount of timesteps, N the number of placesteps
%after this, the function plots a figure which shows a time vs place 
%concentration image

%this function handles the situation where contrast is injected in source
%element 1, the source of the system.
global S

ne = length(S.E); %number of elements (vessels)

S.ntimes = 15000;  %number of timesteps
S.nplaces = 10;  %number of placesteps per element
S.deltat = 0.004;   %size of timestep in s
elementin = 1; %which element is injected with contrast agent
for i=1:ne
    if S.E(i).type ~= 3
        S.E(i).deltax = S.E(i).length/S.nplaces; %length placestep in every element
        S.E(i).C = zeros(S.ntimes,S.nplaces);
    elseif S.E(i).type == 3 % pre-allocated array for concentration in microcirculation
        S.E(i).C(S.ntimes,1) = 0;
    end
end

S.C0 = 100;   %bolus Concentration
Vbolus = 9000; %volume bolus in mm^3 (= 9 cc)

%simulation well-mixed compartments and flow
for tt=2:S.ntimes
    for j = 1:ne
        counter=1;
        connectto=0;
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
            deltaC = abs(S.E(j).Q)*S.deltat*(x-S.E(j).C(tt-1,1))/(S.E(j).CSA*S.E(j).deltax);
            S.E(j).C(tt,1) = S.E(j).C(tt-1,1)+deltaC;
            for xp=2:S.nplaces
                deltaC = abs(S.E(j).Q)*S.deltat*(S.E(j).C(tt-1,xp-1)-S.E(j).C(tt-1,xp))/(S.E(j).CSA*S.E(j).deltax);
                S.E(j).C(tt,xp) = S.E(j).C(tt-1,xp)+deltaC;
            end
        elseif S.E(j).type == 3
            deltaC = abs(S.E(j).Q)*S.deltat*(x-S.E(j).C(tt-1))/(S.volumebox);
            S.E(j).C(tt) = S.E(j).C(tt-1)+deltaC;
        end
    end
end
% 
% % plot figure
% S.y=linspace(0,(S.ntimes*S.deltat),S.ntimes);

end
 