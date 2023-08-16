function all_data_cell=extract_data(week, subject, Directory, sample_length)

div=sample_length/4;

%Initialise table/cell?
all_data_cell={};

%Complexity path
complexity_directory='C:\Users\evanl\Documents\Dreem_Pilot\';

fnames={'fo_chans', 'ff_chans', 'oo_chans', 'glob_chans', 'epochs_over_50'};



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
            disp(sprintf('processing files for %s', inputpath))
            if sample_length == 28
                files=dir('**\28s*.mat');
            else
                files=dir('**\*.mat');
            end
            for i=1:length(files)
                load([files(i).folder '\' files(i).name])
                sample_cell=cell(length(dimensions), 27);
                sesh=files(i).folder(end-1:end);
                sample_cell(:, 1) = {part}; % Subject
                sample_cell(:, 2) = {wk}; % Week
                sample_cell(:,3) = {['run_' sesh]};
                sample_cell(:, 5:18)=num2cell(dimensions);

                %% Adding in for neural complexity
                clear padded_lzc;
                clear padded_lzsum;
                complexity_inputpath=[complexity_directory part '\' wk '\' '17-LZ\'];

                wkstr=num2str(w);
                seshstr=num2str(sesh);
                newlength=week_length(complexity_inputpath);
                try
                    load([complexity_inputpath part(1:3) '_wk' wkstr '_' seshstr(2) '_4secs_padded_lzc.mat']);
                    load([complexity_inputpath part(1:3) '_wk' wkstr '_' seshstr(2) '_4secs_padded_lzsum.mat']);
                catch
%                     'No complexity data, adding in NaNs'
                    sample_cell(:,19:27)={NaN};
                end
                
                try %Again trying to add in the complexity data
                    %For loop to add in complexity measures
                    for i=1:length(sample_cell)
                        idx=1:7:newlength;
                        start_idx=idx(i);
                        end_idx=idx(i+1)-1;
                        for k=19:22 % These are the column numbers for the data_cell
                            sample_cell{i,k}=nanmedian(padded_lzsum.(fnames{k-18})(start_idx:end_idx,1));
                        end
                        for k=23:26
                            sample_cell{i,k}=nanmedian(padded_lzc.(fnames{k-22})(start_idx:end_idx,1)); 
                        end
                        for k=27
                            sample_cell{i,k}=padded_lzsum.epochs_over_50;
                        end
                    end
                catch
%                     ['Does not work for ' part wk ' session ' seshstr]
                end

                %% Adding in section for accelerometer 
                resp_inpath=[complexity_directory part '\' wk '\' '18-SD_acc\'];
                
                %Trying to load accelerometery dataset
                try
                    load([resp_inpath part(1:3) '_wk' wkstr '_' seshstr(2) '.mat']);
                    sample_cell(:,28)=num2cell(acc_info.before_retention);
                    sample_cell(:,29)=num2cell(acc_info.after_retention);
                    % This shifts the after retention epochs forward if they overlap
                    for j=1:length(sample_cell)
                        plus_sc = cell2mat(sample_cell(j,28)) + cell2mat(sample_cell(j,29));
                        if ~mod(plus_sc,2) && plus_sc > 0 && cell2mat(sample_cell(j,28)) ~= 0 ...
                            && cell2mat(sample_cell(j,29)) ~=0
                            sample_cell(j,29) = {0};
                            sample_cell(j+1, 29) = sample_cell(j, 28);
                        end
                    end
                catch
                    sample_cell(:,28:29)={NaN};
                    ['Could not load ' part(1:3) ' Week ' wkstr ' Session ' seshstr(2)]
                end
                
                %% Adding in information for phenomenological epoch
                if w==1
                    r_s = [0 123]; 
                    r_e= [21 153]; 
                    br_s= [21 153]; 
                    br_e = [89 221]; 
                    h_s= [89 221]; 
                    h_e = [123 255];  
                    % Editing for 28s interpolation of phenomenology
                    if sample_length==28
                        r_s=round(r_s/7);
                        r_e=round(r_e/7);
                        br_s=round(br_s/7);
                        br_e=round(br_e/7);
                        h_s=round(h_s/7);
                        h_e=round(h_e/7);
                    end
                    for i = 1:length(dimensions)
                        if i >= 1 && i < r_e(1)
                            sample_cell(i, 4) = {'Intro'}; 
                        elseif i >= r_s(2) && i < r_e(2)
                            sample_cell(i, 4) ={'Rest'};
                        elseif (i >= h_s(1) && i < h_e(1)) || (i >= h_s(2) && i < h_e(2))
                            sample_cell(i,4) ={'Hold'};
                        elseif (i >= br_s(1) && i < br_e(1)) || (i >= br_s(2) && i < br_e(2))
                            sample_cell(i, 4)={'Breath'};
                        elseif i >=h_e(2) && i <= length(dimensions)
                            sample_cell(i, 4)={'END'};
                        end
                    end
                    all_data_cell=[all_data_cell; sample_cell];
                elseif w==2
                    r_s = [0 190 345 531]; 
                    r_e = [74 230 396 560]; 
                    br_s = [74 230 396 560];  
                    br_e = [166 306 492 636]; 
                    h_s = [166 306 492]; 
                    h_e = [190 345 531]; 
                    e_s = 636;
                    if sample_length==28
                        r_s=round(r_s/7);
                        r_e=round(r_e/7);
                        br_s=round(br_s/7);
                        br_e=round(br_e/7);
                        h_s=round(h_s/7);
                        h_e=round(h_e/7);
                        e_s=round(e_s/7);
                    end
                    for i = 1:length(dimensions)
                        if i >= 1 && i < r_e(1)
                            sample_cell(i, 4) = {'Intro'}; %Need to figure out what to put here
                        elseif (i >= r_s(2) && i < r_e(2)) || (i >= r_s(3) && i < r_e(3)) ...
                                || (i >= r_s(4) && i < r_e(4))
                            sample_cell(i, 4) ={'Rest'};
                        elseif (i >= h_s(1) && i < h_e(1)) || (i >= h_s(2) && i < h_e(2)) ...
                                || (i >= h_s(3) && i < h_e(3))
                            sample_cell(i,4) ={'Hold'};
                        elseif (i >= br_s(1) && i < br_e(1)) || (i >= br_s(2) && i < br_e(2)) || ...
                                (i >= br_s(3) && i < br_e(3)) || (i >= br_s(4) && i < br_e(4))
                            sample_cell(i, 4)={'Breath'};
                        elseif i >= e_s && i <= length(dimensions)
                            sample_cell(i, 4)={'END'};
                        end
                    end
                    all_data_cell=[all_data_cell; sample_cell];
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
                    if sample_length==28
                        r_s=round(r_s/7);
                        r_e=round(r_e/7);
                        br_s=round(br_s/7);
                        br_e=round(br_e/7);
                        h_s=round(h_s/7);
                        h_e=round(h_e/7);
                        fb_s=round(fb_s/7);
                        fb_e=round(fb_e/7);
                        e_s=round(e_s/7);
                    end
                    for i = 1:length(dimensions)
                        if i >= 1 && i < r_e(1)
                            sample_cell(i, 4) = {'Intro'}; %Need to figure out what to put here
                        elseif (i >= r_s(2) && i < r_e(2)) || (i >= r_s(3) && i < r_e(3)) ...
                                || (i >= r_s(4) && i < r_e(4))
                            sample_cell(i, 4) ={'Rest'};
                        elseif (i >= h_s(1) && i < h_e(1)) || (i >= h_s(2) && i < h_e(2)) ...
                                || (i >= h_s(3) && i < h_e(3)) || (i >= h_s(4) && i < h_e(4)) || ...
                                (i >= h_s(5) && i < h_e(5))
                            sample_cell(i,4) ={'Hold'};
                        elseif (i >= br_s(1) && i < br_e(1)) || (i >= br_s(2) && i < br_e(2)) || ...
                                (i >= br_s(3) && i < br_e(3)) || (i >= br_s(4) && i < br_e(4))
                            sample_cell(i, 4)={'Breath'};
                        elseif (i >= fb_s(1) && i < fb_e(1)) || (i >= fb_s(2) && i < fb_e(2)) ||...
                                (i >= fb_s(3) && i < fb_e(3))
                            sample_cell(i, 4)={'Fast'};
                        elseif i >= e_s && i <= length(dimensions)
                            sample_cell(i, 4)={'END'};
                        end
                    end
                    all_data_cell=[all_data_cell; sample_cell];
                elseif w==4
                    r_s = [0 132];
                    r_e = [78 172];
                    br_s = [78 172];
                    br_e = [117 202];
                    h_s = [117 221];
                    h_e = [132 246];
                    fb_s = 202;
                    fb_e = 221;
                    e_s = 246;
                    if sample_length==28
                        r_s=round(r_s/7);
                        r_e=round(r_e/7);
                        br_s=round(br_s/7);
                        br_e=round(br_e/7);
                        h_s=round(h_s/7);
                        h_e=round(h_e/7);
                        fb_s=round(fb_s/7);
                        fb_e=round(fb_e/7);
                        e_s=round(e_s/7);
                    end
                    for i = 1:length(dimensions)
                        if i >= 1 && i < r_e(1)
                            sample_cell(i, 4) = {'Intro'}; %Need to figure out what to put here
                        elseif (i >= r_s(2) && i < r_e(2)) 
                            sample_cell(i, 4) ={'Rest'};
                        elseif (i >= h_s(1) && i < h_e(1)) || (i >= h_s(2) && i < h_e(2)) 
                            sample_cell(i,4) ={'Hold'};
                        elseif (i >= br_s(1) && i < br_e(1)) || (i >= br_s(2) && i < br_e(2)) 
                            sample_cell(i, 4)={'Breath'};
                        elseif (i >= fb_s(1) && i < fb_e(1)) 
                            sample_cell(i, 4)={'Fast'};
                        elseif i >= e_s && i <= length(dimensions)
                            sample_cell(i, 4)={'END'};
                        end
                    end
                    all_data_cell=[all_data_cell; sample_cell];
                end
            end
        end
    end
end
