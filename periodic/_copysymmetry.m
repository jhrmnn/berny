% restores a complete molecular systems given the unique atoms and
% symmetry

function xyz2 = copysymmetry(xyz,abc,symm,equiv)
	m = length(symm);
	n = size(xyz,1);
	A = inv(abc)';
	for i=1:n
		xyz(i,:) = (A*xyz(i,:)')'; % transforms to fractional
	end
	xyz2 = zeros(max(max(equiv(:,m))),3);
	for i=1:n
		for j=1:m
			xyz2(equiv(i,j),:) = (symm{j}(:,1:3)*xyz(i,:)'...
			                     +symm{j}(:,4)+equiv(i,m+(j-1)*3+(1:3))')';
		end
	end
	for i=1:size(xyz2,1)
		xyz2(i,:) = (abc'*xyz2(i,:)')'; % transforms back to cartesian
	end
end	
