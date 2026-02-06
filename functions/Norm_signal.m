function rx_clean = Norm_signal(signal_clean)
    max_amp = max(abs(signal_clean));
    rx_clean = signal_clean / max_amp;
end