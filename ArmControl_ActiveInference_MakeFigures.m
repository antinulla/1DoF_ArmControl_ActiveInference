%% Loading simulations results
clear
close all

load('simulationsResults.mat')
% results(1) <-> simMode = 1 --> Standard Reaching (Sim 1)
% results(2) <-> simMode = 2 --> Rubber/Virtual Hand Illusion (Sim 2)
% results(3) <-> simMode = 3 --> Reaching Under Multisensory Conflict (Sim 3)

onsetTime = 3;  % onset of target or illusion
t = pi/3.; % target configuration / rubber hand position
time = sim.time
results = sim.results;
sim_time = max(sim.time);
xmin = 0;

for simMode = 1:3
    
    a = results(simMode).a ;
    mu = results(simMode).mu ;
    x = results(simMode).x ;
    mErrors = results(simMode).mErrors ;
    sErrors = results(simMode).sErrors;
    daErrorP = results(simMode).daErrorP;
    daErrorV = results(simMode).daErrorV;
    
    if simMode == 3
        x_S1 = results(1).x;
        mu_S1 = results(1).mu;
        a_S1 = results(1).a;
        
        theta_RH = results(3).theta_VH;
    end
    
    
    figure    
    % Plotting joint angle (real + inferred)
    subplot(5,1,1)
    plot([time(1) time(end)], [t t],'color',[0, 109/255,2/255] ,'linewidth', 2); hold on
    plot(time(:), x(:,1),'k','linewidth', 2)
    if(simMode == 3)
        plot(time(:), theta_RH(:),'color',[64/255, 103/255,174/255] ,'linewidth', 2)
        plot(time(:), x_S1(:,1),'k--','linewidth', 2)
        plot(time(:),mu_S1(:,1),'r--','linewidth', 2)
    end
    plot(time(:), mu(:,1),'r','linewidth', 2)
    xlim([xmin, sim_time])
    yrange = [-0.2, 1.8];
    ylim(yrange);
    plot([onsetTime onsetTime],  yrange,'k')
    ylabel('\theta, \mu [rad/s]')
    
    % Plotting joint angle velocity (real + inferred)
    subplot(5,1,2)   
    plot(time(:), x(:,2),'k','linewidth', 2); hold on;
    plot(time(:), mu(:,2),'r','linewidth', 2)
    if(simMode == 3)
        plot(time(:), x_S1(:,2),'k--','linewidth', 2)
        plot(time(:),mu_S1(:,2),'r--','linewidth', 2)
    end
    xlim([xmin, sim_time])
    ymax = max([x(:,2); mu(:,2)]);
    ymin = min([x(:,2); mu(:,2)]);
    yrange = [-0.1, 0.8]
    ylim(yrange);
    plot([onsetTime onsetTime],  yrange,'k')
    plot([xmin sim_time], [0 0],'k:')
    ylabel('\theta\prime, \mu\prime [rad/s]')
    
    % Plotting Action
    subplot(5,1,3)
    plot(time(:), a(:),'r','linewidth', 2); hold on
    if(simMode == 3)
        plot(time(:),a_S1(:),'r--','linewidth', 2)
    end
    xlim([xmin, sim_time]);
    yrange = [-0.5, 1.3*max(a)];
    ylim( yrange)
    plot([onsetTime onsetTime],  yrange,'k')
    plot([xmin sim_time], [0 0],'k:')
    ylabel('Action')
    
    % Plotting Model and Sensory Prediction Errors
    subplot(5,1,4)
    plot(time(:), mErrors(:,2),'color',[1, 125/255, 0],'linewidth', 2); hold on
    plot(time(:),sErrors(:,1),'m','linewidth', 1) % proprioceptive sensory error
    plot(time(:),sErrors(:,2),'b','linewidth', 1) % visual sensory error
    plot(time(:), mErrors(:,2),'color','g','linewidth', 2) % model error
    xlim([xmin, sim_time])
    yrange = [-1.3, 1.3]
    ylim( yrange)
    plot([onsetTime onsetTime],  yrange,'k')
    plot([xmin sim_time], [0 0],'k:')
    ylabel('Predic. Err.s')
    
    %  Plotting contributions to dF/da from visual and proprioceptive
    %  prediction errors
    subplot(5,1,5)
    plot(time(:),daErrorP(:),'m','linewidth', 1); hold on
    plot(time(:),daErrorV(:),'b','linewidth', 1)
    xlim([xmin, sim_time])
    yrange = [-3, 6]
    yrange = [-6, 6]
    if(simMode == 3 || simMode == 1)
        yrange = [-10, 10]
    end
    ylim( yrange)
    plot([onsetTime onsetTime],  yrange,'k')
    plot([xmin sim_time], [0 0],':k')
    ylabel('dF/dA Cotr.')
    xlabel('time [s]')
    
end
