%%%
% Author: Kyle McGahee
% Description: Show that the two methods for coordinate projections are symbollically equivalent. 
%%%

clear all

%% Method 1 - Euclidean Space

% Pixel coordinates
syms u v

% Camera parameters.
syms f pw ph u0 v0

% Pixel to sensor frame
sensor = [0 -ph; pw 0]*[u; v] + [ph*v0; pw*u0];

% Rotation matrix
syms r11 r12 r13 r21 r22 r23 r31 r32 r33
R = [r11 r12 r13;
     r21 r22 r23;
     r31 r32 r33];

% Camera's postition in the world frame.
syms tx ty tz
Tr = [tx; ty; tz];

% Convert to camera frame by appending focal length and rotate to world.
ned = R*[sensor; f];

% Convert this vector to a parameterized position vector with param. S
syms S
pos_vec = S*ned + Tr;

% Solve for S so that the last row is zero (the item is on the flat world
% plane)
S = solve(pos_vec(3) == 0, S);

% Plug back into pos_vec to find actual actual world point.
NED = subs(pos_vec)

% Remove last component because it's zero.
NE_euclidean = NED(1:2)
%% Method 2 - Projective Space

% Convert from pixel to sensor frame in homogenous coordinates.
% sensor_p == sensor prime == sensor'
sensor_p = [0 -ph ph*v0; pw 0 pw*u0; 0 0 1]*[u; v; 1];

% Convert to camera frame
cam = [1/f 0 0; 0 1/f 0; 0 0 1]*sensor_p

% 3x4 Transformation matrix
% From world to camera frame.
T = [transpose(R) -Tr];

% 
Tm = [T(:,1:2) T(:,4)]

world_p = inv(Tm)*cam;

% Convert back to non-homogenous coordinates
NE_projective = world_p(1:2) / world_p(3);

R_row = cross(R(1,:), R(2,:));
r31 = R_row(1);
r32 = R_row(2);
r33 = R_row(3);
NE_euclidean = subs(NE_euclidean);

% Display results
simplify(NE_euclidean)
simplify(NE_projective)

isAlways(NE_euclidean == NE_projective)

all_params = [u v f pw ph u0 v0 r11 r12 r13 r21 r22 r23 tx ty tz];
all_values = [23 512 20 .01 .005 500 1000 1 0 0 0 1 0 23.5 15. -5.6];
method1_val = eval(subs(NE_euclidean, all_params, all_values))
method2_val = eval(subs(NE_projective, all_params, all_values))

method1_val ./ method2_val
