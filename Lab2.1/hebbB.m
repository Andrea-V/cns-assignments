
U = load('hebbdata.mat', 'data');
U = U.data;

%subtract the mean
mu = mean(U(:));
U = U - mu;

%% INIT
n = 2;
w = 2 * (rand(1, n) - 0.5); % random bw -1 and 1
eps = 1e-6; % tolleranza
eta = 0.0001; % learning rate
alpha = 1; % regularization
kmax = 1000 ; % max iterations
k = 0;
t = 0;
ws = [];
normws = [];

%% OJA RULE
while true
    k = k + 1;
    w_old = w;

    U = U(randperm(size(U, 1)),:); % permute rows
    
    for i = 1:size(U, 1)
        t = t + 1;
        v = w * (U(i,:))';
        w = w + eta * v * U(i,:) - alpha * v * v * w;
        %w = w + eta * U(i,:) * U(i,:)' * w - alpha * v * v * w;
        
        ws = [ ws; w ];
        normws = [normws, norm(w)];
    end
    
    fprintf('k: %d,\tres:%.5f \tw:[ %.5f %.5f ]\n', k, norm(w-w_old), w);
    if norm(w - w_old) < eps || k > kmax
        break
    end
end

%% PLOT
% normalize w and center U
w = w/norm(w);
mu = mean(U(:));
U = U - mu;

figure
hold on;
plot(U(:,1), U(:,2), '.');
plotv(w');

% extracting max eigvalue
Q = U' * U;
[eigvecs, eigvals] = eig(Q);
eigvals = diag(eigvals);
[max_v, max_i] = max(eigvals);

plotv(eigvecs(:,max_i));
legend('input data', 'weight vector', 'max eigvector');

% W over time
figure
plot(1:t, ws(:, 1));
xlabel('time');
title('w(1) over time');

figure
plot(1:t, ws(:,2));
xlabel('time');
title('w(2) component over time');

% norm(w) over time
figure
plot(1:t, normws);
xlabel('time');
title('norm(w) over time');
