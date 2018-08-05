clc
clear
%% LOAD DATASET

load laser_dataset;
dataset = cell2mat(laserTargets);

%load MGtimeseries;
%dataset = cell2mat(MGtimeseries);

dataset = mapminmax(dataset); % scaling to [-1 1]

X = dataset(1:end-1);
y = dataset(2:end);

X_tr = X(1:4000);
y_tr = y(1:4000);

X_val = X(4001:5000);
y_val = y(4001:5000);

X_ts = X(5001:end);
y_ts = y(5001:end);

% add biases to data
X_tr  = [X_tr; ones(1, size(X_tr, 2))]; 
X_val = [X_val; ones(1, size(X_val, 2))];
X_ts  = [X_ts; ones(1, size(X_ts, 2))];

ni = size(X, 1);

%% PARAM GRID
nrs = [10 20 50 100];           % reservoir units
as = [0.9 0.7 0.5 0.3 0.1];             % leaky parameter
rhos = [0.7 0.8 0.9 0.99];      % spectral radius
lambdas = [1e-5 1e-3 1e-4];     % regularization
scalings = [1 0.1 0.01];        % input scaling
connectivities = [0.9 0.7 0.5 0.3 0.1]; % # of connected units
ntransients = [100];            % lenght of initial transient

esn_pool = 5;

%% GRID SEARCH
nr_best = 0;
a_best = 0;
rho_best = 0;
lambda_best = 0;
scaling_best = 0;
connectivity_best = 0;
ntransient_best = 0;

error_tr_best = Inf;
error_val_best = Inf;

W_in_best = [];
W_hat_best = [];
W_out_best = [];

fprintf('- begin grid search\n');

for nr = nrs
for rho = rhos
for a = as
for lambda = lambdas
for scaling = scalings
for connectivity = connectivities
for ntransient = ntransients
fprintf('\n- params: nres: %d,\trho: %f,\t a: %f,\tlambda: %f,\tscaling: %f,\tconnectivity: %f,\ttransient: %d\n',...
    nr, rho, a, lambda, scaling, connectivity, ntransient); 

    %% ESN TRAINING
    err_pool_tr = [];
    err_pool_val = [];
        
    for i=1:esn_pool
        % training
        [W_in, W_hat] = echo_state_network(ni, nr, rho, a, scaling, connectivity);
        [ W_out, output_tr, err_tr ] = esn_train(X_tr, y_tr, W_in, W_hat, a, lambda, ntransient);
        err_pool_tr(end + 1) = err_tr;
        
        % validation
        [ output_val, err_val ] = esn_score(X_val, y_val, W_in, W_hat, W_out, a, ntransient);
        err_pool_val(end + 1) = err_val;
    end
    
    % considering the mean of pool
    error_tr  = mean(err_pool_tr);
    error_val = mean(err_pool_val);
    fprintf('-- TR error: %f,\t - VAL error: %f\n', error_tr, error_val);
    
    % check to find a new best
    if error_val < error_val_best
        fprintf('-- FOUND NEW BEST!\n');
        %save errors
        error_val_best = error_val;
        error_tr_best = error_tr;
        
        %save parameters
        a_best = a;
        nr_best = nr;
        rho_best = rho;
        lambda_best = lambda;
        scaling_best = scaling;
        connectivity_best = connectivity;
        ntransient_best = ntransient;
    end
end
end
end
end
end
end
end
fprintf('- end grid search\n')
fprintf('\n- best params: nres: %d,\trho: %f,\t a: %f,\tlambda: %f,\tscaling: %f,\tconnectivity: %f,\ttransient: %d\n',...
    nr_best, rho_best, a_best, lambda_best, scaling_best, connectivity_best, ntransient_best);   
fprintf('- best TR error: %f,\t - best VAL error: %f\n', error_tr_best, error_val_best);

%% TRAIN WITH FULL DATASET (TR+VAL)
fprintf('- retraining model with full dataset\n');

err_pool_tr = [];
err_pool_ts = [];
outputs_ts = [];
y_tr_pred_pool = [];
y_ts_pred_pool = [];

for i = 1:2*esn_pool
    % training
    [W_in, W_hat] = echo_state_network(ni, nr_best, rho_best, a_best, scaling_best, connectivity_best);
    [ W_out, y_tr_pred, error_tr ] = esn_train([X_tr X_val], [y_tr y_val], W_in, W_hat, a_best, lambda_best, ntransient_best);
    err_pool_tr(end + 1) = error_tr;
    y_tr_pred_pool = [y_tr_pred_pool; y_tr_pred];
    
    % test
    [ y_ts_pred, error_ts ] = esn_score(X_ts, y_ts, W_in, W_hat, W_out, a_best, ntransient_best);
    err_pool_ts(end + 1) = error_ts;
    y_ts_pred_pool = [y_ts_pred_pool; y_ts_pred];
end

% considering the mean of pool
error_tr_final  = mean(err_pool_tr);
error_ts_final  = mean(err_pool_ts);

y_tr_pred = mean(y_tr_pred_pool, 1);
y_ts_pred = mean(y_ts_pred_pool, 1);


fprintf('- final TR error: %f,\t - final TS error: %f\n', error_tr_final, error_ts_final);

% saving results
save('esn_lab32_results.mat', 'W_in', 'W_hat', 'W_out', 'error_tr_final', 'error_ts_final',...
     'nr_best', 'rho_best', 'lambda_best', 'scaling_best', 'connectivity_best', 'ntransient_best');

%% PLOT
% target vs output
figure
subplot(2, 1, 1);
hold on
y_temp = [y_tr y_val];
plot(1:size(y_tr_pred, 2), y_temp(:,ntransient_best:end));
plot(1:size(y_tr_pred, 2), y_tr_pred);
title('target vs output (TR+VAL)');
legend('target', 'output');


subplot(2, 1, 2);
hold on
plot(1:size(y_ts_pred, 2), y_ts(:,ntransient_best:end));
plot(1:size(y_ts_pred, 2), y_ts_pred);
title('target vs output (TS)');
legend('target', 'output');

print('esn_output_target','-dpng');
savefig('esn_output_target');

