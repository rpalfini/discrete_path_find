function points_out = multi_click_input()
% based on %from https://www.mathworks.com/matlabcentral/answers/156494-ginput-how-to-prompt-for-value-after-each-click
hold on;
maxAllowablePoints = 20; % Whatever you want.
numPointsClicked = 0;
promptOn = 0;
if promptOn
    promptMessage = sprintf('Left click up to %d points.\nRight click when done.', maxAllowablePoints);
    titleBarCaption = 'Continue?';
    button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
    if strcmpi(button, 'Cancel')
        return;
    end
end
h = [];
while numPointsClicked < maxAllowablePoints
  numPointsClicked = numPointsClicked + 1;
  [x(numPointsClicked), y(numPointsClicked), button] = ginput(1);
  if button == 3
    x_out = x(1:end-1);
    y_out = y(1:end-1);
    points_out = [x_out' y_out'];
    for ii = 1:length(h)
        delete(h(ii))
    end
    return
    % Exit loop if
  end
  h(numPointsClicked) = plot(x(numPointsClicked), y(numPointsClicked), 'r+', 'MarkerSize', 15);
end
x_out = x;
y_out = y;
points_out = [x_out' y_out'];