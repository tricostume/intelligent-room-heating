function [xdot] = model_integrating_input(x, u, Te)
%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Thesis: 
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Model of the thermal dynamics used for linear simulation 
%Description: This model already includes the estimated parameters.
%State vector x:
%T_0                 %deegres
%T_1                 %deegres
% .......               .....
%T_11                %deegres
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% State vector definition
% Rooms' temperature
T0 = x(1); u0 = u(1) * (20*u(1)-x(1));
T1 = x(2); u1 = u(2) * (20*u(2)-x(2));
T2 = x(3); u2 = u(3) * (20*u(3)-x(3));
T3 = x(4); u3 = u(4) * (20*u(4)-x(4));
T4 = x(5); u4 = u(5) * (20*u(5)-x(5));
T5 = x(6); u5 = u(6) * (20*u(6)-x(6));
T6 = x(7); u6 = u(7) * (20*u(7)-x(7));
T7 = x(8); u7 = u(8) * (20*u(8)-x(8));
T8 = x(9); u8 = u(9) * (20*u(9)-x(9));
T9 = x(10); u9 = u(10) * (20*u(10)-x(10));
% Lounge temperature
T10 = x(11); u10 = u(11) * (20*u(11)-x(11));
% Middle corridor temperature
T11 = x(12); u11 = u(12) * (20*u(12)-x(12));

%Integral states for improved control
ui0 = 0;
ui1 = u(2)*x(13);
ui2 = u(3)*x(14);
ui3 = 0;
ui4 = u(5)*x(15);

% Exogenous input: External temperature in time
Te = Te; 
%2. Control signal: A simple proportional error is proposed for each room
% until now this represents a heat source with 100% efficiency.
% u0,u1...u11
%% 3. Constants used in this model
% These constants can be opened to any multiplication of subparameters and
% represent a generic representation of the model.

% Transmission factors
% From inner rooms to external (e) ambient. 
% Units to be opened up [J/(s K)] Direction of flow Kxy x->y
% For now we tune with these two coefficients by hand after estimating 
% parameters with physical formulas
mult = 3;
mult_ext = 0.6;

K0_e = mult_ext*15.4; K1_e = mult_ext*15.4; K2_e = mult_ext*14.2; K3_e = mult_ext*14.2; K4_e = mult_ext*14.2; K5_e = mult_ext*14.2; 
K6_e = mult_ext*14.2; K7_e = mult_ext*1.8; K8_e = mult_ext*15.4; K9_e = mult_ext*15.4; K10_e = mult_ext*32; K11_e = mult_ext*3.6;
% Between bedrooms
K0_2 = mult*12; K0_11 = mult*18; 
K1_3 = mult*12; K1_11 = mult*18; 
K2_4 = mult*12; K2_11 = mult*18;
K3_5 = mult*12; K3_11 = mult*18; 
K4_6 = mult*12; K4_11 = mult*18; 
K5_7 = mult*12; K5_11 = mult*18; 
K6_9 = mult*12; K6_11 = mult*18; 
K7_8 = mult*12; K7_11 = mult*10;
K8_11 = mult*18;
K9_10 = mult*12; K9_11 = mult*6;
K10_11 = mult*36;
% Proposing transmitivity of heat sources in the rooms (Al)
Ku = 40;
% Heat capacitances [J/(K)]
% (Notice it could be worked with Specific heat capacitances by
% considering air mass into play, the units would then be [J/(kg K)]
% We tune capacitance with this parameter after estimating it with 
% physical formulas
factor=0.8;
c0 = 93990*factor;
c1 = 93990*factor;
c2 = 93990*factor;
c3 = 93990*factor;
c4 = 93990*factor;
c5 = 93990*factor;
c6 = 93990*factor;
c7 = 93990*factor;
c8 = 93990*factor;
c9 = 93990*factor;
c10 = 187989.12*factor;
c11 = 278640*factor;

%% 4. Optimized parameters for the given constants
% Identification not yet performed

%% 5. Define heat fluxes out of states
% External fluxes
q0_e = K0_e*(T0-Te); q1_e = K1_e*(T1-Te); q2_e = K2_e*(T2-Te); 
q3_e = K3_e*(T3-Te); q4_e = K4_e*(T4-Te); q5_e = K5_e*(T5-Te);
q6_e = K6_e*(T6-Te); q7_e = K7_e*(T7-Te); q8_e = K8_e*(T8-Te);
q9_e = K9_e*(T9-Te); q10_e = K10_e*(T10-Te); q11_e = K11_e*(T11-Te);
% Between rooms
q0_2 = K0_2*(T0-T2); q0_11 = K0_11*(T0-T11); 
q1_3 = K1_3*(T1-T3); q1_11 = K1_11*(T1-T11); 
q2_4 = K2_4*(T2-T4); q2_11 = K2_11*(T2-T11);
q3_5 = K3_5*(T3-T5); q3_11 = K3_11*(T3-T11);
q4_6 = K4_6*(T4-T6); q4_11 = K4_11*(T4-T11);
q5_7 = K5_7*(T5-T7); q5_11 = K5_11*(T5-T11);
q6_9 = K6_9*(T6-T9); q6_11 = K6_11*(T6-T11);
q7_8 = K7_8*(T7-T8); q7_11 = K7_11*(T7-T11);
q8_11 = K8_11*(T8-T11);
q9_10 = K9_10*(T9-T10); q9_11 = K9_11*(T9-T11);
q10_11 = K10_11*(T0-T11);

%% 5. Explicit Model: One can add here extra fluxes like ventilation or
% finer modelling issues like windows or solar irradiation.
xdot = [
% Generalized temperatures
% Bedrooms
(1/c0)*(Ku*u0 - q0_e - q0_2 -q0_11);
(1/c1)*(Ku*u1 + 10*ui1 - q1_e - q1_3 -q1_11); % Add integrating control
(1/c2)*(Ku*u2 + 10*ui2 - q2_e + q0_2 -q2_4 - q2_11);
(1/c3)*(Ku*u3 - q3_e + q1_3 -q3_5 - q3_11);
(1/c4)*(Ku*u4 + 10*ui4 - q4_e + q2_4 -q4_6 - q4_11);
(1/c5)*(Ku*u5 - q5_e + q3_5 -q5_7 - q5_11);
(1/c6)*(Ku*u6 - q6_e + q4_6 -q6_9 - q6_11);
(1/c7)*(Ku*u7 - q7_e + q5_7 -q7_8 - q7_11);
(1/c8)*(Ku*u8 - q8_e + q7_8 -q8_11);
(1/c9)*(Ku*u9 - q9_e + q6_9 -q9_10 - q9_11);
% Lounge
(1/c10)*(2*Ku*u10 - q10_e + q9_10 -q10_11);
% Corridor
(1/c11)*(2*Ku*u11 - q11_e + q0_11 + q1_11 + q2_11 + q3_11 + q4_11 + q5_11 + ... 
q6_11 + q7_11 + q8_11 + q9_11 + q10_11);
% Errors to be integrated
0.002*u1;
0.002*u2;
0.002*u4;
];
end