% Name: Alex Keany
% Date: 15/03/2024
%
% Description: This script calculates the parallel and perpendicular
% reaction forces at point O, as well as the moment at point O. These
% calculations are based on an angle theta that is input by the user in 
% degrees. The script will then print the results correct to 2 decimal
% places.
%
% Input(s): 
% - angle
%
% Output(s):
% - R_parallel
% - R_perp
% - moment_O
%
clear % clears workspace
close all % closes all figure windows 
clc % clears command window
%
% asks user to input the angle theta that is on the diagram in part a in
% degrees and saves it as 'angle'
angle = input('Please enter the angle between the arm and the positive direction of the horizontal axis [deg]?\n');
%
% calculates reaction force at point O parallel to arm using the equation from
% part b and saves it as 'R_parallel'
R_parallel = 230.3*sind(angle); % [N]
%
% calculates reaction force at point O perpendicular to arm using the equation
% from part b and saves it as 'R_perp'
R_perp = 230.3*cosd(angle); % [N]
%
% calculates moment at point O using the equation from part b and saves it
% as 'moment_O'
moment_O = 93.345*cosd(angle); % [Nm]
%
% defines the sentence to be displayed
sentence = 'The %s at point O is %.2f [%s].\n';
%
% prints the results for the user
fprintf(sentence,'reaction force parallel to the arm',R_parallel,'N')
fprintf(sentence,'reaction force perpendicular to the arm',R_perp,'N')
fprintf(sentence,'moment',moment_O,'Nm')