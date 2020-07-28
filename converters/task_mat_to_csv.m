% CSN Convert Completed Participants' MAT to CSV

% Set up datapath
datapath = '/Users/metis/Projects/shlab/mounts/csn/data';

% List data directory contents and extract files starting with
% 'csntask_subjCSN', which signify behavioral task responses
dir_list = dir(datapath);
dir_contents = {dir_list.name};
filenames = dir_contents(startsWith(dir_contents, 'csntask_subjCSN'));

% Note incompletes (and non-participant)
incompletes = {'CSN003'
               'CSN013'
               'CSN014'
               'CSN024'
               'CSN028'
               'CSN031'
               'CSN046'
               'CSN999'};

% Navigate into data directory
cd(datapath)

% Convert each complete participant behavioral task response
% from .mat to .csv
for i = 1:length(filenames)

    fn = filenames{i};
    participant_id = string(regexp(fn, 'CSN\d{3}', 'match'));
    
    % Skip to next participant if current is incomplete
    if ismember(participant_id, incompletes)
        continue
    end
    
    load(fn);
    
    N_TRIALS = subjdata.nTrials;
    BASE_BOOL = true(N_TRIALS, 1);
    BASE_ONES = ones(N_TRIALS, 1);
    
    trial = transpose(1:N_TRIALS);
    clock_side = BASE_BOOL * subjdata.lr;
    p_signal = BASE_ONES * subjdata.pSignal;
    resp = subjdata.resps;
    step = subjdata.steps;
    img_index = subjdata.img_ind;

    participant_table = table(trial, clock_side, p_signal, resp, ...
                        step, img_index);
    
    participant_fn = participant_id + '.csv';
    
    writetable(participant_table, 'csv/' + participant_fn, ...
               'Delimiter', ',', 'QuoteStrings', true);
    
end

