function extract_save_weeks(all_data_table, outputpath)

k=ismember(all_data_table.Week, 'week_1');
wk_1=all_data_table(k==1,:);
k=ismember(all_data_table.Week, 'week_2');
wk_2=all_data_table(k==1,:);
k=ismember(all_data_table.Week, 'week_3');
wk_3=all_data_table(k==1,:);
k=ismember(all_data_table.Week, 'week_4');
wk_4=all_data_table(k==1,:);

wk_1_outputfile = [outputpath '\week_1\all_week_1.csv'];
writetable(wk_1_outputfile, 'wk_1')
wk_2_outputfile = [outputpath '\week_2\all_week_2.csv'];
writetable(wk_2_outputfile, 'wk_2')
wk_3_outputfile = [outputpath '\week_3\all_week_3.csv'];
writetable(wk_3_outputfile, 'wk_3')
wk_4_outputfile = [outputpath '\week_4\all_week_4.csv'];
writetable(wk_4_outputfile, 'wk_4')
end
