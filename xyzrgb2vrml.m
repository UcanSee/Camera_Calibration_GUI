function xyzrgb2vrml(outfile,xyz,rgb)
if(size(xyz,1)~=size(rgb,1))
    error('Input xyz and rgb arguments should have same number of rows');
end
if(size(xyz,2)~=3 | size(rgb,2)~=3)
    error('Input xyz aand rgb arguments should have 3 columns');
end

%% Routines has a hacked way of writing formatted matrices to a file. 
%% If you have smarter ways, please let me know.
fid=fopen(outfile,'w');
% Write VRML header
fprintf(fid,'#VRML V1.0 ascii \n');
% Write point color info
fprintf(fid,'Material{\n');
fprintf(fid,'  diffuseColor [ \n');

% If range of rgb values is >1 divide by 255
if(range(rgb(:))>1)
    rgb=rgb./255;
end
% Append rgb info in "r g b," in row format
for i=1:size(rgb,1)
    fprintf(fid,'%.4g %.4g %.4g,\n',rgb(i,:));
end
%rgb=[num2str(rgb,'%.4g ') repmat(',',size(rgb,1),1)];
%dlmwrite(outfile,rgb,'delimiter','','-append');

% Close parentheses around rgb info 
fprintf(fid,'  ]\n');
fprintf(fid,'}\n');

% Write indexing method
fprintf(fid,'MaterialBinding {\n');
fprintf(fid,'  value PER_VERTEX_INDEXED\n');
fprintf(fid,'}\n');

% Write point vertices
fprintf(fid,'Coordinate3 {\n');
fprintf(fid,'  point [\n');

% Append xyz info in "x y z," in row format
for i=1:size(xyz,1)
    fprintf(fid,'%.4g %.4g %.4g,\n',xyz(i,:));
end
%xyz=[num2str(xyz,'%.4g ') repmat(',',size(xyz,1),1)];
%dlmwrite(outfile,xyz,'delimiter','','-append');

% Close parentheses around xyz info
%fid=fopen(outfile,'a');
fprintf(fid,'  ]\n');
fprintf(fid,'}\n');

% Write indexing method
fprintf(fid,'PointSet {\n');
fprintf(fid,'  startIndex 0\n');
fprintf(fid,'  numPoints %d\n',size(xyz,1));
fprintf(fid,'}\n');
fclose(fid);
