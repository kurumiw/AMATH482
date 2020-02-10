close all;
subplot(2,1,1)
pcolor(slide_p, f_p, abs(pgt_spec')), shading interp 
set(gca,'Fontsize',[12]) 
% set(gca,'YTick',(90:1:135))
title(['Spectrogram of Mary Had a Little Lamb, Played on piano'])
% subtitle([''])
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])
ylim([230,340])
colormap(hot)
hold on

subplot(2,1,2)
pcolor(slide_rec, f_rec, abs(recgt_spec')), shading interp 
set(gca,'Fontsize',[12]) 
% set(gca,'YTick',(90:1:135))
title(['Spectrogram of Mary Had a Little Lamb, Played on recorder'])
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])
ylim([750,1100])
hold on
plot(slide_rec, 1023.9,'r-')
colormap(hot)