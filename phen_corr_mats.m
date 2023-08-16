function phen_corr_mats(sample_table, corr_type, plot, YlabelNames)


if corr_type==1
    k=ismember(sample_table.Week, 'week_1');
    wk_1_matrix=table2array(sample_table(k==1,5:18));
    wk_1_corr=corrcoef(wk_1_matrix);
    k=ismember(sample_table.Week, 'week_2');
    wk_2_matrix=table2array(sample_table(k==1,5:18));
    wk_2_corr= corrcoef(wk_2_matrix);
    k=ismember(sample_table.Week, 'week_3');
    wk_3_matrix=table2array(sample_table(k==1,5:18));
    wk_3_corr= corrcoef(wk_3_matrix);
    k=ismember(sample_table.Week, 'week_4');
    wk_4_matrix=table2array(sample_table(k==1,5:18));
    wk_4_corr= corrcoef(wk_4_matrix);
    all_data_matrix = table2array(sample_table(:, 5:18));
    all_data_corr=corrcoef(all_data_matrix);
elseif corr_type==2
    k=ismember(sample_table.Week, 'week_1');
    wk_1_matrix=table2array(sample_table(k==1,5:18));
    wk_1_corr=corr(wk_1_matrix, 'type', 'Spearman');
    k=ismember(sample_table.Week, 'week_2');
    wk_2_matrix=table2array(sample_table(k==1,5:18));
    wk_2_corr= corr(wk_2_matrix, 'type', 'Spearman');
    k=ismember(sample_table.Week, 'week_3');
    wk_3_matrix=table2array(sample_table(k==1,5:18));
    wk_3_corr= corr(wk_3_matrix, 'type', 'Spearman');
    k=ismember(sample_table.Week, 'week_4');
    wk_4_matrix=table2array(sample_table(k==1,5:18));
    wk_4_corr= corr(wk_4_matrix, 'type', 'Spearman');
    all_data_matrix = table2array(sample_table(:, 5:18));
    all_data_corr=corr(all_data_matrix, 'type', 'Spearman');
end

%%By subject
pc_struct=struct('s01', [], 's02', [], 's03', [], 's04', [], 's07', [], 's08', [], 's10', []);

for s=1:length(subject)
    dispose=[];
    sub=ismember(all_data_table.Subject, subject{s});
    dispose=all_data(sub==1, :);
    pc_struct.(subject{s})=dispose;
end

corr_sample=zeros(14,14);

for s=1:length(subject)
    dispose=[];
    if s==1
        corr_sample=corr(pc_struct.(subject{s}))
    else
        corr_sample=corr_sample+(corr(pc_struct.(subject{s})));
    end
end

corr_sample_new=corr_sample/7


%% Plotting if necessary

if plot==1
    % Set [min,max] value of C to scale colors
    % This must span the range of your data!
    % clrLim = [0,1]; 
    % Set the  [min,max] of diameter where 1 consumes entire grid square
    diamLim = [0.3, 1];
    % Plot the data using imagesc() for later comparison
    matrices = {'wk_1_corr', 'wk_2_corr', 'wk_3_corr', 'wk_4_corr'}
    figure()
    imagesc(all_data_corr)
    yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
    xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
    yticklabels(YlabelNames)
    xticklabels(YlabelNames)
    colormap(redblue)
    if corr_type==1
        title('Correlation Matrix for All Data')
    elseif corr_type==2
        title('Correlation Matrix for All Data')
    end
    colorbar()
    caxis([-1, 1])
    axis equal 
    axis tight
    
    
    figure()
    for i=1:length(matrices)
        subplot(2,2,i)
        m=matrices{i}
        if i==1
            imagesc(wk_1_corr)
            yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
            yticklabels(YlabelNames)
            xticklabels({''})
        elseif i==2
            imagesc(wk_2_corr)
            yticklabels({''})
            xticklabels({''})
        elseif i==3
            imagesc(wk_3_corr)
            yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
            xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
            yticklabels(YlabelNames)
            xticklabels(YlabelNames)
        elseif i==4
            imagesc(wk_4_corr)
            xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
            xticklabels(YlabelNames)
            yticklabels({''})
        end
    %     yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
    %     xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
    %     yticklabels(YlabelNames)
    %     xticklabels(YlabelNames)
        colormap(redblue)
        caxis([-1, 1])
        title(['Week ' m(4)])
        colorbar()
    %     caxis(clrLim)
        axis equal 
        axis tight
    end
end
