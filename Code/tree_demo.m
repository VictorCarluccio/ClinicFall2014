clear;
close all;
tic

addpath(genpath('.'));

%% Load Data

load wineEW.mat
% [data,labels] = load_data(data_struct);

%% Implement Feast

% Feature Selecgtion Algorithm
struct.method = 'jmi';
% The number of most relivant features. 
struct.numFeats = 8;




%% Select Feature Selection Algorithms
% feature subset selection is only used on the training data. 
% feature selec with multiple datasets

data_struct.dataset = 'gaussian';
data_struct.classes = 2;
data_struct.samples = [100 100];
data_struct.MU = {[1,1] [-1 -1]};
data_struct.SIGMA = {eye(2), eye(2)};
data_struct.plot = true;
 

% spec for tree
% struct.classifier_type = 'tree';

% spec for naivebayes
struct.classifier_type = 'naivebayes';

% spec for kNN
% struct.classifier_type = 'knn';
% struct.NumNeighbors = 5;
% struct.Distance = 'euclidean';

%  stuct spec for the svm
% struct.classifier_type = 'svm';
% struct.kernel_function = 'rbf';
% struct.rbf_sigma = 1;
% struct.boxconstraint = 1;

% spec for svm (poly)
% struct.classifier_type = 'svm';
% struct.kernel_function = 'polyorder';
% struct.polyorder = 6;
% struct.boxconstraint = 1;

% spec for adaboost
% struct.classifier_type = 'adaboost'
% struct.NLearn = 
% struct.Learners =


%%
% creat anon & varriables
calc_error = @(x, y) sum(x~=y)/length(y);
k_folds = 5;


% perm the data and labels
RandomIDX = randperm(length(labels));
data = data(RandomIDX,:);
labels = labels(RandomIDX);

% % % % % creating a tree
% % % % tree = ClassificationTree.fit(data,labels);
% % % % % view(tree, 'mode', 'graph')
% % % % %predictions
% % % % pred = predict(tree, data);


%------------------------------------------------------------

% split data/labels into the k-folds
% for k ...
%             train a tree
%             test a tree
%             calc error

cv = cvpartition(length(labels),'k',k_folds);

err = zeros(k_folds, 1);

% parpool(4);

for k=1:k_folds %parfor for parrallel computing
    idx_train = cv.training(k);
    idx_test = cv.test(k);

    err(k) = classifier_eval(struct, data(idx_train,:), labels(idx_train), ...
       data(idx_test,:), labels(idx_test)); 
end
% delete(gcp)

cv_error = mean(err);
message=['The cv error is ', num2str(cv_error)];
disp(message)
runtime=toc;
save(['classification_',struct.classifier_type,'_cv',num2str(k_folds),'_',data_struct.dataset,'.mat'])



