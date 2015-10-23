classdef armBernoulli<handle
    % % Bernoulli arm 
    
    properties
        p % parameter
        mean % expectation of the arm
        var % variance of the arm 
    end
    
    methods
        function self = armBernoulli(p)
            self.p=p; 
            self.mean = p;
            self.var = p*(1-p);
        end
        
        function [loss] = play(self)
            loss = rand(1)<self.p;
        end
                
    end    
end
