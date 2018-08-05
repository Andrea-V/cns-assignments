a=0.03; b=0.25; c=-60;  d=4;
V=-64;  u=b*V;
VV=[];  uu=[];
tau = 0.25; tspan = 0:tau:100;
for t=tspan
   if ((t>10) & (t < 15)) | ((t>80) & (t < 85)) 
        I=1;
    elseif (t>70) & (t < 75)
        I=-6;
    else
        I=0;
    end;
    
    [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I);
    
    V = V_new;
    u = u_new;
    VV(end+1) = V_ret;
    uu(end+1) = u_ret;
end;
plot(tspan,VV,[0 10 10 15 15 70 70 75 75 80 80 85 85 max(tspan)],...
          -85+[0 0  5  5  0  0  -5 -5 0  0  5  5  0  0]);
axis([0 max(tspan) -90 30])

title('(O) thresh. variability');

xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(O) thresh variability');