% calculates distance matrix from either (n,3) or (3n,1)
% geometry matrix. 12/04/07

function R = dist(xyz)
	if size(xyz,2) == 1 % if (3n,1)
		xyz = reshape(xyz,3,[])';
	end
	n = size(xyz,1);
	ind = 1:n;
	ind = ind(ones(1,n),:);
	delta = xyz(ind',:)-xyz(ind,:);
	R = reshape(sqrt(sum(delta.^2,2)),n,n); % distances
end

