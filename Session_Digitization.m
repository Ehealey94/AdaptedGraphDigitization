%% Combine the y values for each dimension
% Sort the tracing files so that:
% Directory/Participant/Session/dim.jpg
Directory='/Users/jachs/Desktop/Jamyang_Project/Drawings/Pretend/'
Participant='2743/'
Session='02'
inputpath=[Directory Participant Session '/'];
outputpath=[Directory Participant 'Digitised/'];
% mkdir(outputpath) uncomment the first time to make the output directory
cd (inputpath)

files=dir ('*.jpg');

%load the outputfile if it exists already
outputfile=[outputpath Session '_dimensionsdata.mat'];

if exist (outputfile)~=0
    load (outputfile);
    zer=find (dimensions(1,:)==0)
else
    dimensions=[];
end

%% %Read the Graph and specify how many datapoints you want per graph
%Set this to match the number of epochs of each session
n_epochs=250    

for f= 1:length(files)%[416,452]
    
    try
         y=digitize_graph(files(f).name,[0:1/(n_epochs-1):1]);
        close all
        dimensions(:,f)=y;
        disp(files(f).name)
    catch
        disp (['couldnt digitise ' files(f).name ', attempting with automatically cropped image'])
        
        try
            close all
            y=digitize_graph_autocrop(files(f).name,[0:1/(n_epochs-1):1]);
            dimensions(:,f)=y;
            disp(files(f).name)

            
        catch
            
            disp (['couldnt digitise ' files(f).name ', attempting again with cropped image'])
            
            try
                
                close all
                y=digitize_graph_crop(files(f).name,[0:1/(n_epochs-1):1]);
                dimensions(:,f)=y;
                disp(files(f).name)
            catch
                disp (['couldnt digitise ' files(f).name])
                
            end
        end
        
    end    
   
    save(outputfile,'dimensions');
 
end
figure; plot(dimensions(:,f))
%% Check if the files were digitized correctly

% plot the image next to the vector
close all

for f=1:length(files) %this next
    
    I = imread(files(f).name);
    fig_position = [400 400 1200 300];
    figure('Position', fig_position)
    
    subplot(1,2,1)
    imshow(I);
    subplot(1,2,2)
    plot(dimensions(:,f));
    ylim([0 1])
    xlim([0 n_epochs]);
    sgtitle(files(f).name);
    
end

%% Now load all the dimensionfiles and concatenate into one 
Directory='/Users/jachs/Desktop/Jamyang_Project/Drawings/Pretend/';
Participant='2743/';
inputpath=[Directory Participant 'Digitised/'];
outputfile=[Directory Participant 'AllData.mat'];
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
 