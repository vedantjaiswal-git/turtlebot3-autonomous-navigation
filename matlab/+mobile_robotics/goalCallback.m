function goalCallback(msg, goalHandle)
%GOALCALLBACK Store the latest RViz goal pose.

goalHandle.x = msg.pose.position.x;
goalHandle.y = msg.pose.position.y;

quat = [msg.pose.orientation.w, ...
        msg.pose.orientation.x, ...
        msg.pose.orientation.y, ...
        msg.pose.orientation.z];
eul = quat2eul(quat);
goalHandle.theta = eul(1);

fprintf("Received goal: x=%.2f, y=%.2f, yaw=%.2f rad\n", ...
    goalHandle.x, goalHandle.y, goalHandle.theta);

end

