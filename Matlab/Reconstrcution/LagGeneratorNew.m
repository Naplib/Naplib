function [out]=LagGeneratorNew(R,Lag)
% R: is the time*neurons
% out: is the time* (neuron*lags)

% Nima, 2008
out=zeros(size(R,1),size(R,2)*length(Lag));
ind2=1;
R(end+1:end+13,:) = 0;
for cnt1 = 1:length(Lag)
    t1 = circshift(R,Lag(cnt1));
    if Lag(cnt1)<0
        t1(end-abs(Lag(cnt1)):end,:)=0;
    else
        t1(1:Lag(cnt1),:)=0;
    end
    out(:,ind2:ind2+size(R,2)-1) = t1(1:size(out,1),:);
    ind2 = ind2+size(R,2);
end