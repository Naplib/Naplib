function dh2 = EcogExtractHighGamma (d, infs, outfs)
% d: recorded data, channel x sample
% fs: sampling rate of the data
% outfs: sampling rate of output

% Nima, nimail@gmail.com
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu

defaultfs = 400; % Hz
freqRange=[70 150];

if infs ~= defaultfs
    d = resample(d',defaultfs,infs)';
    fs = defaultfs;
end

% apply notch filter:
notchFreq=60;
while notchFreq<fs/2
    [b,a]=fir2(1000,[0 notchFreq-1 notchFreq-.5 notchFreq+.5 notchFreq+1 fs/2]/(fs/2),[1 1 0 0 1 1 ]);
    d=filtfilt(b,a,d')';
    notchFreq=notchFreq+60;
end

% calculate hilbert envelope:
[dh,cfs,sigma_fs] = CUprocessingHilbertTransform_filterbankGUI(d, fs, freqRange);
%
dh2 = mean(abs(dh),3);
%dh2 = mapstd(dh2);
dh2 = resample(dh2',outfs,fs)';
