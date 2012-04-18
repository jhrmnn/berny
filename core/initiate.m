% initiates workspace file and geometry for berny optimizer.
% 12/04/10

function geom = initiate(geom,param)
	global angstrom fid steps
	angstrom = 1.88972613288; % 1 angstrom in a.u.
	fid = param.fid; % set fid of logfile
	steps = 0; % set steps counter
	param.threshold = getthreshold(param); % extract thresholds
	trust = param.trust; % initial trust radius
	allowed = readallowed(param.allowed); % read allowed bond types
	symm = readsymm(param.symmetry); % read symmetry definition
	geom.xyz = symmetrize(geom,symm); % symmetrize geometry
	[coords,rho,geomdef] = gencoords(geom,allowed);
	                    % generate internal redundant coordinates
	if param.geomdef
		writeX(geomdef,[param.name '.def.xyz']);
	end
	[q.now,w] = internals(geom,coords,rho);
	                     % evaluate coordinates and their weights
	H = hessian(rho,coords); % initial hessian guess
	save -v6 berny.mat q w H trust steps coords symm param
end

function y = getthreshold(param)
	names = {'gradientrms' 'steprms' 'gradientmax' 'stepmax'};
	y = zeros(1,4);
	for i = 1:4
		y(i) = param.(names{i});
	end
end
