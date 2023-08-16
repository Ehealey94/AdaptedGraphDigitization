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