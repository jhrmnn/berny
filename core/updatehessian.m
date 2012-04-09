function H = updatehessian(q,g,H)
	dq = correct(q.now-q.best);
	dg = g.now-g.best;
	BFGS = dg*dg'/(dq'*dg)-H*(dq*dq')*H/(dq'*H*dq); % BFGS update
	MS = (dg-H*dq)*(dg-H*dq)'/(dq'*(dg-H*dq)); % MS update
	Q = abs(dq'*(dg-H*dq))/(norm(dq)*norm(dg-H*dq)); % Bofill's coeff
	dH = (1-Q)*BFGS+Q*MS;
	H = H + dH;
	print('Hessian update information:\n');
	print('* Bofill''s coefficient: %g\n',Q);
	print('* Maximum absolute change: %g\n',norm(diag(dH),inf));
	print('* RMS change: %g\n',rms(dH));
end
