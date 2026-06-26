%% Processing and plotting script for Figure 4
%  Code Associated with the manuscript: 
%  "The fingerprint of reduced overturning circulation on 39Ar"
%   Martin et al., submitted to Geophysical Research Letters
% 
%  Written by Kaden Martin
%  Last updated: June 26th, 2026
%  Contact: kaden.martin@whoi.edu
%
%  -----=
%  Code will calculate the sensitivity of 39Arpm to MOC across the globe,
%  and plot with a focus on the North Atlantic. Will also calculate the
%  windowed correlation between either circulation and the transect within
%  the NAtl. Original data files are large (~10GB) - for ease, needed data
%  was extracted and included. Full data files are available on request.
%  -----=

%% Prepare workspace
clear; close all;

% -= User input
which_moc = 'AMOC'; % 'AMOC' or 'AABW'
time1 = 1980; % younger time (1980); youngest possible is 1765
time2 = 2100; % latest time (2100); latest possible is 2499

% -= Load model results
load('../Data/moc_from_psi_basins_ssp3-7.0ext.mat');
load('../Data/UVIC_Coordinates.mat');
load('../Data/Figure4_Data')

% -= Load measurements
load('../Data/Ar39_Data.mat');

% -= Load utilties
load('../Utilities/brownteal.mat'); 
load('../Utilities/redblue.mat'); 
load('../Utilities/RGB_Colors.mat');
load('../Utilities/coastlines.mat');

%% Calculate sensitivty of 39Ar to MOC
if strcmp(which_moc,'AMOC') == 1
    circulation_select = psi_amoc;
    contour_range = [0 1 1.5 2 2.5 3 4];
    string_label = '^{39}Ar_{pm} AMOC Sensitivty (%/Sv)';
elseif strcmp(which_moc,'AABW') == 1
    circulation_select = psi_aabw;
    contour_range = [0 2 4 6 8 10];
    string_label = '^{39}Ar_{pm} AABW Sensitivty (%/Sv)';
end

% -----= Calculate avg Sensitivity across time 1 to time 2
ranger = find(T == time1):find(T == time2);
for i = 1:100
    for j = 1:100
        amoc_sensitivity(i,j) = 100*mean(squeeze(model_output_2k_ann(i,j,ranger))./circulation_select(ranger));
    end
end

% -= Convert to ATL projection
amoc_sensitivity_atl = [amoc_sensitivity(51:end,:); amoc_sensitivity(1:50,:)];
x_atl = x - 180;

% -----= Plot 39Ar / MOC Sensitivity
figure; hold on;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 22;
ax = gca;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) % this is where matlab puts the figure on your screen, and how large it is
set(ax,'Color','k');
ax.FontSize = 16;
[C,h] = contourf(x_atl,y,amoc_sensitivity_atl',contour_range,'LineWidth',1.5,'ShowText',true,'LabelColor','k');
plot(coastlon,coastlat,'w-','LineWidth',1.75)
clabel(C,h,'FontSize',15,'Color','k','LabelSpacing',200,'FontWeight','bold');
colormap(colormapper([1 1 1],[],[70,130,180]/255,'two'));
co = colorbar;
co.Label.String = string_label;
ylabel('Latitude (^{o}N)');
xlabel('Longitude (^{o}E)');
axis([-100 25 y(1) y(end)]);

%% Compare transect values to MOC 
% -----= Extract values at the transect and compare to AMOC and AABW
xx = 1;
for i = 1:size(x_inds,2) % x_inds are the lon of transect in NAtl core 
    for j = 1:size(y_inds,2) % y_inds are the lat of transect in NAtl core 
        dummy_profile(xx,:) = squeeze(model_output_2k(x_inds(i),y_inds(j),:));
        xx = xx+1;
    end
end

dummy_profile = dummy_profile';

% -= convert to annual avg
k = 1;
for i = 1:12:size(dummy_profile,1)
    dummy_profile_ann(k,:) = mean(dummy_profile(i:i+11,:),1);
    k = k+1;
end

% rename
atl_profiles_mean_2000_ann = dummy_profile_ann';

colors = [yellow_green; sky_blue; [255 128 0]/255; [0 102 102]/255; orchid; [0 0 255]/255];
profile_color = sky_blue;

% -= Plot transect along with AMOC and AABW anomaly
figure; hold on;
i_range = 21:26;
k = 1; kk = 1;
for i = i_range
    if i == i_range(1)
        plot(T,100*atl_profiles_mean_2000_ann(i,:),'-','Color',profile_color,'LineWidth',1.25);
        p3 = plot(T(1:15:735),100*atl_profiles_mean_2000_ann(i,1:15:735),'ko','MarkerSize',10,'MarkerFaceColor',profile_color,'DisplayName','Southernmost');
    elseif i == i_range(end)
        plot(T,100*atl_profiles_mean_2000_ann(i,:),'-','Color',profile_color,'LineWidth',1.25);
        p4 = plot(T(1:15:735),100*atl_profiles_mean_2000_ann(i,1:15:735),'ks','MarkerSize',10,'MarkerFaceColor',profile_color,'DisplayName','Northernmost');
    else
        plot(T,100*atl_profiles_mean_2000_ann(i,:),'-','Color',profile_color,'LineWidth',1.25);
    end
    k = k+1;
    kk = kk+1;
end

ylabel('^{39}Ar_{pm} (%)');
yyaxis right;
set(gca,'YColor','k');
p1 = plot(T,psi_amoc-mean(psi_amoc(1:100)),'k-','LineWidth',1.5,'DisplayName','AMOC');
p2 = plot(T,psi_aabw-mean(psi_aabw(1:100)),'k--','LineWidth',1.5,'DisplayName','AABW');

legend([p1 p2 p3 p4]);
legend('boxoff');
legend('location','southwest');

axis([1900 2100 -inf inf]);
xlabel('Time (years)');
ylabel('AMOC & AABW Anomaly (Sv)');
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) % this is where matlab puts the figure on your screen, and how large it is
ax = gca;
ax.FontSize = 16;


% -----= Calculate windowed correlation between specified circulation and
%        transect (will either be AMOC or AABW)
window_length = 25; % years for window
for i = 1:size(atl_profiles_mean_2000_ann,1)
    kk = 1;
    profile = (atl_profiles_mean_2000_ann(i,:))';
    for k = window_length:length(T)-window_length
        ranger = k-window_length+1:k+window_length-1;
        dummy_a = profile(ranger);
        dummy_b = circulation_select(ranger);
        
        window_corr(i,kk) = corr(dummy_a,dummy_b);
        T_corr(kk) = T(k);
        kk = kk+1;
    end
end

% -= Plot windowed correlation
figure; hold on;
for i = i_range
    plot(T(25:end-25),window_corr(i,:),'-','Color','k','LineWidth',1.25);
end

for i = i_range
    if i == i_range(1)
        plot(T(25:end-25),window_corr(i,:),'-','Color',profile_color,'LineWidth',1.25);
        p3 = plot(T(25:20:end-25),window_corr(i,1:20:end),'ko','MarkerSize',10,'MarkerFaceColor',profile_color);

    elseif i == i_range(end)
        plot(T(25:end-25),window_corr(i,:),'-','Color',profile_color,'LineWidth',1.25);
        p4 = plot(T(35:20:end-25),window_corr(i,10:20:end),'ks','MarkerSize',10,'MarkerFaceColor',profile_color,'DisplayName','Northernmost');
    end
end
axis([1900 2100 -0.2 1]);
ylabel('25-yr Windowed Corr (AMOC,Ar39pm)');
xlabel('Time (years)');
ax = gca;
ax.FontSize = 16;


%% Hovmöller
T_long = linspace(1765,2499,8820); % age of whole sim
lat_ranger_hov = i_range; % match windowed correlation
time_ranger_hov = 1623:4026; % 1623:4026 is 1900:2100

data_hov = atl_profiles_mean_2000_hov(lat_ranger_hov,time_ranger_hov); % rename data for ease

data_hov = data_hov';
for i = 1:size(data_hov,2)
    dummy = data_hov(:,i);
    dummy = smooth(dummy,12);
    data_hov(:,i) = dummy;
end

data_hov = data_hov';
y_inds_hov = y_inds(lat_ranger_hov);

% -----= Plot!
figure;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) % this is where matlab puts the figure on your screen, and how large it is
contourf(T_long(time_ranger_hov),y(y_inds_hov),100*data_hov,10);
clim([0 100]);
c = colorbar;
c.Label.String = '^{39}Ar_{pm} (%)';
colormap(brownteal);
ax = gca;
ax.YDir = 'normal';
ax.FontSize = 16;
ylabel('Latitude (^oN)');
xlabel('Time (years)');
