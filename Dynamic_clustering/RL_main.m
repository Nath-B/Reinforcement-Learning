% Main file

% Import USERS x URLs
user_url_mat=load('users_urls');
users_urls=user_url_mat.users_urls;

% Import URLs x contexts
url_contexts_mat=load('DELICIOUS_TF_IDF');
url_contexts=url_contexts_mat(:,2:end);

% Load the unique urls and unique users
unique_urls=unique(url_contexts_mat(:,1));
unique_users=unique(users_urls(:,1));

% Display the number of users and urls
n_users=size(unique_users,1);
n_urls=size(unique_urls,1);
disp(['There are ' num2str(n_users) ' users and ' num2str(n_urls) ' urls']);

% Initialize parameters
T=20000; % time horizon
nb_runs = 5; % number of averaging runs for each algorithm
nb_arms=25; % number of arms
K = 16; % number of clusters for DynUCB
alpha = 0.5 ; % exploration parameter for UCB bound
bool_random_gaussian=1; % 1 or 2 for fixed random contexts before the main loop 
						% 3 or 4 for different random contexts at each step
						% 1 and 3 are for gaussian distributed, 2 and 4 for random among dataset
						
% DYN-UCB
[Arms_last,Rewards,success_rate,Clusters_last] = DynUCB_runs(nb_runs,nb_arms,K,url_contexts,users_urls,alpha,T,unique_urls,bool_random_gaussian);
figure
plot(cumsum(Rewards));
disp(['success rate ' num2str(success_rate)]);

% LinUCB_IND
[Arms_last_IND,Rewards_IND,success_rate_IND] = LinUCB_IND_runs(nb_runs,nb_arms,url_contexts,users_urls,alpha,T,unique_urls,bool_random_gaussian);
figure;
plot(cumsum(Rewards_IND));
disp(['success rate ' num2str(success_rate_IND)]);

% LinUCB_SIN
[Arms_last_SIN,Rewards_SIN,success_rate_SIN] = LinUCB_SIN_runs(nb_runs,nb_arms,url_contexts,users_urls,alpha,T,unique_urls,bool_random_gaussian);
figure;
plot(cumsum(Rewards_SIN));
disp(['success rate ' num2str(success_rate_SIN)]);

% Plot them all
figure;
plot(cumsum(Rewards),'r'); hold on,
plot(cumsum(Rewards_IND),'b'); hold on,
plot(cumsum(Rewards_SIN),'g');
legend('DynUCB','LinUCB-IND','LinUCB-SIN');
title('DynUCB, LinUCB-IND and LinUCB-SIN cumulative rewards over iterations');