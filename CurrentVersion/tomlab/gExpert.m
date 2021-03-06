function g = gExpert(x)

global expertWeights;
global noOfPhasesInACycle;
global ds;
global xExpertCombined;
persistent delta;
persistent t;
persistent l;
global featureSelection;
global maxPhases;
global maxLinks;

[noOfLinks, noOfPhasesInACycle, minPhaseLength, ...
maxPhaseLength, noOfCycles, simTime, arrivalRate,...
departureRate, lInitial, phaseSets, phaseSequence, zeroTimePhases] = unpackDataSet(ds);

m = noOfLinks;
n = noOfPhasesInACycle*noOfCycles;
nc = noOfPhasesInACycle;
cmax = noOfCycles;
weights = expertWeights;

% initialize size of g to all zeros
g = zeros(size(x));
g_cycleLength = zeros(size(x));
g_phaseVariance = zeros(size(x,1),nc);
g_queueLength = zeros(size(x),m);
g_queueLengthSquared = zeros(size(x),m);
g_delay = zeros(size(x),m);

% xIndexing
[l,t,delta] = xIndexing(m,n);    % Index l,t and delta within the vector x

% Cycle length
if featureSelection(1) == 1
    c = 1;
    cycleLength = zeros(1,cmax);
    for k = 1:n
        cycleLength(c) = cycleLength(c) + x(delta(k));
        if mod(k,nc) == 0
            c = c+1;
        end
    end
    c = 1;
    for k = 1:n
        g_cycleLength(delta(k)) = weights(1)*2*cycleLength(c);
        if mod(k,nc) == 0
            c = c+1;
        end
    end
end

% Phase lengths variances
for p = 1:nc
    temp = 0;
    for c2 = 1:cmax
        temp = temp + x(delta((nc*(c2-1))+p));
    end
    deltaBar(p) = temp*(1/cmax);
end
for p = 1:nc
    if featureSelection(1+p) == 1
        for k = 1:n
            if mod(k,nc) == p || (mod(k,nc) == 0 && p == nc)
                g_phaseVariance(delta(k),p) = weights(1+p)*2*(1-1/cmax)*(x(delta(k)) - (1/cmax)*(deltaBar(p)));
                for k2 = 1:n
                    if (mod(k2,nc) == p || (mod(k2,nc) == 0 && p == nc)) && k2 ~= k
                        g_phaseVariance(delta(k),p) = g_phaseVariance(delta(k),p) + weights(1+p)*2*(-1/cmax)*(x(delta(k2))-(1/cmax)*(deltaBar(p)));
                    end
                end
            end
        end
    end
end

% QueueLength
for i = 1:m
    if featureSelection(1+maxPhases+i) == 1
        for k = 1:n
            g_queueLength(l(i,k),i) = weights(1+nc+i)*1;
        end
    end
end

% QueueLength^2
for i = 1:m
    if featureSelection(1+maxPhases+maxLinks+i) == 1
        for k = 1:n
            g_queueLengthSquared(l(i,k),i) = weights(1+nc+m+i)*2*x(l(i,k));
        end
    end
end

% Delay
for i = 1:m
    if featureSelection(1+maxPhases+2*maxLinks+i) == 1
        for k = 1:n-1
            g_delay(l(i,k),i) = weights(1+nc+2*m+i)*(x(delta(k)) + x(delta(k+1)));
        end
        for k = n
            g_delay(l(i,k),i) = weights(1+nc+2*m+i)*x(delta(k));
        end
    end
end


for k = 2:n
    for i = 1:m
        if featureSelection(1+maxPhases+2*maxLinks+i) == 1
            g_delay(delta(k),i) = g_delay(delta(k),i) + weights(1+nc+2*m+i)*(x(l(i,k-1)) + x(l(i,k)));
        end
    end
end
for k = 1
    for i = 1:m
        if featureSelection(1+maxPhases+2*maxLinks+i) == 1
            g_delay(delta(k),i) = g_delay(delta(k),i) + weights(1+nc+2*m+i)*(lInitial(i) + x(l(i,k)));
        end
    end
end

g = g_cycleLength + sum(g_phaseVariance,2) + ...
    sum(g_queueLength,2) + sum(g_queueLengthSquared,2) + sum(g_delay,2);



