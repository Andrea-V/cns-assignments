a=0.02;  b=1; c=-55;  d=4;
V=-65;  u=-16;
VV=[];  uu=[];  II=[];
tau = 0.5; tspan = 0:tau:400;
for t=tspan
    if (t < 200)
        I=t/25;
    elseif t < 300
        I=0;
    elseif t < 312.5
        I=(t-300)/12.5*4;
    else
        I=0;
    end;
    
    V = V + tau*(0.04*V^2+5*V+140-u+I);
    u = u + tau*a*(b*(V+65)); % diverso rispetto al modello standard.
    if V > 30
        VV(end+1) = 30;
        V = c;
        u = u + d;
    else
        VV(end+1) = V;
    end;
    uu(end+1) = u;
    II(end+1) = I;
end;
plot(tspan,VV,tspan,II*1.5-90);
axis([0 max(tspan) -90 30])

title('(R) accomodation');
xlabel('time (ms)');
ylabel('membrane potential (mV)');
savefig('(R) accomodation');