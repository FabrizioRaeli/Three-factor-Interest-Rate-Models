function disptable(yield,y_hat,y_hatPCA,i)
% function that displays the error tables for both Nelson-Siegel and PCA
% method in 1y, 3y, 5y, 10y maturities
%
% INPUT
% yield     = yield curve
% y_hat     = Nelson-Siegel forecasted curve
% y_hatPCA  = PCA forecasted curve
% i         = starting date index for yield curve 
% OUTPUT:
% error tables

Maturity = [1; 3; 5; 10];

mean_NS = zeros(4,1);
Std_Dev_NS = zeros(4,1);
RMSE_NS = zeros(4,1);
AC12_NS = zeros(4,1);
AC24_NS = zeros(4,1);

error_NS_1y = (yield(i+12:end,1)-y_hat(1:end-12,1))*100;
AC_NS_1y = autocorr(error_NS_1y,'NumLags',24);
AC12_NS(1) = AC_NS_1y(12);
AC24_NS(1) = AC_NS_1y(24);
RMSE_NS(1) = sqrt(mean(abs(error_NS_1y).^2));
mean_NS(1) = mean(error_NS_1y);
Std_Dev_NS(1) = std(error_NS_1y);

error_NS_3y = (yield(i+12:end,3)-y_hat(1:end-12,3))*100;
AC_NS_3y = autocorr(error_NS_3y,'NumLags',24);
AC12_NS(2) = AC_NS_3y(12);
AC24_NS(2) = AC_NS_3y(24);
RMSE_NS(2) = sqrt(mean(abs(error_NS_3y).^2));
mean_NS(2) = mean(error_NS_3y);
Std_Dev_NS(2) = std(error_NS_3y);

error_NS_5y = (yield(i+12:end,5)-y_hat(1:end-12,5))*100;
AC_NS_5y = autocorr(error_NS_5y,'NumLags',24);
AC12_NS(3) = AC_NS_5y(12);
AC24_NS(3) = AC_NS_5y(24);
RMSE_NS(3) = sqrt(mean(abs(error_NS_5y).^2));
mean_NS(3) = mean(error_NS_5y);
Std_Dev_NS(3) = std(error_NS_5y);

error_NS_10y = (yield(i+12:end,10)-y_hat(1:end-12,10))*100;
AC_NS_10y = autocorr(error_NS_10y,'NumLags',24);
AC12_NS(4) = AC_NS_10y(12);
AC24_NS(4) = AC_NS_10y(24);
RMSE_NS(4) = sqrt(mean(abs(error_NS_10y).^2));
mean_NS(4) = mean(error_NS_10y);
Std_Dev_NS(4) = std(error_NS_10y);

mean_PCA = zeros(4,1);
Std_Dev_PCA = zeros(4,1);
RMSE_PCA = zeros(4,1);
AC12_PCA = zeros(4,1);
AC24_PCA = zeros(4,1);

error_PCA_1y = (yield(i+13:end,1)-y_hatPCA(1:end-12,1))*100;
AC_PCA_1y = autocorr(error_PCA_1y,'NumLags',24);
AC12_PCA(1) = AC_PCA_1y(12);
AC24_PCA(1) = AC_PCA_1y(24);
RMSE_PCA(1) = sqrt(mean(abs(error_PCA_1y).^2));
mean_PCA(1) = mean(error_PCA_1y);
Std_Dev_PCA(1) = std(error_PCA_1y);

error_PCA_3y = (yield(i+13:end,3)-y_hatPCA(1:end-12,3))*100;
AC_PCA_3y = autocorr(error_PCA_3y,'NumLags',24);
AC12_PCA(2) = AC_PCA_3y(12);
AC24_PCA(2) = AC_PCA_3y(24);
RMSE_PCA(2) = sqrt(mean(abs(error_PCA_3y).^2));
mean_PCA(2) = mean(error_PCA_3y);
Std_Dev_PCA(2) = std(error_PCA_3y);

error_PCA_5y = (yield(i+13:end,5)-y_hatPCA(1:end-12,5))*100;
AC_PCA_5y = autocorr(error_PCA_5y,'NumLags',24);
AC12_PCA(3) = AC_PCA_5y(12);
AC24_PCA(3) = AC_PCA_5y(24);
RMSE_PCA(3) = sqrt(mean(abs(error_PCA_5y).^2));
mean_PCA(3) = mean(error_PCA_5y);
Std_Dev_PCA(3) = std(error_PCA_5y);

error_PCA_10y = (yield(i+13:end,10)-y_hatPCA(1:end-12,10))*100;
AC_PCA_10y = autocorr(error_PCA_10y,'NumLags',24);
AC12_PCA(4) = AC_PCA_10y(12);
AC24_PCA(4) = AC_PCA_10y(24);
RMSE_PCA(4) = sqrt(mean(abs(error_PCA_10y).^2));
mean_PCA(4) = mean(error_PCA_10y);
Std_Dev_PCA(4) = std(error_PCA_10y);

Nelson_Siegel = table(Maturity,mean_NS,Std_Dev_NS,RMSE_NS,AC12_NS,AC24_NS)

Principal_Component_Analysis = table(Maturity,mean_PCA,Std_Dev_PCA,RMSE_PCA,AC12_PCA,AC24_PCA)

end