clc;
clear;

%% GENERATE DATASET
digits = load('digits.mat', 'dataset');
digits = digits.dataset;

% input patterns (memories)
U(1,:) = digits{1}(:);
U(2,:) = digits{2}(:);
U(3,:) = digits{3}(:);

%distorted patterns
Ud(1,:) = distort_image(U(1,:), 0.05);
Ud(2,:) = distort_image(U(2,:), 0.05);
Ud(3,:) = distort_image(U(3,:), 0.05);

ipat = 3;
maxpat = 10;
%% INIT NETWORK
N = size(U, 2); % # of neurons
c = 1 / N;
M = c * (U' * U) ; % weight matrix

I = ones(N,1)*0.5; % bias

% remove self-recurrent connections
for i = 1:size(M, 1)
    M(i, i) = 0;
end

mean_overlaps = [];

while size(U, 1) <= maxpat
    %% RETRIEVE DISTORTED PATTERNS
    % for each test pattern in Ud
    pattern_overlaps = [];

    for i=1:size(Ud,1)
        fprintf('- Retrieving pattern %d...\n', i);
        % extract pattern i
        k = 1;
        eps = 1e-3;
        t = 1;
        u = Ud(i,:);

        % init state, activations and energy
        xs = (M*u')';
        vs = u;

        % compute initial energy for u  
        energy = (-1/2) * u * (M * u') - u * I; 
        es = [energy];

        % compute initial overlaps with 3 memories 
        %overlap(1) = c * (U(1,:) * u');
        %overlap(2) = c * (U(2,:) * u');
        %overlap(3) = c * (U(3,:) * u');

        %os = [overlap];

        % retrive pattern i
        energy_old = energy;
        while true
            energy_old = energy;
            % for each neuron (asynchronous update)
            for j = randperm(N)
                t = t + 1;

                % init current state (to previous one)
                x = xs(t-1, :);
                v = vs(t-1, :);

                % update neuron j (state and activation)
                x(j) = M(j,:) * vs(t-1, :)' + I(j);
                if x(j) <= 0 
                    v(j) = -1;
                else
                    v(j) = 1;
                end

                %update overlaps with 3 memories
                %overlap(1) = c * (U(1,:) * v');
                %overlap(2) = c * (U(2,:) * v');
                %overlap(3) = c * (U(3,:) * v');

                % update energy of network
                energy = (-1/2) * v * (M * v') - v * I;

                %store new state, activations, overlaps and energy
                xs = [xs; x];
                vs = [vs; v];
                %os = [os; overlap];
                es(end+1) = energy;
            end

            fprintf('- epoch: %d, network energy: %f, energy gain: %f\n', k, energy, abs(energy - energy_old));
            k = k +1;
            if abs(energy - energy_old) < eps
                break
            end
        end

        % computing final overlap
        original  = U(i, :);
        retrieved = vs(end, :);
        o = c * (original * retrieved');
        pattern_overlaps(i) = o;
        fprintf('- Final overlap of pattern %d: %f\n', i, o);
    end
    
    mean_overlaps(end + 1) = mean(pattern_overlaps);
    fprintf('Mean overlap with %d memories: %f\n', size(Ud, 1), mean_overlaps(end));
    
    %% ADD NEW PATTERN
    ipat = ipat + 1;
    
    if ipat > maxpat
        break
    end
    
    fprintf('Adding pattern %d to memories...\n', ipat);
    U(ipat, :)  = digits{ipat}(:);
    Ud(ipat, :) = distort_image(U(ipat,:), 0.05);
    
    M = (1 - c) * M + c * U(ipat, :)' * U(ipat, :);
end

%% PLOT
figure
plot(3:size(Ud, 1), mean_overlaps);
ylabel('mean overlap');
xlabel('stored memories');
