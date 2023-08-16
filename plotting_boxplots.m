function plotting_boxplots(all_data_table, YlabelNames, save)

%% Plotting boxplots for all data - shade out if needed

all_data=all_data_table(:, 5:18);

k=ismember(all_data_table.Week, 'week_1');
wk_1=table2array(all_data_table(k==1, 5:18));
k=ismember(all_data_table.Week, 'week_2');
wk_2=table2array(all_data_table(k==1, 5:18));
k=ismember(all_data_table.Week, 'week_3');
wk_3=table2array(all_data_table(k==1, 5:18));
k=ismember(all_data_table.Week, 'week_4');
wk_4=table2array(all_data_table(k==1, 5:18));


figure()
boxplot(wk_1, 'Labels', YlabelNames)
title('Week 1 Dimensions')
figure()
boxplot(wk_2, 'Labels', YlabelNames)
title('Week 2 Dimensions')
figure()
boxplot(wk_3, 'Labels', YlabelNames)
title('Week 3 Dimensions')
figure()
boxplot(wk_4, 'Labels', YlabelNames)
title('Week 4 Dimensions')

%% Extracting and plotting boxplots for specific conditions

% bc_xlabelnames=categorical(YlabelNames);
% 
% k=ismember(all_data_table.Condition, 'Breath');
% all_breath=table2array(all_data_table(k==1, 5:18));
% k=ismember(all_data_table.Condition, 'Intro');
% all_intro=table2array(all_data_table(k==1, 5:18));
% k=ismember(all_data_table.Condition, 'Hold');
% all_hold=table2array(all_data_table(k==1, 5:18));
% k=ismember(all_data_table.Condition, 'Fast');
% all_fast=table2array(all_data_table(k==1, 5:18));
% k=ismember(all_data_table.Condition, 'Rest');
% all_rest=table2array(all_data_table(k==1, 5:18));
% k=ismember(all_data_table.Condition, 'END');
% all_end=table2array(all_data_table(k==1, 5:18));
% 
% % Plot each condition with mean of intensity of dimension per subject
% for c=1:length(Conditions)
%     fig=figure('WindowState', 'maximized')
%     if c == 1 
%         boxplot(all_intro, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title('Dimensions for Start of Session');
%     elseif c==2
%         boxplot(all_breath, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title(['Dimensions for ' Conditions{c} ' Condition']);
%     elseif c==3
%         boxplot(all_hold, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title(['Dimensions for ' Conditions{c} ' Condition']);
%     elseif c==4
%         boxplot(all_rest, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title(['Dimensions for ' Conditions{c} ' Condition']);
%     elseif c==5
%         boxplot(all_end, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title(['Dimensions for End of Session']);
%     elseif c==6
%         boxplot(all_fast, 'Labels', YlabelNames, 'Symbol', '')
%         for i =1:length(subject)
%             hold on
%             plot(part_var.(Conditions{c}).(subject{i}), '-o')
%         end
%         hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
%         title(['Dimensions for ' Conditions{c} ' Condition']);
%     end
%     if save == 1
%         opf=(['C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.fig\' Conditions{c} '_plus_subject.fig']);
%         saveas(fig, opf)
%         opf=(['C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.png\' Conditions{c} '_plus_subject.png']);
%         saveas(fig, opf)
%     end
% end
% 
% 
