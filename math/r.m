function [R,grad] = r(xyz,grad)
	v = xyz(1,:)-xyz(2,:);
	R = norm(v);
	if ~exist('grad','var')
		return
	end
	grad = zeros(2,3);
	grad(1,:) = v/norm(v);
	grad(2,:) = -v/norm(v);
end
