function [ AVG,phnsub ] = findavg(D,L,delet,phnsub)

% D contains electrode*time*instances
% L contains labels in numeric order for example L=[1 2 3 .... ]
% delet = cell file containing phonemes that will be deleted from output AVG
% phnsub = cell file containing all phonemes  
% AVG (phoneme * electrodes * time) = average value for each phoneme
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu
%

AVG=zeros(length(unique(L)),size(D,1),size(D,2));

for i=1:length(unique(L))
    ind=find(L==i);
    AVG(i,:,:)=mean(D(:,:,ind),3);
end 

if ~exist('phnsub') 
    phnsub=[];
end

if exist('delet') && ~isempty(delet)
    ind=find(ismember(phnsub,delet));
    phnsub(ind)=[];
    resp(ind,:,:)=[];
end


end

