%% Combine the y values for each dimension
% Sort the tracing files so that:
% Directory/Participant/Session/dim.jpg
clear all
Directory='C:\Users\evanl\Documents\TET\';
Participant='s14\';
Week='week_4\'%, 'week_2\', 'week_3\', 'week_4\'};
Session='02\'%, '02\', '03\', '04\', '05\', '06\', '07\'}; 

inputpath=[Directory Participant Week]
outputpath=[Directory Participant Week 'Digitised\' Session];
mkdir(outputpath) %uncomment the first time to make the output directory
cd (inputpath)
mkdir('start_times')


%% Powerpoint into jpeg 
width=1440;
height=900;
destination=['C:\Users\evanl\Documents\TET\' Participant Week '07'];
mkdir(destination)
filename=[erase(Week, '\'), '_session_', Session(2), '.pptx']

ppt2image(filename, width, height, destination, 'jpg');

%% Renaming jpeg files
% Below for s10 and under
inputpath= [Directory Participant Week Session]
% outputpath = [inputpath '\Digitised\'];
% mkdir(outputpath)
cd(inputpath)

%and below for s11 and over
%use destination
cd(destination)

files=dir('*.jpg');

% %Deleting redundant slides
% for i=[17 1]
%     delete(files(i).name)
% end

%Moving start_time slide
% newname=['Session_' Session(1:2) '.jpg'];
% stt_dest=[inputpath 'start_times\'];
% movefile("Slide02.JPG", [stt_dest newname])

files=dir('*.jpg');

%double checking they've been loaded correctly - should be bliss, and
%week_4 should be receptivity
figure;
imshow(files(2).name)
if contains(inputpath, "week_4")
    figure;
    imshow(files(11).name)
end



% This is because scanner uploads 1 rather than 01, hence different order
dimnames={'01_meta_awareness','10_bliss', '11_disembodiment', '12_insightfulness',...
    '13_anxiety', '14_spiritual_experience' '02_distraction', '03_physical_effort','04_mental_effort',...
    '05_boredom', '06_receptivity', '07_emotional_intensity', '08_clarity', '09_release'};

%For jpegs of s01-s10 
% if str2num(Participant(2:3)) <=10 || str2num(Participant(2:3)) == 14
%     dimnames={'08_clarity', '09_release','10_bliss', '11_disembodiment', '12_insightfulness',...
%         '13_anxiety', '14_spiritual_experience','01_meta_awareness', '02_distraction', ...
%         '03_physical_effort','04_mental_effort','05_boredom', '06_receptivity', '07_emotional_intensity'};
% elseif str2num(Participant(2:3)) > 10 || str2num(Participant(2:3)) ~= 14
%     dimnames={'01_meta_awareness', '02_distraction','03_physical_effort','04_mental_effort','05_boredom',...
%         '06_receptivity', '07_emotional_intensity', '08_clarity', '09_release','10_bliss', '11_disembodiment',...
%         '12_insightfulness', '13_anxiety', '14_spiritual_experience'};
% end



if length(files)<14
    fprintf('\n!!!!!!!!!!!INCOMPLETE DIMENSIONS - DO NOT PREPROCESS!!!!!!!!!! \n')
elseif length(files)==14 
    %rename files
    for i=1:length(files)
        newname=strcat(dimnames{i}, '.jpg');
        movefile(files(i).name, newname);
    end
end

%% For loop to rename files

Sesh={'01\','02\'}; 

for i=1:length(Sesh)
    Session = Sesh{i};
    inputpath= [Directory Participant Week Session]
    cd(inputpath)
    files=dir('*.jpg');

    dimnames={'01_meta_awareness','10_bliss', '11_disembodiment', '12_insightfulness',...
    '13_anxiety', '14_spiritual_experience' '02_distraction', '03_physical_effort','04_mental_effort',...
    '05_boredom', '06_receptivity', '07_emotional_intensity', '08_clarity', '09_release'};

    if length(files)<14
        fprintf('\n!!!!!!!!!!!INCOMPLETE DIMENSIONS - DO NOT PREPROCESS!!!!!!!!!! \n')
    elseif length(files)==14 
        %rename files
        for i=1:length(files)
            newname=strcat(dimnames{i}, '.jpg');
            movefile(files(i).name, newname);
        end
    end
end


%% Alternative for loop to turn powerpoints into jpegs
Wk={'week_1\', 'week_2\', 'week_3\', 'week_4\'};
Sesh={'01\', '02\', '03\', '04\', '05\', '06\', '07\'}; 

for w=1:length(Wk)
    Week=Wk{w};
    cd([Directory Participant Week])
    files=dir('*.pptx')
    for s=1:length(files)
        Session=Sesh{s};
        inputpath=[Directory Participant Week];
        outputpath=[Directory Participant Week 'Digitised\' Session];
        mkdir(outputpath) %uncomment the first time to make the output directory
        cd (inputpath)
        mkdir('start_times')


        %% Powerpoint into jpeg 
        width=1440;
        height=900;
        destination=['C:\Users\evanl\Documents\TET\' Participant Week Session(1:2)];
        mkdir(destination)
        filename=[erase(Week, '\'), '_session_', Session(2), '.pptx']
        if exist(filename) ~=2
            continue
        end
        
        try
        ppt2image(filename, width, height, destination, 'jpg');
        catch
            disp([Week Session ' does not exist, continuing...'])
            continue
        end

        %% Renaming jpeg files
        cd(destination)
        
        files=dir('*.jpg');
        
        %Deleting redundant slides
        for i=[17 1]
            delete(files(i).name)
        end
        
        %Moving start_time slide
        newname=['Session_' Session(1:2) '.jpg'];
        stt_dest=[inputpath 'start_times\'];
        movefile("Slide02.JPG", [stt_dest newname])
        
        %Load filenames again 
        files=dir('*.jpg');
        
        dimnames={'01_meta_awareness', '02_distraction','03_physical_effort','04_mental_effort','05_boredom',...
                '06_receptivity', '07_emotional_intensity', '08_clarity', '09_release','10_bliss', '11_disembodiment',...
                '12_insightfulness', '13_anxiety', '14_spiritual_experience'};
        
        if length(files)<14
            fprintf('\n!!!!!!!!!!!INCOMPLETE DIMENSIONS - DO NOT PREPROCESS!!!!!!!!!! \n')
        elseif length(files)==14 
            %rename files
            for i=1:length(files)
                newname=strcat(dimnames{i}, '.jpg');
                movefile(files(i).name, newname);
            end
        end
    end
end

%% Change path for specific session
    
%% Loop for Session Digitization
Wk={'week_1\', 'week_2\', 'week_3\', 'week_4\'}
Sesh={'01\','02\', '03\', '04\', '05\', '06\', '07\'};

for w=4%:length(Wk)
    Week=Wk{w};
    cd([Directory Participant Week])
%     files=dir('*.pptx')
    for s=1:length(Sesh)
    Session=Sesh{s}
    inputpath=[Directory Participant Week];
    cd([inputpath '/' Session])
    outputpath=[Directory Participant Week 'Digitised\' Session];
    mkdir(outputpath);

    %load the outputfile if it exists already
    outputfile=[outputpath '_dimensionsdata.mat'];
    
    if exist (outputfile)~=0
        load (outputfile);
        zer=find (dimensions(1,:)==0)
    else
        dimensions=[];
    end


%% Read the Graph and specify how many datapoints you want per graph
%Set this to match the number of epochs of each session
%Reload files again with newnames
files=dir('*.jpg');

n_epochs=week_length(inputpath)

for f= 1:length(files)        
         try
            close all
            y=digitize_graph_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
            dimensions(:,f)=y;
            disp(files(f).name)            
         catch
             disp (['couldnt digitise ' files(f).name ', attempting again with cropped image'])
% %             
             
                close all
                y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
                dimensions(:,f)=y;
                disp(files(f).name)
%             catch
%                 disp (['couldnt digitise ' files(f).name])
                
%             end
        end
       save(outputfile,'dimensions');     
    end    
   
    end
end




%% Check if the files were digitized correctly
Week='week_4\'
Session=Sesh{2}
cd([Directory Participant Week Session])
outputpath=[Directory Participant Week 'Digitised\' Session];
n_epochs=week_length(outputpath);
load([outputpath '_dimensionsdata.mat'])
files=dir('*.jpg');
% plot the image next to the vector
close all

for f=1:length(files) %this next
    
    I = imread(files(f).name);
     fig_position = [50 50 1200 300];
     figure('Position', fig_position)
    
    subplot(1,2,1)
    imshow(I);
    subplot(1,2,2)
    plot(dimensions(:,f));
    ylim([0 1])
    xlim([0 n_epochs]);
    sgtitle(files(f).name);
    
end



%% If not similar, try and replace with crop method:
bad_dims = [2 14];

for f=bad_dims
    close all
    y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
    dimensions(:,f)=y;
    disp(files(f).name)
end
outputfile=[outputpath '_dimensionsdata.mat'];
save(outputfile,'dimensions');

%Plot and check

close all
for f=bad_dims     
    I = imread(files(f).name);
    fig_position = [50 50 1200 300];
    figure('Position', fig_position)
    
    subplot(1,2,1)
    imshow(I);
    subplot(1,2,2)
    plot(dimensions(:,f));
    ylim([0 1])
    xlim([0 n_epochs]);
    sgtitle(files(f).name);
end
% figure;
% plot(dimensions(:,(bad_dims(1))));
% ylim([0 1]);
% xlim([0 n_epochs]);
% figure;
% plot(dimensions(:, (bad_dims(2))));
% ylim([0 1]);
% xlim([0 n_epochs]);

%% Now load all the dimensionfiles and concatenate into one 

% I think this is for the whole Week, so probably gotta run through loop
Directory='C:\Users\evanl\Documents\TET\'
Participant='s02\'
Week='week_1\'
Session='01\'
inputpath=[Directory Participant Week 'Digitised/' Session];
outputfile=[Directory Participant Week 'Digitised/' 'AllData.mat'];
cd(inputpath)

AllData=[];
files=dir ('*.mat');
for i=1:length(files)
    load(files(i).name)
    %check it's all in correct order
    disp(files(i).name)
    AllData=[AllData; dimensions];
end

save(outputfile,'dimensions');
 