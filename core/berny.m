% performs one step of Berny algorithm. 12/04/12

function [state,var] = berny(var)
	global angstrom steps param
	loadvar(var); % extract variables from struct var
	steps = steps+1;
	e.now = energy.E; % energy
	g.now = reshape(energy.g',3*geom.n,1); % gradient in angstroms
	print('Energy: %.12f',e.now,'gui');
	B = Bmat(geom,coords); % Wilson B matrix
	Bi = ginv(B);
	g.now = Bi'*g.now/angstrom; % internal gradient in a.u.
	if isfield(geom,'zmat')
		B = B*zmatgrad(geom.zmat)';
		Bi = ginv(B);
	end
	if steps > 1
		H = updatehessian(H,q.now-q.best,g.now-g.best);
		trust = updatetrust(e.now-e.last,e.deP,q.dqq,trust);
		dq = q.best-q.now;
		[t,ei] = linearsearch(e.now,e.best,g.now'*dq,g.best'*dq);
		e.deP = ei-e.now; % predicted energy change
		q.dql = t*dq; % linear step
		gi = g.now+t*(g.best-g.now); % interpolated gradient
	else
		e.deP = 0;
		q.dql = 0;
		gi = g.now;
	end
	proj = B*Bi; % projector on nonredundant subspace
	Hproj = proj*H*proj+1000*(eye(size(H))-proj); % projected H
	[q.dqq,de] = quadraticstep(proj*gi,Hproj,w,trust);
	e.deP = e.deP+de; % predicted energy change
	q.dq = q.dql+q.dqq; % total inteded step
	print('Total step: RMS: %.3g, max: %.3g',rms(q.dq),max(abs(q.dq)));
	if isfield(geom,'zmat')
		varold = geom.zmat.var;
		[geom.zmat.var,q.new] = red2zmat(q.dq,q.now,Bi,geom,coords);
		geom.xyz = zmat2xyz(geom.zmat);
		dQ = geom.zmat.var-varold;
	else
		[geom.xyz,q.new] = red2car(q.dq,q.now,Bi,geom,coords);
		dQ = q.new-q.now;
	end
	geom.xyz = symmetrize(geom,symm);
	q.dq = q.new-q.now; % total actual step
	state = testconvergence(B'*g.now,dQ,q.dqq,trust);
	if steps == 1 || e.now < e.best
		q.best = q.now; e.best = e.now; g.best = g.now;
	end
	q.now = q.new;
	e.last = e.now;
	var = savevar(geom,q,w,e,g,H,trust,steps,coords,symm,param);
end
		
