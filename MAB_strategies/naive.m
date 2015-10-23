function [loss, draws] = naive(T,MAB)
% Simulates a bandit game of length T with the UCB  strategy

% Initialize the outputs
loss=zeros(1,T);
draws=zeros(1,T);
Nbarms=length(MAB);

% Initialize the sum of losses for each arm for time t=0
S=zeros(1,Nbarms);
% Initialize number of draws for each arm for time t=0
N=zeros(1,Nbarms);

% Initialize by choosing each arm once
for a=1:Nbarms
   N(a)=N(a)+1;
   loss(a)=MAB{a}.play();
   S(a)=S(a)+loss(a);
   draws(a)=a;
end

% Loop over time
for t=Nbarms+1:T
    mu=S./N;
    [~, draws(t)]=min(mu); % we try to minimize the average loss
    loss(t)=MAB{draws(t)}.play();
    N(draws(t))=N(draws(t))+1;
    S(draws(t))=S(draws(t))+loss(t);
end

end