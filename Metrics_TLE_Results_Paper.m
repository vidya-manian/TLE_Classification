% GNet = 'GoogleNetTrained.mat';
% RNet18 = 'ResNet18Trained.mat';
% RNet50 = 'ResNet50Trained.mat';
% SNet = 'SqueezeNetTrained.mat';

clear all
clc

% Data de test
path_test  = 'C:\Users\RA-4-01\Documents\TLEs\TLE Full Classification\TLEs 7 Clases Data Training\Test_Set';
imds_test  = imageDatastore(path_test,'IncludeSubfolders',true,'LabelSource','foldernames'); 

% Red Entrenada
pathNet = 'C:\Users\RA-4-01\Documents\TLEs\TLE Full Classification\Results Matlab\ResNet50_TLEs_trained.mat';
netTrained = load(pathNet);
inputSize = netTrained.net.Layers(1).InputSize;

% Informacion del entrenamiento
% pathInfo = 'C:\Users\RA-4-01\Documents\TLEs\TLE Full Classification\Results Matlab SGDM\SqueezeNetTrained.mat';
% trainigInfo = load(pathInfo);


%*************Testing************** 
Test = augmentedImageDatastore(inputSize(1:2),imds_test,'ColorPreprocessing','gray2rgb');

%Metrics
[YPredTest, probsTest] = classify(netTrained.net,Test);
numCorrect = nnz(YPredTest==imds_test.Labels);
fracCorrect = numCorrect/length(imds_test.Labels);
accuracyTest = mean(YPredTest == imds_test.Labels);

% Confusion Matrix
figure()
cmTest = confusionchart(imds_test.Labels, YPredTest);
cmTest.Title = "Confusion Matrix: SNet";
cmTest.ColumnSummary = "column-normalized";
cmTest.RowSummary = "row-normalized";