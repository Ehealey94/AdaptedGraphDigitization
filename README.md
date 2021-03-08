# AdaptedGraphDigitization
 Takes jpgs of graphs ordered by participant, session and dimension, into one data matrix where each column is a experience dimension
 
 The jpg files need to be named consistently across folders to make sure the dimensions are matched up correctly. 
 Each file is in a folder corresponding to the session, nested within each participant
 For example 
 
 Directory/Participant_01/Session01/01_Aperture.jpg
 Directory/Participant_01/Session01/01_Boredom.jpg
 ...
 
 In the script you need to change the variables 'Directory', 'Participant' and 'Session' to match your system. 
 
 n_epochs should be changed to the number of epochs you have for each meditation.
 Note: To make this precise, there should be an intermediate step which loads the index to the removed epochs from the eeg file, and removes the same 'epochs' from the continuous data. However, if very few epochs have been removed and considering the low resolution of the traces and later data smoothing, this should not make a difference.
 
 The last section concatenates all files from one participant to create one large datamatrix, where each column represents one dimension. 
 
 
 
