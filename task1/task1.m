clear

% task1
q = load('target_1.mat').target;
T = size(q, 2);
E = [[1 0 0 0]; [0 1 0 0]];
A = [[1 0 0.2 0]; [0 1 0 0.2]; [0 0 0.8 0]; [0 0 0 0.8]];
B = [[0,0]; [0,0]; [0.2 0]; [0 0.2]];
lb = [0.001 0.005 0.01 0.05 0.1 0.5 1 5 10];
x_init = [1; 1; 0; 0];
TE = [];
CE = [];
X = [];
P = [];

for i = 1 : size(lb, 2)
    % solve optimization problem
    cvx_begin quiet
        variable x(4, T);
        variable u(2, T - 1);

        f = norm(E * x(:, 1) - q(:, 1), Inf);
        % build cost function
        for t = 2 : T
            f = f + norm(E * x(:, t) - q(:, t), Inf);
        end
        for t = 1 : T - 1
            f = f + lb(i) * (u(1, t)^2 + u(2, t)^2);
        end
        minimize(f);
        % subject to
        x(:, 1) == x_init; 
        for t = 1 : T - 1
            x(:, t + 1) == A * x(:, t) + B * u(:, t)
        end
    cvx_end;

    TE_aux = 0;
    for t = 1 : T
        TE_aux = TE_aux + norm(E * x(:, t) - q(:, t), Inf);
    end
    TE = [TE TE_aux];

    CE_aux = 0;
    for t = 1 : T - 1
        CE_aux = CE_aux + (u(1, t)^2 + u(2, t)^2);
    end
    CE = [CE CE_aux];
    P = [P mtimes(E,x)];
   
    % loading = size(lb, 2) - i
end
save('vehicle.mat','CE','TE','P','lb') 
CE;
TE;

