clear all; close all; clc;

%% Music genre identification (PART 1: BAND CLASSIFICATION) SVM
clear all; clc; %close all;
cd '~/Documents/MATLAB/AMATH482/HW4'

samplenum = 30;
alice_filename = 'resampled_audio/aliceinchains_mix.wav';
[alice_pl, alice_mat] = audio_to_fftmatrix(alice_filename, samplenum);

nir_filename = 'resampled_audio/nirvana_mix.wav';
[nir_pl, nir_mat] = audio_to_fftmatrix(nir_filename, samplenum);

pearl_filename = 'resampled_audio/pearljam_mix.wav';
[pearl_pl, pearl_mat] = audio_to_fftmatrix(pearl_filename, samplenum);


X = [alice_mat nir_mat pearl_mat];
% X = X'; %transpose
[u s v] = svd((X'), 'econ');
features=1:230;

test_samplenum=0.2*samplenum;

for jj=1:100
    [xtrain, label, test, truth] = construct_train(samplenum, u'*X', features);

   % LDA/QDA
    class = classify(test, xtrain, label, 'diaglinear');
    correct1 = (class == truth);
    E1(jj) = (sum(correct1(:) == 1))/(test_samplenum*3)*100;
    E1ave = mean(E1);

%     class2 = classify(test, xtrain, label, 'diagquadratic');
%     correct2 = (class2 == truth);
%     E2(jj) = (sum(correct2(:) == 1))/(test_samplenum*3)*100;
%     E2ave = mean(E2);

    % Naive Bayes
    Mdl3 = fitcnb(real(xtrain),label);
    test_labels3 = predict(Mdl3, real(test));
    correct3 = (test_labels3 == truth);
    E3(jj)=(sum(correct3(:) == 1))/(test_samplenum*3)*100;
    E3ave = mean(E3);

    % SVM
    Mdl4 = fitcecoc(real(xtrain),label);
    test_labels4 = predict(Mdl4, real(test));
    correct4 = (test_labels4 == truth);
    E4(jj)=(sum(correct4(:) == 1))/(test_samplenum*3)*100;
    E4ave = mean(E4);
end

% close all;
figure(2)
subplot(2,2,1)
bar(E1)
ylim([0 125])
title('LDA')
t1 = text(60, 119,['average:' num2str(round(E1ave,2)) '%'])
t1.Color = 'red';
hold on;
yline(E1ave, 'r', 'LineWidth', 2);

% subplot(2,2,2)
% bar(E2)
% ylim([0 125])
% title('QDA')
% t2 = text(60, 119,['average:' num2str(round(E2ave,2)) '%'])
% t2.Color = 'red';
% hold on;
% yline(E2ave, 'r', 'LineWidth', 2);

subplot(2,2,2)
bar(E3)
ylim([0 125])
title('Naive Bayes')
t3 = text(60, 119,['average:' num2str(round(E3ave,2)) '%'])
t3.Color = 'red';
hold on;
yline(E3ave, 'r', 'LineWidth', 2);

subplot(2,2,3)
bar(E4)
ylim([0 125])
title('SVM')
t4 = text(60, 119,['average:' num2str(round(E4ave,2)) '%'])
t4.Color = 'red';
hold on;
yline(E4ave, 'r', 'LineWidth', 2);

sgtitle('Test 2: The Case for Seattle')

%%
mode = 180;
% recon = u(:,1:mode)*s(1:mode,1:mode)*v(:,1:mode)';
% what = ifft(u(:,));
sound(real(what),8000)


%%
figure(2)
for j = 1:length(s)
    diagonal = diag(s);
    diagarr(j) = sum(diagonal(1:j))/sum(diagonal(:));
end

plot(diagarr, 'LineWidth', 2)
title('Fraction Energy Captured at ea ')
xlabel('Singular Values')
ylabel('Fraction Energy Captured')
