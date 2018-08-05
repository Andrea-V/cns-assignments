
function [V_ret, u_ret, V_new, u_new] = izhikevich(tau, a, b, c, d, V, u, I)
    V = V + tau*(0.04*V^2+5*V+140-u+I);
    u = u + tau*a*(b*V-u);
    
    if V > 30
        V_ret = 30;
        V_new = c;
        u = u + d;
    else
        V_ret = V;
        V_new = V;
    end;
    
    u_ret = u;
    u_new = u;
end

