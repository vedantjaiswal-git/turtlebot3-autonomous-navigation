function followPathWithTeb(referencePath, map, odomSub, velPub, config)
%FOLLOWPATHWITHTEB Track the optimized path with a TEB controller.

teb = controllerTEB(referencePath, map);
teb.RobotInformation.Shape = config.robotShape;
teb.RobotInformation.Dimension = config.robotDimensions;
teb.LookAheadTime = config.lookAheadTime;
teb.MaxVelocity = config.maxVelocity;
teb.MaxAcceleration = config.maxAcceleration;
teb.ReferenceDeltaTime = config.referenceDeltaTime;
teb.ObstacleSafetyMargin = config.obstacleSafetyMargin;

rate = robotics.Rate(config.controlRateHz);
goalReached = false;

while ~goalReached
    odomMsg = receive(odomSub, 1);
    currentPose = mobile_robotics.odometryToPose(odomMsg);
    currentVelocity = [odomMsg.twist.twist.linear.x, odomMsg.twist.twist.angular.z];

    [velocityCommands, ~, localPath, info] = step(teb, currentPose, currentVelocity);
    goalReached = info.HasReachedGoal;

    mobile_robotics.plotTebTracking(map, referencePath, localPath, currentPose);
    mobile_robotics.publishVelocity(velPub, velocityCommands(1, 1), velocityCommands(1, 2));

    waitfor(rate);
end

end

