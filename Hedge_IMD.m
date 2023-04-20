function [strategy,loss] = Hedge_IMD(T,lossfun,lossoffset)
D = sqrt(2); Lip = 2; % lossfun = @(s,t)(sin(6*log(t))/2); lossoffset = rand; T = 1e4;
m = ceil(log2(1+sqrt(2)*D*T)); e = 0.02;
delta = zeros(m+1,T+1); Delta = zeros(T+1,1);
eta = ones(m+1,T+1)/e; theta = ones(T+1,1)/e;
X = 2*rand(m+1,T+1)-1; W = ones(m+1,T+1)/(m+1);
loss = [lossoffset;rand(T,1)]; Loss = rand(m+1,T+1);
s = ones(T+1,1);
argmin = @(x,l,e)(x-sign(x-l).*e).*(abs(x-l)>=e)+l.*(abs(x-l)<e);
for t = 2:T+1
    X(:,t) = argmin(X(:,t-1),repmat(loss(t-1),m+1,1),eta(:,t-1));
    W(:,t) = opt_entropy(W(:,t-1).*exp(-theta(t-1)*Loss(:,t-1)),(m+1)/T);
    s(t) = sum(W(:,t).*X(:,t),'all');
    loss(t) = lossfun(s(t),t); % Observe loss(t)
    Loss(:,t) = abs(loss(t)-X(:,t));
    delta(:,t-1) = abs(loss(t-1)-X(:,t-1))-abs(loss(t-1)-X(:,t))-(X(:,t)-X(:,t-1)).^2./eta(:,t)/2;
    eta(:,t) = (D^2+(2.^(0:m)-1)'*Lip)./(e+sum(delta(:,1:t-1),2));
    Delta(t-1) = sum(Loss(:,t-1).*(W(:,t-1)-W(:,t)),'all')-sum(log(W(:,t)./W(:,t-1)).*W(:,t),'all')/theta(t-1);
    theta(t) = log(T)/(e+sum(Delta(1:t-1)));
end
strategy = s(2:T+1); loss = loss(2:T+1);