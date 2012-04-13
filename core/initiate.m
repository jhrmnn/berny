% initiates workspace file and geometry for berny optimizer.
% 12/04/10

function geom = initiate(geom,param)
	global bohr fid steps
	param.threshold = getthreshold(param);
	bohr = 0.52917720859;
	fid = fopen(param.logfile,'w');
	steps = 0;
	trust = param.trust;
	allowed = readallowed(param.allowed); % read allowed bond types
	symm = readsymm(param.symmetry); % read symmetry definition
	geom.xyz = symmetrize(geom,symm);
	[coords,rho] = gencoords(geom,allowed);
	                    % generate internal redundant coordinates
	[q.now,w] = internals(geom,coords,rho);
	                     % evaluate coordinates and their weights
	[e,g] = deal([]); % energy and gradient
	H = hessian(rho,coords); % initial hessian guess
	save -v6 berny.mat q w e g H trust steps coords symm param
end

function y = getthreshold(param)
	names = {'gradientrms' 'steprms' 'gradientmax' 'stepmax'};
	y = zeros(1,4);
	for i = 1:4
		y(i) = param.(names{i});
	end
end
