function [ X, U_prop, U_int, Uc_prop,time] = simulate_series_graph(T_rooms,u_rooms, u_cooling, Te, qS,Ts,samples,P)
%1. Initial state for this example
xss0 = [T_rooms(:,1); zeros(12,1)];
%2. Matrices initialisation 
% New variable introduced for variable sampling: Notice Ts must be bigger
% than 3600 and integer with respect to Ts (no decimals).
step = ceil(Ts/3600);
time = 1:step:samples;
mod_samples = ceil(samples/step);
nx = length(xss0);
nu = size(u_rooms,1);
X = zeros(nx, mod_samples);
U = zeros(nu,mod_samples-1);
U_prop = zeros(nu,mod_samples-1);
U_int = zeros(nu,mod_samples-1);
Uc_prop = zeros(nu,mod_samples-1);
X(:, 1) = xss0;
flag_aux_i = 1;

for k = 1:step:samples
    % Resize iteration number
    if k==1
       count = 1;
    else
        count = ceil(k/step);
    end
    disp(['iter ' num2str(count)]);
    x = X(:, count);
    % Redefinition of control: In reality we control with a heat flow and
    % not with a temperature set point. This only applies if the set point
    % is different to zero (notice we have unitary gain):
    u = u_rooms(:,k);
    uc = u_cooling(:,k);
    t_ext = Te(k);
    qS_k = qS(:,k);
    previous_states = x;
    [u, uc] = adjust_controls (u, uc, x);
    u_prop = u .* (20*u-x(1:12));
    u_int = u .*x(13:24);
    uc_prop = uc .* (26*uc-x(1:12));
    %model(x,u,t_ext)
    if k>=133
        % This is to avoid integral control grow at every heating
        % activation, for now we are lucky that at sample 133 all of the
        % required heating ups happened. In reality this is again a vector
        % for conditions of each room.
       flag_aux_i=0; 
    end
    x = integrate_step(x, u, uc, t_ext, qS_k, Ts,P);
    x = adjust_i_states(previous_states,x, flag_aux_i);
    X(:, count + 1) = x;
    U(:,count) = u;
    U_prop(:,count)=u_prop;
    U_int(:,count)=u_int;
    Uc_prop(:,count)=uc_prop;
end
global i_states;
i_states = X(13:24,:);
% This graphing section should be uncommented if this function would
% need further tuning.
figure
clf
for i=1:nx-12
    ax(i) = subplot(4,3,i);
    plot(20*u_rooms(i,1:samples),'g--')
    hold on
    plot(26*u_cooling(i,1:samples),'m--')
    plot(time,X(i,1:mod_samples),'r')
    plot(T_rooms(i,1:samples))
    title(['Room' num2str(i-1)])
    ylabel('Temp[°]')
end
%linkaxes (ax,'x');
%linkaxes (ax,'y');
end

