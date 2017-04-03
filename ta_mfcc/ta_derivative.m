function [ first, second, third, ymat, delta ] = ta_derivative ( fn, x )
% [ first, second, third, ymat ] = derivative ( fn, x )
% 
% Quickndirty estimate of first, second and third derivatives
%   Use eps*50 increment/decrement to estimate for input. %%@ta no, i think you are using delta now, not eps*50...
%     Input can/should be n x 1 vector of points (centres) to evaluate at.
%     first, second, third and fourth derivatives will follow suit as n x 1. %@ta not doing fourth derivatives here
%     ymat output is a n x 7 matrix of samples zigzagging around centres.
%
%     Internal delta specifies the precision multiplying zigzag offsets:
%       [0 -0.5 +0.5 -1.0 +1.0 -1.5 +1.5] 
%
%  For efficiency samples are calculated once + multiple symmetric derivatives.
%  For the same reason the local sampling matrix ymat is made available.
%  Reducing the precision (delta) below that given is dangerous/unstable.
%
% Examples:
% x = [-5:.1:5]';
% [first, second, third, value] = derivative(@sin,x);
% figure(1); plot(x,[first, second, third, value(:,1)]);grid
% [first, second, third, value] = derivative(@normpdf,x);
% figure(2); plot(x,[first, second, third, value(:,1)]);grid
% 
% David M W Powers Jan 2016

% @ta why multiply 10 x 10^-5??? should be 1e-4
%delta = 10e-5; % full delta missing centre if odd, half for even derivatives
% delta = get_delta(x.^-3);
delta = 1e-4;


%% at a grid point
% xmat = [ x-1.5*delta x-0.5*delta x+0.5*delta x+1.5*delta];
% ymat = fn(xmat);
% 
% %% https://dx.doi.org/10.1090%2FS0025-5718-1988-0935077-0
% first = ( ymat(:,3) - ymat(:,2) )/delta;
% second = ( 0.5*ymat(:, 1) - 0.5*ymat(:, 2) - 0.5*ymat(:,3) + 0.5*ymat(:, 4) ) / delta^2;
% third = ( -1*ymat(:, 1) + 3*ymat(:, 2) - 3*ymat(:,3) + 1*ymat(:, 4) ) / delta^3;


%% around the centre
xmat = [ x-2*delta x-1*delta x x+1*delta x+2*delta];
ymat = fn(xmat);

%% https://dx.doi.org/10.1090%2FS0025-5718-1988-0935077-0
first = ( -0.5*ymat(:,2) + 0.5*ymat(:,4) )/delta;
second = ( 1*ymat(:, 2) - 2*ymat(:,3) + 1*ymat(:, 4) ) / delta^2;
third = ( -0.5*ymat(:, 1) + 1*ymat(:, 2) - 1*ymat(:,4) + 0.5*ymat(:, 5) ) / delta^3;

% second = (ymat(:,3)-2*ymat(:,1)+ymat(:,2))/delta^2; %@ta where does '*4' come from?

%@ta where does this come from???
%third = (ymat(:,7)-3*ymat(:,3)+3*ymat(:,2)-ymat(:,6))./delta^3;


% @ta is it this?
%third = -0.5*(ymat(:,2)) + 1*(ymat(:,5)) - 1*(ymat(:,4)) + 0.5 *(ymat(:,3))/delta^3;

% https://en.wikipedia.org/wiki/Finite_difference_coefficient
% for first, this is central finite difference of accuracy 2
% for second, this is 




% % Wikipedia:Numeric Differentiation
% function [delta] = get_delta(x)
% 
% h = sqrt(eps)*x; 
% xph = x + 2 * h; % maximum distance from the curve
% delta = xph - x;
% delta = max(delta); % do something to get a single value for delta
% end

end
% diff(@(1:10).^2)
% derivative(@sin, 3);