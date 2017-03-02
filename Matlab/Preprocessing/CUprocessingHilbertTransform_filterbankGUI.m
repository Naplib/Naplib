  function [filteredData,cfs,sigma_fs,hilbdata]=CUprocessingHilbertTransform_filterbankGUI(d,Fs,freqRange)

% This function is used in EcogExtractHighGamma.m
%{
PURPOSE: Perform Hilbert transform

INPUTS: ecog data structure
        Sampling frequency
        Optional: frequency range for window (2 element array with low frequency first)-- if no input, go to default range

OUTPUT: filtered data structure
%}

%********CHANGE, allow for multiband freqRange*************
%{
if nargin==3
    freqH=freqRange(2);
    freqL=freqRange(1);
else
    freqH=150;
    freqL=70;
end

max_freq=Fs/2;
%}
% Neural Acoustic Processing Lab, 
% Columbia University, naplab.ee.columbia.edu


%%%%%%%%%%%%%%%CREATE FILTER BANK
a=[log10(.39); .5];

frange=freqRange;
f0=0.018;
octspace=1/7;%usually 1/7
minf=frange(1);
maxf=frange(2);
maxfo=log2(maxf/f0);
cfs=f0;
sigma_f=10^(a(1)+a(2)*log10(cfs(end)));

while log2(cfs(end)/f0)<maxfo
    cfo=log2(cfs(end)/f0);
    cfo=cfo+octspace;
    if cfs(end)<4,
        cfs=[cfs cfs(end)+sigma_f]; %switches to log spacing at 4 Hz
    else cfs=[cfs f0*(2^(cfo))];
    end
    sigma_f=10^(a(1)+a(2)*log10(cfs(end)));
end

cfs=cfs(find(cfs>=minf & cfs<=maxf));
npbs=length(cfs);
sigma_fs=(10.^([ones(length(cfs),1) log10(cfs')]*a))';
badfs=[find(cfs>340 & cfs<480) find(cfs>720 & cfs<890)];
sigma_fs=sigma_fs(setdiff(1:npbs,badfs));
cfs_all=cfs;
cfs=cfs(setdiff(1:npbs,badfs));
npbs=length(cfs);
sds=sigma_fs.*sqrt(2);

T=size(d,2);
freqs=(0:floor(T/2)).*(Fs/T); nfreqs=length(freqs);
h = zeros(1,T);
if 2*fix(T/2)==T %if T is even
    h([1 T/2+1]) = 1;
    h(2:T/2) = 2;
else
    h(1) = 1; h(2:(T+1)/2) = 2;
end

%CHANGE: vectorize across channels, take out loop*******************
%x=fft(ecog.data,nfft,2);
filteredData = zeros(size(d,1),T,npbs);

for c=1:size(d,1)
    adat=fft(d(c,:),T);
    for f=1:npbs
        H = zeros(1,T);
        k = freqs-cfs(f);
        H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
        H(nfreqs+1:end)=fliplr(H(2:ceil(T/2)));
        H(1)=0;
        hilbdata=ifft(adat(end,:).*(H.*h),T);
        envData=abs(hilbdata);
        %phaseData=angle(hilbdata);
        filteredData(c,:,f)=hilbdata;
        %phaseInfo.data(c,:,f)=phaseData;
    end
end

filteredData = abs(filteredData);
