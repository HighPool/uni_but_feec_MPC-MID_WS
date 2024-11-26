% Dynamic System Identification Using Least Squares (MNČ) and Instrumental Variables (IV)
% Author: [Your Name]
% Date: [Today’s Date]

% Step 1: Generate Input Signal
disp('Generating input signal...');
fs = 100; % Sampling frequency (Hz)
N = 1000; % Number of samples
prbs_signal = idinput(N, 'prbs', [0 1], [-1 1]); % PRBS input signal
plot(prbs_signal); title('Input Signal (PRBS)'); xlabel('Samples'); ylabel('Amplitude');

% Step 2: Collect System Data
disp('Collecting system data...');
% Load system simulation function (replace with actual function name)
output_signal = odezva_2024(prbs_signal);

% Step 3: Preprocess Data
disp('Preprocessing data...');
% Handle delays, remove offsets, or correct faulty readings (example below handles delays)
delay = 1; % Example delay in samples
u = prbs_signal(1:end-delay); % Delayed input
y = output_signal(delay+1:end); % Corresponding output
t = (1:length(u))' / fs; % Time vector for plotting

% Step 4: Construct Regression Matrix
disp('Constructing regression matrix...');
na = 2; % Number of output lags
nb = 2; % Number of input lags
Phi = [];
for i = 1:length(y) - max(na, nb)
    row = [-y(i:i+na-1)', u(i:i+nb-1)']; % Delayed outputs and inputs
    Phi = [Phi; row];
end
Y = y(max(na, nb)+1:end); % Output vector

% Step 5: Solve for Model Parameters Using Least Squares
disp('Estimating parameters using Least Squares...');
theta_ls = (Phi' * Phi) \ (Phi' * Y); % Least Squares solution
disp('Estimated Parameters (Least Squares):');
disp(theta_ls);

% Step 6: Optionally Apply Instrumental Variables (IV)
disp('Applying Instrumental Variables (optional)...');
% Generate instrumental variables matrix
Z = []; % Replace with proper IV construction if needed
for i = 1:length(y) - max(na, nb)
    row = [-y(i-delay:i+na-1-delay)', u(i-delay:i+nb-1-delay)']; % Delayed by additional samples
    Z = [Z; row];
end
theta_iv = (Z' * Phi) \ (Z' * Y); % IV solution
disp('Estimated Parameters (Instrumental Variables):');
disp(theta_iv);

% Step 7: Validate the Model
disp('Validating the model...');
% Generate validation input
validation_input = idinput(N, 'prbs', [0 1], [-1 1]); % PRBS for validation
validation_output = odezva_2024(validation_input); % Obtain validation output

% Simulate model response
validation_u = validation_input(1:end-delay);
validation_y = validation_output(delay+1:end);
Phi_val = [];
for i = 1:length(validation_y) - max(na, nb)
    row = [-validation_y(i:i+na-1)', validation_u(i:i+nb-1)'];
    Phi_val = [Phi_val; row];
end
model_response = Phi_val * theta_ls; % Simulated response using LS parameters

% Plot validation results
figure;
plot(validation_y(max(na, nb)+1:end), 'b'); hold on;
plot(model_response, 'r--');
legend('Actual Output', 'Modeled Output');
title('Validation Results');
xlabel('Samples'); ylabel('Amplitude');

% Step 8: Finalize and Document
disp('Wrapping up...');
% Save parameters and results
save('model_params.mat', 'theta_ls', 'theta_iv');
disp('Model identification complete!');
