clear
clc
%% LOAD DATASET
dataset = load('digitRBM.mat');
data    = dataset.data;
targets = dataset.targets;

Nd = size(data, 1);
Ni = size(data, 2);

%% INIT RBM
nhidden = 1000;

% weight matrix
M = 0.01 * (randn(Ni, nhidden) - 0.5);

% applies sigmoid transfer function to a vector
sigmoid = @(a) 1.0 ./ (1.0 + exp(-a));

% biases
b_hidden = zeros(nhidden ,1);  % hidden
b_visible = zeros(Ni, 1);      % visible

%% TRAIN RBM
k = 0;
max_epochs = 50;
eta = 0.001;
errors = [Inf];

while true
    
    deltaM = zeros(Ni, nhidden);
    error = 0;
    
    
    % train rbm with each sample
    for i = 1:Nd
        % clamp training vector to visible units
        v0 = data(i,:)' > rand(Ni,1);
        
        % update all hidden units
        h0 = sigmoid(M' * v0 + b_hidden) > rand(nhidden,1);

        % update visible units to get reconstruction
        v1 = sigmoid(M * h0 + b_visible) > rand(Ni, 1);

        % update hidden units again
        h1 = sigmoid(M' * v1 + b_hidden) > rand(nhidden,1);
        
        % convert logical to numerical
        h0 = double(h0);
        h1 = double(h1);
        deltaM = deltaM + (v0 * h0') / Nd - (v1 * h1') / Nd ;
       
        % Using directly probability pj to update M
        % h0 = sigmoid(M' * v0 + b_hidden);
        % h1 = sigmoid(M' * v1 + b_hidden);
        % deltaM = deltaM + (v0 * h0') / Nd - (v1 * h1') / Nd;
        
        error = error + norm(v0 - v1);
    end
    
    errors(end + 1) = error / Nd; % mean error over tr samples
    
    % weights update
    M = M + eta * deltaM;
    k = k + 1;
    fprintf('- epoch %d, error: %f\n', k, errors(end));
    
    if k > max_epochs
        break
    end
end

%% PLOT ERROR
figure
plot(1:size(errors, 2), errors);
title('training error');
xlabel('epoch');
ylabel('error');

%% PLOT WEIGHTS
figure
for i=1:nhidden
   subplot(1, nhidden, i);
   imshow(reshape(M(:,i), 28, 28));
   title(sprintf('unit %d', i));
end


%% PLOT RECONSTRUCTION

X_ts = [ data(7,:);
      data(1550,:);
      data(3100,:);
      data(3300,:);
      data(4702,:);
      data(5502,:);
      data(6623,:);
      data(8000,:);
      data(8494,:);
      data(end-12,:)
];

for i = 1:10
    v0 = X_ts(i,:)' > rand(Ni,1);
    h0 = sigmoid(M' * v0 + b_hidden) > rand(nhidden,1);
    v1 = sigmoid(M * h0 + b_visible) > rand(Ni, 1);
    h1 = sigmoid(M' * v1 + b_hidden) > rand(nhidden,1);
    
    figure
    subplot(1,3,1);
    imshow(reshape(X_ts(i,:),28,28));
    title('original');
    subplot(1,3,2);
    imshow(reshape(v0,28,28));
    title('input (v0)');
    subplot(1,3,3);
    imshow(reshape(v1,28,28));
    title('reconstructed (v1)');
end