function savedebug(var)
	if ~var.param.debug, return, end
	file = [var.param.name '.mat'];
	if exist(file,'file')
		load(file);
	else
		debug = {};
	end
	var.param.debug = 0;
	var.param.fid = 1;
	debug{end+1} = var;
	save('-v6',file,'debug');
end
