% calculates numerical gradient dXYZ/dZMAT. 12/04/15

function gradxyz = zmatgrad(zmat,step)
%
if nargin==1 ; step = 1e-6; end
npar = length(zmat.var);
nat = size(zmat.def,1);
gradxyz = zeros(npar,3*nat);
zmatd = zmat;
for i = 1:npar
    zmatd.var = zmat.var;
    zmatd.var(i) = zmat.var(i)-2*step;
    X1 = zmat2xyz(zmatd);
    zmatd.var(i) = zmat.var(i)-step;
    X2 = zmat2xyz(zmatd);
    zmatd.var(i) = zmat.var(i)+step;
    X4 = zmat2xyz(zmatd);
    zmatd.var(i) = zmat.var(i)+2*step;
    X5 = zmat2xyz(zmatd);
    G = (X1-8*X2+8*X4-X5)'/12/step;
    gradxyz(i,:) = G(:);
end
    