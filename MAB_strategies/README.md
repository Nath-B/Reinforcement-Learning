# Multi-armed bandit strategies

**The README.pdf file explains in details the implemented algorithms. What follows is a non-exhaustive description of the approach.**

The reinforcement learning algorithms implemented here on **MATLAB** compare the UCB algorithm with other strategies, for different Arms probabilitiy distributions : 

- Bernouilli distribution
- Exponential distribution
- Gaussian distribution
- Beta distribution

The strategies are the following ones :

- The first strategy (naive strategy), consists in choosing at each iteration the arm with the highest empirical reward
- For a chosen horizon, the second strategy (mid-strategy) consists in chosing arms one at a time during the first half, and picking the one with the lowest regret during the second half
- The third strategy is the classical UCB algorithm


The main.m file defines different arms functions, and then plots regrets after calling the different reinforcement learning strategies (naive, mid-strategy, UCB), along with UCB regret bounds.