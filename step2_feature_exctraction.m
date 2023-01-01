close all;
clear;
clc;

num_joints = 20;
limb_info = [02,03;  % 01. shoulder right
             03,05;  % 02. arm right
             05,07;  % 03. forearm right
             07,09;  % 04. hand right
             12,13;  % 05. hip right
             13,15;  % 06. thigh right
             15,17;  % 07. leg right
             17,19;  % 08. foot right
             01,02;  % 09. neck
             02,11;  % 10. upper spine
             11,12;  % 11. lower spine
             02,04;  % 12. shoulder left
             04,06;  % 13. arm left
             06,08;  % 14. forearm left
             08,10;  % 15. hand left
             12,14;  % 16. hip left
             14,16;  % 17. thigh left
             16,18;  % 18. leg left
             18,20]; % 19. foot left

% If you run "step1_data_transformation_from_txt_to_csv.m,"
% csv files exist in ...\DB\kinect gait csv dataset.
% Please modify PATH for your environment.
dataset_path_in = strcat(pwd, '\DB\kinect gait csv dataset\');
dataset_path_out = strcat(pwd, '\DB\feature vector\');
if ~exist(dataset_path_out, 'dir')
    mkdir(dataset_path_out);
end

% We unzipped the BMI data at the folder "Gender BMI Data."
% In the BMI data zip file, there is "person-data.csv."
% In this csv file, the heights infromation for 164 people are listed.
% However, for only 112 people, both the body weight and heights information are provided. 
% For ease of data handling, we deleted the 52 rows corresponding 52 people in the
% csv file. In addition, we deleted columns D (Age), E (Gender), G (BackPack), 
% and H (HighHeels) in the csv file. Then, we saved the file.
bmi_info_path_in = strcat(pwd, '\DB\Gender BMI Data\person-data.csv');
BMI = importdata(bmi_info_path_in);

person_lists = dir(dataset_path_in);
p_max = length(person_lists);
% Each sequence is divided into N sub-sequences.
% After frame division process is executed, N sub-sequences are generated.
% Each sub-sequence is indicated by parameter n.
for N = 1:1:6
    for n = 1:1:N
        fprintf('%d / %d\n',n,N);
        cnt = 1;
        feature_vector = zeros(555, 21);
        % 555 = 111 people * 5 sequences per person
        % 21 = 20 features + 1 label
        for p = 3:1:p_max
            person_path_in = strcat(dataset_path_in, person_lists(p).name);

            bmi = BMI.data(p-2,3);
            if bmi < 18.5; label = 1;     % Underweight
            elseif bmi < 25.0; label = 2; % Normal weight
            else; label = 3;              % Obesity
            end

            walk_list = dir(person_path_in);
            w_max = length(walk_list);
            for w = 3:1:w_max
                file_path_in = strcat(person_path_in,'\',walk_list(w).name);
                motion = importdata(file_path_in);
                
                % Frame division
                if n == 1; frm_range = round(size(motion,1)*0/N)+1:1:round(size(motion,1)*1/N);
                elseif n == 2; frm_range = round(size(motion,1)*1/N)+1:1:round(size(motion,1)*2/N);
                elseif n == 3; frm_range = round(size(motion,1)*2/N)+1:1:round(size(motion,1)*3/N);
                elseif n == 4; frm_range = round(size(motion,1)*3/N)+1:1:round(size(motion,1)*4/N);
                elseif n == 5; frm_range = round(size(motion,1)*4/N)+1:1:round(size(motion,1)*5/N);
                elseif n == 6; frm_range = round(size(motion,1)*5/N)+1:1:round(size(motion,1)*6/N);
                end
                
                motion = motion(frm_range,:);
                limb_len = zeros(size(motion,1),size(limb_info,1));
                subj_height = zeros(size(motion,1),1);
                for frm = 1:1:size(motion,1)
                    pose = reshape(motion(frm,:),3,num_joints);
                    pose = pose';
                    
                    for i = 1:1:size(limb_info,1)
                        x = (pose(limb_info(i,1),1) - pose(limb_info(i,2),1))^2;
                        y = (pose(limb_info(i,1),2) - pose(limb_info(i,2),2))^2;
                        z = (pose(limb_info(i,1),3) - pose(limb_info(i,2),3))^2;
                        limb_len(frm,i) = sqrt(x + y + z);
                    end                    

                    % Calculate the height of subject
                    % height = neck + upper spine + lower spine 
                    %        + avg(right hip, left hip)
                    %        + avg(right thigh, left thigh)
                    %        + avg(right leg, left leg)
                    seg = zeros(1,6);
                    seg(1, 1) = limb_len(frm, 09); % neck
                    seg(1, 2) = limb_len(frm, 10); % upper_spine
                    seg(1, 3) = limb_len(frm, 11); % lower_spine
                    seg(1, 4) = (limb_len(frm, 05)+limb_len(frm, 16))/2; % average of hips
                    seg(1, 5) = (limb_len(frm, 06)+limb_len(frm, 17))/2; % average of thighs
                    seg(1, 6) = (limb_len(frm, 07)+limb_len(frm, 18))/2; % average of leg
                    subj_height(frm, 1) = sum(seg);
                end

                mean_limb_len = mean(limb_len);
                mean_subj_height = mean(subj_height);

                % 1) mean_limb_length : 19
                % 2) mean_subj_height : 1
                % 3) Nutritional Status label : 1
                feature = [mean_limb_len...
                           mean_subj_height];

                feature_vector(cnt,:) = [feature, label];
                cnt = cnt + 1;
            end
        end
        file_path_out = strcat(dataset_path_out,'feature_vector',num2str(N),'_',num2str(n),'.mat');
        save(file_path_out, 'feature_vector');
    end
end