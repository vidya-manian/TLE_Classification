
% Data
path_train = 'C:\Users\vidyam\Desktop\TLE CNN\TLEs 7 Clases Data Training\Train_Set';
path_test  = 'C:\Users\vidyam\Desktop\TLE CNN\TLEs 7 Clases Data Training\Test_Set';
path_val = 'C:\Users\vidyam\Desktop\TLE CNN\TLEs 7 Clases Data Training\Val_Set';


imds_train = imageDatastore(path_train,'IncludeSubfolders',true,'LabelSource','foldernames'); 
imds_test  = imageDatastore(path_test,'IncludeSubfolders',true,'LabelSource','foldernames'); 
imds_val  = imageDatastore(path_val,'IncludeSubfolders',true,'LabelSource','foldernames'); 



%CNN Model
net = resnet18;
inputSize = net.Layers(1).InputSize;

%Replace Final Layers
lgraph = layerGraph(net);
[learnableLayer,classLayer] = findLayersandReplace(lgraph);
numClasses = numel(categories(imds_train.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

% ResNet adaptation for TLE classfication
lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

%Freeze Initial Layers
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:4) = freezeWeights(layers(1:4));
lgraph = createLgraphUsingConnections(layers,connections);


% Training
Train      = augmentedImageDatastore(inputSize(1:2),imds_train,'ColorPreprocessing','gray2rgb');
Val      = augmentedImageDatastore(inputSize(1:2),imds_val,'ColorPreprocessing','gray2rgb');



options = trainingOptions('adam', ...
    'MiniBatchSize',50, ...
    'MaxEpochs',15, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',Val, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');


[net,trainigInfo] = trainNetwork(Train,lgraph,options);


%Testing Images


[YPred,probs] = classify(net,Val);
numCorrect = nnz(YPred==imds_val.Labels);
fracCorrect = numCorrect/length(imds_val.Labels);
accuracy = mean(YPred == imds_val.Labels);


figure()
cm = confusionchart(imds_test.Labels,YPred);
cm.Title = "Matriz de Confusión ";
cm.ColumnSummary = "column-normalized";
cm.RowSummary = "row-normalized";


% Accuraccy test set
Test = augmentedImageDatastore(inputSize(1:2),imds_val,'ColorPreprocessing','gray2rgb');
[YPredTest, probsTest] = classify(net,Test);
accuracyTest = mean(YPredTest == imds_test.Labels);


figure()
cmTest = confusionchart(imds_test.Labels, YPredTest);
cmTest.Title = "Confusion Matrix: ResNet50";
cmTest.ColumnSummary = "column-normalized";
cmTest.RowSummary = "row-normalized";

idx = randperm(numel(imds_test.Files),7);
figure()
for i = 1:7
    subplot(4,2,i)
    I = readimage(imds_test,idx(i));
    imshow(I)
    label = YPredTest(idx(i));
    title(string(label) + ", " + num2str(100*max(probsTest(idx(i),:)),3) + "%");
end
