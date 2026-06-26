%% Processing and plotting script for Figure 1
%  Code Associated with the manuscript: 
%  "The fingerprint of reduced overturning circulation on 39Ar"
%   Martin et al., submitted to Geophysical Research Letters
% 
%  Written by Kaden Martin
%  Last updated: June 26th, 2026
%  Contact: kaden.martin@whoi.edu
%
%  -----=
%  Code will analyze pre-industrial simulations and compare with data. Will
%  plot the 39Arpm value at various depth levels, currently at: surface,
%  2km, and 4.1km. 
%  -----=

%% Prepare workspace and load data
clear; close all;

% -= User Input for plots
c_min = 0;
c_max = 1;

% -= Plotting utilities
load('../Utilities/coastlines.mat');
load('../Utilities/brownteal.mat');
load('../Utilities/RGB_Colors.mat');

% -----= Load data
% -= Model Data
load('../Data/Ar39pm_PIC_monthly.mat');
load('../Data/UVIC_Coordinates.mat');
% -= Measured Data
load('../Data/Ar39_Data.mat'); % data(lat, lon (E), depth, 39Arpm, sigma)

%% Process model output
% lon = linspace(0,360,100);
% lat = linspace(-90,90,100);
% level = (1:1:19)';

lon = x;
lat = y;
level = z;

Ar39pm_ann = mean(Ar39pm,4);

% -= Convert to Atlantic Projection
for i = 1:length(level)
    Ar39pm_ann_atl(:,:,i) = Ar39pm_ann([51:end 1:50],:,i);
end
x_atl = 180-x([51:end 1:50]);


%% Model-data comparison for PIC

% -= Convert to 0-360 degrees E if needed
for i = 1:length(ar39_data)
    if ar39_data(i,2) < 0
        ar39_data(i,2) = ar39_data(i,2)+360;
    end
end

jj = 1;
% -----= Loop to grab a data point, identify nearest model point, and
%        calculate difference
for i = 1:size(ar39_data,1) % loop over all data points
    dummy = ar39_data(i,:); % grab your data of interest
    dummy_z_index = find(min(abs(dummy(1,3)-level)) == abs(dummy(1,3)-level));
    dummy_lat_index = find(min(abs(dummy(1,1)-lat)) == abs(dummy(1,1)-lat));
    dummy_lon_index = find(min(abs(dummy(1,2)-lon)) == abs(dummy(1,2)-lon));

    if length(dummy_z_index) > 1
        dummy_z_index = dummy_z_index(1);
    end
    if length(dummy_lat_index) > 1
        dummy_lat_index = dummy_lat_index(1);
    end
    if length(dummy_lon_index) > 1
        dummy_lon_index = dummy_lon_index(1);
    end
    ar39_data(i,6) = Ar39pm_ann(dummy_lon_index,dummy_lat_index,dummy_z_index);
end

% -= Check if a data point is in the Atlantic, Pacific, or Indian basin
atl_count = 0; 
pac_count = 0;
ind_count = 0;
for i = 1:size(ar39_data,1)
    if ar39_data(i,2) > 275 && ar39_data(i,2) < 360
        atl_count = atl_count+1;
    elseif ar39_data(i,2) > 0 && ar39_data(i,2) < 60 && ar39_data(i,1) > 60
        atl_count = atl_count+1;
    elseif ar39_data(i,2) > 0 && ar39_data(i,2) < 6 && ar39_data(i,1) < 0
        atl_count = atl_count+1;
    elseif ar39_data(i,1) < -38 && ar39_data(i,2) > 0 && ar39_data(i,2) < 250
        ind_count = ind_count+1;
    elseif ar39_data(i,2) > 150 && ar39_data(i,2) < 250
        pac_count = pac_count+1;
    end
end

% -= Convert processed data to atlantic projection
ar39_data_atl = ar39_data;
for i = 1:size(ar39_data_atl,1)
    if ar39_data_atl(i,2) > 180
        ar39_data_atl(i,2) = ar39_data_atl(i,2) - 360;
    end
end

% -----= Plot Results
% -= Cross Plot of model data vs measured data, seperated by basin
figure; hold on;
kk = 1;
for i = 1:size(ar39_data,1)
    if ar39_data(i,2) > 275 && ar39_data(i,2) < 360
        p1 = errorbar(ar39_data(i,4),ar39_data(i,6)*100,ar39_data(i,5),'horizontal','ko','MarkerFaceColor','r','MarkerSize',8,'DisplayName','Atlantic');
        ar39_atl(kk,:) = ar39_data(i,:); kk = kk+1; 
    elseif ar39_data(i,2) > 0 && ar39_data(i,2) < 60 && ar39_data(i,1) > 60
        errorbar(ar39_data(i,4),ar39_data(i,6)*100,ar39_data(i,5),'horizontal','ko','MarkerFaceColor','r','MarkerSize',8);
        ar39_atl(kk,:) = ar39_data(i,:); kk = kk+1; 
    elseif ar39_data(i,2) > 0 && ar39_data(i,2) < 6 && ar39_data(i,1) < 0
        errorbar(ar39_data(i,4),ar39_data(i,6)*100,ar39_data(i,5),'horizontal','ko','MarkerFaceColor','r','MarkerSize',8);
        ar39_atl(kk,:) = ar39_data(i,:); kk = kk+1; 
    elseif ar39_data(i,1) < -38 && ar39_data(i,2) > 0 && ar39_data(i,2) < 250
        p2 = errorbar(ar39_data(i,4),ar39_data(i,6)*100,ar39_data(i,5),'horizontal','ko','MarkerFaceColor','g','MarkerSize',8,'DisplayName','Indian');
    elseif ar39_data(i,2) > 150 && ar39_data(i,2) < 250
        p3 = errorbar(ar39_data(i,4),ar39_data(i,6)*100,ar39_data(i,5),'horizontal','ko','MarkerFaceColor','b','MarkerSize',8,'DisplayName','Pacific');
    end
end

plot([0 1000],[0 1000],'k-','LineWidth',1.5);
axis([0 110 0 110]);
xlabel('Measured ^{39}Ar_{pm}');
ylabel('Modeled ^{39}Ar_{pm}');
ax = gca;
ax.FontSize = 18;
legend([p1 p3 p2]);
legend('location','northwest');
legend('boxoff');


%% Calculate Stats Associated with model-data comparison
k = 1;
for i = 1:size(ar39_data,1)
    if ~isnan(ar39_data(i,6))
        dummy_ar39(k,:) = ar39_data(i,:);
        k = k+1;
    end
end

[p,S] = polyfit(dummy_ar39(:,4),dummy_ar39(:,6),1);

dummy_ar39(:,7) = dummy_ar39(:,4) - 100*dummy_ar39(:,6);
dummy_ar39(:,8) = dummy_ar39(:,7).*dummy_ar39(:,7);

model_data_rmse = sqrt(sum(dummy_ar39(:,8))/size(dummy_ar39,1));
model_data_r_square = S.rsquared;

%% Plot results
% -----= Surface
level_select = 1;
figure; hold on;
imagesc(lon-180,lat,100*Ar39pm_ann_atl(:,:,level_select)','AlphaData',~isnan(Ar39pm_ann_atl(:,:,level_select)'),[100*c_min 100*c_max]);
plot(coastlon,coastlat,'w-','LineWidth',1.5);
axis([-180 180 -90 90]);
set(gca,'Color','k');
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
title('Surfacec');
ax = gca;
ax.FontSize = 18;
colormap(brownteal)
colorbar;
c = colorbar;
c.Label.String  = '^{39}Ar_{pm}';

% -= Plot data for reference
plot(ar39_data_atl(:,2),ar39_data_atl(:,1),'wo','MarkerSize',8.5,'MarkerFaceColor',steel_blue);


% -----= Intermediate
level_select = 11;
figure; hold on;
imagesc(lon-180,lat,100*Ar39pm_ann_atl(:,:,level_select)','AlphaData',~isnan(Ar39pm_ann_atl(:,:,level_select)'),[100*c_min 100*c_max]);
plot(coastlon,coastlat,'w-','LineWidth',1.5);
axis([-180 180 -90 90]);
set(gca,'Color','k');
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
title('Intermediate Depth, 2000m');
ax = gca;
ax.FontSize = 18;
colormap(brownteal)
colorbar;
c = colorbar;
c.Label.String  = '^{39}Ar_{pm}';


% -----= Abyssal
level_select = 16;
figure; hold on;
imagesc(lon-180,lat,100*Ar39pm_ann_atl(:,:,level_select)','AlphaData',~isnan(Ar39pm_ann_atl(:,:,level_select)'),[100*c_min 100*c_max]);
plot(coastlon,coastlat,'w-','LineWidth',1.5);
axis([-180 180 -90 90]);
set(gca,'Color','k');
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
title('Abyssal Depth, 4100m');
ax = gca;
ax.FontSize = 18;
colormap(brownteal)
colorbar;
c = colorbar;
c.Label.String  = '^{39}Ar_{pm}';
