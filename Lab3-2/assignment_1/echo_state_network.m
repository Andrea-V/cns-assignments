function [W_in, W_hat] = echo_state_network(ni, nr, rho, leaky, scaling, connectivity)
    % create W_in e W_hat
    W_in = scaling * 2 * rand(nr, ni + 1) - 1;
    W_hat = 2 * rand(nr, nr) - 1;
    W_hat(rand(nr, nr) > connectivity) = 0;
    
    % adjusting W_hat for ESP with leaky parameter
    W_hat = (1-leaky) * eye(nr) + leaky * W_hat; 
    
    W_hat = W_hat * (rho / max(abs(eig(W_hat))) ); % necessary condition
    % W_hat = W_hat * (rho / norm(W_hat) ); % sufficient condition
end