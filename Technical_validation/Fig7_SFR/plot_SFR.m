% Define participants and groups they belong to
albinism={['ALB1'];['ALB2'];['ALB3'];['ALB4'];['ALB5'];['ALB6'];['ALB7'];['ALB8'];['ALB9']};
controls={['CON1'];['CON2'];['CON3'];['CON4'];['CON5'];['CON6'];['CON7'];['CON8']};
achiasma={['ACH1']};
hypoplasia={['CHP1']};

subjects=dir(strcat('SFR/*txt'));
subjects = cellfun(@(x){x(1:4)}, {subjects(1:end).name});

% Create table to store all the sh coefficients
sh_table = array2table(nan(4,19));
sh_table.Properties.VariableNames = subjects;

% Load sh coefficients into the table
for i=1:size(subjects,2)
    
    subj=subjects{i};
    tmp_file=fopen(strcat('SFR/',subj,'_SFR.txt'));
    tmp=textscan(tmp_file,'%f', 'HeaderLines',2);
    fclose(tmp_file);

    sh_table{1,subj}=tmp{1}(1);
    sh_table{2,subj}=tmp{1}(2);
    sh_table{3,subj}=tmp{1}(3);
    sh_table{4,subj}=tmp{1}(4);   
end

% Prepare custom color map
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Size of font
font_size = 30

% Plot everything using box plots
figure('units','normalized','outerposition',[0 0 1 1]);
hold on

% Add lines
for k=1:size(subjects,2)  

    switch subjects{k}(1:3)
        case 'CHP'
            plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(1,:),'LineWidth',2) 
        case 'ACH'
            plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(2,:),'LineWidth',2) 
        case 'ALB'
            plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(3,:),'LineWidth',2) 
        case 'CON'
            plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(5,:),'LineWidth',2) 
    end
end

% Add markers
for i=1:size(sh_table,1)

    % Create X variable
    x=i*ones(1,19);
    
    % Create group variable
    groups=[ones(1,1), 2*ones(1,1), 3*ones(1,9), 4*ones(1,8)]

    h = gscatter(x,sh_table{i,:},groups,'kkkk','v^so',30)
    set(h(1), 'MarkerFaceColor', custom_rgb_map(1,:));
    set(h(2), 'MarkerFaceColor', custom_rgb_map(2,:));
    set(h(3), 'MarkerFaceColor', custom_rgb_map(3,:));
    set(h(4), 'MarkerFaceColor', custom_rgb_map(5,:));
    
    hold on
    
end

% Y label
ylabel('Value', 'FontSize', font_size)

% X label
set(gca,'XTick', [1:4],'xticklabel' ,{'order 0' ' order 2' 'order 4','order 6'}, 'FontSize', font_size);
xlabel('Zero phase (m=0) SH coefficients of single fiber response function', 'FontSize', font_size);

% Horizontal line
h4 = yline(0, '--')

% Legend
legend([h(1),h(2),h(3),h(4)],'Chiasma Hypoplasia','Achiasma','Albinism','Control', 'FontSize', font_size+4)
    
% Title
title('Spherical harmonics coefficients of the single fiber response function')

% Ticks out
set(gca,'TickDir','out'); 

% Box off
box off

print(gcf,'Fig7_SH_coefficients_of_SFR','-djpeg','-r300');    
close
