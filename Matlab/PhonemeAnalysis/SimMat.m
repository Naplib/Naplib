function [ Dist2] = SimMat( AVG, elecs, time, DistType )
% AVG is phoneme*electrodes*time (use findavg code)
% elecs is the number of electrodes which are used in the unsupervised clustering
% time is the time window used for unsupervised clustering
% DistType contains the type of distance, default= euclidean
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

if ~exist('elecs') ||  isempty(elecs)
    elecs=1:size(AVG,2);
end

if ~exist('time') || isempty (time)
    time=1:size(AVG,3);
end

if ~exist('DistType') || isempty (DistType)
    DistType='euclidean';
end


temp=AVG(:,elecs,time);
tmp1=reshape(permute(temp,[1 2 3]),[size(temp,1) size(temp,2)*size(temp,3)]);
Dist=pdist(tmp1,DistType);
Dist2=squareform(Dist);

end
