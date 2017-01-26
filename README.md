Naplib

List of functions: 

1. Sig_out = NeuralFilt(signal,fs,option)

% signal is channel*time
% fs sampling frequency
% option ‘EEG’ or ‘ECoG’

if option = ‘EEG’ 
FIR filter 2 to 15 Hz: zero-phase, use filtfilt from Scipy.signal 
	Elseif option = ‘ECoG’
Envelop of 70 to 150 Hz ( define a filter bank then extract envelop of each bank)

2. Sig_out = NeuralCMR(signal,bad_channels)

% signal is channel*time
% bad_channel is optional

If exist(bad_channel)
	Remove bad channels from the signal
End

Signal= signal – mean(signal,1)


3. [phoneme_data, phoneme_feat] = NeuralPhonemeResp(s, out, phoneme, fname, feats, loc)
