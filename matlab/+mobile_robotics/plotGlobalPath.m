function plotGlobalPath(map, startPose, goalPose, plannedPath, plannerName)
%PLOTGLOBALPATH Visualize the global planner output.

figure("Name", "Global Path");
show(map);
hold on;
plot(startPose(1), startPose(2), "*g", "LineWidth", 3);
plot(goalPose(1), goalPose(2), "*r", "LineWidth", 3);

if ~isempty(plannedPath)
    plot(plannedPath(:, 1), plannedPath(:, 2), "r-", "LineWidth", 2);
end

title("Global Path - " + plannerName);
axis equal;
drawnow;

end

