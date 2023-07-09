function [tPs,tM1,tM2] = HkcPick_TimeSeperation(H,kappa)
% Calculating Time Seperation
Vp=6.3;
p=0.06;

Vs=Vp./kappa;

eta_s=sqrt(1./Vs.^2-p^2);
eta_p=sqrt(1./Vp.^2-p^2);

tPs=H.*(eta_s-eta_p);
tM1=H.*(eta_s+eta_p);
tM2=2*H.*eta_s;

end

