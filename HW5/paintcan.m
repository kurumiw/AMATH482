clear all; close all; clc;

%% Loading the videos, find sv spectrum 
load ~/Documents/MATLAB/AMATH482/HW3/cam1_1.mat
numFrames = size(vidFrames1_1, 4);

for k = 1 : numFrames
    mov(k).cdata = vidFrames1_1(:,:,:,k);
    mov(k).colormap = [];
end

v_paint = [];
for j=1:numFrames
    X = frame2im(mov(j));
    I = rgb2gray(X);
    frm = reshape( I, [], 1);
    v_paint(:,j) = frm;
end

[u s v] = svd(v_paint, 'econ');
s_diag_prop = diag(s)/sum(diag(s));

figure(1)
plot(s_diag_prop, 'ro', 'MarkerFaceColor', 'r')
title('Singular Value Spectrum, Paintcan')
xlabel('Modes')
ylabel('Fraction Energy')
set(gca, 'FontSize', 13)

%% Applying DMD
thresh = 0.008;
trc = sum(s_diag_prop >= thresh);

X1 = v_paint(:,1:end-1);
X2 = v_paint(:,2:end);
dt = 0.0333;

[Phi,omega,lambda,b,Xdmd] = DMD(X1,X2,trc,dt);

X_sparse = X1 - abs(Xdmd);
R = X_sparse.*(X_sparse<0);
X_sparse = X_sparse-R;

figure(4)
imshow(uint8(reshape(v_paint(:,20),[],640)))
title('Original')
set(gca, 'FontSize', 13)

%%
figure(2)
for j = 1:numFrames-1
    imshow(uint8(reshape(X_sparse(:,j), [], 640)))
    drawnow
end

figure(3)
for j = 1:numFrames-1
    imshow(uint8(reshape(Xdmd(:,j), [], 640)))
    drawnow
end


figure(4)
subplot(2,2,[1 2])
imshow(uint8(reshape(v_paint(:,20),[],640)))
title('Original')
set(gca, 'FontSize', 13)
subplot(2,2,3)
imshow(uint8(reshape(X_sparse(:,20), [], 640)))
title('Foreground')
set(gca, 'FontSize', 13)
subplot(2,2,4)
imshow(uint8(reshape(Xdmd(:,20), [], 640)))
title('Background')
set(gca, 'FontSize', 13)
