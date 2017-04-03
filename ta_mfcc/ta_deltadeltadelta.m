function [ first, second] = ta_deltadeltadelta ( data )

index = 1:size(data,2);
x = data(:, index);

first = ta_delta(x);
second = ta_delta(first);

end

function [delta] = ta_delta(data)
% TA_DELTA compute delta 

% initialise delta to the correct size
delta = zeros(size(data));

% set the endpoints
delta(1) = -data(1) + data(2);
delta(end) = -data(end) + data(end-1);

% set the other points
delta(2:end-1,:) = ( data(3:end, :) - data(1:end-2, :) ) / 2;

end