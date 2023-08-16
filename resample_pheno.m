% function to interpolate the pheno data to 28s
function resample_pheno(week, subject, sample_length)


%Delete this when applying to all
sample_length=28

% Computing lengths for each  
wk1l=(week_length('week_1')*4)/sample_length;
wk2l=(week_length('week_2')*4)/sample_length;
wk3l=(week_length('week_3')*4)/sample_length;
wk4l=(week_length('week_4')*4)/sample_length;

%Putting in cell
wk_lengths={wk1l, wk2l, wk3l, wk4l}
leftovers={}


%Rounding and extracting difference
for i=1:length(wk_lengths)
    wl=wk_lengths{i};
    new_wl=floor(wl)
    leftovers{i}=wl-new_wl
    wk_lengths{i}=new_wl
end

interp_meth='spline';

subject={'s01\', 's02\', 's03\', 's04\', 's07\', 's08\', 's10\', 's11\', 's13\'...
    's14\', 's17\', 's18\', 's19\', 's21\'};
Directory='C:\Users\evanl\Documents\TET\';

for w=1:length(week)
    for s=1:length(subject)
        wk=week{w};
        part=subject{s};
        inputpath=[Directory part '\' wk '\' 'Digitised\'];
        if exist(inputpath) ==0
            disp(sprintf('No files in %s', inputpath))
            continue
        else
            cd(inputpath)
            disp(sprintf('processing files for %s', inputpath))
            files=dir('**\*.mat')
            for i=1:length(files)
                d_res=[];
                load([files(i).folder '\' files(i).name])
                idx=1:length(dimensions);
                int_vec=linspace(min(idx), max(idx), wk_lengths{w})
                for d=1:width(dimensions)
                    d_res(:,d)=interp1(dimensions(:,d), int_vec, interp_meth)
                end
                dimensions=d_res;
                filename=['28s_' files(i).name]
                save([files(i).folder '\' filename], "dimensions")
            end
        end
    end
end



% figure()
% tcl=tiledlayout(5,6)
% for i=1:width(dimensions)
%     nexttile(tcl)
%     plot(dimensions(:,i))
%     xlim([0 length(dimensions)])
%     ylim([0 1])
%     set(gca, 'XTickLabel', []);
%     title(['Original ' YlabelNames{i}])
%     nexttile(tcl)
%     plot(d_res(:,i), 'r')
%     xlim([0 length(d_res)])
%     ylim([0 1])
%     set(gca, 'XTickLabel', []);
%     title(['Resampled ' YlabelNames{i}])
% end
% 
% d=load('28s__dimensionsdata.mat')
% 
