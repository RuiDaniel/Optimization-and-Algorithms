clear

% task7
q1 = load('target_1.mat').target;
q2 = load('target_2.mat').target;
T = size(q1, 2);
E = [[1 0 0 0]; [0 1 0 0]];
A = [[1 0 0.2 0]; [0 1 0 0.2]; [0 0 0.8 0]; [0 0 0 0.8]];
B = [[0,0]; [0,0]; [0.2 0]; [0 0.2]];
lb = 0.5;
p1 = 0.6;
p2 = 1 - p1;
x_init = [1; 1; 0; 0];
P1 = [];
P2 = [];

% solve optimization problem
cvx_begin quiet
    variable x1(4, T);
    variable x2(4, T);
    variable u1(2, T - 1);
    variable u2(2, T - 1);

    f = p1 * norm(E * x1(:, 1) - q1(:, 1), Inf) + p2 * norm(E * x2(:, 1) - q2(:, 1), Inf);
    % build cost function
    for t = 2 : T
        f = f + p1 * norm(E * x1(:, t) - q1(:, t), Inf) + p2 * norm(E * x2(:, t) - q2(:, t), Inf);
    end
    for t = 1 : T - 1
        f = f + p1 * lb * (u1(1, t)^2 + u1(2, t)^2) + p2 * lb * (u2(1, t)^2 + u2(2, t)^2);
    end
    minimize(f);
    % subject to
    x1(:, 1) == x_init; 
    x2(:, 1) == x_init;
    for t = 1 : T - 1
        if t < 35
            u1(:, t) == u2(:, t);
        end
        x1(:, t + 1) == A * x1(:, t) + B * u1(:, t);
        x2(:, t + 1) == A * x2(:, t) + B * u2(:, t);
    end
cvx_end;

P1 = [P1 mtimes(E, x1)];
P2 = [P2 mtimes(E, x2)];

save('task7.mat','P1','P2','lb') ;


