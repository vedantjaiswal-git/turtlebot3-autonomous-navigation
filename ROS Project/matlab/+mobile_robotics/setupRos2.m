function [node, velPub, odomSub, goalSub, goalHandle] = setupRos2(config)
%SETUPROS2 Create ROS 2 interfaces used by the navigation pipeline.

node = ros2node(config.nodeName, config.domainId);
velPub = ros2publisher(node, config.cmdVelTopic, "geometry_msgs/Twist");
odomSub = ros2subscriber(node, config.odomTopic, "nav_msgs/Odometry");

goalHandle = PoseHandle();
goalSub = ros2subscriber(node, config.goalTopic, "geometry_msgs/PoseStamped", ...
    @(msg) mobile_robotics.goalCallback(msg, goalHandle));

end
