a=1;  b=0.2; c=-60;  d=-21;
V=-70;  u=b*V;
VV=[];  uu=[];
tau = 0.1; tspan = 0:tau:50;
T1 = 10;
for t=tspan
     if abs(t-T1)<1 
        I=20;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1-1 T1-1 T1+1 T1+1 max(tspan)],-90+[0 0 10 10 0 0]);
axis([0 max(tspan) -90 30])

title('(Q) DAP         ');

xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(Q) DAP');