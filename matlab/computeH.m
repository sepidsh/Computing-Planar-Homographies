function [ H2to1 ] = computeH(x1, x2)
x1 = x1';
x2 = x2';
A = [
    [ -x2(1,:);
      -x2(2,:);
      -ones(1, size(x1,2)); 
      zeros(3, size(x1,2));
      x1(1,:) .* x2(1,:);
      x1(1,:) .* x2(2,:);
      x1(1,:)] [zeros(3, size(x1,2));
      -x2(1,:);
      -x2(2,:);
      -ones(1, size(x1,2));
      x1(2,:) .* x2(1,:);
      x1(2,:) .* x2(2,:);
      x1(2,:)]
     ];
[u, s, v] = svd(A);
u = u(:,9);
u = reshape(u, 3, 3);
H2to1 = u';
end
