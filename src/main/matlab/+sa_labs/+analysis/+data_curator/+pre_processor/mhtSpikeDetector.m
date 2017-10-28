function mhtSpikeDetector(epochs, parameter)

% description : Spike detection from max turner package rieke lab. Below are the list of parameter and its default value
% refractoryPeriod:
%   default : 1.5E-3
%   description: refactory period in seconds
% searchWindow:
%   default: 1E-3
%   description: search window for spikes
% devices:
%   default: "@(epoch, devices) sa_labs.analysis.common.getdeviceForEpoch(epoch, devices)"
%   description: List of amplifier channels for the given epoch
% ---

for epochData = epochs
    for i = 1 : numel(parameter.devices)
        device = parameter.devices{i};
        response = epochData.getResponse(device);
        
        [spikeTimes, spikeAmplitudes, statistics] = mht.spike_util.detectSpikes(response.quantity,...
            'sampleRate', epochData.get('sampleRate'),...
            'refractoryPeriod', parameter.refractoryPeriod,...
            'searchWindow', parameter.searchWindow);
        
        epochData.addDerivedResponse('spikeTimes', spikeTimes, device);
        epochData.addDerivedResponse('spikeAmplitudes', spikeAmplitudes, device);
        epochData.addDerivedResponse('spikeStatistics', statistics, device);
    end
end
end
