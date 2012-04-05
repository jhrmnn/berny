function trust = updatetrust(trust,de,deP,dq,onsphere,mintrust)
	r = de/deP; % fletcher's parameter
	if de == 0
		r = 1; % round-offs
	end
	print('Fletcher''s parameter: %g\n',r);
	if r < 0.05
		trust = norm(dq)/4;
	elseif r > 0.5 && onsphere
		trust = 2*trust;
	end
	if trust < mintrust
		trust = mintrust;
	elseif trust > 5
		trust = 5;
	end
	print('Trust radius: %g\n',trust);
end
