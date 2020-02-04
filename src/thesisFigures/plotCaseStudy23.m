%Script to plot figures for case studies 2 and 3.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

%--------------------------------------------- INPUTS -------------------------------------------------------------

%Define base conditions for sensitivity analysis.
N = 5;
Uinf = 8;
TIinf = 6;
X = 5;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Define domain for each parameter.
vecN = [3 5 7];
vecU = [6 8 10];
vecTI = [2 6 10];
vecX = [5 7 9];

%---------------------------------------- FIGURE PROPERTIES ----------------------------------------------------------

names = dir('caseStudy*.mat');
names = {names.name};

