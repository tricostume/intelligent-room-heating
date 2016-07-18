function xnext = integrate_step(x0, u0, Te, dt)
%This is the ode15s integrator
options = odeset('RelTol', 5e-14);
[~, Y] = ode15s(@(t, x)model(x, u0, Te), [0, dt], x0, options);
xnext = Y(end, :)';
end