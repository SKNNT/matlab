clear;
clc;

fs = 1000000;       
N = 640;           % Количество отсчетов
Ts = 1/fs;          
f_begin = 0;        % Начальная частота
f_end = 20000;      % Конечная частота

% Расчет угловых частот
f1 = f_begin;       % Начальная частота
f2 = f_end;         % Конечная частота

dp1 = 2 * pi * f1 * Ts;  % Начальная угловая частота
dp2 = 2 * pi * f2 * Ts;  % Конечная угловая частота
ddp = (dp2 - dp1) / N;    % Изменение угловой частоты на каждом шаге

p = 0;                 % Начальное значение фазы
dp = dp2;              % Начальное значение угловой частоты

% Генерация сигнала
y = zeros(1, 2*N);    % Предварительное выделение памяти для сигнала

for i = 1:N
    y(i) = sin(p);    % Вычисление значения синуса
    p = p + dp;       % Обновление фазы
    dp = dp - ddp;    % Обновление угловой частоты
end

for i = N+1:2*N
    y(i) = sin(p);    % Вычисление значения синуса
    p = p + dp;       % Обновление фазы
    dp = dp + ddp;    % Обновление угловой частоты
end


window = hamming(60)';  % Генерация окна Хемминга
y_windowed = zeros(1, 2*N); % Применение окна к сигналу
for j = 1:30
    y_windowed(j) = y(j) .* window(j);
end

for j = 31:N*2-30
    y_windowed(j) = y(j);
end

for j = N*2-29:N*2
    y_windowed(j) = y(j) .* window(j-N*2+60);
end


t = (0:2*N-1) * Ts;     % Временной вектор
figure;
plot(t, y_windowed);
title('Синусоидальный сигнал с ЛЧМ и окном Хемминга');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;


z = zeros(1,15000);
noise = randn(size(z));
z(7000:8279)=y;%Задержка сигнала(модель отражения от цели)
%z=z+noise;

%filename = 'test.wav';
%audiowrite(filename,z,fs);

z=z(1:10:length(z));
y=y(1:10:length(y));
yfilter=abs(filter(y,1,z));%Согласованный фильтр
figure;
plot(z);
figure;
plot(yfilter);
[max,index] = max(yfilter(:));
c=3*100000000;
Distance=(c/2)*(index*(1/(fs/10))/1000); 
disp(Distance);
%load handel.mat;

