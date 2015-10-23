classdef armGaussian<handle
    % Arm with Gaussian distribution
    
    properties
        mu % first parameter
        sigma2 % second parameter
        mean % expectation of the arm
        var % variance of the arm 
    end
    
    methods
        function self = armGaussian(mu,sigma2)
            self.mu=mu; 
            self.sigma2 = sigma2;
            self.mean = mu;
            self.var = sigma2;
        end
        
        function [loss] = play(self)
            loss = self.mu+sqrt(self.sigma2)*randn;
        end
                
    end    
end