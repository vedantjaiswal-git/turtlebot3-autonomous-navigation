function plotTebTracking(map, referencePath, localPath, currentPose)
%PLOTTEBTRACKING Visualize online TEB tracking state.

clf;
show(map);
hold on;
plot(referencePath(:, 1), referencePath(:, 2), ".-");
plot(localPath(:, 1), localPath(:, 2), ".-");
plot(currentPose(1), currentPose(2), "bo");
drawnow;

end

