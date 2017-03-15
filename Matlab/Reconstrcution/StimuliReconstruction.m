function [g,rstim] = StimuliReconstruction (StimTrain, TrainResp, TestResp, g, Lag)
%
% stimulus reconstruction from neural responses
%
% StimTrain: frequency*time, the time-frequency representation of the training stimulus
% TrainResp: time*channel, the corresponding neural responses to the training stimulus
% TestResp:  time*channel, the neural response for test stimulus
% g: the reconstruction filters (if empty, they will be calculated from training data)
% Lag: are the time delays of the stimulus used for the estimation. Default
%   is -5 to 7
% returns
% g: reconstruction filters
% rstim: reconstructed stimulus from TestResp responses
%
%
% Nima Mesgarani, nimail@gmail.com
% (Mesgarani et. al., Influence of Context and Behavior on Stimulus Reconstruction From 
%   Neural Activity in Primary Auditory Cortex, J. Neurophysiology 2009)


if ~exist('g','var'), g=[];end
if ~exist('TestResp','var') || isempty(TestResp)
    TestResp=[];
    rstim = [];
end
if ~exist('Lag','var') || isempty(Lag)
    Lag = [-5:7];
end
if ~isempty(StimTrain)
    TrainResp(isnan(TrainResp))=0;
    TrainRespLag = LagGeneratorNew(TrainResp,Lag);
    if ~isempty(TestResp)
    end
    disp('finding RR...');
    RR = TrainRespLag'*TrainRespLag;
    disp('finding RS...');
    for cnt1 = 1:size(StimTrain,3)
        RS(:,:,cnt1) = StimTrain(:,:,cnt1)*TrainRespLag;
    end
    disp('finding g...');
    %
    %
    [u,s,v] = svd(RR);
    tmp1 = diag(s);
    tmp2 = tmp1/sum(tmp1);
    for cnt1 = 1:length(tmp2)
        if sum(tmp2(1:cnt1))>0.99,
            break;
        end
    end
    tmp1 = 1./tmp1;
    tmp1(cnt1+1:end) = 0;
    tmp2 = (v*diag(tmp1)*u');
%         tmp2 = diag(ones(1,size(tmp2,1)));
    for cnt1 = 1:size(StimTrain,3)
        g(:,:,cnt1) = tmp2*RS(:,:,cnt1)';
    end
    %
    %     g = pinv(RR)*RS';
    %         g = RS' \ RR;
    disp('done...');
end
if ~isempty(TestResp)
    TestResp(isnan(TestResp))=0;
    TestRespLag  = LagGeneratorNew(TestResp,Lag);
    for cnt1 = 1:size(g,3)
        rstim(:,:,cnt1) = g(:,:,cnt1)'*TestRespLag';
    end
end