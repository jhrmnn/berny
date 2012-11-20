global angstrom
dirs = {'core' 'coords' 'math' 'periodic' 'readwrite' 'tests'};
for i = 1:length(dirs)
	addpath([pwd filesep dirs{i}]);
end
angstrom = 1.88972613288;

param = setparam();
param.fid = 1;
param.name = 'test';
param.debug = 1;
param.geomdef = 1;