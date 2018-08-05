function [ output, error ] = esn_score(X, y, W_in, W_hat, W_out, leaky, ntransient)
    [ states ] = esn_states(X, W_in, W_hat, leaky);

    % discard transient
    states = states(:, ntransient:end);     
    % add bias
    states = [ states; ones(1, size(states, 2)) ];

    y = y(:, ntransient:end); 

    output = W_out * states;
    error = immse(output, y);
end

