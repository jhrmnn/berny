% converts z-matrix to cartesian coordinates. 12/04/15

function xyz = zmat2xyz(zmat)
%
z = zmat.def;
i = z < -1000;
z(i) = zmat.var(-z(i)-1000);
% z(:,[5 7]) = z(:,[5 7])/180*pi;  % deg -> rad

nat = size(z,1);
xyz = zeros(nat,3);
xyz(2,:) = [0 0 z(2,3)];
r3 = z(3,3); a3 = z(3,5);
if z(3,2) == 1
    xyz(3,:) = [r3*sin(a3) 0 r3*cos(a3)];
else
    xyz(3,:) = xyz(2,:)+[r3*sin(a3) 0 -r3*cos(a3)];
end

for i = 4:nat ; xyz(i,:) = addatom(z(i,:),xyz); end

% added by JH, 12/04/16

angstrom = 1.88972613288;
xyz = xyz/angstrom;

end

function X4 = addatom(z,xyz)
%
X1 = xyz(z(6),:);
X2 = xyz(z(4),:);
X3 = xyz(z(2),:);
T = -X3;
X1 = X1+T; X2 = X2+T;
s = dot(X2/norm(X2),[0 0 1]);
if s>1-eps
    R1 = diag([1 1 1]);
elseif s<-1+eps
    R1 = diag([1 1 -1]);
else
    R1 = rotateXY(X2,[0 0 1]);
end
X1 = X1*R1';
phi = atan2(X1(2),X1(1));
R2 = rotate2([0 0 1],phi);
r = z(3);
a = z(5);
d = z(7);
X4 = [r*cos(-d)*sin(a) r*sin(-d)*sin(a) r*cos(a)]; % X1=[1 0 0]; X2=[0 0 1]; X3=[0 0 0];
X4 = X4*R2;
X4 = X4*R1;
X4 = X4-T;

end

function R = rotateXY(X1,X2)
N = cross(X2,X1);
s = sum(X1.*X2);
phi = acos(s/norm(X1)/norm(X2));
nx = N(1)/norm(N);
ny = N(2)/norm(N);
nz = N(3)/norm(N);
s = sin(phi);
ss = sin(phi/2)^2;
R(1,1) = 1-2*(ny*ny+nz*nz)*ss;
R(1,2) = nz*s+2*nx*ny*ss;
R(1,3) = -ny*s+2*nz*nx*ss;
R(2,1) = -nz*s+2*nx*ny*ss;
R(2,2) = 1-2*(nx*nx+nz*nz)*ss;
R(2,3) = nx*s+2*ny*nz*ss;
R(3,1) = ny*s+2*nx*nz*ss;
R(3,2) = -nx*s+2*ny*nz*ss;
R(3,3) = 1-2*(nx*nx+ny*ny)*ss;
end

function R = rotate2(N,phi)
nx = N(1)/norm(N);
ny = N(2)/norm(N);
nz = N(3)/norm(N);
s = sin(phi);
ss = sin(phi/2)^2;
R(1,1) = 1-2*(ny*ny+nz*nz)*ss;
R(1,2) = nz*s+2*nx*ny*ss;
R(1,3) = -ny*s+2*nz*nx*ss;
R(2,1) = -nz*s+2*nx*ny*ss;
R(2,2) = 1-2*(nx*nx+nz*nz)*ss;
R(2,3) = nx*s+2*ny*nz*ss;
R(3,1) = ny*s+2*nx*nz*ss;
R(3,2) = -nx*s+2*ny*nz*ss;
R(3,3) = 1-2*(nx*nx+ny*ny)*ss;
end
