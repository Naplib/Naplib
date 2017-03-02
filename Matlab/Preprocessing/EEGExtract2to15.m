function dh2 = EEGExtract2to15 (d, infs, outfs, z_score)

% Requisite: Downlaod EEGfilt from EEGLab Library ::
% https://sccn.ucsd.edu/svn/software/eeglab/functions/sigprocfunc/eegfilt.m

% d: recorded data, channel x sample
% fs: sampling rate of the data
% outfs: sampling rate of output
% z_score: z_score flag. In the case of z_score = 1 data will be z_scored 

% Bahar, bahar.kh@columbia.edu
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

defaultfs = 100; % Hz

if infs ~= defaultfs
    d = resample(d',defaultfs,infs)';
    fs = defaultfs;
end

if exist('z_score') & z_score==1
    signalnew=(signal-repmat(mean(signal,2),1,size(signal,2)))...
        ./repmat(std(signal(:,500:end)),1,size(signal,2));
end

filtered_data=eegfilt(signalnew',f,2,15,0,100);

dh2 = resample(filtered_data',outfs,fs)';

end
