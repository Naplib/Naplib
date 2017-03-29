function [ Nmat, Amat, Covy] = DistDistCov(AVGN, AVGA,DistType )

% AVGN is phoneme*electrodes*time (use findavg code) for neural data 
% AVGA is phoneme*frequency*time, this contains the acoustic spectrogram of
% phoenems. To generate neural-neural covariance matrix, use averge neural
% response instead of AVGA
% DistType = type of distance, default= euclidean
% Nmat (time*phoneme*phoneme)= Distance matrix based on AVGN for each time point 
% Amat (time*phoneme*phoneme)= Distance matrix based on AVGA for each time point 
% Covy (time*time) = covariance matrix for Amat and Nmat
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

if ~exist('DistType') || isempty (DistType)
    DistType='euclidean';
end

tmp=AVGN;
Nmat=[];
cnt=0;
for ti=size(AVGN,3) %define the time
    
    cnt=cnt+1;
    
    temp=tmp(:,:,ti);
    tmp1=reshape(permute(temp,[1 2 3]),[size(temp,1) size(temp,2)*size(temp,3)]);
    Dist=pdist(tmp1,DistType);
    ltype = 'average' ;
    z = linkage( Dist,ltype);
    c = cluster(z,'cutoff',0.000000000001,'criterion','distance');
    numclass = length(unique(c));
    Dist2=squareform(Dist);
    Nmat(cnt,:,:)=Dist2;
end


tmp=AVGA;
Amat=[];
cnt=0;
for ti=size(AVGA,3) %define the time
    
    cnt=cnt+1;
    
    temp=tmp(:,:,ti);
    tmp1=reshape(permute(temp,[1 2 3]),[size(temp,1) size(temp,2)*size(temp,3)]);
    Dist=pdist(tmp1,dtype,DistType);
    ltype = 'average' ;
    z = linkage( Dist,ltype);
    c = cluster(z,'cutoff',0.000000000001,'criterion','distance');
    numclass = length(unique(c));
    Dist2=squareform(Dist);
    Amat(cnt,:,:)=Dist2;
end

Covy=[];
for i=1:size(Amat,1)
    for j=1:size(Nmat,1)
        tmp1 = squeeze(Amat(i,:,:));
        tmp2 =squeeze(Nmat(j,:,:));
        
        tmp6= cov(tmp1(ind),tmp2(ind));

        Covy(i,j) =tmp6(2);      
    end
end

end
