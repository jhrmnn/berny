% transforms step in internals into cartesians. 12/04/10

function [xyz,q] = red2car(dq,q,Bi,geom,coords)
	global angstrom
	xyz = geom.xyz;
	thre = 1e-6;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	i = 0;
	while true
		i = i+1;
		geom.xyz = xyz+reshape(Bi*dq,3,geom.n)'/angstrom;
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		dxyz = rms(geom.xyz-xyz);
		xyz = geom.xyz;
		q = qnew;
		dq = dqnew;
		err = errnew;
		if dxyz < thre
			msg = 'Perfect transformation to cartesians in %i iterations';
			break
		end
		if i == 1
			[xyz1,q1,dxyz1,err1] = deal(xyz,q,dxyz,err);
		end
		if i >= maxit
			msg = 'Transformation did not converge in %i iterations';
			[xyz,q,dxyz,err] = deal(xyz1,q1,dxyz1,err1);
			break
		end
	end
	print(msg,i);
	print('* RMS(dxyz): %.3g, RMS(dq): %.3g',dxyz,err);
end
