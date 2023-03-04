function [x_span,y_span_guess,N] = make_input_guess(x_start,x_end,dx)
% Uses ginput to make a guess for our problem and modifies guess to match
% it

x0 = x_start(1); y0 = x_start(2); xf = x_end(1); yf = x_end(2);

N = (xf-x0)/dx; % num steps
x_span = x0:dx:xf;
x_span_guess = x_span(2:end-1);

y_guess = ones(1,N-1);

input_clicks = multi_click_input();

input_point_idx = zeros(1,size(input_clicks,1));
for ii = 1:size(input_clicks,1)
    % replaces guesses with ginput click values
    x_click = input_clicks(ii,1)*ones(size(x_span_guess));
    x_diff = abs(x_click-x_span_guess);
    x_idx = find(x_diff==min(x_diff));
    input_point_idx(ii) = x_idx+1; % this is needed b/c x_span_guess is missing entry x0, where as when this is used below, x_span has entry x0
    fprintf('%d idx, %.2f x_click, %.2f x_span\n',x_idx,x_click(1),x_span_guess(x_idx))
    y_guess(x_idx) = input_clicks(ii,2);
end

input_point_idx = sort(input_point_idx);
input_point_idx = [1 input_point_idx length(x_span)];
y_span_guess = [y0 y_guess yf];
for ii = 1:length(input_point_idx)-1
    num_points = input_point_idx(ii+1)-input_point_idx(ii);
    y_at1 = y_span_guess(input_point_idx(ii));
    y_at2 = y_span_guess(input_point_idx(ii+1));
    x_at1 = x_span(input_point_idx(ii));
    x_at2 = x_span(input_point_idx(ii+1));
    slope12 = (y_at2-y_at1)/(x_at2-x_at1);
    dx = x_span(2)-x_span(1);
    for jj = input_point_idx(ii):input_point_idx(ii)+num_points-1
    % creates linear slopes between inputted clicked points
        y_span_guess(jj+1) = y_span_guess(jj) + slope12*dx;
    end
end