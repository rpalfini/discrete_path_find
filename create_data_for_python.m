% packages the data to be loaded and used with python pca

multi_obst = 0;

% trajectory data
% traj_data = [x_out' y_out'];
% traj_id = zeros(length(x_out),1);

traj_data = [];
traj_id = [];

% obstacle data
if multi_obst
    traj_data = [traj_data;
        obst_points_1];
    traj_id_2 = ones(size(obst_points_1,1),1);
    traj_id = [traj_id;
        traj_id_2];

    traj_data = [traj_data;
        obst_points_2];
    traj_id_2 = ones(size(obst_points_2,1),1)*4;
    traj_id = [traj_id;
        traj_id_2];

else
    traj_data = [traj_data;
        obst_points];
    traj_id_2 = ones(size(obst_points,1),1);
    traj_id = [traj_id;
        traj_id_2];
end


% start
traj_data = [traj_data;
            x0 y0];
traj_id = [traj_id;
           2];
% end
traj_data = [traj_data;
            xf yf];
traj_id = [traj_id;
           3];
save_path = 'G:\My Drive\Python\Research\Kernel_PCA_example\';
file_name = 'traj_5_obst.mat';
file_out = strcat(save_path,file_name);
save(file_out,"traj_data","traj_id")