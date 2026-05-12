function pose = odometryToPose(odomMsg)
%ODOMETRYTOPOSE Convert nav_msgs/Odometry to [x y yaw].

pose = zeros(1, 3);
pose(1) = odomMsg.pose.pose.position.x;
pose(2) = odomMsg.pose.pose.position.y;

quat = [odomMsg.pose.pose.orientation.w, ...
        odomMsg.pose.pose.orientation.x, ...
        odomMsg.pose.pose.orientation.y, ...
        odomMsg.pose.pose.orientation.z];
eul = quat2eul(quat);
pose(3) = eul(1);

end

