# Naplib

The library is applicable to both invasive and non-invasive recordings, including electroencephalography
(EEG), electrocorticography (ECoG) and magnetoecnephalography (MEG).


# List of functions

> stimulus: wavefiles containing continuous speech in addition to time-aligned labels of phonemes

> preprocessing: 
- EEGExtract2to15.m
- EcogExtractHighGamma.m
- CUprocessingHilbertTransform_filterbankGUI.m

> Phoneme analysis: 
- findavg.m
- attribute2phoneme.m
- phoneme2attribute.m
- SimMat.m
- Fratio.m
- DistDistCov.m
- Dendro.m
- DPrime.m
- MDSPlot.m

>GUI
- OutGenerator.m
- PhonemeAnalyser.m

> Reconstruction: 
- LagGeneratorNew.m
- StimuliReconstruction.m


# Citation

Basic citation: 
- NAPLIB: AN OPEN SOURCE TOOLBOX FOR REAL-TIME AND OFFLINE NEURALACOUSTIC PROCESSING

Matlab: 
- Khalighinejad, Bahar, Guilherme Cruzatto da Silva, and Nima Mesgarani. "Dynamic Encoding of Acoustic Features in Neural Responses to Continuous Speech." Journal of Neuroscience 37.8 (2017): 2176-2185.
 
PSI vector, selectivity to phonemes: 
- Mesgarani, Nima, et al. "Phonetic feature encoding in human superior temporal gyrus." Science 343.6174 (2014): 1006-1010.

Reconstruction: 
- Mesgarani, Nima, et al. "Influence of context and behavior on stimulus reconstruction from neural activity in primary auditory cortex." Journal of neurophysiology 102.6 (2009): 3329-3339.
