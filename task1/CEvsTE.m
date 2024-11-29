TE = load('vehicle.mat').TE;
CE = load('vehicle.mat').CE;
lb = load('vehicle.mat').lb;

figure(1)
for i = 1 : size(lb, 2)
    hold all; 
    str = strcat('λ = ', num2str(lb(i)));  
    gg = plot(TE(i), CE(i), 'o', 'DisplayName', str);
    legend('-DynamicLegend');
    set(gg,'LineWidth',1.5);
    title('Graph of CE(λ_i) versus TE(λ_i)');
    xlabel('TE(λ_i)');
    ylabel('CE(λ_i)');
    grid;
end