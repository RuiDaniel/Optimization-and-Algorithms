q = load('target_1.mat').target;
P = load('vehicle.mat').P;
lambda = load('vehicle.mat').lb; 
figure(1)
Xtarget = [];
Ytarget = [];
Px = [];
Py = [];

for j = 1 : 9
    for i = 1 : 2 : 120
        Xtarget = [Xtarget q(i)];
        Ytarget = [Ytarget q(i + 1)];
        Px = [Px P((j - 1) * 120 + i)];
        Py = [Py P((j - 1) * 120 + i + 1)];    
    end
    figure(j)
    hold on
    str = strcat(' λ = ', num2str(lb(j)));  
    legend('-DynamicLegend');
    title(strcat('Graph for          ', str));
    target = plot(Xtarget,Ytarget,'r-o','LineWidth',1.5);
    grid on;
    vehicle = plot(Px,Py,'k-o','LineWidth',1.5);
    legend([target vehicle ], 'target', 'vehicle');
    Px = [];
    Py = [];
    Xtarget = [];
    Ytarget = [];
end
