%% INIT
%input patterns
U = [-1 -1 +1 -1 +1 -1 -1 +1;
     -1 -1 -1 -1 -1 +1 -1 -1;
     -1 +1 +1 -1 -1 +1 -1 +1];

N = size(U, 2); % # of neurons
c = 1 / N;
M = c * (U' * U) ; % weight matrix
I = zeros(N, 1); % no bias

% remove self-recurrent connections
for i = 1:size(M, 1)
    M(i, i) = 0;
end

%% CHECK STORED PATTERNS

for i = 1:size(U,1)
    v = zeros(N, 1);
    u = U(i,:);
    
    % retrieve activation
    x = M*u'; 
    v(x <= 0) = -1;
    v(x > 0) = 1;
    
    % measure of similarity (overlap)
    overlap = c * (u * v);
    fprintf('- Overlap of stored pattern %d: %f\n', i, overlap);
end

%% RETRIEVE DISTORTED PATTERNS
Ud = [+1 -1 +1 -1 +1 -1 -1 +1;
      +1 +1 -1 -1 -1 +1 -1 -1;
      +1 +1 +1 -1 +1 +1 -1 +1];

N = size(Ud, 2);
c = 1 / N;

% for each test pattern
for i=1:size(Ud,1)
    % extract pattern i
    eps = 1e-3;
    t = 1;
    u = Ud(i,:);
    
    % init state, activations and energy
    xs = (M*u')';
    vs = u;
    
    energy = (-1/2) * u * (M * u') - u * I; % compute initial energy for u
    es = [energy];
    
    % retrive pattern i
    while true        
        % for each neuron (asynchronous update)
        for j = randperm(N)
            % init current state (to previous one)
            t = t + 1;
            x = xs(t-1, :);
            v = vs(t-1, :);
            
            % update neuron j (state and activation)
            x(j) = M(j,:) * vs(t-1, :)';
            if x(j) <= 0 
                v(j) = -1;
            else
                v(j) = 1;
            end
            
            % update energy of network
            energy_old = energy;
            energy = (-1/2) * v * (M * v') - v * I;
            
            %store new state, activations and energy
            xs = [xs; x];
            vs = [vs; v];
            es(end+1) = energy;
        end

        if abs(energy - energy_old) < eps
            break
        end
    end
    
    %check overlap of retrived pattern with original one
    retrived = vs(end, :);
    original = U(i, :);
    overlap = c * (original * retrived');
    fprintf('- Overlap of retrieved pattern %d: %f\n', i, overlap);
    
    % plot neurons activations over time
    figure
    hold on
    for j = 1:N
        plot(1:t, vs(:,j));
    end
    ylim([-1.1 1.1]);
    title(sprintf('Pattern %d: neuron activations over time.', i));
    ylabel('activation');
    xlabel('epoch');
    legend('show');
end
    
    