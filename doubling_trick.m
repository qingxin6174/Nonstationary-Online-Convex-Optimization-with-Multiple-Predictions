function [regret1,regret2] = doubling_trick(fun,T,lossfun,n,benign_flag,net,init)
strategy = []; loss = rand(n+1,1);
if nargin > 5
    loss(end-1) = init;
    for idx = 0:ceil(log2(T/40+1)-1)
        [strategynew,lossnew,net] = fun(40*2^idx,@(s,t)lossfun(s,t+length(loss)),loss(end-n:end),net);
        strategy = [strategy;strategynew]; loss = [loss;lossnew];
    end
else
    for idx = 0:ceil(log2(T/40+1)-1)
        [strategynew,lossnew] = fun(40*2^idx,@(s,t)lossfun(s,t+length(loss)),loss(end-n:end));
        strategy = [strategy;strategynew]; loss = [loss;lossnew];
    end
end
strategy = strategy(1:T); loss = loss(n+2:T+n+1);
switch benign_flag
    case 1
        regret1 = cumsum(abs(strategy-loss));
        regret2 = [];
    case -1
        regret1 = cumsum(abs(strategy-loss));
        ref = loss./log(exp(1)-1+log(exp(1)-1+(1:T)'));
        regret2 = cumsum(abs(strategy-loss)-abs(ref-loss));
    otherwise
        ref = loss./sqrt(1:T)';
        regret1 = cumsum(abs(strategy-loss)-abs(ref-loss));
        regret2 = [];
end