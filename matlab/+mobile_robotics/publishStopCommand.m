function publishStopCommand(velPub)
%PUBLISHSTOPCOMMAND Stop robot motion.

mobile_robotics.publishVelocity(velPub, 0, 0);

end

