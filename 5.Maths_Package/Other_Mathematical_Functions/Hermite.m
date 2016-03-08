function [ h ] = Hermite( n,x )
% HERMITE: compute the Hermite polynomials.
% 
%   h = hermite(n)
%   h = hermite(n,x)
% 
% Inputs:
%   - n is the order of the Hermite polynomial (n>=0).
%   - x is (optional) values to be evaluated on the resulting Hermite
%     polynomial function.
% 
% Outputs:
% 1. If x is omitted then h is an array with (n+1) elements that contains
%    coefficients of each Hermite polynomial term.
%    E.g. calling h = hermite(3)
%    will result h = [8 0 -12 0], i.e. 8x^3 - 12x
% 
% 2. If x is given, then h = Hn(x) and h is the same size of x.
%    E.g., H2(x) = 4x^2 - 2
%    calling h = hermite(2,[0 1 2])
%    will result h = [-2 2 14]
    
% n should be positive
if( n<0 )
    disp('The order of Hermite polynomial must be greater than or equal to 0.'); 
    h = NaN;
    return;
end

% n should be an integer
if( 0~=n-fix(n) )
    disp('The order of Hermite polynomial must be an integer.'); 
    h = NaN;
    return;    
end

% compute the hermite recursive function.
h = hermite_recursive(n);

% evaluate the hermite polynomial function, given x
if( nargin==2 )
    y = h(end) * ones(size(x));
    p = 1;
    for i=length(h)-1:-1:1
        y = y + h(i) * x.^p;
        p = p+1;
    end
    
    % restore the shape of y, the same as x
    h = reshape(y,size(x));
end    

function h = hermite_recursive(n)
% This is the reccurence construction of a Hermite polynomial, i.e.:
%   H0(x) = 1
%   H1(x) = 2x
%   H[n+1](x) = 2x Hn(x) - 2n H[n-1](x)

if( 0==n ), h = 1;
elseif( 1==n ), h = [2 0];
else
    
    h1 = zeros(1,n+1);
    h1(1:n) = 2*hermite_recursive(n-1);
    
    h2 = zeros(1,n+1);
    h2(3:end) = 2*(n-1)*hermite_recursive(n-2);
    
    h = h1 - h2;
    
end