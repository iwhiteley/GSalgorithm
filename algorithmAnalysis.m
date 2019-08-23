%% data analysis
load 100iter100loopLogo.mat
%load timeVectorAllIters.mat

%average RMSE of the final product of the algorithm
finalIteration100logo = Performance(end, :);
meanFinalIter100logo = mean(finalIteration100logo);
SEMfinalIter100logo = std(finalIteration100logo)/sqrt(length(finalIteration100logo));

% average time it takes per algorithm iteration
averageTimePerLoop100logo = mean(ElapsedTimeVector);
SEMtimePerLoop100logo = std(ElapsedTimeVector)/sqrt(length(ElapsedTimeVector));
ElapsedTimeVector100logo = ElapsedTimeVector;

save('analysis100iter100loopLogo.mat','finalIteration100logo', 'meanFinalIter100logo', 'SEMfinalIter100logo',...
    'averageTimePerLoop100logo', 'SEMtimePerLoop100logo', 'ElapsedTimeVector100logo')

%% combine files

% filenames = {'analysis5iter100loopLogo.mat', 'analysis10iter100loopLogo.mat', 'analysis50iter100loopLogo.mat', 'analysis100iter100loopLogo.mat',};
% for kk = 1:numel(filenames)
%     load(filenames{kk})
% end

%% Plotting

RMSEfinalIteration = boxplot([finalIteration5logo(:), finalIteration10logo(:), finalIteration50logo(:), finalIteration100logo(:)],'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
xlabel('Number of Iterations')
ylabel('RMSE')
title('RMSE of final Iteration')

AverageTimePerLoop = boxplot([ElapsedTimeVector5logo(:), ElapsedTimeVector10logo(:), ElapsedTimeVector50logo(:), ElapsedTimeVector100logo(:)], 'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
xlabel('Number of Iterations')
ylabel('Time (s)')
title('Average Time per Loop')