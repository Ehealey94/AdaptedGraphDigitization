function count=total_sessions(all_data_table)

% Count number of sessions
idx=strcmp(all_data_table.Session(1:end-1), all_data_table.Session(2:end));
find(~idx);
count=length(ans);

end