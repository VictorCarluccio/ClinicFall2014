function err = classifier_eval(struct, data_train, labels_train,...
    data_test, labels_test)

%   
% See also
% CLASSIFICATIONTREE

features=feast(struct.method, struct.numFeats, data_train, labels_train);

data_train = data_train(:,features);
data_test = data_test(:,features);


calc_error = @(x,y) sum(x~=y)/length(y);

switch struct.classifier_type
    case 'tree'
        tree = ClassificationTree.fit(data_train,labels_train);
        pred = predict(tree,data_test);
        
    case 'naivebayes'
        nb = NaiveBayes.fit(data_train,labels_train);
        pred = predict(nb,data_test);
        
    case 'kNN' 
        nn = ClassificationKNN.fit(data_train,labels_train,'NumNeighbors',...
            struct.NumNeighbors,'Distance',struct.Distance);
        pred = predict(nn,data_test);
    case 'svm'
        switch struct.kernel_function
            case 'polynomial'
                svm = svmtrain(data_train, labels_train, 'kernel_function',...
                    struct.kernel_function, 'polyorder', struct.polyorder,...
                    'boxconstraint', struct.boxconstraint);
            case 'rbf'
                svm = svmtrain(data_train, labels_train, 'kernel_function',...
                    struct.kernel_function, 'rbf_sigma', struct.rbf_sigma,...
                    'boxconstraint', struct.boxconstraint);
    
            otherwise
                error('Unknown Kernel!')
        end
        pred = svmclassify(svm, data_test);
    case 'adaboost'
        if length(unique([labels_test;labels_train])) >= 3
            ens = fitensemble(data_train,labels_train,'AdaBoostM2', struct.NLearn, struct.Learners);
        else
            ens = fitensemble(data_train,labels_train,'AdaBoostM1', struct.NLearn, struct.Learners);
        end  
        pred = predict(ens, data_test);
        
        
    otherwise
         error('unknown classifier!');
end
         
       err = calc_error(pred,labels_test);
