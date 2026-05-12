function publishVelocity(velPub, linearVelocity, angularVelocity)
%PUBLISHVELOCITY Send a planar Twist command.

msg = ros2message("geometry_msgs/Twist");
msg.linear.x = linearVelocity;
msg.angular.z = angularVelocity;
send(velPub, msg);

end

