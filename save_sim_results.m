% run this after a discrete short distance solver, to save the start and
% final points found


fname = 'log_file.txt';

fid = fopen(fname,'a');

fprintf(fid,'%s \n',test_type);
fprintf(fid,'x_guess, x_sol, y_guess, y_sol\n');

for ii = 1:length(x_out)
    if ~strcmp(test_type,'short_dist_solver')
        fprintf(fid,'%f %f %f %f',x_guess(ii),x_out(ii),y_guess(ii))
    else
    end
end

fclose(fid)
% function out_fname = make_file_name
%
% dir_files = dir;
% if
% end
%
% end