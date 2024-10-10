# Contents
1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [How to Run](#how-to-run)
4. [Citation](#citation)
5. [License](#license)

# Introduction

In this web page, we provide the MATLAB implementation of the ensemble model proposed in our paper '[Ensemble Learning for Skeleton-Based Body Mass Index Classification](https://doi.org/10.3390/app10217812).' Additionally, we offer the Python implementation. If you wish to view the Python version, please click [here](https://github.com/beom-kwon/improving-bmi-classification-accuracy). In this study, we performed skeleton-based body mass index (BMI) classification by developing a unique ensemble learning method for human healthcare. Traditionally, anthropometric features, including the average length of each body part and average height, have been utilized for BMI classification. Average values are generally calculated for all frames because the length of body parts and the subject height vary over time, as a result of the inaccuracy in pose estimation. Thus, traditionally, anthropometric features are measured over a long period. In contrast, we controlled the window used to measure anthropometric features over short/mid/long-term periods. This approach enables our proposed ensemble model to obtain robust and accurate BMI classification results. To produce final results, the proposed ensemble model utilizes multiple k-nearest neighbors (k-NN) classifiers trained using anthropometric features measured over several different time periods.

# Requirements

The proposed ensemble model was implemented using MATLAB R2018a. To implement the ensemble model, we used the MATLAB function 'fitcknn.' To this end, we used the 'Statistics and Machine Learning Toolbox.' Therefore, if you want to run our code, you need to install MATLAB on your computer. In addition, you also need to install the 'Statistics and Machine Learning Toolbox.'

# How to Run

## 1. Dataset Preparation

* We used the Kinect Gait Biometry Dataset - data from 164 individuals walking in front of an Xbox 360 Kinect Sensor.
* If you want to download this dataset, please click [here](https://www.researchgate.net/publication/275023745_Kinect_Gait_Biometry_Dataset_-_data_from_164_individuals_walking_in_front_of_a_X-Box_360_Kinect_Sensor). You can then find the download link.
* You also need to download the Gender and Body Mass Index (BMI) Data for the Kinect Gait Biometry Dataset.
* If you want to download this BMI data, please click [here](https://www.researchgate.net/publication/308929259_Gender_and_Body_Mass_Index_BMI_Data_for_Kinect_Gait_Biometry_Dataset_-_data_from_164_individuals_walking_in_front_of_a_X-Box_360_Kinect_Sensor). You can then find the download link.

## 2. Preprocessing

The Kinect Gait Biometry Dataset consists of a total of 164 people. However, for only 112 of them, both the body weight and heights information are provided. Therefore, we excluded the skeleton sequences of 52 people, resulting in the dataset containing 112 people with five skeleton sequences each. However, for one individual, referred to as 'Person158,' only four sequences exist. To facilitate five-fold cross-validation, we decided to remove this individual from the dataset. Additionally, there are six sequences for the following four individuals: 'Person034,' 'Person036,' 'Person053,' and 'Person096.' After analyzing the six sequences for each of these individuals, we discarded the noisiest sequence for each person. Consequently, the first sequence for 'Person034,' the third sequence for 'Person036,' the fifth sequence for 'Person053,' and the sixth sequence for 'Person096' were excluded from the dataset. As a result, the final dataset comprised a total of 555 sequences (=111 people × 5 sequences per person).

## 3. Data Transformation (from .txt to .csv)

The skeleton sequences in the Kinect Gait Biometry Dataset are stored as text files with the filename extension .txt.
For ease of data handling, we converted the data format of each sequence from .txt to .csv.
Please run the script named 'step1_data_transformation_from_txt_to_csv.m.'
After executing the .m file, you will obtain the CSV version of each sequence.

## 4. Feature Extraction

In the ensemble model, anthropometric feature vectors are calculated as averages over long/mid/short-term periods.
Please run the script named 'step2_feature_extraction.m.'
After executing the .m file, you will obtain the anthropometric feature vectors.

## 5. k-Fold Cross-Validation

For assessing the performance of the proposed ensemble model, we used five-fold cross-validation.
To this end, we split the feature vectors into a training dataset and a testing dataset.
In each cross-validation fold, the 444 vectors were used for training the proposed model. 
The remaining 111 (=555 − 444) vectors were used for testing the model.
Please run the script named 'step3_cross_validation.m.'
After executing the .m file, you will obtain the training and testing datasets that are used in each cross-validation fold.

## 6. Hyperparameter Optimization
The proposed ensemble model consists of multiple k-NN classifiers.
To determine the optimal hyperparameter configuration for each k-NN classifier, we performed hyperparameter optimization using the MATLAB function 'fitcknn.'
Please run the script named 'step4_hyperparameter_optimization.m.'
After executing the .m file, you will obtain the trained k-NN classifiers.

## 7. BMI Label Estimation

We evaluated the ensemble model on the testing dataset.
Since the model consists of multiple k-NN classifiers, each k-NN classifier outputs estimated BMI labels.
Please run the script named 'step5_label_estimation.m.'
After executing the .m file, you will obtain the estimated BMI labels of multiple k-NN classifiers.

## 8. Majority Voting

To derive a final classification result from the outputs of multiple k-NN classifiers, we used the majority voting algorithm.
Additionally, we calculated the confusion matrix based on the voting results.
Using the confusion matrix, we calculated true positive rate (TPR), positive predictive value (PPV), F1-score, and accuracy.
Please run the script named 'step6_majority_voting.m.'
After executing the .m file, you will find the k-fold cross-validation results of the ensemble model.

# Citation

Please cite this paper in your publications if it helps your research.

```  
@article{kwon2020ensemble,
  author={Kwon, Beom and Lee, Sanghoon},
  journal={Applied Sciences},
  title={Ensemble Learning for Skeleton-Based Body Mass Index Classification},  
  year={2020},
  volume={10},
  number={21},
  pages={1--23},  
  doi={10.3390/app10217812}
}
```

Paper link:
* [Ensemble Learning for Skeleton-Based Body Mass Index Classification](https://doi.org/10.3390/app10217812)

# License

Our codes are freely available for non-commercial use.
