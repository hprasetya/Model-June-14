clear all
close all
% This script will simulate how particles are advected and diffused into
% parabolic u distribution based on taylor dispersion in a channel flow 

b=0.05;  %mm/s channel's diameter
Uo= 0.5; %mm/s longitudinal component of velocity flow

N=4000; % number of particles
x=zeros(N,1); % initial x-coordinates of particles
y=b*rand(N,1);% initial y-coordinates of particles (radial distribution at t=0)

D=10^-5; %mm^2/s diffusion coefficient
dt=0.1; %s timestep

NT=100; % number of timesteps

t(1)=0;
writerObj = VideoWriter('taylor.avi');
open(writerObj);

for n=1:NT,
    up=4*Uo*y/b.*(1-y/b)-2*Uo/3; % flow velocity based on particle's y-coordinate
    
    % particles are generated for every timestep based on previous location
    % and the effect of diffusion term ((2*D*dt)^0.5) and advection term 
    % (up*dt) in random magnitude. 
    x_term = randn(N,1)*(2*D*dt)^0.5+up*dt; %axial diffusion + advection
    y_term = randn(N,1)*(2*D*dt)^0.5; %radial diffusion
    x_term(find(x_term<0)) = abs(y_term(find(x_term<0))); %remove backward flow
    x=x+x_term;
    y=y+y_term;
    
    % the loop below is boundary condition to contain u distribution within
    % the channel's diameter
    for i=1:N,
        if y(i) < 0,
            y(i) = abs(y(i));
        elseif y(i) > b,
            y(i) = 2*b - y(i);
        end
    end
    
    t(n+1)=t(n)+dt;  
    
    % plot the particles
    plot(x,y,'ko')
    xlabel('vessel length')
    ylabel('D (mm)')
    title('Contrast transport based on Taylor dispersion')
    axis([0.1 1 0 b]) 
    
    pause(0.1)
    frame = getframe;
    writeVideo(writerObj,frame);
    clf;
end
close(writerObj);
