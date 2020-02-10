clear all; clc;
% close all;
direct = '~/Documents/MATLAB/AMATH482/HW4/CroppedYale';
% make matrices for storing the faces over a loop-- average and data matrices
A = [];

% gets all folders in croppedyale folder
dir_yale_cropped = dir(direct);
% looping through each folder and get all files
% start indexing from 4 to account for DS_store and empty directory
% progressbar(0)
for j=4:length(dir_yale_cropped)
    current_folder = dir_yale_cropped(j).name;
    f = dir(fullfile(direct, current_folder,'*.pgm'));
    for k = 3:length(f)
        current_file = fullfile(direct, current_folder, f(k).name);
        loaded_image = imread(current_file);
        A = [A, reshape(loaded_image, [], 1)];
    end
end

A_im = uint8(A);

%% Apply SVD
[U, S, V] = svd(double(A), 'econ');

%% Plotting the energy captured by each singular value modes
% Blue for the Cropped version
figure(1)
subplot(1,2,1)
plot((diag(S)/sum(diag(S))), 'bo', 'MarkerSize', [6], 'MarkerFaceColor', 'b')
title({['Percent Energies Captured by each Mode']; ['Cropped Yale Faces']})
xlabel('Singular Value')
ylabel('Percentage')
set(gca, 'FontSize', 13)
subplot(1,2,2)
plot(log(diag(S)), 'bo', 'MarkerSize', [6], 'MarkerFaceColor', 'b')
title({['Log Plot of Energies Captured by each Mode']; ['Cropped Yale Faces']})
xlabel('Singular Value')
ylabel('Log energy')
set(gca, 'FontSize', 13)

%% Face reconstruction
% Essentially pulling out the n-th element of the diagonal of the singular value vector, truncating
% the U and V matrices of the singular value decomposition
close all;
% Specifies which face to work on
facenum = 980;

tot_energy = diag(S);

%% This figure shows the part of reconstruction by each mode specified in numlist vector
count = 1;
numlist = [1 2 3 4 5 6 7 8];
for j = 1:length(numlist)
    recon = U(:,numlist(j))*S(numlist(j),numlist(j))*V(:,numlist(j))';
    energy_percent = diag(S(numlist(j),numlist(j)))/sum(tot_energy) * 100;

    figure(2)
    subplot(2,4,count)
    pcolor(flipud(reshape(uint8(recon(:,facenum)), [], 168)))
    shading interp
    title({[num2str(numlist(j)) '° Mode']; ['Energy: ' num2str(round(energy_percent, 3)) '%']})
    sgtitle({['Energy Captured by Each Modes, Cropped Yale Faces']; ['Face #', num2str(round(facenum/64,0)+1)]})
    set(gca, 'FontSize', 12)
    count = count + 1;
end

%% This figure shows the total reconstruction at n-th mode
count = 1;
numlist = [1 25 50 100 150 300 600 1200];
for j = 1:length(numlist)
    recon = U(:,1:numlist(j))*S(1:numlist(j),1:numlist(j))*V(:,1:numlist(j))';
    energy_percent = sum(diag(S(1:numlist(j),1:numlist(j))))/sum(tot_energy) * 100;

    figure(3)
    subplot(2,4,count)
    imshow(reshape(uint8(recon(:,facenum)), [], 168))
    title({[num2str(numlist(j)) ' Modes']; ['Total Energy: ' num2str(round(energy_percent, 3)) '%']})
    sgtitle({['Reconstruction of Cropped Yale Faces & Total Energies Captured at N-th Mode']; ['Face #', num2str(round(facenum/64,0)+1)]})
    set(gca, 'FontSize', 12)
    count = count + 1;
end


%% Calculation of total energy percentage over all the modes
for j = 1:length(tot_energy)
    energy_percent(j,:) = sum(diag(S(1:j,1:j)))/sum(tot_energy) * 100;
end

figure(4)
plot(energy_percent, 'b-', 'LineWidth', [3])
title('Percentage of Total Energy Captured at N-th Modes, Cropped')
xlabel('Singular Value Modes')
ylabel('Percent Energy Captured')
set(gca, 'FontSize', 13)

%%
close all

for jj = 1:9
    subplot(3,3,jj)
    pcolor( flipud(reshape( U(:,jj), 192, 168))), shading interp, colormap bone, axis off
    energy_percent = round((diag(S(jj,jj)))/sum(tot_energy) * 100, 2);
    title(['Mode ' num2str(jj) ': ' num2str(energy_percent) '%'])
    set(gca, 'FontSize', 13)
end
set(gca, 'FontSize', 13)
sgtitle('Eigenfaces')
