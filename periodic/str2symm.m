function symm = str2symm(str)
% converts symm string in CIF format to 3x4 matrix
% example: '-x+y,y,1/2+z' --> 
%          [-1 1 0 0; 0 1 0 0; 0 0 1 0.5]
str1 = ['[' str ']' ];
x=0; y=0; z=0;
v0 = eval(str1);
x=1; y=0; z=0;
v1 = eval(str1)-v0;
x=0; y=1; z=0;
v2 = eval(str1)-v0;
x=0; y=0; z=1;
v3 = eval(str1)-v0;
symm = [v1', v2', v3', v0'];