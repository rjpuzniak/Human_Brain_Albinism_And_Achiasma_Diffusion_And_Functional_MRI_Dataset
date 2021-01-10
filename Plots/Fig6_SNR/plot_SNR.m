data_folder='/home/rjp/1_OVGU/3_Data_publication/4_SNR_in_chiasm/Data'

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
    
custom_map=[100 143 255; 120 94 240; 220 38 127; 254 97 0; 256 176 0]/256;
custom_hsv_map = rgb2hsv(custom_map);
custom_hsv_map(:,2) = custom_hsv_map(:,2) * 0.6;
custom_rgb_map = hsv2rgb(custom_hsv_map);

% Plot SNR for each case
groups=[ones(1,1), 2*ones(1,1), 3*ones(1,9), 4*ones(1,8)]

% Size of font
font_size = 30



for i=1:4
    
    if i==1
        type='b0'
    elseif i==2
        type='X'
    elseif i==3
        type='Y'
    elseif i==4
        type='Z'
    end
   
    figure('units','normalized','outerposition',[0 0 1 1]);
    hold on
    %subplot(4,1,i)
    
    % Add lines
    for k=1:size(subjects,2)  
        
        if subjects{k}(1:4)=='ACH1'
            plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',custom_rgb_map(1,:),'LineWidth',2) 
        elseif subjects{k}(1:4)=='ACH2'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',custom_rgb_map(2,:),'LineWidth',2) 
         elseif subjects{k}(1:3)=='ALB'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',custom_rgb_map(3,:),'LineWidth',2) 
         elseif subjects{k}(1:3)=='CON'
             plot([1,2,3,4], snr_data{1,i}{:,k},'-','Color',custom_rgb_map(5,:),'LineWidth',2) 
        end   
            
    end
    
    for j=1:4
        
        x=j*ones(1,19);

        h = gscatter(x,snr_data{1,i}{{variant_names{j}},:},groups,'kkkk','v^so',30, 'LineWidth', 0.1)
        hold on
        
        set(h(1), 'MarkerFaceColor', custom_rgb_map(1,:));
        set(h(2), 'MarkerFaceColor', custom_rgb_map(2,:));
        set(h(3), 'MarkerFaceColor', custom_rgb_map(3,:));
        set(h(4), 'MarkerFaceColor', custom_rgb_map(5,:));
        
        xlim([0 5])
        set(gca,'XTick', [1:4],'xticklabel' ,{'warped (AP)' ' warped (PA)','unwarped','unwarped'}, 'FontSize', font_size);
        %xlabel('Structure and preprocessing stage', 'FontSize', font_size);
        xlabel('                                                Corpus Callosum                                             Optic Chiasm', 'FontSize', font_size);
        
        if i>1
            ylim([0 50])
            set(gca,'YTick', [0,25,50], 'FontSize', font_size);
            title(strcat('Signal-to-Noise along',32,type,'-axis'),'FontSize',font_size)
        else
            ylim([0 150])
            set(gca,'YTick', [0,75,150], 'FontSize', font_size);
            title(strcat('Signal-to-Noise in',32,type,32,'image'),'FontSize',font_size)
        end
      
        ylabel('Signal-to-Noise Ratio', 'FontSize', font_size)
               
        set(gca,'TickDir','out'); 
        
        %set(h, 'linestyle', '-');

    end
    
    box off
    
    legend([h(1),h(2),h(3),h(4)],'Chiasma Hypoplasia','Achiasma','Albinism','Controls', 'b0 volume', 'FontSize', font_size+4, 'Location','northwest')
    
    print(gcf,strcat('SNR_in_',type),'-depsc','-r600');  
    close
    
end 

