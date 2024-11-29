clear

% task4
q1 = load('target_1.mat').target;
q2 = load('target_2.mat').target;
T = size(q1, 2);
E = [[1 0 0 0]; [0 1 0 0]];
A = [[1 0 0.2 0]; [0 1 0 0.2]; [0 0 0.8 0]; [0 0 0 0.8]];
B = [[0,0]; [0,0]; [0.2 0]; [0 0.2]];
lb = 0.5;
p1 = [0:0.2:1];
p2 = 1 - p1;
x_init = [1; 1; 0; 0];
TE1 = [];
TE2 = [];
CE = [];
X = [];
P = [];

for i = 1 : 6
    % solve optimization problem
    cvx_begin quiet
        variable x(4, T);
        variable u(2, T - 1);

        f = p1(i) * norm(E * x(:, 1) - q1(:, 1), Inf) + p2(i) * norm(E * x(:, 1) - q2(:, 1), Inf);
        % build cost function
        for t = 2 : T
            f = f + p1(i) * norm(E * x(:, t) - q1(:, t), Inf) + p2(i) * norm(E * x(:, t) - q2(:, t), Inf);
        end
        for t = 1 : T - 1
            f = f + lb * (u(1, t)^2 + u(2, t)^2);
        end
        minimize(f);
        % subject to
        x(:, 1) == x_init; 
        for t = 1 : T - 1
            x(:, t + 1) == A * x(:, t) + B * u(:, t)
        end
    cvx_end;

    TE1_aux = 0;
    TE2_aux = 0;
    for t = 1 : T
        TE1_aux = TE1_aux + norm(E * x(:, t) - q1(:, t), Inf);
        TE2_aux = TE2_aux + norm(E * x(:, t) - q2(:, t), Inf);
    end
    TE1 = [TE1 TE1_aux];
    TE2 = [TE2 TE2_aux];

    CE_aux = 0;
    for t = 1 : T - 1
        CE_aux = CE_aux + (u(1, t)^2 + u(2, t)^2);
    end
    CE = [CE CE_aux];
    P = [P mtimes(E,x)];
end
save('task4.mat','CE','TE1','TE2','P','lb') 


