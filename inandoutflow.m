function inandoutflow()
%This function produces a time vs density plot for the contrast in the
%first arteriole (flow in system) and the last venule (flow out system)

global S

inflow=0;
outflow=0;

inflow = inflow + sum(S.E(1).C,2)*S.E(1).CSA*S.E(1).deltax;
outflow = outflow + sum(S.E(2).C,2)*S.E(2).CSA*S.E(2).deltax;

figure(2);
plot(S.y,inflow,'r',S.y,outflow,'b')
legend('Artery','Vein','Location','northeast');
title('Contrast density curve of the two source elements of the system')
xlabel('Time (s)')
ylabel('Density')


end