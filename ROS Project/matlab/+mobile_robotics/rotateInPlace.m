function rotateInPlace(odomSub, velPub, config, controlRateHz)
%ROTATEINPLACE Apply the final heading adjustment used by the pipeline.

rate = robotics.Rate(controlRateHz);
initialPose = mobile_robotics.odometryToPose(receive(odomSub, 2));
targetYaw = wrapToPi(initialPose(3) + config.angleRad);

while true
    currentPose = mobile_robotics.odometryToPose(receive(odomSub, 1));
    yawError = wrapToPi(targetYaw - currentPose(3));

    if abs(yawError) < config.toleranceRad
        break;
    end

    mobile_robotics.publishVelocity(velPub, 0, config.angularSpeed * sign(yawError));
    waitfor(rate);
end

end
