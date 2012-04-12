% transforms step in internals into cartesians. 12/04/10

function [xyz,q] = red2car(dq,q,Bi,geom,coords,symm)
	global bohr
	xyz = geom.xyz;
	n = geom.n;
	
	thre = 1e-6;
	thre2 = 1e-14;
	maxit = 200;
	err = rms(dq);
	qtarget = q+dq;
	wasrecalc = false;
	
	i = 0;
	while true
		i = i+1;
		geom.xyz = xyz+bohr*reshape(Bi*dq,3,n)';
		geom.xyz = symmetrize(geom,symm);
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		if errnew > err+thre2 && ~wasrecalc
			geom.xyz = xyz;
			B = Bmat(geom,coords);
			Bi = B'*ginv(B*B')';
			wasrecalc = true;
			i = i-1;
			continue
		end
		wasrecalc = false;
		dx = rms(geom.xyz-xyz);
		xyz = geom.xyz;
		q = qnew;
		dq = dqnew;
		err = errnew;
		if dx < thre
			msg = 'Perfect transformation to cartesian in %i iterations';
			break
		end
		if i >= maxit
			msg = 'Transformation to cartesian terminated after %ith iteration';
			break
		end
	end
	print(msg,i);
	print('* RMS(dx): %.3g, RMS(dq): %.3g',dx,err);
end
