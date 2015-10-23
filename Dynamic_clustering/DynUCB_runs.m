function [Arms_last,Rewards,success_rate,Clusters_last] = DynUCB_runs(nb_runs,nb_arms,K,url_contexts,user_url_truncated_newdataset,alpha,T,unique_urls,bool_random_gaussian)
% Run several times the DynUCB algorithm and average the results

success_rate = 0;
Rewards=zeros(1,T);
for i=1:nb_runs
    fprintf('\n');
    fprintf(['Run ' num2str(i) ' '])
    [Arms_runs,Rewards_runs,Clusters_last] = DynUCB(nb_arms,K,url_contexts,user_url_truncated_newdataset, alpha, T,unique_urls,bool_random_gaussian);
    Rewards = Rewards + Rewards_runs;
    success_rate = success_rate + sum(Arms_runs==1);
end
Arms_last=Arms_runs;
Rewards = Rewards / nb_runs;
success_rate = success_rate / (T*nb_runs);

end

