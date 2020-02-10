clear all; close all; clc;

%% Loading the videos, find sv spectrum 
redsq = VideoReader('redsquare.mov');
numframe_redsq = (redsq.Duration) * (redsq.FrameRate);
v_redsq = [];
for j = 1:numframe_redsq
    frm = reshape( rgb2gray(readFrame(redsq)), [], 1);
    v_redsq(:,j) = frm;
end

[u s v] = svd(v_redsq, 'econ');
s_diag_prop = diag(s)/sum(diag(s));

figure(1)
plot(s_diag_prop, 'ro', 'MarkerFaceColor', 'r')
title('Singular Value Spectrum, Red Square')
xlabel('Modes')
ylabel('Fraction Energy')
set(gca, 'FontSize', 13)

%% Applying DMD
thresh = 0.008;
trc = sum(s_diag_prop >= thresh);

X1 = v_redsq(:,1:end-1);
X2 = v_redsq(:,2:end);
dt = redsq.Duration/numframe_redsq;

[Phi,omega,lambda,b,Xdmd] = DMD(X1,X2,trc,dt);

X_sparse = X1 - abs(Xdmd);
R = X_sparse.*(X_sparse<0);
X_sparse = X_sparse-R;

figure(4)
imshow(uint8(reshape(v_redsq(:,20),[],960)))
title('Original')
set(gca, 'FontSize', 13)

%%
figure(2)
for j = 1:numframe_redsq-1
    imshow(uint8(reshape(X_sparse(:,j), [], 960)))
    drawnow
end

figure(3)
for j = 1:numframe_redsq-1
    imshow(uint8(reshape(Xdmd(:,j), [], 960)))
    drawnow
end


figure(4)
subplot(2,2,[1 2])
imshow(uint8(reshape(v_redsq(:,20),[],960)))
title('Original')
set(gca, 'FontSize', 13)
subplot(2,2,3)
imshow(uint8(reshape(X_sparse(:,20), [], 960)))
title('Foreground')
set(gca, 'FontSize', 13)
subplot(2,2,4)
imshow(uint8(reshape(Xdmd(:,20), [], 960)))
title('Background')
set(gca, 'FontSize', 13)
