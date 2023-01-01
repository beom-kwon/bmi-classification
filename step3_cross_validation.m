close all; 
clear variables; 
clc;

input_file = strcat(pwd,'\DB\feature vector\');
output_path = strcat(pwd,'\DB\cross validation\');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

k = 5; % k-fold cross validation

for fold = 1:1:k
    for N = 1:1:6
        for n = 1:1:N
            fprintf('fold: %d, N: %d, n: %d\n',fold,N,n);
            load(strcat(input_file,'feature_vector',num2str(N),'_',num2str(n),'.mat'));
            training_data_name = strcat(output_path,'cv',num2str(fold),'_training_',num2str(N),'_',num2str(n),'.mat');
            testing_data_name  = strcat(output_path,'cv',num2str(fold),'_testing_',num2str(N),'_',num2str(n),'.mat');

            range_testing = fold:k:size(feature_vector,1);
            range_training = 1:1:size(feature_vector,1);
            range_training(range_testing) = [];
    
            feature_vector_training = feature_vector(range_training,:);
            % If you want to apply SMOTE to training dataset
%             feature_vector_training = SMOTE(feature_vector(range_training,:), 5);
            
            save(training_data_name, 'feature_vector_training');
            
            feature_vector_testing = feature_vector(range_testing,:);
            save(testing_data_name, 'feature_vector_testing');
        end
    end
end