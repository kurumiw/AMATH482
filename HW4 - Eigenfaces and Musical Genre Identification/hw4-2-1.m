%% Music genre identification (PART 1: BAND CLASSIFICATION)
clear all; close all; clc;
cd '~/Documents/MATLAB/AMATH482/HW4'

samplenum = 40;
MJ_filename = 'resampled_audio/mj_mix.wav';
[MJ_pl, MJ_mat] = audio_to_fftmatrix(MJ_filename, samplenum);

LA_filename = 'resampled_audio/larc_mix.wav';
[LA_pl, LA_mat] = audio_to_fftmatrix(LA_filename, samplenum);

CHOP_filename = 'resampled_audio/chopin_mix.wav';
[CHOP_pl, CHOP_mat] = audio_to_fftmatrix(CHOP_filename, samplenum);

X = [MJ_mat LA_mat CHOP_mat];
X = X'; %transpose
[u s v] = svd(X, 'econ');


% labels = [repmat({'MJ'}, samplenum, 1); repmat({'L''arc'}, samplenum, 1); repmat({'Chopin'}, samplenum, 1)];
labels = [-1*ones(samplenum,1); zeros(samplenum,1); ones(samplenum,1)];

% Creating the test dataset
test_samplenum = 30;

MJ_test = 'resampled_audio/mj_whoisit.wav';
[MJTEST_pl, MJTEST_mat] = audio_to_fftmatrix(MJ_test, test_samplenum);
LA_test = 'resampled_audio/larc_fate.wav';
[LATEST_pl, LATEST_mat] = audio_to_fftmatrix(LA_test, test_samplenum);
CHOP_test = 'resampled_audio/chop_noct.wav';
[CHOPTEST_pl, CHOPTEST_mat] = audio_to_fftmatrix(CHOP_test, test_samplenum);

truth_label = [-1*ones(test_samplenum,1); zeros(test_samplenum,1); ones(test_samplenum,1)];

testset = [MJTEST_mat LATEST_mat CHOPTEST_mat];
testset = [truth_label'; testset];
ny=size(testset,2);
shuffle = randsample(1:ny,ny);
testset_shuffle = testset(:,shuffle);
truth = testset_shuffle(1,:);
testset_shuffle = testset_shuffle(2:end, :);

train_X = [v(1:samplenum, 1:3); v(samplenum+1:samplenum*2, 1:3); v((samplenum*2)+1:samplenum*3, 1:3)]; 


class = classify(real(testset_shuffle), real(train_X'), labels', 'diagquadratic');
E = mean(100-sum(0.5*abs(class'-truth))/(test_samplenum*3) * 100);



% sound(ifft((testset_shuffle(:,1))),8000

for jj = 1:50
    MJ_filename = 'resampled_audio/mj_mix.wav';
    [MJ_pl, MJ_mat] = audio_to_fftmatrix(MJ_filename, samplenum);

    LA_filename = 'resampled_audio/larc_mix.wav';
    [LA_pl, LA_mat] = audio_to_fftmatrix(LA_filename, samplenum);

    CHOP_filename = 'resampled_audio/chopin_mix.wav';
    [CHOP_pl, CHOP_mat] = audio_to_fftmatrix(CHOP_filename, samplenum);

    X = [MJ_mat LA_mat CHOP_mat];
    X = X'; %transpose

    class_dQDA = classify(real(testset_shuffle'), real(X), labels', 'diagquadratic');
    E_dQDA(jj) = mean(100-sum(0.5*abs(class_dQDA'-truth))/(test_samplenum*3) * 100);

    class_dLDA = classify(real(testset_shuffle'), real(X), labels', 'diaglinear');
    E_dLDA(jj) = mean(100-sum(0.5*abs(class_dLDA'-truth))/(test_samplenum*3) * 100);

end

subplot(1,2,1)
bar(E_dQDA)
subplot(1,2,2)
bar(E_dLDA)

% Mdl = fitcecoc(real(X'), labels');
% [label, score] = predict(Mdl, real(testset_shuffle'));

