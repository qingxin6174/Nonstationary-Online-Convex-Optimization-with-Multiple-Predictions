function [strategy,loss,net] = Hedge_IOMD_LSTM(T,lossfun,lossoffset,net)
D = sqrt(2); Lip = 2; % lossfun = @(s,t)
m = ceil(log2(1+sqrt(2)*D*T)); n = length(lossoffset)-1; e = 0.02;
delta = zeros(m+1,n,n+T+1); Delta = zeros(n+T+1,1); sigma = zeros(n+T+1,1);
eta = ones(m+1,n,n+T+1)/e; theta = ones(n+T+1,1)/e; vartheta = ones(n+T+1,1)/e;
X = 2*rand(m+1,n,n+T+1)-1; W = ones(m+1,n,n+T+1)/(m+1)/n; omega = ones(n,n+T+1)/n;
x = 2*rand(m+1,n,n+T+1)-1; w = ones(m+1,n,n+T+1)/(m+1)/n; 
loss = [lossoffset;zeros(T,1)]; Loss = zeros(m+1,n,n+T+1); L = zeros(n,n+T+1);
s = ones(n+T+1,1); h = zeros(n,n+T+1); H = zeros(m+1,n,n+T+1);
argmin = @(x,l,e)(x-sign(x-l).*e).*(abs(x-l)>=e)+l.*(abs(x-l)<e);
for t = n+2:n+T+1
    h(:,t) = loss(t-1:-1:t-n);
    [net,h(4,t)] = predictAndUpdateState(net,loss(t-1));
    eta(:,:,t) = (D^2+repmat((2.^(0:m)-1)',1,n)*Lip)./(e+sum(delta(:,:,1:t-1),3));
    X(:,:,t) = argmin(x(:,:,t),repmat(h(:,t)',m+1,1),eta(:,:,t));
    L(:,t-1) = abs(loss(t-1)-h(:,t-1));
    vartheta(t-1) = log(T)/(e+sum(sigma(1:t-2)));
    omega(:,t) = opt_entropy(omega(:,t-1).*exp(-vartheta(t-1)*L(:,t-1)),n/T);
    sigma(t-1) = sum(L(:,t-1).*(omega(:,t-1)-omega(:,t)),'all')-sum(log(omega(:,t)./omega(:,t-1)).*omega(:,t),'all')/vartheta(t-1);
    H(:,:,t) = sum(abs(reshape(repmat(h(:,t),1,(m+1)*n)',[m+1,n,n])-repmat(X(:,:,t),1,1,n)).*reshape(repmat(omega(:,t),1,(m+1)*n)',[m+1,n,n]),3);
    theta(t) = log(T)/(e+sum(Delta(1:t-1)));
    W(:,:,t) = opt_entropy(w(:,:,t).*exp(-theta(t)*H(:,:,t)),(m+1)*n/T);
    s(t) = sum(W(:,:,t).*X(:,:,t),'all');
    loss(t) = lossfun(s(t),t); % Observe loss(t)
    x(:,:,t+1) = argmin(x(:,:,t),loss(t),eta(:,:,t));
    delta(:,:,t) = abs(loss(t)-X(:,:,t))-abs(loss(t)-x(:,:,t+1))+abs(repmat(h(:,t)',m+1,1)-x(:,:,t+1))-abs(repmat(h(:,t)',m+1,1)-X(:,:,t))-(x(:,:,t+1)-X(:,:,t)).^2./eta(:,:,t)/2;
    Loss(:,:,t) = abs(loss(t)-X(:,:,t));
    w(:,:,t+1) = opt_entropy(w(:,:,t).*exp(-theta(t)*Loss(:,:,t)),(m+1)*n/T);
    Delta(t) = sum((Loss(:,:,t)-H(:,:,t)).*(W(:,:,t)-w(:,:,t+1)),'all')-sum(log(w(:,:,t+1)./W(:,:,t)).*w(:,:,t+1),'all')/theta(t);
end
strategy = s(n+2:n+T+1); loss = loss(n+2:n+T+1);