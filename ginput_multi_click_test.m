%from https://www.mathworks.com/matlabcentral/answers/156494-ginput-how-to-prompt-for-value-after-each-click
obstacles = read_obstacle_file('obstacle_envs/6_obstacle.txt');
hold on
for kk = 1:size(obstacles,1)
    plot_obstacle(obstacles(kk,1),obstacles(kk,2:3));
end
workspace;  % Make sure the workspace panel is showing.
fontSize = 24;
% imshow('cameraman.tif');
hold on;
maxAllowablePoints = 5; % Whatever you want.
numPointsClicked = 0;
promptMessage = sprintf('Left click up to %d points.\nRight click when done.', maxAllowablePoints);
titleBarCaption = 'Continue?';
button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
if strcmpi(button, 'Cancel')
  return;
end
while numPointsClicked < maxAllowablePoints
  numPointsClicked = numPointsClicked + 1;
  [x(numPointsClicked), y(numPointsClicked), button] = ginput(1)  
  plot(x(numPointsClicked), y(numPointsClicked), 'r+', 'MarkerSize', 15);
  if button == 3
    % Exit loop if
    break;
  end
end
% Print to command window
x
y
msgbox('Done collecting points');