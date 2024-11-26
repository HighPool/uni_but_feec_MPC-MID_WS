% MATLAB Script for System Identification using MNČ and IV
clear; clc;

%% 1. Data Collection
% Generate PRBS input signal
N = 1000; % Number of samples
u = idinput(N, 'prbs'); % Pseudo-Random Binary Sequence
t = (1:N)'; % Time vector

% Call to odezva_2024.p to collect data
% Assuming odezva_2024 outputs system response 'y' for input 'u'
[y] = odezva_2024(217099,u,t);  % Uncomment and replace with actual function call
y = 0.8*u + 0.2*randn(size(u)); % Simulated output (placeholder for testing)

% Split into training and validation
train_ratio = 0.7;
train_size = round(train_ratio * N);
u_train = u(1:train_size);
y_train = y(1:train_size);
u_val = u(train_size+1:end);
y_val = y(train_size+1:end);

%% 2. Model Identification
na = 1; % Order of the output (y)
nb = 1; % Order of the input (u)
d = 1;  % Delay

% Construct Regression Matrix (Φ) for MNČ
Phi_mnc = [-y_train(1:end-1), u_train(1:end-1)];
Y_train = y_train(2:end);

% MNČ Estimation
theta_mnc = (Phi_mnc' * Phi_mnc) \ (Phi_mnc' * Y_train);

% Construct Instrumental Variables (ζ)
Phi_iv = [-y_train(1:end-1), u_train(1:end-1)];
Zeta = [-y_train(1:end-2), u_train(1:end-2)]; % Delayed observations

% IV Estimation
theta_iv = (Zeta' * Phi_iv) \ (Zeta' * Y_train(2:end));

%% 3. Validation
% Generate predictions for validation data
Phi_val = [-y_val(1:end-1), u_val(1:end-1)];
y_pred_mnc = Phi_val * theta_mnc;
y_pred_iv = Phi_val * theta_iv;

% Plot Results
figure;
plot(2:length(y_val), y_val(2:end), 'b', 'DisplayName', 'Actual Output');
hold on;
plot(2:length(y_val), y_pred_mnc, 'r--', 'DisplayName', 'MNČ Output');
plot(2:length(y_val), y_pred_iv, 'g--', 'DisplayName', 'IV Output');
legend;
xlabel('Time');
ylabel('Output');
title('Validation: Actual vs Modeled Outputs');

%% 4. Results Summary
fprintf('MNČ Parameters:\n');
disp(theta_mnc);
fprintf('IV Parameters:\n');
disp(theta_iv);
