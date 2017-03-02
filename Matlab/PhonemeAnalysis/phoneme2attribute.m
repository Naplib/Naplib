function atr = phoneme2attribute (phn,cmd,mode)
% phn = phoneme string
% cmd = 'list' or [] 
% mode = 'IPA' or 'Arpabet'
% e.x. : atr=phoneme2attribute('axh',[],'IPA') => atr = {'voiced'
% 'sonorant'    'syllabic'    'approximant'}
% atr= phoneme2attribute('AA') => atr = {'voiced'    'sonorant'
% 'syllabic'    'back'    'low'}
% 
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

if ~exist('mode','var') || isempty(mode)
    mode = 'Arpabet';
end

atr = [];
atlist = attribute2phoneme([],'list',mode);
for cnt1 = 1:length(atlist)
    thisphn = attribute2phoneme(atlist{cnt1},[],mode);
    if ~isempty(find(strcmpi(thisphn,phn)))
        atr{end+1} = atlist{cnt1};
    end
end
