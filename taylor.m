clear all
close all

b=0.05;  %m/s
Uo=0.2; %m/s

N=10000;
x=zeros(N,1);
y=b*rand(N,1);

D=10^-5; %m^2/s
dt=0.1; %s

NT=100;

xedges=[-0.4:0.02:0.4]; %for histogram
t(1)=0;
sigmax2(1)=0; %variance in x direction
writerObj = VideoWriter('taylor.avi');
open(writerObj);
for n=1:NT,
    up=4*Uo*y/b.*(1-y/b)-2*Uo/3;
    x=x+randn(N,1)*(2*D*dt)^0.5+up*dt+0.005;
    y=y+randn(N,1)*(2*D*dt)^0.5;
    for i=1:N,
        if y(i) < 0,
            y(i) = abs(y(i));
        elseif y(i) > b,
            y(i) = 2*b - y(i);
        end
    end
    t(n+1)=t(n)+dt;
    numx=histc(x,xedges);
    sigmax2(n+1)=var(x);
    %     subplot(2,1,1)
    plot(x,y,'ko')
    xlabel('vessel length')
    ylabel('D (mm)')
    title('Contrast transport based on Taylor dispersion')
    axis([0 1 0 b])
    %     subplot(2,1,2)
    %     bar(xedges,numx,'histc')
    %     xlabel('x-Vt (m)')
    %     ylabel('number/bin')
    %     axis([0 0.4 0 500])
    %axis([-xmax xmax -ymax ymax])
    %     subplot(3,1,3)
    %     plot(t,sigmax2,'k-')
    %     xlabel('t (s)'); ylabel('Variance (m^2)')
    %     axis([0 NT*dt 0 0.01])
    pause(0.1)
    frame = getframe;
    writeVideo(writerObj,frame);
    clf;
end
close(writerObj);