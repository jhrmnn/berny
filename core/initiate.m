% initiates workspace file and geometry for berny optimizer.
% 12/04/10

function geom = initiate(geom,param)
	global bohr
	bohr = 0.52917720859;
	fid = param.fid;
	steps = 0;
	save -v6 workspace.mat fid steps
	trust = param.trust;
	threshold = param.threshold;
	allowed = readallowed(param.allowed);
	symm = readsymm(param.symmetry);
	if ~isempty(symm)
		geom.xyz = symmetrize(geom,symm);
	end
	[coords,rho] = gencoords(geom,allowed);
	[q.now,w] = internals(geom,coords,rho);
	q.best = q.now;
	[g.best,e.best,q.dqtot] = deal(0);
	H = hessian(rho,coords);
	steps = 1;
	if threshold(4) < 0.5
		mintrust = 1.1*threshold(4)*sqrt(size(coords,1));
	else
		mintrust = 0.05;
	end
	save -v6 -append workspace.mat q e g H trust steps
	save -v6 -append workspace.mat coords symm threshold w mintrust 
end
