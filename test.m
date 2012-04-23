% runs some tests on the berny package

function test()
	addpath core coords math periodic readwrite tests
	h3molecule();
% 	hcrystal();
% 	fau();
% 	acetic();
% 	cau10();
end

function h3molecule()
	name = 'H3 molecule';
	geom.n = 3;
	geom.atoms = [1 1 1];
	geom.xyz = [0 0 0; 1 1 0; 2 -1 1];
	geom.periodic = false;
	param = setparam();
	param.trust = 1.2;
	testcase(name,geom,param,-3);
end

function hcrystal()
	name = 'H crystal';
	geom.n = 2;
	geom.atoms = [1 1];
	geom.xyz = 0.75/2*[1 0 0; -1 0 0];
	geom.periodic = true;
	geom.abc = diag([1.5 0.75 0.75]);
	bench = morse(geom.xyz,diag(geom.abc));
	geom.xyz(:,1) = 0.75/2*[1; -1.1];
	param = setparam();
	testcase(name,geom,param,bench);
end

function fau()
	name = 'FAU';
	geom = car2geom('tests/fau.vasp');
	param = setparam();
	param.allowed = 'tests/fau.bonds';
	testcase(name,geom,param);
end

function cau10()
	name = 'CAU-10';
	geom = car2geom('tests/cau-10.vasp');
	param = setparam();
	param.symmetry = 'tests/cau-10.symm';
	testcase(name,geom,param);
end

function acetic()
	name = 'acetic acid';
	geom = car2geom('tests/acetic.vasp');
	param = setparam();
	param.geomdef = 1;
	testcase(name,geom,param);
end

function testcase(name,geom,param,bench)
	fdelete([name '.xyz'],[name '.log'],[name '.mat']);
	param.name = name;
	param.fid = fopen([name '.log'],'w');
	fprintf(1,'testing %s ...\n',name);
	t = clock(); % start clock
	var = initiate(geom,param); % prepare stuff
	while true
		geom = var.geom;
		writeX(geom,[name '.xyz']); % write geometry
		if nargin > 3
			if geom.periodic
				[energy.E,energy.g] = morse(geom.xyz,diag(geom.abc));
			else
				[energy.E,energy.g] = morse(geom.xyz);
			end
		else
			energy.E = 0;
			energy.g = zeros(size(geom.xyz));
		end
		var.energy = energy;
		savedebug(var); % save variable environment into debug
		[state,var] = berny(var); % perform berny
		if state, break, end
	end
	fclose(param.fid);
	if nargin > 3
		dE = abs(bench-energy.E);
		if abs(dE) < 1e-6
			result = 'ok';
		else
			result = 'FAIL!';
		end
		concl = sprintf(': E diff is %.3e: %s',dE,result);
	else
		concl = '';
	end
	fprintf('... finished in %.2f seconds%s\n',...
		etime(clock(),t),concl);
end
