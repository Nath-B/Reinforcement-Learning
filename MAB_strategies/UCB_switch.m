function [loss, draws] = UCB_switch(T,MAB)
%Simulates a bandit game of length T with the UCB-alpha strategy

%Initialize the outputs
loss=zeros(1,T);
draws=zeros(1,T);
Nbarms=length(MAB);

%Initialize the sum of losses for each arm for time t=0
S=zeros(1,Nbarms);
%Initialize number of draws for each arm for time t=0
N=zeros(1,Nbarms);

% Initialize by choosing each arm once
for a=1:Nbarms
   N(a)=N(a)+1;
   loss(a)=MAB{a}.play();
   S(a)=S(a)+loss(a);
   draws(a)=a;
end

%Loop over time up to T/2
for t=Nbarms+1:T/2
    B=S./N-sqrt(2*log(t)./N); % here we consider the loss
    [~, draws(t)]=min(B); % we take the minimum loss with UCB-bound
    loss(t)=MAB{draws(t)}.play();
    N(draws(t))=N(draws(t))+1;
    S(draws(t))=S(draws(t))+loss(t);
end

% Switching and doubling coefficients gap at half horizon
p1=MAB{1}.p;
p2=MAB{2}.p;
MAB_switch={armBernoulli(2*p2),armBernoulli(2*p1)};

% Loop over time from T/2+1 to T
for t=(T/2+1):T
    B=S./N-sqrt(2*log(t)./N); % here we consider the loss
    [~, draws(t)]=min(B); % we take the minimum loss with UCB-bound
    loss(t)=MAB_switch{draws(t)}.play();
    N(draws(t))=N(draws(t))+1;
    S(draws(t))=S(draws(t))+loss(t);
end

end