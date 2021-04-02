% Define participants and groups they belong to
albinism={['ALB1'];['ALB2'];['ALB3'];['ALB4'];['ALB5'];['ALB6'];['ALB7'];['ALB8'];['ALB9']};
controls={['CON1'];['CON2'];['CON3'];['CON4'];['CON5'];['CON6'];['CON7'];['CON8']};
achiasma={['ACH1']};
hypoplasia={['CHP1']};

albinism = reshape(albinism,[1 9]);
controls = reshape(controls,[1 8]);
achiasma = reshape(achiasma,[1 1]);
hypoplasia = reshape(hypoplasia,[1 1]);

% Create a table storing all data
subjects=dir('Data/');
subjects= cellfun(@(x){x(1:4)}, {subjects(3:21).name});

% Table with the raw data
movement_table = array2table(nan(276,size(subjects,2)));
movement_table.Properties.VariableNames = subjects;

% Table for means 
mean_table = array2table(nan(2,size(subjects,2)));
mean_table.Properties.VariableNames = subjects;
mean_table.Properties.RowNames={'mean', 'std'};

% Fill the tables - the one with raw data and the one with means and stds
for subj = subjects
     tmp = load(strcat('Data/',subj{:},'_eddy_movement_rms'));
     movement_table.(subj{:}) = tmp(:,1);
     mean_table.(subj{:})('mean') = mean(tmp(:,1));
     mean_table.(subj{:})('std') = std(tmp(:,1));
end
 
% Load the file describing bvals
bvecs = load('Data/gradient_table.bval');

% Prepare custom color map
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Figure properties (font sizes, markers sizes etc.)
markers_size_plot=50;
markers_size_scatter=800;
line_opacity=0.4;
line_width=2;

font_size = 40;
font_size_ticks=30;
%% Plot results
figure('units','normalized','outerposition',[0 0 1 1]);

% 1st series
% 1st plot
subplot(1,6,1:5)
hold on 

% Find b0 indices
b0_indices = find(~bvecs);
b0_indices = [b0_indices 138+b0_indices];

% Plot lines
plot(movement_table{:, controls},'-','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',[custom_rgb_map(5,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
plot(movement_table{:, albinism},'-','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',[custom_rgb_map(3,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
plot(movement_table{:, achiasma},'-','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',[custom_rgb_map(2,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);
plot(movement_table{:, hypoplasia},'-','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',[custom_rgb_map(1,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot);

% Add markers on top
for i=1:length(controls)
    scatter(b0_indices, movement_table{b0_indices,controls{i}}, markers_size_scatter, 'ko', 'MarkerFaceColor', custom_rgb_map(5,:), 'LineWidth',line_width)
end
for i=1:length(albinism)
    scatter(b0_indices, movement_table{b0_indices,albinism{i}}, markers_size_scatter, 'ks', 'MarkerFaceColor', custom_rgb_map(3,:), 'LineWidth',line_width)
end
for i=1:length(achiasma)
    scatter(b0_indices, movement_table{b0_indices,achiasma{i}}, markers_size_scatter, 'k^', 'MarkerFaceColor', custom_rgb_map(2,:), 'LineWidth',line_width)
end
for i=1:length(hypoplasia)
    scatter(b0_indices, movement_table{b0_indices,hypoplasia{i}}, markers_size_scatter, 'kv', 'MarkerFaceColor', custom_rgb_map(1,:), 'LineWidth',line_width)
end

% X label
xlim([0 278]);
% Remove subsequent values from ticks
b0_indices(2)=[];
b0_indices(9)=[];
b0_indices(10)=[];

set(gca,'XTick', b0_indices, 'FontSize',font_size_ticks);

% Y label
ylim([-0.025 3])
set(gca,'YTick', [0 1.5 3], 'FontSize',font_size_ticks);

% Set font size
xlabel('Volume', 'FontSize', font_size);
ylabel('Movement RMS [mm]', 'FontSize', font_size);

% Adjust ticks
set(gca,'TickDir','out'); 

% Create dummy lines to be shown in the legend
h4 = plot(nan,'-o','MarkerIndices', [] , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',[custom_rgb_map(5,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
h3 = plot(nan,'-s','MarkerIndices', [] , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',[custom_rgb_map(3,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
h2 = plot(nan,'-^','MarkerIndices', [] , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',[custom_rgb_map(2,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
h1 = plot(nan,'-v','MarkerIndices', [] , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',[custom_rgb_map(1,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);

% Finally, set proper margins
ax = gca;
ax.Position=[0.07 0.1 0.7 0.88];

% Legend
%legend([h1(1),h2(1),h3(1), h4(1)],'Chiasma Hypoplasia','Achiasma','Albinism', 'Controls', 'b0 volume', 'FontSize', font_size_ticks, 'Location','northwest')

% Mean plot
subplot(1,6,6);

mean_con = mean(movement_table{1:276, controls});
mean_alb = mean(movement_table{1:276, albinism});
mean_ach = mean(movement_table{1:276, achiasma});
mean_hyp = mean(movement_table{1:276, hypoplasia});

points = [mean_alb, mean_con];
divide=[ones(1,size(albinism,2)),2*ones(1,size(controls,2))];
 
hold on
fig1=scatter(ones(1,size(albinism,2)),mean_alb,markers_size_scatter,'ks', 'LineWidth',line_width);
set(fig1(1), 'MarkerFaceColor', custom_rgb_map(3,:));
hold on
fig2=scatter(2*ones(1,size(controls,2)),mean_con,markers_size_scatter,'ko', 'LineWidth',line_width);
set(fig2(1), 'MarkerFaceColor', custom_rgb_map(5,:));
hold on
fig3=scatter(3*ones(1,size(achiasma,2)),mean_ach,markers_size_scatter,'k^', 'LineWidth',line_width);
set(fig3(1), 'MarkerFaceColor', custom_rgb_map(2,:));
fig4=scatter(4*ones(1,size(hypoplasia,2)),mean_hyp,markers_size_scatter,'kv', 'LineWidth',line_width);
set(fig4(1), 'MarkerFaceColor', custom_rgb_map(1,:));

ylim([0 3]);
set(gca,'YTick', [0 1.5 3], 'FontSize',font_size_ticks);
set(gca,'YTickLabel',[]);
ylabel('')

xlim([0 5]);
              
set(gca,'XTick', [1:4],'xticklabel' ,{'ALB' 'CON' 'ACH' 'CHP'}, 'FontSize',font_size_ticks);
xlabel('Group', 'FontSize', font_size);

ylabel('Mean Movement RMS [mm]', 'FontSize', font_size);

% Finally, set proper margins
ax = gca;
ax.Position=[0.815 0.1 0.18 0.88];

% Ticks out
set(gca,'TickDir','out'); 

% Save the image
print(gcf,'Fig5a_Motion','-djpeg','-r500');    
close

%% Test for equality

[H,P]=ttest2(mean_con, mean_alb)