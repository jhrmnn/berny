function [dq,deP] = quadraticstep(proj,g,H,trust)
	g = proj*g.i;
	H = proj*H*proj+1e4*(eye(size(proj))-proj);
	ev = sort(real(eig(H)));
	dq = -H\g;
	if ev(1) > 0 && norm(dq) < trust
		onsphere = false; % regular NR step was taken
	else
		steplength = @(l)(norm((l*eye(size(H))-H)\g)-trust);
		l = findroot(steplength,ev(1)); % minimization on sphere
		dq = (l*eye(size(H))-H)\g;
		print('Minimization on sphere:\n');
		print('* Negative eigenvalues: %i\n',length(find(ev<0)));
		print('* Lowest eigenvalue: %g\n',ev(1));
		print('* lambda: %g\n',l);
		onsphere = true; % minimization on sphere was performed
	end
	deP = g'*dq+0.5*dq'*H*dq; % predicted energy change
	print('Quadratic step: RMS: %g, maximum absolute: %g\n',...
		rms(dq),max(abs(dq)));
	print('Predicted energy change from quadratic step: %g\n',deP);
end
