# Dynamic clustering of contextual multi-armed bandits

**The README.pdf file explains in details the implemented algorithms. What follows is a non-exhaustive description of the approach**

The reinforcement learning algorithms implemented here on **MATLAB** have been described in the article of Nguyen and Lauw, *Dynamic Clustering of Contextual Multi-Armed Bandits*, and propose a new framework for recommender systems and Multi-Armed Bandits.

The following multi-armed bandits algorithms are implemented here :

- LinUCB_IND algorithm
- LinUCB_SIN algorithm
- DynUCB algorithm

The Delicious dataset is used ; it can be found on the [Delicious website](http://grouplens.org/datasets/hetrec-2011/). It contains social networking, bookmarking, and tagging information from a set of 1867 users from the Delicious social bookmarking system, for 69226 URLs and 53388 tags.

The data has been preprocessed and two datasets are used : a *context matrix* (each URL is associated with context features) as well as a *users* x *urls* matrix (users have assigned tags to specific URLs that they have bookmarked).

One can easily change the datasets and adapt the code so as to run the algorithms on its own datasets.
