%% Test 1: Ideal case, oscillation in z direction
clear all; close all; clc;
load cam1_1.mat
load cam2_1.mat
load cam3_1.mat

filter1 = zeros(480, 640);
filter1(:,300:360) = 1;

% cam1:
    [x1, y1] = paintcan_find(vidFrames1_1, filter1, 1);
    x1(191) = []; y1(191) = [];

    x1_shift = x1-(max(x1)+min(x1))/2;
    y1_shift = y1-(max(y1)+min(y1))/2;

    subplot(4,1,1)
    plot(y1_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(x1_shift, 'b-', 'LineWidth', [2])
    xlim([0,size(vidFrames1_1, 4)+50])
    title(['Displacement of Paint Can, Ideal case (cam1)'])
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')

% cam2:
    filter2 = ones(480, 640);
    [x2, y2] = paintcan_find(vidFrames2_1, filter2, 4);

    x2_shift = x2-(max(x2)+min(x2))/2;
    y2_shift = y2-(max(y2)+min(y2))/2;

    subplot(4,1,2)
    plot(y2_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(x2_shift, 'b-', 'LineWidth', [2])
    title(['Displacement of Paint Can, Ideal case (cam2)'])
    xlim([0,size(vidFrames2_1, 4)+50])
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')

% cam3:
    filter3 = zeros(480, 640);
    filter3(220:320, 250:end) = 1;
    [x3, y3] = paintcan_find(vidFrames3_1, filter3, 8);

    x3_shift = x3-(max(x3)+min(x3))/2;
    y3_shift = y3-(max(y3)+min(y3))/2;

    subplot(4,1,3)
    plot(x3_shift, 'r-', 'LineWidth', [2])
    hold on
    plot(y3_shift, 'b-', 'LineWidth', [2])
    title(['Displacement of Paint Can, Ideal case (cam3)'])
    xlim([0,size(vidFrames3_1, 4)+50])
    xlabel(['Frame'])
    ylabel(['Displacement'])
    legend('Z-Axis', 'X-Y')



X = [x1; y1; x2(1:length(x1)); y2(1:length(x1)); y3(1:length(x1)); x3(1:length(x1))];

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
legend('PC1', 'PC2', 'PC3')

figure(2)
plot(lambda/sum(lambda), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8)
xlabel(['Variance'])
ylabel(['Energy'])
title(['Energy, Diagonal Variances, Case 1'])

xlim([0 7])
ylim([0 1])
