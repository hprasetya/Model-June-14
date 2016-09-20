function [IN,IE, SE]=solvehemodyn(IN,IE,SE)
% define the matrices A and B fom the node table and do a matrix inversion;
% for large networks these need to be sparse

%A is a system matrix defining internal connectivity
%this is A, as can be seen by writing sum(currents)=0 for each node in
%steady state
%diagonals reflect currents flowing away from the node, other elements currents
%flowing towards nodes
nin=length(IN); nie=length(IE); nse=length(SE);

A=zeros(nin,nin);
for j=1:nin
    for i=1:IN(j).nconnect
        A(j,IN(j).cn(i))=IE(IN(j).ie(i)).G;
    end
end
for j=1:nin, A(j,j)=-sum(A(j,:)); end

%B is a matrix defining connectivity to sources, B is square with
%only diagonals filled in, each element is a conductance to a pressure
%source

B=zeros(nin,nin); % note this works with max 1 source connected to each node
PS=zeros(nin,1);
for j=1:nin
    for i=1:IN(j).nsources
        B(j,j)=B(j,j)+SE(IN(j).se(i)).G;
        PS(j,1)=SE(IN(j).se(i)).sourceP;
    end
end

% pressures in nodes
P=-(A-B)\B*PS; % actual solution by matrix inversion
for j=1:nin, IN(j).P=P(j); end  % distribute over the elements

% flows and mean pressures in elements
for i=1:nie
    P1=IN(IE(i).nodes(1)).P; P2=IN(IE(i).nodes(2)).P;
    IE(i).Q=(P1-P2)*IE(i).G;
    IE(i).P=0.5*(P1+P2);
end

% for source elements, flow is positive into the network, venous flow thus
% shows as negative
for i=1:nse
    P1=SE(i).sourceP; P2=IN(SE(i).node).P;
    SE(i).Q=(P1-P2)*SE(i).G;
    SE(i).P=0.5*(P1+P2);
end

%  volume for each vessel  
global S
for i=1:S.nie
    S.IE(i).V= (pi*(S.IE(i).radius)^2*S.IE(i).lenght);
end

for i=1:S.nse
    S.SE(i).V=(pi*(S.SE(i).radius)^2*S.SE(i).lenght);
end
