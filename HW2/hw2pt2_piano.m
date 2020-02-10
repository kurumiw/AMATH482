%% part 2: piano
% clear all; 
close all; clc;

tr_piano=16; % pord time in seconds 
y=audioread('music1.wav'); 
Fs=length(y)/tr_piano;
p8 = audioplayer(y,Fs); 
% playblocking(p8);

n=length(y); 
L = tr_piano;
t2=linspace(0,L,n+1); 
t=t2(1:n); 
k=(2*pi/L)*[0:n/2-1 -n/2:-1]; 
ks=fftshift(k);

f_p = ks/(2*pi);
slide_p = 0:0.5:16;

% vector to store amplitude
pgt_spec=[];

for j = 1:length(slide_p)
    gaussian = exp( -100 * (t-slide_p(j)).^4 );
    pg = y' .* gaussian;
    pgt = fft(pg);
    pgt_spec=[pgt_spec; abs(fftshift(pgt))];
    
    % plotting
    subplot(2,1,1)
    plot(t,y,'k-', t,gaussian,'r-', 'LineWidth', [2])
    title(['Signal, Mary had a Little Lamb, Piano'])
    xlabel(['Time (s)'])
    ylabel(['v(t)'])
    subplot(2,1,2)
    plot(f_p,fftshift(pgt))
    xlim([-1500, 1500])
    ylim([-2000, 2000])
    title(['Fourier transform'])
    xlabel(['Frequency (Hz)'])
    ylabel(['FFT(v)'])
    pause(0)
end

%% spec
close all; clc;

pcolor(slide_p, f_p, abs(pgt_spec')), shading interp 
set(gca,'Fontsize',[12]) 
% set(gca,'YTick',(90:1:135))
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])
ylim([80,150])
colormap(hot)