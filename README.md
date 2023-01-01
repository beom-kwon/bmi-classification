# Contents
1. [Introduction](Introduction)
2. [Requirements](Requirements)
3. [How to run](How-to-run)
4. [Citation](Citation)
5. [License](License)

# Introduction

In this web-page, we provide the MATLAB implementation of the ensemble model proposed in our paper "[Ensemble Learning for Skeleton-Based Body Mass Index Classification](https://doi.org/10.3390/app10217812)." In this study, we performed skeleton-based body mass index (BMI) classification by developing a unique ensemble learning method for human healthcare. Traditionally, anthropometric features, including the average length of each body part and average height, have been utilized for BMI classification. Average values are generally calculated for all frames because the length of body parts and the subject height vary over time, as a result of the inaccuracy in pose estimation. Thus, traditionally, anthropometric features are measured over a long period. In contrast, we controlled the window used to measure anthropometric features over short/mid/long-term periods. This approach enables our proposed ensemble model to obtain robust and accurate BMI classification results. To produce final results, the proposed ensemble model utilizes multiple k-nearest neighbors (k-NN) classifiers trained using anthropometric features measured over several different time periods.

# Requirements

The proposed ensemble model was implemented using MATLAB R2018a. To implement the ensemble model, we used the MATLAB function "fitcknn." To this end, we used the "Statistics and Machine Learning Toolbox." Therefore, if you want to run our code, you need to install MATLAB on your PC. In addition, you also need to install the "Statistics and Machine Learning Toolbox."

# How to run

## 1. Dataset Preparation

* We used the Kinect Gait Biometry Dataset - data from 164 individuals walking in front of a X-Box 360 Kinect Sensor.
* If you want to download this dataset, please click [here](https://www.researchgate.net/publication/275023745_Kinect_Gait_Biometry_Dataset_-_data_from_164_individuals_walking_in_front_of_a_X-Box_360_Kinect_Sensor). You can then find the download link.
* You also need to download the Gender and Body Mass Index (BMI) Data for the Kinect Gait Biometry Dataset.
* If you want to download this BMI data, please click [here](https://www.researchgate.net/publication/308929259_Gender_and_Body_Mass_Index_BMI_Data_for_Kinect_Gait_Biometry_Dataset_-_data_from_164_individuals_walking_in_front_of_a_X-Box_360_Kinect_Sensor). You can then find the download link.

## 2. Pre-processing

The Kinect Gait Biometry Dataset consists of 164 people in total. However, for only 112 people, both the body weight and heights information are provided. Therefore, we discarded the skeleton sequences of 52 people. As a result, the dataset contained 112 people with five skeleton sequences for each person. However, for one individual denoted as "Person158," only four sequences exist. To implement five-fold cross validation, we decided to eliminate this individual from the dataset. Additionally, there are six sequences for the following four individuals: "Person034," "Person036," "Person053," and "Person096." After examining the six sequences for each of these individuals, we discarded the noisiest sequence for each individual. As a result, the first sequence for "Person034," third sequence for "Person036," fifth sequence for "Person053," and sixth sequence for "Person096" were excluded from the dataset. As a result, the final dataset contained a total of 555 sequences (=111 people × 5 sequences per person).

## 3. Data Transformation (from .txt to .csv)

The skeleton sequences in the Kinect Gait Biometry Dataset are stored as text files (i.e., filename extension is .txt).
For ease of data handling, we transformed the data format of each sequence from .txt to .csv.
Run "step1_data_transformation_from_txt_to_csv.m."
After the m file is executed, you can obtain the csv version of each sequence.

## 4. Feature Extraction

In the ensemble model, anthropometric feature vectors are calculated as averages over long/mid/short-term periods.
Run "step2_feature_extraction.m."
After the m file is executed, you can obtain the anthropometric feature vectors.

## 5. k-fold Cross Validation

For assessing the performance of the proposed ensemble model, we used five-fold cross validation.
To this end, we split the feature vectors into a training dataset and a testing dataset.
In each cross validation fold, the 444 vectors were used for training the proposed model. 
The remaining 111 (=555 − 444) vectors were used for testing the model.
Run "step3_cross_validation.m."
After the m file is executed, you can obtain the training and testing datasets that are used in each cross validation fold.

## 6. Hyperparameter Optimization
The proposed ensemble model consists of multiple k-NN  classifiers.
To determine the optimal hyperparameter configuration for each k-NN classifier, we performed hyperparameter optimization using the MATLAB function "fitcknn."
Run "step4_hyperparameter_optimization.m."
After the m file is executed, you can obtain the trained k-NN classifiers.

## 7. BMI Label Estimation

We evaluated the ensemble model on the testing dataset.
Since the model consists of multiple k-NN classifiers, each k-NN classifier outputs the estimated BMI labels.
Run "step5_label_estimation.m."
After the m file is executed, you can obtain the estimated BMI labels of multiple k-NN classifiers.

## 8. Majority Voting

To derive a final classification result from the classification results of multiple k-NN classifiers, we used the majority voting algorithm.
In addition, we calculated confusion matrix using the voting results.
Then, based on the confusion matrix, we calculated true positive rate (TPR), positive predictive value (PPV), F1-score, and accuracy.
Run "step6_majority_voting.m."
After the m file is executed, you can find the k-fold cross validation results of the ensemble model.

# Citation

Please cite this paper in your publications if it helps your research.

```  
@article{kwon2020ensemble,
  title={Ensemble learning for skeleton-based body mass index classification},
  author={Kwon, Beom and Lee, Sanghoon},
  journal={Applied Sciences},
  volume={10},
  number={21},
  pages={7812},
  year={2020},
  publisher={MDPI}
}
```

Paper link:
* [Ensemble Learning for Skeleton-Based Body Mass Index Classification](https://doi.org/10.3390/app10217812)

# Lincense

Our codes are freely available for free non-commercial use.
