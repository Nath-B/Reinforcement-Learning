function [loss, draws] = midStrategy_switch(T,MAB)
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

% Switching and doubling coefficients gap at half horizon
p1=MAB{1}.p;
p2=MAB{2}.p;
MAB_switch={armBernoulli(2*p2),armBernoulli(2*p1)};

% Chose this arm for the remaining iterations
for t=(Nbarms*T_lim+1):T
    draws(t)=action;
    loss(t)=MAB_switch{action}.play();
end

end

