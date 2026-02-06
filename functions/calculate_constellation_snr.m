function snr_db = calculate_constellation_snr(symbols)
    % symbols - вектор комплексных чисел после синхронизации
 
    % Убираем переходные процессы (ждем, пока синхронизация сойдется)
    idx = 15000:length(symbols);
    if length(symbols) < 1500, idx = 1:length(symbols); end
    r = symbols(idx);
    % Нормализуем амплитуду сигнала
    % Средняя мощность принятых символов должна быть равна 1
    r = r / sqrt(mean(abs(r).^2));
    % Определяем идеальные точки QPSK
    % Для каждой принятой точки находим ближайшую идеальную (Hard Decision)
    ideal_points = sign(real(r)) + 1i*sign(imag(r));
    % Нормируем идеальные точки
    ideal_points = ideal_points / sqrt(2);

    % Вычисляем вектор ошибки
    errors = r - ideal_points;
    
    % Вычисляем мощности
    P_signal = mean(abs(ideal_points).^2); % Всегда 1 из-за нормировки
    P_noise = mean(abs(errors).^2);        % Дисперсия облака вокруг точек
    
    % Итоговый SNR в дБ
    snr_db = 10 * log10(P_signal / P_noise);
end