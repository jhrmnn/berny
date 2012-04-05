function test()
	name = 'H3 molecule';
	geom.atoms = {'H' 'H' 'H'};
	geom.xyz = 0.75/sqrt(2)*eye(3);
	geom.xyz(1,2) = 0.01;
	testcase(geom,name,-3);
	name = 'H crystal';
	geom.atoms = {'H' 'H'};
	geom.xyz = [0 0 0; 0.75 0 0];
	geom.abc = diag([1.5 0.75 0.75]);
	bench = morse(geom.xyz,diag(geom.abc));
	geom.xyz(1,1) = 0.01;
	testcase(geom,name,bench);
end

function testcase(geom,name,bench)
	param = setparam();
	fprintf(1,'testing %s ...\n',name);
	initiate(geom,param);
	while true
		if isfield(geom,'abc')
			[energy.E,energy.g] = morse(geom.xyz,diag(geom.abc));
		else
			[energy.E,energy.g] = morse(geom.xyz);
		end
		[geom,state] = berny(energy);
		if state
			delete workspace.mat
			break
		end
	end
	diff = abs(bench-energy.E);
	if diff < 1e-6
		result = 'ok';
	else
		result = 'FAIL!';
	end
	fprintf(1,'... energy diff is %.3e: %s\n\n',diff,result);
end
