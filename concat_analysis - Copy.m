% concatenate all phenomenological data together by week
Directory ='C:\Users\evanl\Documents\TET\';
subject={'s01\', 's02\', 's03\', 's04\', 's07\', 's08\', 's10\', 's11\', 's13\'...
    's14\', 's17\', 's18\', 's19\', 's21\'};
week = {'week_1', 'week_2', 'week_3', 'week_4'};
outputpath=[Directory 'summed\'];
table_names = {'Subject', 'Week', 'Session', 'Condition', 'Meta awareness',...
    'Presence', 'Physical effort','Mental effort','Boredom', 'Receptivity',...
    'Emotional intensity', 'Clarity', 'Release','Bliss', 'Disembodiment', ...
    'Insightfulness', 'Anxiety', 'Spiritual experience', 'fo_lzsum', 'ff_lzsum', ...
    'oo_lzsum', 'global_lzsum', 'fo_lzc', 'ff_lzc', 'oo_lzc', 'global_lzc',...
    'epochs_over_50', 'before_retention', 'after_retention'};
YlabelNames = {'Meta awareness', 'Presence', 'Physical effort','Mental effort',...
    'Boredom', 'Receptivity', 'Emotional intensity', 'Clarity', 'Release',...
    'Bliss', 'Disembodiment', 'Insightfulness', 'Anxiety', 'Spiritual experience'};

% Read the normalized data
all_data_table=readtable('normalized_data_table_28s_with_lz.csv');

%% Extract Phenonemenological Data
sample_length=28;
all_data_cell=extract_data(week, subject, Directory, sample_length);

all_data_table=cell2table(all_data_cell);

% Count total TET sessions
count=total_sessions(all_data_table);

%% Save data for all sessions
all_data_table=cell2table(all_data_cell);
all_data_table.Properties.VariableNames = table_names;
cd(outputpath)
writetable(all_data_table, 'all_data_28s_with_lz.csv');

%Normalize the TET data
DMT='N';
normalized_data_cell=normalise_TET(all_data_table, subject, DMT);
normalized_data_table=normalized_data_cell;
normalized_data_table.Properties.VariableNames = table_names;

%Again saving 
writetable(normalized_data_table, a)


% Extract and save tables of individual weeks
extract_save_weeks(all_data_table, outputpath);

%% Visualising temporal dynamics
extract_temp_dynamics(all_data_cell, week, subject, YlabelNames)



%% Compute correlation coefficients by week

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




%Compute correlation matrices by conditions and week
wk_1_breath_matrix = corrcoef(wk_1_breath);
wk_1_hold_matrix = corrcoef(wk_1_hold);

% Now plot the correlation matrices
% Set [min,max] value of C to scale colors
% This must span the range of your data!
% clrLim = [0,1]; 
% Set the  [min,max] of diameter where 1 consumes entire grid square
diamLim = [0.3, 1];
% Plot the data using imagesc() for later comparison
matrices = {'wk_1_corr', 'wk_2_corr', 'wk_3_corr', 'wk_4_corr'}

figure()
imagesc(spear_corr)
yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14])
yticklabels(YlabelNames)
xticklabels(YlabelNames)
colormap(redblue)
title('Correlation Matrix for All Data')
colorbar()
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
    title(['Week ' m(4)])
    colorbar()
%     caxis(clrLim)
    axis equal 
    axis tight
end

%% Concatenate different conditions

% Initialising all variables
wk_1_breath =[];
wk_1_hold=[];
wk_1_rest=[];
wk_1_intro=[];
wk_1_end=[];

wk_2_breath =[];
wk_2_hold=[];
wk_2_rest=[];
wk_2_intro=[];
wk_2_end=[];

wk_3_breath =[];
wk_3_hold=[];
wk_3_rest=[];
wk_3_intro=[];
wk_3_end=[];
wk_3_fast=[];

wk_4_breath =[];
wk_4_hold=[];
wk_4_rest=[];
wk_4_intro=[];
wk_4_end=[];
wk_4_fast=[]; 

for w=1:length(week)
    for s=1:length(subject)
        wk=week{w};
        part=subject{s};
        inputpath=[Directory part '\' wk '\' 'Digitised\'];
        if exist(inputpath) ==0
            disp(sprintf('No files in %s', inputpath))
            continue
        else
            cd (inputpath)
            files=dir('**\*.mat');
            if w==1 || w==2
                conds={'Breath', 'End', 'Hold', 'Intro', 'Rest'};
            elseif w==3 || w==4
                conds={'Breath', 'End', 'Hold', 'Intro', 'Rest', 'Fast'};
            end
            vars={'breath', 'hold', 'END', 'intro', 'rest', 'fast'};
            clear(vars{:});
            for i=1:length(files)
                load([files(i).folder '\' files(i).name])
                if w==1
                    rs = [0 123]; 
                    re= [21 153]; 
                    br_s= [21 153]; 
                    br_e = [89 221]; 
                    h_s= [89 221]; 
                    h_e = [123 255];  
                    breath = [dimensions(br_s(1):br_e(1)-1, :); dimensions(br_s(2):br_e(2)-1, :)]; %Have to do a minus one 
                    hold = [dimensions(h_s(1):h_e(1)-1, :); dimensions(h_s(2):h_e(2)-1, :)];
                    END = dimensions(h_e(2):end, :);
                    intro = dimensions(1:re(1)-1, :);
                    rest = dimensions(rs(2):re(2)-1, :);
                    sesh=files(i).folder(end-1:end);
                    for c=1:length(conds)
                        cd([outputpath part])
                        mkdir(wk)
                        cd([outputpath part '\' wk])
                        mkdir(conds{c})
                        opf = [outputpath part '\' wk '\' conds{c} '\' sesh '.mat'];
                        if conds{c}=="Breath"
                            save(opf, 'breath');
                        elseif conds{c}=="End"
                            save(opf, 'END');
                        elseif conds{c}=="Hold"
                            save(opf, 'hold');
                        elseif conds{c}=="Intro"
                            save(opf, 'intro');
                        elseif conds{c}=="Rest"
                            save(opf, 'rest');
                        end
                    end
                    wk_1_breath = [wk_1_breath; breath];
                    wk_1_hold = [wk_1_hold; hold];
                    wk_1_end = [wk_1_end; END];
                    wk_1_intro = [wk_1_intro; intro];
                    wk_1_rest = [wk_1_rest; rest];
                elseif w==2
                    r_s = [0 190 345 531]; 
                    r_e = [74 230 396 560]; 
                    br_s = [74 230 396 560];  
                    br_e = [166 306 492 636]; 
                    h_s = [166 306 492]; 
                    h_e = [190 345 531]; 
                    e_s = 636;
                    breath = [dimensions(br_s(1):br_e(1)-1, :); dimensions(br_s(2):br_e(2)-1, :)...
                        ; dimensions(br_s(3):br_e(3)-1,:); dimensions(br_s(4):br_e(4)-1, :)]; 
                    hold = [dimensions(h_s(1):h_e(1)-1, :); dimensions(h_s(2):h_e(2)-1, :)...
                        ; dimensions(h_s(3):h_e(3)-1, :)];
                    END = dimensions(e_s:end, :);
                    intro = dimensions(1:r_e(1)-1, :);
                    rest = [dimensions(r_s(2):r_e(2)-1, :); dimensions(r_s(3):r_e(3)-1, :)...
                        ; dimensions(r_s(4):r_e(4)-1, :)];
                    sesh=files(i).folder(end-1:end);
                    for c=1:length(conds)
                        cd([outputpath part])
                        mkdir(wk)
                        cd([outputpath part '\' wk])
                        mkdir(conds{c})
                        opf = [outputpath part '\' wk '\' conds{c} '\' sesh '.mat'];
                        cd([outputpath part '\' wk])
                        if conds{c}=="Breath"
                            save(opf, 'breath');
                        elseif conds{c}=="End"
                            save(opf, 'END');
                        elseif conds{c}=="Hold"
                            save(opf, 'hold');
                        elseif conds{c}=="Intro"
                            save(opf, 'intro');
                        elseif conds{c}=="Rest"
                            save(opf, 'rest');
                        end
                    end
                    wk_2_breath = [wk_2_breath; breath];
                    wk_2_hold = [wk_2_hold; hold];
                    wk_2_end = [wk_2_end; END];
                    wk_2_intro = [wk_2_intro; intro];
                    wk_2_rest = [wk_2_rest; rest];
                elseif w==3
                    r_s = [0 259 526 706]; %most of the rest is simply the uninstructed portion
                    r_e = [140 268 563 715];
                    br_s = [140 268 389 563];
                    br_e = [220 357 451 630];
                    h_s = [220 357 487 667 810];
                    h_e = [259 389 526 706 858];% If hold is very long in instructions, I'm doing a standardised portion the same as above - 39
                    fb_s = [451 630 715];%faster rate of breathing
                    fb_e = [487 667 810];
                    e_s = [858];
                    breath = [dimensions(br_s(1):br_e(1)-1, :); dimensions(br_s(2):br_e(2)-1, :)...
                        ; dimensions(br_s(3):br_e(3)-1,:); dimensions(br_s(4):br_e(4)-1, :)]; 
                    hold = [dimensions(h_s(1):h_e(1)-1, :); dimensions(h_s(2):h_e(2)-1, :)...
                        ; dimensions(h_s(3):h_e(3)-1, :); dimensions(h_s(4):h_e(4)-1,:); dimensions(h_s(5):h_e(5)-1, :)];
                    END = dimensions(e_s:end, :);
                    intro = dimensions(1:r_e(1)-1, :);
                    rest = [dimensions(r_s(2):r_e(2)-1, :); dimensions(r_s(3):r_e(3)-1, :)...
                        ; dimensions(r_s(4):r_e(4)-1, :)];
                    fast = [dimensions(fb_s(1):fb_e(1)-1, :); dimensions(fb_s(2):fb_e(2)-1, :)...
                        ; dimensions(fb_s(3):fb_e(3)-1, :)];
                    for c=1:length(conds)
                        cd([outputpath part])
                        mkdir(wk)
                        cd([outputpath part '\' wk])
                        mkdir(conds{c})
                        opf = [outputpath part '\' wk '\' conds{c} '\' sesh '.mat'];
                        cd([outputpath part '\' wk])
                        if conds{c}=="Breath"
                            save(opf, 'breath');
                        elseif conds{c}=="End"
                            save(opf, 'END');
                        elseif conds{c}=="Hold"
                            save(opf, 'hold');
                        elseif conds{c}=="Intro"
                            save(opf, 'intro');
                        elseif conds{c}=="Rest"
                            save(opf, 'rest');
                        elseif conds{c}=="Fast"
                            save(opf, 'fast')
                        end
                    end
                    wk_3_breath = [wk_3_breath; breath];
                    wk_3_hold = [wk_3_hold; hold];
                    wk_3_end = [wk_3_end; END];
                    wk_3_intro = [wk_3_intro; intro];
                    wk_3_rest = [wk_3_rest; rest];
                    wk_3_fast = [wk_3_fast; fast];
                elseif w==4
                    r_s = [0 132];
                    r_e = [78 172];
                    br_s = [78 172];
                    br_e = [117 202];
                    h_s = [117 221];
                    h_e = [132 246];
                    fb_s = 202;
                    fb_e = 221;
                    breath = [dimensions(br_s(1):br_e(1)-1, :); dimensions(br_s(2):br_e(2)-1, :)]; 
                    hold = [dimensions(h_s(1):h_e(1)-1, :); dimensions(h_s(2):h_e(2)-1, :)];
                    END = dimensions(h_e(2):end, :);
                    intro = dimensions(1:r_e(1)-1, :);
                    rest = dimensions(r_s(2):r_e(2)-1, :);
                    fast = dimensions(fb_s(1):fb_e(1)-1, :);
                    for c=1:length(conds)
                        cd([outputpath part])
                        mkdir(wk)
                        cd([outputpath part '\' wk])
                        mkdir(conds{c})
                        opf = [outputpath part '\' wk '\' conds{c} '\' sesh '.mat'];
                        cd([outputpath part '\' wk])
                        if conds{c}=="Breath"
                            save(opf, 'breath');
                        elseif conds{c}=="End"
                            save(opf, 'END');
                        elseif conds{c}=="Hold"
                            save(opf, 'hold');
                        elseif conds{c}=="Intro"
                            save(opf, 'intro');
                        elseif conds{c}=="Rest"
                            save(opf, 'rest');
                        elseif conds{c}=="Fast"
                            save(opf, 'fast')
                        end
                    end
                    wk_4_breath = [wk_4_breath; breath];
                    wk_4_hold = [wk_4_hold; hold];
                    wk_4_end = [wk_4_end; END];
                    wk_4_intro = [wk_4_intro; intro];
                    wk_4_rest = [wk_4_rest; rest];
                    wk_4_fast = [wk_4_fast; fast];
                end
            end
        end
    end
end

%save the merged data
for w=1:length(week)
    if w==1 || w==2
        conds={'Breath', 'End', 'Hold', 'Intro', 'Rest'};
    elseif w==3 || w==4
        conds={'Breath', 'End', 'Hold', 'Intro', 'Rest', 'Fast'};
    end
    for c=1:length(conds)
        opf = [outputpath 'all_data\' week{w} '\' conds{c} '_merged.mat'];
        if w==1
            if conds{c}=="Breath"
                save(opf, 'wk_1_breath');
            elseif conds{c}=="End"
                save(opf, 'wk_1_end');
            elseif conds{c}=="Hold"
                save(opf, 'wk_1_hold');
            elseif conds{c}=="Intro"
                save(opf, 'wk_1_intro');
            elseif conds{c}=="Rest"
                save(opf, 'wk_1_rest');
            end
        elseif w==2
            if conds{c}=="Breath"
                save(opf, 'wk_2_breath');
            elseif conds{c}=="End"
                save(opf, 'wk_2_end');
            elseif conds{c}=="Hold"
                save(opf, 'wk_2_hold');
            elseif conds{c}=="Intro"
                save(opf, 'wk_2_intro');
            elseif conds{c}=="Rest"
                save(opf, 'wk_2_rest');
            end
        elseif w==3
            if conds{c}=="Breath"
                save(opf, 'wk_3_breath');
            elseif conds{c}=="End"
                save(opf, 'wk_3_end');
            elseif conds{c}=="Hold"
                save(opf, 'wk_3_hold');
            elseif conds{c}=="Intro"
                save(opf, 'wk_3_intro');
            elseif conds{c}=="Rest"
                save(opf, 'wk_3_rest');
            elseif conds{c}=="Fast"
                save(opf, 'wk_3_fast');
            end
        elseif w==4
            if conds{c}=="Breath"
                save(opf, 'wk_4_breath');
            elseif conds{c}=="End"
                save(opf, 'wk_4_end');
            elseif conds{c}=="Hold"
                save(opf, 'wk_4_hold');
            elseif conds{c}=="Intro"
                save(opf, 'wk_4_intro');
            elseif conds{c}=="Rest"
                save(opf, 'wk_4_rest');
            elseif conds{c}=="Fast"
                save(opf, 'wk_4_fast');
            end
        end
    end
end

%% Concatenating all breath data together
Directory= 'C:\Users\evanl\Documents\TET\summed\all_data\';

%Initialising variables
all_breath=[];
all_end=[];
all_hold=[];
all_intro=[];
all_rest=[];
all_fast=[];

conds={'Breath', 'End', 'Hold', 'Intro', 'Rest', 'Fast'};
for c=1:length(conds)
    cd(Directory)
    files=dir(['**\' conds{c} '*.mat']);
    for i=1:length(files)
        load([files(i).folder '\' files(i).name])
    end
    opf = ['C:\Users\evanl\Documents\TET\summed\all_data\all_weeks\' conds{c} '_merged.mat'];
    if conds{c}=="Breath"
        all_breath=[wk_1_breath; wk_2_breath; wk_3_breath; wk_4_breath];
        save(opf, 'all_breath')
    elseif conds{c}=="End"
        all_end=[wk_1_end; wk_2_end; wk_3_end; wk_4_end];
        save(opf, 'all_end')
    elseif conds{c}=="Hold"
        all_hold=[wk_1_hold; wk_2_hold; wk_3_hold; wk_4_hold];
        save(opf, 'all_hold')
    elseif conds{c}=="Intro"
        all_intro=[wk_1_intro; wk_2_intro; wk_3_intro; wk_4_intro];
        save(opf, 'all_intro')
    elseif conds{c}=="Rest"
        all_rest=[wk_1_rest; wk_2_rest; wk_3_rest; wk_4_rest];
        save(opf, 'all_rest')
    elseif conds{c}=="Fast"
        all_fast=[wk_3_fast; wk_4_fast];
        save(opf, 'all_fast')
    end
end


%% Visualising data for all participants 
load('all_week_1.mat')
YlabelNames = {'Meta awareness', 'Presence', 'Physical effort','Mental effort',...
    'Boredom', 'Receptivity', 'Emotional intensity', 'Clarity', 'Release',...
    'Bliss', 'Disembodiment', 'Insightfulness', 'Anxiety', 'Spiritual experience'};
figure()
boxplot(wk_1_matrix, 'Labels', YlabelNames)
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

bc_xlabelnames=categorical(YlabelNames);

% Plot each condition with mean of intensity of dimension per subject
for c=1:length(Conditions)
    fig=figure('WindowState', 'maximized')
    if c == 1 
        boxplot(all_intro, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title('Dimensions for Start of Session');
    elseif c==2
        boxplot(all_breath, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title(['Dimensions for ' Conditions{c} ' Condition']);
    elseif c==3
        boxplot(all_hold, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title(['Dimensions for ' Conditions{c} ' Condition']);
    elseif c==4
        boxplot(all_rest, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title(['Dimensions for ' Conditions{c} ' Condition']);
    elseif c==5
        boxplot(all_end, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title(['Dimensions for End of Session']);
    elseif c==6
        boxplot(all_fast, 'Labels', YlabelNames, 'Symbol', '')
        for i =1:length(subject)
            hold on
            plot(part_var.(Conditions{c}).(subject{i}), '-o')
        end
        hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
        title(['Dimensions for ' Conditions{c} ' Condition']);
    end
    opf=(['C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.fig\' Conditions{c} '_plus_subject.fig']);
    saveas(fig, opf)
    opf=(['C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.png\' Conditions{c} '_plus_subject.png']);
    saveas(fig, opf)
end

figure()
    boxplot(all_intro, 'Labels', YlabelNames, 'Symbol', '')
    for i =1:length(subject)
        hold on
        plot(part_var.(Conditions{c}).(subject{i}), '-o')
    end
    hLegend = legend(findall(gca,'Tag','Plot'), subject, 'Location','northeastoutside');
    title('Dimensions for Start of Session')


k=ismember(sample_table.Condition, 'Breath');
all_breath=table2array(sample_table(k==1, 5:18));
k=ismember(sample_table.Condition, 'Intro');
all_intro=table2array(sample_table(k==1, 5:18));
k=ismember(sample_table.Condition, 'Hold');
all_hold=table2array(sample_table(k==1, 5:18));
k=ismember(sample_table.Condition, 'Fast');
all_fast=table2array(sample_table(k==1, 5:18));
k=ismember(sample_table.Condition, 'Rest');
all_rest=table2array(sample_table(k==1, 5:18));
k=ismember(sample_table.Condition, 'END');
all_end=table2array(sample_table(k==1, 5:18));

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
% load data
load('C:\Users\evanl\Documents\TET\summed\all_data\all_weeks\all_weeks.mat');
all_data=readtable('C:\Users\evanl\Documents\TET\summed\all_data\all_weeks\all_data.csv');

all_data=cell2mat(all_data_cell(:, 5:18));

all_data=table2array(all_data(:, 5:18));
idx=kmeans(all_data, 2);

cluster_one = all_data(idx==1, :);
cluster_two = all_data(idx==2, :);
cluster_three = all_data(idx==3, :);
cluster_four = all_data(idx==4, :);
cluster_five = all_data(idx==5, :);

% Classifying which condition each cluster is
all_data_cell(:,19)={0};
for i=1:length(all_data_cell)
    all_data_cell{i, 19} = idx(i);
end

Conditions={'Intro', 'Breath', 'Hold', 'Rest', 'End', 'Fast'};

%Visualing each clustes distribution of conditions
for k=1:4
    clstr=all_data_cell(idx==k, 4);
    clstr=categorical(clstr)
    figure()
    histogram(clstr)
    title(['Distribution of Conditions for Cluster ' num2str(k)])
end
%By week
for k=1:4
    clstr=all_data_cell(idx==k, 2);
    clstr=categorical(clstr);
    figure()
    histogram(clstr, 'Normalization','pdf')
    title(['Distribution of Weeks for Cluster ' num2str(k)])
end
%By Subject
for k=1:4
    clstr=all_data_cell(idx==k, 1);
    clstr=categorical(clstr);
    figure()
    histogram(clstr, 'Normalization','pdf')
    title(['Distribution of Subject for Cluster ' num2str(k)])
end



opffig = 'C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.fig\'
opfpng = 'C:\Users\evanl\Documents\TET\summed\visuals\boxplots\.png\'
close all
f=figure('WindowState','maximized')
boxplot(cluster_one, 'Labels', YlabelNames, 'Symbol','')
title('Cluster One')
% saveas(f, ([opffig 'cluster_one_dimensions.fig']));
% saveas(f, ([opfpng 'cluster_one_dimensions.png']));
f=figure('WindowState','maximized')
boxplot(cluster_two, 'Labels', YlabelNames, 'Symbol','')
title('Cluster Two')
% saveas(f, ([opffig 'cluster_two_dimensions.fig']));
% saveas(f, ([opfpng 'cluster_two_dimensions.png']));
figure()
boxplot(cluster_three, 'Labels', YlabelNames, 'Symbol', '')
title('Cluster Three')
figure()
boxplot(cluster_four, 'Labels', YlabelNames, 'Symbol', '')
title('Cluster Four')
figure()
boxplot(cluster_five, 'Labels', YlabelNames, 'Symbol', '')
title('Cluster Five')


eva=evalclusters(table2array(normalized_data_cell(:, 5:18)), 'kmeans', 'CalinskiHarabasz', 'KList', 2:6) %2
eva=evalclusters(all_data, 'kmeans', 'CalinskiHarabasz', 'KList', 2:6) % also 2

eva=evalclusters(all_data, 'kmeans', 'DaviesBouldin', 'KList', 2:8) %2
eva=evalclusters(all_data, 'kmeans', 'gap', 'KList', 2:8) %too much computation
eva=evalclusters(all_data, 'kmeans', 'silhouette', 'KList', 2:8) %took too long

eva=evalclusters(all_data, 'gmdistribution', 'CalinskiHarabasz', 'KList', 1:6)


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
data=all_data;

% Perform the PCA
[coeff, score, latent] = pca(data);
% Extract the principal components
principal_components = coeff(:, 1:3);
% Project the data onto the principal components
projected_data = data * principal_components;
% Visualize the projected data, and labelling k-means
figure()
scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], idx);


% % Visualise projected data and labelling participant
% subs=categorical(sample_table.Subject);
% scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], subs);
% %Visualise projected data and labelling fuzzy c-means
% figure()
% scatter3(projected_data(:,1), projected_data(:,2), projected_data(:,3), [], fcm_idx);
% Add labels to the axes
xlabel('First Principal Component');
ylabel('Second Principal Component');
zlabel('Third Principal Component');
% Add a title to the plot
title('3D Scatter Plot of Projected Data');

% Find the highest 3 coefficients for each PC
PC_3coeff=coeff(:, 1:3);
PC_3coeff=abs(PC_3coeff);
max(PC_3coeff(:,1))

xlabel('Bliss, Clarity, Spiritual Exp')
ylabel('Physical Effort, Mental Effort, Anxiety')
zlabel('Disembodiment, Meta-Awareness, -Spiritual Exp')


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

normalized_data_cell={};

for s=1:length(subjects)
    sub=subjects{s}
    idx=strcmpi(all_data_table.Subject, sub);
    subject_data = all_data_table(idx==1, :);
    normalize(subject_data(:, 5:18), 'range');
    normalized_data_cell=[normalized_data_cell; subject_data];
end

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
p=[]

for i=1:length(YlabelNames)
        [h(i) p(i)]=kstest(all_data(:,i));
end

h
p