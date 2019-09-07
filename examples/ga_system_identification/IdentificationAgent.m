classdef IdentificationAgent
    %AGENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fitness
        A
        B
        low
        high
        T
        inp_size
        out_size
    end
    
    methods
        function agent = IdentificationAgent(inp_size, out_size)
            %AGENT Construct an instance of this class
            %   Detailed explanation goes here
            agent.low = -500;
            agent.high = 100;
            agent.out_size = out_size;
            agent.inp_size = inp_size;
            agent.A = randn(agent.out_size, agent.out_size) * agent.high;
            agent.B = randn(agent.out_size, agent.inp_size) * agent.high;
            agent.fitness = inf;
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
            idx = rand(size(agent.A)) > 1 - mutate_probability;
            new_A = randn(agent.out_size, agent.out_size) * agent.high;
            agent.A(idx) = new_A(idx);
            
            idx = rand(size(agent.B)) > 1 - mutate_probability;
            new_B = randn(agent.out_size, agent.out_size) * agent.high;
            agent.B(idx) = new_B(idx);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%   CROSSOVER FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%
        function new_agent = crossover(agent, other)
            new_agent = IdentificationAgent(agent.inp_size, agent.out_size);
            crossover_amount = rand;
            new_agent.A = agent.A * crossover_amount + other.A * (1-crossover_amount);
            new_agent.B = agent.B * crossover_amount + other.B * (1-crossover_amount);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%   FITNESS FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%
        function agent = calc_fitness(agent, param)
            agent_param = param;
            agent_param.A = agent.A;
            agent_param.B = agent.B;
            [X, u, r] = control_response(get_sys(agent_param), param.K);
            J = 0;
            n = size(X, 2);
            
            for i=1:n
                e = param.X(:, i) - X(:, i);
                u_e = param.u(:, i) - u(:, i);
                J = e' * param.Q * e + u_e' * param.R * u_e + J;
            end 
            agent.fitness = J;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

