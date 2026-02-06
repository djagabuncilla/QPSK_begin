function plot_dvbs2_simple(sig, sps)
    sig = sig(:);
 
    % Нужен ресемплинг, так как SNS можно использовать только целый
    [p, q] = rat(4 / sps, 0.0001);
    sig_res = resample(sig(1:min(end, 100000)), p, q);
    sps_work = 4;

    % Символьная синхронизация
    symbolSync = comm.SymbolSynchronizer('SamplesPerSymbol', sps_work);
    syncedSig = symbolSync(sig_res);

    % Фазовая синхронизация
    carrierSync = comm.CarrierSynchronizer('Modulation', 'QPSK', 'SamplesPerSymbol', 1);
    finalSymbols = carrierSync(syncedSig);

    % Отрисовка чистого созвездия
    figure('Color', 'w');
    
    % Убираем переходные процессы (первые 10000 символов)
    idx = 15000:length(finalSymbols);
    if isempty(idx), idx = 1:length(finalSymbols); end
    
    % Рисуем только точки
    plot(real(finalSymbols(idx)), imag(finalSymbols(idx)), '.', 'MarkerSize', 4);
    grid on; 
    axis square;
    
    % Масштабирование
    limit = 1.5 * median(abs(finalSymbols(idx)));
    if ~isnan(limit) && limit > 0
        xlim([-limit limit]); ylim([-limit limit]);
    end
    snr_val = calculate_constellation_snr(finalSymbols);
    text(limit*0.5, -limit*0.8, sprintf('SNR: %.2f dB', snr_val), ...
     'FontSize', 12, 'FontWeight', 'bold', 'Color', 'white');
    fprintf('Оценка SNR по созвездию: %.2f дБ\n', snr_val);
end