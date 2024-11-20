clear
close all
clc

format long e

n = 20;
fib = zeros(n,1);
fib(1:2,1) = [0 1];

for i = 3:1:n
    fib(i) = fib(i-1)+fib(i-2);
end
fib

phi = fib(3:end)./fib(2:end-1)

figure(1)
plot(phi)