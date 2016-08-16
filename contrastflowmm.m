%% INFORMATION ABOUT THIS SCRIPT
% Author: Duncan de Graaf, master physics student at the University 
% of Amsterdam. 
% This MATLAB script describes inflow and outflow of contrast agent in the
% vascular network.
% This 'contrastflow'-script is the main script that runs all the other
% scripts in turn. So for a simulation of the vascular network this 
% 'contrastflow'-script should be runned.
%
%ed: I amtrying to digest this, all my remakrs start with %ed: 


%% SOME INITIAL COMMANDO'S THAT ARE DESIRABLE

tic;    % tic/toc is a MATLAB commando that keeps the time between 
        % these commando's and displays it in the command window
clear;  % clear the workspace for a next simulation
clc;    % clear the command window for a next simulation

set(0,'DefaultFigureWindowStyle','docked') % a commando that docks all figures together


%% DEFINITION OF MODEL PARAMETERS, FULL MODEL IS IN S
global S    % S is a variable that is used in almost all the scripts and is 
            % used to 'hang' on several variables of the simulation
S=[];       % delete any existing fields from previous simulation
S.fluidviscosity = 0.00001;  % fluid viscosity of blood


%% DEFINITION OF THE CONNECTIVITY OF THE MODEL: the element tables  
% IE = Internal Element
% SE = Source Element
% IN = Internal Node
% The script 'configuration' tells what the configuration istants used in this simulation of the vascular
% network. In this script the IE and SE are told to which IN they are
% connected. 
% IE is a vector of internal elements, each with fields representing the connections,
% parameters and state variables such as radius and length.
% SE is a vector of elements that connect to sources. These elements do not
% adapt and SE should not contain state variables

% [S.IE, S.SE] = configuration;
[S.IE, S.SE] = testconfigurationmmgiusto;
% [S.IE, S.SE] = testconfiguration2;

%% ADD RANDOM ELEMENTS TO EXISTENT STRUCTURE OF ELEMENTS
%first distancematrix(x1,x2,y1,y2) determines for every posistion in a
%rectangled grid(x1,x2,y1,y2) its nearest element(vessel)
%then structurerandom(x1,x2,y1,y2) adds terminal segments with a certain density = number of terminal segments/surface area, radius and pressure.

%ed: so we have a matrix that for each element gives the index of the
%nearest internal or source element. What I don't understand is what
%happens if we are adding vessels, then the nearest element should change.
%(where) is this happening?

%ed: matrix should cover area of all the predefined internal and source elements,
%I am not convinced that this is the case, are x and y accidently switched?
% if  vessel 'sticks out'from the matrix, it has zero relevant matrix
% elements and this could cause the hanging. 

S.matrix = distancematrix(0,100,0,502); 
structurerandom(0,100,0,502); 

S.nie=length(S.IE); % number of internal elements (resistances)each connecting two nodes
S.nse=length(S.SE); % number of connections to pressure sources/sinks from single node

%ed: ok to do a quick drawing but maybe make a function; also look at what
%duncan already made in terms of drawing
for i= 1:3
    X= [S.SE(i).u(1) S.SE(i).v(1)];
    Y= [S.SE(i).u(2) S.SE(i).v(2)];
    plot(X,Y);
    Z=S.SE(i).radius; %mar: his changement doesn't work and also plo(X,Y,'LINEWIDTH',Z,'r') it gives me always error and nothing is red also when i do: plot(Z,'r')
    plot(Z,'linewidth','r');
    
    hold on ;
end



for i= 1:length(S.IE)
    X= [S.IE(i).u(1) S.IE(i).v(1)];
    Y= [S.IE(i).u(2) S.IE(i).v(2)];
    plot(X,Y);

    hold on ;
end


    
    
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
