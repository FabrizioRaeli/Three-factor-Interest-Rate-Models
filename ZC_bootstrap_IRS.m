function [ZC_curves] = ZC_bootstrap_IRS(MID_rates,seattlement_dates)
%
% INPUT
% MID_rates                 = values of the swap rates
% seattlement_dates         = numerical date corresponding to each swap
% OUTPUT:
% ZC_curves                 = Zero Coupon Curves for each date

% swap percentage
swap_fixed = MID_rates/100;

deltas = zeros(size(MID_rates));
payment_dates = zeros(size(deltas,2),1);
T = zeros(size(deltas));
for i = 1:size(deltas,1)
    for j=1:size(deltas,2)
        payment_dates(j) = addtodate(seattlement_dates(i),j,"month");
        while isbusday(payment_dates(j)) == 0
            payment_dates(j) = addtodate(payment_dates(j),1,"day");
        end
    end
    deltas(i,:) = yearfrac([seattlement_dates(i);payment_dates(1:end-1)],payment_dates(1:end),6);
    I = seattlement_dates(i)*ones(length(payment_dates),1);
    T(i,:) = yearfrac(I,payment_dates(1:end),3);
end

% initialize vector of swaps DF
disc_swaps = zeros(size(deltas));

% first swap discount for each date
disc_swaps(:,1) = 1./(1 + deltas(:,1) .* swap_fixed(:,1));

% swap discounts;
for i = 1:size(deltas,1)
    for j = 2:size(deltas,2)
        BPV = sum(deltas(i,1:j-1).*disc_swaps(i,1:j-1));
        disc_swaps(i,j)=(1 - swap_fixed(i,j) * BPV)/(1 + deltas(i,j)*swap_fixed(i,j));
    end 
end

% Zero Rates
ZC_curves = zeros(size(deltas));
for i = 1:size(deltas,1)
    ZC_curves(i,:) = -log(disc_swaps(i,1:end))./T(i,1:end);
end

end