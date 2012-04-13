% creates sratch file and sets environemt. 12/04/13

function scr = head(id,program)
	[stat,user] = system('echo $USER');
	scr = sprintf('/scratch/%s/%s',user(1:end-1),id);
	mkdir(scr);
	switch program
		case 'gaussian'
			g09 = regexp(grep('g09root=','G09'),' (/\S+)\)','tokens');
			g09 = [g09{1}{1} '/g09'];
			putenv('GAUSS_SCRDIR',scr);
			putenv('GAUSS_EXEDIR',g09);
			putenv('LD_LIBRARY_PATH',[getenv('LD_LIBRARY_PATH') ':' g09]);
			putenv('PATH',[getenv('PATH') pathsep() g09]);
	end
end

function s = grep(pattern,script)
	[stat,s] = system(['grep ' pattern ' $(which ' script ')']);
end
