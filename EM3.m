% MAS // MCSE 2016
% M.Merts HAN,  engine model
clear all, close all;

%% This is the m script for validating the ICE model.
load('workspace')               % Import workspace for validation data


steps=1000;                     % calculation-steps per engine revolution.
engine_speed=3000;              % rpm
stepsize=(60/engine_speed)/steps;
sim_time=stepsize*(2*steps-1)   % two engine revolutions, one cycle
R      = 287;                   % Specific Universal gas constant(J/kg.K)
Rho    = 1.27;                  % Density of air (kg/m^3)

gma    = 1.32;                  % Specific heat ratio
MAP    = 80000;                 % Manifold Absolute Pressure [Pa]
P_ambient = 100000;             % Ambient pressure [Pa]
P_exhaust = 120000;             % Pressure in cylindre during exhaust stroke.
CR     = 10.1;                    % Compression ratio  
Bore   = 73.4*10^-3;            %[m]
Stroke = 72.6*10^-3;              %[m]
V_cyl  =(Bore/2)^2*pi*Stroke;   % cylindre volume
V_comp =V_cyl/(CR-1);           % Compression ratio
CrankRadius=Stroke/2;           
ConRod =137.2*10^-3;              % Length of conrod
Valve_lift=9*10^-3;
Nr_of_valves=2;
Valve_dia=30*10^-3;
Cd=0.35;                        % discharge coefficient of flow over intake valve
P_0=100000;                     % Pa,  atmosferic, at start of intake stroke
T_air=323;                      %air temperature at start of intake stroke
m_0=P_0*(V_comp)/(R*T_air);     %mass of air inside cylinder, at start of intake
V_sonic = 20.0457*sqrt(T_air);         % Sonic velocity (m/s)


% fuel
% energy content
LHV=44400*10^3;  % J/kg
AFR =14.7;       % actual Air Fuel ratio,  [kg/kg]

AFR_stoich=14.7; % Stoichiometric air fuel ratio for the applied fuel.
AFR_effective=max(AFR_stoich,AFR);

%% Simulating
sim('EngineModel_student2')

%% Plotting PV diagram
figure(1)
hold on
plot((volume(:,1)/1000),(bar(:,1)*100000), 'black', 'LineWidth', 1)
plot(Volume(1:500,2),Pressure(1:500,2), 'g','LineWidth', 2);
plot(Volume(500:1000,2),Pressure(500:1000,2), 'y','LineWidth', 2);
plot(Volume(1000:1500,2),Pressure(1000:1500,2), 'r','LineWidth', 2);
plot(Volume(1500:2000,2),Pressure(1500:2000,2), 'b','LineWidth', 2);
hold off
grid on
xlabel('Volume [m3]')
ylabel('Pressure [pascal]')
legend('Measured data', 'Intake', 'Compression','Combustion', 'Exhaust');
title('PV diagram');

%% Calculating work, efficiency, power and torque
area_comp = polyarea(volume(180:540,1),bar(180:540,1));
area_in = polyarea(volume(1:180,1),bar(1:180,1));
area_ex = polyarea(volume(541:720,1),bar(541:720,1));
area_inside = area_comp - area_in - area_ex;
work = area_inside

Efficiency = (work/added_energy(1,2))*100
Power = work*25
Torque = Power/((2*pi/60)*3000)


