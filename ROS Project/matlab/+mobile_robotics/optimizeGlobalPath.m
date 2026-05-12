function optimizedPath = optimizeGlobalPath(plannedPath, goalPose, map)
%OPTIMIZEGLOBALPATH Smooth the global path before TEB tracking.

plannedPath(end, 3) = goalPose(3);
[optimizedPath, ~, ~] = optimizePath(plannedPath, map, optimizePathOptions);

figure("Name", "Optimized Path");
show(map);
hold on;
plot(plannedPath(1, 1), plannedPath(1, 2), "*g", "LineWidth", 3);
plot(plannedPath(end, 1), plannedPath(end, 2), "*r", "LineWidth", 3);
plot(plannedPath(:, 1), plannedPath(:, 2), "r-", "LineWidth", 2);
plot(optimizedPath(:, 1), optimizedPath(:, 2), "g-", "LineWidth", 2);
title("Optimized Global Path");
axis equal;
drawnow;

end

