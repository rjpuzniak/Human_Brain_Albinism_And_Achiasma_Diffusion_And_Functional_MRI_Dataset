% Define relevant folders
main_folder='/home/rjp/1_OVGU/3_Data_publication/1_Motion_estimate';
data_folder='/home/rjp/1_OVGU/3_Data_publication/1_Motion_estimate/Data';

% Define participants and groups they belong to
albinism={['ALB1'];['ALB2'];['ALB3'];['ALB4'];['ALB5'];['ALB6'];['ALB7'];['ALB8'];['ALB9']};
controls={['CON1'];['CON2'];['CON3'];['CON4'];['CON5'];['CON6'];['CON7'];['CON8']};
achiasma={['ACH1']};
hypoplasia={['CHP1']};

albinism = reshape(albinism,[1 9]);
controls = reshape(controls,[1 8]);
achiasma = reshape(achiasma,[1 1]);
hypoplasia = reshape(hypoplasia,[1 1]);

subjects=dir(data_folder);
subjects={subjects(3:end).name};

% Create a table storing all data
movement_table = array2table(nan(276,19));
movement_table.Properties.VariableNames = subjects;

% Table for means 
mean_table = array2table(nan(2,19));
mean_table.Properties.VariableNames = subjects;
mean_table.Properties.RowNames={'mean', 'std'};

% Fill the tables - the one with raw data and the one with means and stds
for subj = subjects
     tmp = load(strcat(data_folder,'/',subj{:},'/eddy_movement_rms'));
     movement_table.(subj{:}) = tmp(:,1);
     mean_table.(subj{:})('mean') = mean(tmp(:,1));
     mean_table.(subj{:})('std') = std(tmp(:,1));
end
 
% Load the file describing bvals
bvecs = load(strcat(main_folder,'/ep2ddiff137free15mmisob1600TE64p3APs006a001.bval'));

% Prepare custom color map
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

font_size = 20

% Plot results
figure('units','normalized','outerposition',[0 0 1 1]);

% 1st series
% 1st plot
subplot(2,4,1:3)
hold on 

% Find b0 indices
b0_indices = find(~bvecs)

% Plot lines
h1 = plot(movement_table{1:138, hypoplasia},'-v','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',custom_rgb_map(1,:), 'LineWidth',1.25, 'MarkerSize', 12);
h2 = plot(movement_table{1:138, achiasma},'-^','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',custom_rgb_map(2,:), 'LineWidth',1.25, 'MarkerSize', 12);
h3 = plot(movement_table{1:138, albinism},'-s','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',custom_rgb_map(3,:), 'LineWidth',1.25, 'MarkerSize', 12);
h4 = plot(movement_table{1:138, controls},'-o','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',custom_rgb_map(5,:), 'LineWidth',1.25, 'MarkerSize', 12);

%h2 = plot(movement_table{1:138, achiasma},'Color',custom_rgb_map(2,:), 'LineWidth',1.25)
%h3 = plot(movement_table{1:138, albinism},'Color',custom_rgb_map(3,:), 'LineWidth',1.25)
%h4 = plot(movement_table{1:138, controls},'Color',custom_rgb_map(5,:), 'LineWidth',1.25)
 


% Add markers for b0 images

% Mark b0s
%for vol = 1:size(bvecs,2)
%    if bvecs(vol)==0
%        h5 = xline(vol, '--')
%    end
%end

% Legend
legend([h1(1),h2(1),h3(1), h4(1)],'Chiasma Hypoplasia','Achiasma','Albinism', 'Controls', 'b0 volume', 'FontSize', font_size-6, 'Location','northwest')

% X label
set(gca,'XTick', b0_indices);
xlim([0 138]);
xlabel('Volume', 'FontSize', font_size);

% Y label
ylabel('Movement RMS', 'FontSize', font_size);
set(gca,'YTick', [0 1.25 2.5]);

% Ticks out
set(gca,'TickDir','out'); 

% Title
title('Subjects movement in DWI acquired with AP PED', 'FontSize', font_size)

% 2nd plot
subplot(2,4,4);

mean_con = mean(movement_table{1:138, controls});
mean_alb = mean(movement_table{1:138, albinism});
mean_ach = mean(movement_table{1:138, achiasma});
mean_hyp = mean(movement_table{1:138, hypoplasia});

[H,P] = ttest2(mean_con,mean_alb)

points = [mean_alb, mean_con];
divide=[ones(1,size(albinism,2)),2*ones(1,size(controls,2))];

%boxplot(points, divide, 'colors', [custom_rgb_map(3,:); custom_rgb_map(5,:)]);
 
hold on
fig1=scatter(ones(1,size(albinism,2)),mean_alb,360,'ks');
set(fig1(1), 'MarkerFaceColor', custom_rgb_map(3,:));
hold on
fig2=scatter(2*ones(1,size(controls,2)),mean_con,360,'ko');
set(fig2(1), 'MarkerFaceColor', custom_rgb_map(5,:));
hold on
fig3=scatter(3*ones(1,size(achiasma,2)),mean_ach,360,'k^');
set(fig3(1), 'MarkerFaceColor', custom_rgb_map(2,:));
fig4=scatter(4*ones(1,size(hypoplasia,2)),mean_hyp,360,'kv');
set(fig4(1), 'MarkerFaceColor', custom_rgb_map(1,:));

ylim([0 2.5]);
set(gca,'YTick', [0 1.25 2.5]);
ylabel('')

xlim([0 5]);
              
%set(gca,'YTick',[0 0.01 0.02 0.03], 'FontSize', 24);
set(gca,'XTick', [1:4],'xticklabel' ,{'ALB' 'CON' 'ACH' 'CHP'}, 'FontSize',font_size-10);
xlabel('Group', 'FontSize', font_size);

%set(gca,'YTick', [0 0.2 0.4], 'FontSize', font_size);   
%ylabel('Mean RMS Movement relative to previous volume', 'FontSize', font_size);

% Ticks out
set(gca,'TickDir','out'); 


%title(strcat('AP phase encoding series)'))
title('Mean movement', 'Fontsize',font_size)


%%
% 1st series
% 1st plot
subplot(2,4,5:7)
hold on 

% Find b0 indices
b0_indices = find(~bvecs)

% Plot lines
h1 = plot(139:276,movement_table{139:276, hypoplasia},'-v','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',custom_rgb_map(1,:), 'LineWidth',1.25, 'MarkerSize', 12);
h2 = plot(139:276,movement_table{139:276, achiasma},'-^','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',custom_rgb_map(2,:), 'LineWidth',1.25, 'MarkerSize', 12);
h3 = plot(139:276,movement_table{139:276, albinism},'-s','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',custom_rgb_map(3,:), 'LineWidth',1.25, 'MarkerSize', 12);
h4 = plot(139:276,movement_table{139:276, controls},'-o','MarkerIndices', b0_indices , 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',custom_rgb_map(5,:), 'LineWidth',1.25, 'MarkerSize', 12);

%h2 = plot(movement_table{1:138, achiasma},'Color',custom_rgb_map(2,:), 'LineWidth',1.25)
%h3 = plot(movement_table{1:138, albinism},'Color',custom_rgb_map(3,:), 'LineWidth',1.25)
%h4 = plot(movement_table{1:138, controls},'Color',custom_rgb_map(5,:), 'LineWidth',1.25)
 


% Add markers for b0 images

% Mark b0s
%for vol = 1:size(bvecs,2)
%    if bvecs(vol)==0
%        h5 = xline(vol, '--')
%    end
%end

% Legend
%legend([h1(1),h2(1),h3(1), h4(1)],'Chiasma Hypoplasia','Achiasma','Albinism', 'Controls', 'b0 volume', 'FontSize', font_size-6, 'Location','northwest')

% X label
set(gca,'XTick', 138+b0_indices);
xlim([139 276]);
xlabel('Volume', 'FontSize', font_size);

% Y label
ylabel('Movement RMS', 'FontSize', font_size);
set(gca,'YTick', [0 1.25 2.5]);
ylim([0 3.1])

% Ticks out
set(gca,'TickDir','out'); 

% Title
title('Subjects movement in DWI acquired with PA PED', 'FontSize', font_size)

% 2nd plot
subplot(2,4,8);

mean_con = mean(movement_table{139:276, controls});
mean_alb = mean(movement_table{139:276, albinism});
mean_ach = mean(movement_table{139:276, achiasma});
mean_hyp = mean(movement_table{139:276, hypoplasia});

[H,P] = ttest2(mean_con,mean_alb)

points = [mean_alb, mean_con];
divide=[ones(1,size(albinism,2)),2*ones(1,size(controls,2))];

%boxplot(points, divide, 'colors', [custom_rgb_map(3,:); custom_rgb_map(5,:)]);
 
hold on
fig1=scatter(ones(1,size(albinism,2)),mean_alb,360,'ks');
set(fig1(1), 'MarkerFaceColor', custom_rgb_map(3,:));
hold on
fig2=scatter(2*ones(1,size(controls,2)),mean_con,360,'ko');
set(fig2(1), 'MarkerFaceColor', custom_rgb_map(5,:));
hold on
fig3=scatter(3*ones(1,size(achiasma,2)),mean_ach,360,'k^');
set(fig3(1), 'MarkerFaceColor', custom_rgb_map(2,:));
fig4=scatter(4*ones(1,size(hypoplasia,2)),mean_hyp,360,'kv');
set(fig4(1), 'MarkerFaceColor', custom_rgb_map(1,:));

ylim([0 3.1]);
set(gca,'YTick', [0 1.25 2.5]);
ylabel('')

xlim([0 5]);
              
%set(gca,'YTick',[0 0.01 0.02 0.03], 'FontSize', 24);
set(gca,'XTick', [1:4],'xticklabel' ,{'ALB' 'CON' 'ACH' 'CHP'}, 'FontSize',font_size-10);
xlabel('Group', 'FontSize', font_size);

%set(gca,'YTick', [0 0.2 0.4], 'FontSize', font_size);   
%ylabel('Mean RMS Movement relative to previous volume', 'FontSize', font_size);

% Ticks out
set(gca,'TickDir','out'); 


%title(strcat('AP phase encoding series)'))
title('Mean movement', 'Fontsize',font_size)


% Save the image
saveas(gcf, '/home/rjp/1_OVGU/3_Data_publication/1_Motion_estimate/motion_plot.epsc')
print(gcf,'motion_plot_v2','-depsc','-r300');    
close
