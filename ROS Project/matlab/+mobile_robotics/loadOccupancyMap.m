function map = loadOccupancyMap(config)
%LOADOCCUPANCYMAP Load and align the occupancy map.

mapImage = imread(config.imageFile);
binaryImage = mapImage < config.occupiedThreshold;
binaryImage = imrotate(binaryImage, 90);

map = binaryOccupancyMap(binaryImage, config.resolution);
map.GridLocationInWorld = config.origin;
inflate(map, config.inflationRadius);

end
