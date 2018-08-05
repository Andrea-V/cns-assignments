load valve_dataset;

X = cell2mat(valveInputs);
y = cell2mat(valveTargets);

% TR set
X_tr = X(1:1000);
y_tr = y(1:1000);

% VAL set
X_val = X(1001:1500);
y_val = y(1001:1500);

% TS set
X_ts = X(1501:1801);
y_ts = y(1501:1801);

% final params
best_Ne = 0;
best_Ni = 0;
best_error_val = Inf;
best_error_tr = Inf;

% param grid
Nes = [1 2 5 10 20 50 100];
Nis = [1 2 5 10 20 50 100];

%% MODEL SELECTION
fprintf('*** MODEL SELECTION ***\n')
for Ne = Nes
    for Ni = Nis
        fprintf('- Params: Ne: %d, Ni:%d\n', Ne, Ni);
        %% TRAINING
        states_tr = liquid_state_machine(Ne, Ni, X_tr);
        Wout = y_tr * pinv(states_tr);

        y_tr_pred = Wout * states_tr;
        error_tr = mean(abs(y_tr_pred - y_tr));

        %% VALIDATION
        states_val = liquid_state_machine(Ne, Ni, X_val);
        y_val_pred = Wout * states_val;
        error_val = mean(abs(y_val_pred - y_val));
        
        %% SELECTION
        fprintf('- TR error: %f, VAL error: %f\n', error_tr, error_val);
        if error_val < best_error_val
            fprintf('-- New best found!\n');
            best_error_val = error_val;
            best_error_tr = error_tr;
            best_Ne = Ne;
            best_Ni = Ni;
        end
    end
end
fprintf('******\n')
fprintf('- Best Params: Ne: %d, Ni:%d\n', best_Ne, best_Ni);
fprintf('- Best TR error: %f, VAL error: %f\n', best_error_tr, best_error_val);

%% SAVE 
% retrain on full training set
states_tr = liquid_state_machine(best_Ne, best_Ni, [X_tr X_val]);
Wout = [y_tr y_val] * pinv(states_tr);
save('Wout.mat', 'Wout');
save('final_Ne.mat', 'best_Ne');
save('final_Ni.mat', 'best_Ni');
