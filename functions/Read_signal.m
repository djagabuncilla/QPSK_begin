function rx = Read_signal(filename)
    N_read = 6e6;
    fid = fopen(filename, 'r');
    raw = fread(fid, 2 * N_read, 'int16');
    fclose(fid);
    actual_N = floor(length(raw) / 2);
    I = raw(1:2:end);
    Q = raw(2:2:end);
    rx = complex(I(1:actual_N), Q(1:actual_N));
end



