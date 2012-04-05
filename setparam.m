function param = setparam(jobname)
	% setting default values
	param.gradientmax = 0.45e-3;
	param.gradientrms = 0.3e-3;
	param.stepmax = 1.8e-3;
	param.steprms = 1.2e-3;
	param.maxsteps = 100;
	param.trust = 0.3;
	param.restart = 'no';
	param.periodic = 'default';
	param.fixedwalls = 'no';
	param.stop = 'berny';
	param.logfile = [];
	% reads the opt file and executes every line in matlab syntax
	if exist('jobname','var')
		fid = fopen(jobname,'r');
		try
			while ~feof(fid)
				l = fgets(fid);
				tok = regexp(l,'(\w+) *= *([^\n]+)\n','tokens');
				if isempty(tok)
					continue
				else
					var = tok{1}{1};
				end
				if isempty(str2num(tok{1}{2}))
					val = ['''' tok{1}{2} ''''];
				else
					val = tok{1}{2};
				end
				eval(['param.' var ' = ' val ';']);
			end
			fclose(fid);
		catch
			fclose(fid);
			error('I cannot read the opt file');
		end
	end
	if isempty(param.logfile)
		param.fid = 1;
	else
		param.fid = fopen(param.logfile,'a');
	end
end
