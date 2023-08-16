function pc_struct=princ_comp_plot(all_data_table, subject, week)


%lighter colours
blue = [114 147 203]./255;
% red = [211 94 96]./255;
black = [128 133 133]./255;
% green = [132 186 91]./255;
brown = [171 104 87]./255;
% purple = [144 103 167]./255;
yellow = [0.9290 0.6940 0.1250];

%Darker colours
purple = [107 76 154]./255;
red = [204 37 41]./255;
green = [62 150 81]./255;

colours={blue, black, brown, purple, green, red, yellow};

data=table2array(all_data_table(:,5:18));

% Perform the PCA
[coeff, score, latent] = pca(data);
% Extract the principal components
principal_components = coeff(:, 1:3);
% Project the data onto the principal components
projected_data = data * principal_components;


pc_struct=struct('s01', [], 's02', [], 's03', [], 's04', [], 's07', [], 's08', [], 's10', []);
pc_struct.s01=struct('week_1', [], 'week_2', [], 'week_3', [], 'week_4', []);
pc_struct.s02=pc_struct.s01;
pc_struct.s03=pc_struct.s01;
pc_struct.s04=pc_struct.s01;
pc_struct.s07=pc_struct.s01;
pc_struct.s08=pc_struct.s01;
pc_struct.s10=pc_struct.s01;

%Extract by subject
for w=1:length(week)
    for s=1:length(subject)
        dispose=[];
        sub=ismember(all_data_table.Subject, subject{s});
        k=ismember(all_data_table.Week, week{w});
        dispose=projected_data(k==1 & sub==1, :);
        pc_struct.(subject{s}).(week{w})=dispose;
    end
%         n_epochs = week_length(week{w});
%         pc_struct.(subject{s}).(week{w})=reshape(pc_struct.(subject{s}).(week{w}), [], 3);
end

%Corr coeff for subject


% Creating subject figures
figure()
tcl=tiledlayout(2,2)
for w=1:length(week)
    n_epochs=week_length(week{w});
    nexttile(tcl)
    for s=1:length(subject)
        n_sesh=length(pc_struct.(subject{s}).(week{w}))/(week_length(week{w}))
        for i=1:n_sesh
            st_idx=(i*n_epochs)-1-n_epochs;
            end_idx=i*n_epochs;
            if i==1 && s==1
                line_1=plot3(pc_struct.(subject{s}).(week{w})(1:n_epochs,1), pc_struct.(subject{s}).(week{w})(1:n_epochs,2), pc_struct.(subject{s}).(week{w})(1:n_epochs,3));
            elseif i==1 && s~=1
                hold on 
                line_1=plot3(pc_struct.(subject{s}).(week{w})(1:n_epochs,1), pc_struct.(subject{s}).(week{w})(1:n_epochs,2), pc_struct.(subject{s}).(week{w})(1:n_epochs,3));
            elseif i>1
                hold on
                line_1=plot3(pc_struct.(subject{s}).(week{w})(st_idx:end_idx,1), pc_struct.(subject{s}).(week{w})(st_idx:end_idx,2), pc_struct.(subject{s}).(week{w})(st_idx:end_idx,3));
                title(sprintf("Week %s", num2str(w)))
            end
            line_1.Color=colours{s};
        end
    end
    if w==4
        lgd=legend('Subject 1', 'Subject 2', 'Subject 3', 'Subject 4', 'Subject 5', 'Subject 6', 'Subject 7');
        lgd.Position('East')
    end
end

figure()
tcl=tiledlayout(2,2)
for w=1:length(week)
    n_epochs=week_length(week{w});
    nexttile(tcl)
    for s=1:length(subject)
        n_sesh=length(pc_struct.(subject{s}).(week{w}))/(week_length(week{w}))
        for i=1:n_sesh
            st_idx=(i*n_epochs)-1-n_epochs;
            end_idx=i*n_epochs;
            if i==1 && s==1
                line_1=plot3(pc_struct.(subject{s}).(week{w})(1:n_epochs,1), pc_struct.(subject{s}).(week{w})(1:n_epochs,2), pc_struct.(subject{s}).(week{w})(1:n_epochs,3));
            elseif i==1 && s~=1
                hold on 
                line_1=plot3(pc_struct.(subject{s}).(week{w})(1:n_epochs,1), pc_struct.(subject{s}).(week{w})(1:n_epochs,2), pc_struct.(subject{s}).(week{w})(1:n_epochs,3));
            elseif i>1
                hold on
                line_1=plot3(pc_struct.(subject{s}).(week{w})(st_idx:end_idx,1), pc_struct.(subject{s}).(week{w})(st_idx:end_idx,2), pc_struct.(subject{s}).(week{w})(st_idx:end_idx,3));
                title(sprintf("Week %s", num2str(w)))
            end
            line_1.Color=colours{s};
        end
    end
    if w==4
        lgd=legend('Subject 1', 'Subject 2', 'Subject 3', 'Subject 4', 'Subject 5', 'Subject 6', 'Subject 7');
        lgd.Position('East')
    end
end




% Something to look at: the distance metric within each weeks

dist_met_cell={};
for w=1:length(week)
    n_epochs=week_length(week{w});
    for s=1:length(subject)
        n_sesh=length(pc_struct.(subject{s}).(week{w}))/(week_length(week{w}))
        dispose={};
        for i=1:n_sesh
            st_idx=(i*n_epochs)-1-n_epochs
            end_idx=i*n_epochs
            if i==1
                A=pc_struct.(subject{s}).(week{w})(1, :);
                B=pc_struct.(subject{s}).(week{w})(n_epochs, :);
            elseif i>1
                A=pc_struct.(subject{s}).(week{w})(st_idx, :);
                B=pc_struct.(subject{s}).(week{w})(end_idx, :);
            end
            % Euclidean distance between end and start
            dispose{i,1}=week{w};
            dispose{i,2}=subject{s};
            dispose{i,3}=i;
            dispose{i,4}=norm(B-A);
        end
        dist_met_cell=[dist_met_cell; dispose]
    end
end

idx=[];
dist_met_cell=sortrows(dist_met_cell, 2);
for i=1:length(dist_met_cell)-1
    if contains(dist_met_cell(i,2), dist_met_cell(i+1,2))
        continue
    elseif contains(dist_met_cell(i,2), dist_met_cell(i+1,2))==0
        idx=[idx, i]
    end
end


figure()
distance_vec=cell2mat(dist_met_cell(:,4))
imagesc(distance_vec)
%For weeks
% yline(43, 'Color', 'r', 'Label', 'Week 1')
% yline(83, 'Color', 'r', 'Label', 'Week 2')
% yline(122, 'Color', 'r', 'Label', 'Week 3')
% yline(154, 'Color', 'r', 'Label', 'Week 4')
% For subjects
for i =1:length(idx)
    yline(idx, 'Color', 'g', 'Label', subject{i})
end
yline(154, 'Color', 'g', 'Label', subject{end})
% line_y=yline([idx, 154], 'Color', 'g')
colorbar()
colormap(redblue)
title("Sorted by Subjects")

subject_sort=sortrows(dist_met_cell, 2)

distance_vec=horzcat(cell2mat(dist_met_cell(1:154,4)), cell2mat(subject_sort(1:154, 4)));

figure()
imagesc(distance_vec)
yline(43, 'Color', 'r', 'Label', 'Week 1')
yline(83, 'Color', 'r', 'Label', 'Week 2')
yline(122, 'Color', 'r', 'Label', 'Week 3')
yline(154, 'Color', 'r', 'Label', 'Week 4')
colorbar()
colormap("jet")





        
