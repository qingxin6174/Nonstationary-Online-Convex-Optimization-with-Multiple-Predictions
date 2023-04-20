clear
load('temperature.mat')
Temp = table2array(timetable2table(temp,'ConvertRowTimes',false));
% XTrain = cell(32,1);TTrain = cell(32,1);
for idx = 1:28
    D = mean(reshape(Temp(1:end-2,idx),4,floor(length(Temp)/4)));
    data = (D-(max(D)+min(D))/2) / (max(D)-min(D))*2;
%     figure,plot(data,'MarkerSize',8,'Marker','.');
    XTrain{idx} = data(:,1:end-1);
    TTrain{idx} = data(:,2:end);
end

layers = [ ...
    sequenceInputLayer(1)
    lstmLayer(256,'OutputMode','sequence')
    fullyConnectedLayer(1)
    regressionLayer];
options = trainingOptions("adam", ...
    MaxEpochs=1000, ...
    MiniBatchSize=7, ...
    SequencePaddingDirection="left", ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=0);
net = trainNetwork(XTrain,TTrain,layers,options);

save('net256.mat','net');



for idx = 29:32
    net = resetState(net);
    D = mean(reshape(Temp(1:end-2,idx),4,floor(length(Temp)/4)));
    d = (D-(max(D)+min(D))/2) / (max(D)-min(D))*2;
    [net,~] = predictAndUpdateState(net,d(1:1114));
    d = d(1114:2114)';
    T = 1001; y = zeros(T,1);
    for t = 2:T
        [net,y(t)] = predictAndUpdateState(net,d(t-1));
    end

    figure,plot([d(1:T),y],'MarkerSize',8,'Marker','.');
end