Files in this directory solve optimization problems using discrete formulations.  To run, choose one of the files and run it to see results.  There are various options you can modify to change the problems.  You can modify:
- the number of steps taken to reach the solution (usually variable N)
- the interval between x steps when finding the solution (when available)
- change the initial guesses for x and y values, by modifying the x_option and y_option variables
- change the values of the boundary conditions

Problems solved and file that solves:
- short_dist_solver.m: Solves the shortest distance from a start to end point using constant size dx interval between steps
- short_dist_var_dx.m: Solves the shortest distance from a start to end point using varied size dx between steps
- short_dist_curv.m: Solves shortest distance from specified start point to unknown end point along specified curve 

Saving Results:
- Results can be saved to file with save_sim_results.m
- Results can be made into a gif with create_results_gif.m

External Packages Used:
- globalOutputFcns: used to get optimization steps data

