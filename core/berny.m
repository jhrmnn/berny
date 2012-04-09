% performs one step of Berny algorithm

function [geom,state] = berny(geom,energy)	
	load workspace.mat ...
		q e g H trust steps ...
		coords symm threshold w
	e.now = energy.E; % energy
	g.now = reshape(energy.g',3*geom.n,1); % cartesian gradient
	alwaysprint('Energy: %4.12f\n',e.now);
	B = Bmat(geom,coords); % Wilson B-matrix
	G = B*B'; 
	Gi = ginv(G);
	proj = G*Gi; % projector on nonredundant subspace
	g.now = w\Gi*B*g.now; % internal weighted gradient
	if steps > 1
		load workspace.mat mintrust
		H = updatehessian(q,g,H);
		trust = updatetrust(q,e,trust,mintrust);
		[t,e.i] = linearsearch(q,e,g);
		q.i = q.best+t*correct(q.now-q.best);
		g.i = g.best+t*(g.now-g.best); % interpolation of gradient
		q.dql = (t-1)*correct(q.now-q.best);
	else
		print('First step: no linear search\n');
		[q,e,g] = shift('now','i',q,e,g);
		q.dql = 0;
	end
	[q.dqq,e.deP] = quadraticstep(proj,g,H,trust);
	state = testconvergence(proj*w*g.i,q.dqtot,threshold);
	[q,e,g] = shift('now','last',q,e,g); % previous calculated point
	q.total = q.dql+q.dqq;
	print('Total step: RMS: %g, maximum absolute: %g\n',...
		rms(q.total),max(abs(q.total)));
	[geom.xyz,q.now] = red2car(q,coords,geom);
	q.dqtot = correct(q.now-q.last);
	if steps <= 1 || e.last < e.best
		[q,e,g] = shift('last','best',q,e,g);
	end
	if ~isempty(symm)
		geom.xyz = symmetrize(geom,symm);
	end
	if state
		print('Optimization ended after %d steps\n',steps);
		return
	end
	steps = steps+1;
 	save -v6 -append workspace.mat H e g q steps
end

function varargout = shift(from,to,varargin)
	for i = 1:length(varargin)
		varargin{i}.(to) = varargin{i}.(from);
	end
	varargout = varargin;
end
