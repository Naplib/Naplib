function [ output_args ] = Dendro( AVG, elecs, time, phnsub )
% AVG is phoneme*electrodes*time (use findavg code)
% elecs is the number of electrodes which are used in the unsupervised clustering
% time is the time window used for unsupervised clustering
% By Bahar Khalighinejad (bk2556@columbia.edu)
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

if ~exist('elecs') ||  isempty(elecs)
    elecs=1:size(AVG,2);
end

if ~exist('time') || isempty (time)
    time=1:size(AVG,3);
end

figure
temp=AVG(:,elecs,time);
tmp1=reshape(permute(temp,[1 2 3]),[size(temp,1) size(temp,2)*size(temp,3)]);
Dist=pdist(tmp1);
ltype = 'average' ;

z = linkage( Dist,ltype);
c = cluster(z,'cutoff',0.000000000001,'criterion','distance');
numclass = length(unique(c));
[hv,ttv,permv] = dendrogram(z,numclass,'orientation','top','labels',phnsub);
title('Dendrogram based on 0 to 300 ms after the onset of phoneme');

end

