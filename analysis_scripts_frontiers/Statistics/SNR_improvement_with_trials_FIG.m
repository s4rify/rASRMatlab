chan=23;
erp = [];
figure;
for t = 1:size(MERGED.data,3)
    erp = squeeze(mean(MERGED.data(chan,:,1:t),3));
    plot(MERGED.times,erp, 'k', 'linew',2);
    hold all;
    plot(MERGED.times,squeeze(MERGED.data(chan,:,t)), 'g');
    plot(MERGED.times(IND(1)), erp(IND(1)), '*')
    plot(MERGED.times(IND(2)), erp(IND(2)), '*')
    hold off;
    title(num2str(t));
    axis([MERGED.times(1) MERGED.times(end), -15 15]);
    grid on;
    pause(.3);
end