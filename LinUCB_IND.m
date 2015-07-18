function [Arms,Rewards] = LinUCB_IND(nb_arms,url_contexts,user_urls,alpha,T,unique_urls,bool_random_gaussian)
% Implements the LinUCB_IND strategy

% Define parameters
n_users = size(unique(user_urls(:,1)),1);
n_urls=size(url_contexts,1);

% Define the means and covariance matrices of the contexts
mean_contexts=mean(url_contexts);
std_contexts=std(url_contexts);
% Define the random contexts vectors
if bool_random_gaussian==1
rand_contexts=normrnd(repmat(mean_contexts,[nb_arms-1,1]),repmat(std_contexts,[nb_arms-1,1]));
elseif bool_random_gaussian==2
rand_contexts=url_contexts(floor(rand(1,nb_arms - 1)*n_urls)+1,:); % vector 14x25
end

% INVERSE DICTIONARY FOR USERS
keySet=(1:n_users)';
valueSet=unique(user_urls(:,1));
user_dict = containers.Map(keySet,valueSet);

% DICTIONARY FOR URLS, SAME AS THE ONE FOR CONSTRUCTING CONTEXTS
valueSet_url=(1:n_urls)';
keySet_url=unique_urls;
mapObj_url = containers.Map(keySet_url,valueSet_url);

d=size(url_contexts,2); % Number of PCA components : 25
Arms=zeros(1,T);
Rewards=zeros(1,T);

% Initialize parameters for each user
w=zeros(d,n_users);
b=zeros(d,n_users);
M=zeros(d,d,n_users);
for t=1:n_users
   M(:,:,t)=eye(d); 
end

%% Main loop
for t=1:T
    if mod(t,T/10)==0
        fprintf('.');
    end
    % Select a random user, and its cluster k
    user=floor(rand*n_users)+1;
    
    % Observe the context of 25 arms, 24 of which are randomly taken,
    % and the last one is an URL tagged by this user
    indices_user= user_urls(:,1)==user_dict(user);
    uniques_url_of_user=unique(user_urls(indices_user,2));
    rand_index_url_of_user=floor(rand()*size(uniques_url_of_user,1))+1;
    rand_url_of_user=uniques_url_of_user(rand_index_url_of_user);
   
    context_url=url_contexts(mapObj_url(rand_url_of_user),:);% vector 1x25
     
     % Redefine the random contexts vectors at each step if bool_random_gaussian is 2 or 3
     if bool_random_gaussian==3
     rand_contexts=normrnd(repmat(mean_contexts,[nb_arms-1,1]),repmat(std_contexts,[nb_arms-1,1]));
     elseif bool_random_gaussian==4
     rand_contexts=url_contexts(floor(rand(1,nb_arms - 1)*n_urls)+1,:); % vector 14x25
     end

    contexts=[context_url;rand_contexts]; % vector 15x25

    % Define the UCB nb_arms-row vector
    UCB = zeros(1,nb_arms); % UCB(1) is the 'real URL'
    
    for a=1:nb_arms
        UCB(a) = w(:,user)'*contexts(a,:)' + alpha*sqrt(contexts(a,:)*((M(:,:,user)\(contexts(a,:)'))));
    end
    
    % Define the best arm
    [~,Arms(t)] = max(UCB);
    % Define the reward
    if Arms(t)==1
        Rewards(t)=1;
    else
        Rewards(t)=-1/(nb_arms-1);
    end

    % Define the best arm context
    x_t=contexts(Arms(t),:)'; % vector of size 25x1
    % Update the user's parameters
    M(:,:,user)=M(:,:,user)+x_t*x_t';
    b(:,user)=b(:,user)+Rewards(t)*x_t;
    w(:,user)=M(:,:,user)\b(:,user);
    
end

end

