function [life_time, rate, half_life, A] = make_real_tm(b,path_file,v)
% function takes a series of bins and concaternated path data and turn them
% into a transition matrix;
%
% b should be a Kx2 matrix, with K being the number of states in your data.
% each row of b specifies the FRET range of a state in your data. For
% example, if you have 3 fret states in your data, which range from 0.1 to
% 0.2, 0.4 to 0.6 and 0.8 to 0.9 then b should be "[0.1 0.2;0.4 0.6; 0.8
% 0.9]"
% path_file should be the name of data text file containing 2 columns . The
% first column must
% contain the trace number and the 2nd column contains the idealized
% trajectory. Here's what a sample path file would look like if you had two
% traces, 5 data points long each:
% 1     0.4
% 1     0.4
% 1     0.6
% 1     0.6
% 1     0.2
% 2     0.6
% 2     0.2
% 2     0.2
% 2     0.6
% 2     0.6

% make sure b is reasonable
[m n] = size(b);
if n ~= 2
    if m == 1 && mod(n,2) == 0
        b = reshape(b,2,length(b)/2)';
    else
        error('b must be Kx2 or 1x2K')
    end
end
% number of states in datat
K = size(b,1);
% initialize transition matrix
A = zeros(K);

% lad path data if given a file
if isstr(path_file)
    path = load(path_file);
    N = path(end,1);
    x_hat = cell(1,N);
    for n = 1:N
        x_hat{n} = path(path(:,1)==n,2);
    end
elseif iscell(path_file)
    x_hat=path_file;
    N = length(x_hat);
else
    error('path_file must be either the name of a concaternated data file, or a cell array of path data');
end

for n=1:N
    T = length(x_hat{n});
    % add counts to A
    for t=1:T-1
        z = between(b,x_hat{n}(t));
        z_1 = between(b,x_hat{n}(t+1));
        % only add count if z and z+1 are allowed states
        if z*z_1
            A(z,z_1) = A(z,z_1) + 1;
        end
    end
end

A = norm(A,2);

rate = -log(diag(A));
life_time = 1./rate;
half_life = -log(0.5)./rate;

% print everything if in verbose mode
if nargin == 3 && v
    disp(' ')
    if isstr(path_file)
        disp(sprintf('File name: %s', path_file))
    end
    disp('FRET ranges:')
    for k = 1:K
        disp(sprintf('%g %g',b(k,1),b(k,2)));
    end
    
    disp('Transition matrix learned')
    disp(A)
    
    disp('Half-lives learned')
    disp(half_life)
    
    disp('Continuous rate constants (k) learned:')
    disp(rate)
    
    disp('Lifetimes (1/k) learned:')
    disp(life_time)

end

function z = between(b,x)


    for k=1:size(b,1)
        if x > min(b(k,:)) && x < max(b(k,:))
            z = k;
            return
        end
    end
    % if not in range
    z = 0;

    
    
    
    
function [M, z] = norm(A, dim)
% NORMALISE Make the entries of a (multidimensional) array sum to 1
% [M, c] = normalise(A)
% c is the normalizing constant
%
% [M, c] = normalise(A, dim)
% If dim is specified, we normalise the specified dimension only,
% otherwise we normalise the whole array.

if nargin < 2
  z = sum(A(:));
  % Set any zeros to one before dividing
  % This is valid, since c=0 => all i. A(i)=0 => the answer should be 0/1=0
  s = z + (z==0);
  M = A / s;
elseif dim==1 % normalize each column
  z = sum(A);
  s = z + (z==0);
  %M = A ./ (d'*ones(1,size(A,1)))';
  M = A ./ repmatC(s, size(A,1), 1);
else
  % Keith Battocchi - v. slow because of repmat
  z=sum(A,dim);
  s = z + (z==0);
  L=size(A,dim);
  d=length(size(A));
  v=ones(d,1);
  v(dim)=L;
  %c=repmat(s,v);
  c=repmat(s,v');
  M=A./c;
end