% transforms step in internals into cartesians. 12/04/10

function [xyz,q] = red2car(dq,q,Bi,geom,coords)
	global angstrom
	xyz = geom.xyz;
	thre = 1e-6;
	thre2 = 1e-14;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	wasrecalc = false;
	i = 0;
	while true
		i = i+1;
		geom.xyz = xyz+reshape(0.5*Bi*dq,3,geom.n)'/angstrom;
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
		dxyz = rms(geom.xyz-xyz);
		xyz = geom.xyz;
		q = qnew;
		dq = dqnew;
		err = errnew;
		if dxyz < thre
			msg = 'Perfect transformation to cartesians in %i iterations';
			break
		end
		if i >= maxit
			msg = 'Transformation to cartesians terminated after %ith iteration';
			break
		end
	end
	print(msg,i);
	print('* RMS(dxyz): %.3g, RMS(dq): %.3g',dxyz,err);
end
