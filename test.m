% runs some tests on the berny package

function test()
	addpath core coords math periodic readwrite tests
	try
		h3molecule();
		hcrystal();
% 		fau();
% 		acetic();
	catch % octave doesn't know "catch ME"
		delete berny.mat
		rethrow(lasterror);
	end
end

function h3molecule()
	name = 'H3 molecule';
	geom.n = 3;
	geom.atoms = [1 1 1];
	geom.xyz = [0 0 0; 1 1 0; 2 -1 1];
	geom.periodic = false;
	param = setparam();
	param.stepmax = 1e-5;
	testcase(name,geom,param,-3,'berny');
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
	param.symmetry = 'tests/h.symm';
	testcase(name,geom,param,bench,'berny');
end

function fau()
	name = 'FAU';
	geom = car2geom('tests/fau.vasp');
	param = setparam();
	param.allowed = 'tests/fau.bonds';
	load tests/fau-bench.mat bench
	testcase(name,geom,param,bench,'intro');
end

function acetic()
	name = 'acetic acid';
	geom = car2geom('tests/acetic.vasp');
	param = setparam();
	load tests/acetic-bench.mat bench
	testcase(name,geom,param,bench,'intro');
end

function testcase(name,geom,param,bench,type)
	global angstrom
	if geom.periodic, arg{2} = diag(geom.abc); end
	results = {'ok' 'FAIL!'};
	param.logfile = [name '.txt'];
	param.fid = fopen(param.logfile,'w');
	tic;
	fprintf(1,'testing %s ...\n',name); octfflush(1);
	geom = initiate(geom,param);
	switch type
		case 'intro'
			Gi = bernyintro(geom);
			diff = norm(svd(Gi)-bench);
			what = 'generalized inverse';
		case 'berny'
			geomname = [name '.xyz'];
			if exist(geomname,'file'), delete(geomname), end
			while true
				%writeX(geom,geomname);
				arg{1} = geom.xyz;
				[energy.E,energy.g] = morse(arg{:});
				energy.g = energy.g/angstrom;
				[geom,state] = berny(geom,energy);
				if state, break, end
			end
			diff = abs(bench-energy.E);
			what = 'energy';
	end
	failed = diff > 1e-6;
	fprintf(1,'... %s diff is %.3e: %s\n',...
		what,diff,results{failed+1});
	toc; octfflush(1);
	fprintf(1,'\n');
	delete berny.mat
end
