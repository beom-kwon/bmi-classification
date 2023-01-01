close all;
clear;
clc;

input_path  = strcat(pwd,'\DB\cross validation\');
model_path  = strcat(pwd,'\DB\trained ensemble model\');
output_path = strcat(pwd,'\DB\estimated labels\');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

k = 5; % k-fold cross validation

for fold = 1:1:k
    for N = 1:1:6
        for n = 1:1:N
            fprintf('fold: %d, N: %d, n: %d\n',fold,N,n);
            GT = [];
            Pred = [];
            testing_file = strcat(input_path,'cv',num2str(fold),'_testing_',num2str(N),'_',num2str(n),'.mat');
            model_file   = strcat(model_path,'cv',num2str(fold),'_knn_model_',num2str(N),'_',num2str(n),'.mat');
            output_file = strcat(output_path,'cv',num2str(fold),'_estimated_label_',num2str(N),'_',num2str(n),'.mat');
            
            % Data loading
            load(testing_file);
            Y = feature_vector_testing(:,21);   % label
            X = feature_vector_testing(:,1:20); % features

            % model loading
            load(model_file);
            [label, score, cost] = predict(knn_model, X);

            GT = [GT; Y];
            Pred = [Pred; label];
            clear knn_model;
            clear Y;
            clear X;
            save(output_file,'Pred','GT');
        end        
    end
end