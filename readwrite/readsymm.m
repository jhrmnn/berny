% reads symmetry definition in CIF format. 12/04/07

function symm = readsymm(filename)
	if isempty(filename)
		symm = [];
		return
	end
	fid = fopen(filename,'r');
	i = 0;
	while ~feof(fid)
		l = fgetl(fid);
		i = i+1;
		symm{i} = str2symm(l);
	end
end

% converts symm string in CIF format to [A,b] matrix
% such that A*(preimage)+b = (image). by Ota Bludsky
function symm = str2symm(str)
	str = ['[' str ']'];
	[x,y,z] = deal(0);
	b = eval(str)';
	one = eye(3);
	A = zeros(3);
	for i = 1:3
		[x,y,z] = deal(one(i,1),one(i,2),one(i,3));
		A(:,i) = eval(str)';
	end
	symm = [A b];
end
