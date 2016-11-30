% File name: advectiondiffusion.m
% Author: Clive Mingham
% Date: 14 Oct 2010
% Modified by : Haryadi Prasetya (11 Nov 2016)

% This m-file is associated with the free text book: 'Introductory Finite Difference
% Methods for PDEs' which may be downloaded from
% http://bookboon.com/uk/student/mathematics/introductory-finite-difference
% -methods-for-pdes
%
% Description: Solves the 1D Advection-Diffusion equation
% dU/dt + v dU/dx = Kx d2U/dx2 with conditions given by Figure 5.2.
%
% Variables:
% u=u(x,t) is the concentration function
% runtime is run time in seconds
% t is elapsed time in seconds
% x is distance in metres
% v is velocity m/s
% Kx is the diffusion coefficient in the x direction
%
% Note:
% 1) if Kx = 0 this is pure advection and the problem
%    has the usual analytical solution.
% 2) if v = 0 this is pure diffusion and the problem
%    has an analytical solution for certain inital conditions.
%
% Discretisation:
% first order forward difference for du/dt
% first order backward difference for du/dx
% second order symmetric difference for d2u/dx2
%
% Sub function: gaussian
%
% Boundary Conditions:
% Dirichlet - set to ghost values to zero at left and right edges of domain
%
% Output:
% - Simulation of contrast flow based on Advection-Diffusion formula through
% single segment of vessel. Flow velocity is pre-determined.
% - Time density curve of number of particles flowing through over time
% Note: you can choose regime, between advection-diffusion & pure advection
%%
% clear all; clc; clf
% First set the initial parameters.
p=0;                           % start of computational domain
q=100;                         % end of computational domain
v=10;                         % flow velocity in x direction
t=0;           % start clock
r=2; % vessel radius
runtime=20;                    % required run time
Kx=20;                        % diffusion coeficient in x direction
N=11;                         % number of grid points
dx=(q-p)/(N-1);                % spatial step size
x = p: dx : q;                 % vector of grid points
u0=zeros(1,N);                 % vector of initial u values filled with zeros
% Set initial profile
C0=100; % vessel input step function
Vbolus=300;
u0=cat(2,C0,zeros(1,length(x)-1)); % initial profile
initialu=u0;                    % keep initial profile for comparison
Q=50;
F=0.9;                         % safety factor
dtAD=dx*dx/(v*dx+2*Kx);        % unsplit time step from von Neumann stability analysis
dt=0.04; %F*dtAD                    % time step reduced by safety factor
ntimesteps=500;                % number of time steps
Cx=v*dt/dx;                   % Courant number
Rx=Kx*(dt/(dx*dx));            % constant for diffusion term

u=zeros(ntimesteps,N+2);                % define correct sized numerical solution array
u(1,1:N)=u0;

for count=1:ntimesteps
    u0=[0 u0  0];         % insert ghost values
    for i=2:N+1
        %% Choose one regime, comment the other
        u(count+1,i-1)=u0(i)-Cx*(u0(i)-u0(i-1))+ Rx*(u0(i+1)-2*u0(i)+u0(i-1)); % advection + axial diffusion
%         u(count+1,i-1)=u0(i)-Cx*(u0(i)-u0(i-1)); % only pure advection
    end
    if count*dt*Q<Vbolus
        u(count+1,1)=100;
    end
    u0=u(count+1,1:N);            % copy solution to initial conditions for next iteration
end

line_int = abs(u./100-1);
line_int(:,end-1:end)=[];
vessel_coord = [0 1 2 3 4 5 6 7 8 9 10 11];
[ts,num_segment] = size(line_int);

writerObj = VideoWriter('singlesegmentAD.avi');
open(writerObj);

figure,
for i=1:ts
    for j=2:num_segment-1
        seg_x = [vessel_coord(j) vessel_coord(j+1)];
        seg_y = zeros(1,2);
        plot(seg_x,seg_y,'linewidth',50,'color',line_int(i,j).*[1 0 0])
        title('Contrast simulation in a single segment')
        hold on
    end
    axis([-1 12 -1 1]);
    drawnow
     frame = getframe;
    writeVideo(writerObj,frame);
    clf;
end
hold off
close(writerObj);
%% Plot density curve
numberofparticles1 = 0;
for j=1:N+1
    numberofparticles1 = numberofparticles1 + u(:,j)*pi*r^2*dt;
end
axtime=linspace(0,((ntimesteps+1)*dt),ntimesteps+1);
figure,plot(axtime,numberofparticles1);

% To plot adv-diff vs pure-adv time density curve, pick pure advection
% regime (comment line 77, de-comment line 78). After the script has done
% running, rename 'numberofparticles1' to 'number of particles2',
% de-comment line 77 & comment line 78, and run the script again. Then plot
% it using 2 lines below:
% figure,plot(axtime,numberofparticles1,'b',axtime,numberofparticles2,'r')
% legend('advection-diffusion','pure advection')
xlabel('time (s)');ylabel('density')
title('Time density curve')