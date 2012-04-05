% calculates distance matrix from either (n,3) or (3n,1) geometry matrix

function R = dist(xyz)
	if size(xyz,2) == 1 % if (3n,1)
		xyz = reshape(xyz,3,length(xyz))';
	end
	n = size(xyz,1);
	R = zeros(n);
	for i = 1:n
		for j = 1:n
			R(i,j) = norm(xyz(i,:)-xyz(j,:));
		end
	end
	R(logical(eye(n))) = Inf;
end

