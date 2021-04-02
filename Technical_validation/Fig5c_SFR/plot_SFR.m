% Define participants and groups they belong to
albinism={['ALB1'];['ALB2'];['ALB3'];['ALB4'];['ALB5'];['ALB6'];['ALB7'];['ALB8'];['ALB9']};
controls={['CON1'];['CON2'];['CON3'];['CON4'];['CON5'];['CON6'];['CON7'];['CON8']};
achiasma={['ACH1']};
hypoplasia={['CHP1']};

data_folder='Data';

subjects=dir(strcat(data_folder,'/*txt'));
subjects = cellfun(@(x){x(1:4)}, {subjects(1:end).name});

% Create table to store all the sh coefficients
sh_table = array2table(nan(4,19));
sh_table.Properties.VariableNames = subjects;

% Load sh coefficients into the table
for i=1:size(subjects,2)
    
    subj=subjects{i};
    %tmp=load(strcat(data_folder,'/',subj,'_SFR.txt'));
    
    fid = fopen(strcat(data_folder,'/',subj,'_SFR.txt'),'rt');
    indata = textscan(fid, '%f', 'HeaderLines',2);
    fclose(fid);
    tmp = indata{1};

    sh_table{1,subj}=tmp(1);
    sh_table{2,subj}=tmp(2);
    sh_table{3,subj}=tmp(3);
    sh_table{4,subj}=tmp(4);   
end

% Prepare custom color map
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Figure properties (font sizes, markers sizes etc.)
markers_size_plot=25;
markers_size_scatter=800;
line_opacity=0.4;
line_width=2;

font_size = 40;
font_size_ticks=30;

%% Plot
figure('units','normalized','outerposition',[0 0 1 1]);
hold on

% Add lines
for k=1:size(subjects,2)  

    if subjects{k}(1:4)=='ACH1'
        plot([1,2,3,4], sh_table{:,k},'-','Color',[custom_rgb_map(1,:),line_opacity],'LineWidth',line_width);
    elseif subjects{k}(1:4)=='ACH2'
         plot([1,2,3,4], sh_table{:,k},'-','Color',[custom_rgb_map(2,:),line_opacity],'LineWidth',line_width);
     elseif subjects{k}(1:3)=='ALB'
         plot([1,2,3,4], sh_table{:,k},'-','Color',[custom_rgb_map(3,:),line_opacity],'LineWidth',line_width); 
     elseif subjects{k}(1:3)=='CON'
         plot([1,2,3,4], sh_table{:,k},'-','Color',[custom_rgb_map(5,:),line_opacity],'LineWidth',line_width); 
    end   

end

for i=1:size(sh_table,1)

    h1=scatter(i*ones(1,8), sh_table{i,controls}, markers_size_scatter, 'ko', 'MarkerFaceColor', custom_rgb_map(5,:), 'LineWidth',line_width);
    h2=scatter(i*ones(1,9), sh_table{i,albinism}, markers_size_scatter, 'ks', 'MarkerFaceColor', custom_rgb_map(3,:), 'LineWidth',line_width);
    h3=scatter(i*ones(1,1), sh_table{i,achiasma}, markers_size_scatter, 'k^', 'MarkerFaceColor', custom_rgb_map(2,:), 'LineWidth',line_width);
    h4=scatter(i*ones(1,1), sh_table{i,hypoplasia}, markers_size_scatter, 'kv', 'MarkerFaceColor', custom_rgb_map(1,:), 'LineWidth',line_width);
    
end

% Set labels
set(gca,'XTick', [1:4],'xticklabel' ,{'order 0' ' order 2' 'order 4','order 6'}, 'FontSize', font_size_ticks);
xlabel('Zero phase SH coefficients of SFR', 'FontSize', font_size);
ylabel('Value', 'FontSize', font_size);

% Horizontal line
h4 = yline(0, '--');
xlim([0.95 4.05]);

% Create dummy lines to be shown in the legend
h4 = plot(nan,'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',[custom_rgb_map(5,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
h3 = plot(nan,'s', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',[custom_rgb_map(3,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
h2 = plot(nan,'^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',[custom_rgb_map(2,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
h1 = plot(nan,'v', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',[custom_rgb_map(1,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);

% Legend
%legend([h4,h3,h2,h1],'Chiasma Hypoplasia','Achiasma','Albinism','Control', 'FontSize', font_size-6','Location','northeast')
    
% Ticks out
set(gca,'TickDir','out'); 

% Box off
box off

pbaspect([1 1 1])

print(gcf,'Fig5c_SFR','-djpeg','-r400');    
close
