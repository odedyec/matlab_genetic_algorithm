classdef OptimalControlAgent
    %AGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fitness
        K
        low
        high
        T
        inp_size
        out_size
    end
    
    methods
        function agent = OptimalControlAgent(inp_size, out_size, T)
            %AGENT Construct an instance of this class
            %   Detailed explanation goes here
            agent.low = -3;
            agent.high = 30;
            agent.out_size = out_size;
            agent.inp_size = inp_size;
            agent.K = randn(agent.inp_size, agent.out_size) * agent.high;
            agent.fitness = inf;
            agent.T = T;
        end
        
        function agent = set_fitness(agent, val)
            agent.fitness = val;
        end
        
        function outputArg = is_bigger(agent,other)
            outputArg = (agent.fitness > other.fitness);
        end
        
        function agent = set_K(agent, K)
            agent.K = K;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%   MUTATE FUNCTIONS     %%%%%%%%%%%%%%%%%%%%%%%%%
        function agent = mutate(agent, param)
            mutate_probability = param.mutate_probability;
            if rand > 1 - mutate_probability
                mutation_change = 0.2; % Up to 20% change
                mutation = mutation_change * rand(size(agent.K)) + (1-mutation_change);  % Uniform random between [0.5, 2]
                agent.K = agent.K .* mutation;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%   CROSSOVER FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%
        function new_agent = crossover(agent, other)
            new_agent = OptimalControlAgent(agent.inp_size, agent.out_size, agent.T);
            crossover_amount = rand;
            new_agent.K = agent.K * crossover_amount + other.K * (1-crossover_amount);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%   FITNESS FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%
        function agent = calc_fitness(agent, param)
            [X, u, r] = control_response(get_sys(param), agent.K);
            J = 0;
            n = size(X, 2);

            for i=1:n
                e = r(:, i) - X(:, i);
                J = e' * param.Q * e + u(:, i)' * param.R * u(:, i) + J;
            end 
            agent.fitness = J;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

