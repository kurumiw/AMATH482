clear  all; close all; clc;

%% Load raw dataset 
load Testdata

L=15; % spatial domain

n=64; % Fourier modes

x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz] = meshgrid(k,k,k);
[Ksx,Ksy,Ksz] = meshgrid(ks,ks,ks);

%% Spectrum averaging: Finding frequency signature
% Part 1: Spectrum Averaging
uave = zeros(n,n,n);
for t = 1:20
    un = reshape(Undata(t,:),n,n,n);  % reshape the data to 64x64x64
    unf = fftn(un);  % 3D fft
    uave = uave + unf;  % Add to Uave
end

uave = abs(fftshift(uave)) / 20; % Average spectrum from measurements at 20
                                 % timepoints!

                             
% Part 2: Find frequency signature of marble
[M,I] = max(uave(:));  % M=max value / I=linear index of max value
[Kx_I, Ky_I, Kz_I] = ind2sub(size(uave),I);  % Find coord of I in 64x64x64 

f_sig = [Ksx(Kx_I, Ky_I, Kz_I), Ksy(Kx_I, Ky_I, Kz_I), Ksz(Kx_I, Ky_I, Kz_I)]; 
% [1.8850, -1.0472, 0]



%% Frequency filtering: Noise reduction
% Part 1: Construct filter around frequency signature determined previously 

% F(k) = exp(??(k ? k0)^2)
filter = exp(-1 * ( (Kx-f_sig(1)).^2 + (Ky-f_sig(2)).^2 + (Kz-f_sig(3)).^2 ));

% Part 2: Applying the filter to denoise
for t = 1:20  % for 20 timepoints
    
    un = reshape(Undata(t,:),n,n,n);  % reshape each row of raw data to 64x64x64
    unt = fftn(un);  
    untf = unt .* filter;  % apply frequency filter
    unf = ifftn(untf);  % inverse fft
    
    [M,I] = max(unf(:));  
    [x_I,y_I,z_I] = ind2sub(size(unf),I);
    
    X_marb(t,:) = X(x_I, y_I, z_I);
    Y_marb(t,:) = Y(x_I, y_I, z_I);
    Z_marb(t,:) = Z(x_I, y_I, z_I);

end

final_marb = [X_marb(20), Y_marb(20), Z_marb(20)];

%% Plotting

close all;
figure
plot3(X_marb, Y_marb, Z_marb, 'b', ...
    'LineWidth', 2)
hold on
plot3(X_marb(end), Y_marb(end), Z_marb(end), '-bo', ...
    'MarkerSize', 10, ...
    'MarkerFaceColor', [.1 .1 1])
title('Trajectory of Marble in Fluffy''s Intestines, 20 timepoints', ...
    'FontWeight', 'normal', ...
    'FontSize', 20)
xlabel('X', ...
    'FontSize', 14)
ylabel('Y', ...
    'FontSize', 14)
zlabel('Z', ...
    'FontSize', 14)
set(gca,'FontSize',12)
grid on
hold off

close all;
figure
plot3(X_marb, Y_marb, Z_marb, 'b', ...
    'LineWidth', 2)
hold on
plot3(X_marb(end), Y_marb(end), Z_marb(end), '-bo', ...
    'MarkerSize', 10, ...
    'MarkerFaceColor', [.1 .1 1])
title('Trajectory of Marble in Fluffy''s Intestines, 20 timepoints', ...
    'FontWeight', 'normal', ...
    'FontSize', 20)
xlabel('X', ...
    'FontSize', 14)
ylabel('Y', ...
    'FontSize', 14)
zlabel('Z', ...
    'FontSize', 14)
set(gca,'FontSize',12)
grid on
hold off



