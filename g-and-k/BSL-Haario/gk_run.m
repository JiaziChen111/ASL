
rng(1234)  % was rng(1234)

% ground-truth parameters
A = 3.0;
B = 1.0;
g = 2.0;
k = 0.5;

logA = log(A);
logB = log(B);
logg = log(g);
logk = log(k);


nobs = 1000;  % data sample size
theta_true = [logA, logB, logg, logk];  % ground-truth parameters


numsim= 1000;  % % model simulations per iteration
numattempts = 1;
mcwm=1; % if 1 uses Markov-chain-within-Metropolis during burnin



y = gk_rnd(theta_true,nobs,1);

%thetastart = [logA, logB, logg, logk];
 thetastart = zeros(numattempts,4);
 thetastart(1,:) = [2, 2, 1, 0.2];
% thetastart(2,:) = [1.6, 1.6, 1, 0];
% thetastart(3,:) = [1.6, 0.5, 0.5, 0];


for attempt= 1:numattempts
    attempt
Haario_mcmciter = 5200; % total number of MCMC iterations
Haario_proposal = diag([0.025, 0.025, 0.025, 0.025].^2); % covariance matrix for random walk during burnin (on parameters log-scale)
Haario_length_CoVupdate = 50;  % frequency of covariance update for the Haario adaptive MCMC
Haario_burnin = 200; 
chains_withHaario = bslmcmc(thetastart(attempt,:),y,numsim,Haario_mcmciter,Haario_proposal,Haario_burnin,Haario_length_CoVupdate,mcwm);
MCMC = chains_withHaario;
filename = sprintf('chains_attempt%d',attempt);
save(filename,'MCMC','-ascii')
end

