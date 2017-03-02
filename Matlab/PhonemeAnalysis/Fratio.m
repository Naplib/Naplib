function [f] = Fratio(D,L,Electrode,Attribute,phnsub)
% F-statistic over time
% can be followed by 'Electrode' properties
% Electrode -> 'all' using all electrodes returning one F-statistic over
% time f is 1*time
% Electrode -> 'individual' returning different F-statistic values for
% different electrodes, f is electrode*time
% attribute -> 'manner' groups are considered as different manners of
% articulation
% attribute _> 'default' each label is considered as one category
% D is electrode*time*instances
% L is instances, labels are in numeric order for example L=[1 2 3 .... ]
% phnsub is the label of phonemes for example phnsub={'AA','AO','B','C',
% ...}
% Bahar 2015 (bk2556@columbia.edu)
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu


if ~exist('Electrode') || isempty(Electrode)
    Electrode='all';
end

if ~exist('Attribute') || isempty(Attribute)
    Attribute='default';
end

if strcmp(Attribute,'default')
    Ltmp=L;
    label=unique(L);
    
elseif strcmp(Attribute,'manner')
    atlist = attribute2phoneme([],'list');
    AL = zeros(length(atlist),length(L));
    % find the attribs of this phoneme:
    for cnt1 = 1:length(phnsub)
        atr = phoneme2attribute(phnsub{cnt1});
        atvec = zeros(1,length(atlist));
        for cnt2 = 1:length(atlist)
            if ~isempty(find(strcmpi(atr,atlist{cnt2}))), atvec(:,cnt2)=1;end
        end
        AL(:,L==cnt1)=repmat(atvec',[1 length(find(L==cnt1))]);
    end
    Ltmp=zeros(1,length(AL));
    ind=find(ismember(phnsub,attribute2phoneme('plosive')));
    Ltmp(1,find(ismember(L,ind)))=1;
    ind=find(ismember(phnsub,attribute2phoneme('fricative')));
    Ltmp(1,find(ismember(L,ind)))=2;
    ind=find(ismember(phnsub,attribute2phoneme('nasal')));
    Ltmp(1,find(ismember(L,ind)))=3;
    ind=find(ismember(phnsub,attribute2phoneme('syllabic')));
    Ltmp(1,find(ismember(L,ind)))=4;
    label=[1 2 3 4];
end



f=[];
if strcmp(Electrode,'all')
    for t=1:size(D,2)
        tmp=squeeze(D(:,t,:));
        [~, f(1,t) ,~] = DPrime(tmp,Ltmp(:),label);
    end
elseif strcmp(Electrode,'individual')
    for t=1:size(D,2)
        tmp=squeeze(D(:,t,:));
        for cnt=1:size(D,1)
            [~, f(cnt,t) ,~] = DPrime(tmp(cnt,:),Ltmp(:),label);
        end
    end
end


end

