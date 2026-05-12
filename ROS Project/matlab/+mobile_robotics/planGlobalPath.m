function plannedPath = planGlobalPath(map, startPose, goalPose, config)
%PLANGLOBALPATH Generate a collision-free global path.

stateSpace = stateSpaceSE2;
stateValidator = validatorOccupancyMap(stateSpace);
stateValidator.Map = map;
stateValidator.ValidationDistance = config.validationDistance;
stateSpace.StateBounds = [map.XWorldLimits; map.YWorldLimits; [-pi pi]];

switch config.type
    case "PRM"
        planner = plannerPRM(stateSpace, stateValidator, ...
            "MaxNumNodes", config.prmMaxNodes, ...
            "MaxConnectionDistance", config.prmConnectionDistance);

    case "BiRRT"
        planner = plannerBiRRT(stateSpace, stateValidator);
        planner.MaxIterations = config.maxIterations;
        planner.MaxConnectionDistance = config.maxConnectionDistance;

    case "RRT"
        planner = plannerRRT(stateSpace, stateValidator);
        planner.MaxIterations = config.maxIterations;
        planner.MaxConnectionDistance = config.maxConnectionDistance;

    otherwise
        error("Navigation:UnknownPlanner", "Unknown global planner: %s", config.type);
end

[path, solutionInfo] = plan(planner, startPose, goalPose);

if solutionInfo.IsPathFound
    plannedPath = path.States;
else
    plannedPath = [];
    warning("Navigation:NoGlobalPath", "%s planner did not find a path.", config.type);
end

mobile_robotics.plotGlobalPath(map, startPose, goalPose, plannedPath, config.type);

end

