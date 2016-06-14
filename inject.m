function C = inject(e,k,V,t,dt)

global S

n = length(e); %how many vessels are injected with contrast agent

if t*dt*abs(S.E(k).Q) <= V/n
    C = S.C0;
else
    C = 0;
end