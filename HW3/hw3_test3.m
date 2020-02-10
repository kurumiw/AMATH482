clear all; close all; clc;

load cam1_3.mat
load cam2_3.mat
load cam3_3.mat

filter1 = zeros(480, 640);
filter1(:,280:380) = 1;

% cam1:
    [x1, y1] = paintcan_find(vidFrames1_3, filter1, 2, 'average');  
    x1_shift = x1-(max(x1)+min(x1))/2;
    y1_shift = y1-(max(y1)+min(y1))/2;
    
    subplot(4,1,1)
    plot(y1_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(x1_shift, 'b-', 'LineWidth', [2])
    xlim([0,size(vidFrames1_3, 4)+50])
    title(['Displacement of Paint Can, w/ Horizontal Disp (cam1)'])
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')

% cam2:

    filter2 = zeros(480, 640);
    filter2(:,250:450) = 1; 
    [x2, y2] = paintcan_find(vidFrames2_3, filter2, 4, 'average');
    
    x2_shift = x2-(max(x2)+min(x2))/2;
    y2_shift = y2-(max(y2)+min(y2))/2;
    
    subplot(4,1,2)
    plot(y2_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(x2_shift, 'b-', 'LineWidth', [2])
    title(['Displacement of Paint Can, w/ Horizontal Disp (cam2)'])
    xlim([0,size(vidFrames2_3, 4)+50])
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')


% cam3:

    filter3 = zeros(480, 640);
    filter3(180:320, 250:end) = 1;
    [x3, y3] = paintcan_find(vidFrames3_3, filter3, 8, 'average');
    
    x3_shift = x3-(max(x3)+min(x3))/2;
    y3_shift = y3-(max(y3)+min(y3))/2;
    
    subplot(4,1,3)
    plot(x3_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(y3_shift, 'b-', 'LineWidth', [2])
    title(['Displacement of Paint Can, w/ Horizontal Disp (cam3)'])
    xlim([0,size(vidFrames3_3, 4)+50])   
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')


    
X = [x1(1:length(x3)); y1(1:length(x3)); x2(1:length(x3)); y2(1:length(x3)); x3; y3];

[m,n]=size(X); % compute data size 
mn=mean(X,2); % compute mean for each row 
X=X-repmat(mn,1,n); % subtract mean
[u,s,v]=svd(X*X'/sqrt(n-1)); % perform the SVD 
lambda=diag(s).^2; % produce diagonal variances 
Y=u'*X; % produce the principal components projection

subplot(4,1,4)
plot(Y(1,:), 'LineWidth', [2])
title(['Displacement along Principal Components'])
xlabel(['Frame'])
ylabel(['Displacement'])
xlim([0 (length(X)+50)])
ylim([-100 100])
hold on;
plot(Y(2,:), 'LineWidth', [2])
hold on;
plot(Y(3,:), 'LineWidth', [2])
hold on;
plot(Y(4,:), 'LineWidth', [2])
legend('PC1', 'PC2', 'PC3', 'PC4')

figure(2) 
plot(lambda/sum(lambda), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8)
xlabel(['Variance'])
ylabel(['Energy'])
title(['Energy, Diagonal Variances, Case 3'])
xlim([0 7])
ylim([0 1])
