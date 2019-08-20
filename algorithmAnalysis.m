%% data analysis
load 5iter100loopLogo.mat
%load timeVectorAllIters.mat

%average RMSE of the final product of the algorithm
finalIteration5logo = Performance(end, :);
meanFinalIter5logo = mean(finalIteration5logo);
SEMfinalIter5logo = std(finalIteration5logo)/sqrt(length(finalIteration5logo));

% average time it takes per algorithm iteration
averageTimePerLoop5logo = mean(ElapsedTimeVector);
SEMtimePerLoop5logo = std(ElapsedTimeVector)/sqrt(length(ElapsedTimeVector));
ElapsedTimeVector5logo = ElapsedTimeVector;

save('analysis5iter100loopLogo.mat','finalIteration5logo', 'meanFinalIter5logo', 'SEMfinalIter5logo',...
    'averageTimePerLoop5logo', 'SEMtimePerLoop5logo', 'ElapsedTimeVector5logo')

%% combine files

filenames = {'analysis5iter100loopLogo.mat', 'analysis10iter100loopLogo.mat', 'analysis50iter100loopLogo.mat', 'analysis100iter100loopLogo.mat',};
for kk = 1:numel(filenames)
    load(filenames{kk})
end

%% Plotting

% xNames = {'5 iterations', '10 iterations', '50 iterations', '100 iterations'};
% xpoints = (meanFinalIter5, meanFinalIter10, meanFinalIter50, meanFinalIter100);
% ypoints = range(0.3:0.4)
% scatter(xpoints)

RMSEfinalIteration = boxplot([finalIteration5logo(:), finalIteration10logo(:), finalIteration50logo(:), finalIteration10logo(:)],'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
xlabel('Number of Iterations')
ylabel('RMSE')
title('RMSE of final Iteration')
% 
% AverageTimePerLoop = boxplot([ElapsedTime5iter(:), ElapsedTime10iter(:), ElapsedTime50iter(:), ElapsedTime100iter(:)], 'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
% xlabel('Number of Iterations')
% ylabel('Time (s)')
% title('Average Time per Loop')