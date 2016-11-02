function advectiondiffusion
% File name: advectiondiffusion.m
% Author: Clive Mingham 
% Date: 14 Oct 2010
%
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
% The solution is calculated over [p, q] using N points and plotted
% after ntimesteps time steps, i.e. the final 
% solution is at time, ntimesteps*dt seconds.
%%
% clear all; clc; clf
% First set the initial parameters.
p=0;                           % start of computational domain
q=100;                         % end of computational domain
v=50;                         % water speed in x direction
t=0;                           % start clock
runtime=20;                    % required run time
Kx=0.00025;                        % diffusion coeficient in x direction
N=11;                         % number of grid points
dx=(q-p)/(N-1);                % spatial step size
x = p: dx : q;                 % vector of grid points
u0=zeros(1,N);                 % vector of initial u values filled with zeros
% Set initial profile
C0=100; 
Q = 50;
Vbolus=500;
u0=cat(2,C0,zeros(1,length(x)-1)); % initial profile
initialu=u0;                    % keep initial profile for comparison
%
F=0.9;                         % safety factor
dtAD=dx*dx/(v*dx+2*Kx);        % unsplit time step from von Neumann stability analysis
dt=0.04 %F*dtAD                    % time step reduced by safety factor
ntimesteps=2000;                % number of time steps
Cx=v*dt/dx;                   % Courant number
Rx=Kx*(dt/(dx*dx));            % constant for diffusion term
% 
u=zeros(ntimesteps,N+2);                % define correct sized numerical solution array
u(1,1:N)=u0;                              
% Begin the time marching algorithm
disp('start time marching ...')
 for count=1:ntimesteps     
%      t=t+dt;        % current time for outputted solution
%      if t > runtime
%          t=t-dt;    % go back
%          dt=t-runtime; % calc last dt
%          t=runtime
%      else
%          t
%      end                                 
    u0=[0 u0  0];         % insert ghost values
    for i=2:N+1
        u(count+1,i-1)=u0(i)-Cx*(u0(i)-u0(i-1))+ Rx*(u0(i+1)-2*u0(i)+u0(i-1));   
    end
    if count*dt*Q<Vbolus
         u(count+1,1)=100;
     end
    u0=u(count+1,1:N);            % copy solution to initial conditions for next iteration
%     if t >= runtime
%          disp('runtime achieved')
%          break   % stop time marching loop     
%      end      
   end  % of time marching loop 
   %%
   line_int = abs(u./100-1);
   line_int(:,end-1:end)=[];
   vessel_coord = [0 1 2 3 4 5 6 7 8 9 10 11];
   [ts,num_segment] = size(line_int);
   figure,axis([-2 12 -1 1]);
   for i=1:ts
       for j=1:num_segment
           seg_x = [vessel_coord(j) vessel_coord(j+1)];
           seg_y = zeros(1,2);
           plot(seg_x,seg_y,'linewidth',50,'color',line_int(i,j).*[1 0 0])
           
           hold on
       end
       drawnow
   end
   hold off