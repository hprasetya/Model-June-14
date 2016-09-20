%% INFORMATION ABOUT THIS SCRIPT
% Author: Duncan de Graaf, master physics student at the University 
% of Amsterdam. 
% This MATLAB script describes inflow and outflow of contrast agent in the
% vascular network.
% This 'contrastflow'-script is the main script that runs all the other
% scripts in turn. So for a simulation of the vascular network this 
% 'contrastflow'-script should be runned.


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
S.hematocrit = 0.45 ; %supponing that Ht is 45% of whole blood
S.plasmaviscosity=(1.3*(10)^-3); %range plasma viscosity[1.1-1.6]cP I've changed it in [Kg/m*s]
S.bloodviscosity =S.plasmaviscosity*(1+2.5*S.hematocrit);
%S.fluidviscosity = 0.00001;  % fluid viscosity of blood


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
[S.IE, S.SE] = testconfigurationmmgiusto;  %cause of my cnfiguration;
% [S.IE, S.SE] = testconfiguration2;



%% ADD RANDOM ELEMENTS TO EXISTENT STRUCTURE OF ELEMENTS
%first distancematrix(x1,x2,y1,y2) determines for every posistion in a rectangled grid(x1,x2,y1,y2) its nearest element
%then structurerandom(x1,x2,y1,y2) adds terminal segments with a certain density = number of terminal segments/surface area, radius and pressure.

S.matrix = distancematrix(0,100,0,502); %cause of new configuration;
structurerandom(0,100,0,502); 


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


%% PUTS IE,SE,IN TOGETHER TO FORM ELEMENTS (E) AND NODES (N)
% this function uses al the information in IE,SE and IN to form two types
% of variables: elements (E) and nodes (N)

[S.E,S.N] = mix(S.SE,S.IE,S.IN);

%% SIMULATION OF INJECTING OF CONTRASTAGENT IN THE VASCULAR SYSTEM
%this function generates contrast inflow and outflow in the vascular system
%output is a MxN concentration matrix with M the timesteps, N the placesteps

injectcontrast;

%% OUTPUT OF THE SIMULATION: A MOVIE WITH ALL STRUCTURES AND FLOW OF CONTRAST AGENT THROUGH SYSTEM

% plotstructure;

toc;

%end of script
