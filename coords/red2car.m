% transforms step in internals into cartesians. 12/04/10

function [xyz,q] = red2car(dq,q,Bi,geom,coords)
	global angstrom
	xyz = geom.xyz;
	thre = 1e-6;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	i = 0;
	trust = 1;
	while true
		i = i+1;
		geom.xyz = xyz+reshape(Bi*(trust*dq),3,geom.n)'/angstrom;
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		fletcher = err/errnew;
		if fletcher > 1 && trust < 1
			trust = 2*trust;
		elseif fletcher < 1
			trust = trust/2;
		end
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
