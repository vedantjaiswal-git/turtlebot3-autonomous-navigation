function [startPose, goalPose] = waitForScenario(node, odomSub, goalHandle, map)
%WAITFORSCENARIO Read the current odometry and latest RViz goal.

figure("Name", "Navigation Scenario");
show(map);
hold on;

disp("Waiting for initial odometry and RViz goal...");
odomMsg = receive(odomSub, 10);
startPose = mobile_robotics.odometryToPose(odomMsg);
plot(startPose(1), startPose(2), "go", "MarkerSize", 8, "LineWidth", 2);

tfTree = ros2tf(node);
pause(5);

goalPoseMsg = mobile_robotics.goalHandleToPose(goalHandle, tfTree);
goalPose = [goalPoseMsg.pose.position.x, goalPoseMsg.pose.position.y, goalHandle.theta];
plot(goalPose(1), goalPose(2), "rx", "MarkerSize", 8, "LineWidth", 2);

end

