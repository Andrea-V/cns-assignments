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

%% LOAD VARS
final_Ne = load('final_Ne.mat', 'best_Ne');
final_Ni = load('final_Ni.mat', 'best_Ni');
Wout = load('Wout.mat');

Wout = Wout.Wout;
final_Ne = final_Ne.best_Ne;
final_Ni = final_Ni.best_Ni;

 %% PLOT
states_tr = liquid_state_machine(final_Ne, final_Ni, [X_tr X_val]); 
y_tr_pred = Wout * states_tr;
error_tr = mean(abs(y_tr_pred - [y_tr y_val]));

% plot training result
plot(1:size(y_tr_pred, 2), y_tr_pred);
hold on;
plot(1:size([y_tr y_val], 2), [y_tr y_val]);
title('output vs target (TR + VAL)');
legend ('output', 'target');
xlabel('time');
ylabel('value');
savefig('TR_VAL')
hold off;

%testing on test set
states_ts = liquid_state_machine(final_Ne, final_Ni, X_ts);
y_ts_pred = Wout * states_ts;
error_ts = mean(abs(y_ts_pred - y_ts));

fprintf('*** Final Model ***\n');
fprintf('- Params: Ne: %d, Ni:%d\n', final_Ne, final_Ni);
fprintf('- Error TR: %f, Error TS: %f\n', error_tr, error_ts);

% plot test result
plot(1:size(y_ts_pred, 2), y_ts_pred);
hold on;
plot(1:size(y_ts, 2), y_ts);
title('output vs target (TS)');
legend ('output', 'target');
xlabel('time');
ylabel('value');
savefig('TS')
hold off;