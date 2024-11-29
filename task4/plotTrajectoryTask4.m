q1 = load('target_1.mat').target;
q2 = load('target_2.mat').target;
P = load('task4.mat').P;
figure(1)
Xtarget1 = [];
Ytarget1 = [];
Xtarget2 = [];
Ytarget2 = [];
Px = [];
Py = [];

for j = 1:6
    for i = 1:2:120
        Xtarget1 = [Xtarget1 q1(i)];
        Ytarget1 = [Ytarget1 q1(i + 1)];
        Xtarget2 = [Xtarget2 q2(i)];
        Ytarget2 = [Ytarget2 q2(i + 1)];
        Px = [Px P((j - 1) * 120 + i)];
        Py = [Py P((j - 1) * 120 + i + 1)];    
    end
    figure(j)
    hold on
    str = strcat(' instance i = ', num2str(j));  
    legend('-DynamicLegend');
    title(strcat('Graph for          ', str));
    target1 = plot(Xtarget1,Ytarget1,'r-o','LineWidth',1.5);
    target2 = plot(Xtarget2,Ytarget2,'b-o','LineWidth',1.5);
    grid on;
    vehicle = plot(Px,Py,'k-o','LineWidth',1.5);
    legend([target1 target2 vehicle ], 'target1', 'target2', 'vehicle');
    xlabel('X');
    ylabel('Y');
    Px = [];
    Py = [];
    Xtarget1 = [];
    Ytarget1 = [];
    Xtarget2 = [];
    Ytarget2 = [];
end
