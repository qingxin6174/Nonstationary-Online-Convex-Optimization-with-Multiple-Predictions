% clear;
% f{1} = @(s,t)(sin(6*log(t))/2);
% f{2} = @(s,t)(mod(t,2)-0.5)+f{1}(s,t);
% f{3} = @(s,t)(mod(t,3)-1)/2+f{1}(s,t);
% f{4} = @(s,t)(s<0)-(s>=0);
% T = 1e5;
% parfor idx = 1:4
%     regret{idx} = zeros(T,4);
%     regret{idx}(:,1) = doubling_trick(@(T,l,o)Hedge_IOMD(T,l,o),T,@(s,t)f{idx}(s,t),4,idx<4);
%     regret{idx}(:,2) = doubling_trick(@(T,l,o)Hedge_IOMD(T,l,o),T,@(s,t)f{idx}(s,t),2,idx<4);
%     regret{idx}(:,3) = doubling_trick(@(T,l,o)Hedge_IMD(T,l,o),T,@(s,t)f{idx}(s,t),0,idx<4);
%     regret{idx}(:,4) = doubling_trick(@(T,l,o)Ader(T,l,o),T,@(s,t)f{idx}(s,t),0,idx<4);
% end
% save('regret.mat','regret');
% clear;

clear;
load('regret.mat');
for idx = 1:4
    % 创建 figure
    figure1 = figure('Position',[180,500,640,310],'Color','white');
    % 创建 axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    % 使用 plot 的矩阵输入创建多行
    loglog1 = loglog(regret{idx},'LineWidth',2,'LineStyle','-');
    set(loglog1(1),'DisplayName','Hedge-OptIOMD (1:4)','Color',[0.02 0.1 0.7]);
    set(loglog1(2),'DisplayName','Hedge-OptIOMD (1,2)','Color',[0.18 0.35 0.02]);
    set(loglog1(3),'DisplayName','Hedge-IOMD','Color',[0.65 0.24 0.07]);
    set(loglog1(4),'DisplayName','Ader','Color',[0.8 0.66 0.03]);
    % 创建 label
    xlabel('T','FontAngle','italic','FontSize',18,'FontName','Times', ...
        'VerticalAlignment','baseline','Units','pixels','Position',[492,15,0]);
    ylabel('regret','FontSize',18,'FontName','Times');
    hold(axes1,'off');
    % 设置其余坐标区属性
    set(axes1,'AmbientLightColor','none','Clipping','off','Color','none','FontName','Times','FontSize',16, ...
        'XColor',[0 0 0],'XMinorTick','on','XScale','log',...
        'YColor',[0 0 0],'YMinorTick','on','YScale','log', ...
        'YTick',10.^(0:5),'YTickLabel',{'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'}, ...
        'XTick',10.^(0:5),'XTickLabel',{'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'});
    data = regret{idx}(:);
    ylim(axes1,[0,1.15*max(data(:))]);
    % 创建 legend
    legend1 = legend(axes1,'show');
    set(legend1,'Orientation','vertical','Location','northwest', ...
        'FontSize',14,'EdgeColor','none','Color','none');

    exportgraphics(figure1,strcat('case',num2str(idx),'.pdf'),'BackgroundColor','none','ContentType','vector')
end