% makes trust-constrained NR step. 12/04/12

function [dq,deP] = quadraticstep(g,H,w,trust)
	%gw = w*g; % weigh gradient
	gw = g;
	%dq = -H\gw;
	%ev = eig((H+H')/2);
	rfo = [H gw; gw' 0];
	[V,D] = eig((rfo+rfo')/2);
	dq = V(1:end-1,1)/V(end,1);
	if norm(dq) > trust
		steplength = @(l)(norm((l*eye(size(H))-H)\gw)-trust);
		ev = eig((H+H')/2);
		l = findroot(steplength,ev(1)); % minimization on sphere
		dq = (l*eye(size(H))-H)\gw;
		print('Minimization on sphere:');
		print('* Number of negative eigenvalues: %i',...
			length(find(ev<0)));
		print('* Lowest eigenvalue: %.3g',ev(1));
		print('* lambda: %.3g',l);
	end
	deP = g'*dq+0.5*dq'*H*dq; % predicted energy change
	print('Quadratic step: RMS: %.3g, max: %.3g',...
		rms(dq),max(abs(dq)));
	print('* Predicted energy change: %.3g',deP);
end
