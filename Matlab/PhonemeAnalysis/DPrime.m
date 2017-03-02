function [allf f fs] = DPrime(D,L,phns)

% function [f] = DPrime(D,L,phns, flag)
% D = feature x instance matrix (eg: 256 x 6000)
% L = instance x 1 matrix (eg 6000 x 1) where each element defines the
%    class of the instance
% phns = the unique classes
%
% f-statistic where
% allf = distance of each phoneme from the average of all 
% f = between group variability / within group
% variability
% fs = standard error
% 
% Nima, 2010 (Connie, updated 2013)
% modified by Bahar, 2015 (bk2556@columbia.edu)
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu
%

if ~exist('phns','var') || isempty(phns)
    phns = unique(L);
end

Dtot=[];
Ltot=[];

for i=1:length(phns)
    Dtot=cat(2,Dtot,D(:,find(L==phns(i))));
    Ltot=cat(1,Ltot,L(find(L==phns(i))));
end

D=Dtot;
L=Ltot;

xh = mean(D,2);
total = 0;

for cnt1 = 1:length(phns)
    cnt2 = phns(cnt1);
    
    % first, between class variability
    index = find(L==cnt2);
    index = index(:)';
    dc = mean(D(:,index),2);
    sb = norm(dc-xh,2)^2;
    
    % now do the within class variability
    sw = 0;
    for cnt3 = index
        sw = sw + norm(D(:,cnt3)-dc,2)^2;
    end
    sbs(cnt1) = sb*length(index);
    sws(cnt1) = sw;
    total = total+length(index);
end

tmpb = sbs/(length(phns)-1); %sum(sbs)/(length(phns)-1);

tmpw = sws/(total-length(phns));%
allf = (tmpb)./tmpw;

f = sum(tmpb)/sum(tmpw); %tmpb/tmpw;

fs = std(length(phns)*tmpb/sum(tmpw))/sqrt(length(phns));
