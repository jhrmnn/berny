% set default parameters and optionally loads jobfile. 12/04/07

function param = setparam(jobfile)
	param = defaults();
	if nargin > 0
		param = addparams(param,jobfile);
	end
	param.threshold = getthreshold(param); % extract thresholds
end

function param = defaults()
	param.gradientmax = 0.45e-3;
	param.gradientrms = 0.3e-3;
	param.stepmax = 1.8e-3;
	param.steprms = 1.2e-3;
	param.maxsteps = 100;
	param.trust = 0.3;
	param.allowed = '';
	param.symmetry = '';
	param.geomdef = 0;
	param.debug = 0;
	param.restart = '';
end

function param = addparams(param,file)
	fid = fopen(file,'r');
	while ~feof(fid)
		l = fgets(fid);
		if isempty(l) || l(1)=='%' % empty or comment line
			continue
		end
		tok = regexp(l,'(\S+)\s*=\s*(\S+)\s*\n','tokens');
		if isempty(tok)
			continue
		else
			var = tok{1}{1}; % paramter
		end
		if isnan(str2double(tok{1}{2}))
			val = ['''' tok{1}{2} '''']; % non-numerical value
		else
			val = tok{1}{2}; % numerical value
		end
		eval(['param.' var ' = ' val ';']); % evaluate
	end
	fclose(fid);
end

function y = getthreshold(param)
	names = {'gradientrms' 'steprms' 'gradientmax' 'stepmax'};
	y = zeros(1,4);
	for i = 1:4
		y(i) = param.(names{i});
	end
end
