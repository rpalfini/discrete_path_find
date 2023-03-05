function cost = find_path_cost(points)
% points is an array formatted [point1; point2;...;pointN] that represents
% the points of our solution
distances = pdist(points);
cost = sum(distances);
end