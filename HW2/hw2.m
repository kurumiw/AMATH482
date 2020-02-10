%%
clear all; close all; clc;

load handel
v = y'/2; 
plot((1:length(v))/Fs,v); 
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Signal, Handel''s Mesiah');

p8 = audioplayer(v,Fs); % Sample rate Fs = 8192 Hz
% 8.92 second recording = 73113 data collection over time 
% playblocking(p8);
v = v(1:end-1);

L=9; n=73113; 
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(2*pi/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

S = fft(v);
% subplot(2,1,1)
% plot(t(1:end-1), v);
% subplot(2,1,2)
% plot(ks, fftshift(S))

%%
slide = 0:0.1:9;
Sgt_spec=[];
t=t(1:end-1);
for j = 1:length(slide)
%     gaus = exp(-((t-slide(j)).^2);
    gaus = exp( -30 * (t-slide(j)).^2 );
    Sf = v .* gaus;
    Sft = fft(Sf);
    Sgt_spec=[Sgt_spec; abs(fftshift(Sft))];
    subplot(2,1,1)
    plot(t,v,'k-', t,gaus, 'r-', 'LineWidth', [2] )
    subplot(2,1,2)
%     plot(t, Sf, 'k-', 'LineWidth', [2])
    plot(ks,fftshift(Sft))
    ylim([-150,150])
%     pause(0.1)
end

%%
close all; clc;

% freq = ks.*Fs/9;
Sgt_spec_t = Sgt_spec.';
Sgt_spec_t_trunc = Sgt_spec_t(1:end-1, :);
freq=ks*Fs/(n);
pcolor(slide, freq(1:end-1), Sgt_spec_t_trunc), shading interp 
set(gca,'Fontsize',[14]) 
xlabel('Time (S)
colormap(hot)

%% Part 2
% tr_piano=16; % record time in seconds 
% y=audioread('music1.wav'); 
% Fs=length(y)/tr_piano;
% plot((1:length(y))/Fs,y); 
% xlabel('Time [sec]'); 
% ylabel('Amplitude'); 
% title('Mary had a little lamb (piano)'); drawnow 
% p8 = audioplayer(y,Fs); 
% playblocking(p8);
% 
% figure(2) 
% tr_rec=14; % record time in seconds 
% y=audioread('music2.wav'); 
% Fs=length(y)/tr_rec; 
% plot((1:length(y))/Fs,y); 
% xlabel('Time [sec]'); 
% ylabel('Amplitude'); 
% title('Mary had a little lamb (recorder)'); 
% p8 = audioplayer(y,Fs); 
% playblocking(p8);