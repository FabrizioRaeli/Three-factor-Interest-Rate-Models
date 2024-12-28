%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RM8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   INPUT data are stored as:
%   - IRS monthly rates : swap rates  composed by ten tenors across 183
%       months from 1999 to 2014
%   
% 
%    OUTPUT data are stored as:
%   - Nelson-Siegel betas for the three factor model
%   - Principal Components of the PCA which are our new betas
%   - Twelve months ahead forecast of the model with the two possible set
%       set of betas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

%% Input Data

% Import Excel
filename = "IRS_monthly";
[dates_num, MID_rates] = readExcel(filename);
% Bootstrap
[yield] = ZC_bootstrap_IRS(MID_rates,dates_num);
% Yield values for some Maturities
dates = datetime(datestr(dates_num));
figure
plot(dates,yield(:,[1,3,5,10])*100)
legend('1 year Yield','3 year Yield','5 year Yield','10 year Yield')
xlabel('years')
ylabel('Yield (%)')
title('Yield values between 01/99 and 3/14 for each maturities')
% Yield Curve
tau = (12:12:120)';
tt = (1:10).*ones(183,1);
xx = [dates,dates,dates,dates,dates,dates,dates,dates,dates,dates];
figure
surf(xx,tt,yield*100)
xlabel('Time','Rotation',25)
ylabel('Maturity (years)','Rotation',-25)
zlabel('Yield (%)')
xtickangle(40)

%% Point 1

% Nelson-Siegel parameters
[lambda,beta] = param(yield,tau);

%% Yield curve and NS curve

yieldNS = computeYieldNS(beta,lambda);
% Comparison of yield curves with Nelson-Siegel curve
x = [7,110,116,157];
figure
for i = 1:length(x)
subplot(2,2,i)
plot(1:10, yield(x(i),:)*100,'b-',1:10, yieldNS(x(i),:)*100,'*-')
title(['Yield Curve on ' datestr(dates(x(i)))])
xlabel('Maturity(years)')
ylabel('Yield(%)')
legend('yield curve','fitted NS yield curve')
end

%% Empirical betas

coeff1 = @(t) (1-exp(-lambda*t))./(lambda*t);
coeff2 = @(t) coeff1(t) - exp(-lambda*t);

A(1,1) = coeff1(120) - coeff1(12);
A(1,2) = coeff2(120) - coeff2(12);
A(2,1) = 2*coeff1(24) - coeff1(120) - coeff1(12);
A(2,2) = 2*coeff2(24) - coeff2(120) - coeff2(12);

b = zeros(2,length(dates_num));
b(1,:) = yield(:,10)' - yield(:,1)';
b(2,:) = 2*yield(:,2)' - yield(:,1)' - yield(:,10)';
beta_emp = zeros(length(dates_num),3);
beta_emp(:,2:3) = (A\b)';
beta_emp(:,1) = yield(:,10) - beta_emp(:,2) *coeff1(120) - beta_emp(:,3) *coeff2(120);

%% Point 2

% Yield changes calculation for PCA
yieldPCA = yield(2:end,:) - yield(1:end-1,:);
muPCA = mean(yieldPCA);
sigmaPCA = std(yieldPCA);
yieldPCA_ = (yieldPCA - muPCA)./sigmaPCA;

corr = corrcoef(yieldPCA_);
figure
h = heatmap(corr, 'ColorMap',parula,'ColorScaling','scaled','GridVisible','off');
h.XLabel = 'Maturities (years)';
h.YLabel = 'Maturities (years)';
h.Title = 'Correlation Matrix';

[loadings,PrincComp,~] = pca(yieldPCA_,'NumComponents',3);

%% graphs of the betas

figure
plot(dates,beta_emp(:,1)*100,'r',dates,beta(:,1)*100,'b')
legend('\beta_1-Emp','\beta_1-NS')
title('\beta_1 Comparison','dates between 29-1-99 and 31-3-14')
xlabel('years')
ylabel('(%)')

figure
plot(dates,beta_emp(:,2)*100,'r',dates,beta(:,2)*100,'b')
legend('\beta_2-Emp','\beta_2-NS')
title('\beta_2 Comparison','dates between 29-1-99 and 31-3-14')
xlabel('years')
ylabel('(%)')

figure
plot(dates,beta_emp(:,3)*100,'r',dates,beta(:,3)*100,'b')
legend('\beta_3-Emp','\beta_3-NS')
title('\beta_3 Comparison','dates between 29-1-99 and 31-3-14')
xlabel('years')
ylabel('(%)')

%% graphs of the loadings

figure
plot(1:10,loadings(:,1),'ro-',1:10,loadings(:,2),'bo-',1:10,loadings(:,3),'go-')
hold on
plot(1:10,0*(1:10),'k')
legend('PC1','PC2','PC3')
title('Principal component loadings')
xlabel('Tenors')

%% FORECAST

i = 98;
[y_hat,y_hatPCA] = forecasting(beta,lambda,PrincComp,loadings,i);

% Convert Yield changes to Yield levels
y_hatPCA = y_hatPCA./100;
y_hatPCA(1:end-12,:) = y_hatPCA(1:end-12,:) + yield((98+12):end-1,:); 
y_hatPCA(end-12:end,:) = cumsum(y_hatPCA(end-12:end,:));

% We sum 'end-12' since that line is the difference of the yield between
% March and February 2014 and so i must sum not the 'end' line (March 2015)
% but the 'end-1' line (February 2014) to obtain the yield curve of March

%% graphs of the forecast for NS

figure
plot(1:10, yield(98+12,:)*100,1:10, y_hat(1,:)*100,'-or')
legend('Bootstrap','forecasted-NS')
title('Nelson-Siegel','yield: from Feb-08 to Feb-18')
xlabel('Maturities (years) ')
ylabel('Yield (%)')

figure
plot(1:10, yield(98+24,:)*100,1:10, y_hat(13,:)*100,'-or')
legend('real','forecasted-NS')
title('Nelson-Siegel','yield: from Feb-09 to Feb-19')
xlabel('Maturities (years)')
ylabel('Yield (%)')

figure
plot(1:10, yield(98+13,:)*100,1:10, y_hatPCA(1,:)*100,'-og')
legend('Bootstrap','forecasted-PCA')
title('PCA','yield: from Mar-08 to Mar-18')
xlabel('Maturities (years) ')
ylabel('(%)')

figure
plot(1:10, yield(98+25,:)*100,1:10, y_hatPCA(13,:)*100,'-og')
legend('real','forecasted-PCA')
title('PCA','yield: from Mar-09 to Mar-19')
xlabel('Maturities (years) ')
ylabel('(%)')

figure 
plot(1:10,yield(end-11,:)*100,1:10,y_hat(end-11,:)*100,'-or',1:10,y_hatPCA(end-11,:)*100,'-og')
legend('RW','Nelson-Siegel','PCA')
title('Forecast comparison','yield: from Apr-14 to Apr-24')
xlabel('Maturities (years) ')
ylabel('(%)')

%% Forecasting table

% we use this value of i since it indicates the values of the yield from
% 28-February-2007
disptable(yield,y_hat,y_hatPCA,i);

%% Final Analisys

i = 121;
[y_hat2008,y_hatPCA2008] = forecasting(beta,lambda,PrincComp,loadings,i);

% here we use this value of i that indicates the 30-January-2009 in our
% dates vector beacuse we want to take into consideration also the 2008
% crisis

y_hatPCA2008 = y_hatPCA2008./100;
y_hatPCA2008(1:end-12,:) = y_hatPCA2008(1:end-12,:) + yield((i+12):end-1,:); 
y_hatPCA(end-12:end,:) = cumsum(y_hatPCA(end-12:end,:));

disptable(yield,y_hat2008,y_hatPCA2008,i);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THANK YOU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%