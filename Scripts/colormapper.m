function [colormap] = colormapper(color_first,color_middle,color_second,type)
%% Colormap Maker
% Written by Kaden Martin - kaden.martin@whoi.edu, circa 2026
% a simple function to make unique color maps

% This will make an evenly spaced colormap between color_first and
% color_second.
% There are two types:
% 'two' - the middle of the colormap will be a blend of the two colors
% 'three' - the middle of the colormap will be a third color
% 'divergent' - the middle of the colormap will be white

%%

if strcmp(type,'two')
    xq = (1:1:51)';
    x = [1; 51];
    y = [color_first; color_second];
    yq = interp1(x,y,xq);
    colormap = yq;

elseif strcmp(type,'three')
    xq = (1:1:51)';
    x = [1; 26; 51];
    y = [color_first; color_middle; color_second];
    yq = interp1(x,y,xq);
    colormap = yq;

elseif strcmp(type,'divergent')
    xq = (1:1:51)';
    x = [1; 26; 51];
    y = [color_first; 1 1 1; color_second];
    yq = interp1(x,y,xq);
    colormap = yq;
end