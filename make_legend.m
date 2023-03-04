function make_legend(varargin)
legend_entries = {};
for ii = 1:nargin
    legend_entries{ii} = varargin{ii};
end
legend(legend_entries)
end