%% Part 2: recorder
close all; 
clc; %clear all;

tr_rec=14; % record time in seconds 
y=audioread('music2.wav'); 
Fs=length(y)/tr_rec;
p8 = audioplayer(y,Fs); 
% playblocking(p8);

n=length(y); 
L = tr_rec;
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(2*pi/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

f_rec = ks/(2*pi);
slide_rec = 0:0.25:14;

recgt_spec=[];

a = 200;

for j = 1:length(slide_rec)
    gaussian = exp( -a * (t-slide_rec(j)).^4 );
    pg = y' .* gaussian;
    recgt = fft(pg);
    recgt_spec=[recgt_spec; abs(fftshift(recgt))];
    
    % plotting
    subplot(2,1,1)
    plot(t,y,'k-', t,gaussian,'r-', 'LineWidth', [2])
    title(['Signal, Mary had a Little Lamb, Recorder'])
    xlabel(['Time (s)'])
    ylabel(['s(t)'])
    ylim([-1, 1]);
    subplot(2,1,2)
    plot(f_rec,fftshift(recgt))
    xlim([-1500, 1500])
    ylim([-2000, 2000])
    title(['Fourier transform'])
    xlabel(['Frequency (Hz)'])
    ylabel(['FFT(s)'])
    pause(0)
end

[M,I] = max(recgt_spec, [], 2);
%%
close all; clc;

for j = 1:length(M)
    filter = exp( -0.000007 * (f_rec-M(j)) .^ 2);
    recgt_spec_f(j,:) = filter .* recgt_spec(j,:);
%     plot(filter)
%     pause(0)
end

%%
pcolor(slide_rec, f_rec, abs(recgt_spec')), shading interp 
set(gca,'Fontsize',[12]) 
% set(gca,'YTick',(90:1:135))
title(['Spectrogram of Mary Had a Little Lamb, Played on recorder'])
% subtitle([''])
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])
ylim([700,1200])
colormap(hot)