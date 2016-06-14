function analyzerectangle(x1,x2,y1,y2)
%ANALYZE IN A RECTANGLED ROI THE DENSITY OF THE CONTRAST
%   This function analyzes the flow of contrast and provides for three
%   different situations the time-density curve, arrival time and time-to
%   peak. 
%   Case I: Without microcirculation
%   Case II: Only microcirculation
%   Case III: All contrast
%   Case IV: Only venous system
%   Case V: Only Arterial system

global S

set(0,'DefaultFigureWindowStyle','docked') % a commando that docks all figures together

%Case I: Without microcirculation
numberofparticles1 = 0;
for i=1:length([S.E])
    if S.E(i).type ~= 3
        for j=1:S.nplaces
            rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
            rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
            if S.E(i).u(1)+rcu*(j-1) >= x1 && S.E(i).u(1)+rcu*(j-1) <= x2 && S.E(i).u(2)+rcv*(j-1) >= y1 && S.E(i).u(2)+rcv*(j-1) <= y2
                numberofparticles1 = numberofparticles1 + S.E(i).C(:,j)*S.E(i).CSA*S.E(i).deltax;
            end
        end
    end
end



%Case II: Only microcirculation
numberofparticles2 = 0;
for i=1:length([S.E])
    if S.E(i).type == 3
        if S.E(i).u(1) >= x1 && S.E(i).u(1) <= x2 && S.E(i).u(2) >= y1 && S.E(i).u(2) <= y2
            numberofparticles2 = numberofparticles2 + S.E(i).C*S.volumebox;
        end
    end
end


flag=0; %flag for breaking out the loop
for tt=1:S.ntimes
    if numberofparticles2(tt) > numberofparticles2(tt+1)
        flag=1;
        time = tt*S.deltat;
        X=['Time-to-peak is  ',num2str(time),' s'];
        disp('ONLY MICROCIRCULATION:');
        disp(X);
        disp(' ');
    end
    if flag == 1
        break;
    end
end

%Case III: All contrast
numberofparticles3 = 0;
for i=1:length([S.E])
    if S.E(i).type ~= 3
        for j=1:S.nplaces
            rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
            rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
            if S.E(i).u(1)+rcu*(j-1) >= x1 && S.E(i).u(1)+rcu*(j-1) <= x2 && S.E(i).u(2)+rcv*(j-1) >= y1 && S.E(i).u(2)+rcv*(j-1) <= y2
                numberofparticles3 = numberofparticles3 + S.E(i).C(:,j)*S.E(i).CSA*S.E(i).deltax;
            end
        end
    elseif S.E(i).type == 3
        if S.E(i).u(1) >= x1 && S.E(i).u(1) <= x2 && S.E(i).u(2) >= y1 && S.E(i).u(2) <= y2
            numberofparticles3 = numberofparticles3 + (S.E(i).C*S.volumebox)';
        end
    end
end

flag=0; %flag for breaking out the loop
for tt=1:S.ntimes
    if numberofparticles3(tt) > numberofparticles3(tt+1)
        flag=1;
        time = tt*S.deltat;
        X=['Time-to-peak is  ',num2str(time),' s'];
        disp('ALL CONTRAST:');
        disp(X);
        disp(' ');
    end
    if flag == 1
        break;
    end
end

%Case IV: Only venous system
numberofparticles4 = 0;
for i=1:length([S.E])
    if S.E(i).type == 4
        for j=1:S.nplaces
            rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
            rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
            if S.E(i).u(1)+rcu*(j-1) >= x1 && S.E(i).u(1)+rcu*(j-1) <= x2 && S.E(i).u(2)+rcv*(j-1) >= y1 && S.E(i).u(2)+rcv*(j-1) <= y2
                numberofparticles4 = numberofparticles4 + S.E(i).C(:,j)*S.E(i).CSA*S.E(i).deltax;
            end
        end
    end
end

%Case V: Only Arterial system
numberofparticles5 = 0;
for i=1:length([S.E])
    if S.E(i).type == 1 || S.E(i).type == 2
        for j=1:S.nplaces
            rcu = (S.E(i).v(1)-S.E(i).u(1))/S.nplaces;
            rcv = (S.E(i).v(2)-S.E(i).u(2))/S.nplaces;
            if S.E(i).u(1)+rcu*(j-1) >= x1 && S.E(i).u(1)+rcu*(j-1) <= x2 && S.E(i).u(2)+rcv*(j-1) >= y1 && S.E(i).u(2)+rcv*(j-1) <= y2
                numberofparticles5 = numberofparticles5 + S.E(i).C(:,j)*S.E(i).CSA*S.E(i).deltax;
            end
        end
    end
end

S.y=linspace(0,(S.ntimes*S.deltat),S.ntimes);
figure(1);plot(S.y,numberofparticles1,'r',S.y,numberofparticles2,'b',S.y,numberofparticles3,'g',S.y,numberofparticles4,'y',S.y,numberofparticles5,'m');
legend('Without microcirculation','Only microcirculation','All contrast','Only venous system','Only arterial system','Location','northeast')
title('Contrast density curve')
xlabel('Time (s)')
ylabel('Density')



end %end function

