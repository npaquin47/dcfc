function lsqfit
% Following lsqlin's notations

%--------------------------------------------------------------------------
% PRE-PROCESSING
%--------------------------------------------------------------------------
% for reproducibility
%rng(125)
degree  = 2;

% data from comment
x       = [0.2096 -3.5761 -0.6252 -3.7951 -3.3525 -3.7001 -3.7086 -3.5907].';
d       = [95.7750 94.9917 90.8417 62.6917 95.4250 89.2417 89.4333 82.0250].';
n_data  = length(d);

% number of equally spaced points to enforce the derivative
n_deriv = 20;
xd      = linspace(min(x), max(x), n_deriv);

% limit on derivative - in each data point
b       = zeros(n_deriv, 1);

% coefficient matrix
C       = nan(n_data, degree+1);
% derivative coefficient matrix
A       = nan(n_deriv, degree);

% loop over polynom terms
for ii  = 1:degree+1
    C(:,ii) = x.^(ii-1);
    A(:,ii) = (ii-1)*xd.^(ii-2);
end

printf("A\n")
disp(A)
printf("C\n")
disp(C)

%--------------------------------------------------------------------------
% FIT - LSQ
%--------------------------------------------------------------------------
% Unconstrained
% p1 = pinv(C)*y
p1      = (C\d);
lsqe    = sum((C*p1 - d).^2);

printf("pinv(C)")
disp(pinv(C))
printf("p1\n")
disp(p1)
printf("lsqe\n")
disp(lsqe)

p2      = polyfit(x,d,degree);

%--------------------------------------------------------------------------
% ANONYMOUS FUNCTION
%--------------------------------------------------------------------------
error_fun = @(p) errfunc(A, C, p, d, lsqe)

% Constrained
[p3, fval] = fminunc(error_fun, p1);

% correct format for polyval
p1      = fliplr(p1.')
p2
p3      = fliplr(p3.')
fval

%--------------------------------------------------------------------------
% PLOT
%--------------------------------------------------------------------------
xx      = linspace(-4,1,100);

plot(x, d, 'x')
hold on
plot(xx, polyval(p1, xx))
plot(xx, polyval(p2, xx),'--')
plot(xx, polyval(p3, xx))

% legend('data', 'lsq-pseudo-inv', 'lsq-polyfit', 'lsq-constrained', 'Location', 'southoutside')
xlabel('X')
ylabel('Y')

endfunction

