% updates trust radius based on Fletcher's algorithm. 12/04/12

function trust = updatetrust(de,deP,dq,trust)
	if de ~= 0
		r = de/deP; % fletcher's parameter
	else
		r = 1; % round-offs
	end
	if r < 0.25
		trust = norm(dq)/4;
	elseif r > 0.75 && abs(norm(dq)-trust) < 1e-10
		trust = 2*trust;
	end
	print('Trust radius: %.3g',trust);
	print('* Fletcher''s parameter: %.3g',r);
end
