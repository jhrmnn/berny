% makes a supercell. 12/04/07

function [xyz,varargout] = copycell(xyz,abc,lim,atoms)
	[I,J,K] = ndgrid(...
		lim(1,1):lim(1,2),...
		lim(2,1):lim(2,2),...
		lim(3,1):lim(3,2)); % grid of cell indexes
	IJK = [I(:) J(:) K(:)]; % list of cell indexes
	m = size(IJK,1); % number of cells
	shift = IJK*abc; % list of shift vectors
	n = size(xyz,1);
	in = 1:n; % n-index
	im = 1:m; % m-index
	xyz = xyz(in(ones(1,m),:)',:)+shift(im(ones(1,n),:),:);
	if nargout > 1
		varargout{1} = atoms(reshape(in(ones(1,m),:)',m*n,1));
	end
end
