function [ output ] = esn_predict(X, W_in, W_hat, W_out, ntransient)
    [ states ] = esn_states(X, W_in, W_hat);

    % discard transient
    states = states(:, ntransient:end);     
    % add bias
    states = [ states; ones(1, size(states, 2)) ];
    
    output = W_out * states;
end

