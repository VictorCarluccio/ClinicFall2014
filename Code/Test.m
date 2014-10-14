clear all 
close all
clc

load wine_dataset
wineInputs = wineInputs';
wineTargets = wineTargets';
% wineTargets = vec2ind(wineTargets);
[classes,key,labels] = unique(wineTargets);
data = wineInputs;

load fisheriris;
[classes1,key1,labels1] = unique(species);
data1 = meas;