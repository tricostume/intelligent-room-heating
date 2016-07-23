% As it will be needed to tune the cooling paramters, the parameter
% vector must be enlarged and intelligent initial guesses must be
% proposed.
% TEST 1: BEFORE OPTIMISATION
% load('P_init_with_sun_and_unbounded_prop_control.mat');
% P0 = [P0; zeros(3,1)];
% P0(19) = 20*P0(11); % Kucx
% P0(20) = 20*P0(12); % Kuc10
% P0(21) = 20*P0(13); % Kuc11

%TEST 2: AFTER OPTIMISATION
load('P_init_sun_unboundedcontrols_and_cooling.mat')
% Relaxed Kxe
P_temp = zeros(70,1);
P_temp(1) = P0(1);
P_temp(2) = P0(1);
P_temp(3) = P0(2);
P_temp(4) = P0(2);
P_temp(5) = P0(2);
P_temp(6) = P0(2);
P_temp(7) = P0(2);
P_temp(8) = P0(3);
P_temp(9) = P0(1);
P_temp(10) = P0(1);
P_temp(11) = P0(4);
P_temp(12) = P0(5);
% Relaxed Kxy
for i=13:20
   P_temp(i) = P0(6); 
end
P_temp(21) = P0(7);
P_temp(22) = P0(6);
P_temp(23) = P0(10);
for i=24:30
   P_temp(i) = P0(7); 
end
P_temp(31) = P0(8);
P_temp(32) = P0(9);
for i=33:42
   P_temp(i) = P0(11); 
end
P_temp(43) = P0(12);
P_temp(44) = P0(13);
for i=45:54
   P_temp(i) = P0(19); 
end
P_temp(55) = P0(20);
P_temp(56) = P0(21);
for i=57:66
   P_temp(i) = P0(14); 
end
P_temp(67) = P0(15);
P_temp(68) = P0(16);
P_temp(69) = P0(17);
P_temp(70) = P0(18);

P0=P_temp;
