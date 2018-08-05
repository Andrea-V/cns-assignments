function [ W_out, output, error ] = esn_train(X, y, W_in, W_hat, leaky, lambda, ntransient)
    states = esn_states(X, W_in, W_hat, leaky);

    % discard transient
    states = states(:, ntransient:end);     
    % add bias
    states = [ states; ones(1, size(states, 2)) ];

    y = y(:, ntransient:end); 

    % train readout and compute error
    W_out = (y * states') / (states * states'  + lambda * eye(size(W_hat, 1) + 1)); % ridge regression     

    output = W_out * states;
    error = immse(output, y);
end

