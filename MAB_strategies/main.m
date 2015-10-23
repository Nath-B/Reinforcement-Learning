%% Build a multi-armed bandit
Arm1=armBernoulli(0.3);
Arm2=armBernoulli(0.5);
Arm3=armBernoulli(0.1);
Arm4=armExp(0.2);
Arm5=armGaussian(0.7,1);

% Bandit : set of arms
MAB={Arm1,Arm2,Arm3,Arm4,Arm5};
NbArms=length(MAB);

% Save the means of the different arms
Means=zeros(1,NbArms);
for i=1:NbArms
    Means(i)=MAB{i}.mean;
end

% Display the different losses and the best bandit
[~, Best_arm]=min(Means);
disp('********** Multi-armed bandit setting **********')
disp(['This multi-armed bandit is composed of ' num2str(NbArms) ' arms'])
for i=1:NbArms
   disp(['Arm ' num2str(i) ' has average loss : ' num2str(Means(i))]) 
end
disp(['The best arm is number ' num2str(Best_arm) ' with average loss ' num2str(Means(Best_arm))])

%% Expected pseudo-regret curve for UCB and the naive strategy
% We run several simulations and average over these simulations
nsim=15; % number of simulations
n=1000; 
T=NbArms*n; % horizon

disp('********** UCB, naive, and mid-strategies **********')
disp('Loading UCB strategy ...')
[mean_reg1, draws1]=mean_regret(nsim,T,MAB,'UCB');
disp('Loading naive strategy ...')
[mean_reg2, draws2]=mean_regret(nsim,T,MAB,'naive');
disp('Loading mid-strategy ...')
[mean_reg3, draws3]=mean_regret(nsim,T,MAB,'midStrategy');

% Compute the two regret bounds given in the course
S=0;
for i=1:NbArms
   if (Means(i)>min(Means))
       delta=Means(i)-min(Means);
       S=S+1/delta;
   end
end

B1=8*log(1:T)*S+NbArms*pi^2/3;
B2=sqrt(NbArms*T*(8*log(1:T)+pi^2/3));

% Plot UCB, naive, and mid-strategy with the two regret bounds
figure;
plot(1:T,mean_reg1); hold on,
plot(1:T,mean_reg2); hold on,
plot(1:T,mean_reg3); hold on,
plot(1:T,B1); hold on,
plot(1:T,B2);

xlabel('Iteration')
ylabel('Regret')
legend('UCB','Naive strategy','Mid-strategy','First Bound', 'Second Bound');
title('Average regret for each strategy for several runs')

% Plot the drawn arms for the mid-strategy
figure;
plot(1:T,draws3);hold on,
xlabel('Iteration')
ylabel('Chosen arm')
ylim([0 6])
legend('Mid-strategy')
title('Drawn arms for mid-strategy')

% Plot the average number of times each arm was chosen for UCB algorithm
figure;
for i=1:NbArms
    plot(cumsum(draws1==i)./(1:T)); hold on,
end
xlabel('Iteration')
ylabel('Average number of times the arm was chosen')
legend('Arm1','Arm2','Arm3','Arm4','Arm5')
title('Average number of times each arm was chosen for UCB algorithm')

%% Mid-strategy with arms switch and doubling coefficients
disp('********** Non iid data **********')
Arm1=armBernoulli(0.2);
Arm2=armBernoulli(0.3);
MAB={Arm1,Arm2};
T=10000;
disp('Loading mid-strategy with arms switch ...')
[mean_reg4, draws4]=mean_regret(nsim,T,MAB,'midStrategy_switch');
[~, draws5]=mean_regret(nsim,T,MAB,'UCB_switch');

figure;
plot(1:T,mean_reg4);
xlabel('Iteration')
ylabel('Regret')
title('Switching and doubling coefficients gap at half horizon')
legend('Mid-strategy')

% Plot the average number of times each arm was chosen for UCB algorithm
figure;
for i=1:NbArms
    plot(cumsum(draws5==i)./(1:T)); hold on,
end
xlabel('Iteration')
ylabel('Average number of times the arm was chosen')
legend('Arm1','Arm2')
title('Average number of times each arm was chosen for UCB algorithm')
