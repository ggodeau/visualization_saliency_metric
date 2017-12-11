close all

froot='C:\Users\Gabriel\Documents\GAT\Lorraine\ECE 8803 Special Problem\RESULTS';

files=dir(strcat(froot,'\TRAIN 3\images'));

print=1;
nb=25;
epoch=[10,200,300,400,500,600,700]

for k=8:8+nb
    imgs=imread(strcat(froot,'\TRAIN 3\images\',files(k).name));
    groundT=imread(strcat(froot,'\TRAIN 3\maps\',files(k).name(1:end-4),'.png'));

    

    figure();
    subplot(3,3,1);
    imshow(imgs);
    title('Original Image');
    subplot(3,3,2);
    imshow(groundT);
    title('Ground Truth');

    for l=1:length(epoch)
        c=['\TRAIN 3\training_',int2str(epoch(l)),'ep\'];
        sal=imread(strcat(froot,c,files(k).name(1:end-4),'.jpg'));
        sal=double(sal);
        subplot(3,3,2+l);
        imshow(sal./max(sal(:)));
        title(sprintf('Training %d',l));
    end
    
    
%     
%     %KL Divergence
%     %Punish false negative, must be 0 to be perfect
%     
%     figure();
% 
%      for l=1:length(epoch)
%         c=['\TRAIN 3\training_',int2str(epoch(l)),'ep\'];
%         sal=imread(strcat(froot,c,files(k).name(1:end-4),'.jpg'));
%         sal=double(sal);
%         [resMap,figtitle] = visualize_KL(sal, groundT, 0);
%         score=sum(resMap(:));
%         subplot(2,3,l);
%         imshow(resMap);
%         title(sprintf('KL divergence\n Training %d',l));
%     end
%     
%     %visualize Similarity (SIM) computation
%     
%     %Must be as close as possible to the ground truth. best score is 1
%     %Pinish false negative but not false positive (take the min)
% 
% %     maxval = max(max(resMap90(:)),max(resMap300(:)));
%     figure();
% 
%     for l=1:length(epoch)
%         c=['\TRAIN 3\training_',int2str(epoch(l)),'ep\'];
%         sal=imread(strcat(froot,c,files(k).name(1:end-4),'.jpg'));
%         sal=double(sal);
%         [resMap,figtitle] = visualize_SIM(sal, groundT, 0);
%         score=sum(resMap(:));
%         subplot(2,3,l);
%         imshow(resMap/max(resMap(:)));
%         title(sprintf('Histogram intersection\n Training %d',l));
%     end
% 
%     % visualize Pearson's Correlation Coefficient (CC) computation
%     %Punish both true and false positive but there is no distinction
%     %between them, must be 1 to be perfect.
% 
%     figure();
% 
%     for l=1:length(epoch)
%         c=['\TRAIN 3\training_',int2str(epoch(l)),'ep\'];
%         sal=imread(strcat(froot,c,files(k).name(1:end-4),'.jpg'));
%         sal=double(sal);
%         [score,resMap,figtitle] = visualize_CC(sal, groundT, 0);
%         score=sum(resMap(:));
%         subplot(2,3,l);
%         imshow(resMap);
%         title(sprintf('Correlation Coefficient\n Training %d',l));
%     end
    

end

