function extract_temp_dynamics(all_data_cell, week, subject, YlabelNames)

field =["MA", "Prsnc", "Physeff","Meneff","Brdm", "Recep",...
   "Em_in", "Clrty", "Rls","Bls", "Disem", "Insght", "Anx", "Spexp"];
    
    temp_dyn.week_1 = struct(field(1), [], field(2), [], field(3), [], field(4), [],...
        field(5), [], field(6), [], field(7), [], field(8), [], field(9), [], field(10), [],...
        field(11), [], field(12), [], field(13), [], field(14), []);
    temp_dyn.week_2 = temp_dyn.week_1;
    temp_dyn.week_3 = temp_dyn.week_1;
    temp_dyn.week_4 = temp_dyn.week_1;

wk = fieldnames(temp_dyn)
fn = fieldnames(temp_dyn.week_1)

for i=1:length(fn)
    for w=1:length(week)
        for s=1:length(subject)
            dispose = [];
            for a = 1:length(all_data_cell)
                if strcmpi(all_data_cell{a, 2}, wk{w}) && strcmpi(all_data_cell{a, 1}, subject{s})
                    dispose = [dispose; all_data_cell{a, (i+4)}];
                else
                    continue
                end
            end
                temp_dyn.(wk{w}).(fn{i})=[temp_dyn.(wk{w}).(fn{i}); dispose];
        end
        n_epochs = week_length(week{w})
        temp_dyn.(wk{w}).(fn{i})=reshape(temp_dyn.(wk{w}).(fn{i}), n_epochs, [])
    end
end

%% Plot with standard deviation
for w=1:length(week)
    figure()
    tcl=tiledlayout(4,4)
    for i=1:length(fn)
        if i==4
            if w==1
                lgd=legend('','','Breath', '', 'Hold', '');
            elseif w==2
                lgd=legend('','','Breath', '','','', 'Hold','','');
            elseif w==3 
                lgd=legend('','','Breath', '','','', 'Hold','','', '','', 'Fast', '', '');
            elseif w==4
                lgd=legend('','','Breath', '', 'Hold','', 'Fast');
            end
            lgd.Layout.Tile = 4;
            lgd.FontSize = 15; 
            nexttile(tcl)
            stdshade_acj(temp_dyn.(wk{w}).(fn{i})', 0.2, 'b')
            n_epochs = week_length(week{w});
            xlim([0 n_epochs]);
            ylim([0 1]);
            title(YlabelNames{i})
            if w==1
                breath=[21 153];
                hold=[89 221];
                br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
                hold_line=xline(hold, '-.r', 'LineWidth', 1);
            elseif w==2
                breath=[74 230 396 560];
                hold=[166 306 492];
                br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
                hold_line=xline(hold, '-.r', 'LineWidth', 1);
            elseif w==3
                breath=[140 268 389 563];
                hold=[220 357 487 667 810];
                fast = [451 630 715];
                br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
                hold_line=xline(hold, '-.r', 'LineWidth', 1);
                fast_line=xline(fast, '-.', 'LineWidth', 1, 'Color', [0.9290 0.6940 0.1250]);
            elseif w==4
                breath=[78 172];
                hold=[117 221];
                fast=[202];
                br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
                hold_line=xline(hold, '-.r', 'LineWidth', 1);
                fast_line=xline(fast, '-.', 'LineWidth', 1, 'Color', [0.9290 0.6940 0.1250]);
            end
        else
        nexttile(tcl)
        stdshade_acj(temp_dyn.(wk{w}).(fn{i})', 0.2, 'b')
        n_epochs = week_length(week{w});
        xlim([0 n_epochs]);
        ylim([0 1]);
        title(YlabelNames{i})
        if w==1
            breath=[21 153];
            hold=[89 221];
            br_line=xline(breath, '-.g', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);%, Name, {'Breath'});
            hold_line=xline(hold, '-.r', 'LineWidth', 1)%, {'Hold'});
        elseif w==2
            breath=[74 230 396 560];
            hold=[166 306 492];
            br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
            hold_line=xline(hold, '-.r', 'LineWidth', 1);
        elseif w==3
            breath=[140 268 389 563];
            hold=[220 357 487 667 810];
            fast = [451 630 715];
            br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
            hold_line=xline(hold, '-.r', 'LineWidth', 1);
            fast_line=xline(fast, '-.', 'LineWidth', 1, 'Color', [0.9290 0.6940 0.1250]);
        elseif w==4
            breath=[78 172];
            hold=[117 221];
            fast=[202];
            br_line=xline(breath, '-.', 'LineWidth', 1, 'Color', [0.4660 0.6740 0.1880]);
            hold_line=xline(hold, '-.r', 'LineWidth', 1);
            fast_line=xline(fast, '-.', 'LineWidth', 1, 'Color', [0.9290 0.6940 0.1250]);
        end
        end
    end
%     sgtitle(['Temporal Dynamics of Week ' num2str(w)]) 
%     opf= (['C:\Users\evanl\Documents\TET\summed\visuals\temporal_dynamics\.fig\' week{w} '_STD_Labels.fig']);
%     saveas(tcl, opf)
%     opf= (['C:\Users\evanl\Documents\TET\summed\visuals\temporal_dynamics\.png\' week{w} '_STD_Labels.png']);
%     saveas(tcl, opf)
end
