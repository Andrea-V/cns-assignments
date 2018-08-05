a=0.03; b=0.25; c=-52;  d=0;
V=-64;  u=b*V;
VV=[];  uu=[];
tau = 0.2;  tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) & (t < T1+5) 
        I=-15;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1 T1 (T1+5) (T1+5) max(tspan)],-85+[0 0 -5 -5 0 0]);
axis([0 max(tspan) -90 30])

title('(N) rebound burst');
xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(N) rebound burst');