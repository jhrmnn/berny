% performs one step of Berny algorithm. 12/04/12

function [geom,state] = berny(geom,energy)
	global param fid angstrom
	load berny.mat q w e g H trust steps coords symm param
	steps = steps+1;
	e.now = energy.E; % energy
	g.now = reshape(energy.g',3*geom.n,1); % gradient in angstroms
	print('Energy: %.12f',e.now,'always');
	B = Bmat(geom,coords); % Wilson B matrix
	G = B*B';
	Gi = ginv(G);
	Bi = B'*Gi'; % inverse B matrix
	proj = G*Gi; % projector on nonredundant subspace
	g.now = Bi'*g.now/angstrom; % internal gradient in a.u.
	if steps > 1
		H = updatehessian(H,correct(q.now-q.best),g.now-g.best);
		trust = updatetrust(e.now-e.last,e.deP,q.dqq,trust);
		dq = correct(q.best-q.now);
		[t,ei] = linearsearch(e.now,e.best,g.now'*dq,g.best'*dq);
		%[t,ei] = deal(0,e.now); % no linear interpolation
		e.deP = ei-e.now; % predicted energy change
		q.dql = t*dq; % linear step
		gi = g.now+t*(g.best-g.now); % interpolated gradient
	else
		e.deP = 0;
		q.dql = 0;
		gi = g.now;
	end
	Hproj = proj*H*proj+1000*(eye(size(H))-proj); % projected H
	[q.dqq,de] = quadraticstep(proj*gi,Hproj,w,trust);
	e.deP = e.deP+de; % predicted energy change
	q.dq = q.dql+q.dqq; % total inteded step
	print('Total step: RMS: %.3g, max: %.3g',...
		rms(q.dq),max(abs(q.dq)));
	[geom.xyz,q.new] = red2car(q.dq,q.now,Bi,geom,coords,symm);
		% transform internal step (a.u.) into cartesian step (angstrom)
	q.dq = correct(q.new-q.now); % total actual step
	state = testconvergence(proj*g.now,q,trust);
	if steps == 1 || e.now < e.best
		q.best = q.now; e.best = e.now; g.best = g.now;
	end
	q.now = q.new;
	e.last = e.now;
 	save -v6 -append berny.mat q e g H trust steps
end
