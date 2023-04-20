% 创建 figure
figure1 = figure('Position',[180,500,640,400],'Color','white');
% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
% 使用 plot 的矩阵输入创建多行
plot1 = plot(regret{4},'LineWidth',2);
set(plot1(1),'DisplayName','Hedge-OptIOMD (let previous 4 losses be predictors)','Color',[0.02 0.1 0.7]);
set(plot1(2),'DisplayName','Hedge-OptIOMD (let previous 2 losses be predictors)','Color',[0.18 0.35 0.02]);
set(plot1(3),'DisplayName','Hedge-IOMD','Color',[0.65 0.24 0.07]);
set(plot1(4),'DisplayName','Ader','Color',[0.8 0.66 0.03]);
% 创建 label
xlabel('T','FontAngle','italic','FontSize',60,'FontName','Times');
ylabel('regret','FontSize',60,'FontName','Times');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'AmbientLightColor','none','Clipping','off','Color','none',...
    'FontName','Times','FontSize',18,'XColor',[0 0 0],'XTick',...
    [1,1e4,3e4,5e4,7e4],'XTickLabel',...
    {'10^{0}','10^4','3\times10^4','5\times10^4','7\times10^4'},...
    'YColor',[0 0 0]);
set(axes1,'XScale','log','YScale','log');
xlim(axes1,[1 7.2e4]);
ylim(axes1,[0 2400]);
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,'Orientation','vertical','Location','northwest', ...
    'FontSize',14.5,'EdgeColor','none','Color','none');

exportgraphics(figure1,'adversarial.pdf','BackgroundColor','none','ContentType','vector')