function obstacles = read_obstacle_file(filename)
% obstacles are formatted [r,x,y] and each row is new obstacle
fid = fopen(filename);
obstacles = [];
tline = fgetl(fid);
action = 0;

while ischar(tline)
    if strcmp(tline,'New Obstacle Set:')
        action = 0; %TODO: implement the code to allow it to read multiple obstacle courses, or figure out how to run python code in matlab
    elseif strcmp(tline,"radius,x,y")
        action = 1;
        tline = fgetl(fid);
    end
    
    if action == 1
       new_obs = read_obstacle(tline); 
       obstacles(end+1,:) = new_obs;
    end
    tline = fgetl(fid);
end
fclose(fid);
end

function out = read_obstacle(obs_string)
    data = split(obs_string,',');
    r = str2double(data{1});
    x = str2double(data{2});
    y = str2double(data{3});
    out = [r,x,y];
end