a=0.1;  b=0.26; c=-60;  d=0;
V=-61;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:300;
T1=tspan(end)/8;
T2 = 216;
for t=tspan
    if ((t>T1) & (t < T1+5)) | ((t>T2) & (t < T2+5)) 
        I=1.24;
    else
        I=0.24;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 T1 T1 (T1+5) (T1+5) T2 T2 (T2+5) (T2+5) max(tspan)],-90+[0 0 10 10 0 0 10 10 0 0]);
axis([0 max(tspan) -90 30])

title('(P) bistability');

xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(P) bistability');