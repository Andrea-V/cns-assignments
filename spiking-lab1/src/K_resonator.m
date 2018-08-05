a=0.1;  b=0.26; c=-60;  d=-1;
V=-62;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:400;
T1=tspan(end)/10;
T2=T1+20;
T3 = 0.7*tspan(end);
T4 = T3+40;
for t=tspan
    if ((t>T1) & (t < T1+4)) | ((t>T2) & (t < T2+4)) | ((t>T3) & (t < T3+4)) | ((t>T4) & (t < T4+4)) 
        I=0.65;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1 T1 (T1+8) (T1+8) T2 T2 (T2+8) (T2+8) T3 T3 (T3+8) (T3+8) T4 T4 (T4+8) (T4+8) max(tspan)],-90+[0 0 10 10 0 0 10 10 0 0 10 10 0 0 10 10 0 0]);
axis([0 max(tspan) -90 30])

title('(K) resonator');

xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(K) resonator');