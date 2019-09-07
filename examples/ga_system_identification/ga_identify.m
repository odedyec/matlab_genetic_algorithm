%% GA param
param.Population = 1000;
param.Generations = 5;
param.Selection = 0.005;
param.mutate_probability = 0.3;
%% System params
param.dt = 0.005;
param.T = 2;
param.show = 1;
param.x0 = [0;0];
param.ref_signal = [10;0];
param.u_max = 10;
param.A = [ 0         1;  -44.0966   -1.3972];
param.B = [83.4659; 80.3162];

%% GA generate controllers
% Gen fast controller
param.Q = diag([10, 1]);
param.R = 1;


%% Create dataset
param.K = lqr(param.A, param.B, param.Q, param.R);
[X, u, ref] = control_response(get_sys(param), param.K);
param.X = X;
param.u = u;
param.ref = ref;

%% create set of agents
agents = {param.Population, 1};
for i=1:param.Population
    agents{i}=IdentificationAgent(size(param.B, 2), size(param.B, 1));
end

%% Identify using GA
param.Q = diag([1, 1]);
param.R = 1;
agents = ga_optimize(agents, param);
best_agent_param = param;
best_agent_param.A = agents{1}.A;
best_agent_param.B = agents{1}.B;
[X_est, u_est, ref] = control_response(get_sys(best_agent_param), param.K);
t = param.dt:param.dt:param.T;
subplot(2, 1, 1)
for j = 1:2
    subplot(2, 1, j)
    plot(t, X(j, :), t, X_est(j, :))
end