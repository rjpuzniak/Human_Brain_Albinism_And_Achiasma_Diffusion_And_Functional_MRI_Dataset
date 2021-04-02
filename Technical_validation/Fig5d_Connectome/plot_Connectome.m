% Load the data for known repositories
fname = 'Data/datasets_info.json'; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
repo_data = jsondecode(str);

% Initialize the structure
groups={'Control','Albinism','Achiasma','Chiasma Hypoplasia'};

for i=1:length(groups)
    ovgu_data(i).name=groups{i};
    ovgu_data(i).x=[];
    ovgu_data(i).y=[];
end

% Custom color maps
custom_map=[100 143 255; 120 94 240; 220 38 127; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Load the data for all of the OVGU subjects
dir_info = dir('Data/');

for j=3:(length(dir_info)-3)
    
    filename=strcat('Data/',dir_info(j).name);
    
    fid = fopen(filename); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    data = jsondecode(str);
    
    switch filename(6:8)
        case 'CON'
            ovgu_data(1).x = [ovgu_data(1).x data.life.rmse];
            ovgu_data(1).y = [ovgu_data(1).y data.life.non0_tracks];
        case 'ALB'
            ovgu_data(2).x = [ovgu_data(2).x data.life.rmse];
            ovgu_data(2).y = [ovgu_data(2).y data.life.non0_tracks];
        case 'ACH'
            ovgu_data(3).x = [ovgu_data(3).x data.life.rmse];
            ovgu_data(3).y = [ovgu_data(3).y data.life.non0_tracks]; 
        case 'CHP'
            ovgu_data(4).x = [ovgu_data(4).x data.life.rmse];
            ovgu_data(4).y = [ovgu_data(4).y data.life.non0_tracks];            
    end
end

% Figure properties (font sizes, markers sizes etc.)
markers_size_plot=25;
markers_size_scatter=800;
line_opacity=0.4;
line_width=2;

font_size = 40;
font_size_ticks=30;

%% Plot

figure('units','normalized','outerposition',[0 0 1 1]);

% Plot  repo data
for i=1:length(repo_data.data)    
    s = scatter(repo_data.data(i).x, repo_data.data(i).y, markers_size_scatter ,'filled', 's', 'MarkerFaceAlpha', 0.25, 'MarkerEdgeColor', 'black', 'MarkerEdgeAlpha', 0.5);
    hold on;
end

% Plot OVGU data
scatter(ovgu_data(1).x, ovgu_data(1).y,  markers_size_scatter ,'filled', 'o', 'MarkerFaceAlpha', 1.0, 'MarkerEdgeColor', 'black', 'MarkerEdgeAlpha', 1.0, 'MarkerFaceColor', custom_rgb_map(4,:), 'LineWidth', 2)
scatter(ovgu_data(2).x, ovgu_data(2).y,  markers_size_scatter ,'filled', 's', 'MarkerFaceAlpha', 1.0, 'MarkerEdgeColor', 'black', 'MarkerEdgeAlpha', 1.0, 'MarkerFaceColor', custom_rgb_map(3,:), 'LineWidth', 2)
scatter(ovgu_data(3).x, ovgu_data(3).y,  markers_size_scatter ,'filled', '^', 'MarkerFaceAlpha', 1.0, 'MarkerEdgeColor', 'black', 'MarkerEdgeAlpha', 1.0, 'MarkerFaceColor', custom_rgb_map(2,:), 'LineWidth', 2)
scatter(ovgu_data(4).x, ovgu_data(4).y,  markers_size_scatter ,'filled', 'v', 'MarkerFaceAlpha', 1.0, 'MarkerEdgeColor', 'black', 'MarkerEdgeAlpha', 1.0, 'MarkerFaceColor', custom_rgb_map(1,:), 'LineWidth', 2)

% Add legend
hLegend = legend(repo_data.data.name);

hXLabel = xlabel('Connectome RMSE');
hYLabel = ylabel('Fascicles Number');

% Adjust font
set(gca, 'FontName', 'Helvetica', 'FontSize', font_size_ticks)
set([hXLabel, hYLabel, hLegend],'FontSize', font_size)
set([hLegend], 'FontSize', font_size_ticks-5)
set([hXLabel, hYLabel], 'FontSize', font_size)

ax = gca
set(ax,'TickDir','out'); 
ax.Position=[0.08 0.11 0.9 0.85];
% Save the file
print(gcf, 'Fig5d_Connectome.jpg','-djpeg','-r500')
close
