function initiate(geom,param)
	global bohr
	bohr = 0.52917720859;
	addpath coords math periodic readwrite
	fid = param.fid;
	xyz = geom.xyz;
	steps = 0;
	save -v6 workspace.mat fid steps
	atoms = geom.atoms;
	m = length(atoms); % number of atoms
	if exist('symm','file') % list of cell symmetries, cif format
		symm = readsymm('symm');
	else
		symm{1} = [eye(3) zeros(3,1)];
	end
	if isfield(geom,'abc')
		periodic=1;
	else
		periodic=0;
	end
	if periodic	% prepare things for periodic case
		abc = geom.abc;
		[xyz] = symmetrize(xyz,abc,symm,strcmp(param.fixedwalls,'yes'));				
		[xyz,atoms] = copycell(xyz,abc,[0 1; 0 1; 0 1],atoms); % make a 2x2x2 supercell
		% the subcells are ordered as (0,0,0),(1,0,0),(0,1,0),...
	else % the old story
		abc = eye(3);
	end
	if exist('allowedbonds','file')
		allowed = readallowed('allowedbonds');
	else
		allowed = struct('types',[],'elems',[],'atoms',[]);
	end
	[ind,rho,nfrag] = genind(xyz,atoms,allowed,m);
	% generates internal coords definition
	if periodic
		ind = reduce(ind,m);
	end
	n = size(ind,1); % number of coords
	if exist('strains','file')
		C = readstrains('strains',ind); % constraint matrix
		constrained = true;
	else
		C = zeros(size(ind,1));
		constrained = false;
	end
	% coordanalysis(ind,m,nfrag); % prints info to log file
	ind = ind(:,1:4);
	q = internals(xyz,ind);
	qbest = q;
	gbest = 0;
	ebest = 0;
	dqtot = 0;
	w = weights(xyz,q,ind,rho);
	if exist('H','file')
		load H
		print('Initial Hessian loaded from file\n');
	else
		H = hessian(rho,ind);
		print('Initial Hessian approximated by Swart''06 model\n');
	end
	ffflush(fid);
	trust = param.trust;
	threshold = [param.gradientmax param.gradientrms param.stepmax param.steprms];
	steps = 1;
	if threshold(4) < 0.5
		mintrust = 1.1*threshold(4)*sqrt(n);
	else
		mintrust = 0.05;
	end
	save -v6 workspace.mat C H abc atoms dqtot ebest constrained ...
		fid gbest ind m n q qbest steps symm threshold trust w xyz ...
		mintrust periodic
end

function symm = readsymm(filename)
	fid = fopen(filename,'r');
	i = 1;
	while ~feof(fid)
		l = fgetl(fid);
		symm{i} = str2symm(l);
		i = i+1;
	end
end		
