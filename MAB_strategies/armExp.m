classdef armExp<handle
    % Arm with trucated exponential distribution
    
    properties
        lambda % parameter of the exponential distribution
        mean % expectation of the arm
        var % variance of the arm 
    end
    
    methods
        function self = armExp(lambda)
            self.lambda=lambda;
            self.mean = (1/lambda)*(1-exp(-lambda));
            self.var = 1;
        end
        
        function [loss] = play(self)
            loss = min(-1/self.lambda*log(rand),1);
        end
                
    end    
end