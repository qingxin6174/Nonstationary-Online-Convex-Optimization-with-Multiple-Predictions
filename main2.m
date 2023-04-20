% clear;
% load('temperature.mat')
% load('lstm256.mat')
% Temp = table2array(timetable2table(temp,'ConvertRowTimes',false));
% for idx = 29:32
%     net = resetState(net);
%     D = mean(reshape(Temp(1:end-2,idx),4,floor(length(Temp)/4)));
%     D = (D-(max(D)+min(D))/2) / (max(D)-min(D))*2;
%     init = D(1:1114); data = repmat(D(1115:end),1,10);
%     f = @(s,t)data(t);
%     [net,~] = predictAndUpdateState(net,init);
%     T = 1e4;
%     regret{idx-28} = zeros(T,8);
% 
%     [regret{idx-28}(:,1),regret{idx-28}(:,5)] = ...
%         doubling_trick(@(T,l,o,n)Hedge_IOMD_LSTM(T,l,o,n),T,@(s,t)f(s,t),4,-1,net,init(end));
%     [regret{idx-28}(:,2),regret{idx-28}(:,6)] = ...
%         doubling_trick(@(T,l,o)Hedge_IOMD(T,l,o),T,@(s,t)f(s,t),2,-1);
%     [regret{idx-28}(:,3),regret{idx-28}(:,7)] = ...
%         doubling_trick(@(T,l,o)Hedge_IMD(T,l,o),T,@(s,t)f(s,t),0,-1);
%     [regret{idx-28}(:,4),regret{idx-28}(:,8)] = ...
%         doubling_trick(@(T,l,o)Ader(T,l,o),T,@(s,t)f(s,t),0,-1);
% end
% 
% save('regret_w.mat','regret');
% clear;

clear;
load('regret_w.mat');
for idx = 1:4
    % 创建 figure
    figure1 = figure('Position',[180,200,640,560],'Color','white');
    % 创建 axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % 使用 plot 的矩阵输入创建多行
    loglog1 = loglog(regret{idx}(:,1:4),'LineWidth',2,'LineStyle','--');
    set(loglog1(1),'DisplayName','Hedge-OptIOMD (1,2,3,LSTM)','Color',[0.02 0.1 0.7]);
    set(loglog1(2),'DisplayName','Hedge-OptIOMD (1,2)','Color',[0.18 0.35 0.02]);
    set(loglog1(3),'DisplayName','Hedge-IOMD','Color',[0.65 0.24 0.07]);
    set(loglog1(4),'DisplayName','Ader','Color',[0.8 0.66 0.03]);
    loglog2 = loglog(regret{idx}(:,5:8),'LineWidth',2,'LineStyle','-');
    set(loglog2(1),'DisplayName','Hedge-OptIOMD (1,2,3,LSTM)','Color',[0.02 0.1 0.7]);
    set(loglog2(2),'DisplayName','Hedge-OptIOMD (1,2)','Color',[0.18 0.35 0.02]);
    set(loglog2(3),'DisplayName','Hedge-IOMD','Color',[0.65 0.24 0.07]);
    set(loglog2(4),'DisplayName','Ader','Color',[0.8 0.66 0.03]);
    % 创建 label
    xlabel('T','FontAngle','italic','FontSize',18,'FontName','Times');
    ylabel('regret','FontSize',18,'FontName','Times');
    hold(axes1,'off');
    % 设置其余坐标区属性
    set(axes1,'AmbientLightColor','none','Clipping','off','Color','none', ...
        'FontName','Times','FontSize',16,'XColor',[0 0 0],'YColor',[0 0 0],'XAxisLocation','origin');
    % 创建 legend
    legend1 = legend(loglog1);
    set(legend1,'Orientation','vertical','Location','northwest', ...
        'FontSize',14,'EdgeColor','none','Color','none','FontName','Times');
    title(legend1,'Optimal Comparators');
    ah1 = axes('position',get(gca,'position'),'visible','off');
    legend2 = legend(ah1,loglog2);
    set(legend2,'Orientation','vertical','Location','southwest', ...
        'FontSize',14,'EdgeColor','none','Color','none','FontName','Times');
    title(legend2,'Shrinkage Comparators');
%     xlim(axes1,[0,100+1e4]);
    data = regret{idx}(:);
    ylim(axes1,[min([-1500;data(:)])-180,max([1100;data(:)])+150]);

    exportgraphics(figure1,strcat('withLSTM',num2str(idx),'.pdf'),'BackgroundColor','none','ContentType','vector')
end