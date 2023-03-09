function cost = find_path_cost(points)
% points is an array formatted [point1; point2;...;pointN] that represents
% the points of our solution

% calculate distances between points
n = size(points, 1);
distances = zeros(n,1);
for i = 1:n-1
    distances(i) = norm(points(i,:) - points(i+1,:));
end
cost = sum(distances);
end