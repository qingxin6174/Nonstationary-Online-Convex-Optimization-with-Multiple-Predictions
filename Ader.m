function [strategy,loss] = Ader(T,lossfun,lossoffset)
Proj = @(x)sign(x).*min([abs(x),ones(length(x),1)],[],2);
Norm = @(v)v/norm(v,1);
rho = 2; varrho = 2;
n = floor(log2(sqrt(2*T+1)))+1;
eta = rho/varrho/sqrt(T)*2.^(0:n-1)';
theta = 2/rho/varrho/sqrt(T); 
X = 2*rand(n,T+1)-1; G = zeros(n,T+1);
W = zeros(n,T+1); L = zeros(n,T+1);
s = zeros(T+1,1); loss = [lossoffset;rand(T,1)];
X(:,1) = 2*rand(n,1)-1;
G(:,1) = X(:,1); 
W(:,1) = Norm((1:n).^(-2))';
for t = 2:T+1
    X(:,t) = Proj(X(:,t-1)-eta.*G(:,t-1));
    W(:,t) = Norm(W(:,t-1)-theta.*L(:,t-1));
    s(t) = sum(W(:,t).*X(:,t),'all');
    loss(t) = lossfun(s(t),t); % Observe loss(t)
    Grad = @(s)sign(s-loss(t));
    G(:,t) = Grad(X(:,t));
    L(:,t) = Grad(s(t))*X(:,t);
end
strategy = s(2:T+1); loss = loss(2:T+1);