% makes a supercell

function [xyz,varargout] = copycell(xyz,abc,lim,varargin)
	[I,J,K] = ndgrid(...
		lim(1,1):lim(1,2),...
		lim(2,1):lim(2,2),...
		lim(3,1):lim(3,2)); % grid of cell indexes
	IJK = [I(:) J(:) K(:)]; % list of cell indexes
	IJK(~any(IJK,2),:) = []; % remove (0,0,0) cell
	IJK = [0 0 0; IJK]; % add (0,0,0) cell to beginning
	m = size(IJK,1); % number of cells
	n = size(xyz,1); % number of atoms
	shift = IJK*abc; % list of shift vectors
	in = (1:n)'; % n-index
	im = 1:m; % m-index
	xyz = xyz(in(:,ones(1,m)),:)+shift(im(ones(1,n),:),:);
	if nargout > 1
		varargout{1} = {varargin{1}{in(:,ones(1,m))}}';
	end
end
