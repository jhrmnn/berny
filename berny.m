% performs one step of Berny algorithm

function [geom,state] = berny(energy)	
	load workspace.mat C H abc atoms dqtot ebest constrained ...
		gbest ind m n q qbest symm threshold trust w xyz steps ...
		mintrust periodic
	e = energy.E; % energy of current step
	g = energy.g; % cartesian gradient of current step
	aprint('Energy: %4.12f\n',e);
	
	B = Bmat(xyz,m,ind); % internal coords and Wilson matrix
	G = B*B'; 
	Gi = ginv(G); % generalized inverse
	proj = G*Gi; % projector on nonredundant subspace
	if constrained
		proj = proj-proj*C*ginv(C*proj*C)*C*proj; % constrained projector
	end
	
	g = reshape(g',3*size(g,1),1);
	g = w\Gi*B*g; % internal weighted gradient
	
	if steps > 1
		load workspace.mat ei deP qi onsphere
		H = updatehessian(correct(q-qbest),g-gbest,H);
		trust = updatetrust(trust,e-ei,deP,correct(q-qi),onsphere,mintrust);
		[t,ei] = linearsearch(ebest,e,gbest'*correct(q-qbest),g'*correct(q-qbest));
	else
		ei = e; % predicted energy change from linear step is zero
		t = 1;
		print('First step: no linear search\n');
	end
	qi = qbest+t*correct(q-qbest);
	gi = gbest+t*(g-gbest); % interpolation of gradient

	[dq,deP,onsphere] = quadraticstep(proj*gi,...
	                    proj*H*proj+1e4*(eye(n)-proj),trust);
	state = testconvergence((eye(n)-C)*proj*w*gi,dqtot,threshold);
	qlast = q; % previous calculated point
	elast = e;
	glast = g;
	print('Total step: RMS: %g, maximum absolute: %g\n',...
		rms((t-1)*correct(q-qbest)+dq),...
		max(abs((t-1)*correct(q-qbest)+dq)));
	[xyz,q] = red2car((t-1)*correct(q-qbest)+dq,q,ind,xyz,abc,m);
	if constrained
		[xyz,q] = red2car(B'*Gi*C,correct(qlast-q),q,ind,xyz,abc,symm,equiv);
	end
	dqtot = correct(q-qlast);
	if steps <= 1 || elast < ebest
		qbest = qlast;
		ebest = elast;
		gbest = glast;
	end
	xyz = symmetrize(xyz,abc,symm);				
	
	if periodic
		xyz = copycell(xyz,abc,[0 1; 0 1; 0 1]);
	end
	geom.atoms = atoms;
	geom.xyz = xyz(1:m,:);
	if periodic
		geom.abc = abc;
	end
	if state
		print('Optimization ended after %d steps\n',steps);
		return
	end
	steps = steps + 1;
 	save -v6 -append workspace.mat H deP dqtot ebest elast ...
		gbest glast onsphere q qbest qlast steps xyz ei qi
end
