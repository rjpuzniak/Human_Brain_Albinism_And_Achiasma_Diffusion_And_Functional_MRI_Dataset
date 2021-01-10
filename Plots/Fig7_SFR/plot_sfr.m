albinism={['ce04'];['fe21'];['ib57'];['kw99'];['nh50'];['rx88'];['sj22'];['tq63'];['uh47']};
controls={['la21'];['lw37'];['nb30'];['ow93'];['uf97'];['xn78'];['xs62'];['ta14']};
achiasma={['ps94'];['hw91']};

data_folder='/home/rjp/1_OVGU/3_Data_publication/2_SFR/SFR'
output_folder='/home/rjp/1_OVGU/3_Data_publication/2_SFR'

subjects=dir(strcat(data_folder,'/*txt'));
subjects = cellfun(@(x){x(1:5)}, {subjects(1:end).name});

% Create table to store all the sh coefficients
sh_table = array2table(nan(4,19));
sh_table.Properties.VariableNames = subjects;

% Load sh coefficients into the table
for i=1:size(subjects,2)
    
    subj=subjects{i}
    tmp=load(strcat(data_folder,'/',subj,'_SFR.txt'));

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

% Size of font
font_size = 30

% Plot everything using box plots
figure('units','normalized','outerposition',[0 0 1 1]);
hold on

% Add lines
for k=1:size(subjects,2)  

    if subjects{k}(1:4)=='ACH1'
        plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(1,:),'LineWidth',2) 
    elseif subjects{k}(1:4)=='ACH2'
         plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(2,:),'LineWidth',2) 
     elseif subjects{k}(1:3)=='ALB'
         plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(3,:),'LineWidth',2) 
     elseif subjects{k}(1:3)=='CON'
         plot([1,2,3,4], sh_table{:,k},'-','Color',custom_rgb_map(5,:),'LineWidth',2) 
    end   

end

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

print(gcf,'sh_coeffs_of_sfr','-depsc','-r300');    
%close
