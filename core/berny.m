% performs one step of Berny algorithm. 12/04/12

function [geom,state] = berny(geom,energy)
	global param fid
	load berny.mat q w e g H trust steps coords symm param
	steps = steps+1;
	e.now = energy.E; % energy
	g.now = reshape(energy.g',3*geom.n,1); % cartesian gradient
	print('Energy: %.12f',e.now,'always');
	B = Bmat(geom,coords); % Wilson B-matrix
	G = B*B';
	Gi = ginv(G);
	Bi = B'*Gi';
	proj = G*Gi; % projector on nonredundant subspace
	g.now = Bi'*g.now; % internal gradient
	if steps > 1
		H = updatehessian(H,correct(q.now-q.best),g.now-g.best);
		trust = updatetrust(e.now-e.last,e.deP,q.dqq,trust);
		dq = correct(q.best-q.now);
		[t,ei] = linearsearch(e.now,e.best,g.now'*dq,g.best'*dq);
		%[t,ei] = deal(0,e.now); % no linear interpolation
		e.deP = ei-e.now;
		q.dql = t*dq;
		q.i = q.now+q.dql;
		g.i = g.now+t*(g.best-g.now);
	else
		print('First step: no linear search');
		[q,e,g] = shift('now','i',q,e,g);
		e.deP = 0;
		q.dql = 0;
	end
	Hproj = proj*H*proj+1000*(eye(size(H))-proj);
	[q.dqq,de] = quadraticstep(proj*g.i,Hproj,w,trust);
	e.deP = e.deP+de;
	q.dq = q.dql+q.dqq;
	print('Total step: RMS: %.3g, max: %.3g',...
		rms(q.dq),max(abs(q.dq)));
	[geom.xyz,q.new] = red2car(q.dq,q.now,Bi,geom,coords,symm);
	q.dq = correct(q.new-q.now);
	state = testconvergence(proj*g.i,q,trust);
	if state
		print('Optimization ended after %i steps',steps);
		if fid > 0, fclose(fid); end
		return
	end
	if steps == 1 || e.now < e.best
		[q,e,g] = shift('now','best',q,e,g);
	end
	q.now = q.new;
	e.last = e.now;
 	save -v6 -append berny.mat q e g H trust steps
end

function varargout = shift(from,to,varargin)
	for i = 1:length(varargin)
		varargin{i}.(to) = varargin{i}.(from);
	end
	varargout = varargin;
end
