%% TurtleBot3 Autonomous Navigation Pipeline
% This script is the main MATLAB implementation for the project. It connects
% ROS 2 communication, occupancy-map based global planning, path optimization,
% and Time Elastic Band (TEB) trajectory tracking for a TurtleBot3 robot in an
% indoor Gazebo/RViz simulation.
%
% The reusable operations are implemented in the +mobile_robotics package, but
% the complete project workflow and its key parameters are kept here so the
% final script remains self-contained and easy to review.

clear;
close all;
clc;

scriptDir = fileparts(mfilename("fullpath"));
addpath(scriptDir);

%% Configuration
% ROS 2 topics and domain.
config.ros.nodeName = "matlab_node";
config.ros.domainId = 30;
config.ros.cmdVelTopic = "/cmd_vel";
config.ros.odomTopic = "/odom";
config.ros.goalTopic = "/goal_pose";

% Occupancy map alignment. The map is rotated and shifted to match the
% simulation coordinate frame used by Gazebo and RViz.
config.map.imageFile = fullfile(scriptDir, "indoor_map.pgm");
config.map.occupiedThreshold = 100;
config.map.resolution = 1 / 0.05;
config.map.origin = [-4.5, -2.8];
config.map.inflationRadius = 0.05;

% Global planner settings. BiRRT is used as the final planner because it grows
% trees from both the start and goal poses, which is useful in constrained
% indoor maps. PRM and RRT remain available through the helper function.
config.planner.type = "BiRRT";
config.planner.validationDistance = 0.01;
config.planner.maxIterations = 300;
config.planner.maxConnectionDistance = 0.3;
config.planner.prmMaxNodes = 200;
config.planner.prmConnectionDistance = 2.0;

% Local trajectory tracking settings for the TEB controller.
config.teb.robotShape = "Rectangle";
config.teb.robotDimensions = [0.2 0.2];
config.teb.lookAheadTime = 5.0;
config.teb.maxVelocity = [0.5 1.5];
config.teb.maxAcceleration = [0.5 0.5];
config.teb.referenceDeltaTime = 0.3;
config.teb.obstacleSafetyMargin = 0.1;
config.teb.controlRateHz = 5;

% Final heading adjustment after reaching the translational goal.
config.finalTurn.enabled = true;
config.finalTurn.angleRad = pi / 2;
config.finalTurn.angularSpeed = 0.3;
config.finalTurn.toleranceRad = deg2rad(3);

%% ROS 2 Setup
% ROS 2 interfaces: odometry input, RViz goal input, and velocity output.
[node, velPub, odomSub, goalSub, goalHandle] = mobile_robotics.setupRos2(config.ros); %#ok<ASGLU>

%% Map Loading
% Occupancy map used by the global planner and TEB controller.
map = mobile_robotics.loadOccupancyMap(config.map);

%% Scenario Initialization
% Read the current robot pose and the operator-selected RViz goal.
[startPose, goalPose] = mobile_robotics.waitForScenario(node, odomSub, goalHandle, map);

%% Global Planning
% Plan a collision-free SE(2) path through the indoor map.
plannedPath = mobile_robotics.planGlobalPath(map, startPose, goalPose, config.planner);
if isempty(plannedPath)
    error("Navigation:NoGlobalPath", "Global planner did not return a valid path.");
end

%% Path Optimization
% Smooth the global path before handing it to the local trajectory tracker.
optimizedPath = mobile_robotics.optimizeGlobalPath(plannedPath, goalPose, map);

%% TEB Path Following
% Follow the optimized path and publish velocity commands to the robot.
mobile_robotics.followPathWithTeb(optimizedPath, map, odomSub, velPub, config.teb);

%% Final Orientation Control
% Apply the final heading adjustment used by the navigation task.
if config.finalTurn.enabled
    mobile_robotics.rotateInPlace(odomSub, velPub, config.finalTurn, config.teb.controlRateHz);
end

mobile_robotics.publishStopCommand(velPub);
disp("Navigation goal reached.");
