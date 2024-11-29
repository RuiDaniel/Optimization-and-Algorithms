clear

norm = load('task8.mat').normgk;
p = load('task8.mat').pk;
v = load('task8.mat').vk;
f = load('task8.mat').f_value;

figure(1)
hold on
str = strcat(' p = (', num2str(p(1)), ',', num2str(p(2)), ') and v = (', num2str(v(1)), ',', num2str(v(2)), ')');
title(strcat('Cost function across iterations k of the LM method for', str));
grid on;
kk = [1 : size(f, 2)];
plot(kk, f, 'LineWidth', 1.5);
xlabel('k');
ylabel('cost function f(x_k)');
ylim([0 500]);
grid minor;

figure(2)
semilogy(kk, norm,'LineWidth',1.5);
title(strcat('Norm of the gradient across iterations k of the LM method for ', str));
xlabel('k');
ylabel('∇f(x_k)');
ylim([10^-8 10^4]);
grid on;
grid minor;

