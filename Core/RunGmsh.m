function RunGmsh(GeoFile, Parameters, NrOfdimensions, Output)
% This function copy the content of the GeoFile.geo file and add the 
% defintions of parameters in the Output.geo File which is converted 
% in .msh format.
% At the end all the elements are created with the function Gmsh2CodeFEM
%-----------------------------------------------------------------------
% GeoFile : File in which the data will be recovered
% Parameters : Structure which contained the data on the parameters of the
% mesh.
% NrOfdimensions : Number of dimensions of the problem
% Output : Name of the output file (.geo and .msh)
%-----------------------------------------------------------------------

% Open the output file
outfile = fopen([Output '.geo'], 'w+');

% Write the definitions of the parameters
names = fieldnames(Parameters);
for n=1:length(names)
    if isfloat(Parameters.(names{n}))
        fprintf(outfile, [names{n} ' = %.16f;\n'], Parameters.(names{n}));
    end
end
fprintf(outfile, '\n');

% Open the original file
infile = fopen(GeoFile, 'r+');
% Copy its content into the output file
while ~feof(infile)
    x = fgets(infile);
    fprintf(outfile, '%s', x);
end

fclose(infile);
fclose(outfile);

% Run gmsh to produce the .msh file
system(['gmsh ' Output ['.geo -' num2str(NrOfdimensions) ' -optimize_ho -v 0 -format msh2' ]]);

% Parse the .msh file to create the elements
Gmsh2CodeFem([Output '.msh'], Output);
