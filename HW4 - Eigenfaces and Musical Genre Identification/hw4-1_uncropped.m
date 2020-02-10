clear all; clc;
% close all;
direct = '~/Documents/MATLAB/AMATH482/HW4/yalefaces_uncropped/yalefaces';
% make matrices for storing the faces over a loop-- average and data matrices 
A = [];

% gets all folders in croppedyale folder
dir_yale_uncropped = dir(direct);
% start indexing from 4 to account for DS_store and empty directory
% progressbar(0)
count = 1;
f = dir(fullfile(direct, '*.gif'));
for j = 3:length(f)
    current_file = fullfile(direct, f(j).name);
    loaded_image = imread(current_file);
    A(:,count) = reshape(loaded_image, [], 1);
    progressbar(j/length(f))
    count = count + 1;
end

A_im = uint8(A);

%% Save for later
% save('faces_loaded.mat', A_im, '-mat')


%% Apply SVD
[U, S, V] = svd(double(A), 'econ');

%% Plotting the energy captured by each singular value modes 
% Magenta for the Cropped version 
figure(1)
subplot(1,2,1)
plot((diag(S)/sum(diag(S))), 'mo', 'MarkerSize', [6], 'MarkerFaceColor', 'm')
title({['Percent Energies Captured by each Mode']; ['Uncropped Yale Faces']})
xlabel('Singular Value')
ylabel('Percentage')
set(gca, 'FontSize', 13)
subplot(1,2,2)
plot(log(diag(S)), 'mo', 'MarkerSize', [6], 'MarkerFaceColor', 'm')
title({['Log Plot of Energies Captured by each Mode']; ['Uncropped Yale Faces']})
xlabel('Singular Value')
ylabel('Log energy')
set(gca, 'FontSize', 13)

%% Face reconstruction 
% Essentially pulling out the n-th element of the diagonal of the singular value vector, truncating
% the U and V matrices of the singular value decomposition  
close all;
% Specifies which face to work on
facenum = 140;

tot_energy = diag(S);

%% This figure shows the part of reconstruction by each mode specified in numlist vector 
count = 1;
numlist = [1 2 3 4 5 6 7 8];
for j = 1:length(numlist)
    recon = U(:,numlist(j))*S(numlist(j),numlist(j))*V(:,numlist(j))';
    energy_percent = diag(S(numlist(j),numlist(j)))/sum(tot_energy) * 100;
    
    figure(2)
    subplot(2,4,count)
    pcolor(flipud(reshape(uint8(recon(:,facenum)), [], 320)))
    shading interp
    title({[num2str(numlist(j)) '° Mode']; ['Energy: ' num2str(round(energy_percent, 3)) '%']})
    sgtitle({['Energy Captured by Each Modes, Uncropped Yale Faces']; ['Subject #', num2str(round(facenum/11,0))]})
    set(gca, 'FontSize', 12)
    count = count + 1;
end 

%% This figure shows the total reconstruction at n-th mode
count = 1;
numlist = [1 4 10 20 40 80 100 160];
for j = 1:length(numlist)
    recon = U(:,1:numlist(j))*S(1:numlist(j),1:numlist(j))*V(:,1:numlist(j))';
    energy_percent = sum(diag(S(1:numlist(j),1:numlist(j))))/sum(tot_energy) * 100;
    
    figure(3)
    subplot(2,4,count)
    imshow(reshape(uint8(recon(:,facenum)), [], 320))
    title({[num2str(numlist(j)) ' Modes']; ['Total Energy: ' num2str(round(energy_percent, 3)) '%']})
    sgtitle({['Reconstruction of Uncropped Yale Faces & Total Energies Captured at N-th Mode']; ['Subject #', num2str(round(facenum/11,0))]})
    set(gca, 'FontSize', 12)
    count = count + 1;
end

%% Calculation of total energy percentage over all the modes
for j = 1:length(tot_energy)
    energy_percent(j,:) = sum(diag(S(1:j,1:j)))/sum(tot_energy) * 100;
end

figure(4)
plot(energy_percent, 'm-', 'LineWidth', [3])
title('Percentage of Total Energy Captured at N-th Modes, Uncropped')
xlabel('Singular Value Modes')
ylabel('Percent Energy Captured')
set(gca, 'FontSize', 13)


%%
[u,s,v]=svd(A, 'econ'); % perform the SVD 
lambda=diag(s).^2; % produce diagonal variances 

%%
close all

for jj = 1:9
    subplot(3,3,jj)
    pcolor( flipud(reshape( U(:,jj), 243, 320))), shading interp, colormap bone, axis off
    energy_percent = round((diag(S(jj,jj)))/sum(tot_energy) * 100, 2);
    title(['Mode ' num2str(jj) ': ' num2str(energy_percent) '%'])
    set(gca, 'FontSize', 13)
end
set(gca, 'FontSize', 13)
sgtitle('Eigenfaces')


