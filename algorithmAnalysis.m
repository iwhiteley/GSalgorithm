%% data analysis
load 100iter100loop.mat
%load timeVectorAllIters.mat

%average RMSE of the final product of the algorithm
finalIteration100 = Performance(end, :);
meanFinalIter100 = mean(finalIteration100);
SEMfinalIter100 = std(finalIteration100)/sqrt(length(finalIteration100));

% average time it takes per algorithm iteration
averageTimePerLoop100 = mean(ElapsedTimeVector);
SEMtimePerLoop100 = std(ElapsedTimeVector)/sqrt(length(ElapsedTimeVector));
ElapsedTimeVector100 = ElapsedTimeVector;

save('analysis100iter100loop.mat','finalIteration100', 'meanFinalIter100', 'SEMfinalIter100', 'averageTimePerLoop100', 'SEMtimePerLoop100', 'ElapsedTimeVector100')

%% combine files

filenames = {'analysis5iter100loop.mat', 'analysis10iter100loop.mat', 'analysis50iter100loop.mat', 'analysis100iter100loop.mat',};
for kk = 1:numel(filenames)
    load(filenames{kk})
end

%% Plotting

% xNames = {'5 iterations', '10 iterations', '50 iterations', '100 iterations'};
% xpoints = (meanFinalIter5, meanFinalIter10, meanFinalIter50, meanFinalIter100);
% ypoints = range(0.3:0.4)
% scatter(xpoints)

RMSEfinalIteration = boxplot([finalIteration5(:), finalIteration10(:), finalIteration50(:), finalIteration100(:)],'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
xlabel('Number of Iterations')
ylabel('RMSE')
title('RMSE of final Iteration')

AverageTimePerLoop = boxplot([ElapsedTime5iter(:), ElapsedTime10iter(:), ElapsedTime50iter(:), ElapsedTime100iter(:)], 'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
xlabel('Number of Iterations')
ylabel('Time (s)')
title('Average Time per Loop')