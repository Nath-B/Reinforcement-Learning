function [R,draws] = mean_regret(nsim,T,MAB,strategy)
% Averages the regret over nsim runs of the strategy

NbArms=length(MAB);
% Compute the means of the different arms
Means=zeros(1,NbArms);
for i=1:NbArms
    Means(i)=MAB{i}.mean;
end

sum_loss=zeros(1,T);
for i=1:nsim
    switch strategy
        case 'UCB'
          [loss,draws]=UCB(T,MAB);  
        case 'naive'
           [loss,draws]=naive(T,MAB);
        case 'midStrategy'
           [loss,draws]=midStrategy(T,MAB);
        case 'midStrategy_switch'
           [loss,draws]=midStrategy_switch(T,MAB);
        case 'UCB_switch'
           [loss,draws]=UCB_switch(T,MAB);
    end
sum_loss=sum_loss+loss;
end

mean_loss=sum_loss/nsim;
R=cumsum(mean_loss)-(1:T)*min(Means);

if strcmp(strategy,'midStrategy_switch')||strcmp(strategy,'UCB_switch')

    B_1=zeros(1,T);
    B_2=zeros(1,T);
    B_1(1:T/2)=(MAB{1}.p)*(1:(T/2));
    B_2(1:T/2)=(MAB{2}.p)*(1:(T/2));
    % Switching and doubling coefficients gap at half horizon
    B_1((T/2+1):T)=(MAB{1}.p)*T/2-2*(MAB{2}.p)*T/2+2*(MAB{2}.p)*((T/2+1):T);
    B_2((T/2+1):T)=(MAB{2}.p)*T/2-2*(MAB{1}.p)*T/2+2*(MAB{1}.p)*((T/2+1):T);
    
    R=cumsum(mean_loss)-min(B_1,B_2);
end

end

