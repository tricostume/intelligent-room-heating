function [xdot] = model(x, u, uc, Te, qS,P, lambda)
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
% VERY IMPORTANT: This model already takes into consideration solar
% radiation as the input qS. One must give this function an input sun heat
% flux qS with units [W]. Until now this is the heat flux sensed by the
% windows, a multiplying factor can be applied in the case that the
% simulation is not exact in order to account for solar radiation heat
% fluxes through the walls and not only thorugh the windows.
% PARAMETER: "lambda" used for sampling time scaling.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% State vector definition
% Rooms' temperature
T0 = x(1); u0 = u(1)*(20*u(1)-x(1)); uc0=uc(1)*(26*uc(1)-x(1));
T1 = x(2); u1 = u(2)*(20*u(2)-x(2)); uc1=uc(2)*(26*uc(2)-x(2));
T2 = x(3); u2 = u(3)*(20*u(3)-x(3)); uc2=uc(3)*(26*uc(3)-x(3));
T3 = x(4); u3 = u(4)*(20*u(4)-x(4)); uc3=uc(4)*(26*uc(4)-x(4));
T4 = x(5); u4 = u(5)*(20*u(5)-x(5)); uc4=uc(5)*(26*uc(5)-x(5));
T5 = x(6); u5 = u(6)*(20*u(6)-x(6)); uc5=uc(6)*(26*uc(6)-x(6));
T6 = x(7); u6 = u(7)*(20*u(7)-x(7)); uc6=uc(7)*(26*uc(7)-x(7));
T7 = x(8); u7 = u(8)*(20*u(8)-x(8)); uc7=uc(8)*(26*uc(8)-x(8));
T8 = x(9); u8 = u(9)*(20*u(9)-x(9)); uc8=uc(9)*(26*uc(9)-x(9));
T9 = x(10); u9 = u(10)*(20*u(10)-x(10)); uc9=uc(10)*(26*uc(10)-x(10));
% Lounge temperature
T10 = x(11); u10 = u(11) * (20*u(11)-x(11)); uc10=uc(11)*(26*uc(11)-x(11));
% Middle corridor temperature
T11 = x(12); u11 = u(12) * (20*u(12)-x(12)); uc11=uc(12)*(26*uc(12)-x(12));

%Integral states for improved control

ui0 = u(1)*x(13);
ui1 = u(2)*x(14);
ui2 = u(3)*x(15);
ui3 = u(4)*x(16);
ui4 = u(5)*x(17);
ui5 = u(6)*x(18);
ui6 = u(7)*x(19);
ui7 = u(8)*x(20);
ui8 = u(9)*x(21);
ui9 = u(10)*x(22);
ui10 = u(11)*x(23);
ui11 = u(12)*x(24);

% Exogenous input: External temperature in time
Te = Te; 
% Exogenous input: Input solar radiaton HEAT FLUXES
qS0 = qS(1);
qS1 = qS(2);
qS2 = qS(3);
qS3 = qS(4);
qS4 = qS(5);
qS5 = qS(6);
qS6 = qS(7);
qS7 = qS(8);
qS8 = qS(9);
qS9 = qS(10);
qS10 = qS(11);
qS11 = qS(12);
%2. Control signal: A simple error integrator is proposed for each room
% until now this represents a heat source with 100% efficiency.
% u0,u1...u11
%% 3. Parameters to be optimised
% These parameters are going to be found with mathematical programming
% non linear optimisation techniques.
K0_e = P(1); K1_e = P(2); K2_e = P(3); K3_e = P(4); K4_e = P(5); K5_e = P(6); 
K6_e = P(7); K7_e = P(8); K8_e = P(9); K9_e = P(10); K10_e = P(11); K11_e = P(12);
%K0_e = P(1); K1_e = P(2); K2_e = P(3); K3_e = P(4); K4_e = P(5); K5_e = P(6); 
%K6_e = P(7); K7_e = P(8); K8_e = P(9); K9_e = P(10); K10_e = P(11); K11_e = P(12);
% Between bedrooms
% K0_2 = P(13); K0_11 = P(14); 
% K1_3 = P(15); K1_11 = P(16); 
% K2_4 = P(17); K2_11 = P(18);
% K3_5 = P(19); K3_11 = P(20); 
% K4_6 = P(21); K4_11 = P(22); 
% K5_7 = P(23); K5_11 = P(24); 
% K6_9 = P(25); K6_11 = P(26); 
% K7_8 = P(27); K7_11 = P(28);
% K8_11 = P(29);
% K9_10 = P(30); K9_11 = P(31);
% K10_11 = P(32);

K0_2 = P(13); K0_11 = P(24); 
K1_3 = P(14); K1_11 = P(25); 
K2_4 = P(15); K2_11 = P(26);
K3_5 = P(16); K3_11 = P(27); 
K4_6 = P(17); K4_11 = P(28); 
K5_7 = P(18); K5_11 = P(29); 
K6_9 = P(19); K6_11 = P(30); 
K7_8 = P(20); K7_11 = P(31);
K8_11 = P(21);
K9_10 = P(22); K9_11 = P(32);
K10_11 = P(23);
% Proposing transmitivities of heat and cold sources
Ku0 = P(33); Kuc0 = P(45);
Ku1 = P(34); Kuc1 = P(46);
Ku2 = P(35); Kuc2 = P(47);
Ku3 = P(36); Kuc3 = P(48);
Ku4 = P(37); Kuc4 = P(49);
Ku5 = P(38); Kuc5 = P(50);
Ku6 = P(39); Kuc6 = P(51);
Ku7 = P(40); Kuc7 = P(52);
Ku8 = P(41); Kuc8 = P(53);
Ku9 = P(42); Kuc9 = P(54);
Ku10 = P(43); Kuc10 = P(55);
Ku11 = P(44); Kuc11 = P(56);
% Heat capacitances [J/(K)]
c0 = (P(57)+1)/lambda;
c1 = (P(58)+1)/lambda;
c2 = (P(59)+1)/lambda;
c3 = (P(60)+1)/lambda;
c4 = (P(61)+1)/lambda;
c5 = (P(62)+1)/lambda;
c6 = (P(63)+1)/lambda;
c7 = (P(64)+1)/lambda;
c8 = (P(65)+1)/lambda;
c9 = (P(66)+1)/lambda;
c10 = (P(67)+1)/lambda;
c11 = (P(68)+1)/lambda;
% Proposing integral parameters of hot and cold sourcers
Ki = P(69);
Gi = P(70)*lambda;
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
(1/c0)*(Ku0*u0 + Ki*ui0 + Kuc0*uc0 + qS0 - q0_e - q0_2 -q0_11);
(1/c1)*(Ku1*u1 + Ki*ui1 + Kuc1*uc1 + qS1 - q1_e - q1_3 -q1_11); % Add integrating control
(1/c2)*(Ku2*u2 + Ki*ui2 + Kuc2*uc2 + qS2 - q2_e + q0_2 -q2_4 - q2_11);
(1/c3)*(Ku3*u3 + Ki*ui3 + Kuc3*uc3 + qS3 - q3_e + q1_3 -q3_5 - q3_11);
(1/c4)*(Ku4*u4 + Ki*ui4 + Kuc4*uc4 + qS4 - q4_e + q2_4 -q4_6 - q4_11);
(1/c5)*(Ku5*u5 + Ki*ui5 + Kuc5*uc5 + qS5 - q5_e + q3_5 -q5_7 - q5_11);
(1/c6)*(Ku6*u6 + Ki*ui6 + Kuc6*uc6 + qS6 - q6_e + q4_6 -q6_9 - q6_11);
(1/c7)*(Ku7*u7 + Ki*ui7 + Kuc7*uc7 + qS7 - q7_e + q5_7 -q7_8 - q7_11);
(1/c8)*(Ku8*u8 + Ki*ui8 + Kuc8*uc8 + qS8 - q8_e + q7_8 -q8_11);
(1/c9)*(Ku9*u9 + Ki*ui9 + Kuc9*uc9 + qS9 - q9_e + q6_9 -q9_10 - q9_11);
% Lounge
(1/c10)*(Ku10*u10 + Ki*ui10 + Kuc10*uc10 + qS10 - q10_e + q9_10 -q10_11);
% Corridor
(1/c11)*(Ku11*u11 + Ki*ui11 + Kuc11*uc11 + qS11 - q11_e + q0_11 + q1_11 + q2_11 + q3_11 + q4_11 + q5_11 + ... 
q6_11 + q7_11 + q8_11 + q9_11 + q10_11);
% Errors to be integrated: Heating
Gi*u0;
Gi*u1;
Gi*u2;
Gi*u3;
Gi*u4;
Gi*u5;
Gi*u6;
Gi*u7;
Gi*u8;
Gi*u9;
Gi*u10;
Gi*u11;
];
end