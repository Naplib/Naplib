function atr = phoneme2attribute (phn,cmd)

atr = [];
atlist = attribute2phoneme([],'list');
for cnt1 = 1:length(atlist)
    thisphn = attribute2phoneme(atlist{cnt1});
    if ~isempty(find(strcmpi(thisphn,phn)))
        atr{end+1} = atlist{cnt1};
    end
end
