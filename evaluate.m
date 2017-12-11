close all

froot='C:\Users\Gabriel\Documents\GAT\Lorraine\ECE 8803 Special Problem\RESULTS';

files=dir(strcat(froot,'\TRAIN 2\images'));

% imgs=[];
% groundT=[];
% sal=[];
KL=figure();
title('KL');
scKL=[0,0,0,0,0];

CC=figure();
title('CC');
scCC=[0,0,0,0,0];

SIM=figure();
title('SIM');
scSIM=[0,0,0,0,0];

IG=figure();
title('IG');
scIG=[0,0,0,0,0];

print=1;
nb=0;

for k=3:3+nb
    imgs=imread(strcat(froot,'\TRAIN 2\images\',files(k).name));
    groundT=imread(strcat(froot,'\maps\',files(k).name(1:end-4),'.png'));
    sal90=imread(strcat(froot,'\TRAIN 2\saliency_original_90ep\',files(k).name));
    sal902=imread(strcat(froot,'\TRAIN 2\saliency_trained_90ep\',files(k).name));    
    sal300=imread(strcat(froot,'\TRAIN 2\saliency_trained_300ep\',files(k).name));
    sal180=imread(strcat(froot,'\TRAIN 2\saliency_trained_180ep\',files(k).name));    
    sal60=imread(strcat(froot,'\TRAIN 2\saliency_trained_60ep\',files(k).name));
    sal30=imread(strcat(froot,'\TRAIN 2\saliency_trained_30ep\',files(k).name));
    
    S=size(sal300);
    imgs=imresize(imgs,S);
    groundT=imresize(groundT,S);
    sal90=imresize(sal90,S);
    
    sal90=double(sal90);
    sal30=double(sal30);
    sal60=double(sal60);
    sal902=double(sal902);
    sal180=double(sal180);
    sal300=double(sal300);
    
    
    if print==1
        figure();
        subplot(3,3,1);
        imshow(imgs);
        title('Original Image');
        subplot(3,3,2);
        imshow(groundT);
        title('Ground Truth');
        subplot(3,3,3);
        imshow(sal90./max(sal90(:)));
        title('Original Training');
        subplot(3,3,4);
        imshow(sal60./max(sal60(:)));
        title('New Training 60')
        subplot(3,3,5);
        imshow(sal90./max(sal90(:)));
        title('New Training 90')
        subplot(3,3,6);
        imshow(sal180./max(sal180(:)));
        title('New Training 180')
        subplot(3,3,7);
        imshow(sal300./max(sal300(:)));
        title('New Training 300')
    end
    
    %KL Divergence
    %Punish false negative, must be 0 to be perfect
    [resMap90,figtitle] = visualize_KL(sal90, groundT, 0);
    [resMap30,figtitle] = visualize_KL(sal30, groundT, 0);
    [resMap60,figtitle] = visualize_KL(sal60, groundT, 0);
    [resMap902,figtitle] = visualize_KL(sal902, groundT, 0);
    [resMap180,figtitle] = visualize_KL(sal180, groundT, 0);
    [resMap300,figtitle] = visualize_KL(sal300, groundT, 0);
    score90=sum(resMap90(:));
    score30=sum(resMap30(:));
    score60=sum(resMap60(:));
    score902=sum(resMap902(:));
    score180=sum(resMap180(:));
    score300=sum(resMap300(:));
    maxval = max([max(resMap90(:)),max(resMap60(:)),max(resMap902(:)),max(resMap180(:)),max(resMap300(:))]);

    figure(KL);
    hold on
    
    scoreKL=[abs(score30),score60,score902,score180,score300];
    scKL=scKL+scoreKL;
    absKL=[30,60,90,180,300];
    plot(absKL,scoreKL);
    hold off
    
    if print==1
        figure();
        subplot(2,3,1);
        imshow(resMap90/maxval);
        title(sprintf('KL divergence \nOriginal Training\n%d',score90));
        subplot(2,3,2);
        imshow(resMap60/maxval);
        title(sprintf('KL divergence \nNew Training 60ep\n%d',score60));
        subplot(2,3,3);
        imshow(resMap902/maxval);
        title(sprintf('KL divergence \nNew Training 90ep\n%d',score902));
        subplot(2,3,4);
        imshow(resMap180/maxval);
        title(sprintf('KL divergence \nNew Training 180ep\n%d',score180));
        subplot(2,3,5);
        imshow(resMap300/maxval);
        title(sprintf('KL divergence \nNew Training 300ep\n%d',score300));
    end
    
    %visualize Similarity (SIM) computation
    
    %Must be as close as possible to the ground truth. best score is 1
    %Pinish false negative but not false positive (take the min)
    
    [resMap90,figtitle] = visualize_SIM(sal90, groundT, 0);
    [resMap30,figtitle] = visualize_SIM(sal30, groundT, 0);
    [resMap60,figtitle] = visualize_SIM(sal60, groundT, 0);
    [resMap902,figtitle] = visualize_SIM(sal902, groundT, 0);
    [resMap180,figtitle] = visualize_SIM(sal180, groundT, 0);
    [resMap300,figtitle] = visualize_SIM(sal300, groundT, 0);
    score90=sum(resMap90(:));
    score30=sum(resMap30(:));
    score60=sum(resMap60(:));
    score902=sum(resMap902(:));
    score180=sum(resMap180(:));
    score300=sum(resMap300(:));
%     maxval = max(max(resMap90(:)),max(resMap300(:)));
    
    figure(SIM);
    hold on
    
    scoreSIM=[score30,score60,score902,score180,score300];
    scSIM=scSIM+scoreSIM;
    absSIM=[30,60,90,180,300];
    plot(absSIM,scoreSIM);
    hold off

    if print==1
        figure();
        subplot(2,3,1);
        imshow(resMap90/max(resMap90(:)));
        title(sprintf('Histogram intersection \nOriginal Training\n%d',score90));
        subplot(2,3,2);
        imshow(resMap60/max(resMap60(:)));
        title(sprintf('Histogram intersection \nNew Training 60ep\n%d',score60));
        subplot(2,3,3);
        imshow(resMap902/max(resMap902(:)));
        title(sprintf('Histogram intersection \nNew Training 90ep\n%d',score902));
        subplot(2,3,4);
        imshow(resMap180/max(resMap180(:)));
        title(sprintf('Histogram intersection \nNew Training 180ep\n%d',score180));
        subplot(2,3,5);
        imshow(resMap300/max(resMap300(:)));
        title(sprintf('Histogram intersection \nNew Training 300ep\n%d',score300));
    end
        
    % visualize Pearson's Correlation Coefficient (CC) computation
    %Punish both true and false positive but there is no distinction
    %between them, must be 1 to be perfect.
    [score90,resMap90,figtitle] = visualize_CC(sal90, groundT, 0);
    [score30,resMap30,figtitle] = visualize_CC(sal30, groundT, 0);
    [score60,resMap60,figtitle] = visualize_CC(sal60, groundT, 0);
    [score902,resMap902,figtitle] = visualize_CC(sal902, groundT, 0);
    [score180,resMap180,figtitle] = visualize_CC(sal180, groundT, 0);
    [score300,resMap300,figtitle] = visualize_CC(sal300, groundT, 0);
%     score90=sum(resMap90(:));
%     score300=sum(resMap300(:));
    maxval = max([max(resMap90(:)),max(resMap60(:)),max(resMap902(:)),max(resMap180(:)),max(resMap300(:))]);
    
    figure(CC);
    hold on
    
    scoreCC=[score30,score60,score902,score180,score300];
    scCC=scCC+scoreCC;
    absCC=[30,60,90,180,300];
    plot(absCC,scoreCC);
    hold off
    
    if print==1
        figure();
        subplot(2,3,1);
        imshow(resMap90/maxval);
        title(sprintf('Correlation Coefficient \nOriginal Training\n%d',score90));
        subplot(2,3,2);
        imshow(resMap60/maxval);
        title(sprintf('Correlation Coefficient \nNew Training 60ep\n%d',score60));
        subplot(2,3,3);
        imshow(resMap902/maxval);
        title(sprintf('Correlation Coefficient \nNew Training 90ep\n%d',score902));
        subplot(2,3,4);
        imshow(resMap180/maxval);
        title(sprintf('Correlation Coefficient \nNew Training 180ep\n%d',score180));
        subplot(2,3,5);
        imshow(resMap300/maxval);
        title(sprintf('Correlation Coefficient \nNew Training 300ep\n%d',score300));
    end
    % visualize Information Gain (IG) computation

    % Red = Where the information should have increase but failed
    % Blue = Where the information have correctly increase.
    
    [score30,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal30, sal90,print);
    title(sprintf('Information Gain (IG)\nOriginal -> 30 \n%d',score30));
    [score60,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal60, sal90,print);
    title(sprintf('Information Gain (IG)\nOriginal -> 60 \n%d',score60));
    [score902,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal902, sal90,print);
    title(sprintf('Information Gain (IG)\nOriginal -> 90 \n%d',score90));
    [score180,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal180, sal90,print);
    title(sprintf('Information Gain (IG)\nOriginal -> 180 \n%d',score180));
    [score300,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal300, sal90,print);
    title(sprintf('Information Gain (IG)\nOriginal -> 300 \n%d',score300));
    
    
    
    figure(IG);
    title('IG');
    hold on
    scoreIG=[score30,score60,score902,score180,score300];
    scIG=scIG+scoreIG;
    absIG=[30,60,90,180,300];
    plot(absIG,scoreIG);
    hold off
    
    
    
%     [score,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal90, sal300);
%     title(sprintf('Information Gain (IG)\n%d',score));
%     [score,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal300 );
%     title(sprintf('Information Gain (IG)\n%d',score));
%     [score,resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(groundT, sal90);
%     title(sprintf('Information Gain (IG)\n%d',score));
%     pos=sum(resMap_pos(:))/(S(1)*S(2));
%     neg=sum(resMap_neg(:))/(S(1)*S(2));
%     res1=sum(resMap(:))/(S(1)*S(2));
%     res2=sum(resMap2(:))/(S(1)*S(2));
    
end

figure(KL);
hold on
plot(absKL,scKL./nb, 'LineWidth', 3);
hold off

figure(SIM);
hold on
plot(absSIM,scSIM./nb, 'LineWidth', 3);
hold off

figure(CC);
hold on
plot(absCC,scCC./nb, 'LineWidth',3);
hold off

figure(IG);
hold on
plot(absIG,scIG./nb, 'LineWidth', 3);
hold off



