function [degrees_std2,degrees_stdall,rho] = HkcPick_DegreeSTD(degrees)
% Calculate the standard deviation of the angular variable 
% Input Variable:
% degrees: angular variable in degree, not in radian

radians=deg2rad(degrees);
X_mean=mean(cos(radians),2);
Y_mean=mean(sin(radians),2);
[radian_mean,rho]=cart2pol(X_mean,Y_mean);

% unwrap degrees , comparing with deg_mean
[a,b]=size(degrees);

radian_mean_matrix=zeros(a,b);
for n=1:b
    radian_mean_matrix(:,n)=radian_mean;
end
radian_wrappedres=radians-radian_mean_matrix;
radian_unwrappedres=unwrap(radian_wrappedres,[],2);

radian_std2=std(radian_unwrappedres,0,2);
radian_stdall=std(radian_unwrappedres,0,'all');
degrees_std2=rad2deg(radian_std2);
degrees_stdall=rad2deg(radian_stdall);

end

