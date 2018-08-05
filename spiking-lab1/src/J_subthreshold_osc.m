a=0.05; b=0.26; c=-60;  d=0;
V=-62;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:200;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) & (t < T1+5) 
        I=2;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1 T1 (T1+5) (T1+5) max(tspan)],-90+[0 0 10 10 0 0]);
axis([0 max(tspan) -90 30])
title('(J) subthreshold osc.');

xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(J) subthreshold osc.');