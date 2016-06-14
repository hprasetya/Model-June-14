function plotstructure()

global S

cmax = round(S.C0); %maximal concentration to set contrast of the lines drawn
rmax=max([S.E.radius]); %maximal radius to set linewidth
maxradius = sqrt(1/(S.density*pi)); %radius of microcirculatory 'boxes'
scalewidth = 10; % (-)  thickness of the lines
writerObj = VideoWriter('test.avi');
open(writerObj);

frames = 1000; %number of frames in the movie (30 frames/second)
timeperframe = S.ntimes/frames;
for tt=1:S.ntimes  
    if rem(tt/timeperframe,1) == 0
        for i=1:length(S.E)
            if S.E(i).type ~= 3
                for j=1:S.nplaces
                    rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
                    rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
                    f = [S.E(i).u(1)+rcu*(j-1) S.E(i).u(1)+rcu*j];
                    g = [S.E(i).u(2)+rcv*(j-1) S.E(i).u(2)+rcv*j];
                    lw=scalewidth*min(max(S.E(i).radius/rmax),1);
                    b=line(f,g);
                    color = (1-S.E(i).C(tt,j)/cmax);
                    set(b,'LineWidth',lw,'Color',[color color color]);
                    if S.E(i).type == 4 
                        if S.E(i).C(tt,j)/cmax < 0.05
                            set(b,'Visible','off');
                        end
                    end
                end
            elseif S.E(i).type == 3
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
        end
        frame = getframe;
        writeVideo(writerObj,frame);
        clf;
    end
end
close(writerObj);


end
 