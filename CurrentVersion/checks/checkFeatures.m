function [] = checkFeatures()

global featureSelection;
global noOfPhasesInACycle;
global noOfLinks;
global generalizedObj;
global solverName;

for i = 1:numel(featureSelection)
    if featureSelection(i) ~= 0
        if featureSelection(i) ~= 1
            error('Invalid logical values selected in featureSelection');
        end
    end
end

if sum(featureSelection) <= 0
    error('Not enough features selected.');
end

if sum(featureSelection(10:17)) + sum(featureSelection(18:25)) == 0
       error('Objective function must be strictly increasing in queue length. Please select features that make this happen.');
end

for i = 3:9
    if generalizedObj == 0 && featureSelection(i) == 1 && noOfPhasesInACycle < i-1
        warning('Phase feature selected, but phase does not seem to exist. Ignoring phase %i feature.',i-1);
        featureSelection(i) = 0;
    end
end

for i = 11:17
    if generalizedObj == 0 && featureSelection(i) == 1 && noOfLinks < i-9
        warning('Queue feature selected, but queue does not seem to exist. Ignoring queue feature %i.', i-9);
        featureSelection(i) = 0;
    end
end

for i = 19:25
    if generalizedObj == 0 && featureSelection(i) == 1 && noOfLinks < i-17
        warning('Queue feature selected, but link does not seem to exist. Ignoring queue %i feature.', i-17);
        featureSelection(i) = 0;
    end
end

for i = 27:33
    if strcmp(solverName, 'tomlab')
        if generalizedObj == 0 && featureSelection(i) == 1 && noOfLinks < i-25
            warning('Queue feature selected, but queue does not seem to exist. Ignoring queue %i feature.', i-25);
            featureSelection(i) = 0;
        end
    elseif strcmp(solverName, 'cplex')
        if generalizedObj == 0 && featureSelection(i) == 1 && noOfPhasesInACycle < i-25
            warning('Phase feature selected, but phase does not seem to exist. Ignoring queue %i feature.', i-25);
            featureSelection(i) = 0;
        end
    else
        error('Solver name not recognized.');
    end
end

for i = 35:41
    if strcmp(solverName, 'tomlab')
        if generalizedObj == 0 && featureSelection(i) == 1 && noOfPhasesInACycle < i-33
            warning('Phase feature selected, but phase does not seem to exist. Ignoring phase %i feature.', i-33);
            featureSelection(i) = 0;
        end
    elseif strcmp(solverName, 'cplex')
        % do nothing.
    else
        error('Solver name not recognized.');
    end
end

% if featureSelection(12) == 1 && noOfPhasesInACycle < 2
%     warning('Phase 2 feature selected, but phase 2 does not seem to exist. Ignoring phase 2 feature.');
%     featureSelection(12) = 0;
% end
% 
% if featureSelection(13) == 1 && noOfPhasesInACycle < 3
%     warning('Phase 3 feature selected, but phase 3 does not seem to exist. Ignoring phase 3 feature.');
%     featureSelection(13) = 0;
% end
% 
% if featureSelection(14) == 1 && noOfPhasesInACycle < 4
%     warning('Phase 4 feature selected, but phase 4 does not seem to exist. Ignoring phase 4 feature.');
%     featureSelection(14) = 0;
% end
% 
% if featureSelection(15) == 1 && noOfPhasesInACycle < 5
%     warning('Phase 5 feature selected, but phase 5 does not seem to exist. Ignoring phase 5 feature.');
%     featureSelection(15) = 0;
% end
% 
% if featureSelection(16) == 1 && noOfPhasesInACycle < 6
%     warning('Phase 5 feature selected, but phase 6 does not seem to exist. Ignoring phase 6 feature.');
%     featureSelection(16) = 0;
% end
% 
% if featureSelection(17) == 1 && noOfPhasesInACycle < 7
%     warning('Phase 7 feature selected, but phase 7 does not seem to exist. Ignoring phase 7 feature.');
%     featureSelection(17) = 0;
% end
% 
% if featureSelection(18) == 1 && noOfPhasesInACycle < 8
%     warning('Phase 8 feature selected, but phase 8 does not seem to exist. Ignoring phase 8 feature.');
%     featureSelection(18) = 0;
% end



% if featureSelection(4) == 1 && noOfLinks < 2
%     warning('Queue 2 feature selected, but queue 2 does not seem to exist. Ignoring queue 2 feature.');
%     featureSelection(4) = 0;
% end
% 
% if featureSelection(5) == 1 && noOfLinks < 3
%     warning('Queue 3 feature selected, but queue 3 does not seem to exist. Ignoring queue 3 feature.');
%     featureSelection(5) = 0;
% end
% 
% if featureSelection(6) == 1 && noOfLinks < 4
%     warning('Queue 4 feature selected, but queue 4 does not seem to exist. Ignoring queue 4 feature.');
%     featureSelection(6) = 0;
% end
% 
% if featureSelection(7) == 1 && noOfLinks < 5
%     warning('Queue 5 feature selected, but queue 5 does not seem to exist. Ignoring queue 5 feature.');
%     featureSelection(7) = 0;
% end
% 
% if featureSelection(8) == 1 && noOfLinks < 6
%     warning('Queue 6 feature selected, but queue 6 does not seem to exist. Ignoring queue 6 feature.');
%     featureSelection(8) = 0;
% end
% 
% if featureSelection(9) == 1 && noOfLinks < 7
%     warning('Queue 7 feature selected, but queue 7 does not seem to exist. Ignoring queue 7 feature.');
%     featureSelection(9) = 0;
% end
% 
% if featureSelection(10) == 1 && noOfLinks < 8
%     warning('Queue 8 feature selected, but queue 8 does not seem to exist. Ignoring queue 8 feature.');
%     featureSelection(10) = 0;
% end

