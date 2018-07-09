function rotm = azel2rotm(az,el,d)
[x,y,z] = sph2cart(az,el,d);
t = [x,y,z]';

R = viewmtx(az*180/pi+90,el*180/pi);
R = R(1:3,1:3);
t = -R*t;
rotm = [R,t];
end

