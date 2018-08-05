a=0.02; b=0.2;  c=-65;  d=6;
V=-70;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:100;
T1=tspan(end)/10;

for t=tspan
    if (t>T1) 
        I=14;
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
xlabel('time (ms)')
ylabel('membrane potential (mV)')
title('(A) tonic spiking');
savefig('(A) tonic spiking');