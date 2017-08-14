function [sub] = mtl_driver(extract_mode)
%extract_driver triggers the extraction routine 
% in two modes: the cluster mode or the stand-alone mode.
%   Input: extract_mode
%           1: stand-alone mode when the script is meant to 
%              run on a signle computer. The extraction of each
%              subject takes around 3 hours and expect this to
%              take a long time.
%           2. cluster-mode when script is running on MPI's cluster
%              the each subject's extraction will be submitted as a job
%              and all the jobs can be run in paralle but requires one to
%              be familiar with the cluster operations. 

n_subject = 26;

if extract_mode == 1
    
    for i=1:n_subject
        comnorm_predict(1, i);
    end
    
elseif extract_mode == 2
    addpath('/usr/local/share/htcondor_matlab/');
    htjob = htcondorjob('comnorm_predict');
    htjob.mem = 4000;
    % memroy 4GB
    htjob.bid = 5;

    for i=1:n_subject
        htjob.addJob(2, i);
    end

    htjob.run;
else  
    warning('mtl_mode not recognized. Use 1 to run on local machine and 2 to run on cluster');
end

% don't know why need to return something to work on cluster
sub = 1;

end

