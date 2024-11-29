clear

r1 = load('measurements.mat').r1;
r2 = load('measurements.mat').r2;
lb(1) = 1;
ep = 10^-6;
p = zeros(1,2);
v = zeros(1,2);
p(1, :) = [-1 0];
v(1, :) = [0 1];
s1 = [0 -1]';
s2 = [1 5]';
k = 1;
T = size(r1, 1);

while(1)
    x = zeros(4, 1);
    x(1) = p(k, 1);
    x(2) = p(k, 2);
    x(3) = v(k, 1);
    x(4) = v(k, 2);
    
    f_value(k) = f(x, r1, r2, T);

    gk = zeros(2,2);
    gk = gradient_f(x, T, r1, r2);
    
    normgk(k) = norm(gk);
    
    if normgk(k) < ep
        pk = p(1, :);
        vk = v(1, :);
        save('task8.mat', 'normgk', 'f_value', 'pk', 'vk') 
        % The final estimate of p and v
        fprintf('The final estimate of p and v:\n')
        fprintf(strcat('p = (', num2str(x(1)), ',', num2str(x(2)), ')\nv = (', num2str(x(3)), ',', num2str(x(4)), ')\n'))
        break
    end

    % solve optimization problem
    A = zeros(2 * T + 4, 4);
    b = zeros(2 * T + 4, 1);
    i = 1;
    for t = 1 : T
        aux = gradient_fit(1, t, x);
        A(i, 1) = aux(1);
        A(i, 2) = aux(2);
        A(i, 3) = aux(3);
        A(i, 4) = aux(4);
        i = i + 1;
    end
    for t = 1 : T
        aux = gradient_fit(2, t, x);
        A(i, 1) = aux(1);
        A(i, 2) = aux(2);
        A(i, 3) = aux(3);
        A(i, 4) = aux(4);
        i = i + 1;
    end
    aux = sqrt(lb(k)) * eye(4);
    A(i, :) = aux(1, :);
    A(i + 1, :) = aux(2, :);
    A(i + 2, :) = aux(3, :);
    A(i + 3, :) = aux(4, :);
    
    i = 1;
    for t = 1 : T
        b(i) = gradient_fit(1, t, x)' * x - fit(1, t, x, r1, r2);
        i = i + 1;
    end
    for t = 1 : T
        b(i) = gradient_fit(2, t, x)' * x - fit(2, t, x, r1, r2);
        i = i + 1;
    end
    b(i) = sqrt(lb(k)) * x(1);
    b(i + 1) = sqrt(lb(k)) * x(2);
    b(i + 2) = sqrt(lb(k)) * x(3);
    b(i + 3) = sqrt(lb(k)) * x(4);
    
    x_opt = A \ b;

    if (f(x_opt, r1, r2, T) < f(x, r1, r2, T))
        p(k + 1, 1) = x_opt(1);
        p(k + 1, 2) = x_opt(2);
        v(k + 1, 1) = x_opt(3);
        v(k + 1, 2) = x_opt(4);
        lb(k + 1) = 0.7 * lb(k);
    else
        p(k + 1, :) = p(k, :);
        v(k + 1, :) = v(k, :);
        lb(k + 1) = 2 * lb(k);
    end
    k = k + 1;
end

function y = fit(i, t, x, r1, r2)
    if i == 1
        r = r1;
        s = [0 -1]';
    else
        r = r2;
        s = [1 5]';
    end
    
    p = zeros(2, 1);
    v = zeros(2, 1);
    p(1) = x(1);
    p(2) = x(2);
    v(1) = x(3);
    v(2) = x(4);
    y = norm(p + (t - 1) * 0.1 * v - s) - r(t);
end

function y = f(x, r1, r2, T)
    y = 0;
    for i = 1 : 2
        for t = 1 : T
            y = y + fit(i, t, x, r1, r2) ^ 2;
        end
    end
end

function y = gradient_fit(i, t, x)
    y = zeros(4, 1);

    if i == 1
        s = [0 -1]';
    else
        s = [1 5]';
    end
    
    p = zeros(2, 1);
    v = zeros(2, 1);
    p(1) = x(1);
    p(2) = x(2);
    v(1) = x(3);
    v(2) = x(4);
    
    aux = norm(p + (t - 1) * 0.1 * v - s);
    y(1) = (p(1) + (t - 1) * 0.1 * v(1) - s(1)) / aux;
    y(2) = (p(2) + (t - 1) * 0.1 * v(2) - s(2)) / aux;
    y(3) = ((t - 1) * 0.1 * (p(1) + (t - 1) * 0.1 * v(1) - s(1))) / aux;
    y(4) = ((t - 1) * 0.1 * (p(2) + (t - 1) * 0.1 * v(2) - s(2))) / aux;

end

function y = gradient_f(x, T, r1, r2)
    y = 0;
    for i = 1 : 2
        for t = 1 : T
            y = y + gradient_fit(i, t, x) * fit(i, t, x, r1, r2);
        end
    end
    y = y * 2;
end
