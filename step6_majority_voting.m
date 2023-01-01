clear variables;
close all;
clc;

input_path = strcat(pwd,'\DB\estimated labels\');
output_path = strcat(pwd,'\DB\majority voting results\');
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

k = 5; % k-fold cross validation

N_range = 1:1:6;
Num_Classifier = sum(N_range);
result_set = zeros(111,Num_Classifier,k);
for fold = 1:1:k
    cnt = 1;
    for N = N_range
        for n = 1:1:N
            input_file = strcat(input_path,'cv',num2str(fold),'_estimated_label_',num2str(N),'_',num2str(n),'.mat');
            load(input_file);
            result_set(:,cnt,fold) = Pred;
            cnt = cnt + 1;
            clear Pred;
        end
    end
end
    
class_set = unique(GT);
voting_results = zeros(size(GT,1),k);
for fold = 1:1:k
    for i = 1:1:size(GT,1)
        V = [numel(find(result_set(i,:,fold)==class_set(1,1))),...
             numel(find(result_set(i,:,fold)==class_set(2,1))),...
             numel(find(result_set(i,:,fold)==class_set(3,1)))];
        [~, max_idx] = max(V);
        voting_results(i,fold) = max_idx;
    end
end

TPR = zeros(numel(class_set),k); % true positive rate
PPV = zeros(numel(class_set),k); % positive predictive value
F1  = zeros(numel(class_set),k);
macro_TPR = zeros(1,k);
macro_PPV = zeros(1,k);
macro_F1  = zeros(1,k);
acc = zeros(1,k);
for fold = 1:1:k
    Class = {1:1:3};
    Num_Class = length(Class{1});
    CF = zeros(Num_Class, Num_Class); % confusion matrix

    for i = 1:1:size(voting_results,1)
        CF(voting_results(i,fold),GT(i,1)) = CF(voting_results(i,fold),GT(i,1)) + 1;
    end
    
    TPR(:,fold) = [CF(1,1)/sum(CF(:,1)); CF(2,2)/sum(CF(:,2)); CF(3,3)/sum(CF(:,3))];
    PPV(:,fold) = [CF(1,1)/sum(CF(1,:)); CF(2,2)/sum(CF(2,:)); CF(3,3)/sum(CF(3,:))];
    F1(:,fold)  = [2*TPR(1,1)*PPV(1,1)/(TPR(1,1)+PPV(1,1));
                   2*TPR(2,1)*PPV(2,1)/(TPR(2,1)+PPV(2,1));
                   2*TPR(3,1)*PPV(3,1)/(TPR(3,1)+PPV(3,1))];

    macro_TPR(1,fold) = sum(TPR(:,fold))/3;
    macro_PPV(1,fold) = sum(PPV(:,fold))/3;
    macro_F1(1,fold)  = sum(F1(:,fold))/3;
    acc(1,fold) = (CF(1,1)+CF(2,2)+CF(3,3))/(sum(sum(CF)));
end

sum_macro_TPR = 0;
sum_macro_PPV = 0;
sum_macro_F1 = 0;
sum_acc = 0;
for fold = 1:1:k
    output_file = strcat(output_path,'results_fold',num2str(fold),'.txt');
    fileID = fopen(output_file,'w');
    
    fprintf(fileID,'TPR for class 1: %.4f\n',TPR(1,fold));
    fprintf(fileID,'TPR for class 2: %.4f\n',TPR(2,fold));
    fprintf(fileID,'TPR for class 3: %.4f\n',TPR(3,fold));
    
    fprintf(fileID,'PPV for class 1: %.4f\n',PPV(1,fold));
    fprintf(fileID,'PPV for class 2: %.4f\n',PPV(2,fold));
    fprintf(fileID,'PPV for class 3: %.4f\n',PPV(3,fold));
    
    fprintf(fileID,'F1 for class 1: %.4f\n',F1(1,fold));
    fprintf(fileID,'F1 for class 2: %.4f\n',F1(2,fold));
    fprintf(fileID,'F1 for class 3: %.4f\n',F1(3,fold));
    
    fprintf(fileID,'Macro-average TPR: %.4f\n',macro_TPR(1,fold));
    fprintf(fileID,'Macro-average PPV: %.4f\n',macro_PPV(1,fold));
    fprintf(fileID,'Macro-average F1: %.4f\n' ,macro_F1(1,fold));
    
    fprintf(fileID,'Accuracy: %.4f\n',acc(1,fold));
    
    sum_macro_TPR = sum_macro_TPR + macro_TPR(1,fold);
    sum_macro_PPV = sum_macro_PPV + macro_PPV(1,fold);
    sum_macro_F1  = sum_macro_F1  + macro_F1(1,fold);
    sum_acc = sum_acc + acc(1,fold);
    
    fclose(fileID);
end

output_file2 = strcat(output_path,'Average results.txt');
fileID = fopen(output_file2,'w');
fprintf(fileID,'Average performance of k-fold cross validation\n');
fprintf(fileID,'Average of Macro-average TPR: %.4f\n',sum_macro_TPR/k);
fprintf(fileID,'Average of Macro-average PPV: %.4f\n',sum_macro_PPV/k);
fprintf(fileID,'Average of Macro-average F1: %.4f\n',sum_macro_F1/k);
fprintf(fileID,'Average of Accuracy: %.4f\n',sum_acc/k);
fclose(fileID);