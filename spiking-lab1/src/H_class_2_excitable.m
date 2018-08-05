a=0.2;  b=0.26; c=-65;  d=0;
V=-64;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:300;
T1=30;
for t=tspan
    if (t>T1) 
        I=-0.5+(0.015*(t-T1)); 
    else
        I=-0.5;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1 max(tspan) max(tspan)],-90+[0 0 20 0]);
axis([0 max(tspan) -90 30])
title('(H) Class 2 excitable');

xlabel('Time (ms)')
ylabel('Membrane Potential (mV)')
savefig('(H) Class 2 excitable');