% Gives energy and gradient for atoms interacting pairwise
% via Morse potential. Optional second argument is a column 
% vector of dimensions of a rectangular cell: in that case,
% periodic system is calculated.

function [E,g] = morse(xyz,varargin)
	V = @(r,r0)((1-exp(-(r-r0))).^2-1); % morse potential
	drV = @(r,r0)(2*(1-exp(-(r-r0))).*exp(-(r-r0))); % derivative
	r0 = 0.75; % equilibrium distance
	
	n = size(xyz,1); % number of atoms
	if nargin > 1 % if periodic
		abc = varargin{1}; % cell dimension vector
		range = 20; % cutoff range
		ncell = ceil(range./abc); % size of supercell
		super = copycell(xyz,diag(abc),[-ncell ncell]); % supercell
	else
		super = xyz; % supercell is only one cell
	end
	m = size(super,1); % number of atoms in supercell
	in = (1:n)';
	im = 1:m;
	delta = xyz(in(:,ones(1,m)),:)-super(im(ones(1,n),:),:);
	r = sqrt(sum(delta.^2,2)); % distances
	Vij = V(r,r0);
	Vij(find(triu(ones(n)))) = 0; 
	E = sum(Vij); % energy
	drVij = drV(r,r0);
	dxyzVij = reshape(drVij(:,ones(1,3)).*delta./r(:,ones(1,3)),n,m,3);
	dxyzVij(repmat(find(eye(n)),1,3)+repmat(n*m*(0:2),n,1)) = 0;
	g = permute(sum(dxyzVij,2)/2,[1 3 2]); % gradient
end

% Makes a supercell by applying shift vectors (rows of abc).
function xyz = copycell(xyz,abc,lim)
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
end

