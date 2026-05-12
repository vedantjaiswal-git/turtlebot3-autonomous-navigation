function goalPose = goalHandleToPose(goalHandle, tfTree)
%GOALHANDLETOPOSE Transform the RViz map-frame goal into odometry frame.

poseStamped = ros2message("geometry_msgs/PoseStamped");
poseStamped.header.frame_id = "map";
poseStamped.pose.position.x = goalHandle.x;
poseStamped.pose.position.y = goalHandle.y;
poseStamped.pose.position.z = 0;

quat = axang2quat([0 0 1 goalHandle.theta]);
poseStamped.pose.orientation.w = quat(1);
poseStamped.pose.orientation.x = quat(2);
poseStamped.pose.orientation.y = quat(3);
poseStamped.pose.orientation.z = quat(4);

goalPose = transform(tfTree, "odom", poseStamped);

end

