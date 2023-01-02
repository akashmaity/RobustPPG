function B = createB(normals)
c1 = 0.429043;
c2 = 0.511664;
c3 = 0.743125;
c4 = 0.886227;
c5 = 0.247708;
x = normals(:,1)';
y = normals(:,2)';
z = normals(:,3)';
i = ones(size(x));
B = [c4*i;2*c2*x;2*c2*y;2*c2*z;-c5+c3*z.^2;2*c1*x.*y;2*c1*y.*z;2*c1*x.*z;c1*(x.^2-y.^2)];
end