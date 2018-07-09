function s2 = render2azel(s3,az,el,d)

rotm = azel2rotm(az,el,d);
%R = R*rotFix;

n = length(s3);
s3c = rotm(:,1:3)*s3'+repmat(rotm(:,4),[1 n]);
s2 = s3c./repmat(s3c(3,:),[3 1]);
s2 = s2(1:2,:);

end

