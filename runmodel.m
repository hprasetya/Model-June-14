clear all;close all;
global S
S=[];

S.hematocrit = 0.45 ; %supponing that Ht is 45% of whole blood
S.plasmaviscosity=(1.3*(10)^-3); %range plasma viscosity[1.1-1.6]cP I've changed it in [Kg/m*s]
S.fluidviscosity =S.plasmaviscosity*(1+2.5*S.hematocrit); 

[S.IE, S.SE] = testconfigurationmmgiusto;
S.matrix = distancematrix(0,100,0,500);
structurerandom(0,100,0,500);


S.nie=length(S.IE); % number of internal elements (resistances)each connecting two nodes
S.nse=length(S.SE); % number of connections to pressure sources/sinks from single node


%% ADD MICROCIRCULATORY 'BOXES' WHICH REPRESENT THE MICROCIRCULATORY NETWORK
%The microcirculation - exchange of oxygen between blood and tissue - is
%connected to the terminal segments in the structure created.
%In this function the microcirculation is made with 'boxes' with a
%certain volume and resistance (conductance).
micronetwork;
S.nie=length(S.IE); % number of internal elements (resistances)each connecting two nodes
S.nse=length(S.SE); % number of connections to pressure sources/sinks from single node


%% ADD VENOUS SYSTEM

makevenoussystem;
S.nie=length(S.IE); % number of internal elements (resistances)each connecting two nodes
S.nse=length(S.SE); % number of connections to pressure sources/sinks from single node

%% DEFINITION OF THE CONNECTIVITY OF THE MODEL: the node table
% this function makes a table of nodes, each node has information on the
% connected segments and will have pressure data
% never change this!

[S.IN,S.nin]=MakeNodeTable(S.IE,S.SE);

%% CALCULATE NODE PRESSURES AND ELEMENT FLOWS
% solvehemodyn uses the conductances and source pressures, and returns for
% all node the pressures as field and for all elements the flow and mean
% pressure

calcconductance % In this routine the conductance is calculated
[S.IN,S.IE, S.SE]=solvehemodyn(S.IN,S.IE,S.SE);

%% CALCULATE CROSS SECTIONAL AREA AND AVERAGE SPEED IN INTERNAL ELEMENTS AND SOURCE ELEMENTS
%these functions calculates the CSA and average speed in every internal
%element and every source element

calccrosssectionalarea;
calcaveragespeed;

%Plot venous system(IE)
for i=1:S.nie
    if S.IE(i).type == 4    
        X = [S.IE(i).u(1)  S.IE(i).v(1)];
        Y = [S.IE(i).u(2)  S.IE(i).v(2)];
        plot(X,Y,'b','linewidth',S.IE(i).radius*3);        
        hold on ;
    end
end
%Plot venous system(SE)
for i=1:S.nse
    if S.SE(i).type == 4       
        X = [S.SE(i).u(1)  S.SE(i).v(1)];
        Y = [S.SE(i).u(2)  S.SE(i).v(2)];
        plot(X,Y,'b','linewidth',S.SE(i).radius*3);       
        hold on ;
    end
end

%Plot arterial system(SE)
for i= 1:length(S.SE)
    if S.SE(i).type <3
        X= [S.SE(i).u(1) S.SE(i).v(1)];
        Y= [S.SE(i).u(2) S.SE(i).v(2)];
        plot(X,Y,'r','linewidth',S.SE(i).radius*4);
        hold on ;
    end
end
%Plot arterial system(IE)
for i= 1:length(S.IE)
    if S.IE(i).type <3
        X= [S.IE(i).u(1) S.IE(i).v(1)];
        Y= [S.IE(i).u(2) S.IE(i).v(2)];
        plot(X,Y,'r','linewidth',S.IE(i).radius*4);        
        hold on ;
    end
end
axis tight
