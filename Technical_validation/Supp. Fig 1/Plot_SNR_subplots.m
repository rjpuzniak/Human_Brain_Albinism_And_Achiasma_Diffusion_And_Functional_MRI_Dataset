data_folder='../Fig5b_SNR/Data'

% Define participants and groups they belong to
albinism={['ALB1'];['ALB2'];['ALB3'];['ALB4'];['ALB5'];['ALB6'];['ALB7'];['ALB8'];['ALB9']};
controls={['CON1'];['CON2'];['CON3'];['CON4'];['CON5'];['CON6'];['CON7'];['CON8']};
achiasma={['ACH2']};
hypoplasia={['ACH1']};

% Subjects
subjects=dir(strcat(data_folder,'/SNR_CC_clean'));
subjects = cellfun(@(x){x(5:8)}, {subjects(5:end).name});

% Folder to be processed
variant=dir(data_folder);
variant_names = cellfun(@(x){x(5:end)}, {variant(3:end).name});

% Create template table
template = array2table(zeros(4,19));
template.Properties.VariableNames = subjects;
template.Properties.RowNames={'CC_AP', 'CC_PA', 'CC_clean','OC_clean'};

% SNR data ordered as b0, X, Y,Z
snr_data{1}=template;
snr_data{2}=template;
snr_data{3}=template;
snr_data{4}=template;

% Loop through all BL files and save them to tables   
for i=1:(size(dir(data_folder),1)-3)
    for j=1:(size(subjects,2))

         % Find the file
        path=dir(strcat(data_folder,'/SNR_',variant_names{i},'/sub-',subjects{j},'/*/output/snr.json'));
        file_path=strcat(path.folder,'/',path.name);

        % Load the contents of json file
        fname = strcat(file_path);
        fid = fopen(fname); 
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        data = jsondecode(str);

        % Save the json file contents to the table
        for k=1:size(data.SNRInB0_X_Y_Z,1)
            snr_data{1,k}.(subjects{j})(variant_names{i})=str2num(data.SNRInB0_X_Y_Z{k,1});
        end  
        
    end 
end

% Loop through custom OC data
for j=1:(size(subjects,2))
    file_path=strcat(data_folder,'/SNR_OC_clean/snr_',subjects{j},'.json');
    
    % Load the contents of json file
    fname = strcat(file_path);
    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    data = jsondecode(str);

    % Save the json file contents to the table
    for k=1:size(data.SNRInB0_X_Y_Z,1)
        snr_data{1,k}.(subjects{j})(variant_names{4})=str2num(data.SNRInB0_X_Y_Z{k,1});
    end  
    
end
 
% Custom color map
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Figure properties (font sizes, markers sizes etc.)
markers_size_plot=50;
markers_size_scatter=800;
line_opacity=0.4;
line_width=2;

font_size = 20;
font_size_ticks=10;

%% Plot SNR for each case
groups=[ones(1,1), 2*ones(1,1), 3*ones(1,9), 4*ones(1,8)];

figure('units','normalized','outerposition',[0 0 1 1]);

for i=1:4
    
    subplot(2,3,mod(i+2,4)+1)
    
    if i==1
        type='b0';
    elseif i==2
        type='X-axis';
    elseif i==3
        type='Y-axis';
    elseif i==4
        type='Z-axis';
    end
   
    hold on
    
    % Add lines
    for k=1:size(subjects,2)          
        if subjects{k}(1:4)=='ACH1'
            plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',[custom_rgb_map(1,:),line_opacity],'LineWidth',line_width) 
        elseif subjects{k}(1:4)=='ACH2'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',[custom_rgb_map(2,:),line_opacity],'LineWidth',line_width) 
         elseif subjects{k}(1:3)=='ALB'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',[custom_rgb_map(3,:),line_opacity],'LineWidth',line_width) 
         elseif subjects{k}(1:3)=='CON'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',[custom_rgb_map(5,:),line_opacity],'LineWidth',line_width) 
        end              
    end
    
    for j=1:4

        % Add markers on top
        h1=scatter(j*ones(1,8), snr_data{1,i}{{variant_names{j}},controls}, markers_size_scatter, 'ko', 'MarkerFaceColor', custom_rgb_map(5,:), 'LineWidth',line_width);
        h2=scatter(j*ones(1,9), snr_data{1,i}{{variant_names{j}},albinism}, markers_size_scatter, 'ks', 'MarkerFaceColor', custom_rgb_map(3,:), 'LineWidth',line_width);
        h3=scatter(j*ones(1,1), snr_data{1,i}{{variant_names{j}},achiasma}, markers_size_scatter, 'k^', 'MarkerFaceColor', custom_rgb_map(2,:), 'LineWidth',line_width);
        h4=scatter(j*ones(1,1), snr_data{1,i}{{variant_names{j}},hypoplasia}, markers_size_scatter, 'kv', 'MarkerFaceColor', custom_rgb_map(1,:), 'LineWidth',line_width);
     
        hold on

        xlim([0 5])
        set(gca,'XTick', [1:4],'xticklabel' ,{'raw AP' ' raw PA','corrected','corrected'}, 'FontSize', font_size_ticks);
        
        
        if i>1
            ylim([0 50])
            set(gca,'YTick', [0,25,50], 'FontSize', font_size_ticks);
        else
            ylim([0 150])
            set(gca,'YTick', [0,75,150], 'FontSize', font_size_ticks);
        end
      
        ylabel('Signal-to-Noise Ratio', 'FontSize', font_size)
        xlabel('              Corpus Callosum        Optic Chiasm', 'FontSize', font_size);
               
        set(gca,'TickDir','out'); 
        
        title(type, 'FontSize', font_size)

    end
    
    box off

    % Create dummy lines to be shown in the legend
    h4 = plot(nan,'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(5,:), 'Color',[custom_rgb_map(5,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
    h3 = plot(nan,'s', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(3,:), 'Color',[custom_rgb_map(3,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
    h2 = plot(nan,'^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(2,:), 'Color',[custom_rgb_map(2,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
    h1 = plot(nan,'v', 'MarkerEdgeColor', 'k', 'MarkerFaceColor',custom_rgb_map(1,:), 'Color',[custom_rgb_map(1,:),line_opacity], 'LineWidth',line_width, 'MarkerSize', markers_size_plot-25);
    
    pbaspect([1 1 1]);
    
end 


print(gcf,strcat('SNR'),'-djpeg','-r500');  
%close