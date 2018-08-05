a=0.02; b=0.25; c=-55;  d=0.05;
V=-64;  u=b*V;
VV=[];  uu=[];
tau = 0.2;  tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) 
        I=0.6;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;

plot(tspan,VV,[0 T1 T1 max(tspan)],-90+[0 0 10 10]);
axis([0 max(tspan) -90 30])
title('(D) phasic bursting');
xlabel('time (ms)')
ylabel('membrane potential (mV)')
savefig('(D) phasic bursting');