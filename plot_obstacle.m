function data_out = plot_obstacle(r,center)
theta = 0:pi/12:2*pi;
x_out = zeros(1,length(theta));
y_out = zeros(1,length(theta));
for ii = 1:length(theta)
    x_out(ii) = r*cos(theta(ii));
    y_out(ii) = r*sin(theta(ii));
end
x_out = x_out + center(1);
y_out = y_out + center(2);
data_out = [x_out',y_out'];

% figure(fig)
plot(x_out,y_out,'Color',[0.4940 0.1840 0.5560],'LineWidth',2)