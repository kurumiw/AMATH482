function [xtrain, train_label, test, test_label] = construct_train(samplenum, v, features)

    % Random permutation from 1 to samplenum
    r1 = randperm(samplenum); %e.g. 100: vector of length 100 with 1 thru 100 permutated 
    r2 = randperm(samplenum);
    r3 = randperm(samplenum);

    % Index of the training set
    ind1 = r1( 1:samplenum*0.8 ); % e.g. r1(1:80)
    ind2 = r2( 1:samplenum*0.8 ) + samplenum; % e.g. r2(1:80) + 100 = r2(101:180)
    ind3 = r3( 1:samplenum*0.8 ) + 2*samplenum; % e.g. r3(1:80) + 200 = r3(201:280)

    % Index for test set
    ind1t = r1( 1+samplenum*0.8:samplenum ); % e.g. r1(81:100)
    ind2t = r2( 1+samplenum*0.8:samplenum ) + samplenum; % r2(81:100) + 100 = r2(181:200)
    ind3t = r3( 1+samplenum*0.8:samplenum ) + 2*samplenum; % r3(81:100) + 200 = r3(281:300)
    
    % xtrain set
    xtrain = [v(ind1, features); 
              v(ind2, features);
              v(ind3, features)];

    train_label = [ones(length(ind1), 1);
                 2*ones(length(ind1), 1);
                 3*ones(length(ind1), 1)];
    
    % test set
    test = [v(ind1t, features);
            v(ind2t, features);
            v(ind3t, features)];

    test_label = [ones(length(ind1t), 1);
                2*ones(length(ind1t), 1);
                3*ones(length(ind1t), 1)];
            
end
