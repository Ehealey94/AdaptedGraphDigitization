% concatenate all phenomenological data together by week
Directory ='C:\Users\evanl\Documents\TET\';
subject = {'s01', 's02', 's03', 's04', 's07', 's08', 's10'};
week = {'week_1', 'week_2', 'week_3', 'week_4'};
outputpath=[Directory 'summed\'];
table_names = {'Subject', 'Week', 'Session', 'Condition', 'Meta awareness',...
    'Presence', 'Physical effort','Mental effort','Boredom', 'Receptivity',...
    'Emotional intensity', 'Clarity', 'Release','Bliss', 'Disembodiment', 'Insightfulness', 'Anxiety', 'Spiritual experience'};
YlabelNames = {'Meta awareness', 'Presence', 'Physical effort','Mental effort',...
    'Boredom', 'Receptivity', 'Emotional intensity', 'Clarity', 'Release',...
    'Bliss', 'Disembodiment', 'Insightfulness', 'Anxiety', 'Spiritual experience'};

[colours, blue, black, brown, yellow, purple, red, green]=tasty_colours()

%% Extract Phenonemenological Data
all_data_cell=extract_data(week, subject, Directory);

% Count total TET sessions
count=total_sessions(all_data_table);

%% Save data for all sessions
all_data_table=cell2table(all_data_cell);
all_data_table.Properties.VariableNames = table_names;
cd(outputpath)
writetable(all_data_table, 'all_data.csv');

% Extract and save tables of individual weeks
extract_save_weeks(all_data_table, outputpath);

%% Visualising temporal dynamics
extract_temp_dynamics(normalized_data_cell, week, subject, YlabelNames)

%% Visualising temporal dynamics with clusters
% all_data has to be with clusters in end column
temp_dyn=extract_temp_dynamics_clusters(all_data_clusters, week, subject, YlabelNames)

for w=1:length(week)
    wdth=width(temp_dyn.(week{w}))
    dispose=[];
    for i = 1:length(temp_dyn.(week{w}))
        dispose(i,1)=sum(temp_dyn.(week{w})(i,:)==1);
        dispose(i,1)=(dispose(i,1)/wdth)*100;
    end
    temp_dyn.(week{w})(:, (wdth+1))=dispose;
end


%% Compute correlation coefficients by week
corr_type=2; %1 for pearson's, 2 for spearman's
plot=1; %1/0 for yes/no
phen_corr_mats(all_data_table, corr_type, plot, YlabelNames)


%Compute correlation matrices by conditions and week
% wk_1_breath_matrix = corrcoef(wk_1_breath);
% wk_1_hold_matrix = corrcoef(wk_1_hold);

%% Dimension Intensity Boxplot for all participants 
save = 0; %1 to save
plotting_boxplots(all_data_clusters, YlabelNames, save)




figure()
    boxplot(all_intro, 'Labels', YlabelNames, 'Symbol', '')
    for i =1:length(subject)
        hold on
        plot(part_var.(Conditions{c}).(subject{i}), '-o')
    end
    hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
    title('Dimensions for Start of Session')




figure()
for i=1:length(Conditions)
    subplot(3,2,i)
    if i==1
        boxplot(all_intro, 'Symbol', '')
        set(gca,'XTickLabel',{' '})
        title('Dimensions for Start of Session')
    elseif i==2
        boxplot(all_breath, 'Symbol', '')
        set(gca,'XTickLabel',{' '})
        title('Dimensions for Breath Condition')
    elseif i==3
        boxplot(all_hold, 'Symbol', '')
        set(gca,'XTickLabel',{' '})
        title('Dimensions for Breath Hold Condition')
    elseif i==4
        boxplot(all_rest, 'Symbol', '')
        set(gca,'XTickLabel',{' '})
        title('Dimensions for Rest Condition')
    elseif i==5
        boxplot(all_end, 'Labels', YlabelNames, 'Symbol', '')
        title('Dimensions for End of Session')
    elseif i==6
        boxplot(all_fast, 'Labels', YlabelNames, 'Symbol', '')
        title('Dimensions for Fast Breathing Condition')
    end
end


part_var.Intro = struct("s01", [], "s02", [], "s03", [],"s04", [], "s07", [], "s08", [], "s10", []);
part_var.Breath = part_var.Intro;
part_var.Hold = part_var.Intro;
part_var.Rest = part_var.Intro;
part_var.Fast = part_var.Intro;
part_var.End = part_var.Intro;

for i = 1:length(subject)
    for c=5
        sample=[];
        cond=Conditions{c};
        subj=subject{i};
        k=ismember(sample_table.Subject, subj);
        j=strcmpi(sample_table.Condition, cond);
        sample = table2array(sample_table(k==1 & j==1, 5:18));
        length(sample)
        part_var.(Conditions{c}).(subj)=mean(sample)
    end
end


% Visualing different conditions
figure()
boxplot(all_breath, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for Breathing Condition')
figure()
boxplot(all_hold, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for Breath Hold Condition')
figure()
boxplot(all_intro, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for Start of Session')
figure()
boxplot(all_end, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for End of Session')
figure()
boxplot(all_fast, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for Fast Breathing Condition')
figure()
boxplot(all_rest, 'Labels', YlabelNames, 'Symbol', '')
title('Dimensions for Rest Condition')

%% K-clustering and visualisation
normalized_data_arr=table2array(normalized_data(:, 5:18));
% Find optimal number of clusters 
eva=evalclusters(normalized_data_arr, 'kmeans', 'CalinskiHarabasz', 'KList', 2:6) %2
n_clusters=2; % Change based on above
% Function
[all_data_clusters, idx] = k_cluster_data(all_data, n_clusters, YlabelNames);




%% Can also do fuzzy c-means clustering - partitions each (multivariate) data point into clusters with a degree of membership for each cluster
[centers, U] = fcm(all_data, 4);
maxU=max(U);

idx1=find(U(1,:)==maxU);
idx2=find(U(2,:)==maxU);
idx3=find(U(3,:)==maxU);
idx4=find(U(4,:)==maxU);


cluster_one=all_data(idx1,:);
cluster_two=all_data(idx2,:);
cluster_three=all_data(idx3,:);
cluster_four=all_data(idx4,:);

%% PCA
pc_struct=princ_comp_plot(all_data_table, subject, week)


% Perform the PCA
[coeff, score, latent] = pca(data);
% Extract the principal components
principal_components = coeff(:, 1:3);
% Project the data onto the principal components
projected_data = data * principal_components;
% Visualize the projected data, and labelling k-means
cl_one_pc_space=projected_data(idx==1,:);
cl_two_pc_space=projected_data(idx==2,:);
figure()
uno=scatter3(cl_one_pc_space(:,1), cl_one_pc_space(:,2), cl_one_pc_space(:,3));
hold on
dos=scatter3(cl_two_pc_space(:,1), cl_two_pc_space(:,2), cl_two_pc_space(:,3));
uno.CData=blue;
dos.CData=yellow;
legend('Cluster One', 'Cluster Two', 'Location','eastoutside')
xlabel('Receptivity, Bliss, Spiritual Experience')
ylabel('Mental Effort, Physical Effort, Embodiment')
zlabel('PC 3')
title('TET in Principal Component Space')

h=scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], idx)
for 
% Visualise projected data and labelling participant
subs=categorical(sample_table.Subject);
h=scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], subs);
%Visualise projected data and labelling fuzzy c-means
figure()
scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], fcm_idx);
% Add labels to the axes
xlabel('First Principal Component');
ylabel('Second Principal Component');
zlabel('Third Principal Component');
% Add a title to the plot
title('3D Scatter Plot of Projected Data');

idx1(2,:)=1;
idx2(2,:)=2;
idx3(2,:)=3;
idx4(2,:)=4;

fcm_idx=zeros(87671,1);
fcm_idx(idx1, 1)=1;
fcm_idx(idx2,1)=2;
fcm_idx(idx3,1)=3;
fcm_idx(idx4,1)=4;


% Load the EEG data into a variable called "eeg"
eeg=pop_loadset('filename', 's02_wk1_1_hp_4sec.set');

eeg=eeg.data;

% Calculate the mean and standard deviation of the signal
mu = mean(eeg);
sigma = std(eeg);

% Compute the z-score of each sample
z = zscore(eeg);

% Find any samples with a z-score greater than 3
spikes = find(z > 3);

% Plot the EEG signal, highlighting the identified spikes in red
plot(eeg());
hold on;
plot(spikes, eeg(spikes), 'r.');

eeg=pop_loadset('filename', 's02_wk1_1_hp.set');

eeg=eeg.data;
% Identify peaks in the signal that are above a threshold of 0.5
[peaks, peak_locations] = findpeaks(eeg(1,:), 'MinPeakHeight', 0.5);

% Plot the original signal and the identified peaks
plot(eeg);
hold on;
plot(peak_locations, peaks, 'ro');





%% Dividing up phenomenology based on high intensity of specific dimensions
high_release=table2array(sample_table(find(sample_table.Release>.85), 5:18));
f=figure
boxplot(high_release, 'Labels', YlabelNames, 'Symbol', '')
title('High Relase Dimension Intensities');
saveas(f, 'release_.85.png')
hr_table= sample_table(find(sample_table.Release>.85), :);
hr_cell=table2cell(hr_table);

%Week 
clstr=hr_cell(:, 2);
clstr=categorical(clstr);
f=figure()
histogram(clstr, 'Normalization','pdf')
title('High Release By Week')
saveas(f, 'release_.85_week.png')

%Condition
clstr=hr_cell(:, 4);
clstr=categorical(clstr);
f=figure()
histogram(clstr, 'Normalization','pdf')
title('High Release By Condition')
saveas(f, 'release_.85_condition.png')

% Subject
clstr=hr_cell(:, 1);
clstr=categorical(clstr);
f=figure()
histogram(clstr, 'Normalization','pdf')
title('High Release By Subject')
saveas(f, 'release_.85_subject.png')

% Spiritual experience
se_table= sample_table(find(sample_table.("Spiritual experience")>.85), :);
figure
boxplot(table2array(se_table(:, 5:18)), 'Labels', YlabelNames, 'Symbol', '')
title('High Spiritual Experience Dimension Intensities');

se_cell=table2cell(se_table);

%Week 
clstr=se_cell(:, 2);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Spiritual Experience By Week')

% Condition
clstr=se_cell(:, 4);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Spiritual Experience By Cluster')

% Subject
clstr=se_cell(:, 1);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Spiritaul Expeirence By Subject')

%Bliss
bliss_table= sample_table(find(sample_table.Bliss>.85), :);
figure
boxplot(table2array(bliss_table(:, 5:18)), 'Labels', YlabelNames, 'Symbol', '')
title('High Bliss Dimension Intensities');

bliss_cell=table2cell(bliss_table);

clstr=bliss_cell(:, 2);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Bliss By Week')

% Condition
clstr=bliss_cell(:, 4);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Bliss By Condition')

% Subject
clstr=bliss_cell(:, 1);
clstr=categorical(clstr);
figure()
histogram(clstr, 'Normalization','pdf')
title('High Bliss By Subject')

idx=strcmpi(bliss_table.Subject, 's07');
s07_cell=bliss_table(idx==1, :)


figure()
for i=1:2
subplot(2,1,i)
    if i==1
    boxplot(cluster_one, 'Symbol', '')
    set(gca, 'XtickLabel', {''})
    title('Dimensions for Cluster One')
    elseif i==2
    boxplot(cluster_two, 'Labels', YlabelNames, 'Symbol','')
    title('Dimensions for Cluster Two')
    end
end
%% Normalising Traces by Participant
subjects = {'s01','s02','s03','s04', 's07', 's08', 's10'};
normalized_data=normalise_TET(all_data_table, subjects);


%% Checking normalisation of data
figure()
for i=1:length(YlabelNames)     
    if i==13|| i==14
        subplot(4,4,i+1)
        hist(all_data(:,i))
        xlabel('Intensity')
    else
        subplot(4,4,i)
        hist(all_data(:,i))
        if i==1 || i==5 || i==9 || i==13
            ylabel('Frequency')
        end
        if i ==9 || i ==12
            xlabel('Intensity')
        end
        title(YlabelNames(i))
    end
end

figure()
for i=1:length(YlabelNames)     
    if i==13|| i==14
        subplot(4,4,i+1)
        hist(all_data(:,i))
    else
        subplot(4,4,i)
        hist(all_data(:,i))
    end
        title(YlabelNames(i))
        xlabel('Intensity')
        ylabel('Frequency')
    end
end

h=[];
p=[];

for i=1:length(YlabelNames)
        [h(i) p(i)]=kstest(all_data(:,i));
end

h
p