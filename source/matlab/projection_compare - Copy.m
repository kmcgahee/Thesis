% Author: Kyle McGahee
% Description: Show that the two methods for coordinate projections are symbollically equivalent. 

clear all

%% Method 1 - Euclidean Space

% Pixel coordinates and camera parameters.
syms u v f pw ph u0 v0

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

% Convert to camera frame by appending focal length and then rotate to world.
ned = R*[sensor; f];

% Convert this vector to a parameterized position vector.
syms S
pos_vec = S*ned + Tr;

% Solve for S so that the last row is zero (the item is on the flat world plane)
S = solve(pos_vec(3) == 0, S);

% Plug back into pos_vec to find actual actual world point.
NED = subs(pos_vec);

% Remove last component because it's zero.
NE_euclidean = NED(1:2);

%% Method 2 - Projective Space

% Convert from pixel to sensor frame in homogenous coordinates.
% sensor_p == sensor prime == sensor'
sensor_p = [0 -ph ph*v0; pw 0 pw*u0; 0 0 1]*[u; v; 1];

% Convert to camera frame
cam = [1/f 0 0; 0 1/f 0; 0 0 1]*sensor_p;

% 3x4 Transformation matrix
% From world to camera frame.
T = [transpose(R) -Tr];

% Modified transformation assuming D=0 so third column is removed.
Tm = [T(:,1:2) T(:,4)];

% Solve for world point.
world_p = inv(Tm)*cam;

% Convert back to non-homogenous coordinates by dividing by scale (S')
NE_projective = world_p(1:2) / world_p(3);

% Third row (R3) is cross product of first two.  Replace symbollically
% in 1st method since these terms won't show up in this method.
R3 = cross(R(1,:), R(2,:));
r31 = R3(1);
r32 = R3(2);
r33 = R3(3);
NE_euclidean = subs(NE_euclidean);

% Display results
%NE_euclidean = simplify(NE_euclidean)
%NE_projective = simplify(NE_projective)

% This will print (1) (true) when the symbollic equations are equivalent.
isAlways(NE_euclidean == NE_projective)

