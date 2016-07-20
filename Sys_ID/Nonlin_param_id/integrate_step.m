function xnext = integrate_step(x0, u0, uc0, Te, qS, dt,P)
%This is the ode15s integrator
options = odeset('RelTol', 5e-14);
[~, Y] = ode15s(@(t, x)model_trial_no_integral(x, u0, uc0, Te, qS, P, dt), [0, 1], x0, options);
xnext = Y(end, :)';
end