%% Run this in order to see simulation results!
clear all; clc; close all;
%0. Load measured data
M = csvread('MyDesign_EnergyUse.csv',1,1);
T_rooms = M(:,1:3:end);
T_sp = 20;
% Control normalisation (used below in control redefinition)
u_rooms = M(:,2:3:end)'/20;
%u_rooms = u_rooms .* (T_sp*u_rooms-T_rooms);
Te = M(:,3);
%1. Set sampling time and numer of samples (specified in hours here)
Ts = 1;
N = size(M,1);
%2. Initial state for this example
xss0 = T_rooms(1,:)';
%3. Matrices initialisation 
nx = length(xss0);
nu = size(u_rooms,1);
X = zeros(nx, N);
U = zeros(nu,N-1);
X(:, 1) = xss0;
T = 0:Ts:((N-1)*Ts);
samples = 500;
%%
%4. Simulation loop
for k = 1:samples
    x = X(:, k);
    % Redefinition of control: In reality we control with a heat flow and
    % not with a temperature set point. This only applies if the set point
    % is different to zero (notice we have unitary gain):
    u = u_rooms(:,k) .* (T_sp*u_rooms(:,k)-x);
    t_ext = Te(k);
    %model(x,u,t_ext)
    x = integrate_step(x, u, t_ext, 3600*Ts);
    X(:, k + 1) = x;
    U(:,k) = u;
    disp(['Iter ' num2str(k)]);
end
figure
for i=1:nx
    subplot(4,3,i)
    plot(X(i,1:samples),'r')
    hold on
    plot(T_rooms(1:samples,i))
    title(['Room' num2str(i)])
    ylabel('Temp[°]')
end