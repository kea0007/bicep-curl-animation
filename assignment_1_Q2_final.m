% Name: Alex Keany
% Date: 17/03/2024
% Description: This script asks the user to input the maximum angle,
% repetitions and mass held in a bicep curl. It then produces an animation
% of that bicep curl and animates 4 graphs showing the angular displacement
% and 3 forces involved in the bicep curl.
%
% Input(s):
% - max_angle 
% - reps_per_min 
% - mass_weight
%
% Output(s): 1 figure split into 5 uneven sections to show:
% - an animation of a bicep curl on the whole left half 
% - a graph of the angular displacement vs time on the right
% - a graph of the parallel reaction force vs time on the right
% - a graph of the perpendicular reaction force vs time on the right
% - a graph of the muscle force vs time on the right
%
clear % clears workspace
close all % closes all figure windows 
clc % clears command window
%
% specifies parameters fixed in this animation
a = 0.15; % [m]
b = 0.45; % [m]
mu_u = 0.20; % [m]
mu_d = 0.03; % [m]
mass_arm = 3.5; % [kg]
%
% asks user to input the maximum angle in degrees and traps them in a while loop if an invalid number
% is given
max_angle = input('Please enter maximum of the range of motion of the bicep curl [deg]:\n');
while max_angle<0 || max_angle>70
    max_angle = input('That range of motion is unrealistic. Please enter a number between 0 and 70 degrees.\n');
end
% 
% asks user to input the bicep curls per minute and the mass of the weight
% held in kg
reps_per_min = input('Please enter the number of repetitions of bicep curls per minute:\n');
mass_weight = input('Please enter the mass of the carried weight [kg]:\n');
%
% enters a matrix of t values between 0 and 30 seconds 
n_points = 1000; % the number of points in t
t = linspace(0,30,n_points); % time [seconds]
%
% calculates the angular displacement in radians and degrees
max_angle_rad = max_angle*pi/180;
period = 60/reps_per_min; % [s]
ang_freq = 2*pi/period; % [s-1]
ang_disp = max_angle_rad*cos(ang_freq*t); % [rad]
ang_disp_deg = ang_disp*180/pi; % [deg]
%
% calculates the angular velocity and angular acceleration 
ang_vel = -ang_freq*max_angle_rad*sin(ang_freq.*t); % [rad/s]
ang_accel = -(ang_freq)^2*max_angle_rad*cos(ang_freq.*t); % [rad/s2]
%
% expressions for the mass moment of inertia and location of the centre of
% mass 
I_O = 0.08875+0.2065*mass_weight;
r_COM = (0.525+0.45*mass_weight)/(3.5+mass_weight);
%
% calculates muscle force using expressions provided
numerator_1 = sqrt(mu_u^2+mu_d^2-2*mu_u*mu_d*sin(ang_disp));
denominator_1 = mu_u*mu_d*cos(ang_disp);
brackets_1 = I_O*ang_accel+(a*mass_arm+b*mass_weight)*9.8*cos(ang_disp);
F_muscle = (numerator_1)./(denominator_1).*(brackets_1); 
%
% calculates parallel reaction force using expressions provided
numerator_2 = mu_d-mu_u*sin(ang_disp);
denominator_2 = numerator_1;
brackets_2 = (mass_arm+mass_weight)*(9.8*sin(ang_disp)-ang_vel.^2.*r_COM);
R_par = F_muscle.*((numerator_2)./(denominator_2))+brackets_2;
%
% calculates perpendicular reaction force using expressions provided
brackets_3 = (mass_arm+mass_weight)*(9.8*cos(ang_disp)+ang_accel.*r_COM);
numerator_3 = mu_u*cos(ang_disp);
denominator_3 = numerator_1;
R_perp = brackets_3 - F_muscle.*((numerator_3)./(denominator_3));
%
% sets up the subplots with axes labels and titles 
% note: all the y limits have been set as the min and max values 
% of what is being graphed offset by 0.1. This is so that when 
% theta = 0 degrees the script still graphs the results.
subplot(4,2,2)
xlabel('time [s]')
ylabel('𝜃 [degrees]')
xlim([0 30])
ylim([-max_angle-0.1 max_angle+0.1]) 
title('Graph showing the angular displacement [degrees] vs time [s]')
%
subplot(4,2,4)
xlabel('time [s]')
ylabel('R_p_a_r [N]')
xlim([0 30])
ylim([min(R_par)-0.1 max(R_par)+0.1])
title('Graph showing the parallel reaction force [N] vs time [s]')
%
subplot(4,2,6)
xlabel('time [s]')
ylabel('R_p_e_r_p [N]')
xlim([0 30])
ylim([min(R_perp)-0.1 max(R_perp)+0.1])
title('Graph showing the perpendicular reaction force [N] vs time [s]')
%
subplot(4,2,8)
xlabel('time [s]')
ylabel('F_m_u_s_c_l_e [N]')
xlim([0 30])
ylim([min(F_muscle)-0.1 max(F_muscle)+0.1])
title('Graph showing the force due to the muscle [N] vs time [s]')
%
subplot(4,2,[1 3 5 7])
axis equal % ensures the axes have equal scale
axis([-0.1,b+0.05,-b-0.05,b+0.05])
title('Bicep curl')
%
% plotting animated bicep curl and force
tip_x=b*cos(ang_disp); % x-coordinates of the tip of the arm segment (B)
tip_y=b*sin(ang_disp); % y-coordinates of the tip of the arm segment (B)
%
figure(1) % opens a figure
%
% Sets up animatedlines that "live" in each of the separate subplots set up
% previously
subplot(4,2,2)
theta_vs_time = animatedline('Color','b');
%
subplot(4,2,4)
R_par_vs_time = animatedline('Color','g');
%
subplot(4,2,6)
R_perp_vs_time = animatedline('Color','magenta');
%
subplot(4,2,8)
F_vs_time = animatedline('Color','r');
%
subplot(4,2,[1 3 5 7])
forearm=animatedline('Color','k','LineWidth',5);
upperarm=animatedline('Color','k','LineWidth',5);
force=animatedline('Color','r','LineWidth',2);
circle=animatedline('Marker','o','MarkerSize',40,'MarkerFaceColor','b');
%
% Animation loop to add points to the graphs and move the bicep in sync
% with each other
for i=1:length(t)
    clearpoints(forearm) % need this otherwise past positions of the arm will remain on the figure
    clearpoints(upperarm)
    clearpoints(force)
    clearpoints(circle)
    addpoints(forearm,[0,tip_x(i)],[0,tip_y(i)]) % forearm is between (0,0) and the tip of the arm
    addpoints(upperarm,[0,0],[b,0]) % upper arm added to make the diagram look more like a bicep curl
    addpoints(force,[0,mu_d.*cos(ang_disp(i))],[mu_u,mu_d.*sin(ang_disp(i))]) % force shown which will be between (0, mu_u) and a second point going around a circle of radius mu_d
    addpoints(circle,tip_x(i),tip_y(i)) % a circle to show the weight held in the hand
    addpoints(theta_vs_time,t(i),ang_disp_deg(i))
    addpoints(R_par_vs_time,t(i),R_par(i))
    addpoints(R_perp_vs_time,t(i),R_perp(i))
    addpoints(F_vs_time,t(i),F_muscle(i))
    drawnow
end
%