%%
clear all; close all; clc;

load handel
v = y'/2; 


p8 = audioplayer(v,Fs); % Sample rate Fs = 8192 Hz
% 8.92 second recording = 73113 data collection over time 
% playblocking(p8);


L=9; % length of recording in seconds
n=length(v); % Fourier modes-- not 2^n but that's okay
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(2*pi/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);


% truncation because not divisible by 2. Overrides original value!
v = v(1:n-1);
t = t(1:n-1);

% convert wavenumbers to frequency
f = ks/(2*pi);

% apply fft to entire signal on time domain
vt = fft(v);


subplot(2,1,1)
plot((1:length(v))/Fs,v); 
xlabel('Time (s)'); 
ylabel('Amplitude'); 
title('Signal, Handel''s Mesiah');
subplot(2,1,2)
plot(ks, fftshift(vt))

%% STFT, Gabor filter
close all; clc;

% define sliding window
slide = 0:0.1:9;

% vector to store amplitude
vgt_spec=[];
tau = 4;

for j = 1:length(slide)
gaussian = exp( -500000 * (t-slide(j)).^4 );
    vg = v .* gaussian;
    vgt = fft(vg);
    vgt_spec=[vgt_spec; abs(fftshift(vgt))];
    
    % plotting
    subplot(3,1,1)
    plot(t,v,'k-', t,gaussian,'r-', 'LineWidth', [2])
    title(['a) Signal, Handel''s Mesiah'])
    xlabel(['Time (s)'])
    ylabel(['v(t)'])
    ylim([-1,1])
    subplot(3,1,2)
    plot(t,vg, 'k-', 'LineWidth', [2])
    title(['b) Windowed Signal, Handel''s Mesiah'])
    xlabel(['Time (s)'])
    ylabel(['v(t)'])
    ylim([-1,1])
    subplot(3,1,3)
    plot(f,fftshift(vgt))
    ylim([-150,150])
    title(['c) Windowed Fourier transform, Handel''s Mesiah'])
    xlabel(['Frequency (Hz)'])
    ylabel(['FFT(v)'])
    pause(0.05)
end
for j = 1:length(slide)
%     gaussian = exp( -40 * (t-slide(j)).^4 );
%     vg = v .* gaussian;
%     vgt = fft(vg);
%     vgt_spec=[vgt_spec; abs(fftshift(vgt))];
%     
%     % plotting
%     subplot(2,1,1)
%     plot(t,v,'k-', t,gaussian,'r-', 'LineWidth', [2])
%     title(['Signal, Handel''s Mesiah'])
%     xlabel(['Time (s)'])
%     ylabel(['v(t)'])
%     subplot(2,1,2)
%     plot(f,fftshift(vgt))
%     ylim([-150,150])
%     title(['Fourier transform'])
%     xlabel(['Frequency (Hz)'])
%     ylabel(['FFT(v)'])
%     pause(0.05)

end

%% plotting
close all; clc;

pcolor(slide, f, vgt_spec'), shading interp 
set(gca,'Fontsize',[12]) 
title([{'Spectrogram of Handel''s Mesiah';'a = 40'}])
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])
colormap(hot)



