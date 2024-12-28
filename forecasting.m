function [y_hat,y_hatPCA] = forecasting(beta_hat,lambda,PrincComp,loadings,i)
% function that forecasts our data data using an AR(1) model as described
% in the paper [2] from February-2008 to March-2015
%
% INPUT
% beta_hat      = betas from Nelson-Siegel
% lambda        = optimal Nelson-Siegel lambda
% PrincComp     = Principal Components from the PCA
% loadings      = loadings of the PCA 
% i             = starting date index for yield curve forecast
% OUTPUT:
% y_hat         = forecasted yield curve with Nelson-Siegel parameters
% y_hatPCA      = forecasted yield curve with PCA parameters

%% Nelson-Siegel
% training set
beta_new = beta_hat(13:i-1,:);
beta_old = beta_hat(1:i-1-12,:);
% regression for AR(1) coefficients
beta1 = [ones(size(beta_new,1),1) beta_old(:,1)];
X1_NS = regress(beta_new(:,1),beta1);

beta2 = [ones(size(beta_new,1),1) beta_old(:,2)];
X2_NS = regress(beta_new(:,2),beta2);

beta3 = [ones(size(beta_new,1),1) beta_old(:,3)];
X3_NS = regress(beta_new(:,3),beta3);
% testing set
beta_new = beta_hat(i:end,:);
% beta forecasted
beta_fwd = zeros(size(beta_new,1),3);
beta_fwd(:,1) = X1_NS(1) + X1_NS(2)*beta_new(:,1);
beta_fwd(:,2) = X2_NS(1) + X2_NS(2)*beta_new(:,2);
beta_fwd(:,3) = X3_NS(1) + X3_NS(2)*beta_new(:,3);
% forecasted yield curve
y_hat = computeYieldNS(beta_fwd,lambda);

%% PCA
% training set
pc_new = PrincComp(13:i-1,:);
pc_old = PrincComp(1:i-1-12,:);
% regression for AR(1) coefficients
pc1 = [ones(size(pc_new,1),1) pc_old(:,1)];
X1_PCA = regress(pc_new(:,1),pc1);

pc2 = [ones(size(pc_new,1),1) pc_old(:,2)];
X2_PCA = regress(pc_new(:,2),pc2);

pc3 = [ones(size(pc_new,1),1) pc_old(:,3)];
X3_PCA = regress(pc_new(:,3),pc3);
% testing set
pc_new = PrincComp(i:end,:);
% forecasted Principal Components
x_hat = zeros(size(pc_new,1),3);
x_hat(:,1) = X1_PCA(1) + X1_PCA(2) * pc_new(:,1);
x_hat(:,2) = X2_PCA(1) + X2_PCA(2) * pc_new(:,2);
x_hat(:,3) = X3_PCA(1) + X3_PCA(2) * pc_new(:,3);
% forecasted yield curve
y_hatPCA = x_hat * loadings';

end