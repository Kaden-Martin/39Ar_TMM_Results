%% Processing and plotting script for Figure 2
%  Code Associated with the manuscript: 
%  "The fingerprint of reduced overturning circulation on 39Ar"
%   Martin et al., submitted to Geophysical Research Letters
% 
%  Written by Kaden Martin
%  Last updated: June 26th, 2026
%  Contact: kaden.martin@whoi.edu
%  
%  -----=
%  Code will calculate SSP simulation anomalies for either the year 2040 or
%  2100. It will also identify the maximum anomaly and depth of max
%  anomaly, and compare it with a user-defined threshold. In this case,
%  threshold is 10 39Arpm. 
%  -----=
%  Optional user input:
%       - year_select can be used to set oldest year to 2040 or 2100
%       

%% Prepare workspace and load data
clear; close all;

% -= User Input
year_select = '2040'; % '2040' or '2100'

% -= Load utilities
load('../Utilities/brownteal.mat'); 
load('../Utilities/redblue.mat'); 
load('../Utilities/RGB_Colors.mat');
load('../Utilities/coastlines.mat');

% -= Load Experiment Results
load('../Data/Ar39pm_SSP1_1980_2040_2100.mat','Ar39pm_SSP1_1980','Ar39pm_SSP1_2040');
Ar39pm_SSP1_exp = Ar39pm_SSP1_2040;
load('../Data/Ar39pm_SSP2_1980_2040_2100.mat','Ar39pm_SSP2_1980','Ar39pm_SSP2_2040');
Ar39pm_SSP2_exp = Ar39pm_SSP2_2040;
load('../Data/Ar39pm_SSP3_1980_2040_2100.mat','Ar39pm_SSP3_1980','Ar39pm_SSP3_2040');
Ar39pm_SSP3_exp = Ar39pm_SSP3_2040;
load('../Data/Ar39pm_SSP5_1980_2040_2100.mat','Ar39pm_SSP5_1980','Ar39pm_SSP5_2040');
Ar39pm_SSP5_exp = Ar39pm_SSP5_2040;
load('../Data/UVIC_Coordinates.mat');

if strcmp(year_select,'2100') == 1
    load('../Data/Ar39pm_SSP5_1980_2040_2100.mat','Ar39pm_SSP5_2100');
    Ar39pm_SSP5_exp = Ar39pm_SSP5_2100;
    load('../Data/Ar39pm_SSP3_1980_2040_2100.mat','Ar39pm_SSP3_2100');
    Ar39pm_SSP3_exp = Ar39pm_SSP3_2100;
    load('../Data/Ar39pm_SSP2_1980_2040_2100.mat','Ar39pm_SSP2_2100');
    Ar39pm_SSP2_exp = Ar39pm_SSP2_2100;
    load('../Data/Ar39pm_SSP1_1980_2040_2100.mat','Ar39pm_SSP1_2100');
    Ar39pm_SSP1_exp = Ar39pm_SSP1_2100;
end


%% Process Simulations
% -= SSP1
dAr39pm_SSP1_2040_anom = ((Ar39pm_SSP1_exp - Ar39pm_SSP1_1980)./Ar39pm_SSP1_1980)*100;
dAr39pm_SSP1_2040_anom_ann = mean(dAr39pm_SSP1_2040_anom,4);

% -= SSP2
dAr39pm_SSP2_2040_anom = ((Ar39pm_SSP2_exp - Ar39pm_SSP2_1980)./Ar39pm_SSP2_1980)*100;
dAr39pm_SSP2_2040_anom_ann = mean(dAr39pm_SSP2_2040_anom,4);

% -= SSP3
dAr39pm_SSP3_2040_anom = ((Ar39pm_SSP3_exp - Ar39pm_SSP3_1980)./Ar39pm_SSP3_1980)*100;
dAr39pm_SSP3_2040_anom_ann = mean(dAr39pm_SSP3_2040_anom,4);

% -= SSP5
dAr39pm_SSP5_2040_anom = ((Ar39pm_SSP5_exp - Ar39pm_SSP5_1980)./Ar39pm_SSP5_1980)*100;
dAr39pm_SSP5_2040_anom_ann = mean(dAr39pm_SSP5_2040_anom,4);


%% This calculates the depth of max anomaly, and value of max anomaly
% -= SSP1
for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = dAr39pm_SSP1_2040_anom_ann(xx,yy,:);
        if min(isnan(dummy)) == 0
            max_anom_ind(xx,yy) = find(abs(dummy) == max(abs(dummy)),1);
            max_anom_value(xx,yy) = dummy(:,:,max_anom_ind(xx,yy));
        else
            max_anom_ind(xx,yy) = NaN;
            max_anom_value(xx,yy) = NaN;
        end
    end
end

for i = 1:size(max_anom_ind,1)
    for j = 1:size(max_anom_ind,2)
        if ~isnan(max_anom_ind(i,j))
            max_anom_depth(i,j) = z(max_anom_ind(i,j));
        else
            max_anom_depth(i,j) = NaN;
        end
    end
end

max_anom_depth_SSP1 = max_anom_depth;
max_anom_value_SSP1 = max_anom_value;
clear max_anom_depth max_anom_value max_anom_ind;

% -= SSP2
for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = dAr39pm_SSP2_2040_anom_ann(xx,yy,:);
        if min(isnan(dummy)) == 0
            max_anom_ind(xx,yy) = find(abs(dummy) == max(abs(dummy)),1);
            max_anom_value(xx,yy) = dummy(:,:,max_anom_ind(xx,yy));
        else
            max_anom_ind(xx,yy) = NaN;
            max_anom_value(xx,yy) = NaN;
        end
    end
end

for i = 1:size(max_anom_ind,1)
    for j = 1:size(max_anom_ind,2)
        if ~isnan(max_anom_ind(i,j))
            max_anom_depth(i,j) = z(max_anom_ind(i,j));
        else
            max_anom_depth(i,j) = NaN;
        end
    end
end

max_anom_depth_SSP2 = max_anom_depth;
max_anom_value_SSP2 = max_anom_value;
clear max_anom_depth max_anom_value max_anom_ind;

% -= SSP3
for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = dAr39pm_SSP3_2040_anom_ann(xx,yy,:);
        if min(isnan(dummy)) == 0
            max_anom_ind(xx,yy) = find(abs(dummy) == max(abs(dummy)),1);
            max_anom_value(xx,yy) = dummy(:,:,max_anom_ind(xx,yy));
        else
            max_anom_ind(xx,yy) = NaN;
            max_anom_value(xx,yy) = NaN;
        end
    end
end

for i = 1:size(max_anom_ind,1)
    for j = 1:size(max_anom_ind,2)
        if ~isnan(max_anom_ind(i,j))
            max_anom_depth(i,j) = z(max_anom_ind(i,j));
        else
            max_anom_depth(i,j) = NaN;
        end
    end
end

max_anom_depth_ind_SSP3 = max_anom_ind;
max_anom_depth_SSP3 = max_anom_depth;
max_anom_value_SSP3 = max_anom_value;
clear max_anom_depth max_anom_value max_anom_ind;

% -= SSP5
for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = dAr39pm_SSP5_2040_anom_ann(xx,yy,:);
        if min(isnan(dummy)) == 0
            max_anom_ind(xx,yy) = find(abs(dummy) == max(abs(dummy)),1);
            max_anom_value(xx,yy) = dummy(:,:,max_anom_ind(xx,yy));
        else
            max_anom_ind(xx,yy) = NaN;
            max_anom_value(xx,yy) = NaN;
        end
    end
end

for i = 1:size(max_anom_ind,1)
    for j = 1:size(max_anom_ind,2)
        if ~isnan(max_anom_ind(i,j))
            max_anom_depth(i,j) = z(max_anom_ind(i,j));
        else
            max_anom_depth(i,j) = NaN;
        end
    end
end

max_anom_depth_SSP5 = max_anom_depth;
max_anom_value_SSP5 = max_anom_value;
clear max_anom_depth max_anom_value max_anom_ind;

% -= Find regions above a threshold. Used to identify the black contours in
%    figure 2a, b, d, and e
abs_threshold = 10;
for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        if max_anom_value_SSP1(xx,yy) < abs_threshold && max_anom_value_SSP1(xx,yy) > -1*abs_threshold
            max_anom_value_thresh(xx,yy) = 0;
            max_anom_thresh(xx,yy) = NaN;
        else
            max_anom_value_thresh(xx,yy) = abs(max_anom_value_SSP1(xx,yy));
            max_anom_thresh(xx,yy) = 1;
            if isnan(max_anom_value_SSP1(xx,yy))
                max_anom_thresh(xx,yy) = NaN;
            end
        end
    end
end

for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = squeeze(Ar39pm_SSP1_1980(xx,yy,:,1));
        if size(find(isnan(dummy),1),1) == 0
            deepest_depth(xx,yy) = 19;
        elseif size(find(isnan(dummy)),1) == 19
            deepest_depth(xx,yy) = NaN;
        else
            deepest_depth(xx,yy) = find(isnan(dummy),1)-1;
        end
    end
end

for xx = 1:size(x,1)
    for yy = 1:size(y,1)
        dummy = deepest_depth(xx,yy);
        if ~isnan(dummy)
            deepest_depth(xx,yy) = z(dummy);
        end
    end
end

%% Convert to Atlantic Projection and Plot
% -= Process and define utilities
redblue = flipud(redblue); 
blue = redblue(26:end,:);

% -= Convert to ATL
max_anom_value_SSP3_atl = max_anom_value_SSP3([51:end 1:50],:,:);
max_anom_depth_SSP3_atl = max_anom_depth_SSP3([51:end 1:50],:,:);
max_anom_value_thresh_atl = max_anom_value_thresh([51:end 1:50],:,:);

dummy = (max_anom_value_SSP5-max_anom_value_SSP1);
max_anom_diff_atl = dummy([51:end 1:50],:,:);
x_atl = linspace(-180,180,100);

% -----= Plot
% -= User Input
anom_plot_range = 30;
% -= SSP3 39Ar Anomaly
figure;
hold on;
imagesc(x_atl,y,max_anom_value_SSP3_atl(:,:)','AlphaData',~isnan(max_anom_value_SSP3_atl(:,:)'),[-1*anom_plot_range anom_plot_range]);
contour(x_atl,y,max_anom_value_thresh_atl(:,:)',[10 10],'k-','LineWidth',3);
plot(coastlon,coastlat,'k-','LineWidth',1.5);
colormap(brownteal);
c = colorbar;
c.Label.String = 'Maximum ^{39}Ar_{pm} Anomaly';
axis([-180 180 y(1) y(end)]);
title(strcat('SSP3:',{' '},year_select,'-1980'));
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
ax = gca;
ax.FontSize = 18;

% -= SSP3 39Ar Anomaly Depth
figure;
hold on;
imagesc(x_atl,y,(1/1)*max_anom_depth_SSP3_atl(:,:)','AlphaData',~isnan(max_anom_depth_SSP3_atl(:,:)'),[z(1) z(19)]);
contour(x_atl,y,max_anom_value_thresh_atl(:,:)',[10 10],'k-','LineWidth',3);
plot(coastlon,coastlat,'k-','LineWidth',1.5);
colormap(blue);
c = colorbar;
c.Label.String = 'Depth of Maximum ^{39}Ar_{pm} Anomaly (m)';
c.Direction = 'reverse';
axis([-180 180 y(1) y(end)]);
title(strcat('SSP3:',{' '},year_select,'-1980'));
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
ax = gca;
ax.FontSize = 18;

% -= SSP5 - SSP1 39Ar Anomaly
figure;
hold on;
imagesc(x_atl,y,max_anom_diff_atl','AlphaData',~isnan(max_anom_diff_atl(:,:)'),[-15 15]);
plot(coastlon,coastlat,'k-','LineWidth',1.5);
colormap(brownteal);
c = colorbar;
c.Label.String = '\DeltaMax ^{39}Ar_{pm} Anomaly';
axis([-180 180 y(1) y(end)]);
title('SSP5-SSP1 \DeltaMax Anom.');
ylabel('Latitude (^oN)');
xlabel('Longitude (^oE)');
ax = gca;
ax.FontSize = 18;
