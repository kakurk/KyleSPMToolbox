function [Contrasts] = BuildContrastVectors(Contrasts,pathtoSPM)
    % Function designed to a.) create contrast vectors and b.) run contrasts in
    % SPM 8. Written by Kyle Kurkela, kyleakurkela@gmail.com. 3/2/2016.

    % Step 1: load the labels of each column of the design matrix
    SPM = [];
    load(pathtoSPM)
    Regressors.Names = SPM.xX.name;
    pos_neg = {'positive' 'negative'};    
    Regressors.Estimability = spm_SpUtil('isCon',SPM.xX.X);

    % Step 2: Build an array that tells you how many times each TT involved in
    % the specified contrasts occurs in our design matrix. Because our TT are
    % subject behavior defined, they may not occur in each run.

    for indexC = 1 : length(Contrasts)
        for indexPN = 1:2
            for indexQ = 1 : length(Contrasts(indexC).(pos_neg{indexPN}))
                TT_occurance{indexC}.(pos_neg{indexPN})(indexQ) = 0; %#ok<*AGROW>
                for indexV = 1 : length(Regressors.Names)
                    if ~isempty(strfind(Regressors.Names{indexV},Contrasts(indexC).(pos_neg{indexPN}){indexQ})) && ...
                            Regressors.Estimability(indexV)
                       TT_occurance{indexC}.(pos_neg{indexPN})(indexQ) = TT_occurance{indexC}.(pos_neg{indexPN})(indexQ) + 1;
                    end
                end
            end
        end
    end

    % Step 3: Build contrast vectors and apply appropriate weights. The
    % contrast vectors needed to be weighted by the number of runs that they
    % occur in and by the number of included trial types in a given
    % contrast

    for indexC = 1 : length(Contrasts)
        Contrasts(indexC).vector = zeros(1,length(Regressors.Names));
        for indexPN = 1:2
            for indexQ = 1 : length(Contrasts(indexC).(pos_neg{indexPN}))
                for indexV = 1 : length(Regressors.Names)
                    if ~isempty(strfind(Regressors.Names{indexV},Contrasts(indexC).(pos_neg{indexPN}){indexQ})) && ...
                            Regressors.Estimability(indexV)
                        if indexPN == 1
                            Contrasts(indexC).vector(indexV) = roundsd(contrast_weight(TT_occurance{indexC}.(pos_neg{indexPN}),Contrasts(indexC).(pos_neg{indexPN}){indexQ},Regressors.Names,Regressors.Estimability),5);
                        elseif indexPN == 2
                            Contrasts(indexC).vector(indexV) = roundsd(-contrast_weight(TT_occurance{indexC}.(pos_neg{indexPN}),Contrasts(indexC).(pos_neg{indexPN}){indexQ},Regressors.Names,Regressors.Estimability),5);
                        end
                    end
                end
            end
        end
    end

    %% Sub Functions
    
    function weight = contrast_weight(TT_occurance,TrialType,TT_name_vector,param_est)
        % Function designed to calculate the contrast weight for a given TT
        % occurance. Function takes in arguments of:

        % Step 1: Calculate the 'divsor'. The divsor is the number of trial
        % types included in the current contrast. For example, given the design
        % matrix:
        % Run1_Hit  Run1_Miss  Run1_CR  Run1_FA  Run2_Hit  Run2_CR  Run2_FA
        % and the contrast HitFA_vs_MissCR, we would want to spread the
        % contrast weights across trial types included. Example vector would be
        % [.25 -.5 -.25 .25 -.25 -.5 .25].
        divsor=0;
        for i = 1:length(TT_occurance)
            if TT_occurance(i) ~= 0
                divsor = divsor+1;
            end
        end

        % Step 2: Calculate the 'number'. The number is the total number of
        % runs that this trial type occurs in. For example, in the design
        % matrix:
        % Run1_Hit  Run1_Miss  Run1_CR  Run1_FA  Run2_Hit  Run2_CR  Run2_FA
        % This subjects does not make 'Miss' a target in Run 2. Thus, we do not
        % want to weight the contrast across runs. Example contrast Hit_vs_Miss
        % vector = [.5 -1 0 0 .5 0 0].

        number=0;
        for k = 1:length(TT_name_vector)
            if ~isempty(strfind(TT_name_vector{k},TrialType)) && ...
                            param_est(k)
                number = number+1;
            end
        end

        % Step 3: Acutally Calculate the Weight
        weight = 1/divsor/number;

    end
    
    function y = roundsd(x,n,method)
        %ROUNDSD Round with fixed significant digits
        %	ROUNDSD(X,N) rounds the elements of X towards the nearest number with
        %	N significant digits.
        %
        %	ROUNDSD(X,N,METHOD) uses following methods for rounding:
        %		'round' - nearest (default)
        %		'floor' - towards minus infinity
        %		'ceil'  - towards infinity
        %		'fix'   - towards zero
        %
        %	Examples:
        %		roundsd(0.012345,3) returns 0.0123
        %		roundsd(12345,2) returns 12000
        %		roundsd(12.345,4,'ceil') returns 12.35
        %
        %	See also Matlab's functions ROUND, ROUND10, FLOOR, CEIL, FIX, and 
        %	ROUNDN (Mapping Toolbox).
        %
        %	Author: François Beauducel <beauducel@ipgp.fr>
        %	  Institut de Physique du Globe de Paris
        %
        %	Acknowledgments: Edward Zechmann, Daniel Armyr, Yuri Kotliarov
        %
        %	Created: 2009-01-16
        %	Updated: 2015-04-03

        %	Copyright (c) 2015, François Beauducel, covered by BSD License.
        %	All rights reserved.
        %
        %	Redistribution and use in source and binary forms, with or without 
        %	modification, are permitted provided that the following conditions are 
        %	met:
        %
        %	   * Redistributions of source code must retain the above copyright 
        %	     notice, this list of conditions and the following disclaimer.
        %	   * Redistributions in binary form must reproduce the above copyright 
        %	     notice, this list of conditions and the following disclaimer in 
        %	     the documentation and/or other materials provided with the distribution
        %	                           
        %	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
        %	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
        %	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
        %	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
        %	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
        %	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
        %	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
        %	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
        %	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
        %	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
        %	POSSIBILITY OF SUCH DAMAGE.

        if nargin < 2
            error('Not enough input arguments.')
        end

        if nargin > 3
            error('Too many input arguments.')
        end

        if ~isnumeric(x)
                error('X argument must be numeric.')
        end

        if ~isnumeric(n) || ~isscalar(n) || n < 0 || mod(n,1) ~= 0
            error('N argument must be a scalar positive integer.')
        end

        opt = {'round','floor','ceil','fix'};

        if nargin < 3
            method = opt{1};
        else
            if ~ischar(method) || ~ismember(opt,method)
                error('METHOD argument is invalid.')
            end
        end

        % --- the generic formula was:
        %og = 10.^(floor(log10(abs(x)) - n + 1));
        %y = feval(method,x./og).*og;

        % --- but to avoid numerical noise, we must treat separately positive and 
        % negative exponents, because:
        % 3.55/0.1 - 35.5 is -7.105427357601e-15
        % 	3.55*10 - 35.5 is 0

        e = floor(log10(abs(x)) - n + 1);
        og = 10.^abs(e);
        y = feval(method,x./og).*og;
        k = find(e<0);
        if ~isempty(k)
            y(k) = feval(method,x(k).*og(k))./og(k);
        end	
        y(x==0) = 0;

    end
    
end