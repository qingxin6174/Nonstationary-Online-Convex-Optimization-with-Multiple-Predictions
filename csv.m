clear;
load('regret.mat');
downsample = unique(round(10.^(0:0.02:5)))';
for cases = 1:4
    REG = regret{cases}./repmat(1:1e5,4,1)';
    writecell({'x','a','b','c','d'},strcat('mreg',num2str(cases),'.csv'))
    writematrix([downsample,REG(downsample,:)],strcat('mreg',num2str(cases),'.csv'),'WriteMode','append')
end

clear;
load('regret_w.mat');
downsample = unique(round(10.^(0:0.005:4)))';
% downsample = round(linspace(1,1e4,200))';
for cases = 1:4
    REG = regret{cases}./repmat(1:1e4,8,1)';
    writecell({'x','a','b','c','d'},strcat('temp',num2str(cases),'.csv'))
    writematrix([downsample,REG(downsample,1:4)],strcat('temp',num2str(cases),'.csv'),'WriteMode','append')
end