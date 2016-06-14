function G=conductance(ri,l)

% calculates conductance, based on the radius and length

% parameters in structure S that are used:
% S.fluidviscosity

global S


G=pi*ri^4./(8*S.fluidviscosity*l);

end