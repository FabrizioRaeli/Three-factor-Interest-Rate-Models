function [lambda,beta] = param(yield,tau)
% function that finds the best lambda and fit the model in order to find the
% corresponding betas
% INPUTS:
% yield     = yield curve from the IRS rates
% tau       = vector of maturities
%
% OUTPUTS:
% lambda    = optimal exponential decay rate (constant)
% beta      = factors of the Nelson-Siegel model (3 for each month)

% lambda grid
t = linspace(1,6*12,1000)';
l = 1./t;
d = zeros(size(yield,1),length(l));

% computation of the optimal lambda
for i = 1:length(l)
A(:,1) = ones(10,1);
A(:,2) = (1-exp(-l(i)*tau))./(l(i)*tau);
A(:,3) = (1-exp(-l(i)*tau))./(l(i)*tau) - exp(-l(i)*tau);
AA = A'*A;
b = A'*yield';
beta = (AA\b);
y_NS = (A*beta)';
d(:,i) = sum(abs(y_NS-yield).^2,2);
end

dist = sum(d);
lambda = l(min(dist) == dist);

% betas obtained with the optimal lambda
A(:,1) = ones(10,1);
A(:,2) = (1-exp(-lambda*tau))./(lambda*tau);
A(:,3) = (1-exp(-lambda*tau))./(lambda*tau) - exp(-lambda*tau);
AA = A'*A;
b = A'*yield';
beta = (AA\b)';

end