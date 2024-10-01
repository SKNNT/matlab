clear;
fs = 1000000;
N = 1600;
Ts = 1/fs;
f_begin = 0;
f_end = 20000;

f1 = f_begin;
f2 = f_end;

dp1 = 2 * pi * f1 * Ts;
dp2 = 2 * pi * f2 * Ts;
ddp = (dp2 - dp1) / N;

p = 0;
dp = dp2;

y = zeros(1, 2*N);

for i = 1:N
    y(i) = sin(p);
    p = p + dp;
    dp = dp - ddp;
end

for i = N+1:2*N
    y(i) = sin(p);
    p = p + dp;
    dp = dp + ddp;
end
%окно Хемменга 
window = hamming(60)';
y_windowed = zeros(1, 2*N);

for j = 1:30
    y_windowed(j) = y(j) .* window(j);
end

for j = 31:N*2-30
    y_windowed(j) = y(j);
end

for j = N*2-29:N*2
    y_windowed(j) = y(j) .* window(j-N*2+60);
end

t = (0:2*N-1) * Ts;
figure;
plot(t, y_windowed);
title('Синусоидальный сигнал с ЛЧМ и окном Хемминга');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;