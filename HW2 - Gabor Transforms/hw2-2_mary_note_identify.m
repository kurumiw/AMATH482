clc;

%%
for j = 1:length(I)
    index = I(j);
    maxfq(j) = f_rec(index);
end

maxfq = abs(maxfq);

%%
upper = mean(maxfq(maxfq > 1000))   % 1031.4 Hz   C6 
middle = mean(maxfq(maxfq < 950 & maxfq > 850))     % 912.41 Hz  A#5/Bflat5
lower = mean(maxfq(maxfq < 850))    % 815.59 Hz   G#5/Aflat5


%% piano
[Mp,Ip] = max(pgt_spec, [], 2);
for j = 1:length(Ip)
    indexp = Ip(j);
    maxfq_p(j) = f_p(indexp);
end

maxfq_p = abs(maxfq_p);

upper = mean(maxfq_p(maxfq_p > 300))   % 320.08 Hz D#4/Eflat4
middle = mean(maxfq_p(maxfq_p < 300 & maxfq_p > 280))   % 287.07 Hz D4
lower = mean(maxfq_p(maxfq_p < 270 & maxfq_p > 240))   % 256.03 Hz C4

subplot(2,1,1)
plot(slide_p, maxfq_p, 'ro', 'MarkerFaceColor', 'r')
hold on
yline(320.08, '-k', 'LineWidth', [2])
hold on
yline(287.07, '-k', 'LineWidth', [2])
hold on
yline(256.03, '-k', 'LineWidth', [2])
title(['Max Frequency at each transition, Mary Had a Little Lamb on Piano'])
xlabel(['Time (sec)'])
ylabel(['Frequency'])
ylim([230,340])
set(gca,'Fontsize',[12]) 


subplot(2,1,2)
plot(slide_rec, maxfq, 'bo', 'MarkerFaceColor','b')
hold on
yline(1031.4, '-k', 'LineWidth', [2])
hold on
yline(912.41, '-k', 'LineWidth', [2])
hold on
yline(815.59, '-k', 'LineWidth', [2])
title(['Max Frequency at each transition, Mary Had a Little Lamb on Recorder'])
xlabel(['Time (sec)'])
ylabel(['Frequency'])
ylim([750,1100])

set(gca,'Fontsize',[12]) 