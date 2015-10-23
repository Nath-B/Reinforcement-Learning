function [loss, draws] = midStrategy(T,MAB)
% Simulates a bandit game of length T with the strategy described 
% in the project

%Initialize the outputs
loss=zeros(1,T);
draws=zeros(1,T);
Nbarms=length(MAB);

% Loop over time and compute the C_k
T_lim=floor(T/(2*Nbarms));
C=zeros(1,Nbarms);

for k=0:(Nbarms-1)
    T_k=k*T_lim+1;
    T_kk=(k+1)*T_lim;
    
    for t=T_k:T_kk
        draws(t)=k+1;
        loss(t)=MAB{draws(t)}.play();
        C(k+1)=C(k+1)+loss(t);
    end
end

% Compute min(C1,...,C_Nbarms)
[~, action]=min(C);

% Choose this arm for the remaining iterations
for t=(Nbarms*T_lim+1):T
    draws(t)=action;
    loss(t)=MAB{action}.play();
end

end

