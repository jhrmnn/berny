% initiates workspace file and geometry for berny optimizer.
% 12/04/10

function var = initiate(geom,param_arg)
	global angstrom steps param
	angstrom = 1.88972613288; % 1 angstrom in a.u.
	steps = 0; % set steps counter
	param = param_arg;
	trust = param.trust; % initial trust radius
	symm = readsymm(param.symmetry); % read symmetry definition
	geom.xyz = symmetrize(geom,symm); % symmetrize geometry
	allowed = readallowed(param.allowed); % read allowed bond types
	[coords,rho,geomdef] = gencoords(geom,allowed);
	                    % generate internal redundant coordinates
	if param.geomdef
		writeX(geomdef,[param.name '.def.xyz']);
	end
	[q.now,w] = internals(geom,coords,rho);
	                     % evaluate coordinates and their weights
	H = hessian(rho,coords); % initial hessian guess
	var = savevar(param,steps,trust,symm,geom,coords,q,w,H);
end
