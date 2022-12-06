function points_out = get_circle_points(r,center)
theta = 0:pi/12:2*pi;

for ii = 1:length(theta)
    x_out(ii) = r*cos(theta(ii));
    y_out(ii) = r*sin(theta(ii));
end
x_out = x_out + center(1);
y_out = y_out + center(2);
points_out = [x_out; y_out];
end