q1 = load('target_1.mat').target;
q2 = load('target_2.mat').target;
P1 = load('task7.mat').P1;
P2 = load('task7.mat').P2;
lb = load('task7.mat').lb;
figure(1)
Xtarget1 = [];
Ytarget1 = [];
Xtarget2 = [];
Ytarget2 = [];
Px1 = [];
Py1 = [];
Px2 = [];
Py2 = [];

for i = 1:2:120
    Xtarget1 = [Xtarget1 q1(i)];
    Ytarget1 = [Ytarget1 q1(i + 1)];
    Xtarget2 = [Xtarget2 q2(i)];
    Ytarget2 = [Ytarget2 q2(i + 1)];
    Px1 = [Px1 P1(i)];
    Py1 = [Py1 P1(i + 1)]; 
    Px2 = [Px2 P2(i)];
    Py2 = [Py2 P2(i + 1)]; 
end
figure(1)
xlim([-1.5 1.5]);
hold on 
legend('-DynamicLegend');
title(strcat("Random target with midway information at t = 35 and λ = " ,num2str(lb)));
target1 = plot(Xtarget1,Ytarget1,'r-o','LineWidth',1.5);
target2 = plot(Xtarget2,Ytarget2,'b-o','LineWidth',1.5);
grid on;
vehicle1 = plot(Px1,Py1,'k-o','LineWidth',1.5);
vehicle2 = plot(Px2,Py2,'k-o','LineWidth',1.5);
legend([target1 target2 vehicle1], 'target1', 'target2', 'vehicle');
xlabel('X');
ylabel('Y');

