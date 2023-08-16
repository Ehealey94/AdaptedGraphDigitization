function [all_data_clusters, idx]=k_cluster_data(all_data_table, n_clusters, YlabelNames)
%% Computing

all_data=table2array(all_data_table(:, 5:18));
idx=kmeans(all_data, n_clusters);

% Assigning clusters
cluster_one = all_data(idx==1, :);
cluster_two = all_data(idx==2, :);
try
    cluster_three = all_data(idx==3, :);
catch
    disp('not more than two clusters')
end
try
    cluster_four = all_data(idx==4, :);
catch
    disp('not more than three clusters')
end

% Classifying which cluster each timepoint is in
all_data_table(:,end+1)={0};
for i=1:height(all_data_table)
    all_data_table{i, end} = idx(i);
end

all_data_clusters=all_data_table;
all_data_cluster=renamevars(all_data_clusters, 'Var30', 'Cluster');
%% Boxplots 

%Get colours
[colours, blue, black, brown, yellow, purple, red, green] = tasty_colours()



% close all
f=figure('WindowState','maximized')
t=tiledlayout(2,1)
nexttile
boxplot(cluster_one, 'Labels', YlabelNames, 'Symbol','');
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),blue,'FaceAlpha',.50);
end
title('Cluster One')
% saveas(f, ([opffig 'cluster_one_dimensions.fig']));
% saveas(f, ([opfpng 'cluster_one_dimensions.png']));

%Cluster two 
% f=figure('WindowState','maximized')
nexttile
boxplot(cluster_two, 'Labels', YlabelNames, 'Symbol','');
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),yellow,'FaceAlpha',.50);
end
title('Cluster Two')

t.Title.String='Dimension Intensities for Each Cluster';

% saveas(f, ([opffig 'cluster_two_dimensions.fig']));
% saveas(f, ([opfpng 'cluster_two_dimensions.png']));
if n_clusters > 2
    figure()
    boxplot(cluster_three, 'Labels', YlabelNames, 'Symbol', '')
    title('Cluster Three')
end
if n_clusters > 3
    figure()
    boxplot(cluster_four, 'Labels', YlabelNames, 'Symbol', '')
    title('Cluster Four')
end
if n_clusters > 4
    figure()
    boxplot(cluster_five, 'Labels', YlabelNames, 'Symbol', '')
    title('Cluster Five')
end

%% Plotting - Histograms

% Conditions={'Intro', 'Breath', 'Hold', 'Rest', 'End', 'Fast'};
% 
% for k=1:n_clusters
%     clstr=all_data_table(idx==k, 4);
%     clstr=categorical(clstr)
%     figure()
%     histogram(clstr)
%     title(['Distribution of Conditions for Cluster ' num2str(k)])
% end
% %By week
% for k=1:n_clusters
%     clstr=all_data_cell(idx==k, 2);
%     clstr=categorical(clstr);
%     figure()
%     histogram(clstr, 'Normalization','pdf')
%     title(['Distribution of Weeks for Cluster ' num2str(k)])
% end
% %By Subject
% for k=1:n_clusters
%     clstr=all_data_cell(idx==k, 1);
%     clstr=categorical(clstr);
%     figure()
%     histogram(clstr, 'Normalization','pdf')
%     title(['Distribution of Subject for Cluster ' num2str(k)])
% end
