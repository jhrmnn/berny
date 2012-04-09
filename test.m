% runs some tests on the berny package

function test()
	addpath core coords math periodic readwrite tests
	try
		h3molecule();
		hcrystal();
		fau();
		acetic();
	catch ME
		delete workspace.mat
		rethrow(ME);
	end
end

function h3molecule()
	name = 'H3 molecule';
	geom.n = 3;
	geom.atoms = [1 1 1]';
	geom.xyz = 0.75/sqrt(2)*eye(3);
	geom.xyz(1,2) = 0.2;
	geom.periodic = false;
	param = setparam();
	testcase(name,geom,param,-3);
end

function hcrystal()
	name = 'H crystal';
	geom.n = 2;
	geom.atoms = [1 1]';
	geom.xyz = 0.75/2*[1 0 0; -1 0 0];
	geom.periodic = true;
	geom.abc = diag([1.5 0.75 0.75]);
	bench = morse(geom.xyz,diag(geom.abc));
	geom.xyz(:,1) = 0.75/2*[1; -1.01];
	param = setparam();
	param.symmetry = 'h.symm';
	testcase(name,geom,param,bench);
end

function fau()
	name = 'FAU';
	geom = car2geom('fau.vasp');
	param = setparam();
	param.allowed = 'fau.bonds';
	testcase(name,geom,param);
end

function acetic()
	name = 'acetic acid';
	geom = car2geom('acetic.vasp');
	param = setparam();
	testcase(name,geom,param);
end

function testcase(name,geom,param,varargin)
	if geom.periodic, arg{2} = diag(geom.abc); end
	tic;
	fprintf(1,'testing %s ...\n',name);
	geom = initiate(geom,param);
	if nargin == 3
		fprintf(1,'... test finished\n');
	else
		while true
			arg{1} = geom.xyz;
			[energy.E,energy.g] = morse(arg{:});
			[geom,state] = berny(geom,energy);
			if state, break, end
		end
		diff = abs(varargin{1}-energy.E);
		if diff < 1e-6
			result = 'ok';
		else
			result = 'FAIL!';
		end
		fprintf(1,'... energy diff is %.3e: %s\n',diff,result);
	end
	toc;
	fprintf(1,'\n');
	delete workspace.mat
end
