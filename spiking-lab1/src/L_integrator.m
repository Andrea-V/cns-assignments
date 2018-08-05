a=0.02; b=-0.1; c=-55; d=6;
V=-60; u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:100;
T1=tspan(end)/11;
T2=T1+5;
T3 = 0.7*tspan(end);
T4 = T3+10;
for t=tspan
    if ((t>T1) & (t < T1+2)) | ((t>T2) & (t < T2+2)) | ((t>T3) & (t < T3+2)) | ((t>T4) & (t < T4+2)) 
        I=9;
    else
        I=0;
    end;
    
    V = V + tau*(0.04*V^2+4.1*V+108-u+I); % diverso dal modello standard.
    u = u + tau*a*(b*V-u);
    if V > 30
        VV(end+1)=30;
        V = c;
        u = u + d;
    else
        VV(end+1) = V;
    end;
    uu(end+1) = u;
end;
plot(tspan,VV,[0 T1 T1 (T1+2) (T1+2) T2 T2 (T2+2) (T2+2) T3 T3 (T3+2) (T3+2) T4 T4 (T4+2) (T4+2) max(tspan)],-90+[0 0 10 10 0 0 10 10 0 0 10 10 0 0 10 10 0 0]);
axis([0 max(tspan) -90 30])

title('(L) integrator');
xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(L) integrator');