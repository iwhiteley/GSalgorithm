%%% data analysis
load 100iter100loopSpotPhase.mat
%load timeVectorAllIters.mat

%average RMSE of the final product of the algorithm
finalIteration100SpotPhase = Performance(end, :);
meanFinalIter100SpotPhase = mean(finalIteration100SpotPhase);
SEMfinalIter100SpotPhase = std(finalIteration100SpotPhase)/sqrt(length(finalIteration100SpotPhase));

% average time it takes per algorithm iteration
% averageTimePerLoop100spot = mean(ElapsedTimeVector);
% SEMtimePerLoop100spot = std(ElapsedTimeVector)/sqrt(length(ElapsedTimeVector));
% ElapsedTimeVector100spot = ElapsedTimeVector;

save('analysis100iter100loopSpotPhase.mat','finalIteration100SpotPhase', 'meanFinalIter100SpotPhase', 'SEMfinalIter100SpotPhase');
%     'averageTimePerLoop100spot', 'SEMtimePerLoop100spot', 'ElapsedTimeVector100spot')

%% combine files

% filenames = {'analysis5iter100loopSpot.mat', 'analysis10iter100loopSpot.mat', 'analysis50iter100loopSpot.mat', 'analysis100iter100loopSpot.mat',};
% for kk = 1:numel(filenames)
%     load(filenames{kk})
% end

%% Plotting

% RMSEfinalIteration = boxplot([finalIteration100LogoPhase(:), finalIteration100mileyPhase(:), finalIteration100SpotPhase(:)]);%, finalIteration100logo(:)],'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
% xlabel('Number of Iterations')
% ylabel('RMSE')
% title('RMSE of final Spot iteration ')
% 
% figure(2)
% AverageTimePerLoop = boxplot([ElapsedTimeVector5logo(:), ElapsedTimeVector10logo(:), ElapsedTimeVector50logo(:), ElapsedTimeVector100logo(:)], 'Labels', {'5 Iterations','10 Iterations','50 Iterations','100 Iterations'});
% xlabel('Number of Iterations')
% ylabel('Time (s)')
% title('Average Time per Loop')