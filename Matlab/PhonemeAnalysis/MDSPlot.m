function MDSPlot( AVG, elecs, time, phnsub )

%  AVG (phoneme*electrodes*time) = average response to phonemes 
% elecs is the number of electrodes which are used in the unsupervised clustering
% time is the time window used for unsupervised clustering  
% By Bahar Khalighinejad (bk2556#columbia.edu)
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

figure

AVG2=AVG(:,elecs,time);
tmp=reshape(AVG2,[size(AVG2,1) size(AVG2,2)*size(AVG2,3)]);
Dist=pdist(tmp);
[Y e] = cmdscale(Dist,2);

for i=1:size(AVG,1)
    
    phon=phnsub(i);
    
    if any(ismember(attribute2phoneme('plosive'),phon))
        color='b';
    elseif any(ismember(attribute2phoneme('fricative'),phon))
        color='r';
    elseif any(ismember(attribute2phoneme('nasal'),phon))
        color='g';
    elseif any(ismember(attribute2phoneme('approximant'),phon))
        color='g';
    elseif any(ismember(attribute2phoneme('syllabic'),phon))
        color='k';
    end
    
    hold on
    scatter(Y(i,1),Y(i,2),'.','w');
    h=text(Y(i,1),Y(i,2),phon,'color',color,'FontWeight','bold');
    set(h,'FontSize',16)
    
end

end

