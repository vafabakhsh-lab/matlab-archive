function get_real_tm_JF(b,path_file);
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
if size(b,2) ~= 2
    error('b must be Kx2')
end
% number of states in datat
K = size(b,1);
% initialize transition matrix
A = zeros(K);

% load path data
path = load(path_file);
N = path(end,1);
x_hat = cell(1,N);

for n = 1:N
    x_hat{n} = path(path(:,1)==n,2);
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

%rate = -log(diag(A));

%half_life = -log(0.5)./rate;

rate = ln(diag(A));

% print everything
disp(' ')
disp(sprintf('File name: %s', path_file))
disp('FRET ranges:')
for k = 1:K
    disp(sprintf('%g %g',b(k,1),b(k,2)));
end
disp('Transition matrix learned')
disp(A)
disp('Continuous rate constants:')
disp(rate)
disp('Half-lives learned')
disp(half_life)


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