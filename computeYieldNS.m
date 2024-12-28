function yieldNS = computeYieldNS (beta,lambda)
% function that given the betas and the lambda computes the Nelson-Siegel
% yield curve

tau = (12:12:120)';

coeff1 = (1-exp(-lambda*tau))./(lambda*tau);
coeff2 = coeff1 - exp(-lambda*tau);

yieldNS = beta(:,1) + beta(:,2) * coeff1' + beta(:,3) * coeff2';

end