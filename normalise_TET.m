function normalized_data_cell=normalise_TET(all_data_table, subjects, DMT) 

if strcmpi(DMT, 'Y')
    table_idx=(4:18)
else
    table_idx=(5:18)
end
normalized_data_cell={};

for s=1:length(subjects)
    k=ismember(all_data_table.Subject, subjects{s});
    subject_data = all_data_table(k==1, :);
    %convert to array to normalise
    sub_data_mat=table2array(subject_data(:,table_idx));
    nsd=normalize(sub_data_mat, 'range');
    nsd=array2table(nsd);
    %insert back
    subject_data(:,table_idx)=nsd;
    normalized_data_cell=[normalized_data_cell; subject_data];
end


