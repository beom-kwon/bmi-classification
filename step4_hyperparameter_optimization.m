close all;
clear variables;
clc;

input_path = strcat(pwd,'\DB\cross validation\');
output_path = strcat(pwd,'\DB\trained ensemble model\');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

k = 5; % k-fold cross validation

for fold = 1:1:k
    for N = 1:1:6
        for n = 1:1:N
            fprintf('fold: %d, N: %d, n: %d\n',fold,N,n);
        
            training_file = strcat(input_path,'cv',num2str(fold),'_training_',num2str(N),'_',num2str(n),'.mat');
            output_file   = strcat(output_path,'cv',num2str(fold),'_knn_model_',num2str(N),'_',num2str(n),'.mat');

            % Load training dataset
            load(training_file);
            Y = feature_vector_training(:,21);   % label
            X = feature_vector_training(:,1:20); % anthropometric features

            % Hyperparameter Optimization
            knn_model = fitcknn(X,Y,'OptimizeHyperparameters','all',...
                'HyperparameterOptimizationOptions',...
                struct('AcquisitionFunctionName','expected-improvement-plus',...
                'Verbose',0,'ShowPlots',0));

            save(output_file,'knn_model');
        end
    end
end