%% Processing and plotting script for Figure 3
%  Code Associated with the manuscript: 
%  "The fingerprint of reduced overturning circulation on 39Ar"
%   Martin et al., submitted to Geophysical Research Letters
% 
%  Written by Kaden Martin
%  Last updated: June 26th, 2026
%  Contact: kaden.martin@whoi.edu
% 
%  -----=
%  This code handles southern sourced water fraction in the
%  zonal Atlantic. Source regions are included in "zonal_bands.m" in the
%  data folder. Also calculates ideal mean age in the
%  zonal Atlantic. 
%  -----=

%% SOUTHERN SOURCED WATER FRACTION ---------------------------------------=
%% Prepare workspace and load data
clear; close all;

% -= Load model data
load('../Data/SSFW_Data_lite.mat');
load('../Data/UVIC_Coordinates.mat');

load('../Utilities/RGB_Colors.mat');


%% -----= Southern Sourced Water Fraction - Zonal Atlantic

% % -----=
% % -= If using the full data file from Zenodo, uncomment the following
% load('../Data/Zonal_water_ventilation_summary_ssp5_8.5.mat');
% T = Frac{2}.T; % time associated with each slice
% zonal_atl = Frac{2}.tr_zonal_atl; % extract zonal atlantic

% zonal_atl_1980 = squeeze(zonal_atl(:,:,44,:));
% zonal_atl_2040 = squeeze(zonal_atl(:,:,56,:));
% zonal_atl_anom = zonal_atl_2040-zonal_atl_1980;
% 
% zonal_atl_2040_SH = sum(zonal_atl_2040(:,:,[1 2 3 4]),3); % 2040 southern fraction
% zonal_atl_1980_SH = sum(zonal_atl_1980(:,:,[1 2 3 4]),3); % 1980 southern fraction
% zonal_atl_anom_SH = 100*(zonal_atl_2040_SH - zonal_atl_1980_SH);% southern fraction anomaly
% % -----=

% -= Plot SSWF Anomaly
figure; hold on;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) % this is where matlab puts the figure on your screen, and how large it is
imagesc(y,z,zonal_atl_anom_SH','AlphaData',~isnan(zonal_atl_anom_SH'),[-10 10]);
colormap(colormapper([255 215 0]/255,[],[139 0 139]/255,'divergent'));

colorbar;
c = colorbar;
c.Label.String  = 'Ventilation Fraction Anomaly (%)';
ylabel('Depth (m)');
xlabel('Latitude (^oN)');
title('SSP5: 2040-1980 Southern-sourced Water Anomaly')
ax = gca;
ax.YDir = 'reverse';
set(ax,'Color','k');
ax.FontSize = 16;
axis([y(1) y(end) z(1) z(end)]);

% -= Plot 1980 SSWF for reference
figure; hold on;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) 
imagesc(y,z,100*zonal_atl_1980_SH','AlphaData',~isnan(zonal_atl_1980_SH'),[0 100]);
colormap(colormapper([255 239 175]/255*1,[255 215 0]/255,[139 0 139]/255,'three')); % purple/yellow
colorbar;
c = colorbar;
c.Label.String  = 'Ventilation Fraction Anomaly (%)';

ylabel('Depth (m)');
xlabel('Latitude (^oN)');
title('SSP5: 1980 Southern-sourced Water Fraction')
ax = gca;
ax.YDir = 'reverse';
set(ax,'Color','k');
ax.FontSize = 16;
axis([y(1) y(end) z(1) z(end)]);

% -= Stats
zonal_atl_anom_SH_core = reshape(zonal_atl_anom_SH(74:79,15:16),[],1);
zonal_atl_anom_SH_core_avg = mean(zonal_atl_anom_SH_core,'all');
zonal_atl_anom_SH_core_std = std(zonal_atl_anom_SH_core);




%% IDEAL MEAN AGE --------------------------------------------------------=
%% Load data
% -= Load model data
load('../Data/IdealAge_Data_lite.mat');
% -= Load utilites
load('../Utilities/RGB_Colors.mat');

%% Evaluate ideal mean age and 2040-1980 anomaly
% -----=
% % -= If using the full data file from Zenodo, uncomment the following
% % -= Calculate baselines and anomalies
% load('../Data/IdealAge_SSP.mat');
% zonal_atl = squeeze(Age{5,1}.age_zonal(:,:,:,1));
% zonal_atl_1980 = zonal_atl(:,:,216);
% zonal_atl_2040 = zonal_atl(:,:,276);
% zonal_atl_anom = zonal_atl_2040-zonal_atl_1980;
% -----=

%% Plotting
% -= Plot 2040-1980 ideal mean age anomaly
figure; hold on;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) 
imagesc(y,z,zonal_atl_anom','AlphaData',~isnan(zonal_atl_anom'),[0 150]);
colormap(colormapper([1 1 1],[30,144,255]/255,[0 0 1],'three'));
colorbar;
c = colorbar;
c.Label.String  = 'Ideal Age Anomaly (years)';

ylabel('Depth (m)');
xlabel('Latitude (^oN)');
title('Atlantic Ideal Age Anomaly');
ax = gca;
ax.YDir = 'reverse';
set(ax,'Color','k');
ax.FontSize = 16;
axis([-90 90 z(1) z(end)]);

% -= Atlantic 1980
figure; hold on;
set(gcf,'PaperUnits','centimeters')
xSize = 14;
ySize = 9;
set(gcf,'Position',[50 50 xSize*45 ySize*45]) % this is where matlab puts the figure on your screen, and how large it is
imagesc(y,z,zonal_atl_1980','AlphaData',~isnan(zonal_atl_anom'),[0 500]);
colormap(colormapper([175 238 238]/255,[30,144,255]/255,[75 0 130]/255,'three'));
colorbar;
c = colorbar;
c.Label.String  = 'Ideal Age (years)';
ylabel('Depth (m)');
xlabel('Latitude (^oN)');
title('1980 Atlantic Ideal Age');
ax = gca;
ax.YDir = 'reverse';
set(ax,'Color','k');
ax.FontSize = 16;
axis([-90 90 z(1) z(end)]);
