ne = length(S.E);
cmax = round(S.C0); %maximal concentration to set contrast of the lines drawn
rmax=max([S.E.radius]); %maximal radius to set linewidth
maxradius = sqrt(1/(S.density*pi)); %radius of microcirculatory 'boxes'
scalewidth = 10; % (-)  thickness of the lines
figure
% tic
writerObj = VideoWriter('contrast.avi');
open(writerObj);

frames = 1000; %number of frames in the movie (30 frames/second)
timeperframe = S.ntimes/frames;
for tt = 1:S.ntimes
    if rem(tt/timeperframe,1) == 0
        for i = 1:ne
            if S.E(i).type > 3
                
                rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
                rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
                lw=scalewidth*min(max(S.E(i).radius/rmax),1);
                for j=1:S.nplaces
                    f = [S.E(i).u(1)+rcu*(j-1) S.E(i).u(1)+rcu*j];
                    g = [S.E(i).u(2)+rcv*(j-1) S.E(i).u(2)+rcv*j];
                    b=line(f,g);
                    color = abs((1-S.E(i).C(tt,j)/cmax));
                    try
                        set(b,'LineWidth',lw,'Color',color*[1 1 1]);
                    catch me
                        set(b,'LineWidth',lw,'Color',[1 1 1]);
                    end
                end
            end
        end
        for i = 1:ne
            if S.E(i).type < 3
                
                rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
                rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
                lw=scalewidth*min(max(S.E(i).radius/rmax),1);
                for j=1:S.nplaces
                    f = [S.E(i).u(1)+rcu*(j-1) S.E(i).u(1)+rcu*j];
                    g = [S.E(i).u(2)+rcv*(j-1) S.E(i).u(2)+rcv*j];
                    b=line(f,g);
                    color = abs((1-S.E(i).C(tt,j)/cmax));
                    try
                        set(b,'LineWidth',lw,'Color',color*[1 1 1]);
                    catch me
                        set(b,'LineWidth',lw,'Color',[1 1 1]);
                    end
                end
            end
        end
        if S.E(i).type == 3
            if S.E(i).C(tt)/cmax > 0.1
                maxconcentration = max([S.E(i).C]);
                radius = maxradius*S.E(i).C(tt)/maxconcentration;
                if S.E(i).C(tt) <= S.E(i).C(tt+1)
                    pos = [S.E(i).u(1)-radius S.E(i).u(2)-radius 2*radius 2*radius];
                elseif S.E(i).C(tt) > S.E(i).C(tt+1)
                    pos = [S.E(i).u(1)-radius+S.switchcoordinates(1) S.E(i).u(2)-radius+S.switchcoordinates(2) 2*radius 2*radius];
                end
                color = [1-0.5*(S.E(i).C(tt)/cmax) 1-0.5*(S.E(i).C(tt)/cmax) 1-0.5*(S.E(i).C(tt)/cmax)];
                rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',color,'FaceColor',color);
            end
        end
        %     toc
        drawnow
        frame = getframe;
        writeVideo(writerObj,frame);
        clf;
    end
end
close(writerObj);
