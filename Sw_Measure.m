function Sw = Sw_Measure(inMat)
%Calculates Roger's (Telesford's?) Sw measure

%depends on regular_matrix_generator function from Gergana Bounova

%Inputs:
%   inMat A graph's weight matrix 

%Outputs:
%   Sw    smallworldness measure developed by Telesford, comparing
%   Clustering Coefficient of a regular network and Path Length of a random
%   network to the CC and PL of the input network. Sw close to 1 represents
%   networks close to random graph, while Sw close to -1 represents
%   networks close to regular networks. Sw of 0 is highly small-world

%written by Jeremiah Palmerston 


%% Generate 'Null' Graphs

n = size(inMat,2);
c = 2;

%%% Generate Random Symmetric Graph
dense = nanmean(nanmean(abs(double(inMat))));
adjMat_R = sprand(n,n,dense); %%% Same size and similar weight density as input Graph
adjMat_R = tril(adjMat_R,-1);
adjMat_R = adjMat_R+adjMat_R.';

%%% Generate Regular Lattice Graph, Weighted  
numb_connections = length(find(inMat>0));
avg_deg_unw = numb_connections/n;
avg_rad_unw = avg_deg_unw/2;
avg_rad_eff = ceil(avg_rad_unw);
adjMat_Lat = regular_matrix_generator(abs(double(inMat)),avg_rad_eff);

%%% Path Lengths
plRand = nanmean(nanmean(distance_wei(1-adjMat_R)));
plNet = nanmean(nanmean(distance_wei(1-inMat)));

%%% Clustering Coefficients
ccLat = nanmean(weightedClustCoeff(adjMat_Lat));
ccNet = nanmean(weightedClustCoeff(inMat));

%%% Final Sw Measure
Sw = (plRand/plNet)-(ccNet/ccLat);
