a=-0.02;  b=-1; c=-60;  d=8;
V=-63.8;  u=b*V;
VV=[];  uu=[];
tau = 0.5; tspan = 0:tau:350;
for t=tspan
       if (t < 50) | (t>250)
        I=80;
    else
        I=75;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 50 50 250 250 max(tspan)],-80+[0 0 -10 -10 0 0]);
axis([0 max(tspan) -90 30])

title('(S) inh. induced sp.');
xlabel('time (ms)');
ylabel('membrane potential (mV)');

savefig('(S) inh. induced sp.');